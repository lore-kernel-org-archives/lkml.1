Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYGVSnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYGVSnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYGVSnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:43:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYGVSnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:43:31 -0400
Subject: Re: Firmware breakage
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080722191910.11eef7c4@lxorguk.ukuu.org.uk>
References: <20080722173420.6f90556d@lxorguk.ukuu.org.uk>
	 <1216748431.3019.6.camel@shinybook.infradead.org>
	 <20080722190516.4ee477f4@lxorguk.ukuu.org.uk>
	 <1216751464.3019.29.camel@shinybook.infradead.org>
	 <20080722191910.11eef7c4@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 14:43:16 -0400
Message-Id: <1216752196.3019.32.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 19:19 +0100, Alan Cox wrote:
> > I was planning to build the firmware binaries as part of 'make modules'
> > anyway, because Rafael had related problems (not being able to write to
> > the NFS-exported kernel tree at all).
> 
> Yes I just hit that problem too.

I'm testing this now...

diff --git a/Makefile b/Makefile
index 6192922..3b43ddb 100644
--- a/Makefile
+++ b/Makefile
@@ -1061,6 +1061,7 @@ modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux)
 	$(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
 	@echo '  Building modules, stage 2.';
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modbuild
 
 
 # Target to prepare building external modules
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index c972c0f..e1b3159 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -17,14 +17,15 @@ include $(srctree)/$(obj)/Makefile
 
 include scripts/Makefile.host
 
-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-m))
-
+mod-fw := $(fw-shipped-m)
 # If CONFIG_FIRMWARE_IN_KERNEL isn't set, then install the 
 # firmware for in-kernel drivers too.
 ifndef CONFIG_FIRMWARE_IN_KERNEL
-mod-fw += $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-y))
+mod-fw += $(fw-shipped-y)
 endif
 
+installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
+
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
 installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/.
 
@@ -49,7 +50,8 @@ PHONY +=  __fw_install __fw_modinst FORCE
 .PHONY: $(PHONY)
 
 __fw_install: $(installed-fw)
-__fw_modinst: $(mod-fw)
+__fw_modinst: $(installed-mod-fw)
+__fw_modbuild: $(mod-fw)
 
 FORCE:
 

-- 
dwmw2

