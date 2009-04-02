Return-Path: <linux-kernel-owner+w=401wt.eu-S1763138AbZDBVQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763138AbZDBVQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZDBVQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:16:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZDBVQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:16:24 -0400
Date: Thu, 2 Apr 2009 23:16:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>,
       Rusty Russell <rusty@rustcorp.com.au>, coreteam@netfilter.org
Subject: Re: [netfilter bug] BUG: using smp_processor_id() in preemptible
	[00000000] code: ssh/9115, caller is ipt_do_table+0xc8/0x559
Message-ID: <20090402211606.GC4076@elte.hu>
References: <20090402200128.GA21805@elte.hu> <49D51D86.9030906@cosmosbay.com> <20090402203220.GA30375@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090402203220.GA30375@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
> > David put into its tree fix for that a few hours ago
> > 
> > commit fa9a86ddc8ecd2830a5e773facc250f110300ae7
> > 
> > (netfilter: iptables: lock free counters) forgot to disable BH
> > in arpt_do_table(), ipt_do_table() and  ip6t_do_table()
> > 
> > Use rcu_read_lock_bh() instead of rcu_read_lock() cures the problem.
> 
> ok, got your fix (attached below), thanks Eric for the pointer.
> 
> But i think my fix might be slightly better, because it does not 
> manipulate the preempt counter and leaves preemption enabled.
> 
> There's no BH context worries since this code did not seem to have 
> BH protection before either. (it used a plain read_lock(), not 
> read_lock_bh(), AFAICS)
> 
> I dont see any preemption worries either. I must be missing 
> something :)

as per the other mail - what i missed was that the old code _did_ 
use read_lock_bh(), which did not get carried over into the 
rcu_read_lock().

So this fix affects basically all things netfilter, not just 
rcu-preempt - a plain rcu_read_lock() doesnt protect against BH 
context interaction.

	Ingo
