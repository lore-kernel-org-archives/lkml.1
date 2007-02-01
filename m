Return-Path: <linux-kernel-owner+w=401wt.eu-S1423018AbXBAVVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423018AbXBAVVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423019AbXBAVVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:21:42 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:44289 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423018AbXBAVVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:21:40 -0500
Date: Thu, 1 Feb 2007 22:20:09 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] Ban module license tag string termination trick
In-Reply-To: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ccs, hello list,



Finally a follow-up to the thread http://lkml.org/lkml/2006/11/1/170



___Abstract___

Proposed patch to prohibit loading modules that use early C string 
termination ("GPL\0 for nothing, folks!") to trick the kernel believing 
it is loading a GPL driver.


___Implementation___

Modules have an ELF section called ".modinfo" which is made up of a 
concatenation of NUL-terminated strings (tags) of the form 
"keyword=contents". When a vendor with bad intent uses 
MODULE_LICENSE("GPL\0 for nothing"), the resulting modinfo data that 
will be written to the object file will be "license=GPL\0for nothing\0". 
When this is interpreted back again in the kernel module loader, it is 
read as "license=GPL", having circumvented the loading mechanism and 
having wrongfully access to GPL symbols. According to Alexey [ 
http://lkml.org/lkml/2006/10/27/233 ], LinuxAnt is one vendor to use 
this trick.

To work against this problem, we must store the length of the actual 
string as the compiler knows it. This will become really cumbersome if 
implemented as a new tag inside the modinfo section. Hence I chose the 
way of adding a new section called ".modlicense". The length of the new 
section's header will automatically be the string length [including 
trailing NUL]. The module loading code then just has to compare the 
section length with the string length as returned by strlen().

A side effect of this patch will be that having multiple 
MODULE_LICENSE() in a kernel module will break, since all the strings 
that are specified with MODULE_LICENSE() get concatenated into the 
modlicense section. This would lead to section data that could look like 
"foo\0bar\0", and hence fails the section_length vs strlen check. 
Putting multiple MODULE_LICENSE() in a module (.ko) does not make sense 
either, because if there is at least one GPL component, it becomes a 
combined work, [insert more GPL interpretation here]. So it is better to 
just deny loading such strange modules too.

A separate patch is required for module-init-tools (m-i-t) to make the 
"modinfo" userspace utility understand the new modlicense section. I do 
not think the world will explode if someone runs an unpatched m-i-t with 
a patched kernel. The m-i-t patch will be posted as a reply to this 
message containing the kernel patch.


___The kernel patch___

Just a few notes here.

  *	The patch moves MODULE_LICENSE() from module.h to moduleparam.h
	because __module_cat is needed. Not strictly, but having __LINE__ as
	part of the symbol name seems nice.

  *	The set_license() function in kernel/module.c has
	been changed to use the section. If no such section exists, i.e. no
	MODULE_LICENSE() was present in any of the .c files that make up a
	module, the behavior is the same as usual, i.e. "unspecified" license,
	leading to a tainted kernel.

  *	strnlen() is used in case someone gets the naughty idea to produce a
	faulty module that does not have the section data NUL-terminated.

  *	I was not sure what error code to return. -EPERM would have been cool
	("You are not allowed to load a module that plays source tricks"), but
	I went with a more neutral -EINVAL for now.

  *	I hope the "goto cleanup" is the right jump target.


Comments welcome.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

# modlicense-kernel.diff
Index: linux-2.6.20-rc7/include/linux/module.h
===================================================================
--- linux-2.6.20-rc7.orig/include/linux/module.h
+++ linux-2.6.20-rc7/include/linux/module.h
@@ -95,36 +95,6 @@ extern struct module __this_module;
 /* For userspace: you can also call me... */
 #define MODULE_ALIAS(_alias) MODULE_INFO(alias, _alias)
 
-/*
- * The following license idents are currently accepted as indicating free
- * software modules
- *
- *	"GPL"				[GNU Public License v2 or later]
- *	"GPL v2"			[GNU Public License v2]
- *	"GPL and additional rights"	[GNU Public License v2 rights and more]
- *	"Dual BSD/GPL"			[GNU Public License v2
- *					 or BSD license choice]
- *	"Dual MIT/GPL"			[GNU Public License v2
- *					 or MIT license choice]
- *	"Dual MPL/GPL"			[GNU Public License v2
- *					 or Mozilla license choice]
- *
- * The following other idents are available
- *
- *	"Proprietary"			[Non free products]
- *
- * There are dual licensed components, but when running with Linux it is the
- * GPL that is relevant so this is a non issue. Similarly LGPL linked with GPL
- * is a GPL combined work.
- *
- * This exists for several reasons
- * 1.	So modinfo can show license info for users wanting to vet their setup 
- *	is free
- * 2.	So the community can ignore bug reports including proprietary modules
- * 3.	So vendors can do likewise based on their own policies
- */
-#define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
-
 /* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>] */
 #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
   
Index: linux-2.6.20-rc7/include/linux/moduleparam.h
===================================================================
--- linux-2.6.20-rc7.orig/include/linux/moduleparam.h
+++ linux-2.6.20-rc7/include/linux/moduleparam.h
@@ -20,8 +20,44 @@
 static const char __module_cat(name,__LINE__)[]				  \
   __attribute_used__							  \
   __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
+
+/*
+ * The following license idents are currently accepted as indicating free
+ * software modules
+ *
+ *	"GPL"				[GNU Public License v2 or later]
+ *	"GPL v2"			[GNU Public License v2]
+ *	"GPL and additional rights"	[GNU Public License v2 rights and more]
+ *	"Dual BSD/GPL"			[GNU Public License v2
+ *					 or BSD license choice]
+ *	"Dual MIT/GPL"			[GNU Public License v2
+ *					 or MIT license choice]
+ *	"Dual MPL/GPL"			[GNU Public License v2
+ *					 or Mozilla license choice]
+ *
+ * The following other idents are available
+ *
+ *	"Proprietary"			[Non free products]
+ *
+ * There are dual licensed components, but when running with Linux it is the
+ * GPL that is relevant so this is a non issue. Similarly LGPL linked with GPL
+ * is a GPL combined work.
+ *
+ * This exists for several reasons
+ * 1.	So modinfo can show license info for users wanting to vet their setup
+ *	is free
+ * 2.	So the community can ignore bug reports including proprietary modules
+ * 3.	So vendors can do likewise based on their own policies
+ */
+#define MODULE_LICENSE(_license) \
+	static const char __module_cat(name, __LINE__)[] \
+	__attribute_used__ \
+	__attribute__((section(".modlicense"), unused)) = \
+	(_license)
+
 #else  /* !MODULE */
 #define __MODULE_INFO(tag, name, info)
+#define MODULE_LICENSE(_license)
 #endif
 #define __MODULE_PARM_TYPE(name, _type)					  \
   __MODULE_INFO(parmtype, name##type, #name ":" _type)
Index: linux-2.6.20-rc7/kernel/module.c
===================================================================
--- linux-2.6.20-rc7.orig/kernel/module.c
+++ linux-2.6.20-rc7/kernel/module.c
@@ -1389,10 +1389,21 @@ static void layout_sections(struct modul
 	}
 }
 
-static void set_license(struct module *mod, const char *license)
+static int set_license(struct module *mod, Elf_Shdr *sechdr)
 {
-	if (!license)
-		license = "unspecified";
+	const char *license = "unspecified";
+
+	if(sechdr != NULL) {
+		license = (const char *)sechdr->sh_addr;
+
+		/* Allow both non-terminated strings and NUL-terminated
+		strings, as long as no string termination trick is done. */
+		if(strnlen(license, sechdr->sh_size) + 1 != sechdr->sh_size) {
+			printk(KERN_WARNING "Module \"%s\" has invalid "
+			       ".modlicense section\n", mod->name);
+			return -EINVAL;
+		}
+	}
 
 	if (!license_is_gpl_compatible(license)) {
 		if (!(tainted & TAINT_PROPRIETARY_MODULE))
@@ -1400,6 +1411,8 @@ static void set_license(struct module *m
 				"kernel.\n", mod->name, license);
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 	}
+
+	return 0;
 }
 
 /* Parse tag=value strings from .modinfo section */
@@ -1549,6 +1562,7 @@ static struct module *load_module(void _
 	unsigned int modindex;
 	unsigned int obsparmindex;
 	unsigned int infoindex;
+	unsigned int license_index;
 	unsigned int gplindex;
 	unsigned int crcindex;
 	unsigned int gplcrcindex;
@@ -1653,6 +1667,7 @@ static struct module *load_module(void _
 	obsparmindex = find_sec(hdr, sechdrs, secstrings, "__obsparm");
 	versindex = find_sec(hdr, sechdrs, secstrings, "__versions");
 	infoindex = find_sec(hdr, sechdrs, secstrings, ".modinfo");
+	license_index = find_sec(hdr, sechdrs, secstrings, ".modlicense");
 	pcpuindex = find_pcpusec(hdr, sechdrs, secstrings);
 #ifdef ARCH_UNWIND_SECTION_NAME
 	unwindex = find_sec(hdr, sechdrs, secstrings, ARCH_UNWIND_SECTION_NAME);
@@ -1660,6 +1675,8 @@ static struct module *load_module(void _
 
 	/* Don't keep modinfo section */
 	sechdrs[infoindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
+	if(license_index)
+		sechdrs[license_index].sh_flags &= ~SHF_ALLOC;
 #ifdef CONFIG_KALLSYMS
 	/* Keep symbol and string tables for decoding later. */
 	sechdrs[symindex].sh_flags |= SHF_ALLOC;
@@ -1769,7 +1786,10 @@ static struct module *load_module(void _
 	module_unload_init(mod);
 
 	/* Set up license info based on the info section */
-	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
+	err = set_license(mod, (license_index != 0) ?
+	      &sechdrs[license_index] : NULL);
+	if(err)
+		goto cleanup;
 
 	if (strcmp(mod->name, "ndiswrapper") == 0)
 		add_taint(TAINT_PROPRIETARY_MODULE);
#<EOF>
