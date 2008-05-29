Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYE2IaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYE2IaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYE2I3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:29:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbYE2I3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:29:53 -0400
Subject: [PATCH 29/28] firmware: Add 'firmware_install' make target
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       johannes@sipsolutions.net
In-Reply-To: <1211975163.3902.11.camel@shinybook.infradead.org>
References: <1211708969@pmac.infradead.org>
	 <E1K0DOP-0007EW-F0@shinybook.infradead.org>
	 <1211734802.31212.129.camel@shinybook.infradead.org>
	 <1211792300.23085.1.camel@pmac.infradead.org>
	 <1211975163.3902.11.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 11:29:13 +0300
Message-Id: <1212049753.15816.9.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
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
index ac2ab7e..3521afe 100644
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
index 0000000..bde4073
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
+installed-fw-dirs := $(dir $(installed-fw))
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


-- 
dwmw2

