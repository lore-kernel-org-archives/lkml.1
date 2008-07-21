Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYGUVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYGUVnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbYGUVnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:43:21 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46710 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755909AbYGUVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:43:20 -0400
Subject: [RFC] fix kallsyms to allow discrimination of local symbols
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Content-Type: text/plain
Date: Mon, 21 Jul 2008 16:43:14 -0500
Message-Id: <1216676595.3433.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that local symbols, being hidden from the linker, might
not be unique.  Thus, they don't make good anchors for the symbol
relative addressing used by kprobes (it takes the first occurrence it
finds).  Likewise, when they appear in stack traces, it's sometimes not
obvious which local symbol it is (although context usually allows an
easy guess).

Fix all of this by prefixing local symbols with the actual C file name
they occur in separated by '|' (I had to use '|' since ':' is already in
use for module prefixes in kallsyms lookups.

I also had to rewrite mksysmap in perl because the necessary text
formatting changes in shell are painfully slow.

Comments?

James

---

diff --git a/Makefile b/Makefile
index 6192922..a416b35 100644
--- a/Makefile
+++ b/Makefile
@@ -685,7 +685,7 @@ quiet_cmd_vmlinux_version = GEN     .version
 
 # Generate System.map
 quiet_cmd_sysmap = SYSMAP
-      cmd_sysmap = $(CONFIG_SHELL) $(srctree)/scripts/mksysmap
+      cmd_sysmap = $(PERL) $(srctree)/scripts/mksysmap
 
 # Link of vmlinux
 # If CONFIG_KALLSYMS is set .version is already updated
@@ -759,7 +759,7 @@ endef
 
 # Generate .S file with all kernel symbols
 quiet_cmd_kallsyms = KSYM    $@
-      cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
+      cmd_kallsyms = $(NM) -n -l $< | sed "s|`pwd`/||" | $(KALLSYMS) \
                      $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
 
 .tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index ad2434b..0badae2 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -63,11 +63,12 @@ static inline int is_arm_mapping_symbol(const char *str)
 
 static int read_symbol(FILE *in, struct sym_entry *s)
 {
-	char str[500];
+	char str[500], file[500];
 	char *sym, stype;
-	int rc;
+	int rc, c, line;
 
-	rc = fscanf(in, "%llx %c %499s\n", &s->addr, &stype, str);
+	file[0] = '\0';
+	rc = fscanf(in, "%llx %c %499s", &s->addr, &stype, str);
 	if (rc != 3) {
 		if (rc != EOF) {
 			/* skip line */
@@ -75,6 +76,12 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 		}
 		return -1;
 	}
+	c = fgetc(in);
+	if (c != '\n') {
+		rc = fscanf(in, "%499[^:]:%d\n", file, &line);
+		if (rc != 2)
+			file[0] = '\0';
+	}
 
 	sym = str;
 	/* skip prefix char */
@@ -115,13 +122,22 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	/* include the type field in the symbol name, so that it gets
 	 * compressed together */
 	s->len = strlen(str) + 1;
+	if (islower(stype))
+		s->len += strlen(file) + 1;
 	s->sym = malloc(s->len + 1);
 	if (!s->sym) {
 		fprintf(stderr, "kallsyms failure: "
 			"unable to allocate required amount of memory\n");
 		exit(EXIT_FAILURE);
 	}
-	strcpy((char *)s->sym + 1, str);
+	if (islower(stype)) {
+		char *ss = (char *)s->sym + 1;
+		
+		strcpy(ss, file);
+		strcat(ss, "|");
+		strcat(ss, str);
+	} else
+		strcpy((char *)s->sym + 1, str);
 	s->sym[0] = stype;
 
 	return 0;
diff --git a/scripts/mksysmap b/scripts/mksysmap
index 6e133a0..496cadd 100644
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -1,4 +1,4 @@
-#!/bin/sh -x
+#!/usr/bin/perl
 # Based on the vmlinux file create the System.map file
 # System.map is used by module-init tools and some debugging
 # tools to retrieve the actual addresses of symbols in the kernel.
@@ -41,5 +41,21 @@
 # so we just ignore them to let readprofile continue to work.
 # (At least sparc64 has __crc_ in the middle).
 
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)' > $2
+chomp($cwd = `pwd`);
+open(I, "nm -n -l $ARGV[0]|") || die;
+open(O, ">$ARGV[1]") || die;
+foreach(<I>) {
+    chomp;
+    ($addr, $type, $symbol, $file_and_line) = split(/[ 	]/, $_);
+    next if ($type =~ /[aNUw]/ || $type =~ /\$[adt]/);
+    next if ($symbol=~ /__crc_/);
+    if ($type =~ /[a-z]/ && $file_and_line) {
+	($_) = split(/:/, $file_and_line);
+	(undef, $file) = split(/^$cwd\//, $_);
+	$symbol = $file."|".$symbol;
+    }
+    print O "$addr $type $symbol\n";
+}
+
+
 


