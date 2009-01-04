Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZADVmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZADVmk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbZADVmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:42:31 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:52528 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZADVm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:42:29 -0500
Date: Sun, 4 Jan 2009 22:44:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] Build failure in current mainline - firmware related
Message-ID: <20090104214406.GA31668@uranus.ravnborg.org>
References: <200901031247.14977.rjw@sisk.pl> <20090103204948.GA5388@uranus.ravnborg.org> <20090103205437.GA5499@uranus.ravnborg.org> <200901032243.28684.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901032243.28684.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 10:43:28PM +0100, Rafael J. Wysocki wrote:
> On Saturday 03 January 2009, Sam Ravnborg wrote:
> > On Sat, Jan 03, 2009 at 09:49:48PM +0100, Sam Ravnborg wrote:
> > > On Sat, Jan 03, 2009 at 12:47:14PM +0100, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > I get the following error from 'make modules_install' on my test boxes:
> > > > 
> > > >   HOSTCC  firmware/ihex2fw                                                             
> > > > /home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system                                            
> > > > compilation terminated.                                                                
> > > > make[3]: *** [firmware/ihex2fw] Error 1                                                
> > > > make[2]: *** [_modinst_post] Error 2                                                   
> > > > make[1]: *** [sub-make] Error 2                                                        
> > > > make: *** [all] Error 2
> > > > 
> > > > where the configuration is that the kernel is compiled on a build box
> > > > with 'make O=<destdir> -j5' and then <destdir> is mounted over NFS read-only by
> > > > each test box (full path to this directory is the same on the build box and on
> > > > the test boxes).  Then, I cd into <destdir>, run 'make modules_install' and get
> > > > the error above.
> > > > 
> > > > 2.6.28 didn't have this problem.
> > > 
> > > 
> > > Strange...
> > > 1) The string "opening dependency file" does not occur in my freshly pulled kernel
> > > 2) Line 268 is last line of ihex2fw.c
> > > 
> > > Could you try to do a "make modules_install V=1" to see the exact arguments supplied ti ihex2fw.c
> > > 
> > > I gave up on all the firmware stuff long time ago and has
> > > never properly reviewed the implementation so I really
> > > have no clue what is actually happening.
> > > 
> > > Walking through the 179 lines Makefile has not yet benn on my
> > > "fun to do" list - and it most likely take a while before it hits it.
> > 
> > Took a quick peek. The Makefile uses "order only" in three spots.
> > This alone demand make version 3.80 IIRC and Documetnation/Changes
> > says 3.79.1...
> > 
> > The "order only" is so rare that Paul Smith once said that
> > coming up with a good example of usage was not easy.
> > 
> > For the headers_* stuff I recall when I reworked it I could
> > kill the usage of "order only" there but now it crept
> > back - sigh!
> 
> Well, in the meantime I ran 'make modules_install V=1' and this is the
> last thing printed (the previous ones are not really interesting):
> 
> make -f /home/rafael/src/linux-2.6/scripts/Makefile.fwinst obj=firmware __fw_modinst
>   gcc -Wp,-MD,firmware/.ihex2fw.d -Ifirmware -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -o firmware/ihex2fw /home/rafael/src/linux-2.6/firmware/ihex2fw.c
> /home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system
> compilation terminated.
> make[3]: *** [firmware/ihex2fw] Error 1
> make[2]: *** [_modinst_post] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> It fails because of the attempt to compile ihex2fw .

There are at least two obvious ways to fix this.

We could try to rearrange things so we do not trigger
the rebuild of ihex2fw in the modules_install case.
This would likely involve creating a new file listing
all the firmawre files and share it between firmware/Makefile
and scripts/Makefile.fwinst

We could also move ihex2fw to scripts so it is build
as part of the preparation for a kernel build.

Attched patch does the latter.
[I will update the changelog before I eventually commit it].

	Sam

Patch is in old-style but the majority of the patch is the file move.

>From f023a3d57e2b70a2d3d9ac4a484f1d337f2a02e3 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 4 Jan 2009 22:38:21 +0100
Subject: [PATCH] kbuild: move ihex2fw to scripts

This fix a situation where we try to rebuild ihex2fw
when we do modules_install

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 firmware/Makefile  |   10 +-
 firmware/ihex2fw.c |  268 ----------------------------------------------------
 scripts/Makefile   |    2 +
 scripts/ihex2fw.c  |  268 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 274 insertions(+), 274 deletions(-)
 delete mode 100644 firmware/ihex2fw.c
 create mode 100644 scripts/ihex2fw.c

diff --git a/firmware/Makefile b/firmware/Makefile
index 6968388..0423c41 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -88,10 +88,10 @@ quiet_cmd_ihex  = IHEX    $@
       cmd_ihex  = $(OBJCOPY) -Iihex -Obinary $< $@
 
 quiet_cmd_ihex2fw  = IHEX2FW $@
-      cmd_ihex2fw  = $(objtree)/$(obj)/ihex2fw $< $@
+      cmd_ihex2fw  = $(objtree)/scripts/ihex2fw $< $@
 
 quiet_cmd_h16tofw  = H16TOFW $@
-      cmd_h16tofw  = $(objtree)/$(obj)/ihex2fw -w $< $@
+      cmd_h16tofw  = $(objtree)/scripts/ihex2fw -w $< $@
 
 quiet_cmd_fwbin = MK_FW   $@
       cmd_fwbin = FWNAME="$(patsubst firmware/%.gen.S,%,$@)";		     \
@@ -154,11 +154,11 @@ $(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
 # is actually meaningful, because the firmware has to be loaded in a certain
 # order rather than as a single binary blob. Thus, we convert them into our
 # more compact binary representation of ihex records (<linux/ihex.h>)
-$(obj)/%.fw: $(obj)/%.HEX $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.HEX  | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,ihex2fw)
 
 # .H16 is our own modified form of Intel HEX, with 16-bit length for records.
-$(obj)/%.fw: $(obj)/%.H16 $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.H16 | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,h16tofw)
 
 $(firmware-dirs):
@@ -175,5 +175,3 @@ targets := $(fw-shipped-) $(patsubst $(obj)/%,%, \
 # Without this, built-in.o won't be created when it's empty, and the
 # final vmlinux link will fail.
 obj-n := dummy
-
-hostprogs-y := ihex2fw
diff --git a/firmware/ihex2fw.c b/firmware/ihex2fw.c
deleted file mode 100644
index 8f7fdaa..0000000
--- a/firmware/ihex2fw.c
+++ /dev/null
@@ -1,268 +0,0 @@
-/*
- * Parser/loader for IHEX formatted data.
- *
- * Copyright © 2008 David Woodhouse <dwmw2@infradead.org>
- * Copyright © 2005 Jan Harkes <jaharkes@cs.cmu.edu>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <stdint.h>
-#include <arpa/inet.h>
-#include <stdio.h>
-#include <errno.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <sys/mman.h>
-#include <fcntl.h>
-#include <string.h>
-#include <unistd.h>
-#include <stdlib.h>
-#define _GNU_SOURCE
-#include <getopt.h>
-
-
-struct ihex_binrec {
-	struct ihex_binrec *next; /* not part of the real data structure */
-        uint32_t addr;
-        uint16_t len;
-        uint8_t data[];
-};
-
-/**
- * nybble/hex are little helpers to parse hexadecimal numbers to a byte value
- **/
-static uint8_t nybble(const uint8_t n)
-{
-       if      (n >= '0' && n <= '9') return n - '0';
-       else if (n >= 'A' && n <= 'F') return n - ('A' - 10);
-       else if (n >= 'a' && n <= 'f') return n - ('a' - 10);
-       return 0;
-}
-
-static uint8_t hex(const uint8_t *data, uint8_t *crc)
-{
-       uint8_t val = (nybble(data[0]) << 4) | nybble(data[1]);
-       *crc += val;
-       return val;
-}
-
-static int process_ihex(uint8_t *data, ssize_t size);
-static void file_record(struct ihex_binrec *record);
-static int output_records(int outfd);
-
-static int sort_records = 0;
-static int wide_records = 0;
-
-int usage(void)
-{
-	fprintf(stderr, "ihex2fw: Convert ihex files into binary "
-		"representation for use by Linux kernel\n");
-	fprintf(stderr, "usage: ihex2fw [<options>] <src.HEX> <dst.fw>\n");
-	fprintf(stderr, "       -w: wide records (16-bit length)\n");
-	fprintf(stderr, "       -s: sort records by address\n");
-	return 1;
-}
-
-int main(int argc, char **argv)
-{
-	int infd, outfd;
-	struct stat st;
-	uint8_t *data;
-	int opt;
-
-	while ((opt = getopt(argc, argv, "ws")) != -1) {
-		switch (opt) {
-		case 'w':
-			wide_records = 1;
-			break;
-		case 's':
-			sort_records = 1;
-			break;
-		default:
-			return usage();
-		}
-	}
-
-	if (optind + 2 != argc)
-		return usage();
-
-	if (!strcmp(argv[optind], "-"))
-	    infd = 0;
-	else
-		infd = open(argv[optind], O_RDONLY);
-	if (infd == -1) {
-		fprintf(stderr, "Failed to open source file: %s",
-			strerror(errno));
-		return usage();
-	}
-	if (fstat(infd, &st)) {
-		perror("stat");
-		return 1;
-	}
-	data = mmap(NULL, st.st_size, PROT_READ, MAP_SHARED, infd, 0);
-	if (data == MAP_FAILED) {
-		perror("mmap");
-		return 1;
-	}
-
-	if (!strcmp(argv[optind+1], "-"))
-	    outfd = 1;
-	else
-		outfd = open(argv[optind+1], O_TRUNC|O_CREAT|O_WRONLY, 0644);
-	if (outfd == -1) {
-		fprintf(stderr, "Failed to open destination file: %s",
-			strerror(errno));
-		return usage();
-	}
-	if (process_ihex(data, st.st_size))
-		return 1;
-
-	output_records(outfd);
-	return 0;
-}
-
-static int process_ihex(uint8_t *data, ssize_t size)
-{
-	struct ihex_binrec *record;
-	uint32_t offset = 0;
-	uint8_t type, crc = 0, crcbyte = 0;
-	int i, j;
-	int line = 1;
-	int len;
-
-	i = 0;
-next_record:
-	/* search for the start of record character */
-	while (i < size) {
-		if (data[i] == '\n') line++;
-		if (data[i++] == ':') break;
-	}
-
-	/* Minimum record length would be about 10 characters */
-	if (i + 10 > size) {
-		fprintf(stderr, "Can't find valid record at line %d\n", line);
-		return -EINVAL;
-	}
-
-	len = hex(data + i, &crc); i += 2;
-	if (wide_records) {
-		len <<= 8;
-		len += hex(data + i, &crc); i += 2;
-	}
-	record = malloc((sizeof (*record) + len + 3) & ~3);
-	if (!record) {
-		fprintf(stderr, "out of memory for records\n");
-		return -ENOMEM;
-	}
-	memset(record, 0, (sizeof(*record) + len + 3) & ~3);
-	record->len = len;
-
-	/* now check if we have enough data to read everything */
-	if (i + 8 + (record->len * 2) > size) {
-		fprintf(stderr, "Not enough data to read complete record at line %d\n",
-			line);
-		return -EINVAL;
-	}
-
-	record->addr  = hex(data + i, &crc) << 8; i += 2;
-	record->addr |= hex(data + i, &crc); i += 2;
-	type = hex(data + i, &crc); i += 2;
-
-	for (j = 0; j < record->len; j++, i += 2)
-		record->data[j] = hex(data + i, &crc);
-
-	/* check CRC */
-	crcbyte = hex(data + i, &crc); i += 2;
-	if (crc != 0) {
-		fprintf(stderr, "CRC failure at line %d: got 0x%X, expected 0x%X\n",
-			line, crcbyte, (unsigned char)(crcbyte-crc));
-		return -EINVAL;
-	}
-
-	/* Done reading the record */
-	switch (type) {
-	case 0:
-		/* old style EOF record? */
-		if (!record->len)
-			break;
-
-		record->addr += offset;
-		file_record(record);
-		goto next_record;
-
-	case 1: /* End-Of-File Record */
-		if (record->addr || record->len) {
-			fprintf(stderr, "Bad EOF record (type 01) format at line %d",
-				line);
-			return -EINVAL;
-		}
-		break;
-
-	case 2: /* Extended Segment Address Record (HEX86) */
-	case 4: /* Extended Linear Address Record (HEX386) */
-		if (record->addr || record->len != 2) {
-			fprintf(stderr, "Bad HEX86/HEX386 record (type %02X) at line %d\n",
-				type, line);
-			return -EINVAL;
-		}
-
-		/* We shouldn't really be using the offset for HEX86 because
-		 * the wraparound case is specified quite differently. */
-		offset = record->data[0] << 8 | record->data[1];
-		offset <<= (type == 2 ? 4 : 16);
-		goto next_record;
-
-	case 3: /* Start Segment Address Record */
-	case 5: /* Start Linear Address Record */
-		if (record->addr || record->len != 4) {
-			fprintf(stderr, "Bad Start Address record (type %02X) at line %d\n",
-				type, line);
-			return -EINVAL;
-		}
-
-		/* These records contain the CS/IP or EIP where execution
-		 * starts. Don't really know what to do with them. */
-		goto next_record;
-
-	default:
-		fprintf(stderr, "Unknown record (type %02X)\n", type);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static struct ihex_binrec *records;
-
-static void file_record(struct ihex_binrec *record)
-{
-	struct ihex_binrec **p = &records;
-
-	while ((*p) && (!sort_records || (*p)->addr < record->addr))
-		p = &((*p)->next);
-
-	record->next = *p;
-	*p = record;
-}
-
-static int output_records(int outfd)
-{
-	unsigned char zeroes[6] = {0, 0, 0, 0, 0, 0};
-	struct ihex_binrec *p = records;
-
-	while (p) {
-		uint16_t writelen = (p->len + 9) & ~3;
-
-		p->addr = htonl(p->addr);
-		p->len = htons(p->len);
-		write(outfd, &p->addr, writelen);
-		p = p->next;
-	}
-	/* EOF record is zero length, since we don't bother to represent
-	   the type field in the binary version */
-	write(outfd, zeroes, 6);
-	return 0;
-}
diff --git a/scripts/Makefile b/scripts/Makefile
index aafdf06..db5dd47 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -2,11 +2,13 @@
 # scripts contains sources for various helper programs used throughout
 # the kernel for the build process.
 # ---------------------------------------------------------------------------
+# ihex2fw:       Parser/loader for IHEX formatted data
 # kallsyms:      Find all symbols in vmlinux
 # pnmttologo:    Convert pnm files to logo files
 # conmakehash:   Create chartable
 # conmakehash:	 Create arrays for initializing the kernel console tables
 
+hostprogs-y                      := ihex2fw
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
diff --git a/scripts/ihex2fw.c b/scripts/ihex2fw.c
new file mode 100644
index 0000000..8f7fdaa
--- /dev/null
+++ b/scripts/ihex2fw.c
@@ -0,0 +1,268 @@
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
+#define _GNU_SOURCE
+#include <getopt.h>
+
+
+struct ihex_binrec {
+	struct ihex_binrec *next; /* not part of the real data structure */
+        uint32_t addr;
+        uint16_t len;
+        uint8_t data[];
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
+static int wide_records = 0;
+
+int usage(void)
+{
+	fprintf(stderr, "ihex2fw: Convert ihex files into binary "
+		"representation for use by Linux kernel\n");
+	fprintf(stderr, "usage: ihex2fw [<options>] <src.HEX> <dst.fw>\n");
+	fprintf(stderr, "       -w: wide records (16-bit length)\n");
+	fprintf(stderr, "       -s: sort records by address\n");
+	return 1;
+}
+
+int main(int argc, char **argv)
+{
+	int infd, outfd;
+	struct stat st;
+	uint8_t *data;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "ws")) != -1) {
+		switch (opt) {
+		case 'w':
+			wide_records = 1;
+			break;
+		case 's':
+			sort_records = 1;
+			break;
+		default:
+			return usage();
+		}
+	}
+
+	if (optind + 2 != argc)
+		return usage();
+
+	if (!strcmp(argv[optind], "-"))
+	    infd = 0;
+	else
+		infd = open(argv[optind], O_RDONLY);
+	if (infd == -1) {
+		fprintf(stderr, "Failed to open source file: %s",
+			strerror(errno));
+		return usage();
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
+	if (!strcmp(argv[optind+1], "-"))
+	    outfd = 1;
+	else
+		outfd = open(argv[optind+1], O_TRUNC|O_CREAT|O_WRONLY, 0644);
+	if (outfd == -1) {
+		fprintf(stderr, "Failed to open destination file: %s",
+			strerror(errno));
+		return usage();
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
+	uint8_t type, crc = 0, crcbyte = 0;
+	int i, j;
+	int line = 1;
+	int len;
+
+	i = 0;
+next_record:
+	/* search for the start of record character */
+	while (i < size) {
+		if (data[i] == '\n') line++;
+		if (data[i++] == ':') break;
+	}
+
+	/* Minimum record length would be about 10 characters */
+	if (i + 10 > size) {
+		fprintf(stderr, "Can't find valid record at line %d\n", line);
+		return -EINVAL;
+	}
+
+	len = hex(data + i, &crc); i += 2;
+	if (wide_records) {
+		len <<= 8;
+		len += hex(data + i, &crc); i += 2;
+	}
+	record = malloc((sizeof (*record) + len + 3) & ~3);
+	if (!record) {
+		fprintf(stderr, "out of memory for records\n");
+		return -ENOMEM;
+	}
+	memset(record, 0, (sizeof(*record) + len + 3) & ~3);
+	record->len = len;
+
+	/* now check if we have enough data to read everything */
+	if (i + 8 + (record->len * 2) > size) {
+		fprintf(stderr, "Not enough data to read complete record at line %d\n",
+			line);
+		return -EINVAL;
+	}
+
+	record->addr  = hex(data + i, &crc) << 8; i += 2;
+	record->addr |= hex(data + i, &crc); i += 2;
+	type = hex(data + i, &crc); i += 2;
+
+	for (j = 0; j < record->len; j++, i += 2)
+		record->data[j] = hex(data + i, &crc);
+
+	/* check CRC */
+	crcbyte = hex(data + i, &crc); i += 2;
+	if (crc != 0) {
+		fprintf(stderr, "CRC failure at line %d: got 0x%X, expected 0x%X\n",
+			line, crcbyte, (unsigned char)(crcbyte-crc));
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
+		record->addr += offset;
+		file_record(record);
+		goto next_record;
+
+	case 1: /* End-Of-File Record */
+		if (record->addr || record->len) {
+			fprintf(stderr, "Bad EOF record (type 01) format at line %d",
+				line);
+			return -EINVAL;
+		}
+		break;
+
+	case 2: /* Extended Segment Address Record (HEX86) */
+	case 4: /* Extended Linear Address Record (HEX386) */
+		if (record->addr || record->len != 2) {
+			fprintf(stderr, "Bad HEX86/HEX386 record (type %02X) at line %d\n",
+				type, line);
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
+			fprintf(stderr, "Bad Start Address record (type %02X) at line %d\n",
+				type, line);
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
+	unsigned char zeroes[6] = {0, 0, 0, 0, 0, 0};
+	struct ihex_binrec *p = records;
+
+	while (p) {
+		uint16_t writelen = (p->len + 9) & ~3;
+
+		p->addr = htonl(p->addr);
+		p->len = htons(p->len);
+		write(outfd, &p->addr, writelen);
+		p = p->next;
+	}
+	/* EOF record is zero length, since we don't bother to represent
+	   the type field in the binary version */
+	write(outfd, zeroes, 6);
+	return 0;
+}
-- 
1.6.0.2.GIT


> 
> Thanks,
> Rafael
