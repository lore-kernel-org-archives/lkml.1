Return-Path: <linux-kernel-owner+w=401wt.eu-S947089AbXHMOkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S947089AbXHMOkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971202AbXHMLm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:42:56 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:40244 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S971445AbXHMLmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:42:52 -0400
Date: Mon, 13 Aug 2007 13:42:37 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:379
 smp_call_function_single()
Message-ID: <20070813134237.23f4b5a1@localhost>
In-Reply-To: <6bffcb0e0708100504n7fbafb5bt6a35165277dc767a@mail.gmail.com>
References: <20070810134140.2806b587@localhost>
	<6bffcb0e0708100504n7fbafb5bt6a35165277dc767a@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 14:04:33 +0200
"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> > [  756.707601] Disabling non-boot CPUs ...
> > [  756.712034] kvm: disabling virtualization on CPU1
> > [  756.712037] WARNING: at arch/x86_64/kernel/smp.c:379 smp_call_function_single()
> > [  756.712039]
> > [  756.712039] Call Trace:
> > [  756.712046]  [<ffffffff8021d159>] smp_call_function_single+0x119/0x120
> > [  756.712050]  [<ffffffff80542169>] thread_return+0x1bf/0x626
> > [  756.712054]  [<ffffffff80234b5b>] sys_sched_yield+0x2b/0x80
> > [  756.712057]  [<ffffffff8043684b>] kvm_cpu_hotplug+0x4b/0xa0
> > [  756.712060]  [<ffffffff80247c83>] notifier_call_chain+0x53/0x80
> > [  756.712062]  [<ffffffff80247d09>] __raw_notifier_call_chain+0x9/0x10
> > [  756.712065]  [<ffffffff80247d21>] raw_notifier_call_chain+0x11/0x20
> > [  756.712068]  [<ffffffff8026184b>] take_cpu_down+0x1b/0x30
> > [  756.712071]  [<ffffffff802699d2>] do_stop+0xd2/0x150
> > [  756.712073]  [<ffffffff80269900>] do_stop+0x0/0x150
> > [  756.712076]  [<ffffffff8024f84d>] kthread+0x4d/0x80
> > [  756.712079]  [<ffffffff8020cb28>] child_rip+0xa/0x12
> > [  756.712081]  [<ffffffff8020c23c>] restore_args+0x0/0x30
> > [  756.712084]  [<ffffffff8024f800>] kthread+0x0/0x80
> > [  756.712086]  [<ffffffff8020cb1e>] child_rip+0x0/0x12
> > [  756.712087]
> > [  756.815693] CPU 1 is now offline
> > [  756.815697] lockdep: not fixing up alternatives.
> > [  756.819276] CPU1 is down
> >  
> 
> Added to KR list, thanks for the report.


I've bisected it down to this commit:

cec9ad279b66793bee0b5009b7ca311060061efd

    KVM: Use CPU_DYING for disabling virtualization
    
    Only at the CPU_DYING stage can we be sure that no user process will
    be scheduled onto the cpu and oops when trying to use virtualization
    extensions.


$ git-bisect log

git-bisect start
# bad: [f695baf2df9e0413d3521661070103711545207a] Linux 2.6.23-rc1
git-bisect bad f695baf2df9e0413d3521661070103711545207a
# good: [7dcca30a32aadb0520417521b0c44f42d09fe05c] Linux 2.6.22
git-bisect good 7dcca30a32aadb0520417521b0c44f42d09fe05c
# good: [1f1c2881f673671539b25686df463518d69c4649] Merge branch 'upstream-linus' of master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6
git-bisect good 1f1c2881f673671539b25686df463518d69c4649
# bad: [3cf01f28c303be34f18cb4f6204cf1bdfe12ba7c] coda: remove statistics counters from /proc/fs/coda
git-bisect bad 3cf01f28c303be34f18cb4f6204cf1bdfe12ba7c
# bad: [b8c638acacfe32c0bde361916467af00691f1965] Merge branch 'uninit-var' of master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6
git-bisect bad b8c638acacfe32c0bde361916467af00691f1965
# good: [c06e677aed0c86480b01faa894967daa8aa3568a] SPI: add 3wire mode flag
git-bisect good c06e677aed0c86480b01faa894967daa8aa3568a
# good: [90da63e54604fd515c17014a0a7f332a018a0a11] fbdev: extract fb_show_logo_line()
git-bisect good 90da63e54604fd515c17014a0a7f332a018a0a11
# good: [e495606dd09d79f9fa496334ac3958f6ff179d82] KVM: Clean up #includes
git-bisect good e495606dd09d79f9fa496334ac3958f6ff179d82
# good: [27d41718157626e4509026c7dac247a659c0e71f] mark a bunch of ISA|EISA|PCI drivers as such
git-bisect good 27d41718157626e4509026c7dac247a659c0e71f
# bad: [3bd858ab1c451725c07a805dcb315215dc85b86e] Introduce is_owner_or_cap() to wrap CAP_FOWNER use with fsuid check
git-bisect bad 3bd858ab1c451725c07a805dcb315215dc85b86e
# bad: [cec9ad279b66793bee0b5009b7ca311060061efd] KVM: Use CPU_DYING for disabling virtualization
git-bisect bad cec9ad279b66793bee0b5009b7ca311060061efd
# good: [4055551bbcb0d0be8c916134b4e9074826e89638] x86_64: Allow smp_call_function_single() to current cpu
git-bisect good 4055551bbcb0d0be8c916134b4e9074826e89638
# good: [a52b1752c077cb919b71167c54968a0b91673281] SMP: Allow smp_call_function_single() to current cpu
git-bisect good a52b1752c077cb919b71167c54968a0b91673281
# good: [4267c41a458cd7d287dc8031468fc385c2f5b2c3] KVM: Tune hotplug/suspend IPIs
git-bisect good 4267c41a458cd7d287dc8031468fc385c2f5b2c3

-- 
	Paolo Ornati
	Linux 2.6.23-rc3 on x86_64
