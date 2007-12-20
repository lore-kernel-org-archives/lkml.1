Return-Path: <linux-kernel-owner+w=401wt.eu-S1765817AbXLTOlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765817AbXLTOlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:41:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764627AbXLTOft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:35:49 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:59844 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764613AbXLTOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:35:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJ4MakdMROHU/2dsb2JhbACBV6hD
Date: Thu, 20 Dec 2007 09:25:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com
Subject: Re: [patch 1/2] Linux Kernel Markers - Support Multiple Probes
Message-ID: <20071220142540.GB22523@Krystal>
References: <20071204181845.895090222@polymtl.ca> <20071204182402.940135178@polymtl.ca> <20071204110648.dd918789.akpm@linux-foundation.org> <20071204192100.GB31752@Krystal> <20071204113954.c1dc9d87.akpm@linux-foundation.org> <20071204194506.GA1431@Krystal> <20071217174023.GA4829@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071217174023.GA4829@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:19:09 up 46 days, 19:24,  4 users,  load average: 1.16, 0.67,
	0.85
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Tue, Dec 04, 2007 at 02:45:06PM -0500, Mathieu Desnoyers wrote:
> > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > On Tue, 4 Dec 2007 14:21:00 -0500
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > > > + */
> > > > > > +void marker_probe_cb(const struct marker *mdata, void *call_private,
> > > > > > +	const char *fmt, ...)
> > > > > > +{
> > > > > > +	va_list args;
> > > > > > +	char ptype;
> > > > > > +
> > > > > > +	preempt_disable();
> > > > > 
> > > > > What are the preempt_disable()s doing in here?
> > > > > 
> > > > > Unless I missed something obvious, a comment is needed here (at least).
> > > > > 
> > > > 
> > > > They make sure the teardown of the callbacks can be done correctly when
> > > > they are in modules and they insure RCU read coherency. Will add
> > > > comment.
> > > 
> > > So shouldn't it be using rcu_read_lock()?  If that does not suit, should we
> > > be adding new rcu primitives rather than open-coding and adding dependencies?
> > 
> > Hrm, yes, good point. Since there seems to be extra magic under
> > __acquire(RCU);  and  rcu_read_acquire();, the the fact that I use
> > rcu_barrier() for synchronization, we should. I'll change it.
> 
> (Sorry to show up so late...  It has been a bit crazy of late...)
> 
> The __acquire(RCU) and rcu_read_acquire() are strictly for the benefit
> of sparse -- they allow it to detect mismatched rcu_read_lock() and
> rcu_read_unlock() pairs.  (Restricted to a single function, but so
> it goes.)
> 
> I don't claim to fully understand this code, so may be way off base.
> However, it looks like you are relying on stop_machine(), which in
> turn interacts with preempt_disable(), but -not- necessarily with
> rcu_read_lock().  Now, your rcu_barrier() call -does- interact with
> rcu_read_lock() correctly, but either you need the preempt_disable()s
> to interact correctly with stop_machine(), or you need to update the
> comments calling out dependency on stop_machine().
> 
> Or it might be that the RCU API needs a bit of expanding.  For example,
> if you absolutely must use call_rcu(), and you also must absolutely
> rely on stop_machine(), this might indicate that we need to add a
> call_rcu_sched() as an asynchronous counterpart to synchronize_sched().
> This would also require an rcu_sched_barrier() as well, to allow safe
> unloading of modules using call_rcu_sched().
> 
> Or am I missing something?
> 

Hi Paul,

Sorry about the late response; I was away for small vacation :)

Yes, I need both :

- disabling preemption at marker site is required to protect against
  deletion of probe code when modules are unloaded.
- I use the call_rcu() to execute delayed free of my data structures. I
  could do all that synchronously with synchronize_sched(), but batch
  registration/unregistration would be just too slow. I don't want to
  take a few minutes to activate ~100 probes, that would be insane.

So yes, adding the new piece of API sounds like a good idea. Meanwhile,
I guess I could just do this in the code executed around probe call,
although it has a performance impact :

  rcu_read_lock();
  preempt_disable();

  probe_call();

  preempt_enable();
  rcu_read_unlock();

Thanks very much for the review,

Mathieu


> 							Thanx, Paul

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
