Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZCEVd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZCEVd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZCEVdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:33:45 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:42514 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZCEVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:33:44 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: [RFC] make install_headers_all and include/linux/{a.out.h,kvm.h}
Date: Thu, 5 Mar 2009 18:33:49 -0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-desktop-0.rc6.1.1mnb; KDE/4.2.1; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051833.50611.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently with make headers_install_all, include/linux/{a.out.h,kvm.h} are not
included with installed files. This is because basically when using
headers_install_all, scripts/headers.sh is called, and it does
"make ARCH=<arch> ... headers_install" for all working arches. The problem
is that currently the headers install process checks for old headers to remove,
and for some arches there is no kvm.h/asm.out.h, thus they are removed when
headers.sh calls headers_install, and because the order of calls, in the end we
don't have include/linux/{a.out.h,kvm.h}

I don't know if headers_install_all is recommended or supported, but in case it
is, shouldn't we being including always kvm.h and a.out.h in the
headers_install_all case?

If headers_install_all isn't recommended/supported, headers_install_all could
be removed; or if it's expected that user should manually copy kvm.h/asm.out.h
or aware of the current shortcoming, just live with it.

If we must always include them, following patch can be applied, which instead
of verifying presence of asm/{a.out.h,kvm.h} inside kernel sources depending on
arch, checks if they were installed in asm* directory, avoid breaking
headers_install_all case:

---
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

diff -p -up linux-2.6.28/Makefile.orig linux-2.6.28/Makefile
--- linux-2.6.28/Makefile.orig	2009-03-05 14:35:03.000000000 -0300
+++ linux-2.6.28/Makefile	2009-03-05 15:37:06.000000000 -0300
@@ -1081,8 +1081,8 @@ PHONY += headers_install
 headers_install: __headers
 	$(if $(wildcard $(srctree)/$(hdr-dir)/Kbuild),, \
 	$(error Headers not exportable for the $(SRCARCH) architecture))
-	$(Q)$(MAKE) $(hdr-inst)=include
 	$(Q)$(MAKE) $(hdr-inst)=$(hdr-dir) $(hdr-dst)
+	$(Q)$(MAKE) $(hdr-inst)=include
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
@@ -1090,8 +1090,8 @@ headers_check_all: headers_install_all
 
 PHONY += headers_check
 headers_check: headers_install
-	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
 	$(Q)$(MAKE) $(hdr-inst)=$(hdr-dir) $(hdr-dst) HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=include HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Modules
diff -p -up linux-2.6.28/include/linux/Kbuild.orig linux-2.6.28/include/linux/Kbuild
--- linux-2.6.28/include/linux/Kbuild.orig	2009-03-05 15:31:38.000000000 -0300
+++ linux-2.6.28/include/linux/Kbuild	2009-03-05 17:20:11.000000000 -0300
@@ -167,8 +167,7 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
-      		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
+ifneq ($(wildcard $(INSTALL_HDR_PATH)/include/asm*/a.out.h),)
 unifdef-y += a.out.h
 endif
 unifdef-y += apm_bios.h
@@ -262,8 +261,7 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
-      		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
+ifneq ($(wildcard $(INSTALL_HDR_PATH)/include/asm*/kvm.h),)
 unifdef-y += kvm.h
 endif
 unifdef-y += llc.h

--
[]'s
Herton
