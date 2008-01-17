Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbYAQWzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbYAQWzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762053AbYAQWvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:51:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761894AbYAQWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:51:33 -0500
Date: Thu, 17 Jan 2008 14:51:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.24-rc8-mm1: powerpc oopses
Message-Id: <20080117145105.ad968ea6.akpm@linux-foundation.org>
In-Reply-To: <200801172315.28129.m.kozlowski@tuxland.pl>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<200801172315.28129.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 23:15:27 +0100
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
>         The script below kills powerpc. oopses get longer and more
> wonderful with every next 'cated' file.

ppc32.

> /proc/<pid>/task/<pid>/pagemap seems to be the cause of oops. The
> important thing is that it oopses for random (that is not first in a row)
> process from /proc. So not every 'cat /proc/<pid>/task/<pid>/pagemap'
> causes an oops.
> 
> I could try to bisect this but this powerpc box is iMac G3 (cpu at 400MHz)
> and this will take time. So any hints appreciated.
> 
> Regards,
> 
> 	Mariusz
> 
> script:
> ---------
> #!/bin/bash
> 
> for i in `find /proc/*/ -readable -type f`; do
>         echo -n "cat $i > /dev/null ... ";
>         logger -t proc_loop $i;
>         sync;
>         cat $i > /dev/null;
>         echo "done";
> done
> ----------
> syslog:
> proc_loop: /proc/3731/task/3731/pagemap
> kernel: BUG: sleeping function called from invalid context at fs/proc/task_mmu.c:554
> kernel: in_atomic():1, irqs_disabled():0
> kernel: Call Trace:
> kernel: [cf1cddf0] [c000840c] show_stack+0x3c/0x194 (unreliable)
> kernel: [cf1cde20] [c002b2ec] __might_sleep+0xf4/0x108
> kernel: [cf1cde30] [c00d2d54] add_to_pagemap+0x40/0x11c
> kernel: [cf1cde50] [c00d2f44] pagemap_pte_range+0xa8/0x10c
> kernel: [cf1cde70] [c0081b30] walk_page_range+0x148/0x23c
> kernel: [cf1cdeb0] [c00d3104] pagemap_read+0x15c/0x244
> kernel: [cf1cdef0] [c0092144] vfs_read+0xc4/0x16c
> kernel: [cf1cdf10] [c009261c] sys_read+0x4c/0x90
> kernel: [cf1cdf40] [c001328c] ret_from_syscall+0x0/0x40

It's not really an oops - it's a warning.  add_to_pagemap() is doing a
put_user() inside pagemap_pte_range->pte_offset_map->kmap_atomic.

A known bug, I'm afraid.

How to fix?

- double-buffer the data to be copied to userspace or

- take a local copy of the pte page then work on that instead or

- play copy_to_user_inatomic() tricks.

It would be really nice to get the maps4 stuff merged this time around but
it is looking unlikely.

> kernel: --- Exception: c01 at 0xff5a364
> kernel:     LR = 0x10002f60
> kernel: BUG: scheduling while atomic: cat/8929/0x00000002
> kernel: Call Trace:
> kernel: [cf1cde90] [c000840c] show_stack+0x3c/0x194 (unreliable)
> kernel: [cf1cdec0] [c002db24] __schedule_bug+0x64/0x78
> kernel: [cf1cdee0] [c027207c] schedule+0x304/0x32c
> kernel: [cf1cdf40] [c0013a5c] recheck+0x0/0x28
> kernel: --- Exception: c01 at 0xff5a364
> kernel:     LR = 0x10002f60
> kernel: BUG: scheduling while atomic: cat/8929/0x00000007
> kernel: Call Trace:
> kernel: [cf1cde90] [c000840c] show_stack+0x3c/0x194 (unreliable)
> kernel: [cf1cdec0] [c002db24] __schedule_bug+0x64/0x78
> kernel: [cf1cdee0] [c027207c] schedule+0x304/0x32c
> kernel: [cf1cdf40] [c0013a5c] recheck+0x0/0x28
> kernel: --- Exception: c01 at 0xff5a364
> kernel:     LR = 0x10002f60
> kernel: BUG: scheduling while atomic: cat/8929/0x00000009
> kernel: Call Trace:
> kernel: [cf1cde90] [c000840c] show_stack+0x3c/0x194 (unreliable)
> kernel: [cf1cdec0] [c002db24] __schedule_bug+0x64/0x78
> kernel: [cf1cdee0] [c027207c] schedule+0x304/0x32c
> kernel: [cf1cdf40] [c0013a5c] recheck+0x0/0x28
> kernel: --- Exception: c01 at 0xff5a364
> kernel:     LR = 0x10002f60
> kernel: Page fault in user mode with in_atomic() = 1 mm = cf2765a0
> kernel: NIP = ff0cbc8  MSR = 4000f932
> kernel: Oops: Weird page fault, sig: 11 [#3]

hm.  Not sure how that happened.  The arch code thinks we're running in
user mode.

> kernel: PREEMPT PowerMac
> kernel: Modules linked in: usbhid ide_cd_mod ohci_hcd usbcore uninorth_agp agpgart
> kernel: NIP: 0ff0cbc8 LR: 0ff0d398 CTR: 0ff0d2d0
> kernel: REGS: cf1cdf50 TRAP: 0401   Tainted: G      D  (2.6.24-rc8-mm1)
> kernel: MSR: 4000f932 <EE,PR,FP,ME,IR,DR>  CR: 28022442  XER: 00000000
> kernel: TASK = cf8d74f0[8929] 'cat' THREAD: cf1cc000
> kernel: GPR00: 00000001 bf93e330 48029bf0 0ffed488 10016038 28022442 00000000 0ff5a364 
> kernel: GPR08: 0000f932 00000000 00001032 00000000 28022442 
> kernel: NIP [0ff0cbc8] 0xff0cbc8
> kernel: LR [0ff0d398] 0xff0d398
> proc_loop: /proc/3731/task/3731/wchan
> kernel: Call Trace:
> kernel: ---[ end trace 54bd1ed4883922c9 ]---
> kernel: note: cat[8929] exited with preempt_count 10
> proc_loop: /proc/3731/task/3731/oom_score
> proc_loop: /proc/3731/task/3731/oom_adj
> proc_loop: /proc/3731/fdinfo/0
> [... snip ...]
