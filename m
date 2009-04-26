Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbZDZVkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbZDZVkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 17:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZDZVj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 17:39:59 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:45911 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbZDZVj6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 17:39:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEFAINu9ElMQW1W/2dsb2JhbACBUMh+g3QF
Date: Sun, 26 Apr 2009 17:39:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, Jarek Poplawski <jarkao2@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       paulmck@linux.vnet.ibm.com, Evgeniy Polyakov <zbr@ioremap.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU recursive lock {XV}
Message-ID: <20090426213954.GA825@Krystal>
References: <20090421143927.52d7d89d@nehalam> <alpine.LFD.2.00.0904220821240.3101@localhost.localdomain> <20090423210938.1501507b@nehalam> <49F146FF.5050200@cosmosbay.com> <20090424091839.6e13ebec@nehalam> <49F22465.80305@gmail.com> <20090425133052.4cb711f5@nehalam> <49F4A6E3.7080102@cosmosbay.com> <20090426193135.GA30851@Krystal> <49F4CA55.8020705@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <49F4CA55.8020705@cosmosbay.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:27:50 up 57 days, 17:54,  2 users,  load average: 0.38, 0.39,
	0.35
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet (dada1@cosmosbay.com) wrote:
> Mathieu Desnoyers a écrit :
> > * Eric Dumazet (dada1@cosmosbay.com) wrote:
> >> From: Stephen Hemminger <shemminger@vyatta.com>
> >>
> >>> Epilogue due to master Jarek. Lockdep carest not about the locking
> >>> doth bestowed. Therefore no keys are needed.
> >>>
> >>> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >> So far, so good, should be ready for inclusion now, nobody complained :)
> >>
> >> I include the final patch, merge of your last two patches.
> >>
> >> David, could you please review it once again and apply it if it's OK ?
> >>
> > [...]
> >> +/*
> >> + * Per-CPU read/write lock associated with per-cpu table entries.
> >> + * This is not a general solution but makes reader locking fast since
> >> + * there is no shared variable to cause cache ping-pong; but adds an
> >> + * additional write-side penalty since update must lock all
> >> + * possible CPU's.
> >> + *
> >> + * Read lock is used by ip/arp/ip6 tables rule processing which runs per-cpu.
> >> + * It needs to ensure that the rules are not being changed while packet
> >> + * is being processed. In some cases, the read lock will be acquired
> >> + * twice on the same CPU; this is okay because read locks handle nesting.
> >> + *
> >> + * Write lock is used in two cases:
> >> + *    1. reading counter values
> >> + *       all readers need to be stopped and the per-CPU values are summed.
> >> + *
> >> + *    2. replacing tables
> >> + *       any readers that are using the old tables have to complete
> >> + *       before freeing the old table. This is handled by reading
> >> + *	  as a side effect of reading counters
> >> + */
> >> +DECLARE_PER_CPU(rwlock_t, xt_info_locks);
> >> +
> >> +static inline void xt_info_rdlock_bh(void)
> >> +{
> >> +	/*
> >> +	 * Note: can not use read_lock_bh(&__get_cpu_var(xt_info_locks))
> >> +	 * because need to ensure that preemption is disable before
> >> +	 * acquiring per-cpu-variable, so do it as a two step process
> >> +	 */
> >> +	local_bh_disable();
> > 
> > Why do you need to disable bottom halves on the read-side ? You could
> > probably just disable preemption, given this lock is nestable on the
> > read-side anyway. Or I'm missing something obvious ?
> 
> It may not be obvious, but subject already raised on this list, so I'll
> try to be as precise as possible (But may be wrong on some points, I'll
> let Patrick correct me if necessary)
> 
> ipt_do_table() is not a readonly function returning a verdict.
> 
> 1) It handles a stack (check how is used next->comefrom) that seems to
> be stored on rules themselves. (This is how I understand this code)
> This is safe as each cpu has its own copy of rules/counters, and BH protected.
> 
> 2) It also updates two 64 bit counters (bytes/packets) on each matched rule.
> 
> 3) Some netfilter matches/targets probably rely on the fact their handlers
> are run with BH disabled by their caller (ipt_do_table()/arp/ip6...)
> 
> These must be BH protected (and preempt disabled too), or else :
> 
> 1) A softirq could interrupt a process in the middle of ipt_do_table()
> and corrupt its "stack".
> 
> 2) A softirq could interrupt a process in ipt_do_table() in the middle
>  of the ADD_COUNTER(). Some counters could be corrupted.
> 
> 3) Some netfiler extensions would break.
> 
> Previous linux versions already used a read_lock_bh() here, on a single
> and shared rwlock, there is nothing new on this BH locking AFAIK.
> 
> Thank you

Thanks for the explanation. It might help to document the role of bh
disabling for the reader in a supplementary code comment, otherwise one
might think it's been put there to match the bottom half disabling used
on the write-side, which has the supplementary role of making sure bh
will not deadlock (and this precise behavior is not needed usually on
the read-side).

One more point :

 *    1. reading counter values
 *       all readers need to be stopped and the per-CPU values are summed.

Maybe it's just me, but this sentence does not seem to clearly indicate
that we have :

for_each_cpu()
  write lock()
  read data
  write unlock()

One might interpret it as :

for_each_cpu()
  write lock()

read data

for_each_cpu()
  write unlock()

Or maybe it's just my understanding of English that's not perfect.
Anyhow, rewording this sentence might not hurt. Something along the
lines of :

"reading counter values
 all readers are iteratively stopped to have their per-CPU values
 summed"

This is an important difference, as this behaves more like a RCU-based
mechanism than a global per-cpu read/write lock where all the write
locks would be taken at once.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
