Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZGKIwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZGKIwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZGKIvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:51:54 -0400
Received: from ozlabs.org ([203.10.76.45]:59396 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZGKIvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:51:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
Date: Sat, 11 Jul 2009 18:21:46 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com> <20090710112403.GC3760@elte.hu> <200907111537.03191.rusty@rustcorp.com.au>
In-Reply-To: <200907111537.03191.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907111821.47769.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009 03:37:01 pm Rusty Russell wrote:
> On Fri, 10 Jul 2009 08:54:03 pm Ingo Molnar wrote:
> > please use the customary comment style:
>
> Please don't.  There's one spot in that file which does it, and frankly
> it's a distracting waste of space.

Sorry, Ingo there's more than one.  I don't bother fixing up others' comments
in patches, so the file is now a bit mixed.  It'd be better to make it
uniform, in which case I'd change it to kernel-style.

I have a question about this patch though: I think it's unsafe in general to
mark the last partial page as NX (we asked for executable pages, this could
remove executable from some unrelated allocation).

And here's the cleanup patch I applied on top of yours; mainly removing
pointless zero checks (ignore the whitespace cleanups).

Thanks,
Rusty.

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1518,55 +1518,30 @@ static void set_section_ro_nx(void *base
 	unsigned long end_pfn;
 
 	/* Initially, all module sections have RWX permissions*/
-
 	DEBUGP("PROTECTING MODULE SECTION: 0x%lx\n"
 			"  text size: %lu\n"
 			"  ro size: %lu\n"
 			"  total size: %lu\n",
 			(unsigned long)base,
-			text_size, ro_size, total_size);
+	       text_size, ro_size, total_size);
 
 	/* Set RO for module text and RO-data*/
-	if (ro_size > 0) {
-		/* Always protect first page.
-		 * Do not protect last partial page */
-		begin_pfn = PFN_DOWN((unsigned long)base);
-		end_pfn = PFN_DOWN((unsigned long)base + ro_size);
+	/* Always protect first page.  Do not protect last partial page */
+	begin_pfn = PFN_DOWN((unsigned long)base);
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
-	}
+	DEBUGP("  RO: 0x%lx %lu\n",
+	       begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
+	set_memory_ro(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
 
 	/* Set NX permissions for module data */
-	if (total_size > text_size) {
-		/* Do not protect first partial page
-		 * Always protect last page. */
-		begin_pfn = PFN_UP((unsigned long)base + text_size);
-		end_pfn = PFN_UP((unsigned long)base + total_size);
+	/* Do not protect first partial page.  Always protect last page. */
+	begin_pfn = PFN_UP((unsigned long)base + text_size);
+	end_pfn = PFN_UP((unsigned long)base + total_size);
 
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
-	}
+	DEBUGP("  NX: 0x%lx %lu\n",
+	       begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
+	set_memory_nx(begin_pfn << PAGE_SHIFT, end_pfn - begin_pfn);
 }
 
 /* Setting memory back to RW+NX before releasing it */



