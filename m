Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYBYQSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYBYQSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 11:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYBYQSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 11:18:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:36233 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753839AbYBYQSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 11:18:41 -0500
X-Authenticated: #8077970
X-Provags-ID: V01U2FsdGVkX19UpAdeCqFUeDW/pVoYLQozDGj+gSkpYMbNPlxprX
	x10hAqZCX8Np3V
From: Richard Hacker <lerichi@gmx.net>
To: kai@germaschewski.name, sam@ravnborg.org
Subject: [PATCH 001/001] scripts/mod/modpost.c: Allow additional Modules.symvers files during modpost stage 2
Date: Mon, 25 Feb 2008 17:19:07 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251719.07240.lerichi@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Hacker <lerichi@gmx.net>

This patch adds a new command line option -E to modpost, expecting a comma 
separated list of additional files as an argument whose symbols should be 
read before processing. Passing EXTRA_SYMBOLS on the make command line will 
then call modpost with this symbol list.

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

I have written this small patch allowing developers to supply a list of symbol 
files to make which modpost then reads before processing the current module, 
thus not generating these annoying warnings.

The patch adds a new command line option -E to modpost which expects a comma 
separated list of additional files whose symbols should be read. 

scripts/Makefile.modpost is also extended to accept the variable 
EXTRA_SYMBOLS, which in turn calls modpost with the -E argument. Therefore it 
is possible to supply the list during the make process
make -C /path/to/linux/kernel M=/path/to/my/module \ 
EXTRA_SYMBOLS=/extra/modules/Modules.symvers,/another/Modules.symvers

I was not successful in putting EXTRA_SYMBOLS living aside EXTRA_CFLAGS, etc. 
as a make variable into the Kbuild makefile. This is where it would fit best. 
Maybe someone can contribute this.

I hope this patch is useful and finds its way into the kernel.


diff -uprN linux-2.6.23-vanilla/scripts/Makefile.modpost 
linux-2.6.23/scripts/Makefile.modpost
--- linux-2.6.23-vanilla/scripts/Makefile.modpost	2008-01-18 
22:47:09.000000000 +0100
+++ linux-2.6.23/scripts/Makefile.modpost	2008-02-25 16:54:42.000000000 +0100
@@ -61,6 +61,7 @@ modpost = scripts/mod/modpost           
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
+ $(if $(EXTRA_SYMBOLS),-E $(EXTRA_SYMBOLS))      \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
diff -uprN linux-2.6.23-vanilla/scripts/mod/modpost.c 
linux-2.6.23/scripts/mod/modpost.c
--- linux-2.6.23-vanilla/scripts/mod/modpost.c	2008-01-18 22:47:09.000000000 
+0100
+++ linux-2.6.23/scripts/mod/modpost.c	2008-02-25 16:53:58.000000000 +0100
@@ -1645,11 +1645,12 @@ int main(int argc, char **argv)
 	struct buffer buf = { };
 	char fname[SZ];
 	char *kernel_read = NULL, *module_read = NULL;
+	char *external_read = NULL, *comma;
 	char *dump_write = NULL;
 	int opt;
 	int err;
 
-	while ((opt = getopt(argc, argv, "i:I:mso:aw")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:E:mso:aw")) != -1) {
 		switch(opt) {
 			case 'i':
 				kernel_read = optarg;
@@ -1658,6 +1659,10 @@ int main(int argc, char **argv)
 				module_read = optarg;
 				external_module = 1;
 				break;
+			case 'E':
+				external_read = optarg;
+				external_module = 1;
+				break;
 			case 'm':
 				modversions = 1;
 				break;
@@ -1682,6 +1687,13 @@ int main(int argc, char **argv)
 		read_dump(kernel_read, 1);
 	if (module_read)
 		read_dump(module_read, 0);
+	while (external_read) {
+		comma = strchr(external_read, ',');
+		if (comma)
+			*comma = '\0';
+		read_dump(external_read, 0);
+		external_read = comma ? comma + 1 : NULL;
+	}
 
 	while (optind < argc) {
 		read_symbols(argv[optind++]);
