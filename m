Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZIDB0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZIDB0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbZIDB0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbZIDB0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:26:51 -0400
Date: Thu, 3 Sep 2009 21:26:07 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>,
       Amerigo Wang <amwang@redhat.com>, linux-kbuild@vger.kernel.org
Message-Id: <20090904012835.3749.65615.sendpatchset@localhost.localdomain>
In-Reply-To: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
References: <20090904012755.3749.69645.sendpatchset@localhost.localdomain>
Subject: [Patch 5/5] Makefile: implement "make foo.c.gcov"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Implement "make path/to/file.c.gcov", also introduce a new
env variable "GCOV_OBJ_DIR" which should point to the objects
directory of gcov.
(defaults to /sys/kernel/debug/gcov/path/to/compile)

Signed-off-by: WANG Cong <amwang@redhat.com>

---
Index: linux-2.6/scripts/Makefile.build
===================================================================
--- linux-2.6.orig/scripts/Makefile.build
+++ linux-2.6/scripts/Makefile.build
@@ -169,6 +169,13 @@ cmd_cc_symtypes_c =                     
 $(obj)/%.symtypes : $(src)/%.c FORCE
 	$(call cmd,cc_symtypes_c)
 
+ifdef CONFIG_GCOV_KERNEL
+cmd_gcov_gcov_c       = $(srctree)/scripts/gen_gcov.sh $(GCOV_OBJ_DIR) $<
+
+$(obj)/%.c.gcov: $(src)/%.c FORCE
+	$(call cmd,gcov_gcov_c)
+endif
+
 # C (.c) files
 # The C file is compiled and updated dependency information is generated.
 # (See cmd_cc_o_c + relevant part of rule_cc_o_c)
Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -313,6 +313,7 @@ NM		= $(CROSS_COMPILE)nm
 STRIP		= $(CROSS_COMPILE)strip
 OBJCOPY		= $(CROSS_COMPILE)objcopy
 OBJDUMP		= $(CROSS_COMPILE)objdump
+GCOV		= $(CROSS_COMPILE)gcov
 AWK		= awk
 GENKSYMS	= scripts/genksyms/genksyms
 DEPMOD		= /sbin/depmod
@@ -353,7 +354,7 @@ KERNELVERSION = $(VERSION).$(PATCHLEVEL)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
 export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
-export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
+export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE GCOV
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
@@ -1517,6 +1518,8 @@ endif
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.o: %.c prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
+%.c.gcov: %.c prepare scripts FORCE
+	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.lst: %.c prepare scripts FORCE
 	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.s: %.S prepare scripts FORCE
