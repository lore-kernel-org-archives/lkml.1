Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYDNPVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYDNPVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYDNPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:21:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52242 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbYDNPVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:21:46 -0400
Date: Mon, 14 Apr 2008 17:21:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: "Denis V. Lunev" <den@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
Message-ID: <20080414152135.GA17313@elte.hu>
References: <200804141547.57719.vda.linux@googlemail.com> <1208182649.7688.7.camel@iris.sw.ru> <200804141654.22513.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804141654.22513.vda.linux@googlemail.com>
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


* Denys Vlasenko <vda.linux@googlemail.com> wrote:

> But do you really need 4k to remember that "this thread went to sleep 
> by executing sleep(60)"? Theoretically, you may get away with much 
> smaller save area to remember that, and be able to wake up and return 
> to userspace.

there are three major issues.

1) the kernel stack is not just about "this thread went to sleep", it 
also contains all the call frames up to the point that schedules. That 
might be quite complex, such as:

 [<c0127c56>] kmap+0x45/0x48
 [<c0178e53>] unmap_vmas+0x57e/0x5f2
 [<c017c41c>] exit_mmap+0x8d/0x112
 [<c0131b2e>] mmput+0x35/0x7d
 [<c01355eb>] exit_mm+0xf5/0xfa
 [<c0136389>] do_exit+0x1ee/0x7a0
 [<c01067f2>] die+0x1f9/0x201
 [<c124a5be>] do_trap+0x9a/0xb2
 [<c0106bc1>] do_invalid_op+0x97/0xa1
 [<c124a28c>] error_code+0x7c/0x84
 [<c0492d21>] plist_del+0x34/0x65
 [<c0155034>] task_blocks_on_rt_mutex+0x14e/0x1b7
 [<c12488c5>] rt_mutex_slowlock+0x13d/0x236
 [<c1248596>] rt_mutex_lock_interruptible+0x2a/0x2f
 [<c1248f20>] _mutex_lock_interruptible+0x37/0x55
 [<c0574325>] tty_write+0x88/0x1d3
 [<c018cb05>] vfs_write+0xb1/0x165
 [<c018d2fc>] sys_write+0x40/0x67
 [<c01050e0>] syscall_call+0x7/0xb

we cannot throw that away or save it differently - it would be way too 
expensive.

2) another issue is that 4K of memory per task isnt all that large. 
Tasks tend to have much larger footprint in other areas: inodes, 
dentries, kmalloc's, open files, sockets, etc. etc. Any task that does 
something interesting will have a lot more than just 4K memory of 
footprint.

3) for runnable tasks a kernel stack is needed in every moment, because 
whenever the CPU enters IRQ handling or fault/exception handling, it 
will switch to a privileged stack. In theory we could have per CPU 
privileged stacks (and even have it for certain types of kernel-only 
exceptions), but especially because faults and even irqs can trigger 
scheduling, it's quite convenient to use the kernel stack as the 
privileged stack too.

	Ingo
