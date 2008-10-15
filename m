Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYJOOqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYJOOqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYJOOq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:46:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:24850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbYJOOq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:46:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,416,1220252400"; 
   d="scan'208";a="391867150"
Date: Wed, 15 Oct 2008 07:46:27 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: linux 2.6.27 kernel panic on x86 - please revert commit 3a85e770aa77e4f1a4096275c97b64c10cd7323e
Message-ID: <20081015144626.GC7829@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0810151902510.19590@boston.corp.fedex.com> <20081015112324.GB31476@elte.hu> <b6a2187b0810150502m3b363b90q106102578e92811d@mail.gmail.com> <20081015120558.GA23347@elte.hu> <b6a2187b0810150639j37ed3be6v3c800fb7d3a4a1f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0810150639j37ed3be6v3c800fb7d3a4a1f0@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 06:39:39AM -0700, Jeff Chua wrote:
> On Wed, Oct 15, 2008 at 8:05 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> Unsetting CONFIG_COMPAT_VDSO solves the issue.
> >>
> >> Thanks for your help, and sorry for the fault alarm. Did take a while
> >> to trace it down to the commit.
> >
> > hm, setting the option should not break new glibc so this is a
> > regression and we've still got a bug to fix.
> 
> Something must have triggered the bug. Every single linux git update
> has been ok with CONFIG_COMPAT_VDSO=y until now, and I had glibc-2.7
> since Dec 2007.

Jeff, Does the appended patch fix the issue? Thanks.

---
Subject: x86: include USER bit for the PDE_IDENT_ATTR

Jeff Chua reported that this patch

> -#define PTE_IDENT_ATTR  0x007          /* PRESENT+RW+USER */
> -#define PDE_IDENT_ATTR  0x067          /* PRESENT+RW+USER+DIRTY+ACCESSED */
> +#define PTE_IDENT_ATTR  0x003          /* PRESENT+RW */
> +#define PDE_IDENT_ATTR  0x063          /* PRESENT+RW+DIRTY+ACCESSED */

broke kernels with CONFIG_COMPAT_VDSO set with this panic info:

init[1]: segfault at ffffe01c up b7f0dc28 sp bfc26628 error 5 in ld-2.7.90.so[b7f0b000+1c000]

Include USER bit in the PDE_IDENT_ATTR only, as the protection bits
are combined from the PDE and PTE entries. This will allow the high
mapped VDSO page in the case of CONFIG_COMPAT_VDSO to be user
readable.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 182f9d4..88a53b1 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -148,8 +148,13 @@
 #ifdef CONFIG_X86_64
 #define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
 #else
+/*
+ * For PDE_IDENT_ATTR include USER bit. As the PDE and PTE protection
+ * bits are combined, this will alow user to access the high address mapped
+ * VDSO in the presence of CONFIG_COMPAT_VDSO
+ */
 #define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
-#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+DIRTY+ACCESSED */
+#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
 #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
 #endif
 


