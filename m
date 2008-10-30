Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYJ3XOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYJ3XOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYJ3XOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:14:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44088 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbYJ3XOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:14:36 -0400
Date: Fri, 31 Oct 2008 00:14:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracepoint: introduce *_noupdate APIs.
Message-ID: <20081030231419.GA1985@elte.hu>
References: <49067E49.4040304@cn.fujitsu.com> <20081030053457.GB27381@Krystal> <20081030053949.GC27381@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030053949.GC27381@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > > 
> > > new APIs separate tracepoint_probe_register(),
> > > tracepoint_probe_unregister() into 2 steps. The first step of them
> > > is just update tracepoint_entry, not connect or disconnect.
> > > 
> > > this patch introduce tracepoint_probe_update_all() for update all.
> > > 
> > > these APIs are very useful for registering a lots of probes
> > > but just update once only. and a very important thing is that
> > > *_noupdate APIs do not require module_mutex.
> > > 
> > > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > [...]
> > 
> > > +/**
> > > + * tracepoint_probe_update_all -  update tracepoints
> > > + */
> > > +void tracepoint_probe_update_all(void)
> > > +{
> > > +	LIST_HEAD(release_probes);
> > > +	struct tp_probes *pos, *next;
> > > +
> > > +	mutex_lock(&tracepoints_mutex);
> > > +	if (!need_update) {
> > > +		mutex_unlock(&tracepoints_mutex);
> > > +		return;
> > > +	}
> > > +	if (!list_empty(&old_probes))
> > > +		list_replace_init(&old_probes, &release_probes);
> > > +	need_update = 0;
> > > +	mutex_unlock(&tracepoints_mutex);
> > > +
> > > +	tracepoint_update_probes();
> > 
> > I think the read-side of this release_probes list should be protected by
> > the tracepoints_mutex too. Two concurrent tracepoint_probe_update_all()
> > could cause havoc here :
> > 
> > 
> > mutex_lock(&tracepoints_mutex);
> > 
> > > +	list_for_each_entry_safe(pos, next, &release_probes, u.list) {
> > > +		list_del(&pos->u.list);
> > > +		call_rcu_sched(&pos->u.rcu, rcu_free_old_probes);
> > > +	}
> > 
> > mutex_unlock(&tracepoints_mutex);
> > 
> > ?
> > 
> > The rest looks good.
> > 
> 
> Argh, forget it. LIST_HEAD(release_probes); is local to the function,
> there is nothing to protect here. My eyes thought they saw a "static"
> here for some reason. Night shift....
> 
> The patch is good as-is.
> 
> Thanks !
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

ok, i've applied both patches to tip/tracing/tracepoints:

 57bc8ea: tracepoint: introduce *_noupdate APIs.
 bbec237: tracepoint: simplification for tracepoints using RCU

thanks!

(Note, i had to resolve conflicts, hopefully i got the end result 
right. Please double-check tip/master.)

	Ingo
