Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYB1Ikw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYB1Ikw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYB1Ik3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:40:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:41998 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754494AbYB1Ik2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:40:28 -0500
X-Authenticated: #8077970
X-Provags-ID: V01U2FsdGVkX1+zsaMQIWWzhfR3BNf2TcC0DnQbjCcJtt4L+VCyqS
	gaQNWpKoODvY4y
From: Richard Hacker <lerichi@gmx.net>
To: kai@germaschewski.name, sam@ravnborg.org
Subject: [PATCH 002/002] scripts/Makefile.modpost: New Kbuild variable EXTRA_SYMBOLS
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 28 Feb 2008 09:40:58 +0100
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200802280940.58916.lerichi@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new (Kbuild) Makefile variable EXTRA_SYMBOLS. The 
space separated list of files assigned to EXTRA_SYMBOLS is used when 
calling scripts/mod/modpost during stage 2 of the Kbuild process for 
non-kernel-tree modules. When the previous patch 001/002 is applied to 
modpost.c, modpost loads these files during initialisation of its symbol
table.

Signed-off-by: Richard Hacker <lerichi@gmx.net>

---
The previous patch in this series (001/002) added a new command line 
argument -E to scripts/mod/modpost.c, instructing modpost to process
the symbols in that file during initialisation of its symbol tables.

This patch introduces a new make variable EXTRA_SYMBOLS. The space 
separated list of files assigned to this variable is passed to modpost 
using the the new -E command line argument. This introduces the possibility
to supply a set of Modules.symvers for modpost to load during initialisation
of it symbol tables.

I hope this patch is useful and finds its way into the kernel.

o Changes from the previous attempt:
   - Documentation update

diff -uprN -X linux-2.6.24/Documentation/dontdiff 
linux-2.6.24-vanilla/Documentation/kbuild/modules.txt 
linux-2.6.24/Documentation/kbuild/modules.txt
--- linux-2.6.24-vanilla/Documentation/kbuild/modules.txt	2008-01-18 
22:43:41.000000000 +0100
+++ linux-2.6.24/Documentation/kbuild/modules.txt	2008-02-28 
09:30:55.000000000 +0100
@@ -486,7 +486,7 @@ Module.symvers contains a list of all ex
 	Sometimes, an external module uses exported symbols from another
 	external module. Kbuild needs to have full knowledge on all symbols
 	to avoid spitting out warnings about undefined symbols.
-	Two solutions exist to let kbuild know all symbols of more than
+	Three solutions exist to let kbuild know all symbols of more than
 	one external module.
 	The method with a top-level kbuild file is recommended but may be
 	impractical in certain situations.
@@ -523,6 +523,12 @@ Module.symvers contains a list of all ex
 		containing the sum of all symbols defined and not part of the
 		kernel.
 
+	Use make variable EXTRA_SYMBOLS in the Makefile
+		If it is impractical to copy Module.symvers from another
+		module, you can assign a space separated list of files to 
+		EXTRA_SYMBOLS in your Makfile. These files will be loaded
+		by modpost during the initialisation of its symbol tables.
+
 === 8. Tips & Tricks
 
 --- 8.1 Testing for CONFIG_FOO_BAR
diff -uprN -X linux-2.6.24/Documentation/dontdiff 
linux-2.6.24-vanilla/scripts/Makefile.modpost 
linux-2.6.24/scripts/Makefile.modpost
--- linux-2.6.24-vanilla/scripts/Makefile.modpost	2008-01-18 
22:47:09.000000000 +0100
+++ linux-2.6.24/scripts/Makefile.modpost	2008-02-27 21:14:36.000000000 +0100
@@ -41,6 +41,12 @@ _modpost: __modpost
 
 include include/config/auto.conf
 include scripts/Kbuild.include
+
+ifneq ($(KBUILD_EXTMOD),)
+# Include the module's Makefile to find EXTRA_SYMBOLS
+include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), $(KBUILD_EXTMOD)/Kbuild, 
$(KBUILD_EXTMOD)/Makefile)
+endif
+
 include scripts/Makefile.lib
 
 kernelsymfile := $(objtree)/Module.symvers
@@ -61,6 +67,7 @@ modpost = scripts/mod/modpost           
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
+ $(if $(EXTRA_SYMBOLS), $(patsubst %, -E %,$(EXTRA_SYMBOLS)))      \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
