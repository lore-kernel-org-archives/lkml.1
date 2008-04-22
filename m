Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbYDVXu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbYDVXu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYDVXus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:50:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:45866 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbYDVXuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=rnuoI2aD4YEsE8slIQfzykzH0oOzeqVSYRaAw6RO2hVuhX4mZQHOTqJbkAbmksfrNOhTrwViww5HWtMvnGyYasqxCmjlTzzKfi4t2FG05xNYVmY+qQK0ZupM38MpguNXZp7UWRKkgF+1gfplS+LSVY9+uvzpWAoPjPXBvqsKG3E=
Message-ID: <480E6BB4.5080902@henry.nestler.gmail.com>
Date: Wed, 23 Apr 2008 00:50:28 +0200
From: Henry Nestler <henry.nestler@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: endless page faults in mount_block_root for Linux 2.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page faults in kernel address space between PAGE_OFFSET up to
VMALLOC_START should not try to map as vmalloc.

Fix rarely endless page faults inside mount_block_root for root
filesystem at boot time.

Signed-off-by: Henry Nestler <henry.nestler@gmail.com>
---

All 32bit kernels up to 2.6.25 can fail into this hole.
I can not present this under native linux kernel. I see, that the 64bit
has fixed the problem. I copied the same lines into 32bit part.

Recorded debugs are from coLinux kernel 2.6.22.18 (virtualisation):
http://www.henrynestler.com/colinux/testing/pfn-check-0.7.3/20080410-antinx/bug16-recursive-page-fault-endless.txt
The physicaly memory was trimmed down to 192MB to better catch the bug.
More memory gets the bug more rarely.

Details, how every x86 32bit system can fail:

Start from "mount_block_root",
http://lxr.linux.no/linux/init/do_mounts.c#L297
There the variable "fs_names" got one memory page with 4096 bytes.
Variable "p" walks through the existing file system types. The first
string is no problem.
But, with the second loop in mount_block_root the offset of "p" is not
at beginning of page, the offset is for example +9, if "reiserfs" is the
first in list.
Than calls do_mount_root, and lands in sys_mount.
Remember: Variable "type_page" contains now "fs_type+9" and not contains
a full page.
The sys_mount copies 4096 bytes with function "exact_copy_from_user()":
http://lxr.linux.no/linux/fs/namespace.c#L1540

Mostly exist pages after the buffer "fs_names+4096+9" and the page fault
handler was not called. No problem.

In the case, if the page after "fs_names+4096" is not mapped, the page
fault handler was called from http://lxr.linux.no/linux/fs/namespace.c#L1320

The do_page_fault gots an address 0xc03b4000.
It's kernel address, address >= TASK_SIZE, but not from vmalloc! It's
from "__getname()" alias "kmem_cache_alloc".
The "error_code" is 0. "vmalloc_fault" will be call:
http://lxr.linux.no/linux/arch/i386/mm/fault.c#L332

"vmalloc_fault" tryed to find the physical page for a non existing
virtual memory area. The macro "pte_present" in vmalloc_fault()
got a next page fault for 0xc0000ed0 at:
http://lxr.linux.no/linux/arch/i386/mm/fault.c#L282

No PTE exist for such virtual address. The page fault handler was trying
to sync the physical page for the PTE lockup.

This called vmalloc_fault() again for address 0xc000000, and that also
was not existing. The endless began...

In normal case the cpu would still loop with disabled interrrupts. Under
coLinux this was catched by a stack overflow inside printk debugs.

---
Index: linux-2.6.25/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.25/arch/x86/mm/fault.c
+++ linux-2.6.25/arch/x86/mm/fault.c
@@ -497,11 +497,6 @@
        unsigned long pgd_paddr;
        pmd_t *pmd_k;
        pte_t *pte_k;
+
+       /* Make sure we are in vmalloc area */
+       if (!(address >= VMALLOC_START && address < VMALLOC_END))
+               return -1;
+
        /*
         * Synchronize this task's top level page-table
         * with the 'reference' page table.

-- 
Henry N.
