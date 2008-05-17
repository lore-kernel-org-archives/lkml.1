Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYEQMwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYEQMwZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 08:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbYEQMwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 08:52:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41636 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302AbYEQMwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 08:52:17 -0400
Date: Sat, 17 May 2008 14:52:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: your change to prevent needless re-building of vmlinux.o
Message-ID: <20080517125204.GA19741@uranus.ravnborg.org>
References: <482DCD89.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482DCD89.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan.

On Fri, May 16, 2008 at 05:08:09PM +0100, Jan Beulich wrote:
> Sam,
> 
> while also looking into this issue (found time only now) I realized this is
> already worked around in .26-rc2. However, it would seem to me that
> suppressing the dependency on init/built-in.o altogether is likely to
> cause problems in the future.
What is not obvious is that the only reason we link vmlinux.o is to
support the section mismatch check.
I once had a version where I used vmlinux.o as an intermediate step
but that did not speed up the following link so I dropped it again.
Therefore the suppressed init/built-in.o dependency will only
cause us to miss a section mismatch check in very rare cases and
will not cause troubles for a normal kernel link.

I have also had in mind to make the vmlinux.o link dependent
on CONFIG_DEBUG_SECTION_MISMATCH so we could skip it for a
kernel build where we do not do this analysis.
But the vmlinux.o link were kept on the rationale that
CONFIG_DEBUG_SECTION_MISMATCH should be used to trigger an
analysis for all links and in the normal situation we would
do the check only on vmlinux.o and for the individual modules.

So I hope this explains why init/built-in.o is supressed today.


> Going through the version generating
> logic again I realized that since vmlinux.o is always built before the first
> of the (perhaps multiple, due to kallsyms) final linking stages, it ought
> to be possible to simply move the version generation into the vmlinux.o
> rule. And indeed, this
> 
> define rule_vmlinux-modpost
> 	:
> 	+$(call cmd,vmlinux_version)
> 	+$(call cmd,vmlinux-modpost)
> 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
> 	$(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
> endef
> 
> with the two other invocations of vmlinux_version removed, seems to
> do what is wanted.A

So what you suggest is something like this:

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
