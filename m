Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXDWFSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXDWFSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXDWFSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:18:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44458 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXDWFSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:18:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: vgoyal@in.ibm.com, Jurriaan <thunder7@xs4all.nl>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Magnus Damm <magnus@valinux.co.jp>, Horms <horms@verge.net.au>,
       thunder7@xs4all.nl, <fastboot@osdl.org>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
References: <20070331005303.354411f0.akpm@linux-foundation.org>
	<20070401052932.GA9894@amd64.of.nowhere>
	<m1ircghb6w.fsf@ebiederm.dsl.xmission.com>
	<20070331232957.e1c93f19.akpm@linux-foundation.org>
	<20070402074159.GA13704@in.ibm.com>
	<m1abxrf9o3.fsf@ebiederm.dsl.xmission.com>
	<20070402094520.GC13704@in.ibm.com>
	<m1648eg01d.fsf@ebiederm.dsl.xmission.com>
	<20070403040152.GA5108@in.ibm.com>
	<m1zm5qc9q2.fsf@ebiederm.dsl.xmission.com>
	<20070403100349.GA21759@in.ibm.com>
Date: Sun, 22 Apr 2007 23:12:13 -0600
In-Reply-To: <20070403100349.GA21759@in.ibm.com> (Vivek Goyal's message of
	"Tue, 3 Apr 2007 15:33:49 +0530")
Message-ID: <m18xcjznbm.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Currently because vmlinux does not reflect that the kernel is relocatable
we still have to support CONFIG_PHYSICAL_START.  So this patch adds a small
c program to do what we cannot do with a linker script, set the elf header
type to ET_DYN.

This should remove the last obstacle to removing CONFIG_PHYSICAL_START
on x86_64.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/Kconfig  |    4 +++
 arch/x86_64/Makefile |   10 +++++++
 scripts/Makefile     |   11 ++++---
 scripts/mketrel.c    |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 5 deletions(-)
 create mode 100644 scripts/mketrel.c

diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 16d9bf3..773b487 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -121,6 +121,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ELF_RELOCATABLE
+	bool
+	default y
+
 source "init/Kconfig"
 
 
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 9dd91b2..5ae79ab 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -124,6 +124,16 @@ define archhelp
   echo  '  isoimage     - Create a boot CD-ROM image'
 endef
 
+ifeq ($(CONFIG_RELOCATABLE),y)
+define cmd_vmlinux__
+      $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
+      -T $(vmlinux-lds) $(vmlinux-init)		\
+      --start-group $(vmlinux-main) --end-group	\
+      $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) FORCE ,$^) \
+      && scripts/mketrel $@
+endef
+endif
+
 CLEAN_FILES += arch/$(ARCH)/boot/fdimage \
 	       arch/$(ARCH)/boot/image.iso \
 	       arch/$(ARCH)/boot/mtools.conf
diff --git a/scripts/Makefile b/scripts/Makefile
index 1c73c5a..ddba550 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -7,11 +7,12 @@
 # conmakehash:   Create chartable
 # conmakehash:	 Create arrays for initializing the kernel console tables
 
-hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
-hostprogs-$(CONFIG_LOGO)         += pnmtologo
-hostprogs-$(CONFIG_VT)           += conmakehash
-hostprogs-$(CONFIG_PROM_CONSOLE) += conmakehash
-hostprogs-$(CONFIG_IKCONFIG)     += bin2c
+hostprogs-$(CONFIG_KALLSYMS)        += kallsyms
+hostprogs-$(CONFIG_LOGO)            += pnmtologo
+hostprogs-$(CONFIG_VT)              += conmakehash
+hostprogs-$(CONFIG_PROM_CONSOLE)    += conmakehash
+hostprogs-$(CONFIG_IKCONFIG)        += bin2c
+hostprogs-$(CONFIG_ELF_RELOCATABLE) += mketrel
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/scripts/mketrel.c b/scripts/mketrel.c
new file mode 100644
index 0000000..effa312
--- /dev/null
+++ b/scripts/mketrel.c
@@ -0,0 +1,70 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <elf.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdlib.h>
+
+static int fd;
+unsigned char e_ident[EI_NIDENT];
+
+void die(const char * str, ...)
+{
+	va_list args;
+	va_start(args, str);
+	vfprintf(stderr, str, args);
+	fputc('\n', stderr);
+	exit(1);
+}
+
+void file_open(const char *name)
+{
+	if ((fd = open(name, O_RDWR, 0)) < 0)
+		die("Unable to open `%s': %m", name);
+}
+
+static void mketrel(void)
+{
+	unsigned char e_type[2];
+	if (read(fd, &e_ident, sizeof(e_ident)) != sizeof(e_ident))
+		die("Cannot read ELF header: %s\n", strerror(errno));
+
+	if (memcmp(e_ident, ELFMAG, 4) != 0)
+		die("No ELF magic\n");
+
+	if ((e_ident[EI_CLASS] != ELFCLASS64) &&
+	    (e_ident[EI_CLASS] != ELFCLASS32))
+		die("Unrecognized ELF class: %x\n", e_ident[EI_CLASS]);
+	
+	if ((e_ident[EI_DATA] != ELFDATA2LSB) &&
+	    (e_ident[EI_DATA] != ELFDATA2MSB))
+		die("Unrecognized ELF data encoding: %x\n", e_ident[EI_DATA]);
+
+	if (e_ident[EI_VERSION] != EV_CURRENT)
+		die("Unknown ELF version: %d\n", e_ident[EI_VERSION]);
+
+	if (e_ident[EI_DATA] == ELFDATA2LSB) {
+		e_type[0] = ET_REL & 0xff;
+		e_type[1] = ET_REL >> 8;
+	} else {
+		e_type[1] = ET_REL & 0xff;
+		e_type[0] = ET_REL >> 8;
+	}
+
+	if (write(fd, &e_type, sizeof(e_type)) != sizeof(e_type))
+		die("Cannot write ELF type: %s\n", strerror(errno));
+}
+
+int main(int argc, char **argv)
+{
+	if (argc != 2)
+		die("Usage: mketrel: vmlinux");
+	file_open(argv[1]);
+	mketrel();
+	close(fd);
+	return 0;
+}
-- 
1.5.1.1.181.g2de0

