Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbZAGPYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbZAGPYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZAGPX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:23:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbZAGPXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:23:55 -0500
Date: Wed, 7 Jan 2009 16:23:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] stop_machine/cpu hotplug: fix disable_nonboot_cpus
Message-ID: <20090107152333.GC5771@elte.hu>
References: <4963F368.7080909@gmail.com> <84144f020901062248j5d406656wb21130d914c7749d@mail.gmail.com> <84144f020901070030k6fb888f6n84255078e4885d28@mail.gmail.com> <20090107091534.GA4633@osiris.boeblingen.de.ibm.com> <1231319946.14720.7.camel@penberg-laptop> <b6a2187b0901070336u1cb0bc94i1e47a68d8ea671c@mail.gmail.com> <20090107122728.GB4633@osiris.boeblingen.de.ibm.com> <b6a2187b0901070551r5bb86dbfye96c2c92e7b78087@mail.gmail.com> <20090107151946.GA25560@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107151946.GA25560@osiris.boeblingen.de.ibm.com>
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


* Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> disable_nonboot_cpus calls _cpu_down. But _cpu_down requires that the 
> caller already created the stop_machine workqueue (like cpu_down does). 
> Otherwise a call to stop_machine will lead to accesses to random memory 
> regions.

btw., i got this crash earlier today:

CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
eth0: no IPv6 routers present
BUG: Bad page state in process cc1  pfn:00879
page:c101b894 flags:00000400 count:0 mapcount:0 mapping:(null) index:0
Pid: 3060, comm: cc1 Not tainted 2.6.28-tip-07641-gb97d41d-dirty #14985
Call Trace:
 [<c016ce8b>] bad_page+0xcf/0xe5
 [<c016d3b4>] free_pages_check+0xa7/0xc5
 [<c016d400>] free_hot_cold_page+0x2e/0x138
 [<c014751c>] ? __lock_acquire+0x127/0x29d
 [<c016d558>] free_hot_page+0xf/0x11
 [<c0170963>] put_page+0x76/0x7c
 [<c0185071>] ? constant_test_bit+0x9/0x20
 [<c0187149>] kfree+0x30/0xe5
 [<c0164993>] ? trace_hardirqs_on+0x8/0x1c
 [<c01547dd>] free_user_ns+0x1d/0x20
 [<c01547c0>] ? free_user_ns+0x0/0x20
 [<c02c7a41>] kref_put+0x18/0x22
 [<c0132d4c>] put_user_ns+0x16/0x18
 [<c0132f52>] free_uid+0x59/0xc8
 [<c0136239>] ? groups_free+0x36/0x3a
 [<c0140406>] put_cred_rcu+0x5f/0x70
 [<c01598fb>] __rcu_process_callbacks+0x168/0x1f8
 [<c03031be>] ? isicom_tx+0x0/0x31f
 [<c01599b1>] rcu_process_callbacks+0x26/0x46
 [<c012f11d>] __do_softirq+0x9d/0x139
 [<c012f080>] ? __do_softirq+0x0/0x139
 <IRQ>  [<c012efe2>] ? irq_exit+0x4c/0x83
 [<c05cc586>] ? __irqentry_text_start+0x6e/0x7c
 [<c0103f61>] ? apic_timer_interrupt+0x2d/0x34

and i applied your patch (from the other thread) and never saw this bug 
again.

So if it's the same bug (it appears to be) then you have my:

Tested-by: Ingo Molnar <mingo@elte.hu>


	Ingo
