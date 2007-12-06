Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbXLFTo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbXLFTo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXLFTou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:44:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbXLFTot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:44:49 -0500
Message-ID: <4758512E.1060306@redhat.com>
Date: Thu, 06 Dec 2007 14:44:46 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>
Subject: 2.6.23: x86_64 oops caused by hotplug running before vdso initialized
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pages is NULL here, implying vma->vm_private_data was NULL. This is apparently
because init_vdso_vars() is __initcall and runs after the rootfs gets populated.
An experimental initrd containing an /sbin/hotplug binary caused this. Normally
we don't have that file in the initrd. Should vdso init be done earlier to prevent
this problem?


static struct page *special_mapping_nopage(struct vm_area_struct *vma,
                                           unsigned long address, int *type)
{
        struct page **pages;

        BUG_ON(address < vma->vm_start || address >= vma->vm_end);

        address -= vma->vm_start;
        for (pages = vma->vm_private_data; address > 0 && *pages; ++pages)
                address -= PAGE_SIZE;

===>    if (*pages) {
                struct page *page = *pages;
                get_page(page);
                return page;
        }

        return NOPAGE_SIGBUS;
}


Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<ffffffff810838e9>] special_mapping_nopage+0x3c/0x63
PGD 7f568067 PUD 7f571067 PMD 0 
Oops: 0000 [1] SMP 
CPU 1 
Modules linked in:
Pid: 219, comm: hotplug Not tainted 2.6.23.9-77.fc8 #1
RIP: 0010:[<ffffffff810838e9>]  [<ffffffff810838e9>]
special_mapping_nopage+0x3c/0x63
RSP: 0000:ffff810037f41d50  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81007f4faff8 RCX: ffffffff8137e240
RDX: 0000000000000000 RSI: 00007fffeebfe000 RDI: ffff81007f4d8420
RBP: ffff81007f4d8420 R08: 00000007fffeebfe R09: 0000000000000000
R10: 000000006ffffdff R11: 000000006ffffe34 R12: 0000000000000000
R13: ffff81007f4da000 R14: 00007fffeebfe020 R15: ffff81007f4d8420
FS:  0000000000000000(0000) GS:ffff810002c3f300(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000007f4ae000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hotplug (pid: 219, threadinfo ffff810037f40000, task ffff81007f4bc820)
Stack:  ffffffff8107e42c 00000010000284d0 ffff81007f569ba8 00ff81000000f2a8
 0000000000000000 ffff810000000000 00000007fffeebfe 00007fffeebfe000
 0000000000000000 0000000000000004 0000000000400040 ffff81007f4d80b0
Call Trace:
 [<ffffffff8107e42c>] __do_fault+0x89/0x489
 [<ffffffff81081bd7>] handle_mm_fault+0x4ed/0x976
 [<ffffffff81084a46>] vma_link+0x70/0xfd
 [<ffffffff8125f037>] do_page_fault+0x45b/0x7e4
 [<ffffffff810115ef>] arch_get_unmapped_area+0x184/0x1f9
 [<ffffffff8108598c>] do_mmap_pgoff+0x2eb/0x350
 [<ffffffff81120cec>] __up_write+0x27/0xf3
 [<ffffffff8125d51d>] error_exit+0x0/0x84
