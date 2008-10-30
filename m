Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYJ3FkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYJ3FkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYJ3Fjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:39:52 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:45386 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbYJ3Fjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:39:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkwFABflCElMQWao/2dsb2JhbACBdsp5g1E
Date: Thu, 30 Oct 2008 01:39:49 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracepoint: introduce *_noupdate APIs.
Message-ID: <20081030053949.GC27381@Krystal>
References: <49067E49.4040304@cn.fujitsu.com> <20081030053457.GB27381@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081030053457.GB27381@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:38:36 up 147 days, 10:19,  5 users,  load average: 0.30, 0.23,
	0.20
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > 
> > new APIs separate tracepoint_probe_register(),
> > tracepoint_probe_unregister() into 2 steps. The first step of them
> > is just update tracepoint_entry, not connect or disconnect.
> > 
> > this patch introduce tracepoint_probe_update_all() for update all.
> > 
> > these APIs are very useful for registering a lots of probes
> > but just update once only. and a very important thing is that
> > *_noupdate APIs do not require module_mutex.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> [...]
> 
> > +/**
> > + * tracepoint_probe_update_all -  update tracepoints
> > + */
> > +void tracepoint_probe_update_all(void)
> > +{
> > +	LIST_HEAD(release_probes);
> > +	struct tp_probes *pos, *next;
> > +
> > +	mutex_lock(&tracepoints_mutex);
> > +	if (!need_update) {
> > +		mutex_unlock(&tracepoints_mutex);
> > +		return;
> > +	}
> > +	if (!list_empty(&old_probes))
> > +		list_replace_init(&old_probes, &release_probes);
> > +	need_update = 0;
> > +	mutex_unlock(&tracepoints_mutex);
> > +
> > +	tracepoint_update_probes();
> 
> I think the read-side of this release_probes list should be protected by
> the tracepoints_mutex too. Two concurrent tracepoint_probe_update_all()
> could cause havoc here :
> 
> 
> mutex_lock(&tracepoints_mutex);
> 
> > +	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
> > +		list_del(&pos->u.list);
> > +		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
> > +	}
> 
> mutex_unlock(&tracepoints_mutex);
> 
> ?
> 
> The rest looks good.
> 

Argh, forget it. LIST_HEAD(release_probes); is local to the function,
there is nothing to protect here. My eyes thought they saw a "static"
here for some reason. Night shift....

The patch is good as-is.

Thanks !

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
