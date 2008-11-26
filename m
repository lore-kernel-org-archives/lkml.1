Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYKZF6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYKZF6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYKZF6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:58:35 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:38316 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYKZF6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:58:34 -0500
Message-ID: <492CE3DF.5000603@oracle.com>
Date: Wed, 26 Nov 2008 13:51:27 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "ZANNONI,ELENA" <ELENA.ZANNONI@oracle.com>
Subject: Re: [PATCH] Kbuild: generate debug info in building
References: <4922238C.40807@oracle.com> <20081122114329.GB24848@uranus.ravnborg.org>
In-Reply-To: <20081122114329.GB24848@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.492CE525.0113:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Nov 18, 2008 at 10:08:12AM +0800, Wenji Huang wrote:
>> This patch will generate kernel debuginfo in Kbuild when invoking "make
>> debug_info". The separate debug files are in .debug under building tree.
>> They can help the cases of requiring debug info for tracing/debug tools,
>> especially cross-compilation. Moreover, it can simplify or standardize
>> the packaging process for the distributions those will provide
>> kernel-debuginfo.
>>
>> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> 
> Hi Wenji.
> 
> Can you tell a bit more why we need this?
> I do not see anyone really asking for this.

Thanks for your comments. The debug info files are important to some 
kernel tracing/debug tools, for example systemtap, crashdumps, etc.
We have several considerations:
   * The debuginfo extracting machinery could be integrated into the
     kbuild system. This way it's not just done via RPM macros. So
     generating debuginfo RPMS or something alike can be simplified and
     standardized, also distribution independent.
   * Reduce the size of current file which mixes executable and
     debug sections. Maybe cut the time of analysis for
     elfutils/binutils which is used by some other tools.
> 
> Apart form the rationale why this is needed I have a few
> comments to your patch.

Please see updated one.

Regards,
Wenji

diff --git a/Makefile b/Makefile
index 7b1f238..4151f53 100644
--- a/Makefile
+++ b/Makefile
@@ -814,6 +814,19 @@ define rule_vmlinux-modpost
         $(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
  endef

+quiet_cmd_vmlinux_debug = GEN     $<.debug
+      cmd_vmlinux_debug = mkdir -p debug; 
         \
+                          $(OBJCOPY) --only-keep-debug 
         \
+                                     $< debug/$<.debug
+targets += vmlinux.debug
+
+PHONY += debug_info
+debug_info: vmlinux FORCE
+ifdef CONFIG_DEBUG_INFO
+       $(call if_changed,vmlinux_debug)
+       $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
+endif
+
  # vmlinux image - including updated kernel symbols
  vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o 
$(kallsyms.o) FORCE
  ifdef CONFIG_HEADERS_CHECK
@@ -1250,6 +1263,7 @@ help:
         @echo  '  all             - Build all targets marked with [*]'
         @echo  '* vmlinux         - Build the bare kernel'
         @echo  '* modules         - Build all modules'
+       @echo  '  debug_info      - Generate debug info files in debug'
         @echo  '  modules_install - Install all modules to 
INSTALL_MOD_PATH (default: /)'
         @echo  '  firmware_install- Install all firmware to 
INSTALL_FW_PATH'
         @echo  '                    (default: 
$$(INSTALL_MOD_PATH)/lib/firmware)'
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index f4053dc..6e630e6 100644
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
+       $(call if_changed,debug_ko)
+endif

  # Add FORCE to the prequisites of a target to force it to be always 
rebuilt.
  # 
---------------------------------------------------------------------------
