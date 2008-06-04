Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYFDVqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYFDVqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYFDVqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:46:38 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40817 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYFDVqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:46:37 -0400
Date: Wed, 4 Jun 2008 23:46:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: [PATCH 1/2] kbuild: drop support for KALLSYMS_EXTRA_PASS
Message-ID: <20080604214644.GB13032@uranus.ravnborg.org>
References: <20080604214514.GA13032@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604214514.GA13032@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 636b71590757772f8a0af2155ae1e6fa0c1f0856 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 4 Jun 2008 22:16:47 +0200
Subject: [PATCH] kbuild: drop support for KALLSYMS_EXTRA_PASS

We have not seen any reports on inconsistent kallsysms data recently
as in the last one or two years. At least I do not recall these
and google had no hits in my searching.

Removing this to simplify the final linking.
When doing "make allyesconfig" build this extra linking
takes considerably time (and I usually forget to turn it off).

In addition this patch removes the debug target: debug_kallsyms

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Paulo Marques <pmarques@grupopie.com>
Cc: Keith Owens <kaos@ocs.com.au>
---
 Makefile     |   38 ++------------------------------------
 init/Kconfig |   12 ------------
 2 files changed, 2 insertions(+), 48 deletions(-)

diff --git a/Makefile b/Makefile
index 8db70fe..911cb90 100644
--- a/Makefile
+++ b/Makefile
@@ -702,7 +702,6 @@ define rule_vmlinux__
 		rm -f $@;                                                    \
 		/bin/false;                                                  \
 	fi;
-	$(verify_kallsyms)
 endef
 
 
@@ -719,28 +718,8 @@ ifdef CONFIG_KALLSYMS
 # o The correct .tmp_kallsyms2.o is linked into the final vmlinux.
 # o Verify that the System.map from vmlinux matches the map from
 #   .tmp_vmlinux2, just in case we did not generate kallsyms correctly.
-# o If CONFIG_KALLSYMS_EXTRA_PASS is set, do an extra pass using
-#   .tmp_vmlinux3 and .tmp_kallsyms3.o.  This is only meant as a
-#   temporary bypass to allow the kernel to be built while the
-#   maintainers work out what went wrong with kallsyms.
 
-ifdef CONFIG_KALLSYMS_EXTRA_PASS
-last_kallsyms := 3
-else
-last_kallsyms := 2
-endif
-
-kallsyms.o := .tmp_kallsyms$(last_kallsyms).o
-
-define verify_kallsyms
-	$(Q)$(if $($(quiet)cmd_sysmap),                                      \
-	  echo '  $($(quiet)cmd_sysmap)  .tmp_System.map' &&)                \
-	  $(cmd_sysmap) .tmp_vmlinux$(last_kallsyms) .tmp_System.map
-	$(Q)cmp -s System.map .tmp_System.map ||                             \
-		(echo Inconsistent kallsyms data;                            \
-		 echo Try setting CONFIG_KALLSYMS_EXTRA_PASS;                \
-		 rm .tmp_kallsyms* ; /bin/false )
-endef
+kallsyms.o := .tmp_kallsyms2.o
 
 # Update vmlinux version before link
 # Use + in front of this rule to silent warning about make -j1
@@ -758,7 +737,7 @@ quiet_cmd_kallsyms = KSYM    $@
       cmd_kallsyms = $(NM) -n $< | $(KALLSYMS) \
                      $(if $(CONFIG_KALLSYMS_ALL),--all-symbols) > $@
 
-.tmp_kallsyms1.o .tmp_kallsyms2.o .tmp_kallsyms3.o: %.o: %.S scripts FORCE
+.tmp_kallsyms1.o .tmp_kallsyms2.o: %.o: %.S scripts FORCE
 	$(call if_changed_dep,as_o_S)
 
 .tmp_kallsyms%.S: .tmp_vmlinux% $(KALLSYMS)
@@ -771,22 +750,9 @@ quiet_cmd_kallsyms = KSYM    $@
 .tmp_vmlinux2: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms1.o FORCE
 	$(call if_changed,vmlinux__)
 
-.tmp_vmlinux3: $(vmlinux-lds) $(vmlinux-all) .tmp_kallsyms2.o FORCE
-	$(call if_changed,vmlinux__)
-
 # Needs to visit scripts/ before $(KALLSYMS) can be used.
 $(KALLSYMS): scripts ;
 
-# Generate some data for debugging strange kallsyms problems
-debug_kallsyms: .tmp_map$(last_kallsyms)
-
-.tmp_map%: .tmp_vmlinux% FORCE
-	($(OBJDUMP) -h $< | $(AWK) '/^ +[0-9]/{print $$4 " 0 " $$2}'; $(NM) $<) | sort > $@
-
-.tmp_map3: .tmp_map2
-
-.tmp_map2: .tmp_map1
-
 endif # ifdef CONFIG_KALLSYMS
 
 # Do modpost on a prelinked vmlinux. The finally linked vmlinux has
diff --git a/init/Kconfig b/init/Kconfig
index 6199d11..5fc1067 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -588,18 +588,6 @@ config KALLSYMS_ALL
 
 	   Say N.
 
-config KALLSYMS_EXTRA_PASS
-	bool "Do an extra kallsyms pass"
-	depends on KALLSYMS
-	help
-	   If kallsyms is not working correctly, the build will fail with
-	   inconsistent kallsyms data.  If that occurs, log a bug report and
-	   turn on KALLSYMS_EXTRA_PASS which should result in a stable build.
-	   Always say N here unless you find a bug in kallsyms, which must be
-	   reported.  KALLSYMS_EXTRA_PASS is only a temporary workaround while
-	   you wait for kallsyms to be fixed.
-
-
 config HOTPLUG
 	bool "Support for hot-pluggable devices" if EMBEDDED
 	default y
-- 
1.5.4.1.143.ge7e51

