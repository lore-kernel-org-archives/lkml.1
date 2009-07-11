Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZGKLuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZGKLuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbZGKLty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:49:54 -0400
Received: from ozlabs.org ([203.10.76.45]:59012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbZGKLtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:49:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH v4] RO/NX protection for loadable kernel modules
Date: Sat, 11 Jul 2009 21:19:45 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
References: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com> <20090707220640.5352ac94@infradead.org> <817ecb6f0907081531u2f63c3c6y9b1cbc7bf8ff653@mail.gmail.com>
In-Reply-To: <817ecb6f0907081531u2f63c3c6y9b1cbc7bf8ff653@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907112119.46603.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009 08:01:59 am Siarhei Liakh wrote:
> [ Arjen wrote: ]
> > I *think* this can be done as
> >
> > begin_pfn = PFN_UP( (base);
> > end_pfn = PFN_DOWN(base + ro_size);
> >
> > if (end_pfn > begin_pfn)
> >        set_memory_ro(begin_pfn >> PAGE_SHIFT, end_pfn - begin_pfn);
> >
> > (note that I think the +1 you have might be buggy)
>
> The +1 is necessary because of (end_addr - 1). However, I like your
> way better, so I will incorporate it in V5.

In fact, this wasn't quite what you did.  You did begin_pfn = PFN_DOWN(),
end_pfn = PFN_DOWN(), then later use PFN_UP on both of them.

Is this what you intended?

(Note: I removed some DEBUGPs, where action is implied anyway).

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1517,55 +1517,41 @@ static void set_section_ro_nx(void *base
 	unsigned long begin_pfn;
 	unsigned long end_pfn;
 
+#ifdef CONFIG_DEBUG_RODATA
+	/* Most module_alloc use vmalloc which page-aligns.  If not,
+	 * we could be missing protection on first part of module. */
+	WARN_ON(offset_in_page((unsigned long)base));
+#endif
+
 	/* Initially, all module sections have RWX permissions*/
-
 	DEBUGP("PROTECTING MODULE SECTION: 0x%lx\n"
 			"  text size: %lu\n"
 			"  ro size: %lu\n"
 			"  total size: %lu\n",
 			(unsigned long)base,
-			text_size, ro_size, total_size);
+	       text_size, ro_size, total_size);
 
-	/* Set RO for module text and RO-data*/
-	if (ro_size > 0) {
-		/* Always protect first page.
-		 * Do not protect last partial page */
-		begin_pfn = PFN_DOWN((unsigned long)base);
-		end_pfn = PFN_DOWN((unsigned long)base + ro_size);
+	/* Set RO for module text and RO-data */
+	/* Don't protect partial pages. */
+	begin_pfn = PFN_UP((unsigned long)base);
+	end_pfn = PFN_DOWN((unsigned long)base + ro_size);
 
-		/*Set text RO if there are still pages between begin and end*/
-		if (end_pfn > begin_pfn) {
-			DEBUGP("  RO: 0x%lx %lu\n",
-					begin_pfn << PAGE_SHIFT,
-					end_pfn - begin_pfn);
-			set_memory_ro(begin_pfn << PAGE_SHIFT,
-						end_pfn - begin_pfn);
-		} else {
-			DEBUGP("  RO: less than a page, not enforcing.\n");
-		}
-	} else {
-		DEBUGP("  RO: section not present.\n");
+	/* Set text RO if there are still pages between begin and end */
+	if (end_pfn > begin_pfn) {
+		DEBUGP("  RO: 0x%lx %lu\n",
+		       begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
+		set_memory_ro(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
 	}
 
 	/* Set NX permissions for module data */
-	if (total_size > text_size) {
-		/* Do not protect first partial page
-		 * Always protect last page. */
-		begin_pfn = PFN_UP((unsigned long)base + text_size);
-		end_pfn = PFN_UP((unsigned long)base + total_size);
+	/* Don't protect partial pages. */
+	begin_pfn = PFN_UP((unsigned long)base + text_size);
+	end_pfn = PFN_DOWN((unsigned long)base + total_size);
 
-		/*Set data NX if there are still pages between begin and end*/
-		if (end_pfn > begin_pfn) {
-			DEBUGP("  NX: 0x%lx %lu\n",
-					begin_pfn << PAGE_SHIFT,
-					end_pfn - begin_pfn);
-			set_memory_nx(begin_pfn << PAGE_SHIFT,
-						end_pfn - begin_pfn);
-		} else {
-			DEBUGP("  NX: less than a page, not enforcing.\n");
-		}
-	} else {
-		DEBUGP("  NX: section not present.\n");
+	if (end_pfn > begin_pfn) {
+		DEBUGP("  NX: 0x%lx %lu\n",
+		       begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
+		set_memory_nx(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
 	}
 }
 

