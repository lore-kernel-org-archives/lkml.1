Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYDFUXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYDFUXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYDFUXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:23:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:58374 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbYDFUXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:23:42 -0400
From: Segher Boessenkool <segher@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] make help: Show defconfig subdirs
Date: Sun,  6 Apr 2008 22:16:07 +0200
Message-Id: <f70d44df351c88b7754e2ca93c6075f9660d3a40.1207512931.git.segher@kernel.crashing.org>
X-Mailer: git-send-email 1.5.4.4.604.g21d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC will start moving board defconfigs into subarch-specific
subdirs soon.  "make help" currently does not look in subdirs to
find the defconfigs to show.  This is partially a good thing,
since there are way too many defconfigs for one list.

This patch makes the main "make help" display something like

  help-40x         - Show 40x-specific targets
  help-44x         - Show 44x-specific targets
  help-boards      - Show all of the above

and wires up stuff so those new help-* commands actually work.

Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
---
 Makefile |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index fec2a12..05d9fda 100644
--- a/Makefile
+++ b/Makefile
@@ -1172,6 +1172,8 @@ rpm: include/config/kernel.release FORCE
 
 boards := $(wildcard $(srctree)/arch/$(ARCH)/configs/*_defconfig)
 boards := $(notdir $(boards))
+board-dirs := $(dir $(wildcard $(srctree)/arch/$(ARCH)/configs/*/*_defconfig))
+board-dirs := $(sort $(notdir $(board-dirs:/=)))
 
 help:
 	@echo  'Cleaning targets:'
@@ -1225,6 +1227,11 @@ help:
 		$(foreach b, $(boards), \
 		printf "  %-24s - Build for %s\\n" $(b) $(subst _defconfig,,$(b));) \
 		echo '')
+	@$(if $(board-dirs), \
+		$(foreach b, $(board-dirs), \
+		printf "  %-16s - Show %s-specific targets\\n" help-$(b) $(b);) \
+		printf "  %-16s - Show all of the above\\n" help-boards; \
+		echo '')
 
 	@echo  '  make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build'
 	@echo  '  make V=2   [targets] 2 => give reason for rebuild of target'
@@ -1236,6 +1243,20 @@ help:
 	@echo  'For further info see the ./README file'
 
 
+help-board-dirs := $(addprefix help-,$(board-dirs))
+
+help-boards: $(help-board-dirs)
+
+boards-per-dir = $(notdir $(wildcard $(srctree)/arch/$(ARCH)/configs/$*/*_defconfig))
+
+$(help-board-dirs): help-%:
+	@echo  'Architecture specific targets ($(ARCH) $*):'
+	@$(if $(boards-per-dir), \
+		$(foreach b, $(boards-per-dir), \
+		printf "  %-24s - Build for %s\\n" $*/$(b) $(subst _defconfig,,$(b));) \
+		echo '')
+
+
 # Documentation targets
 # ---------------------------------------------------------------------------
 %docs: scripts_basic FORCE
-- 
1.5.3.4.208.g805a

