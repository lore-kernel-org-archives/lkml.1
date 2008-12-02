Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbYLBCNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbYLBCNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 21:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYLBCNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 21:13:43 -0500
Received: from ozlabs.org ([203.10.76.45]:33417 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbYLBCNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 21:13:42 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC 5/8] param: arch_get_boot_command_line()
Date: Tue, 2 Dec 2008 12:43:37 +1030
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
References: <200812012326.03151.rusty@rustcorp.com.au> <20081201131807.GD28971@flint.arm.linux.org.uk>
In-Reply-To: <20081201131807.GD28971@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812021243.38862.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2008 23:48:07 Russell King wrote:
> So there's quite a bit which needs to be done to get at the command line.
> Basically, what's required is:
>
> - convert param struct to tag list
> - if no tag list, use default tag list
> - run machine specific fixups which may set memory layout
> - if memory layout has been set, kill off any memory atags to prevent it
>   being overwritten
> - parse all atags which includes setting the command line if such a tag
>   is found
>
> Then, and only then can you be sure that you have the right command line.

   Thanks for the clue donation.  I've read the code harder now.  Tricky.

OK, I think this is close.  I'll grab a cross-compiler and build test at
least, and do a followup patch to switch those __early_param() to core_param
which will simplify this a little.  I'll revert the cmdline() separation now
too, since it's unnecessary, but I have to go run errands for the rest of the
day :(

A couple of #if 0 around code I don't think can happen (even in the orignal
place I moved it from?)

Thanks!
Rusty.

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
+static void __init parse_cmdline(const char *from)
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
@@ -673,18 +673,14 @@ static int __init customize_machine(void
 }
 arch_initcall(customize_machine);
 
-void __init setup_arch(char **cmdline_p)
+/* We not only get the command line here, we parse the tags as well. */
+void arch_get_boot_command_line(void)
 {
 	struct tag *tags = (struct tag *)&init_tags;
 	struct machine_desc *mdesc;
-	char *from;
 
 	setup_processor();
 	mdesc = setup_machine(machine_arch_type);
-	machine_name = mdesc->name;
-
-	if (mdesc->soft_reboot)
-		reboot_setup("s");
 
 	if (__atags_pointer)
 		tags = phys_to_virt(__atags_pointer);
@@ -697,32 +693,48 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	if (tags->hdr.tag != ATAG_CORE)
 		convert_to_tag_list(tags);
+#if 0
 	if (tags->hdr.tag != ATAG_CORE)
 		tags = (struct tag *)&init_tags;
+#endif
+
+	if (mdesc->fixup)
+		mdesc->fixup(mdesc, tags, &meminfo);
+
+#if 0
+	if (tags->hdr.tag == ATAG_CORE) {
+#endif
+		if (meminfo.nr_banks != 0)
+			squash_mem_tags(tags);
+		save_atags(tags);
+		parse_tags(tags);
+#if 0
+	}
+#endif
 
 	if (mdesc->cmdline)
 		from = mdesc->cmdline();
 	else
 		from = default_command_line;
 
-	if (mdesc->fixup)
-		mdesc->fixup(mdesc, tags, &meminfo);
+	/* This copies into boot_command_line */
+	parse_cmdline(from);
+}
 
-	if (tags->hdr.tag == ATAG_CORE) {
-		if (meminfo.nr_banks != 0)
-			squash_mem_tags(tags);
-		save_atags(tags);
-		parse_tags(tags);
-	}
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
 

