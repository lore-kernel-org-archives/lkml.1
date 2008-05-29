Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYFEJx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYFEJx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYFEJw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:52:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbYFEJwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:52:47 -0400
To: linux-kernel@vger.kernel.org
In-Reply-To: <20080605.foo@pmac.infradead.org>
References: <20080605.foo@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 29 May 2008 11:01:51 +0300
Subject: [PATCH 03/18] firmware: Add 'firmware_install' make target
Message-Id: <E1K4C9G-0001cI-Nl@bombadil.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This installs all the in-kernel-tree firmware into $(INSTALL_FW_PATH),
which defaults to $(objtree)/usr/lib/firmware and is intended end up
in /lib/firmware for udev to find the files.

This, in conjunction with the builtin-firmware support, makes it simple
for drivers with associated firmware to move over to request_firmware()
and give the user a choice of whether to have it built in to the kernel
image or loaded separately from userspace.

As with kernel header installation for userspace, it intentionally pays
no attention to configuration variables -- it installs _all_ available
firmware blobs, unconditionally.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 Makefile                |    9 +++++++++
 scripts/Makefile.fwinst |   26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 scripts/Makefile.fwinst

diff --git a/Makefile b/Makefile
index 56c243c..2e264f8 100644
--- a/Makefile
+++ b/Makefile
@@ -995,6 +995,15 @@ depend dep:
 	@echo '*** Warning: make $@ is unnecessary now.'
 
 # ---------------------------------------------------------------------------
+# Firmware install
+INSTALL_FW_PATH=$(objtree)/usr/lib/firmware
+export INSTALL_FW_PATH
+
+PHONY += firmware_install
+firmware_install: FORCE
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_install
+
+# ---------------------------------------------------------------------------
 # Kernel headers
 INSTALL_HDR_PATH=$(objtree)/usr
 export INSTALL_HDR_PATH
diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
new file mode 100644
index 0000000..3cf3649
--- /dev/null
+++ b/scripts/Makefile.fwinst
@@ -0,0 +1,26 @@
+# ==========================================================================
+# Installing firmware
+#
+# We don't include the .config, so all firmware files are in $(fw-shipped-)
+# rather than in $(fw-shipped-y) or $(fw-shipped-n).
+# ==========================================================================
+
+INSTALL := install
+
+include scripts/Kbuild.include 
+include $(srctree)/$(obj)/Makefile
+
+installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-))
+installed-fw-dirs := $(sort $(dir $(installed-fw)))
+
+quiet_cmd_install = INSTALL $(subst $(srctree)/,,$@)
+      cmd_install = $(INSTALL) -m0644 $< $@
+
+$(installed-fw-dirs):
+	$(call cmd,mkdir)
+
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)/
+	$(call cmd,install)
+
+.PHONY: __fw_install
+__fw_install: $(installed-fw)
-- 
1.5.4.5

