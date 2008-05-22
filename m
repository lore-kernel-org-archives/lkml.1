Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYEVT1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYEVT1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbYEVT0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:26:49 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1833 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYEVT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:26:46 -0400
Subject: Re: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, andi-suse@firstfloor.org, miquels@cistron.nl
In-Reply-To: <20080522084736.GC31727@one.firstfloor.org>
References: <20080521113028.GA24632@xs4all.net>
	 <48341A57.1030505@redhat.com>  <20080522084736.GC31727@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 22 May 2008 21:25:43 +0200
Message-Id: <1211484343.30678.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 10:47 +0200, Andi Kleen wrote:
> On Wed, May 21, 2008 at 09:49:27AM -0300, Glauber Costa wrote:
> > probably andi has a better idea on why it was added, since it used to 
> > live in his tree?
> 
> d_a_c() tries a couple of zones, and running the oom killer for each
> is inconvenient. Especially for the 16MB DMA zone which is unlikely
> to be cleared by the OOM killer anyways because normal user applications
> don't put pages in there. There was a real report with some problems
> in this area. Also for the earlier tries you don't want to really
> bring the system into swap.

I understand, but I do think using __GFP_NORETRY causes problems.

Most drivers call pci_alloc_consistent() which calls
dma_alloc_coherent(.... GFP_ATOMIC) which can dip deep into reserves so
it won't fail so easily. Just a handful use dma_alloc_coherent()
directly.

However, in 2.6.26-rc1, dpt_i2o.c was updated for 64 bit support, and
all it's kmalloc(.... GFP_KERNEL) + virt_to_bus() calls have been
replaced by dma_alloc_coherent(.... GFP_KERNEL).

In that case, it's not a very good idea to add __GFP_NORETRY. It will
cause problems. It certainly does in 3w-xxxx.c and it probably will
cause worse problems in dpt_i2o.c.

I think we should do something. How about one of these two patches.

# -----

linux-2.6.26-d_a_c-fix-noretry.patch

diff -ruN linux-2.6.26-rc3.orig/arch/x86/kernel/pci-dma.c linux-2.6.26-rc3/arch/x86/kernel/pci-dma.c
--- linux-2.6.26-rc3.orig/arch/x86/kernel/pci-dma.c	2008-05-18 23:36:41.000000000 +0200
+++ linux-2.6.26-rc3/arch/x86/kernel/pci-dma.c	2008-05-22 21:21:37.000000000 +0200
@@ -398,7 +398,8 @@
 		return NULL;
 
 	/* Don't invoke OOM killer */
-	gfp |= __GFP_NORETRY;
+	if (!(gfp & __GFP_WAIT))
+		gfp |= __GFP_NORETRY;
 
 #ifdef CONFIG_X86_64
 	/* Why <=? Even when the mask is smaller than 4GB it is often


# -----


linux-2.6.26-gfp-no-oom.patch

diff -ruN linux-2.6.26-rc3.orig/arch/x86/kernel/pci-dma.c linux-2.6.26-rc3/arch/x86/kernel/pci-dma.c
--- linux-2.6.26-rc3.orig/arch/x86/kernel/pci-dma.c	2008-05-18 23:36:41.000000000 +0200
+++ linux-2.6.26-rc3/arch/x86/kernel/pci-dma.c	2008-05-22 20:42:10.000000000 +0200
@@ -398,7 +398,7 @@
 		return NULL;
 
 	/* Don't invoke OOM killer */
-	gfp |= __GFP_NORETRY;
+	gfp |= __GFP_NO_OOM;
 
 #ifdef CONFIG_X86_64
 	/* Why <=? Even when the mask is smaller than 4GB it is often
diff -ruN linux-2.6.26-rc3.orig/include/linux/gfp.h linux-2.6.26-rc3/include/linux/gfp.h
--- linux-2.6.26-rc3.orig/include/linux/gfp.h	2008-05-18 23:36:41.000000000 +0200
+++ linux-2.6.26-rc3/include/linux/gfp.h	2008-05-22 21:17:36.000000000 +0200
@@ -43,6 +43,7 @@
 #define __GFP_REPEAT	((__force gfp_t)0x400u)	/* See above */
 #define __GFP_NOFAIL	((__force gfp_t)0x800u)	/* See above */
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* See above */
+#define __GFP_NO_OOM	((__force gfp_t)0x2000u)/* Don't invoke oomkiller */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
 #define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
diff -ruN linux-2.6.26-rc3.orig/mm/page_alloc.c linux-2.6.26-rc3/mm/page_alloc.c
--- linux-2.6.26-rc3.orig/mm/page_alloc.c	2008-05-18 23:36:41.000000000 +0200
+++ linux-2.6.26-rc3/mm/page_alloc.c	2008-05-22 17:39:12.000000000 +0200
@@ -1583,7 +1583,8 @@
 					zonelist, high_zoneidx, alloc_flags);
 		if (page)
 			goto got_pg;
-	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
+	} else if ((gfp_mask & __GFP_FS) &&
+			!(gfp_mask & (__GFP_NORETRY|__GFP_NO_OOM))) {
 		if (!try_set_zone_oom(zonelist, gfp_mask)) {
 			schedule_timeout_uninterruptible(1);
 			goto restart;


