Return-Path: <linux-kernel-owner+w=401wt.eu-S1761583AbYCZAmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761583AbYCZAmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbYCZAmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:42:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:1044 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbYCZAmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:42:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,555,1199692800"; 
   d="scan'208";a="223188276"
Date: Tue, 25 Mar 2008 17:39:12 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, venkatesh.pallipadi@intel.com,
       arjan@linux.intel.com, bug-track@fisher-privat.net
Subject: Re: [Bug 10328] New: [regression] performance drop for glx
Message-ID: <20080326003912.GB3313@linux-os.sc.intel.com>
References: <bug-10328-27@http.bugzilla.kernel.org/> <20080325152809.e2b07251.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325152809.e2b07251.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 03:28:09PM -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Tue, 25 Mar 2008 15:11:15 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=10328
> > 
> >            Summary: [regression] performance drop for glx
> > 
> > after commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5 i expirience some grafik
> > related perfomance issues.
> > 
> > I used glxgears for test.
> > before this patch: 1281.005 FPS
> > and after: 765.000 FPS
> 
> It nearly halved.
> 
> > latest tested commit a4083c9271e0a697278e089f2c0b9a95363ada0a
> > still hase bad performance.
> > 
> > I use Pentium D with 2GB RAM, Grafick: i945G, ICH7
> > 
> 
> That's 
> 
> : commit 4138cc3418f5eaa7524ff8e927102863f1ba0ea5
> : Author: Siddha, Suresh B <suresh.b.siddha@intel.com>
> : Date:   Wed Jan 30 13:33:43 2008 +0100
> : 
> :     x86: set strong uncacheable where UC is really desired
> :     
> :     Also use _PAGE_PWT for all the mappings which need uncache mapping.
> :     Instead of existing PAT2 which is UC- (and can be overwritten by MTRRs),
> :     we now use PAT3 which is strong uncacheable.
> :     
> :     This makes it consistent with pgprot_noncached()

Alexey, Can you please try the appended patch?

Andrew, can you please push the appended patch for 2.6.25? Thanks.
---

fb drivers are using ioremap()/ioremap_nocache(), followed by mtrr_add with
WC attribute. Recent changes in page attribute code made both
ioremap()/ioremap_nocache() mappings as UC (instead of previous UC-). This
breaks the graphics performance, as the effective memory type is UC instead
of expected WC.

The correct way to fix this is to add ioremap_wc() (which uses UC- in the
absence of PAT kernel support and WC with PAT) and change all the
fb drivers to use this new ioremap_wc() API.

We can take this correct and longer route for post 2.6.25. For now,
revert back to the UC- behavior for ioremap/ioremap_nocache.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 4afaba0..794895c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -137,7 +137,11 @@ static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
 	default:
-		prot = PAGE_KERNEL_NOCACHE;
+		/*
+		 * FIXME: we will use UC MINUS for now, as video fb drivers
+		 * depend on it. Upcoming ioremap_wc() will fix this behavior.
+		 */
+		prot = PAGE_KERNEL_UC_MINUS;
 		break;
 	case IOR_MODE_CACHED:
 		prot = PAGE_KERNEL;
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 174b877..9cf472a 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -85,6 +85,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
+#define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
 #define __PAGE_KERNEL_VSYSCALL_NOCACHE	(__PAGE_KERNEL_VSYSCALL | _PAGE_PCD | _PAGE_PWT)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
@@ -101,6 +102,7 @@ extern pteval_t __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define PAGE_KERNEL_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_EXEC)
 #define PAGE_KERNEL_RX			MAKE_GLOBAL(__PAGE_KERNEL_RX)
 #define PAGE_KERNEL_NOCACHE		MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
+#define PAGE_KERNEL_UC_MINUS		MAKE_GLOBAL(__PAGE_KERNEL_UC_MINUS)
 #define PAGE_KERNEL_EXEC_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_EXEC_NOCACHE)
 #define PAGE_KERNEL_LARGE		MAKE_GLOBAL(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC		MAKE_GLOBAL(__PAGE_KERNEL_LARGE_EXEC)
