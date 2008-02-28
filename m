Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbYB1Ikf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbYB1Ikf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbYB1IkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:40:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:37222 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751926AbYB1IkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:40:23 -0500
X-Authenticated: #8077970
X-Provags-ID: V01U2FsdGVkX18+/64CmLU+A1Gwk59eKulV1PxtG+PRVGMBOXRTdk
	lrI54Zkb7lYc3G
From: Richard Hacker <lerichi@gmx.net>
To: kai@germaschewski.name, sam@ravnborg.org
Subject: [PATCH 001/002] scripts/mod/modpost.c: New option -E to load extra symbols
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 28 Feb 2008 09:40:52 +0100
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200802280940.53020.lerichi@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new command line option -E to modpost, expecting a symbol
file as an argument which is read prior to symbol processing. -E can be 
supplied multiple times for as many files as is needed.

Signed-off-by: Richard Hacker <lerichi@gmx.net>

---
When building kernel modules that depend on other modules not in the main 
kernel tree, modpost complains about undefined symbols:
# make -C /path/to/linux/kernel M=/path/to/my/module
...
Building modules, stage 2.
....
WARNING: "rt_copy_buf" [/home/rich/osc_etl_rtw/osc_kmod.ko] undefined!
...etc

This situation occurs when modpost processes the new module's symbols. When
it finds symbols not exported by the mainline kernel, it issues this warning.

The patch adds a new command line option -E to modpost which expects a symbol
file as an argument. The symbols listed in this file are added to modpost's
symbol tables during startup. -E can be supplied as often as required.

This patch works together with the second patch. It introduces a new make
variable, EXTRA_SYMBOLS, which is used when calling modpost.

I hope this patch is useful and finds its way into the kernel.

o Changes from the previous attempt:
   - patches kernel version 2.6.24
   - patches for scripts/mod/modpost.c and scripts/Makefile.modpost are 
     separated
   - the argument to -E is now a single file, not a comma separated list 
     any more. To pass more than one file, -E is used as often as required
   - patch 002/002 in this series introduces the Kbuild variable EXTRA_SYMBOLS
     to scripts/Makefile.modpost that in turn calls modpost with the correct
     -E command line arguments.

--- linux-2.6.24-vanilla/scripts/mod/modpost.c	2008-02-27 21:10:24.000000000 
+0100
+++ linux-2.6.24/scripts/mod/modpost.c	2008-02-27 21:14:36.000000000 +0100
@@ -1658,8 +1658,12 @@ int main(int argc, char **argv)
 	char *dump_write = NULL;
 	int opt;
 	int err;
+	struct ext_sym_list {
+		struct ext_sym_list *next;
+		const char *file;
+	} *extsym_start = NULL, *extsym_iter;
 
-	while ((opt = getopt(argc, argv, "i:I:mso:aw")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:E:mso:aw")) != -1) {
 		switch(opt) {
 			case 'i':
 				kernel_read = optarg;
@@ -1668,6 +1672,14 @@ int main(int argc, char **argv)
 				module_read = optarg;
 				external_module = 1;
 				break;
+			case 'E':
+				external_module = 1;
+				extsym_iter =
+					NOFAIL(malloc(sizeof(*extsym_iter)));
+				extsym_iter->next = extsym_start;
+				extsym_iter->file = optarg;
+				extsym_start = extsym_iter;
+				break;
 			case 'm':
 				modversions = 1;
 				break;
@@ -1692,6 +1704,12 @@ int main(int argc, char **argv)
 		read_dump(kernel_read, 1);
 	if (module_read)
 		read_dump(module_read, 0);
+	while (extsym_start) {
+		read_dump(extsym_start->file, 0);
+		extsym_iter = extsym_start->next;
+		free(extsym_start);
+		extsym_start = extsym_iter;
+	}
 
 	while (optind < argc) {
 		read_symbols(argv[optind++]);
