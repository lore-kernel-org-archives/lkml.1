Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZASUVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZASUVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbZASUVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:21:39 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45077 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZASUVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:21:38 -0500
Date: Mon, 19 Jan 2009 21:21:37 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
In-Reply-To: <20090118210416.GE2978@uranus.ravnborg.org>
Message-ID: <alpine.LSU.2.00.0901192120400.12940@fbirervta.pbzchgretzou.qr>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org> <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr> <20081226194833.GA8306@uranus.ravnborg.org> <alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
 <20090118210416.GE2978@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2009-01-18 22:04, Sam Ravnborg wrote:
>
>Can I ask you to redo this patch.
>I want a way to swith off compression, but it should default be enable.
>So if KBUILD_MODULE_NOCOMPRESS is undefined we will compress the modules
>when we install them.
>
>And add documentation to Documentation/kbuild/kbuild.txt too...

changes to previous:
- added choice for compress (none, -1, -2, ..., -9)
- documentation

parent ad2507ab58aa5a3e50b0482889882ff3adf6ef33 (v2.6.29-rc2-24-gad2507a)
commit 3fc20a79496c3c5c8d4b906ea7e2496de448002d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jan 19 21:18:39 2009 +0100

kbuild: install modules gzipped

This saves lots of disk space. Yes we had discussions about gzip -6
having a better compression-per-time ratio, but the point is that
people doing the compression in the first place often do not care
about the amount of compression time as long as the final filesize
will be smaller (that's what LZMA does over bzip2, and what bzip2
does over gzip). The KBUILD_MODULES_COMPRESS make variable can be set
over the command line to tune the compression level to your need,
including disabling it entirely.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Documentation/kbuild/kbuild.txt |   11 +++++++++++
 scripts/Makefile.modinst        |    6 +++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 923f9dd..453ba6c 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -125,6 +125,17 @@ KBUILD_EXTRA_SYMBOLS
 For modules use symbols from another modules.
 See more details in modules.txt.
 
+KBUILD_MODULES_COMPRESS
+--------------------------------------------------
+By default, kbuild will compress modules with gzip -9 compression to
+reduce disk space. The KBUILD_MODULES_COMPRESS make parameter can be
+used to set an alternate compression level or disable compression
+entirely.
+Example for using the standard gzip compression level:
+	make KBUILD_MODULES_COMPRESS="-6"
+Disabling compression:
+	make KBUILD_MODULES_COMPRESS=""
+
 ALLSOURCE_ARCHS
 --------------------------------------------------
 For tags/TAGS/cscope targets, you can specify more than one archs
diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index 18b4bf8..e0708b1 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -16,9 +16,13 @@ PHONY += $(modules)
 __modinst: $(modules)
 	@:
 
+KBUILD_MODULES_COMPRESS  ?= -9
 quiet_cmd_modules_install = INSTALL $@
       cmd_modules_install = mkdir -p $(2); \
-			    $(mod_strip_cmd) $@ $(2)/$(notdir $@) || cp $@ $(2)
+			    $(mod_strip_cmd) $@ $(2)/$(notdir $@) || cp $@ $(2); \
+			    $(if ${KBUILD_MODULES_COMPRESS}, \
+			    	gzip -f ${KBUILD_MODULES_COMPRESS} \
+			    	$(2)/$(notdir $@), )
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
-- 
# Created with git-export-patch
