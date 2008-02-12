Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYBLH7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYBLH7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbYBLH6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:58:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33197 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbYBLH6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:58:52 -0500
Date: Tue, 12 Feb 2008 08:58:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] 2.6.25-rc1-git1 softlockup while bootup on powerpc
Message-ID: <20080212075812.GC11775@elte.hu>
References: <47B1463E.1070809@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B1463E.1070809@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> While booting with the 2.6.25-rc1-git1 kernel on the powerbox the 
> softlockup is seen, with following trace.

> BUG: soft lockup - CPU#1 stuck for 61s! [insmod:377]
> TASK = c00000077cb2f0e0[377] 'insmod' THREAD: c00000077cb28000 CPU: 1
> NIP [c0000000001b172c] .radix_tree_gang_lookup+0xdc/0x1e4
> LR [c0000000001a6f00] .call_for_each_cic+0x50/0x10c
> Call Trace:
> [c00000077cb2bb20] [c0000000001a6f60] .call_for_each_cic+0xb0/0x10c (unreliable)
> [c00000077cb2bc60] [c00000000019ecd8] .exit_io_context+0xf0/0x110
> [c00000077cb2bcf0] [c00000000006254c] .do_exit+0x820/0x850
> [c00000077cb2bda0] [c000000000062648] .do_group_exit+0xcc/0xe8
> [c00000077cb2be30] [c00000000000872c] syscall_exit+0x0/0x40

this call_for_each_cic/radix_tree_gang_lookup locked up, and all other 
CPUs deadlocked in stopmachine, due to this one.

call_for_each_cic is in ./block/cfq-iosched.c uses RCU, but you've got 
classic-RCU:

  CONFIG_CLASSIC_RCU=y
  # CONFIG_PREEMPT_RCU is not set

so it's not related to the preempt-RCU changes either.

It is this part that locks up:

        do {
...
                nr = radix_tree_gang_lookup(&ioc->radix_root, (void **) cics,
                                                index, CIC_GANG_NR);
...
        } while (nr == CIC_GANG_NR);
...

it seems the radix tree will yield new entries again and again. Either 
it got corrupted, or some other CPU is filling it faster than we can 
deplete it [unlikely i think].

	Ingo
