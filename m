Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYGIEZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYGIEZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYGIEZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:25:08 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:41976 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYGIEZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:25:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEABfVc0hMQWVt/2dsb2JhbACBXK8l
Date: Wed, 9 Jul 2008 00:25:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Hideo AOKI <haoki@redhat.com>,
       Takahiro Yasui <tyasui@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm] markers: avoid call_rcu_sched if old is NULL
Message-ID: <20080709042502.GA7062@Krystal>
References: <4873CE05.2030001@redhat.com> <20080709030200.GA4378@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080709030200.GA4378@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:09:42 up 34 days,  8:50,  3 users,  load average: 1.49, 1.33,
	1.25
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
> > Introduce marker_entry_free_old() and check old pointer is NULL before
> > setting call_rcu_sched(), because marker_entry_remove/add_probe() can
> > return NULL.
> > 
> 
> Hi Masami,
> 
> I doubt this is a bug per se, because kfree accepts NULL pointers (and
> kfree is the only action done on the oldptr by free_old_closure).
> 
> This cleans up the code, so I think it's good to merge your patch, but I
> would definitely not classify this as a bugfix.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 

Hrm, nope, finally there is a problem with your fix. Nack. Here is why :

Lets say we have two probes to connect on the marker, each with its own
private_data.

If we pass from 1 connected probe (probe A) to 2 (Probes A and B), and
then back to one (probe B), we want to make sure that readers
(instrumentation sites) will see coherent probes (matching callback and
private data). I remind you that 0 or 1 probes connected does not use an
array with the markers. Only if 2 to N probes are connected do we use an
array to store the callback and private data pairs. Therefore, special
care must be taken of the callback and private data update in the 1
probe connected case (when there are 0 probes connected, the private
data is not used and therefore we leave it as is at its old value).

However, because your cleanup actually removes the rcu_barrier() done
before the operation following the 2nd probe addition (the barrier is
only done if there are rcu calls pending), we can end up doing :

Probes
A
{A, B}
B

within a single RCU period, which means that a reader can see :

A
B

Those are "single probes" which involves updates of two pointers : the
callback and the private data. They must never be mixed within a single
rcu period : valid transitions go from 0 to 1, 1 to 2, 2 N and from N to
2, 2 to 1, 1 to 0. The modification you are doing here adds transitions
1 to 1 (as my example show) which should never happen.

Final reminder : this "special case" of 0 and 1 probes connected is done
to remove a pointer dereference and to minimize memory allocation in the
"common case" where only 1 probe is connected to a marker. It's not used
in the new tracepoint infrastructure because we have to iterate on the
callbacks in the instrumentation sites. The markers can do this in a
wrapper function, so we don't suffer from added instructions to every
call sites. So your cleanup makes sense for the tracepoint
infrastructure, but not for the markers.

Mathieu


> Mathieu
> 
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > ---
> >  kernel/marker.c |   29 ++++++++++++++---------------
> >  1 file changed, 14 insertions(+), 15 deletions(-)
> > 
> > Mathieu, I think this might be a bug. Tracepoint also has
> > same bug...
> > 
> > Index: 2.6.26-rc8-mm1/kernel/marker.c
> > ===================================================================
> > --- 2.6.26-rc8-mm1.orig/kernel/marker.c	2008-07-07 11:42:04.000000000 -0400
> > +++ 2.6.26-rc8-mm1/kernel/marker.c	2008-07-07 11:42:04.000000000 -0400
> > @@ -201,6 +201,17 @@ static void free_old_closure(struct rcu_
> >  	entry->rcu_pending = 0;
> >  }
> > 
> > +static void marker_entry_free_old(struct marker_entry *entry, void *old)
> > +{
> > +	if (!old)
> > +		return;
> > +	entry->oldptr = old;
> > +	entry->rcu_pending = 1;
> > +	/* write rcu_pending before calling the RCU callback */
> > +	smp_wmb();
> > +	call_rcu_sched(&entry->rcu, free_old_closure);
> > +}
> > +
> >  static void debug_print_probes(struct marker_entry *entry)
> >  {
> >  	int i;
> > @@ -666,11 +677,7 @@ int marker_probe_register(const char *na
> >  	mutex_lock(&markers_mutex);
> >  	entry = get_marker(name);
> >  	WARN_ON(!entry);
> > -	entry->oldptr = old;
> > -	entry->rcu_pending = 1;
> > -	/* write rcu_pending before calling the RCU callback */
> > -	smp_wmb();
> > -	call_rcu_sched(&entry->rcu, free_old_closure);
> > +	marker_entry_free_old(entry, old);
> >  end:
> >  	mutex_unlock(&markers_mutex);
> >  	return ret;
> > @@ -709,11 +716,7 @@ int marker_probe_unregister(const char *
> >  	entry = get_marker(name);
> >  	if (!entry)
> >  		goto end;
> > -	entry->oldptr = old;
> > -	entry->rcu_pending = 1;
> > -	/* write rcu_pending before calling the RCU callback */
> > -	smp_wmb();
> > -	call_rcu_sched(&entry->rcu, free_old_closure);
> > +	marker_entry_free_old(entry, old);
> >  	remove_marker(name);	/* Ignore busy error message */
> >  	ret = 0;
> >  end:
> > @@ -787,11 +790,7 @@ int marker_probe_unregister_private_data
> >  	mutex_lock(&markers_mutex);
> >  	entry = get_marker_from_private_data(probe, probe_private);
> >  	WARN_ON(!entry);
> > -	entry->oldptr = old;
> > -	entry->rcu_pending = 1;
> > -	/* write rcu_pending before calling the RCU callback */
> > -	smp_wmb();
> > -	call_rcu_sched(&entry->rcu, free_old_closure);
> > +	marker_entry_free_old(entry, old);
> >  	remove_marker(entry->name);	/* Ignore busy error message */
> >  end:
> >  	mutex_unlock(&markers_mutex);
> > -- 
> > Masami Hiramatsu
> > 
> > Software Engineer
> > Hitachi Computer Products (America) Inc.
> > Software Solutions Division
> > 
> > e-mail: mhiramat@redhat.com
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
