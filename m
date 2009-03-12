Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZCLUAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZCLUAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZCLUAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:00:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:33832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZCLUAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:00:03 -0400
Date: Thu, 12 Mar 2009 19:57:30 GMT
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, pebolle@tiscali.nl,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1236879901.24144.26.camel@test.thuisdomein>
References: <1236879901.24144.26.camel@test.thuisdomein>
Subject: [tip:x86/setup] x86: remove additional vestiges of the zImage/bzImage split
Message-ID: <tip-f9c5107c2bcad91dd56d23888653d7bfa1a9696e@git.kernel.org>
Git-Commit-ID: f9c5107c2bcad91dd56d23888653d7bfa1a9696e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 19:57:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9c5107c2bcad91dd56d23888653d7bfa1a9696e
Gitweb:     http://git.kernel.org/tip/f9c5107c2bcad91dd56d23888653d7bfa1a9696e
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 12 Mar 2009 12:50:33 -0700
Commit:     H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 12 Mar 2009 12:50:33 -0700

x86: remove additional vestiges of the zImage/bzImage split

Impact: cleanup

Remove targets that were used for zImage only, and Makefile
infrastructure that was there to support the zImage/bzImage split.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
LKML-Reference: <1236879901.24144.26.camel@test.thuisdomein>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/Makefile      |   27 ++++++++-------------------
 arch/x86/boot/Makefile |   29 ++++++++++++++++-------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1836191..43bd89c 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -153,34 +153,23 @@ endif
 
 boot := arch/x86/boot
 
-PHONY += zImage bzImage compressed zlilo bzlilo \
-         zdisk bzdisk fdimage fdimage144 fdimage288 isoimage install
+BOOT_TARGETS = bzlilo bzdisk fdimage fdimage144 fdimage288 isoimage install
+
+PHONY += bzImage $(BOOT_TARGETS)
 
 # Default kernel to build
 all: bzImage
 
 # KBUILD_IMAGE specify target image being built
-                    KBUILD_IMAGE := $(boot)/bzImage
-zImage zlilo zdisk: KBUILD_IMAGE := $(boot)/zImage
+KBUILD_IMAGE := $(boot)/bzImage
 
-zImage bzImage: vmlinux
+bzImage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(KBUILD_IMAGE)
 	$(Q)mkdir -p $(objtree)/arch/$(UTS_MACHINE)/boot
 	$(Q)ln -fsn ../../x86/boot/bzImage $(objtree)/arch/$(UTS_MACHINE)/boot/$@
 
-compressed: zImage
-
-zlilo bzlilo: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zlilo
-
-zdisk bzdisk: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) zdisk
-
-fdimage fdimage144 fdimage288 isoimage: vmlinux
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
-
-install:
-	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
+$(BOOT_TARGETS): vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $@
 
 PHONY += vdso_install
 vdso_install:
@@ -208,4 +197,4 @@ endef
 
 CLEAN_FILES += arch/x86/boot/fdimage \
 	       arch/x86/boot/image.iso \
-	       arch/x86/boot/mtools.conf
+	       arch/x86/boot/mtools.conf        
\ No newline at end of file
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 57a29fe..2a3db75 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -109,9 +109,11 @@ $(obj)/setup.bin: $(obj)/setup.elf FORCE
 $(obj)/compressed/vmlinux: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
 
-# Set this if you want to pass append arguments to the zdisk/fdimage/isoimage kernel
+# Set this if you want to pass append arguments to the
+# bzdisk/fdimage/isoimage kernel
 FDARGS =
-# Set this if you want an initrd included with the zdisk/fdimage/isoimage kernel
+# Set this if you want an initrd included with the
+# bzdisk/fdimage/isoimage kernel
 FDINITRD =
 
 image_cmdline = default linux $(FDARGS) $(if $(FDINITRD),initrd=initrd.img,)
@@ -120,7 +122,7 @@ $(obj)/mtools.conf: $(src)/mtools.conf.in
 	sed -e 's|@OBJ@|$(obj)|g' < $< > $@
 
 # This requires write access to /dev/fd0
-zdisk: $(BOOTIMAGE) $(obj)/mtools.conf
+bzdisk: $(obj)/bzImage $(obj)/mtools.conf
 	MTOOLSRC=$(obj)/mtools.conf mformat a:			; sync
 	syslinux /dev/fd0					; sync
 	echo '$(image_cmdline)' | \
@@ -128,10 +130,10 @@ zdisk: $(BOOTIMAGE) $(obj)/mtools.conf
 	if [ -f '$(FDINITRD)' ] ; then \
 		MTOOLSRC=$(obj)/mtools.conf mcopy '$(FDINITRD)' a:initrd.img ; \
 	fi
-	MTOOLSRC=$(obj)/mtools.conf mcopy $(BOOTIMAGE) a:linux	; sync
+	MTOOLSRC=$(obj)/mtools.conf mcopy $(obj)/bzImage a:linux	; sync
 
 # These require being root or having syslinux 2.02 or higher installed
-fdimage fdimage144: $(BOOTIMAGE) $(obj)/mtools.conf
+fdimage fdimage144: $(obj)/bzImage $(obj)/mtools.conf
 	dd if=/dev/zero of=$(obj)/fdimage bs=1024 count=1440
 	MTOOLSRC=$(obj)/mtools.conf mformat v:			; sync
 	syslinux $(obj)/fdimage					; sync
@@ -140,9 +142,9 @@ fdimage fdimage144: $(BOOTIMAGE) $(obj)/mtools.conf
 	if [ -f '$(FDINITRD)' ] ; then \
 		MTOOLSRC=$(obj)/mtools.conf mcopy '$(FDINITRD)' v:initrd.img ; \
 	fi
-	MTOOLSRC=$(obj)/mtools.conf mcopy $(BOOTIMAGE) v:linux	; sync
+	MTOOLSRC=$(obj)/mtools.conf mcopy $(obj)/bzImage v:linux	; sync
 
-fdimage288: $(BOOTIMAGE) $(obj)/mtools.conf
+fdimage288: $(obj)/bzImage $(obj)/mtools.conf
 	dd if=/dev/zero of=$(obj)/fdimage bs=1024 count=2880
 	MTOOLSRC=$(obj)/mtools.conf mformat w:			; sync
 	syslinux $(obj)/fdimage					; sync
@@ -151,9 +153,9 @@ fdimage288: $(BOOTIMAGE) $(obj)/mtools.conf
 	if [ -f '$(FDINITRD)' ] ; then \
 		MTOOLSRC=$(obj)/mtools.conf mcopy '$(FDINITRD)' w:initrd.img ; \
 	fi
-	MTOOLSRC=$(obj)/mtools.conf mcopy $(BOOTIMAGE) w:linux	; sync
+	MTOOLSRC=$(obj)/mtools.conf mcopy $(obj)/bzImage w:linux	; sync
 
-isoimage: $(BOOTIMAGE)
+isoimage: $(obj)/bzImage
 	-rm -rf $(obj)/isoimage
 	mkdir $(obj)/isoimage
 	for i in lib lib64 share end ; do \
@@ -163,7 +165,7 @@ isoimage: $(BOOTIMAGE)
 		fi ; \
 		if [ $$i = end ] ; then exit 1 ; fi ; \
 	done
-	cp $(BOOTIMAGE) $(obj)/isoimage/linux
+	cp $(obj)/bzImage $(obj)/isoimage/linux
 	echo '$(image_cmdline)' > $(obj)/isoimage/isolinux.cfg
 	if [ -f '$(FDINITRD)' ] ; then \
 		cp '$(FDINITRD)' $(obj)/isoimage/initrd.img ; \
@@ -174,12 +176,13 @@ isoimage: $(BOOTIMAGE)
 	isohybrid $(obj)/image.iso 2>/dev/null || true
 	rm -rf $(obj)/isoimage
 
-zlilo: $(BOOTIMAGE)
+bzlilo: $(obj)/bzImage
 	if [ -f $(INSTALL_PATH)/vmlinuz ]; then mv $(INSTALL_PATH)/vmlinuz $(INSTALL_PATH)/vmlinuz.old; fi
 	if [ -f $(INSTALL_PATH)/System.map ]; then mv $(INSTALL_PATH)/System.map $(INSTALL_PATH)/System.old; fi
-	cat $(BOOTIMAGE) > $(INSTALL_PATH)/vmlinuz
+	cat $(obj)/bzImage > $(INSTALL_PATH)/vmlinuz
 	cp System.map $(INSTALL_PATH)/
 	if [ -x /sbin/lilo ]; then /sbin/lilo; else /etc/lilo/install; fi
 
 install:
-	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(BOOTIMAGE) System.map "$(INSTALL_PATH)"
+	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(obj)/bzImage \
+		System.map "$(INSTALL_PATH)"
