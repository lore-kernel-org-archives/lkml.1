Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbZATDjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbZATDjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 22:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZATDjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 22:39:04 -0500
Received: from milhouse.binasys.co.uk ([216.12.200.91]:34932 "EHLO
	milhouse.binasys.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbZATDjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 22:39:01 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 22:39:00 EST
Date: Tue, 20 Jan 2009 03:30:47 +0000
From: Steve Brokenshire <sbrokenshire@xestia.co.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-Id: <20090120033047.7412d93e.sbrokenshire@xestia.co.uk>
In-Reply-To: <20081226194833.GA8306@uranus.ravnborg.org>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
	<20080226112840.GA29465@uranus.ravnborg.org>
	<alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr>
	<20081226194833.GA8306@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Dec 2008 20:48:33 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Fri, Dec 26, 2008 at 08:30:19PM +0100, Jan Engelhardt wrote:
> > 
> > On Tuesday 2008-02-26 12:28, Sam Ravnborg wrote:
> > >> 
> > >> (I've sent this to the linux-kbuild and linux-kernel lists as this
> > >> patch modifies the Makefile.modinst file. I also don't subscribe to the 
> > >> linux-kbuild and linux-kernel mailing lists so can I have any replies
> > >> CC'ed to me please)
> > >> 
> > >> This patch allows kernel modules to be compressed when 'make
> > >> modules_install' is run after being copied to
> > >> the /lib/module/<version>/<...> directory which is useful if you have
> > >> module-init-tools installed with --enable-zlib. This patch adds an
> > >> option (MODULE_COMPRESS) to the kernel configuration file (specifically
> > >> init/Kconfig) so that the kernel modules will compressed if
> > >> MODULE_COMPRESS is set.
> > 
> > I recently started compressing my kernel modules and that saved me
> > at least 70 MB of disk space on mostlyallmodconfig.
> > (And no, the argument of disks being cheap is not so true with
> > CF or SSD.)
> > Distro is lazy and wants to wait for upstream to have it,
> > so is there any chance of getting this proposal in?
> 
> Steve said he wanted to try to make the solution more
> scalable so I am awaiting a new patch.
> 
> 	Sam
> 

Yikes! I do apologise. I have been a little bit busy lately and that my
old PC decided to fail on the 24th December so I've been using that as
an excuse for panic buying, building and installing a 64-bit system but
I do have an updated patch available that is scalable (in that... if
new compression formats are used in the future they can be easily added
by adding text to init/Kconfig and code to Makefile.modinst).

I have noticed the patch from Jan for specifying settings for gzip. I
don't see why something like this can't be added to init/Kconfig...

config MODULE_COMPRESS_OPTIONS
	string "Compression method command line options"
	depends on MODULES
	help
	  This option specifies the command line options to be used for
	  the selected compression method.

	  Please refer to the selected compression method's documentation 
	  on which options should be used.

	  If unsure, leave this option blank.

And perhaps alter for Makefile.modinst (after applying the patch below)...

quiet_cmd_modules_compress_gzip = COMPRESS $@
      cmd_modules_compress_gzip = gzip $(CONFIG_MODULE_COMPRESS_OPTIONS) \
				 -c $(2)/`basename $@` \ 
				 > $(2)/`basename $@`.gz; \
				rm $(2)/`basename $@`

I'll supply the patch for what's been done so far (that and it's gone
3am here...) so the above makes a bit more sense. I should point out
that in the patch there should be an additional blank line after
endchoice for init/Kconfig but adding that blank line with the plus
sign seems to cause the patching process to fail so I had to take it
out and that this patch works with 2.6.27.4 (which is the kernel I am
currently using) with a slight fuzz and I haven't chance to test it
with the latest kernel.

I'll have a go at incorporating what I've said regarding
MODULE_COMPRESS_OPTIONS into another patch using the latest kernel (and
add the standard 'If unsure' message to MODULE_COMPRESS as well).

Steve

Patch Follows...

================================

Signed-off-by: Steve Brokenshire <sbrokenshire@xestia.co.uk>

--- a/scripts/Makefile.modinst	2008-02-11 05:51:11.000000000 +0000
+++ b/scripts/Makefile.modinst	2008-05-29 19:30:51.000000000 +0100
@@ -5,6 +5,7 @@
 PHONY := __modinst
 __modinst:
 
+include include/config/auto.conf
 include scripts/Kbuild.include
 
 #
@@ -16,8 +17,15 @@
 __modinst: $(modules)
 	@:
 
-quiet_cmd_modules_install = INSTALL $@
-      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@)
+quiet_cmd_modules_install = INSTALL  $@
+      cmd_modules_install = mkdir -p $(2); \
+				cp $@ $(2) ; \
+				$(mod_strip_cmd) $(2)/$(notdir $@)
+
+quiet_cmd_modules_compress_gzip = COMPRESS $@
+      cmd_modules_compress_gzip = gzip --best -c $(2)/`basename $@` \
+				 > $(2)/`basename $@`.gz; \
+				rm $(2)/`basename $@`
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
@@ -26,8 +34,11 @@
 modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
 
 $(modules):
+
 	$(call cmd,modules_install,$(MODLIB)/$(modinst_dir))
 
+	$(if $(CONFIG_MODULE_COMPRESS_GZIP), \
+		$(call cmd,modules_compress_gzip,$(MODLIB)/$(modinst_dir)))
 
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
--- a/init/Kconfig	2008-02-11 05:51:11.000000000 +0000
+++ b/init/Kconfig	2008-05-29 19:05:34.000000000 +0100
@@ -716,6 +716,45 @@
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
+	  format with Gzip being the default compression format.
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
+	  configured with --enable-zlib (if using gzip which is the
+	  default compression method).
+
+choice
+	depends on MODULE_COMPRESS
+	prompt "Kernel module compression method"
+	default MODULE_COMPRESS_GZIP
+
+config MODULE_COMPRESS_GZIP
+	bool "Gzip compression"
+	help
+	  Compresses the kernel modules using the Gzip (GNU zip) 
+	  compression format.
+
+	  This option requires gzip to be installed.
+	  
+endchoice
 config MODVERSIONS
 	bool "Module versioning support"
 	depends on MODULES
--- a/Documentation/kbuild/modules.txt	2008-02-11 05:51:11.000000000 +0000
+++ b/Documentation/kbuild/modules.txt	2008-05-29 19:35:30.000000000 +0100
@@ -96,6 +96,11 @@
 		Installation default is in /lib/modules/<kernel-version>/extra,
 		but may be prefixed with INSTALL_MOD_PATH - see separate
 		chapter.
+		If MODULES_COMPRESS is set when the modules_install target is 
+		run then the module is compressed after it has been 
+		copied to /lib/modules/<kernel-version>. Compressed modules 
+		using the default Gzip compression format will require 
+		module-init-tools installed with --zlib-enabled.
 
 	make -C $KDIR M=`pwd` clean
 		Remove all generated files for the module - the kernel
