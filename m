Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbXLDNt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbXLDNt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXLDNts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:49:48 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:64327 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXLDNtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:49:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=yFUpKd9G3iRDwn5r3lxGKbqu/jlVnIRon8dVl1bDa9MS4M8u4jAmZRdZpdSdckL9dllcoKR0PfYcl2TsiMbUpFNDWqRtvIhmJsdNTH2A9gkl5BZ1PS1+9igflMJDYYQET77j7FqoSIyscLkGB8UOssPOwofaSdxOgkODmnjaDbw=
Message-ID: <47555AF1.8090304@gmail.com>
Date: Tue, 04 Dec 2007 22:49:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: sam@ravnborg.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       notting@redhat.com, rusty@rustcorp.com.au, kay.sievers@vrfy.org,
       greg@kroah.com
Subject: [PATCH] kbuild: implement modules.order
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When multiple built-in modules (especially drivers) provide the same
capability, they're prioritized by link order specified by the order
listed in Makefile.  This implicit ordering is lost for loadable
modules.

When driver modules are loaded by udev, what comes first in
modules.alias file is selected.  However, the order in this file is
indeterministic (depends on filesystem listing order of installed
modules).  This causes confusion.

The solution is two-parted.  This patch updates kbuild such that it
generates and installs modules.order which contains the name of
modules ordered according to Makefile.  The second part is update to
depmod such that it generates output files according to this file.

Note that both obj-y and obj-m subdirs can contain modules and
ordering information between those two are lost from beginning.
Currently obj-y subdirs are put before obj-m subdirs.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Bill Nottingham <notting@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 Makefile               |    5 ++
 scripts/Makefile       |    1 
 scripts/Makefile.build |   16 +++++++-
 scripts/Makefile.lib   |   10 +++++
 scripts/remove-dup.c   |   98 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index a65ffd2..1c020c7 100644
--- a/Makefile
+++ b/Makefile
@@ -311,6 +311,7 @@ DEPMOD		= /sbin/depmod
 KALLSYMS	= scripts/kallsyms
 PERL		= perl
 CHECK		= sparse
+REMOVE_DUP	= scripts/remove-dup
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise $(CF)
 MODFLAGS	= -DMODULE
@@ -1023,6 +1024,7 @@ all: modules
 
 PHONY += modules
 modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
+	@$(REMOVE_DUP) $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
 	@echo '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
 
@@ -1050,6 +1052,7 @@ _modinst_:
 		rm -f $(MODLIB)/build ; \
 		ln -s $(objtree) $(MODLIB)/build ; \
 	fi
+	@cp -f $(objtree)/modules.order $(MODLIB)/
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modinst
 
 # This depmod is only for convenience to give the initial
@@ -1109,7 +1112,7 @@ clean: archclean $(clean-dirs)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' \) \
+		-o -name '*.symtypes' -o -name 'modules.order' \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
diff --git a/scripts/Makefile b/scripts/Makefile
index 1c73c5a..1c82547 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -12,6 +12,7 @@ hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_PROM_CONSOLE) += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
+hostprogs-$(CONFIG_MODULES)	 += remove-dup
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index de9836e..816a955 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -83,10 +83,12 @@ ifneq ($(strip $(obj-y) $(obj-m) $(obj-n) $(obj-) $(lib-target)),)
 builtin-target := $(obj)/built-in.o
 endif
 
+modorder-target := $(obj)/modules.order
+
 # We keep a list of all modules in $(MODVERDIR)
 
 __build: $(if $(KBUILD_BUILTIN),$(builtin-target) $(lib-target) $(extra-y)) \
-	 $(if $(KBUILD_MODULES),$(obj-m)) \
+	 $(if $(KBUILD_MODULES),$(obj-m) $(modorder-target)) \
 	 $(subdir-ym) $(always)
 	@:
 
@@ -276,6 +278,18 @@ targets += $(builtin-target)
 endif # builtin-target
 
 #
+# Rule to create modules.order file
+#
+$(modorder-target): $(subdir-ym) FORCE
+	@{ for m in $(modorder); do				\
+		if echo $$m | grep -q '.*/modules.order'; then	\
+			cat $$m;				\
+		else						\
+			echo kernel/$$m;			\
+		fi;						\
+	done } > $@
+
+#
 # Rule to compile a set of .o files into one .a file
 #
 ifdef lib-target
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 3c5e88b..4563c96 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -25,6 +25,15 @@ lib-y := $(filter-out $(obj-y), $(sort $(lib-y) $(lib-m)))
 # o if we encounter foo/ in $(obj-m), remove it from $(obj-m) 
 #   and add the directory to the list of dirs to descend into: $(subdir-m)
 
+# make sure '/' follows subdirs
+subdir-y	:= $(patsubst %//,%/, $(addsuffix, /,$subdir-y))
+subdir-m	:= $(patsubst %//,%/, $(addsuffix, /,$subdir-m))
+
+# Determine modorder.  Both -y and -m subdirs can contain modules and
+# unfortunately we don't have information about ordering between -y
+# and -m subdirs.  Just put -y's first.
+modorder	:= $(patsubst %/,%/modules.order, $(subdir-y) $(subdir-m) $(filter %/, $(obj-y)) $(obj-m:.o=.ko))
+
 __subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
 subdir-y	+= $(__subdir-y)
 __subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
@@ -64,6 +73,7 @@ real-objs-m := $(foreach m, $(obj-m), $(if $(strip $($(m:.o=-objs)) $($(m:.o=-y)
 extra-y		:= $(addprefix $(obj)/,$(extra-y))
 always		:= $(addprefix $(obj)/,$(always))
 targets		:= $(addprefix $(obj)/,$(targets))
+modorder	:= $(addprefix $(obj)/,$(modorder))
 obj-y		:= $(addprefix $(obj)/,$(obj-y))
 obj-m		:= $(addprefix $(obj)/,$(obj-m))
 lib-y		:= $(addprefix $(obj)/,$(lib-y))
diff --git a/scripts/remove-dup.c b/scripts/remove-dup.c
new file mode 100644
index 0000000..3a7a402
--- /dev/null
+++ b/scripts/remove-dup.c
@@ -0,0 +1,98 @@
+/*
+ * remove-dup - Drop duplicate lines from unsorted input files
+ *
+ * Dec 2007 Tejun Heo <teheo@suse.de>
+ *
+ * This software is released under GPLv2.
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+
+struct hash_ent {
+	struct hash_ent *next;
+	char str[];
+};
+
+#define fatal(fmt, args...)	do {		\
+		fprintf(stderr, fmt , ##args);	\
+		exit(1);			\
+	} while (0)
+
+static inline unsigned int sdb_hash(const char *str)
+{
+        unsigned int hash = 0;
+        int c;
+
+        while ((c = *str++))
+		hash = c + (hash << 6) + (hash << 16) - hash;
+
+        return hash;
+}
+
+int main(int argc, char **argv)
+{
+	unsigned int nr_entries = 0;
+	struct hash_ent **hash_tbl;
+	char line[10240];
+	int i;
+
+	/* first pass, count lines */
+	for (i = 1; i < argc; i++) {
+		FILE *fp = fopen(argv[i], "r");
+
+		if (!fp)
+			fatal("failed to open %s for reading\n", argv[i]);
+
+		while (fgets(line, sizeof(line), fp))
+			nr_entries++;
+
+		fclose(fp);
+	}
+
+	nr_entries = nr_entries * 10 / 8;
+	hash_tbl = calloc(nr_entries, sizeof(struct hash_ent *));
+	if (!hash_tbl)
+		fatal("failed to allocate hash table for %u entries\n",
+		      nr_entries);
+
+	/* second pass, hash and print unique lines */
+	for (i = 1; i < argc; i++) {
+		FILE *fp = fopen(argv[i], "r");
+
+		if (!fp)
+			fatal("failed to open %s for reading\n", argv[i]);
+
+		while (fgets(line, sizeof(line), fp)) {
+			int len = strlen(line);
+			struct hash_ent **ppos, *new_ent;
+
+			if (line[len - 1] == '\n')
+				line[--len] = '\0';
+
+			ppos = hash_tbl + (sdb_hash(line) % nr_entries);
+			while (*ppos) {
+				if (strcmp((*ppos)->str, line) == 0)
+					break;
+				ppos = &(*ppos)->next;
+			}
+			if (*ppos)
+				continue;
+
+			new_ent = malloc(sizeof(struct hash_ent) + len + 1);
+			if (!new_ent)
+				fatal("failed to allocate hash entry\n");
+			new_ent->next = NULL;
+			memcpy(new_ent->str, line, len + 1);
+
+			*ppos = new_ent;
+
+			printf("%s\n", line);
+		}
+
+		fclose(fp);
+	}
+
+	return 0;
+}
