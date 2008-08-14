Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbYHNTdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbYHNTdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYHNTdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:33:43 -0400
Received: from gw.goop.org ([64.81.55.164]:40282 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbYHNTdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:33:42 -0400
Message-ID: <48A48879.2000309@goop.org>
Date: Thu, 14 Aug 2008 12:33:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
References: <1218697362.26014.9.camel@localhost.localdomain> <Pine.LNX.4.64.0808141347480.11013@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808141347480.11013@blonde.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> In both cases it's handling a page fault: I'm curious as to what kind
> of vma this fault is occurring on.  Could you devise a way of getting
> us /proc/<pid>/maps output, together with the faulting address, when
> it hits one of these BUGs?  Or should I try to put together a patch
> for that?

It's a /dev/fb0 mapping:

open("/dev/fb0", O_RDWR)                = 8
...
mmap(NULL, 2097152, PROT_READ|PROT_WRITE, MAP_SHARED, 8, 0) = 0x7fed69a08000

The fault is 1 page into this mapping:

WARNING: at /home/jeremy/hg/xen/paravirt/linux/fs/buffer.c:711 __set_page_dirty+0x7e/0x113()
Modules linked in: xen_fbfront fb fb_sys_fops sysimgblt sysfillrect xen_netfront syscopyarea xen_kbdfront xen_blkfront
Pid: 1357, comm: X Not tainted 2.6.27-rc2-tip #337

Call Trace:
 [<ffffffff802346be>] warn_on_slowpath+0x5d/0x84
 [<ffffffff8024a55d>] ? hrtimer_start+0x118/0x13a
 [<ffffffff8024a728>] ? ktime_get_ts+0x4e/0x53
 [<ffffffff8022c590>] ? hrtick_start_fair+0x11b/0x152
 [<ffffffff803ce686>] ? _spin_lock_irqsave+0x2a/0x33
 [<ffffffff8023d87e>] ? lock_timer_base+0x2b/0x4f
 [<ffffffff803ce6ac>] ? _spin_unlock_irqrestore+0x1d/0x21
 [<ffffffff802af7d3>] __set_page_dirty+0x7e/0x113
 [<ffffffff802b19e1>] __set_page_dirty_buffers+0x84/0x89
 [<ffffffff8026c876>] set_page_dirty+0x46/0xb2
 [<ffffffff8026d9a1>] set_page_dirty_balance+0x17/0x4d
 [<ffffffff80274817>] __do_fault+0x494/0x4ae
 [<ffffffff803cccff>] ? thread_return+0x50/0xc3
 [<ffffffff802765b3>] handle_mm_fault+0x4a1/0x967
 [<ffffffff803ce640>] ? _spin_lock_irq+0x16/0x19
 [<ffffffff8023f8c6>] ? ptrace_stop+0x138/0x15d
 [<ffffffff803ce6ac>] ? _spin_unlock_irqrestore+0x1d/0x21
 [<ffffffff80224f06>] do_page_fault+0x5d0/0x9fa
 [<ffffffff803ce97a>] error_exit+0x0/0x70

---[ end trace a9dc8a283a23b787 ]---
------------[ cut here ]------------
kernel BUG at /home/jeremy/hg/xen/paravirt/linux/lib/radix-tree.c:473!
invalid opcode: 0000 [1] SMP 
CPU 0 
Modules linked in: xen_fbfront fb fb_sys_fops sysimgblt sysfillrect xen_netfront syscopyarea xen_kbdfront xen_blkfront
Pid: 1357, comm: X Tainted: G        W 2.6.27-rc2-tip #337
RIP: e030:[<ffffffff80301cb4>]  [<ffffffff80301cb4>] radix_tree_tag_set+0x17/0x9b
RSP: e02b:ffff88000b049cc0  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88000e47ec08
RBP: ffff88000b049cc8 R08: 2000000000000000 R09: 0000000000000000
R10: 00007fed69a08c80 R11: ffff880001425a90 R12: ffff88000e47ec00
R13: 0000000000000001 R14: ffff88000136c150 R15: ffff88000ef4e700
FS:  00007fed6b4f9780(0000) GS:ffffffff804b6ec0(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fed69a09000 CR3: 000000000cbc4000 CR4: 0000000000002620
     ^^^^^^^^^^^^^^^^
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 1357, threadinfo ffff88000b048000, task ffff88000cb2ecc0)
Stack:  ffff880001425a90 ffff88000b049cf8 ffffffff802af838 ffff88000b049ce8
 ffff880001425a90 ffff88000e47ec00 ffff880001425a90 ffff88000b049d18
 ffffffff802b19e1 ffff880001425a90 0000000000000001 ffff88000b049d48
Call Trace:
 [<ffffffff802af838>] __set_page_dirty+0xe3/0x113
 [<ffffffff802b19e1>] __set_page_dirty_buffers+0x84/0x89
 [<ffffffff8026c876>] set_page_dirty+0x46/0xb2
 [<ffffffff8026d9a1>] set_page_dirty_balance+0x17/0x4d
 [<ffffffff80274817>] __do_fault+0x494/0x4ae
 [<ffffffff803cccff>] ? thread_return+0x50/0xc3
 [<ffffffff802765b3>] handle_mm_fault+0x4a1/0x967
 [<ffffffff803ce640>] ? _spin_lock_irq+0x16/0x19
 [<ffffffff803ce6ac>] ? _spin_unlock_irqrestore+0x1d/0x21
 [<ffffffff80224f06>] do_page_fault+0x5d0/0x9fa
 [<ffffffff803ce97a>] error_exit+0x0/0x70


Code: ff eb 02 31 c0 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f c9 c3 55 44 8b 0f 48 89 e5 44 89 c8 53 48 3b 34 c5 60 f0 4b 80 89 d3 76 04 <0f> 0b eb fe 41 6b c1 06 4c 8b 57 08 44 8d 58 fa 49 83 e2 fe 89 
RIP  [<ffffffff80301cb4>] radix_tree_tag_set+0x17/0x9b
 RSP <ffff88000b049cc0>

