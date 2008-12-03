Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYLCAmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYLCAmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbYLCAmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:42:10 -0500
Received: from ozlabs.org ([203.10.76.45]:40062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbYLCAmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:42:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line()
Date: Wed, 3 Dec 2008 11:11:51 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
References: <200812012326.03151.rusty@rustcorp.com.au> <200812021243.38862.rusty@rustcorp.com.au> <20081202174457.GA26005@flint.arm.linux.org.uk>
In-Reply-To: <20081202174457.GA26005@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031112.00939.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008 04:14:57 Russell King wrote:
> On Tue, Dec 02, 2008 at 12:43:37PM +1030, Rusty Russell wrote:
> > A couple of #if 0 around code I don't think can happen (even in the
> > orignal place I moved it from?)
>
> Looking at just those...
>
> > @@ -697,32 +693,48 @@ void __init setup_arch(char **cmdline_p)
> >  	 */
> >  	if (tags->hdr.tag != ATAG_CORE)
> >  		convert_to_tag_list(tags);
> > +#if 0
> >  	if (tags->hdr.tag != ATAG_CORE)
> >  		tags = (struct tag *)&init_tags;
> > +#endif
>
> This prevents 'init_tags' from ever being used, which wil happen if
> convert_to_tag_list() doesn't find a param_struct to convert.

Ah, I missed this test in convert_to_tag_list:

	if (params->u1.s.page_size != PAGE_SIZE) {
		printk(KERN_WARNING "Warning: bad configuration page, "
		       "trying to continue\n");
		return;
	}

Here's the new arm version, followed by an __early_param conversion.
Compile-tested only.

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -115,7 +115,6 @@ static struct meminfo meminfo __initdata
 static struct meminfo meminfo __initdata = { 0, };
 static const char *cpu_name;
 static const char *machine_name;
-static char __initdata command_line[COMMAND_LINE_SIZE];
 
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 static union { char c[4]; unsigned long l; } endian_test __initdata = { { 'l', '?', '?', 'b' 
} };
@@ -414,10 +413,12 @@ __early_param("mem=", early_mem);
 
 /*
  * Initial parsing of the command line.
+ * FIXME: Use generic core_param.  This actually removes args from the
+ * cmdline as seen in /proc!
  */
-static void __init parse_cmdline(char **cmdline_p, char *from)
+static void __init parse_cmdline(char *from)
 {
-	char c = ' ', *to = command_line;
+	char c = ' ', *to = boot_command_line;
 	int len = 0;
 
 	for (;;) {
@@ -429,7 +430,7 @@ static void __init parse_cmdline(char **
 				int arglen = strlen(p->arg);
 
 				if (memcmp(from, p->arg, arglen) == 0) {
-					if (to != command_line)
+					if (to != boot_command_line)
 						to -= 1;
 					from += arglen;
 					p->fn(&from);
@@ -448,7 +449,6 @@ static void __init parse_cmdline(char **
 		*to++ = c;
 	}
 	*to = '\0';
-	*cmdline_p = command_line;
 }
 
 static void __init
@@ -673,7 +673,8 @@ static int __init customize_machine(void
 }
 arch_initcall(customize_machine);
 
-void __init setup_arch(char **cmdline_p)
+/* We not only get the command line here, we parse the tags as well. */
+void __init arch_get_boot_command_line(void)
 {
 	struct tag *tags = (struct tag *)&init_tags;
 	struct machine_desc *mdesc;
@@ -681,10 +682,6 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_processor();
 	mdesc = setup_machine(machine_arch_type);
-	machine_name = mdesc->name;
-
-	if (mdesc->soft_reboot)
-		reboot_setup("s");
 
 	if (__atags_pointer)
 		tags = phys_to_virt(__atags_pointer);
@@ -703,21 +700,29 @@ void __init setup_arch(char **cmdline_p)
 	if (mdesc->fixup)
 		mdesc->fixup(mdesc, tags, &from, &meminfo);
 
-	if (tags->hdr.tag == ATAG_CORE) {
-		if (meminfo.nr_banks != 0)
-			squash_mem_tags(tags);
-		save_atags(tags);
-		parse_tags(tags);
-	}
+	if (meminfo.nr_banks != 0)
+		squash_mem_tags(tags);
+	save_atags(tags);
+	parse_tags(tags);
+
+	/* This copies into boot_command_line */
+	parse_cmdline(from);
+}
+
+void __init setup_arch(void)
+{
+	struct machine_desc *mdesc = setup_machine(machine_arch_type);
+
+	machine_name = mdesc->name;
+
+	if (mdesc->soft_reboot)
+		reboot_setup("s");
 
 	init_mm.start_code = (unsigned long) &_text;
 	init_mm.end_code   = (unsigned long) &_etext;
 	init_mm.end_data   = (unsigned long) &_edata;
 	init_mm.brk	   = (unsigned long) &_end;
 
-	memcpy(boot_command_line, from, COMMAND_LINE_SIZE);
-	boot_command_line[COMMAND_LINE_SIZE-1] = '\0';
-	parse_cmdline(cmdline_p, from);
 	paging_init(&meminfo, mdesc);
 	request_standard_resources(&meminfo, mdesc);
 
===
arm: use generic early_param

early_param() was inspired by arm's __early_param: now it's called earlier
in generic code, it can be used by arm as well.

This also allows us to get rid of default_command_line.

A possible cleanup would be to have fortunet_fixup do the strlcpy into
boot_command_line itself, and remove the &cmdline arg to ->fixup.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -220,18 +220,6 @@ struct meminfo {
 #define bank_phys_end(bank)	((bank)->start + (bank)->size)
 #define bank_phys_size(bank)	(bank)->size
 
-/*
- * Early command line parameters.
- */
-struct early_params {
-	const char *arg;
-	void (*fn)(char **p);
-};
-
-#define __early_param(name,fn)					\
-static struct early_params __early_##fn __used			\
-__attribute__((__section__(".early_param.init"))) = { name, fn }
-
 #endif  /*  __KERNEL__  */
 
 #endif
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -116,7 +116,6 @@ static const char *cpu_name;
 static const char *cpu_name;
 static const char *machine_name;
 
-static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 static union { char c[4]; unsigned long l; } endian_test __initdata = { { 'l', '?', '?', 'b' 
} };
 #define ENDIANNESS ((char)endian_test.l)
 
@@ -387,10 +386,13 @@ static void __init arm_add_memory(unsign
  * Pick out the memory size.  We look for mem=size@start,
  * where start and size are "size[KkMm]"
  */
-static void __init early_mem(char **p)
+static int __init early_mem(char *p)
 {
 	static int usermem __initdata = 0;
 	unsigned long size, start;
+
+	if (!p)
+		return -EINVAL;
 
 	/*
 	 * If the user specifies memory size, we
@@ -403,53 +405,14 @@ static void __init early_mem(char **p)
 	}
 
 	start = PHYS_OFFSET;
-	size  = memparse(*p, p);
-	if (**p == '@')
-		start = memparse(*p + 1, p);
+	size  = memparse(p, &p);
+	if (*p == '@')
+		start = memparse(p + 1, NULL);
 
 	arm_add_memory(start, size);
+	return 0;
 }
-__early_param("mem=", early_mem);
-
-/*
- * Initial parsing of the command line.
- * FIXME: Use generic core_param.  This actually removes args from the
- * cmdline as seen in /proc!
- */
-static void __init parse_cmdline(char *from)
-{
-	char c = ' ', *to = boot_command_line;
-	int len = 0;
-
-	for (;;) {
-		if (c == ' ') {
-			extern struct early_params __early_begin, __early_end;
-			struct early_params *p;
-
-			for (p = &__early_begin; p < &__early_end; p++) {
-				int arglen = strlen(p->arg);
-
-				if (memcmp(from, p->arg, arglen) == 0) {
-					if (to != boot_command_line)
-						to -= 1;
-					from += arglen;
-					p->fn(&from);
-
-					while (*from != ' ' && *from != '\0')
-						from++;
-					break;
-				}
-			}
-		}
-		c = *from++;
-		if (!c)
-			break;
-		if (COMMAND_LINE_SIZE <= ++len)
-			break;
-		*to++ = c;
-	}
-	*to = '\0';
-}
+early_param("mem", early_mem);
 
 static void __init
 setup_ramdisk(int doload, int prompt, int image_start, unsigned int rd_sz)
@@ -607,7 +570,7 @@ __tagtable(ATAG_REVISION, parse_tag_revi
 
 static int __init parse_tag_cmdline(const struct tag *tag)
 {
-	strlcpy(default_command_line, tag->u.cmdline.cmdline, COMMAND_LINE_SIZE);
+	strlcpy(boot_command_line, tag->u.cmdline.cmdline, COMMAND_LINE_SIZE);
 	return 0;
 }
 
@@ -678,7 +641,8 @@ void __init arch_get_boot_command_line(v
 {
 	struct tag *tags = (struct tag *)&init_tags;
 	struct machine_desc *mdesc;
-	char *from = default_command_line;
+
+	strcpy(boot_command_line, CONFIG_CMDLINE);
 
 	setup_processor();
 	mdesc = setup_machine(machine_arch_type);
@@ -697,16 +661,17 @@ void __init arch_get_boot_command_line(v
 	if (tags->hdr.tag != ATAG_CORE)
 		tags = (struct tag *)&init_tags;
 
-	if (mdesc->fixup)
+	if (mdesc->fixup) {
+		char *from = boot_command_line;
 		mdesc->fixup(mdesc, tags, &from, &meminfo);
+		if (from != boot_command_line)
+			strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);
+	}
 
 	if (meminfo.nr_banks != 0)
 		squash_mem_tags(tags);
 	save_atags(tags);
 	parse_tags(tags);
-
-	/* This copies into boot_command_line */
-	parse_cmdline(from);
 }
 
 void __init setup_arch(void)
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -45,9 +45,6 @@ SECTIONS
 		__setup_start = .;
 			*(.init.setup)
 		__setup_end = .;
-		__early_begin = .;
-			*(.early_param.init)
-		__early_end = .;
 		__initcall_start = .;
 			INITCALLS
 		__initcall_end = .;
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -29,19 +29,24 @@ static unsigned long phys_initrd_start _
 static unsigned long phys_initrd_start __initdata = 0;
 static unsigned long phys_initrd_size __initdata = 0;
 
-static void __init early_initrd(char **p)
+static int __init early_initrd(char *p)
 {
 	unsigned long start, size;
 
-	start = memparse(*p, p);
-	if (**p == ',') {
-		size = memparse((*p) + 1, p);
+	if (!p)
+		return -EINVAL;
 
-		phys_initrd_start = start;
-		phys_initrd_size = size;
-	}
+	start = memparse(p, &p);
+	if (*p != ',')
+		return -EINVAL;
+
+	size = memparse(p + 1, &p);
+
+	phys_initrd_start = start;
+	phys_initrd_size = size;
+	return 0;
 }
-__early_param("initrd=", early_initrd);
+early_param("initrd", early_initrd);
 
 static int __init parse_tag_initrd(const struct tag *tag)
 {
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -96,18 +96,21 @@ static struct cachepolicy cache_policies
  * writebuffer to be turned off.  (Note: the write
  * buffer should not be on and the cache off).
  */
-static void __init early_cachepolicy(char **p)
+static int __init early_cachepolicy(char *p)
 {
 	int i;
+
+	if (!p)
+		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(cache_policies); i++) {
 		int len = strlen(cache_policies[i].policy);
 
-		if (memcmp(*p, cache_policies[i].policy, len) == 0) {
+		if (memcmp(p, cache_policies[i].policy, len) == 0) {
 			cachepolicy = i;
 			cr_alignment &= ~cache_policies[i].cr_mask;
 			cr_no_alignment &= ~cache_policies[i].cr_mask;
-			*p += len;
+			p += len;
 			break;
 		}
 	}
@@ -119,36 +122,42 @@ static void __init early_cachepolicy(cha
 	}
 	flush_cache_all();
 	set_cr(cr_alignment);
+	return 0;
 }
-__early_param("cachepolicy=", early_cachepolicy);
+early_param("cachepolicy", early_cachepolicy);
 
-static void __init early_nocache(char **__unused)
+static int __init early_nocache(char *p)
 {
-	char *p = "buffered";
+	p = "buffered";
 	printk(KERN_WARNING "nocache is deprecated; use cachepolicy=%s\n", p);
-	early_cachepolicy(&p);
+	return early_cachepolicy(p);
 }
-__early_param("nocache", early_nocache);
+early_param("nocache", early_nocache);
 
-static void __init early_nowrite(char **__unused)
+static int __init early_nowrite(char *p)
 {
-	char *p = "uncached";
+	p = "uncached";
 	printk(KERN_WARNING "nowb is deprecated; use cachepolicy=%s\n", p);
-	early_cachepolicy(&p);
+	return early_cachepolicy(p);
 }
-__early_param("nowb", early_nowrite);
+early_param("nowb", early_nowrite);
 
-static void __init early_ecc(char **p)
+static int __init early_ecc(char *p)
 {
-	if (memcmp(*p, "on", 2) == 0) {
+	if (!p)
+		return -EINVAL;
+
+	if (memcmp(p, "on", 2) == 0) {
 		ecc_mask = PMD_PROTECTION;
-		*p += 2;
-	} else if (memcmp(*p, "off", 3) == 0) {
+		p += 2;
+	} else if (memcmp(p, "off", 3) == 0) {
 		ecc_mask = 0;
-		*p += 3;
-	}
+		p += 3;
+	} else
+		return -EINVAL;
+	return 0;
 }
-__early_param("ecc=", early_ecc);
+early_param("ecc", early_ecc);
 
 static int __init noalign_setup(char *__unused)
 {
@@ -636,9 +645,12 @@ static unsigned long __initdata vmalloc_
  * bytes. This can be used to increase (or decrease) the vmalloc
  * area - the default is 128m.
  */
-static void __init early_vmalloc(char **arg)
+static void __init early_vmalloc(char *arg)
 {
-	vmalloc_reserve = memparse(*arg, arg);
+	if (!arg)
+		return -EINVAL;
+
+	vmalloc_reserve = memparse(arg, &arg);
 
 	if (vmalloc_reserve < SZ_16M) {
 		vmalloc_reserve = SZ_16M;
@@ -646,8 +658,9 @@ static void __init early_vmalloc(char **
 			"vmalloc area too small, limiting to %luMB\n",
 			vmalloc_reserve >> 20);
 	}
+	return 0;
 }
-__early_param("vmalloc=", early_vmalloc);
+early_param("vmalloc", early_vmalloc);
 
 #define VMALLOC_MIN	(void *)(VMALLOC_END - vmalloc_reserve)
 




