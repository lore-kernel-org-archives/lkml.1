Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZI1Vgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZI1Vgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZI1Vgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:36:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48196
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbZI1Vgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:36:37 -0400
Date: Mon, 28 Sep 2009 14:36:56 -0700 (PDT)
Message-Id: <20090928.143656.208349447.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@elte.hu, hpa@zytor.com
Subject: Re: [PATCH 2/3] sparc64: implement page mapping percpu first chunk
 allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <4ABB6C80.20109@kernel.org>
References: <4ABB6C3A.8070109@kernel.org>
	<4ABB6C80.20109@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 24 Sep 2009 21:56:32 +0900

> Implement page mapping percpu first chunk allocator as a fallback to
> the embedding allocator.  The next patch will make the embedding
> allocator check distances between units to determine whether it fits
> within the vmalloc area so that this fallback can be used on such
> cases.
> 
> sparc64 currently has relatively small vmalloc area which makes it
> impossible to create any dynamic chunks on certain configurations
> leading to percpu allocation failures.  This and the next patch should
> allow those configurations to keep working until proper solution is
> found.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> David, can you please ack this after reviewing?

Tejun I am testing out the following patch which will make these
patches of your's basically unnecessary:

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 0ff92fa..f3cb790 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -41,8 +41,8 @@
 #define LOW_OBP_ADDRESS		_AC(0x00000000f0000000,UL)
 #define HI_OBP_ADDRESS		_AC(0x0000000100000000,UL)
 #define VMALLOC_START		_AC(0x0000000100000000,UL)
-#define VMALLOC_END		_AC(0x0000000200000000,UL)
-#define VMEMMAP_BASE		_AC(0x0000000200000000,UL)
+#define VMALLOC_END		_AC(0x0000010000000000,UL)
+#define VMEMMAP_BASE		_AC(0x0000010000000000,UL)
 
 #define vmemmap			((struct page *)VMEMMAP_BASE)
 
diff --git a/arch/sparc/kernel/ktlb.S b/arch/sparc/kernel/ktlb.S
index 3ea6e8c..1d36147 100644
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -280,8 +280,8 @@ kvmap_dtlb_nonlinear:
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 	/* Do not use the TSB for vmemmap.  */
-	mov		(VMEMMAP_BASE >> 24), %g5
-	sllx		%g5, 24, %g5
+	mov		(VMEMMAP_BASE >> 40), %g5
+	sllx		%g5, 40, %g5
 	cmp		%g4,%g5
 	bgeu,pn		%xcc, kvmap_vmemmap
 	 nop
@@ -293,8 +293,8 @@ kvmap_dtlb_tsbmiss:
 	sethi		%hi(MODULES_VADDR), %g5
 	cmp		%g4, %g5
 	blu,pn		%xcc, kvmap_dtlb_longpath
-	 mov		(VMALLOC_END >> 24), %g5
-	sllx		%g5, 24, %g5
+	 mov		(VMALLOC_END >> 40), %g5
+	sllx		%g5, 40, %g5
 	cmp		%g4, %g5
 	bgeu,pn		%xcc, kvmap_dtlb_longpath
 	 nop
