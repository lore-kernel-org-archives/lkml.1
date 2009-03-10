Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZCJJhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZCJJhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZCJJhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:37:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbZCJJhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:37:21 -0400
Subject: Re: [PATCH] x86: suggest running a 64bit kernel on LM capable
 machines with plenty memory.
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090309191504.GB11935@one.firstfloor.org>
References: <49B254C6.8010507@pardus.org.tr>
	 <20090307193026.GA2165@x200.localdomain> <49B2CE44.4060305@pardus.org.tr>
	 <87r617ojfi.fsf@firstfloor.org> <1236606168.8389.512.camel@laptop>
	 <20090309191504.GB11935@one.firstfloor.org>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 10:37:08 +0100
Message-Id: <1236677828.25234.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 20:15 +0100, Andi Kleen wrote:
> > How about we do the below as well?
> 
> Idea looks good, but with your patch it would print two conflicting
> messages ("use highmem64. No, use 64bit instead"), wouldn't it? 
> Only one would be better.

Something like the below?


---
 arch/x86/mm/init_32.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 34ef5c7..e759107 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -713,13 +713,19 @@ void __init lowmem_pfn_init(void)
 	"only %luMB highmem pages available, ignoring highmem size of %luMB!\n"
 
 #define MSG_HIGHMEM_TRIMMED \
-	"Warning: only 4GB will be used. Use a HIGHMEM64G enabled kernel!\n"
+	"Warning: only 4GB will be used. Use a %s kernel!\n"
+
+#define MSG_LM_TRIMMED \
+	"Warning: instead of using a 32bit %s kernel, Use a 64bit kernel!\n"
+
+
 /*
  * We have more RAM than fits into lowmem - we try to put it into
  * highmem, also taking the highmem=x boot parameter into account:
  */
 void __init highmem_pfn_init(void)
 {
+	char *highmem;
 	max_low_pfn = MAXMEM_PFN;
 
 	if (highmem_pages == -1)
@@ -737,16 +743,28 @@ void __init highmem_pfn_init(void)
 #ifndef CONFIG_HIGHMEM
 	/* Maximum memory usable is what is directly addressable */
 	printk(KERN_WARNING "Warning only %ldMB will be used.\n", MAXMEM>>20);
+
 	if (max_pfn > MAX_NONPAE_PFN)
-		printk(KERN_WARNING "Use a HIGHMEM64G enabled kernel.\n");
+		highmem = "HIGHMEM64G";
 	else
-		printk(KERN_WARNING "Use a HIGHMEM enabled kernel.\n");
+		highmem = "HIGHMEM";
+
+	if (boot_cpu_has(X86_FEATURE_LM))
+		printk(KERN_WARNING MSG_LM_TRIMMED, highmem);
+	else 
+		printk(KERN_WARNING "Use a %s enabled kernel.\n", highmem);
+
 	max_pfn = MAXMEM_PFN;
 #else /* !CONFIG_HIGHMEM */
 #ifndef CONFIG_HIGHMEM64G
 	if (max_pfn > MAX_NONPAE_PFN) {
 		max_pfn = MAX_NONPAE_PFN;
-		printk(KERN_WARNING MSG_HIGHMEM_TRIMMED);
+		if (boot_cpu_has(X86_FEATURE_LM))
+			highmem = "64bit";
+		else
+			highmem = "HIGHMEM64G enabled";
+
+		printk(KERN_WARNING MSG_HIGHMEM_TRIMMED, highmem);
 	}
 #endif /* !CONFIG_HIGHMEM64G */
 #endif /* !CONFIG_HIGHMEM */


