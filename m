Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbZHIRph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbZHIRph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 13:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbZHIRpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 13:45:36 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:54558 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZHIRpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 13:45:36 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] OOPS in identify_cpu() on CPUs without CPUID
Date: Sun, 9 Aug 2009 19:45:25 +0200
User-Agent: KMail/1.9.10
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <200908081908.12240.linux@rainbow-software.org> <20090808175344.GA8099@elte.hu>
In-Reply-To: <20090808175344.GA8099@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908091945.29233.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 August 2009 19:53:44 Ingo Molnar wrote:
> * Ondrej Zary <linux@rainbow-software.org> wrote:
> > Kernel is broken for x86 CPUs without CPUID since 2.6.28. It
> > crashes with NULL pointer dereference in identify_cpu():
> >
> > 766        generic_identify(c);
> > 767
> > 768-->     if (this_cpu->c_identify)
> > 769                this_cpu->c_identify(c);
> >
> > this_cpu is NULL. This is because it's only initialized in
> > get_cpu_vendor() function, which is not called if the CPU has no
> > CPUID instruction.
>
> indeed ...
>
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > --- linux-2.6.30.4-orig/arch/x86/kernel/cpu/common.c	2009-06-10
> > 05:05:27.000000000 +0200 +++
> > linux-2.6.30.4-router/arch/x86/kernel/cpu/common.c	2009-08-08
> > 18:00:21.000000000 +0200 @@ -699,6 +699,7 @@
> >
> >  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
> >  {
> > +	this_cpu = &default_cpu;
> >  	c->extended_cpuid_level = 0;
> >
> >  	if (!have_cpuid_p())
>
> How about initializing this_cpu instead, via:
>
> static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
>
> ?
> 	Ingo

The new patch is not very nice as default_cpu has to be moved. Works fine.


Kernel is broken for x86 CPUs without CPUID since 2.6.28. It crashes with NULL
pointer dereference in identify_cpu():

766        generic_identify(c);
767
768-->     if (this_cpu->c_identify)
769                this_cpu->c_identify(c);

this_cpu is NULL. This is because it's only initialized in get_cpu_vendor()
function, which is not called if the CPU has no CPUID instruction.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
--- linux-2.6.30.4-orig/arch/x86/kernel/cpu/common.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30.4-router/arch/x86/kernel/cpu/common.c	2009-08-09 13:33:04.000000000 +0200
@@ -58,7 +58,30 @@
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
 }
 
-static const struct cpu_dev *this_cpu __cpuinitdata;
+static void __cpuinit default_init(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_64
+	display_cacheinfo(c);
+#else
+	/* Not much we can do here... */
+	/* Check if at least it has cpuid */
+	if (c->cpuid_level == -1) {
+		/* No cpuid. It must be an ancient CPU */
+		if (c->x86 == 4)
+			strcpy(c->x86_model_id, "486");
+		else if (c->x86 == 3)
+			strcpy(c->x86_model_id, "386");
+	}
+#endif
+}
+
+static const struct cpu_dev __cpuinitconst default_cpu = {
+	.c_init	= default_init,
+	.c_vendor = "Unknown",
+	.c_x86_vendor = X86_VENDOR_UNKNOWN,
+};
+
+static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #ifdef CONFIG_X86_64
@@ -330,29 +353,6 @@
 
 static const struct cpu_dev *__cpuinitdata cpu_devs[X86_VENDOR_NUM] = {};
 
-static void __cpuinit default_init(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_X86_64
-	display_cacheinfo(c);
-#else
-	/* Not much we can do here... */
-	/* Check if at least it has cpuid */
-	if (c->cpuid_level == -1) {
-		/* No cpuid. It must be an ancient CPU */
-		if (c->x86 == 4)
-			strcpy(c->x86_model_id, "486");
-		else if (c->x86 == 3)
-			strcpy(c->x86_model_id, "386");
-	}
-#endif
-}
-
-static const struct cpu_dev __cpuinitconst default_cpu = {
-	.c_init	= default_init,
-	.c_vendor = "Unknown",
-	.c_x86_vendor = X86_VENDOR_UNKNOWN,
-};
-
 static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;


-- 
Ondrej Zary
