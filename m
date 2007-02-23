Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbXBWKPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbXBWKPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 05:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbXBWKPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 05:15:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbXBWKPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 05:15:23 -0500
Date: Fri, 23 Feb 2007 11:10:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>,
       tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
Message-ID: <20070223101025.GA21127@elte.hu>
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com> <1172008584.25076.0.camel@localhost.localdomain> <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com> <1172072023.25076.64.camel@localhost.localdomain> <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com> <1172088044.25076.125.camel@localhost.localdomain> <45DCF644.9040009@googlemail.com> <45DD756D.3040006@googlemail.com> <20070223060802.GA8562@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223060802.GA8562@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.3 required=5.9 tests=ALL_TRUSTED,BAYES_50,PLING_QUERY autolearn=no SpamAssassin version=3.1.7
	0.5 PLING_QUERY            Subject has exclamation mark and question mark
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4987]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> could you please try the patch below? This is pretty much the only 
> condition under which we can silently 'leak' pending softirqs, and 
> trigger the new warning: if something does cond_resched_softirq() in 
> non-runnable state. (which is a no-no, but nothing enforced this, so 
> it could in theory happen.) So the question is, with this patch 
> applied, do you get these new warnings from sched.c?

it just triggered on one of my boxes:

BUG: at kernel/sched.c:4692 cond_resched_softirq()
 [<c03ce128>] cond_resched_softirq+0x5f/0x7b
 [<c0369078>] release_sock+0x42/0x81
 [<c03693bc>] sk_wait_data+0x57/0x9d
 [<c0129a00>] autoremove_wake_function+0x0/0x33
 [<c03942ff>] tcp_recvmsg+0x39c/0x973
 [<c0368e39>] sock_common_recvmsg+0x3e/0x54
 [<c0367903>] sock_aio_read+0x106/0x112
 [<c0159b0c>] do_sync_read+0xc8/0x105
 [<c0129a00>] autoremove_wake_function+0x0/0x33
 [<c0159e82>] vfs_read+0xc1/0x15a
 [<c015a7d2>] sys_read+0x41/0x67
 [<c0103c10>] syscall_call+0x7/0xb
 =======================

so tcp_recvmsg() definitely gets into this condition.

	Ingo
