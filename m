Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbZDNBnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbZDNBnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZDNBnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:43:45 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:18048 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZDNBno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:43:44 -0400
Message-ID: <49E3E944.2040505@oracle.com>
Date: Tue, 14 Apr 2009 09:39:16 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
CC: tytso@MIT.EDU, Elena Zannoni <elena.zannoni@oracle.com>,
       Roland McGrath <roland@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [Fwd: [PATCH 1/1] Separate the debuginfo out from kbuild]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.49E3EA3A.0173:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Roland to cc

-------- Original Message --------
Subject: [PATCH 1/1] Separate the debuginfo out from kbuild
Date: Wed,  8 Apr 2009 22:06:21 -0400
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org, tytso@MIT.EDU, 
elena.zannoni@oracle.com, Wenji Huang <wenji.huang@oracle.com>

This patch will add "make debug_info" to split debuginfo files. The
separate debug files are under debug directory of building tree.

It is based on two considerations:
    * The debuginfo extracting machinery could be integrated into the
      kbuild system. This way it's not just done via RPM macros. So
      generating debuginfo RPMS or something alike can be simplified
      and standardized, also distribution independent.
    * Reduce the size of current file which mixes executable and
      debug sections. For example, 7% off for vmlinux.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
  Makefile                 |   14 ++++++++++++++
  scripts/Makefile.modpost |   12 ++++++++++++
  2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index e5ad5fd..0df7581 100644
--- a/Makefile
+++ b/Makefile
@@ -832,6 +832,19 @@ define rule_vmlinux-modpost
  	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
  endef

+quiet_cmd_vmlinux_debug = GEN     $<.debug
+      cmd_vmlinux_debug = mkdir -p debug;         \
+                          $(OBJCOPY) --only-keep-debug         \
+                                     $< debug/$<.debug
+targets += vmlinux.debug
+
+PHONY += debug_info
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
@@ -1278,6 +1291,7 @@ help:
  	@echo  '  all		  - Build all targets marked with [*]'
  	@echo  '* vmlinux	  - Build the bare kernel'
  	@echo  '* modules	  - Build all modules'
+	@echo  '  debug_info      - Extract debug info to debug directory'
  	@echo  '  modules_install - Install all modules to INSTALL_MOD_PATH 
(default: /)'
  	@echo  '  firmware_install- Install all firmware to INSTALL_FW_PATH'
  	@echo  '                    (default: $$(INSTALL_MOD_PATH)/lib/firmware)'
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index f4053dc..c120261 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -137,6 +137,18 @@ $(modules): %.ko :%.o %.mod.o FORCE

  targets += $(modules)

+modules-debug := $(modules:.ko=.ko.debug)
+quiet_cmd_debug_ko = GEN     $@
+      cmd_debug_ko = mkdir -p debug/$(dir $@);                         \
+                    $(OBJCOPY) --only-keep-debug $< debug/$@
+targets += $(modules-debug)
+
+debug_info: $(modules-debug) FORCE
+
+ifdef CONFIG_DEBUG_INFO
+$(modules-debug): $(modules) FORCE
+	$(call if_changed,debug_ko)
+endif

  # Add FORCE to the prequisites of a target to force it to be always 
rebuilt.
  # 
---------------------------------------------------------------------------
-- 
1.5.6

