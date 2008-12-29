Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbYL2Nyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbYL2Nyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYL2Nv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:51:59 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:43006 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYL2Nvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:52 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 12/13] kbuild: make *config usage docs
Date: Mon, 29 Dec 2008 14:53:22 +0100
Message-Id: <1230558803-7168-12-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Create a kconfig user assistance guide, with a few tips and hints
about using menuconfig, xconfig, and gconfig.

Mostly contains user interface, environment variables, and search topics,
along with mini.config/custom.config usage.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/00-INDEX    |    2 +
 Documentation/kbuild/kconfig.txt |  188 ++++++++++++++++++++++++++++++++++++++
 README                           |   32 ++++---
 3 files changed, 210 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/kbuild/kconfig.txt

diff --git a/Documentation/kbuild/00-INDEX b/Documentation/kbuild/00-INDEX
index 1146442..54a118a 100644
--- a/Documentation/kbuild/00-INDEX
+++ b/Documentation/kbuild/00-INDEX
@@ -4,5 +4,7 @@ kconfig-language.txt
 	- specification of Config Language, the language in Kconfig files
 makefiles.txt
 	- developer information for linux kernel makefiles
+kconfig.txt
+	- usage help for make *config
 modules.txt
 	- how to build modules and to install them
diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
new file mode 100644
index 0000000..26a7c0a
--- /dev/null
+++ b/Documentation/kbuild/kconfig.txt
@@ -0,0 +1,188 @@
+This file contains some assistance for using "make *config".
+
+Use "make help" to list all of the possible configuration targets.
+
+The xconfig ('qconf') and menuconfig ('mconf') programs also
+have embedded help text.  Be sure to check it for navigation,
+search, and other general help text.
+
+======================================================================
+General
+--------------------------------------------------
+
+New kernel releases often introduce new config symbols.  Often more
+important, new kernel releases may rename config symbols.  When
+this happens, using a previously working .config file and running
+"make oldconfig" won't necessarily produce a working new kernel
+for you, so you may find that you need to see what NEW kernel
+symbols have been introduced.
+
+To see a list of new config symbols when using "make oldconfig", use
+
+	cp user/some/old.config .config
+	yes "" | make oldconfig >conf.new
+
+and the config program will list as (NEW) any new symbols that have
+unknown values.  Of course, the .config file is also updated with
+new (default) values, so you can use:
+
+	grep "(NEW)" conf.new
+
+to see the new config symbols or you can 'diff' the previous and
+new .config files to see the differences:
+
+	diff .config.old .config | less
+
+(Yes, we need something better here.)
+
+
+======================================================================
+menuconfig
+--------------------------------------------------
+
+SEARCHING for CONFIG symbols
+
+Searching in menuconfig:
+
+	The Search function searches for kernel configuration symbol
+	names, so you have to know something close to what you are
+	looking for.
+
+	Example:
+		/hotplug
+		This lists all config symbols that contain "hotplug",
+		e.g., HOTPLUG, HOTPLUG_CPU, MEMORY_HOTPLUG.
+
+	For search help, enter / followed TAB-TAB-TAB (to highlight
+	<Help>) and Enter.  This will tell you that you can also use
+	regular expressions (regexes) in the search string, so if you
+	are not interested in MEMORY_HOTPLUG, you could try
+
+		/^hotplug
+
+
+______________________________________________________________________
+Color Themes for 'menuconfig'
+
+It is possible to select different color themes using the variable
+MENUCONFIG_COLOR.  To select a theme use:
+
+	make MENUCONFIG_COLOR=<theme> menuconfig
+
+Available themes are:
+  mono       => selects colors suitable for monochrome displays
+  blackbg    => selects a color scheme with black background
+  classic    => theme with blue background. The classic look
+  bluetitle  => a LCD friendly version of classic. (default)
+
+______________________________________________________________________
+Environment variables in 'menuconfig'
+
+KCONFIG_ALLCONFIG
+--------------------------------------------------
+(partially based on lkml email from/by Rob Landley, re: miniconfig)
+--------------------------------------------------
+The allyesconfig/allmodconfig/allnoconfig/randconfig variants can
+also use the environment variable KCONFIG_ALLCONFIG as a flag or a
+filename that contains config symbols that the user requires to be
+set to a specific value.  If KCONFIG_ALLCONFIG is used without a
+filename, "make *config" checks for a file named
+"all{yes/mod/no/random}.config" (corresponding to the *config command
+that was used) for symbol values that are to be forced.  If this file
+is not found, it checks for a file named "all.config" to contain forced
+values.
+
+This enables you to create "miniature" config (miniconfig) or custom
+config files containing just the config symbols that you are interested
+in.  Then the kernel config system generates the full .config file,
+including dependencies of your miniconfig file, based on the miniconfig
+file.
+
+This 'KCONFIG_ALLCONFIG' file is a config file which contains
+(usually a subset of all) preset config symbols.  These variable
+settings are still subject to normal dependency checks.
+
+Examples:
+	KCONFIG_ALLCONFIG=custom-notebook.config make allnoconfig
+or
+	KCONFIG_ALLCONFIG=mini.config make allnoconfig
+or
+	make KCONFIG_ALLCONFIG=mini.config allnoconfig
+
+These examples will disable most options (allnoconfig) but enable or
+disable the options that are explicitly listed in the specified
+mini-config files.
+
+KCONFIG_NOSILENTUPDATE
+--------------------------------------------------
+If this variable has a non-blank value, it prevents silent kernel
+config udpates (requires explicit updates).
+
+KCONFIG_CONFIG
+--------------------------------------------------
+This environment variable can be used to specify a default kernel config
+file name to override the default name of ".config".
+
+KCONFIG_OVERWRITECONFIG
+--------------------------------------------------
+If you set KCONFIG_OVERWRITECONFIG in the environment, Kconfig will not
+break symlinks when .config is a symlink to somewhere else.
+
+KCONFIG_NOTIMESTAMP
+--------------------------------------------------
+If this environment variable exists and is non-null, the timestamp line
+in generated .config files is omitted.
+
+KCONFIG_AUTOCONFIG
+--------------------------------------------------
+This environment variable can be set to specify the path & name of the
+"auto.conf" file.  Its default value is "include/config/auto.conf".
+
+KCONFIG_AUTOHEADER
+--------------------------------------------------
+This environment variable can be set to specify the path & name of the
+"autoconf.h" (header) file.  Its default value is "include/linux/autoconf.h".
+
+______________________________________________________________________
+menuconfig User Interface Options
+----------------------------------------------------------------------
+MENUCONFIG_MODE
+--------------------------------------------------
+This mode shows all sub-menus in one large tree.
+
+Example:
+	MENUCONFIG_MODE=single_menu make menuconfig
+
+======================================================================
+xconfig
+--------------------------------------------------
+
+Searching in xconfig:
+
+	The Search function searches for kernel configuration symbol
+	names, so you have to know something close to what you are
+	looking for.
+
+	Example:
+		Ctrl-F hotplug
+	or
+		Menu: File, Search, hotplug
+
+	lists all config symbol entries that contain "hotplug" in
+	the symbol name.  In this Search dialog, you may change the
+	config setting for any of the entries that are not grayed out.
+	You can also enter a different search string without having
+	to return to the main menu.
+
+
+======================================================================
+gconfig
+--------------------------------------------------
+
+Searching in gconfig:
+
+	None (gconfig isn't maintained as well as xconfig or menuconfig);
+	however, gconfig does have a few more viewing choices than
+	xconfig does.
+
+###
diff --git a/README b/README
index 159912c..90a0765 100644
--- a/README
+++ b/README
@@ -52,11 +52,11 @@ DOCUMENTATION:
 
  - The Documentation/DocBook/ subdirectory contains several guides for
    kernel developers and users.  These guides can be rendered in a
-   number of formats:  PostScript (.ps), PDF, and HTML, among others.
-   After installation, "make psdocs", "make pdfdocs", or "make htmldocs"
-   will render the documentation in the requested format.
+   number of formats:  PostScript (.ps), PDF, HTML, & man-pages, among others.
+   After installation, "make psdocs", "make pdfdocs", "make htmldocs",
+   or "make mandocs" will render the documentation in the requested format.
 
-INSTALLING the kernel:
+INSTALLING the kernel source:
 
  - If you install the full sources, put the kernel tarball in a
    directory where you have permissions (eg. your home directory) and
@@ -187,14 +187,9 @@ CONFIGURING the kernel:
 	"make randconfig"  Create a ./.config file by setting symbol
 			   values to random values.
 
-   The allyesconfig/allmodconfig/allnoconfig/randconfig variants can
-   also use the environment variable KCONFIG_ALLCONFIG to specify a
-   filename that contains config options that the user requires to be
-   set to a specific value.  If KCONFIG_ALLCONFIG=filename is not used,
-   "make *config" checks for a file named "all{yes/mod/no/random}.config"
-   for symbol values that are to be forced.  If this file is not found,
-   it checks for a file named "all.config" to contain forced values.
-   
+   You can find more information on using the Linux kernel config tools
+   in Documentation/kbuild/make-configs.txt.
+
 	NOTES on "make config":
 	- having unnecessary drivers will make the kernel bigger, and can
 	  under some circumstances lead to problems: probing for a
@@ -231,6 +226,19 @@ COMPILING the kernel:
  - If you configured any of the parts of the kernel as `modules', you
    will also have to do "make modules_install".
 
+ - Verbose kernel compile/build output:
+
+   Normally the kernel build system runs in a fairly quiet mode (but not
+   totally silent).  However, sometimes you or other kernel developers need
+   to see compile, link, or other commands exactly as they are executed.
+   For this, use "verbose" build mode.  This is done by inserting
+   "V=1" in the "make" command.  E.g.:
+
+	make V=1 all
+
+   To have the build system also tell the reason for the rebuild of each
+   target, use "V=2".  The default is "V=0".
+
  - Keep a backup kernel handy in case something goes wrong.  This is 
    especially true for the development releases, since each new release
    contains new code which has not been debugged.  Make sure you keep a
-- 
1.6.0.2.GIT

