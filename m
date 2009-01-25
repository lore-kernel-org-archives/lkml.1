Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbZAYQv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbZAYQv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 11:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbZAYQvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 11:51:50 -0500
Received: from milhouse.binasys.co.uk ([216.12.200.91]:36251 "EHLO
	milhouse.binasys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZAYQvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 11:51:49 -0500
Date: Sun, 25 Jan 2009 16:51:18 +0000
From: Steve Brokenshire <sbrokenshire@xestia.co.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-Id: <20090125165118.dfdd3978.sbrokenshire@xestia.co.uk>
In-Reply-To: <20090120033047.7412d93e.sbrokenshire@xestia.co.uk>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
	<20080226112840.GA29465@uranus.ravnborg.org>
	<alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr>
	<20081226194833.GA8306@uranus.ravnborg.org>
	<20090120033047.7412d93e.sbrokenshire@xestia.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2009 03:30:47 +0000
Steve Brokenshire <sbrokenshire@xestia.co.uk> wrote:

> On Fri, 26 Dec 2008 20:48:33 +0100
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Fri, Dec 26, 2008 at 08:30:19PM +0100, Jan Engelhardt wrote:
> > > 
> > > On Tuesday 2008-02-26 12:28, Sam Ravnborg wrote:
> > > >> 
> > > >> (I've sent this to the linux-kbuild and linux-kernel lists as this
> > > >> patch modifies the Makefile.modinst file. I also don't subscribe to the 
> > > >> linux-kbuild and linux-kernel mailing lists so can I have any replies
> > > >> CC'ed to me please)
> > > >> 
> > > >> This patch allows kernel modules to be compressed when 'make
> > > >> modules_install' is run after being copied to
> > > >> the /lib/module/<version>/<...> directory which is useful if you have
> > > >> module-init-tools installed with --enable-zlib. This patch adds an
> > > >> option (MODULE_COMPRESS) to the kernel configuration file (specifically
> > > >> init/Kconfig) so that the kernel modules will compressed if
> > > >> MODULE_COMPRESS is set.
> > > 
> > > I recently started compressing my kernel modules and that saved me
> > > at least 70 MB of disk space on mostlyallmodconfig.
> > > (And no, the argument of disks being cheap is not so true with
> > > CF or SSD.)
> > > Distro is lazy and wants to wait for upstream to have it,
> > > so is there any chance of getting this proposal in?
> > 
> > Steve said he wanted to try to make the solution more
> > scalable so I am awaiting a new patch.
> > 
> > 	Sam
> > 
> 
> (Stuff I mentioned earlier has been snipped)

I've done some modifications to the previous patch and that there is
now an option to specify the options for the selected compression
format in init/Kconfig using MODULE_COMPRESS_OPTIONS and also some
minor tidying up.

It didn't go quite as planned from the previous post for altering
Makefile.modinst as gzip doesn't like "" when there is nothing in
MODULE_COMPRESS_OPTIONS or when some options are set with the quotation
marks so when MODULE_COMPRESS_OPTIONS just has "" then nothing will
happen (as there would be no value in MODCOMPOPT) and if there is
something other than "" then strip the quotation marks from the start
and the end then place the result in MODCOMPOPT which is then used by
the selected compression method.

I think I've covered everything...

Steve


Patch follows...

================================
Signed-off-by: Steve Brokenshire <sbrokenshire@xestia.co.uk>

--- a/scripts/Makefile.modinst	2009-01-18 18:45:37.000000000 +0000
+++ b/scripts/Makefile.modinst	2009-01-25 13:35:53.000000000 +0000
@@ -5,6 +5,7 @@
 PHONY := __modinst
 __modinst:
 
+include include/config/auto.conf
 include scripts/Kbuild.include
 
 #
@@ -16,8 +17,21 @@ PHONY += $(modules)
 __modinst: $(modules)
 	@:
 
-quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@)
+ifeq ($(CONFIG_MODULE_COMPRESS_OPTIONS), "")
+else
+ MODCOMPOPT = $(shell echo -n $(CONFIG_MODULE_COMPRESS_OPTIONS))
+endif
+
+quiet_cmd_modules_install = INSTALL  $@
+      cmd_modules_install = mkdir -p $(2); \
+				cp $@ $(2) ; \
+				$(mod_strip_cmd) $(2)/$(notdir $@)
+
+quiet_cmd_modules_compress_gzip = COMPRESS $@
+      cmd_modules_compress_gzip = gzip $(MODCOMPOPT) -c \
+				 $(2)/`basename $@` \
+				 > $(2)/`basename $@`.gz; \
+				 rm $(2)/`basename $@`
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
@@ -26,8 +40,11 @@ ext-mod-dir = $(INSTALL_MOD_DIR)$(subst 
 modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
 
 $(modules):
+
 	$(call cmd,modules_install,$(MODLIB)/$(modinst_dir))
 
+	$(if $(CONFIG_MODULE_COMPRESS_GZIP), \
+		$(call cmd,modules_compress_gzip,$(MODLIB)/$(modinst_dir)))
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
--- a/init/Kconfig	2009-01-18 18:45:37.000000000 +0000
+++ b/init/Kconfig	2009-01-25 15:08:39.000000000 +0000
@@ -887,6 +887,62 @@ config MODULE_FORCE_UNLOAD
 	  rmmod).  This is mainly for kernel developers and desperate users.
 	  If unsure, say N.
 
+config MODULE_COMPRESS
+	bool "Compress kernel modules on installation"
+	depends on MODULES
+	help
+	  This option compresses the kernel modules when 'make
+	  modules_install' is run.
+
+	  The modules will be compressed into the selected compression 
+	  format with gzip being the default compression format.
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
+	  This option requires the module-init-tools package to be 
+	  configured with --enable-zlib (if using gzip which is the
+	  default compression format).
+
+	  If unsure, say N.
+
+config MODULE_COMPRESS_OPTIONS
+	string "Compression format command line options"
+	depends on MODULE_COMPRESS
+	help
+	  This option specifies the command line options to be used for
+	  the selected compression format.
+
+	  Please refer to the selected compression format's documentation
+	  on which options should be used.
+
+	  If unsure, leave this option blank.
+
+choice
+	prompt "Kernel module compression format"
+	depends on MODULE_COMPRESS
+	default MODULE_COMPRESS_GZIP
+
+config MODULE_COMPRESS_GZIP
+	bool "gzip compression"
+	help
+	  Compresses the kernel modules using the gzip (GNU zip) 
+	  compression format.
+
+	  This option requires gzip to be installed.
+
+	  If unsure, leave this option selected.
+	  
+endchoice
+
 config MODVERSIONS
 	bool "Module versioning support"
 	help
--- a/Documentation/kbuild/modules.txt	2009-01-18 18:45:37.000000000 +0000
+++ b/Documentation/kbuild/modules.txt	2009-01-25 15:10:27.000000000 +0000
@@ -96,6 +96,13 @@ when building an external module.
 		Installation default is in /lib/modules/<kernel-version>/extra,
 		but may be prefixed with INSTALL_MOD_PATH - see separate
 		chapter.
+		If MODULES_COMPRESS is set when the modules_install target is 
+		run then the module is compressed after it has been 
+		copied to /lib/modules/<kernel-version>. Compressed modules 
+		using the default gzip compression format will require 
+		module-init-tools installed with --zlib-enabled.
+		Any options set in MODULE_COMPRESS_OPTIONS will be 
+		passed to the selected compression format.
 
 	make -C $KDIR M=`pwd` clean
 		Remove all generated files for the module - the kernel
