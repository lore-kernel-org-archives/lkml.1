Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYBYVzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYBYVzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYBYVy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:54:56 -0500
Received: from milhouse.binasys.co.uk ([216.12.200.91]:47210 "EHLO
	milhouse.binasys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYBYVyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:54:55 -0500
X-Greylist: delayed 727 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 16:54:55 EST
Date: Mon, 25 Feb 2008 21:42:09 +0000
From: Steve Brokenshire <sbrokenshire@xestia.co.uk>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] Compress kernel modules on installation.
Message-Id: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(I've sent this to the linux-kbuild and linux-kernel lists as this
patch modifies the Makefile.modinst file. I also don't subscribe to the 
linux-kbuild and linux-kernel mailing lists so can I have any replies
CC'ed to me please)

This patch allows kernel modules to be compressed when 'make
modules_install' is run after being copied to
the /lib/module/<version>/<...> directory which is useful if you have
module-init-tools installed with --enable-zlib. This patch adds an
option (MODULE_COMPRESS) to the kernel configuration file (specifically
init/Kconfig) so that the kernel modules will compressed if
MODULE_COMPRESS is set.

When MODULE_COMPRESS is set the output of 'make modules_install' will
go as the following:

INSTALL  drivers/fs/xfs/xfs.ko
COMPRESS drivers/fs/xfs/xfs.ko
INSTALL  drivers/fs/fat/fat.ko
COMPRESS drivers/fs/fat/fat.ko
...

I've tested my patch on kernel versions 2.6.24.2, 2.6.24-git12, 2.6.23.14 and
2.6.19 and they compile, install and compress into the respective
module directories without any errors.

I've also tested this with the uvcvideo (linux-uvc) kernel module (from
the SVN branch and with kernel versions 2.6.24.2, 2.6.24-git12, 2.6.23.14 and
2.6.19) as that uses Kbuild properly when installing the module and
after installing the uvcvideo the module is then compressed.
Unfortunately, I couldn't find any other kernel modules which used the
Kbuild system for installing their kernel modules. :(

I've included include/config/auto.conf in Makefile.modinst so that it
can check if MODULE_COMPRESS is set when installing the kernel modules.

Unfortunately when I ran mkinitrd (CentOS version) to create the initrd
image to go with the kernel, I get errors saying that certain kernel
modules don't exist despite the fact they do actually exist. When I
pass --allow-missing to mkinitrd, it seems to go fine but when booting
up with the system with the new initrd image I get error messages
saying that the modules don't exist.

A workaround is to compile the modules, don't have MODULE_COMPRESS set 
in .config, install the modules, run mkinitrd and copy it to /boot, set 
MODULE_COMPRESS in .config and then install the modules again but
compressed.

That's about it really. The only showstopper I feel is mkinitrd not
working properly with the compressed kernel modules.

Thanks,
Steve

---

Signed-off-by: Steve Brokenshire <sbrokenshire@xestia.co.uk>

diff -u -r -up a/init/Kconfig b/init/Kconfig
--- a/init/Kconfig	2008-02-02 16:34:29.000000000 +0000
+++ b/init/Kconfig	2008-02-03 09:55:52.000000000 +0000
@@ -725,6 +725,30 @@ config MODULE_FORCE_UNLOAD
 	  rmmod).  This is mainly for kernel developers and desperate users.
 	  If unsure, say N.
 
+config MODULE_COMPRESS
+	bool "Compress kernel modules on installation"
+	depends on MODULES
+	help
+	  This option compresses the kernel modules when 'make
+	  modules_install' is run.
+
+	  The modules will be compressed into the gzip (GNU zip) format
+	  and will use less space than an uncompressed kernel module would.
+
+	  When a kernel module is installed from outside of the main kernel
+	  source and uses the Kbuild system for installing modules then that
+	  kernel module will also be compressed when it is installed.
+
+	  When running mkinitrd you will find that an error message
+	  appears saying that it cannot find a certain kernel module.
+	  As a workaround, unset CONFIG_MODULE_COMPRESS, build the modules
+	  and install them, run mkinitrd and create the initrd image, place
+	  the initrd image in the correct place for booting, set
+	  CONFIG_MODULE_COMPRESS and then install the modules again.
+
+	  This options requires the module-init-tools package to be 
+	  configured with --enable-zlib.
+
 config MODVERSIONS
 	bool "Module versioning support"
 	depends on MODULES
diff -u -r -up a/scripts/Makefile.modinst b/scripts/Makefile.modinst
--- a/scripts/Makefile.modinst	2008-02-02 16:34:33.000000000 +0000
+++ b/scripts/Makefile.modinst	2008-02-02 17:21:46.000000000 +0000
@@ -5,6 +5,7 @@
 PHONY := __modinst
 __modinst:
 
+include include/config/auto.conf
 include scripts/Kbuild.include
 
 #
@@ -16,8 +17,15 @@ PHONY += $(modules)
 __modinst: $(modules)
 	@:
 
-quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@)
+quiet_cmd_modules_install = INSTALL  $@
+      cmd_modules_install = mkdir -p $(2); \
+				cp $@ $(2) ; \
+				$(mod_strip_cmd) $(2)/$(notdir $@)
+
+quiet_cmd_modules_compress = COMPRESS $@
+      cmd_modules_compress = gzip --best -c $(2)/`basename $@` \
+				 > $(2)/`basename $@`.gz; \
+				rm $(2)/`basename $@`
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
@@ -27,7 +35,8 @@ modinst_dir = $(if $(KBUILD_EXTMOD),$(ex
 
 $(modules):
 	$(call cmd,modules_install,$(MODLIB)/$(modinst_dir))
-
+	$(if $(CONFIG_MODULE_COMPRESS), \
+		$(call cmd,modules_compress,$(MODLIB)/$(modinst_dir)))
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
