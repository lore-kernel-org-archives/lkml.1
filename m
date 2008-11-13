Return-Path: <linux-kernel-owner+w=401wt.eu-S1753187AbYKMBno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbYKMBno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKMBnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:43:33 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:49167 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYKMBnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:43:32 -0500
Message-ID: <491B84AB.6060302@oracle.com>
Date: Thu, 13 Nov 2008 09:36:43 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Elena Zannoni <elena.zannoni@oracle.com>,
       "VAN HEES,KRIS" <kris.van.hees@oracle.com>
Subject: [PATCH v1] Kbuild: generate debug info in building
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.491B85E2.00B7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will generate kernel debuginfo in Kbuild when invoking "make
debug_info". The separate debug files are in .debug under building tree.
They can help the cases of requiring debug info for tracing/debug tools,
especially cross-compilation. Moreover, it can simplify or standardize 
the packaging process for the distributions those will provide 
kernel-debuginfo.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
  Makefile                 |   14 ++++++++++++++
  scripts/Makefile.modpost |   14 ++++++++++++++
  2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 7f9ff9b..eed7510 100644
--- a/Makefile
+++ b/Makefile
@@ -814,6 +814,20 @@ define rule_vmlinux-modpost
  	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
  endef

+ifdef CONFIG_DEBUG_INFO
+quiet_cmd_vmlinux_debug = GEN     $<.debug
+      cmd_vmlinux_debug = mkdir -p .debug;                          \
+                          $(OBJCOPY) --only-keep-debug              \
+                                     $< .debug/$<.debug
+targets += vmlinux.debug
+endif
+
+debug_info: vmlinux FORCE
+ifdef CONFIG_DEBUG_INFO
+	$(call if_changed,vmlinux_debug)
+	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
+endif
+
  # vmlinux image - including updated kernel symbols
  vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o
$(kallsyms.o) FORCE
  ifdef CONFIG_HEADERS_CHECK
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index f4053dc..0df73b2 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -137,6 +137,20 @@ $(modules): %.ko :%.o %.mod.o FORCE

  targets += $(modules)

+modules-debug := $(modules:.ko=.ko.debug)
+ifdef CONFIG_DEBUG_INFO
+quiet_cmd_debug_ko = GEN     $@
+      cmd_debug_ko = mkdir -p .debug/`dirname $@`;			\
+		     $(OBJCOPY) --only-keep-debug $< .debug/$@
+targets += $(modules-debug)
+endif
+
+debug_info: $(modules-debug) FORCE
+
+$(modules-debug): $(modules) FORCE
+ifdef CONFIG_DEBUG_INFO
+	$(call if_changed,debug_ko)
+endif

  # Add FORCE to the prequisites of a target to force it to be always
rebuilt.
  #
---------------------------------------------------------------------------
-- 
1.5.6

