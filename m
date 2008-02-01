Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbYBAW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbYBAW5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbYBAW5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:57:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:49355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbYBAW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:57:30 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Fri, 1 Feb 2008 17:55:30 -0500
User-Agent: KMail/1.9.5
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>,
       Mika Penttil? <mika.penttila@kolumbus.fi>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200802011528.17423.rjw@sisk.pl> <20080201145436.GA19653@elte.hu>
In-Reply-To: <20080201145436.GA19653@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011755.31263.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 09:54, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > no strong preference here - pick the one you like best and send a 
> > > patch please :-)
> > 
> > Here you go, but I think it falls into the ACPI category.
> 
> agreed - Len, would you mind to pick this patch up?

This won't work as written -- for the ACPI code doesn't currently optimize
for the HIBERNATE && ! SUSPEND case, and so both code paths are under ACPI_SLEEP.

While some day there may be a justification to make that optimization,
this isn't the day, and this isn't the patch.

So Rafael and I talked about it and decided to go with the simpler
patch below -- which I'll push.

thanks,
-Len

---
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index da524fb..f2f36f8 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -423,23 +423,23 @@ static void __init pagetable_init(void)
 	paravirt_pagetable_setup_done(pgd_base);
 }
 
-#if defined(CONFIG_HIBERNATION) || defined(CONFIG_ACPI)
+#ifdef CONFIG_ACPI_SLEEP
 /*
- * Swap suspend & friends need this for resume because things like the intel-agp
+ * ACPI suspend needs this for resume, because things like the intel-agp
  * driver might have split up a kernel 4MB mapping.
  */
-char __nosavedata swsusp_pg_dir[PAGE_SIZE]
+char swsusp_pg_dir[PAGE_SIZE]
 	__attribute__ ((aligned(PAGE_SIZE)));
 
 static inline void save_pg_dir(void)
 {
 	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
 }
-#else
+#else /* !CONFIG_ACPI_SLEEP */
 static inline void save_pg_dir(void)
 {
 }
-#endif
+#endif /* !CONFIG_ACPI_SLEEP */
 
 void zap_low_mappings(void)
 {
