Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbXG2EvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbXG2EvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 00:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXG2EvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 00:51:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbXG2Eu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 00:50:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add /sys/module/name/notes
X-Fcc: ~/Mail/linus
Emacs: the prosecution rests its case.
Message-Id: <20070729045022.9EB3B4D058D@magilla.localdomain>
Date: Sat, 28 Jul 2007 21:50:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds the /sys/module/<name>/notes/ magic directory, which has
a file for each allocated SHT_NOTE section that appears in <name>.ko.
This is the counterpart for each module of /sys/kernel/notes for vmlinux.
Reading this delivers the contents of the module's SHT_NOTE sections.
This lets userland easily glean any detailed information about that
module's build that was stored there at compile time (e.g. by ld --build-id).

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/module.h |    3 +
 kernel/module.c        |  106 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index b6a646c..65d0752 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -346,6 +346,9 @@ struct module
 
 	/* Section attributes */
 	struct module_sect_attrs *sect_attrs;
+
+	/* Notes attributes */
+	struct module_notes_attrs *notes_attrs;
 #endif
 
 	/* Per-cpu data. */
diff --git a/kernel/module.c b/kernel/module.c
index 33c04ad..d7bbe1a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -20,6 +20,7 @@
 #include <linux/moduleloader.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
+#include <linux/sysfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -1054,6 +1055,100 @@ static void remove_sect_attrs(struct module *mod)
 	}
 }
 
+/*
+ * /sys/module/foo/notes/.section.name gives contents of SHT_NOTE sections.
+ */
+
+struct module_notes_attrs {
+	struct kobject *dir;
+	unsigned int notes;
+	struct bin_attribute attrs[0];
+};
+
+static ssize_t module_notes_read(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t count)
+{
+	/*
+	 * The caller checked the pos and count against our size.
+	 */
+	memcpy(buf, bin_attr->private + pos, count);
+	return count;
+}
+
+static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
+			     unsigned int i)
+{
+	if (notes_attrs->dir) {
+		while (i-- > 0)
+			sysfs_remove_bin_file(notes_attrs->dir,
+					      &notes_attrs->attrs[i]);
+		kobject_del(notes_attrs->dir);
+	}
+	kfree(notes_attrs);
+}
+
+static void add_notes_attrs(struct module *mod, unsigned int nsect,
+			    char *secstrings, Elf_Shdr *sechdrs)
+{
+	unsigned int notes, loaded, i;
+	struct module_notes_attrs *notes_attrs;
+	struct bin_attribute *nattr;
+
+	/* Count notes sections and allocate structures.  */
+	notes = 0;
+	for (i = 0; i < nsect; i++)
+		if ((sechdrs[i].sh_flags & SHF_ALLOC) &&
+		    (sechdrs[i].sh_type == SHT_NOTE))
+			++notes;
+
+	if (notes == 0)
+		return;
+
+	notes_attrs = kzalloc(sizeof(*notes_attrs)
+			      + notes * sizeof(notes_attrs->attrs[0]),
+			      GFP_KERNEL);
+	if (notes_attrs == NULL)
+		return;
+
+	notes_attrs->notes = notes;
+	nattr = &notes_attrs->attrs[0];
+	for (loaded = i = 0; i < nsect; ++i) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+		if (sechdrs[i].sh_type == SHT_NOTE) {
+			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
+			nattr->attr.mode = S_IRUGO;
+			nattr->size = sechdrs[i].sh_size;
+			nattr->private = (void *) sechdrs[i].sh_addr;
+			nattr->read = module_notes_read;
+			++nattr;
+		}
+		++loaded;
+	}
+
+	notes_attrs->dir = kobject_add_dir(&mod->mkobj.kobj, "notes");
+	if (!notes_attrs->dir)
+		goto out;
+
+	for (i = 0; i < notes; ++i)
+		if (sysfs_create_bin_file(notes_attrs->dir,
+					  &notes_attrs->attrs[i]))
+			goto out;
+
+	mod->notes_attrs = notes_attrs;
+	return;
+
+  out:
+	free_notes_attrs(notes_attrs, i);
+}
+
+static void remove_notes_attrs(struct module *mod)
+{
+	if (mod->notes_attrs)
+		free_notes_attrs(mod->notes_attrs, mod->notes_attrs->notes);
+}
+
 #else
 
 static inline void add_sect_attrs(struct module *mod, unsigned int nsect,
@@ -1064,6 +1159,15 @@ static inline void add_sect_attrs(struct module *mod, unsigned int nsect,
 static inline void remove_sect_attrs(struct module *mod)
 {
 }
+
+static inline void add_notes_attrs(struct module *mod, unsigned int nsect,
+				   char *sectstrings, Elf_Shdr *sechdrs)
+{
+}
+
+static inline void remove_notes_attrs(struct module *mod)
+{
+}
 #endif /* CONFIG_KALLSYMS */
 
 #ifdef CONFIG_SYSFS
@@ -1198,6 +1302,7 @@ static void free_module(struct module *mod)
 {
 	/* Delete from various lists */
 	stop_machine_run(__unlink_module, mod, NR_CPUS);
+	remove_notes_attrs(mod);
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
@@ -1925,6 +2030,7 @@ static struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto arch_cleanup;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
 	/* Size of section 0 is 0, so this works well if no unwind info. */
 	mod->unwind_info = unwind_add_table(mod,
