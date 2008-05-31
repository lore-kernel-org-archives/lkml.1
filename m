Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbYFEJ5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbYFEJ5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYFEJxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:53:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbYFEJxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:53:32 -0400
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080605.foo@pmac.infradead.org>
References: <20080605.foo@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 31 May 2008 15:07:18 +0300
Subject: [PATCH 12/18] ihex: add ihex2fw tool for converting HEX files into firmware images
Message-Id: <E1K4CA0-0001dL-8S@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not the straight conversion to binary which objcopy can do for us, but
actually representing each record with its original {addr, length},
because some drivers need that information preserved.

Fix up 'firmware_install' to be able to build $(hostprogs-y) too.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 firmware/Makefile       |   14 +++
 firmware/ihex2fw.c      |  238 +++++++++++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.fwinst |    7 +-
 3 files changed, 258 insertions(+), 1 deletions(-)
 create mode 100644 firmware/ihex2fw.c

diff --git a/firmware/Makefile b/firmware/Makefile
index 4e19ac1..2583aef 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -28,6 +28,9 @@ quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
 quiet_cmd_ihex  = IHEX    $@
       cmd_ihex  = $(OBJCOPY) -Iihex -Obinary $< $@
 
+quiet_cmd_ihex2fw  = IHEX2FW $@
+      cmd_ihex2fw  = $(objtree)/$(obj)/ihex2fw $< $@
+
 quiet_cmd_fwbin = MK_FW   $@
       cmd_fwbin = FWNAME="$(patsubst firmware/%.gen.S,%,$@)";		     \
 		  FWSTR="$(subst /,_,$(subst .,_,$(subst -,_,$(patsubst	     \
@@ -80,9 +83,18 @@ $(patsubst %,$(obj)/%.gen.S, $(fw-external-y)): %: $(wordsize_deps) \
 $(patsubst %,$(obj)/%.gen.o, $(fw-shipped-y)): %.gen.o: %
 $(patsubst %,$(obj)/%.gen.o, $(fw-external-y)): $(obj)/%.gen.o: $(fwdir)/%
 
+# .ihex is used just as a simple way to hold binary files in a source tree
+# where binaries are frowned upon. They are directly converted with objcopy.
 $(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,ihex)
 
+# .HEX is also Intel HEX, but where the offset and length in each record
+# is actually meaninful, because the firmware has to be loaded in a certain
+# order rather than as a single binary blob. Thus, we convert them into our
+# more compact binary representation of ihex records (<linux/ihex.h>)
+$(obj)/%.fw: $(obj)/%.HEX $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+	$(call cmd,ihex2fw)
+
 $(firmware-dirs):
 	$(call cmd,mkdir)
 
@@ -96,3 +108,5 @@ targets := $(fw-shipped-) $(patsubst $(obj)/%,%, \
 # Without this, built-in.o won't be created when it's empty, and the
 # final vmlinux link will fail.
 obj-n := dummy
+
+hostprogs-y := ihex2fw
diff --git a/firmware/ihex2fw.c b/firmware/ihex2fw.c
new file mode 100644
index 0000000..31d963c
--- /dev/null
+++ b/firmware/ihex2fw.c
@@ -0,0 +1,238 @@
+/*
+ * Parser/loader for IHEX formatted data.
+ *
+ * Copyright © 2008 David Woodhouse <dwmw2@infradead.org>
+ * Copyright © 2005 Jan Harkes <jaharkes@cs.cmu.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdint.h>
+#include <arpa/inet.h>
+#include <stdio.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+
+struct ihex_binrec {
+	struct ihex_binrec *next; /* not part of the real data structure */
+        uint32_t addr;
+        uint8_t len;
+        uint8_t data[256];
+};
+
+/**
+ * nybble/hex are little helpers to parse hexadecimal numbers to a byte value
+ **/
+static uint8_t nybble(const uint8_t n)
+{
+       if      (n >= '0' && n <= '9') return n - '0';
+       else if (n >= 'A' && n <= 'F') return n - ('A' - 10);
+       else if (n >= 'a' && n <= 'f') return n - ('a' - 10);
+       return 0;
+}
+
+static uint8_t hex(const uint8_t *data, uint8_t *crc)
+{
+       uint8_t val = (nybble(data[0]) << 4) | nybble(data[1]);
+       *crc += val;
+       return val;
+}
+
+static int process_ihex(uint8_t *data, ssize_t size);
+static void file_record(struct ihex_binrec *record);
+static int output_records(int outfd);
+
+static int sort_records = 0;
+
+int main(int argc, char **argv)
+{
+	int infd, outfd;
+	struct stat st;
+	uint8_t *data;
+
+	if (argc == 4 && !strcmp(argv[1], "-s")) {
+		sort_records = 1;
+		argc--;
+		argv++;
+	}
+	if (argc != 3) {
+	usage:
+		fprintf(stderr, "ihex2fw: Convert ihex files into binary "
+				"representation for use by Linux kernel\n");
+		fprintf(stderr, "usage: ihex2fw [-s] <src.HEX> <dst.fw>\n");
+		fprintf(stderr, "       -s: sort records by address\n");
+		return 1;
+	}
+	if (!strcmp(argv[1], "-"))
+	    infd = 0;
+	else
+		infd = open(argv[1], O_RDONLY);
+	if (infd == -1) {
+		fprintf(stderr, "Failed to open source file: %s",
+			strerror(errno));
+		goto usage;
+	}
+	if (fstat(infd, &st)) {
+		perror("stat");
+		return 1;
+	}
+	data = mmap(NULL, st.st_size, PROT_READ, MAP_SHARED, infd, 0);
+	if (data == MAP_FAILED) {
+		perror("mmap");
+		return 1;
+	}
+
+	if (!strcmp(argv[2], "-"))
+	    outfd = 1;
+	else
+		outfd = open(argv[2], O_TRUNC|O_CREAT|O_WRONLY, 0644);
+	if (outfd == -1) {
+		fprintf(stderr, "Failed to open destination file: %s",
+			strerror(errno));
+		goto usage;
+	}
+	if (process_ihex(data, st.st_size))
+		return 1;
+
+	output_records(outfd);
+	return 0;
+}
+
+static int process_ihex(uint8_t *data, ssize_t size)
+{
+	struct ihex_binrec *record;
+	uint32_t offset = 0;
+	uint8_t type, crc = 0;
+	int i, j;
+	int line = 1;
+
+	i = 0;
+next_record:
+	record = malloc(sizeof(*record));
+	if (!record) {
+		fprintf(stderr, "out of memory for records\n");
+		return -ENOMEM;
+	}
+	memset(record, 0, sizeof(*record));
+
+	/* search for the start of record character */
+	while (i < size) {
+		if (data[i] == '\n') line++;
+		if (data[i++] == ':') break;
+	}
+
+	/* Minimum record length would be about 10 characters */
+	if (i + 10 > size) {
+		fprintf(stderr, "Can't find valid record\n");
+		return -EINVAL;
+	}
+
+	record->len = hex(data + i, &crc);
+	i += 2;
+
+	/* now check if we have enough data to read everything */
+	if (i + 8 + (record->len * 2) > size) {
+		fprintf(stderr, "Not enough data to read complete record\n");
+		return -EINVAL;
+	}
+
+	record->addr  = hex(data + i, &crc) << 8; i += 2;
+	record->addr |= hex(data + i, &crc); i += 2;
+	record->addr += offset;
+	type = hex(data + i, &crc); i += 2;
+
+	for (j = 0; j < record->len; j++, i += 2)
+		record->data[j] = hex(data + i, &crc);
+
+	/* check CRC */
+	(void)hex(data + i, &crc); i += 2;
+	if (crc != 0) {
+		fprintf(stderr, "CRC failure\n");
+		return -EINVAL;
+	}
+
+	/* Done reading the record */
+	switch (type) {
+	case 0:
+		/* old style EOF record? */
+		if (!record->len)
+			break;
+
+		file_record(record);
+		goto next_record;
+
+	case 1: /* End-Of-File Record */
+		if (record->addr || record->len) {
+			fprintf(stderr, "Bad EOF record (type 01) format\n");
+			return -EINVAL;
+		}
+		break;
+
+	case 2: /* Extended Segment Address Record (HEX86) */
+	case 4: /* Extended Linear Address Record (HEX386) */
+		if (record->addr || record->len != 2) {
+			fprintf(stderr, "Bad HEX86/HEX386 record (type %02X)\n", type);
+			return -EINVAL;
+		}
+
+		/* We shouldn't really be using the offset for HEX86 because
+		 * the wraparound case is specified quite differently. */
+		offset = record->data[0] << 8 | record->data[1];
+		offset <<= (type == 2 ? 4 : 16);
+		goto next_record;
+
+	case 3: /* Start Segment Address Record */
+	case 5: /* Start Linear Address Record */
+		if (record->addr || record->len != 4) {
+			fprintf(stderr, "Bad Start Address record (type %02X)\n", type);
+			return -EINVAL;
+		}
+
+		/* These records contain the CS/IP or EIP where execution
+		 * starts. Don't really know what to do with them. */
+		goto next_record;
+
+	default:
+		fprintf(stderr, "Unknown record (type %02X)\n", type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct ihex_binrec *records;
+
+static void file_record(struct ihex_binrec *record)
+{
+	struct ihex_binrec **p = &records;
+
+	while ((*p) && (!sort_records || (*p)->addr < record->addr))
+		p = &((*p)->next);
+
+	record->next = *p;
+	*p = record;
+}
+
+static int output_records(int outfd)
+{
+	unsigned char zeroes[5] = {0, 0, 0, 0, 0};
+	struct ihex_binrec *p = records;
+
+	while (p) {
+		p->addr = htonl(p->addr);
+		write(outfd, &p->addr, (p->len + 8) & ~3);
+		p = p->next;
+	}
+	/* EOF record is zero length, since we don't bother to represent
+	   the type field in the binary version */
+	write(outfd, zeroes, 5);
+	return 0;
+}
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 3cf3649..f72355e 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -6,10 +6,13 @@
 # ==========================================================================
 
 INSTALL := install
+src := $(obj)
 
 include scripts/Kbuild.include 
 include $(srctree)/$(obj)/Makefile
 
+include scripts/Makefile.host
+
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-))
 installed-fw-dirs := $(sort $(dir $(installed-fw)))
 
@@ -22,5 +25,7 @@ $(installed-fw-dirs):
 $(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)/
 	$(call cmd,install)
 
-.PHONY: __fw_install
+.PHONY: __fw_install FORCE
 __fw_install: $(installed-fw)
+
+FORCE:
-- 
1.5.4.5

