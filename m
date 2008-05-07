Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbYEGUwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbYEGUwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbYEGUvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:51:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:38958 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYEGUvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ZxbrXIGNP9vbxUq3X9fZXase3pBbq75FLKbuSrdjkitV2Wu0nd+OMzO2WygiCFXecWHzqL4pyakwPz5CvBwlN7vg66Mrh4M6H1gwYh7zSoy1A1azcWvt8D947c17e1Dnbof8xRDbk1nBUHd3CxpP78V0PBm3pzcGR1daxf4FSNg=
Message-ID: <48221695.7060507@henry.nestler.gmail.com>
Date: Wed, 07 May 2008 22:52:37 +0200
From: Henry Nestler <henry.nestler@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
 2.6 - v2
References: <480E6BB4.5080902@henry.nestler.gmail.com> <20080428164455.GB18210@elte.hu>
In-Reply-To: <20080428164455.GB18210@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page faults in kernel address space between PAGE_OFFSET up to
VMALLOC_START should not try to access pte/pgd inside function
spurious_fault.

To fix, move vmalloc address range checks from vmalloc_fault to
do_page_fault for 32 and 64bit.

Signed-off-by: Henry Nestler <henry.nestler@gmail.com>
---
32bit example, where adresss hole was faulting endless again (after the
patch from 2008-04-23):
=======
Linux version 2.6.25 (hn@hn-dt) (gcc version 4.2.1 (SUSE Linux)) #48
PREEMPT ...
64MB LOWMEM available.
[...]
entry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 61108k/65536k available (1482k kernel code, 0k reserved, 455k
data, 136k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffffa000 - 0xfffff000   (  20 kB)
    vmalloc : 0xc4800000 - 0xffff8000   ( 951 MB)
    lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
      .init : 0xcCPA: page pool initialized 1 of 1 pages preallocated
[...]
checking if image is initramfs...it isn't (no cpio magic); looks like an
initrd
BUG: unable to handle kernel paging request at c0000e68
IP: [<c010cb84>] __change_page_attr_set_clr+0x104/0x590
*pde = 00000063 BUG: unable to handle kernel paging request at c0000000
IP: [<c010c5c9>] do_page_fault+0x639/0x730
*pde = 00000063 BUG: unable to handle kernel paging request at c0000000
IP: [<c010c5c9>] do_page_fault+0x639/0x730
*pde = 00000063 BUG: unable to handle kernel paging request at c0000000
IP: [<c010c5c9>] do_page_fault+0x639/0x730
===== ... this never ends or with a stack overflow ... ===

Shure, the "out of range address" was from buggy driver development.
But not of adresses should kill the complete system.

"__change_page_attr_set_clr" is some of the macros inside spurious_fault.

_After_ this patch, I got such normal trace back print:
========
checking if image is initramfs...it isn't (no cpio magic); looks like an
initrd
BUG: unable to handle kernel paging request at c0000e68
IP: [<c010cb74>] __change_page_attr_set_clr+0x104/0x590
*pde = 08a96063
Oops: 0000 [#1] PREEMPT
Modules linked in:

Pid: 1, comm: swapper Not tainted (2.6.25 #49)
EIP: 0060:[<c010cb74>] EFLAGS: 00010282 CPU: 0
EIP is at __change_page_attr_set_clr+0x104/0x590
EAX: c0000e68 EBX: 00000002 ECX: c030ac3c EDX: c3819edc
ESI: c4000000 EDI: c3f9a000 EBP: c3819eec ESP: c3819e80
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=c3818000 task=c38175f0 task.ti=c3818000)
<0>Stack: 00000046 00000000 00000000 c4000000 00000001 c3819efc ...
[...]
<0>Call Trace:
 [<c010d05f>] ? change_page_attr_set_clr+0x5f/0x1e0
 [<c010d1f7>] ? set_memory_rw+0x17/0x20
 [<c010b5b0>] ? free_init_pages+0x20/0xa0
 [<c015ed08>] ? fput+0x18/0x20
 [<c015bae7>] ? filp_close+0x47/0x70
 [<c010b641>] ? free_initrd_mem+0x11/0x20
 [<c02edf5c>] ? free_initrd+0x1c/0x40
 [<c02ee03b>] ? populate_rootfs+0xbb/0x100
 [<c02e8793>] ? kernel_init+0x83/0x260
[...]
========

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fd7e179..59f612c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -518,10 +518,6 @@ static int vmalloc_fault(unsigned long address)
 	pmd_t *pmd, *pmd_ref;
 	pte_t *pte, *pte_ref;

-	/* Make sure we are in vmalloc area */
-	if (!(address >= VMALLOC_START && address < VMALLOC_END))
-		return -1;
-
 	/* Copy kernel mappings over when needed. This can also
 	   happen within a race in page table update. In the later
 	   case just flush. */
@@ -620,13 +616,17 @@ void __kprobes do_page_fault(struct pt_regs *regs,
unsigned long error_code)
 #else
 	if (unlikely(address >= TASK_SIZE64)) {
 #endif
-		if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
-		    vmalloc_fault(address) >= 0)
-			return;
+		/* Make sure we are in vmalloc area */
+		if (address >= VMALLOC_START && address < VMALLOC_END) {

-		/* Can handle a stale RO->RW TLB */
-		if (spurious_fault(address, error_code))
-			return;
+			if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
+			    vmalloc_fault(address) >= 0)
+				return;
+
+			/* Can handle a stale RO->RW TLB */
+			if (spurious_fault(address, error_code))
+				return;
+		}

 		/*
 		 * Don't take the mm semaphore here. If we fixup a prefetch
