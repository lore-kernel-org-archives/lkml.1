Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbZF2IL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbZF2IL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZF2ILV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:11:21 -0400
Received: from mail.oxtel.com ([193.200.114.15]:3133 "EHLO oxtel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751549AbZF2ILU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:11:20 -0400
Message-ID: <4A487720.5080500@oxtel.com>
Date: Mon, 29 Jun 2009 09:11:12 +0100
From: Chris Pringle <chris.pringle@oxtel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Sergej.Stepanov@ids.de
CC: scottwood@freescale.com, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: AW: PowerPC PCI DMA issues (prefetch/coherency?)
References: <4A37A503.3030209@oxtel.com>
 <20090616162114.GA5051@loki.buserror.net> <4A37C97A.5050508@oxtel.com>
 <4A37CC72.3060709@freescale.com> <4A37CF02.5080906@oxtel.com>
 <4A37D073.6020802@freescale.com> <4A38A21B.5060306@oxtel.com>
 <4A38ED31.9030705@oxtel.com>,<4A3A23FA.1000407@oxtel.com>
 <4206182445660643B9AEB8D4E55BBD0A08533B67B5@HERMES2>
In-Reply-To: <4206182445660643B9AEB8D4E55BBD0A08533B67B5@HERMES2>
Content-Type: multipart/mixed;
 boundary="------------060702070701050901050700"
X-Authenticated-Sender: chris.pringle
X-Server: VPOP3 Enterprise V2.6.0b - Registered
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060702070701050901050700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sergej,

I've attached the patch used to fix this issue. Both the patch to 
pgtable32.h and head_32.S are required in order to make it work. The 
change to pgtable32.h ensures that all pages are marked cache coherent 
(results in setting the M bit). The change to head_32.S ensures that the 
M bit is not unconditionally masked out - it should only be masked out 
if CPU_FTR_NEED_COHERENT is not set.

Hope this helps.

Cheers,
Chris

Sergej.Stepanov@ids.de wrote:
>> The other part of the fix is in asm-powerpc/pgtable32.h. _PAGE_BASE
>> needs _PAGE_COHERENT in order to work correctly, and in fact there is
>> now a comment in there to that affect in 2.6.29. Backporting that change
>> has made it work on 2.6.26. Both this patch, and the fix to head_32.S
>> are needed for it to work correctly on older kernels.
>>
>> Chris
>>     
>
> Hello Chris,
>
> sorry for dummy, but if it possible, could you, please, send a corresponding summary patch of backporting you've done for older kernels?
> or just summary of that changes once again?
>
> Many thanks
>
> Sergej.


-- 

______________________________
Chris Pringle
Software Engineer

Miranda Technologies Ltd.
Hithercroft Road
Wallingford
Oxfordshire OX10 9DG
UK

Tel. +44 1491 820206
Fax. +44 1491 820001
www.miranda.com


____________________________

Miranda Technologies Limited
Registered in England and Wales CN 02017053
Registered Office: James House, Mere Park, Dedmere Road, Marlow, Bucks, SL7 1FJ
--------------060702070701050901050700
Content-Type: text/x-patch;
 name="dma-cache-coherency-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dma-cache-coherency-fix.patch"

diff -r -U3 ./arch/powerpc/kernel/head_32.S ../../kernel.WORKS/linux-2.6.26/arch/powerpc/kernel/head_32.S
--- ./arch/powerpc/kernel/head_32.S	2008-07-13 22:51:29.000000000 +0100
+++ ../../kernel.WORKS/linux-2.6.26/arch/powerpc/kernel/head_32.S	2009-06-17 18:18:04.000000000 +0100
@@ -501,8 +501,11 @@
 	and	r1,r1,r2		/* writable if _RW and _DIRTY */
 	rlwimi	r3,r3,32-1,30,30	/* _PAGE_USER -> PP msb */
 	rlwimi	r3,r3,32-1,31,31	/* _PAGE_USER -> PP lsb */
-	ori	r1,r1,0xe14		/* clear out reserved bits and M */
+	ori	r1,r1,0xe04		/* clear out reserved bits */
 	andc	r1,r3,r1		/* PP = user? (rw&dirty? 2: 3): 0 */
+BEGIN_FTR_SECTION
+	rlwinm	r1,r1,0,~_PAGE_COHERENT	/* clear M (coherence not required) */
+END_FTR_SECTION_IFCLR(CPU_FTR_NEED_COHERENT)
 	mtspr	SPRN_RPA,r1
 	mfspr	r3,SPRN_IMISS
 	tlbli	r3
@@ -575,8 +578,12 @@
 	and	r1,r1,r2		/* writable if _RW and _DIRTY */
 	rlwimi	r3,r3,32-1,30,30	/* _PAGE_USER -> PP msb */
 	rlwimi	r3,r3,32-1,31,31	/* _PAGE_USER -> PP lsb */
-	ori	r1,r1,0xe14		/* clear out reserved bits and M */
+	ori	r1,r1,0xe04		/* clear out reserved bits */
 	andc	r1,r3,r1		/* PP = user? (rw&dirty? 2: 3): 0 */
+BEGIN_FTR_SECTION
+	rlwinm	r1,r1,0,~_PAGE_COHERENT	/* clear M (coherence not required) */
+END_FTR_SECTION_IFCLR(CPU_FTR_NEED_COHERENT)
+    /*ori     r1,r1,0x10*/
 	mtspr	SPRN_RPA,r1
 	mfspr	r3,SPRN_DMISS
 	tlbld	r3
@@ -643,8 +650,12 @@
 	stw	r3,0(r2)		/* update PTE (accessed/dirty bits) */
 	/* Convert linux-style PTE to low word of PPC-style PTE */
 	rlwimi	r3,r3,32-1,30,30	/* _PAGE_USER -> PP msb */
-	li	r1,0xe15		/* clear out reserved bits and M */
+	li	r1,0xe05		/* clear out reserved bits & PP lsb */
 	andc	r1,r3,r1		/* PP = user? 2: 0 */
+BEGIN_FTR_SECTION
+	rlwinm	r1,r1,0,~_PAGE_COHERENT	/* clear M (coherence not required) */
+END_FTR_SECTION_IFCLR(CPU_FTR_NEED_COHERENT)
+    /*ori     r1,r1,0x10*/
 	mtspr	SPRN_RPA,r1
 	mfspr	r3,SPRN_DMISS
 	tlbld	r3
diff -r -U3 ./include/asm-powerpc/pgtable-ppc32.h ../../kernel.WORKS/linux-2.6.26/include/asm-powerpc/pgtable-ppc32.h
--- ./include/asm-powerpc/pgtable-ppc32.h	2008-07-13 22:51:29.000000000 +0100
+++ ../../kernel.WORKS/linux-2.6.26/include/asm-powerpc/pgtable-ppc32.h	2009-06-18 12:11:57.000000000 +0100
@@ -408,7 +408,7 @@
 #ifdef CONFIG_44x
 #define _PAGE_BASE	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_GUARDED)
 #else
-#define _PAGE_BASE	(_PAGE_PRESENT | _PAGE_ACCESSED)
+#define _PAGE_BASE	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_COHERENT)
 #endif
 #define _PAGE_WRENABLE	(_PAGE_RW | _PAGE_DIRTY | _PAGE_HWWRITE)
 #define _PAGE_KERNEL	(_PAGE_BASE | _PAGE_SHARED | _PAGE_WRENABLE)

--------------060702070701050901050700--
