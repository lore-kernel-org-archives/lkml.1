Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYESHfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYESHfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYESHfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:35:44 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:17902 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYESHfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:35:41 -0400
Message-Id: <48314A00.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 19 May 2008 08:36:00 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: your change to prevent needless re-building of vmlinux.o
References: <482DCD89.76E4.0078.0@novell.com>
 <20080517125204.GA19741@uranus.ravnborg.org>
In-Reply-To: <20080517125204.GA19741@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>So what you suggest is something like this:

Yes, exactly:
Acked-by: Jan Beulich <jbeulich@novell.com>

diff --git a/Makefile b/Makefile
index 3140145..3dbfffc 100644
--- a/Makefile
+++ b/Makefile
@@ -657,7 +657,6 @@ vmlinux-init := $(head-y) $(init-y)
 vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
 vmlinux-all  := $(vmlinux-init) $(vmlinux-main)
 vmlinux-lds  := arch/$(SRCARCH)/kernel/vmlinux.lds
-export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
 
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
@@ -690,8 +689,6 @@ quiet_cmd_sysmap = SYSMAP
 # First command is ':' to allow us to use + in front of the rule
 define rule_vmlinux__
 	:
-	$(if $(CONFIG_KALLSYMS),,+$(call cmd,vmlinux_version))
-
 	$(call cmd,vmlinux__)
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd 
 
@@ -747,8 +744,7 @@ endef
 # First command is ':' to allow us to use + in front of this rule
 cmd_ksym_ld = $(cmd_vmlinux__)
 define rule_ksym_ld
-	: 
-	+$(call cmd,vmlinux_version)
+	:
 	$(call cmd,vmlinux__)
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd 
 endef
@@ -798,6 +794,7 @@ quiet_cmd_vmlinux-modpost = LD      $@
 define rule_vmlinux-modpost
 	:
 	+$(call cmd,vmlinux-modpost)
+	+$(call cmd,vmlinux_version)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
 endef
@@ -810,7 +807,6 @@ endif
 ifdef CONFIG_SAMPLES
 	$(Q)$(MAKE) $(build)=samples
 endif
-	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
 

This is a welcome simplifications and I like it.
If we decide to keep the intermediate vmlinux.o link than we should
do so.
If you agree I can try to give it a spin in -next.
[There are two unrelated clean-ups in the patch - both are noops].

Everything that can simplify the final link of vmlinux is welcome.

I have several times been tempted to move it all to a shell script.
What has prevented me to do so has only been:
1) that um has some subtle requirement and therefore redefine the
   vmlinux link
2) that last time I reworked this stuff Andrew could not boot one
   of his systems and I never figured out why
3) lack of time..

But if someone comes up with a patch that moves all this stuff out
of the top-level Makefile I am all open for it.

> 
> What do you think? Am I overlooking some aspect here?
> 
> Btw., another slight anomaly I noticed is that modpost on the modules
> is always performed (even when nothing changed in the tree), while
> on vmlinux.o it is only performed when something caused a re-link. Is
> that intentional, or just a to-be-tolerated side effect?
It is intentional as in we do not have information available
if a module has been build or not.
modpost take care not to overwrite module.mod.c files if the
generated file equals the old file. But could we skip the modpost
entirely it would be better. But that was not trivial last I looked
at it (loong time ago).

	Sam

