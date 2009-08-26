Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbZHZWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbZHZWhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZHZWhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:37:45 -0400
Received: from host0.dyn.jankratochvil.net ([89.250.240.59]:36676 "EHLO
	host0.dyn.jankratochvil.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbZHZWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:37:44 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 18:37:43 EDT
Date: Thu, 27 Aug 2009 00:31:26 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [patch] Fix vdso32 relocation for paddr
Message-ID: <20090826223126.GA20373@host0.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

`readelf -Wl file-dumped-from-/proc/self/maps-[vdso]' for x86_64 process prints:
Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  LOAD           0x000000 0xffffffffff700000 0xffffffffff700000 0x000890 0x000890 R E 0x1000
  DYNAMIC        0x000410 0xffffffffff700410 0xffffffffff700410 0x0000f0 0x0000f0 R   0x8
  NOTE           0x0002d0 0xffffffffff7002d0 0xffffffffff7002d0 0x00003c 0x00003c R   0x4
  GNU_EH_FRAME   0x00030c 0xffffffffff70030c 0xffffffffff70030c 0x000034 0x000034 R   0x4

while such dump for i386 process prints:
Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x000000 0xffffe000 0x00000000 0x00434 0x00434 R E 0x1000
  DYNAMIC        0x000350 0xffffe350 0x00000350 0x00078 0x00078 R   0x4
  NOTE           0x0001c4 0xffffe1c4 0x000001c4 0x00060 0x00060 R   0x4
  GNU_EH_FRAME   0x000224 0xffffe224 0x00000224 0x00024 0x00024 R   0x4

The mapped location can be arbirary (according to the rules of PIC - Position
Independent Code) but currently the i386 vdso (vdso32) looks as an overlayed
code as it has LMA != VMA (rule contained in GDB function section_is_overlay,
as suggested by Daniel Jacobowitz).

Fixed vdso32 prints:
Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x000000 0xffffe000 0xffffe000 0x00434 0x00434 R E 0x1000
  DYNAMIC        0x000350 0xffffe350 0xffffe350 0x00078 0x00078 R   0x4
  NOTE           0x0001c4 0xffffe1c4 0xffffe1c4 0x00060 0x00060 R   0x4
  GNU_EH_FRAME   0x000224 0xffffe224 0xffffe224 0x00024 0x00024 R   0x4

It required now a workaround in GDB patch so at least to fix it in Linux kernel:
	http://sourceware.org/ml/gdb-patches/2009-08/msg00437.html


Thanks,
Jan


Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>

--- linux-2.6.30.x86_64/arch/x86/vdso/vdso32-setup.c-orig	2009-08-26 22:23:08.000000000 +0200
+++ linux-2.6.30.x86_64/arch/x86/vdso/vdso32-setup.c	2009-08-26 22:38:10.000000000 +0200
@@ -172,6 +172,7 @@ static __init void relocate_vdso(Elf32_E
 	phdr = (void *)ehdr + ehdr->e_phoff;
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		phdr[i].p_vaddr += VDSO_ADDR_ADJUST;
+		phdr[i].p_paddr += VDSO_ADDR_ADJUST;
 
 		/* relocate dynamic stuff */
 		if (phdr[i].p_type == PT_DYNAMIC)
