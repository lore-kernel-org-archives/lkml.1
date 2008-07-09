Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYGIDDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYGIDDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 23:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYGIDDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 23:03:33 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:58947 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751161AbYGIDDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 23:03:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAE7Hc0hMQWVt/2dsb2JhbACBXK8x
Date: Tue, 8 Jul 2008 23:03:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC patch 01/12] Kernel Tracepoints
Message-ID: <20080709030330.GB4378@Krystal>
References: <20080704235207.147809973@polymtl.ca> <20080704235423.789031024@polymtl.ca> <487243EC.1010704@redhat.com> <4873D019.4090504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4873D019.4090504@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:02:34 up 34 days,  7:43,  4 users,  load average: 2.17, 1.69,
	1.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi Mathieu,
> 
> Masami Hiramatsu wrote:
> [...]
> >> +int tracepoint_probe_register(const char *name, void *probe)
> >> +{
> >> +	struct tracepoint_entry *entry;
> >> +	int ret = 0;
> >> +	void *old;
> >> +
> >> +	mutex_lock(&tracepoints_mutex);
> >> +	entry = get_tracepoint(name);
> >> +	if (!entry) {
> >> +		entry = add_tracepoint(name);
> >> +		if (IS_ERR(entry)) {
> >> +			ret = PTR_ERR(entry);
> >> +			goto end;
> >> +		}
> >> +	}
> >> +	/*
> >> +	 * If we detect that a call_rcu is pending for this tracepoint,
> >> +	 * make sure it's executed now.
> >> +	 */
> >> +	if (entry->rcu_pending)
> >> +		rcu_barrier();
> >> +	old = tracepoint_entry_add_probe(entry, probe);
> >> +	if (IS_ERR(old)) {
> >> +		ret = PTR_ERR(old);
> >> +		goto end;
> >> +	}
> >> +	mutex_unlock(&tracepoints_mutex);
> >> +	tracepoint_update_probes();		/* may update entry */
> >> +	mutex_lock(&tracepoints_mutex);
> >> +	entry = get_tracepoint(name);
> >> +	WARN_ON(!entry);
> 
> As I said in another patch, you might have to check
> old != NULL here, because tracepoint_entry_add_probe() will
> return NULL when you add a first probe to the entry.
> 
> >> +	entry->oldptr = old;
> >> +	entry->rcu_pending = 1;
> >> +	/* write rcu_pending before calling the RCU callback */
> >> +	smp_wmb();
> >> +#ifdef CONFIG_PREEMPT_RCU
> >> +	synchronize_sched();	/* Until we have the call_rcu_sched() */
> >> +#endif
> >> +	call_rcu(&entry->rcu, free_old_closure);
> >> +end:
> >> +	mutex_unlock(&tracepoints_mutex);
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(tracepoint_probe_register);
> >> +
> >> +/**
> >> + * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
> >> + * @name: tracepoint name
> >> + * @probe: probe function pointer
> >> + *
> >> + * We do not need to call a synchronize_sched to make sure the probes have
> >> + * finished running before doing a module unload, because the module unload
> >> + * itself uses stop_machine(), which insures that every preempt disabled section
> >> + * have finished.
> >> + */
> >> +int tracepoint_probe_unregister(const char *name, void *probe)
> >> +{
> >> +	struct tracepoint_entry *entry;
> >> +	void *old;
> >> +	int ret = -ENOENT;
> >> +
> >> +	mutex_lock(&tracepoints_mutex);
> >> +	entry = get_tracepoint(name);
> >> +	if (!entry)
> >> +		goto end;
> >> +	if (entry->rcu_pending)
> >> +		rcu_barrier();
> >> +	old = tracepoint_entry_remove_probe(entry, probe);
> >> +	mutex_unlock(&tracepoints_mutex);
> >> +	tracepoint_update_probes();		/* may update entry */
> >> +	mutex_lock(&tracepoints_mutex);
> >> +	entry = get_tracepoint(name);
> >> +	if (!entry)
> >> +		goto end;
> >> +	entry->oldptr = old;
> >> +	entry->rcu_pending = 1;
> >> +	/* write rcu_pending before calling the RCU callback */
> >> +	smp_wmb();
> >> +#ifdef CONFIG_PREEMPT_RCU
> >> +	synchronize_sched();	/* Until we have the call_rcu_sched() */
> >> +#endif
> >> +	call_rcu(&entry->rcu, free_old_closure);
> >> +	remove_tracepoint(name);	/* Ignore busy error message */
> >> +	ret = 0;
> >> +end:
> >> +	mutex_unlock(&tracepoints_mutex);
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(tracepoint_probe_unregister);
> >> +
> 
> On the other hand, tracepoint_entry_remove_probe() doesn't return NULL,
> however, I think it might be better to introduce tracepoint_entry_free_old()
> and simplify both of tracepoint_probe_register/unregister.
> 

Yes, the cleanup makes sense and removes an unnecessary call to call_rcu
(which in fact simply kfree a NULL pointer, which is pointless). I'll
integrate this change.

Thanks,

Mathieu

> Thank you,
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
