Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYGQGot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYGQGot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYGQGol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:44:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50694 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbYGQGol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:44:41 -0400
Subject: Re: {build fail} firmware: latest Linus tree modules_install fail
From: David Woodhouse <dwmw2@infradead.org>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <487ED5E3.1060900@cn.fujitsu.com>
References: <487ED5E3.1060900@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 23:44:32 -0700
Message-Id: <1216277072.2480.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 13:17 +0800, Wang Chen wrote:
> make[1]: *** No rule to make target `/lib/firmware/$(dir', needed by `/lib/firmware/ttusb-budget/dspbootcode.bin'.  Stop.
> make: *** [_modinst_post] Error 2
> 
> This error was outputed when I build the latest git tree of Linus's linux-2.6.

Thank you for the report. Please could you confirm that this fixes it
for you?

----
Subject: Update scripts/Makefile.fwinst to cope with older make

Also fix unwanted rebuilds of the firmware/ihex2fw tool by including
the .ihex2fw.cmd file when present.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 3d2f460..92305a3 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -28,18 +28,39 @@ endif
 installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
 installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/.
 
+# Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
+PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
+$(INSTALL_FW_PATH)/$$(%): install-all-dirs
+	@true
+install-all-dirs: $(installed-fw-dirs)
+	@true
+
 quiet_cmd_install = INSTALL $(subst $(srctree)/,,$@)
       cmd_install = $(INSTALL) -m0644 $< $@
 
 $(installed-fw-dirs):
 	$(call cmd,mkdir)
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)/
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
 	$(call cmd,install)
 
-.PHONY: __fw_install __fw_modinst FORCE
+PHONY +=  __fw_install __fw_modinst FORCE
+
+.PHONY: $(PHONY)
 
 __fw_install: $(installed-fw)
 __fw_modinst: $(mod-fw)
 
 FORCE:
+
+# Read all saved command lines and dependencies for the $(targets) we
+# may be building using $(if_changed{,_dep}). As an optimization, we 
+# don't need to read them if the target does not exist; we will rebuild
+# anyway in that case.
+
+targets := $(wildcard $(sort $(targets)))
+cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
+
+ifneq ($(cmd_files),)
+  include $(cmd_files)
+endif


-- 
dwmw2

