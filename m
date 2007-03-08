Return-Path: <linux-kernel-owner+w=401wt.eu-S1030666AbXCHVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030666AbXCHVn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030671AbXCHVn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:43:58 -0500
Received: from ozlabs.org ([203.10.76.45]:60897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030666AbXCHVn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:43:57 -0500
Date: Thu, 8 Mar 2007 15:42:36 -0600
From: Anton Blanchard <anton@samba.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>, David Brown <dmlb2000@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gdb@sourceware.org
Subject: Re: PAGE_SIZE Availability Inconsistency
Message-ID: <20070308214236.GA4154@kryten>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com> <20070306092917.GA5226@infradead.org> <200703080318.04631.zippel@linux-m68k.org> <20070308090031.GB7373@infradead.org> <1173369229.3550.2.camel@laptopd505.fenrus.org> <20070308160852.GB9916@infradead.org> <45F0426C.8000009@zytor.com> <20070308175729.GA7054@kryten> <45F05040.4090602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F05040.4090602@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi Peter,

> The easiest way to fix this would be to always park the swap magic at 
> the offset of the smallest page size in use, which is 4K.  This is 
> analogous how the offset for the ext2/3 superblock got fixed at 1K -- 
> for 1K blocks, it's the second block, but for larger blocks, it's part 
> of the first block.  If we fix the offset of the swap magic at 4096 
> minus the offset that's already there, it will always fall in the first 
> page regardless of page size.

Yeah that makes sense. I gave it a go by creating a MIN_PAGE_SIZE
define, and allowing an architecture to override it if required.

A couple of issues:

1. Parts of the swap header are in PAGE_SIZE chunks so I made them
MIN_PAGE_SIZE chunks too.

2. The badblocks stuff is PAGE_SIZEd too. Do we ever use it on modern
disks? Maybe we can just remove this support.

3. This will unfortunately break machines currently running a 64kB
kernel with swap space. We may just have to lump it and fix on upgade.

Anton
--

Our current swap layout has issues with variable page size kernels.
Instead of using the page size at runtime, base it on the minimum page
size the architecture supports.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/include/linux/swap.h
===================================================================
--- linux-2.6.orig/include/linux/swap.h	2007-03-08 15:14:30.000000000 -0600
+++ linux-2.6/include/linux/swap.h	2007-03-08 15:14:33.000000000 -0600
@@ -48,14 +48,17 @@
  * old reserved area - some extra information. Note that the first
  * kilobyte is reserved for boot loader or disk label stuff...
  *
- * Having the magic at the end of the PAGE_SIZE makes detecting swap
- * areas somewhat tricky on machines that support multiple page sizes.
- * For 2.5 we'll probably want to move the magic to just beyond the
- * bootbits...
+ * Version 1 and 2 swap headers store the magic at the end of the
+ * PAGE_SIZE which causes problems for architectures with multiple
+ * page sizes. An architecture can define MIN_PAGE_SIZE to be used
+ * regardless of the kernel page size to get around this.
  */
+#ifndef MIN_PAGE_SIZE
+#define MIN_PAGE_SIZE PAGE_SIZE
+#endif
 union swap_header {
 	struct {
-		char reserved[PAGE_SIZE - 10];
+		char reserved[MIN_PAGE_SIZE - 10];
 		char magic[10];			/* SWAP-SPACE or SWAPSPACE2 */
 	} magic;
 	struct {
Index: linux-2.6/include/asm-powerpc/page.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/page.h	2007-03-08 15:14:30.000000000 -0600
+++ linux-2.6/include/asm-powerpc/page.h	2007-03-08 15:14:33.000000000 -0600
@@ -24,8 +24,10 @@
 #else
 #define PAGE_SHIFT		12
 #endif
+#define MIN_PAGE_SHIFT		12
 
 #define PAGE_SIZE		(ASM_CONST(1) << PAGE_SHIFT)
+#define MIN_PAGE_SIZE		(ASM_CONST(1) << MIN_PAGE_SHIFT)
 
 /* We do define AT_SYSINFO_EHDR but don't use the gate mechanism */
 #define __HAVE_ARCH_GATE_AREA		1
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c	2007-03-08 14:48:03.000000000 -0600
+++ linux-2.6/mm/swapfile.c	2007-03-08 15:33:04.000000000 -0600
@@ -1568,6 +1568,12 @@
 		p->cluster_next = 1;
 
 		/*
+		 * last_page is in MIN_PAGE_SIZE chunks, scale to kernel
+		 * page size.
+		 */
+		swap_header->info.last_page >>= (PAGE_SHIFT - MIN_PAGE_SHIFT);
+
+		/*
 		 * Find out how many pages are allowed for a single swap
 		 * device. There are two limiting factors: 1) the number of
 		 * bits for the swap offset in the swp_entry_t type and
