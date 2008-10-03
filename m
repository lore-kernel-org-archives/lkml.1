Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbYJCVvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbYJCVvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYJCVvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:51:13 -0400
Received: from kara.rubysoft.com ([64.34.171.174]:37129 "EHLO
	kara.rubysoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbYJCVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:51:13 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 17:51:13 EDT
Date: Fri, 3 Oct 2008 15:43:48 -0600 (MDT)
From: Jeff Hansen <x@jeffhansen.com>
X-X-Sender: ninkid@ren
Reply-To: Jeff Hansen <x@jeffhansen.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [MODULES]: Add KBUILD_EXTSYMVERS to supply external
 Module.symvers files
Message-ID: <Pine.LNX.4.64.0810031542450.20293@ren>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some out-of-tree modules require other out-of-tree modules to load and
function.  This patch allows one module to supply the path(s) of the
modules it depends on by setting the KBUILD_EXTSYMVERS make variable.
The Module.symvers files from these path(s) will be included when
searching for symbol versions, and the resulting modules will have
proper symbol version information.
---
  scripts/Makefile.modpost |    2 ++
  scripts/mod/modpost.c    |   10 ++++++----
  2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 9ee9783..a472d3c 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -81,6 +81,8 @@ modpost = scripts/mod/modpost                    \
   $(if $(CONFIG_MODVERSIONS),-m)                  \
   $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
   $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
+ $(if $(KBUILD_EXTSYMVERS),                      \
+   $(foreach dir,$(KBUILD_EXTSYMVERS),-i $(dir)/Module.symvers)) \
   $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
   $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
   $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8f038e6..37de1c3 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -39,6 +39,7 @@ enum export {
  };

  #define PRINTF __attribute__ ((format (printf, 1, 2)))
+#define MAX_SYMVERS 16

  PRINTF void fatal(const char *fmt, ...)
  {
@@ -2044,19 +2045,20 @@ int main(int argc, char **argv)
  {
  	struct module *mod;
  	struct buffer buf = { };
-	char *kernel_read = NULL, *module_read = NULL;
+	char *kernel_read[MAX_SYMVERS] = { 0 }, *module_read = NULL;
  	char *dump_write = NULL;
  	char *markers_read = NULL;
  	char *markers_write = NULL;
  	int opt;
  	int err;
+	int kernel_reads = 0;
  	struct ext_sym_list *extsym_iter;
  	struct ext_sym_list *extsym_start = NULL;

  	while ((opt = getopt(argc, argv, "i:I:e:cmsSo:awM:K:")) != -1) {
  		switch (opt) {
  		case 'i':
-			kernel_read = optarg;
+			kernel_read[kernel_reads++] = optarg;
  			break;
  		case 'I':
  			module_read = optarg;
@@ -2102,8 +2104,8 @@ int main(int argc, char **argv)
  		}
  	}

-	if (kernel_read)
-		read_dump(kernel_read, 1);
+	while (kernel_reads > 0)
+		read_dump(kernel_read[--kernel_reads], 1);
  	if (module_read)
  		read_dump(module_read, 0);
  	while (extsym_start) {
-- 
1.5.6.4

---------------------------------------------------
"If someone's gotta do it, it might as well be me."
                 x@jeffhansen.com
