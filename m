Return-Path: <linux-kernel-owner+w=401wt.eu-S941782AbXHJULd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941782AbXHJULd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937544AbXHJULW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:11:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48978 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbXHJULT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:11:19 -0400
Date: Fri, 10 Aug 2007 22:12:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andi Kleen <andi@firstfloor.org>,
       =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070810201235.GA4133@uranus.ravnborg.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070810074047.GC31307@uranus.ravnborg.org> <46BC6DA9.1050903@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BC6DA9.1050903@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What primary requirements does in-tree Linux kernel documentation have
> to fulfill in general?

Skipping the obvious ones such as correct, up-to-date etc.
o Readable as-is
o Grepable
o buildable as structured documents or almost like a single book
o Easy to replicate structure
o Maintainable in any decent text-editor (emacs, vim, whatever)

> I've got a hunch that the most suitable format for Linux kernel
> documentation, after careful consideration of what we want from it and
> how we author and maintain it, will turn out to be...
> 
> ...plaintext.
Asciidoc is quite close to plaintext and it looks to me that the
formatting possibilities are quite good.

I spend an hour experimenting a little with
Documentation/kbuild/makefiles.txt.

Diff below shows quite a lot of changes but for the most
this is removal of the indent tab.
Most likely I could have tweaked asciidoc to accept this
but wanted to use default config.

The resulting html page can be seen here:
http://www.ravnborg.org/kbuild/makefiles.html

Produced using:
asciidoc -a toc -a numbered makefiles.txt

I would say that the asciidoc formatted plaintext text
are readable despite the simple markup.
And someone coming later will have no problems to follow
the original markup.

Btw. is is not a full conversion, I stopped after a few chapters.
asciidoc should be able to produce the index automatically
but I had no luck but then I did not try hard either.

	Sam


 makefiles.txt |  397 ++++++++++++++++++++++++++--------------------------------
 1 file changed, 180 insertions(+), 217 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index e08ef87..04f4d43 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -1,59 +1,18 @@
 Linux Kernel Makefiles
+======================
 
 This document describes the Linux kernel Makefiles.
 
-=== Table of Contents
-
-	=== 1 Overview
-	=== 2 Who does what
-	=== 3 The kbuild files
-	   --- 3.1 Goal definitions
-	   --- 3.2 Built-in object goals - obj-y
-	   --- 3.3 Loadable module goals - obj-m
-	   --- 3.4 Objects which export symbols
-	   --- 3.5 Library file goals - lib-y
-	   --- 3.6 Descending down in directories
-	   --- 3.7 Compilation flags
-	   --- 3.8 Command line dependency
-	   --- 3.9 Dependency tracking
-	   --- 3.10 Special Rules
-	   --- 3.11 $(CC) support functions
-
-	=== 4 Host Program support
-	   --- 4.1 Simple Host Program
-	   --- 4.2 Composite Host Programs
-	   --- 4.3 Defining shared libraries
-	   --- 4.4 Using C++ for host programs
-	   --- 4.5 Controlling compiler options for host programs
-	   --- 4.6 When host programs are actually built
-	   --- 4.7 Using hostprogs-$(CONFIG_FOO)
-
-	=== 5 Kbuild clean infrastructure
-
-	=== 6 Architecture Makefiles
-	   --- 6.1 Set variables to tweak the build to the architecture
-	   --- 6.2 Add prerequisites to archprepare:
-	   --- 6.3 List directories to visit when descending
-	   --- 6.4 Architecture-specific boot images
-	   --- 6.5 Building non-kbuild targets
-	   --- 6.6 Commands useful for building a boot image
-	   --- 6.7 Custom kbuild commands
-	   --- 6.8 Preprocessing linker scripts
-
-	=== 7 Kbuild Variables
-	=== 8 Makefile language
-	=== 9 Credits
-	=== 10 TODO
-
-=== 1 Overview
+== Overview
 
 The Makefiles have five parts:
-
-	Makefile		the top Makefile.
-	.config			the kernel configuration file.
-	arch/$(ARCH)/Makefile	the arch Makefile.
-	scripts/Makefile.*	common rules etc. for all kbuild Makefiles.
-	kbuild Makefiles	there are about 500 of these.
+`-----------------------`-------------------------------------------
+Makefile		the top Makefile.
+.config			the kernel configuration file.
+arch/$(ARCH)/Makefile	the arch Makefile.
+scripts/Makefile.*	common rules etc. for all kbuild Makefiles.
+kbuild Makefiles	there are about 500 of these.
+--------------------------------------------------------------------
 
 The top Makefile reads the .config file, which comes from the kernel
 configuration process.
@@ -76,32 +35,36 @@ scripts/Makefile.* contains all the definitions/rules etc. that
 are used to build the kernel based on the kbuild makefiles.
 
 
-=== 2 Who does what
+== Who does what
 
 People have four different relationships with the kernel Makefiles.
 
-*Users* are people who build kernels.  These people type commands such as
+*Users*:-
+are people who build kernels.  These people type commands such as
 "make menuconfig" or "make".  They usually do not read or edit
 any kernel Makefiles (or any other source files).
 
-*Normal developers* are people who work on features such as device
+*Normal developers*:-
+are people who work on features such as device
 drivers, file systems, and network protocols.  These people need to
 maintain the kbuild Makefiles for the subsystem they are
 working on.  In order to do this effectively, they need some overall
 knowledge about the kernel Makefiles, plus detailed knowledge about the
 public interface for kbuild.
 
-*Arch developers* are people who work on an entire architecture, such
+*Arch developers*:-
+are people who work on an entire architecture, such
 as sparc or ia64.  Arch developers need to know about the arch Makefile
 as well as kbuild Makefiles.
 
-*Kbuild developers* are people who work on the kernel build system itself.
+*Kbuild developers*:-
+are people who work on the kernel build system itself.
 These people need to know about all aspects of the kernel Makefiles.
 
 This document is aimed towards normal developers and arch developers.
 
 
-=== 3 The kbuild files
+== The kbuild files
 
 Most Makefiles within the kernel are kbuild Makefiles that use the
 kbuild infrastructure. This chapter introduces the syntax used in the
@@ -113,141 +76,141 @@ file will be used.
 Section 3.1 "Goal definitions" is a quick intro, further chapters provide
 more details, with real examples.
 
---- 3.1 Goal definitions
-
-	Goal definitions are the main part (heart) of the kbuild Makefile.
-	These lines define the files to be built, any special compilation
-	options, and any subdirectories to be entered recursively.
-
-	The most simple kbuild makefile contains one line:
-
-	Example:
-		obj-y += foo.o
-
-	This tells kbuild that there is one object in that directory, named
-	foo.o. foo.o will be built from foo.c or foo.S.
-
-	If foo.o shall be built as a module, the variable obj-m is used.
-	Therefore the following pattern is often used:
-
-	Example:
-		obj-$(CONFIG_FOO) += foo.o
-
-	$(CONFIG_FOO) evaluates to either y (for built-in) or m (for module).
-	If CONFIG_FOO is neither y nor m, then the file will not be compiled
-	nor linked.
-
---- 3.2 Built-in object goals - obj-y
-
-	The kbuild Makefile specifies object files for vmlinux
-	in the $(obj-y) lists.  These lists depend on the kernel
-	configuration.
-
-	Kbuild compiles all the $(obj-y) files.  It then calls
-	"$(LD) -r" to merge these files into one built-in.o file.
-	built-in.o is later linked into vmlinux by the parent Makefile.
-
-	The order of files in $(obj-y) is significant.  Duplicates in
-	the lists are allowed: the first instance will be linked into
-	built-in.o and succeeding instances will be ignored.
-
-	Link order is significant, because certain functions
-	(module_init() / __initcall) will be called during boot in the
-	order they appear. So keep in mind that changing the link
-	order may e.g. change the order in which your SCSI
-	controllers are detected, and thus your disks are renumbered.
-
-	Example:
-		#drivers/isdn/i4l/Makefile
-		# Makefile for the kernel ISDN subsystem and device drivers.
-		# Each configuration option enables a list of files.
-		obj-$(CONFIG_ISDN)             += isdn.o
-		obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
-
---- 3.3 Loadable module goals - obj-m
-
-	$(obj-m) specify object files which are built as loadable
-	kernel modules.
-
-	A module may be built from one source file or several source
-	files. In the case of one source file, the kbuild makefile
-	simply adds the file to $(obj-m).
-
-	Example:
-		#drivers/isdn/i4l/Makefile
-		obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
-
-	Note: In this example $(CONFIG_ISDN_PPP_BSDCOMP) evaluates to 'm'
-
-	If a kernel module is built from several source files, you specify
-	that you want to build a module in the same way as above.
-
-	Kbuild needs to know which the parts that you want to build your
-	module from, so you have to tell it by setting an
-	$(<module_name>-objs) variable.
-
-	Example:
-		#drivers/isdn/i4l/Makefile
-		obj-$(CONFIG_ISDN) += isdn.o
-		isdn-objs := isdn_net_lib.o isdn_v110.o isdn_common.o
-
-	In this example, the module name will be isdn.o. Kbuild will
-	compile the objects listed in $(isdn-objs) and then run
-	"$(LD) -r" on the list of these files to generate isdn.o.
-
-	Kbuild recognises objects used for composite objects by the suffix
-	-objs, and the suffix -y. This allows the Makefiles to use
-	the value of a CONFIG_ symbol to determine if an object is part
-	of a composite object.
-
-	Example:
-		#fs/ext2/Makefile
-	        obj-$(CONFIG_EXT2_FS)        += ext2.o
-		ext2-y                       := balloc.o bitmap.o
-	        ext2-$(CONFIG_EXT2_FS_XATTR) += xattr.o
-
-	In this example, xattr.o is only part of the composite object
-	ext2.o if $(CONFIG_EXT2_FS_XATTR) evaluates to 'y'.
-
-	Note: Of course, when you are building objects into the kernel,
-	the syntax above will also work. So, if you have CONFIG_EXT2_FS=y,
-	kbuild will build an ext2.o file for you out of the individual
-	parts and then link this into built-in.o, as you would expect.
-
---- 3.4 Objects which export symbols
-
-	No special notation is required in the makefiles for
-	modules exporting symbols.
-
---- 3.5 Library file goals - lib-y
-
-	Objects listed with obj-* are used for modules, or
-	combined in a built-in.o for that specific directory.
-	There is also the possibility to list objects that will
-	be included in a library, lib.a.
-	All objects listed with lib-y are combined in a single
-	library for that directory.
-	Objects that are listed in obj-y and additionally listed in
-	lib-y will not be included in the library, since they will
-	be accessible anyway.
-	For consistency, objects listed in lib-m will be included in lib.a.
-
-	Note that the same kbuild makefile may list files to be built-in
-	and to be part of a library. Therefore the same directory
-	may contain both a built-in.o and a lib.a file.
-
-	Example:
-		#arch/i386/lib/Makefile
-		lib-y    := checksum.o delay.o
-
-	This will create a library lib.a based on checksum.o and delay.o.
-	For kbuild to actually recognize that there is a lib.a being built,
-	the directory shall be listed in libs-y.
-	See also "6.3 List directories to visit when descending".
-
-	Use of lib-y is normally restricted to lib/ and arch/*/lib.
-
---- 3.6 Descending down in directories
+=== Goal definitions
+
+Goal definitions are the main part (heart) of the kbuild Makefile.
+These lines define the files to be built, any special compilation
+options, and any subdirectories to be entered recursively.
+
+The most simple kbuild makefile contains one line:
+
+----
+	obj-y += foo.o
+----
+This tells kbuild that there is one object in that directory, named
+foo.o. foo.o will be built from foo.c or foo.S.
+
+If foo.o shall be built as a module, the variable `obj-m` is used.
+Therefore the following pattern is often used:
+
+----
+	obj-$(CONFIG_FOO) += foo.o
+----
+`$(CONFIG_FOO)` evaluates to either y (for built-in) or m (for module).
+If `CONFIG_FOO` is neither y nor m, then the file will not be compiled
+nor linked.
+
+=== Built-in object goals - obj-y
+
+The kbuild Makefile specifies object files for vmlinux
+in the `obj-y` lists.  These lists depend on the kernel
+configuration.
+
+Kbuild compiles all the +obj-y+ files.  It then calls
+`$(LD) -r` to merge these files into one built-in.o file.
+built-in.o is later linked into vmlinux by the parent Makefile.
+
+The order of files in `obj-y` is significant.  Duplicates in
+the lists are allowed: the first instance will be linked into
+built-in.o and succeeding instances will be ignored.
+
+Link order is significant, because certain functions
+(module_init() / __initcall) will be called during boot in the
+order they appear. So keep in mind that changing the link
+order may e.g. change the order in which your SCSI
+controllers are detected, and thus your disks are renumbered.
+
+----
+	#drivers/isdn/i4l/Makefile
+	# Makefile for the kernel ISDN subsystem and device drivers.
+	# Each configuration option enables a list of files.
+	obj-$(CONFIG_ISDN)             += isdn.o
+	obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
+----
+=== Loadable module goals - obj-m
+
+`obj-m` specify object files which are built as loadable
+kernel modules.
+
+A module may be built from one source file or several source
+files. In the case of one source file, the kbuild makefile
+simply adds the file to `obj-m`.
+
+----
+	#drivers/isdn/i4l/Makefile
+	obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
+----
+Note: In this example `$(CONFIG_ISDN_PPP_BSDCOMP)` evaluates to 'm'
+
+If a kernel module is built from several source files, you specify
+that you want to build a module in the same way as above.
+
+Kbuild needs to know which the parts that you want to build your
+module from, so you have to tell it by setting an
+`<module_name>-objs` variable.
+
+----
+	#drivers/isdn/i4l/Makefile
+	obj-$(CONFIG_ISDN) += isdn.o
+	isdn-objs := isdn_net_lib.o isdn_v110.o isdn_common.o
+----
+In this example, the module name will be isdn.o. Kbuild will
+compile the objects listed in +isdn-objs+ and then run
+`$(LD) -r` on the list of these files to generate isdn.o.
+
+Kbuild recognises objects used for composite objects by the suffix
+`-objs`, and the suffix `-y`. This allows the Makefiles to use
+the value of a `CONFIG_` symbol to determine if an object is part
+of a composite object.
+
+----
+	#fs/ext2/Makefile
+        obj-$(CONFIG_EXT2_FS)        += ext2.o
+	ext2-y                       := balloc.o bitmap.o
+        ext2-$(CONFIG_EXT2_FS_XATTR) += xattr.o
+----
+In this example, xattr.o is only part of the composite object
+ext2.o if `$(CONFIG_EXT2_FS_XATTR)` evaluates to 'y'.
+
+Note: Of course, when you are building objects into the kernel,
+the syntax above will also work. So, if you have `CONFIG_EXT2_FS=y`,
+kbuild will build an ext2.o file for you out of the individual
+parts and then link this into built-in.o, as you would expect.
+
+=== Objects which export symbols
+
+No special notation is required in the makefiles for
+modules exporting symbols.
+
+=== Library file goals - lib-y
+
+Objects listed with `obj-*` are used for modules, or
+combined in a built-in.o for that specific directory.
+There is also the possibility to list objects that will
+be included in a library, lib.a.
+All objects listed with `lib-y` are combined in a single
+library for that directory.
+Objects that are listed in obj-y and additionally listed in
+`lib-y` will not be included in the library, since they will
+be accessible anyway.
+For consistency, objects listed in `lib-m` will be included in lib.a.
+
+Note that the same kbuild makefile may list files to be built-in
+and to be part of a library. Therefore the same directory
+may contain both a built-in.o and a lib.a file.
+
+-----
+	#arch/i386/lib/Makefile
+	lib-y    := checksum.o delay.o
+----
+This will create a library lib.a based on checksum.o and delay.o.
+For kbuild to actually recognize that there is a lib.a being built,
+the directory shall be listed in `libs-y`.
+See also "6.3 List directories to visit when descending".
+
+Use of `lib-y` is normally restricted to lib/ and arch/*/lib.
+
+=== Descending down in directories
 
 	A Makefile is only responsible for building objects in its own
 	directory. Files in subdirectories should be taken care of by
@@ -274,7 +237,7 @@ more details, with real examples.
 	names. This allows kbuild to totally skip the directory if the
 	corresponding CONFIG_ option is neither 'y' nor 'm'.
 
---- 3.7 Compilation flags
+=== Compilation flags
 
     EXTRA_CFLAGS, EXTRA_AFLAGS, EXTRA_LDFLAGS, EXTRA_ARFLAGS
 
@@ -338,7 +301,7 @@ more details, with real examples.
 		AFLAGS_head-armv.o := -DTEXTADDR=$(TEXTADDR) -traditional
 		AFLAGS_head-armo.o := -DTEXTADDR=$(TEXTADDR) -traditional
 
---- 3.9 Dependency tracking
+=== Dependency tracking
 
 	Kbuild tracks dependencies on the following:
 	1) All prerequisite files (both *.c and *.h)
@@ -348,7 +311,7 @@ more details, with real examples.
 	Thus, if you change an option to $(CC) all affected files will
 	be re-compiled.
 
---- 3.10 Special Rules
+=== Special Rules
 
 	Special rules are used when the kbuild infrastructure does
 	not provide the required support. A typical example is
@@ -385,7 +348,7 @@ more details, with real examples.
 	to prerequisites are referenced with $(src) (because they are not
 	generated files).
 
---- 3.11 $(CC) support functions
+=== $(CC) support functions
 
 	The kernel may be built with several different versions of
 	$(CC), each supporting a unique set of features and options.
@@ -516,7 +479,7 @@ more details, with real examples.
 	In this example for a specific GCC version the build will error out explaining
 	to the user why it stops.
 
-=== 4 Host Program support
+== Host Program support
 
 Kbuild supports building executables on the host for use during the
 compilation stage.
@@ -530,7 +493,7 @@ This can be done in two ways. Either add the dependency in a rule,
 or utilise the variable $(always).
 Both possibilities are described in the following.
 
---- 4.1 Simple Host Program
+=== Simple Host Program
 
 	In some cases there is a need to compile and run a program on the
 	computer where the build is running.
@@ -544,7 +507,7 @@ Both possibilities are described in the following.
 	c-source file named bin2hex.c located in the same directory as
 	the Makefile.
 
---- 4.2 Composite Host Programs
+=== Composite Host Programs
 
 	Host programs can be made up based on composite objects.
 	The syntax used to define composite objects for host programs is
@@ -563,7 +526,7 @@ Both possibilities are described in the following.
 	Finally, the two .o files are linked to the executable, lxdialog.
 	Note: The syntax <executable>-y is not permitted for host-programs.
 
---- 4.3 Defining shared libraries
+=== Defining shared libraries
 
 	Objects with extension .so are considered shared libraries, and
 	will be compiled as position independent objects.
@@ -585,7 +548,7 @@ Both possibilities are described in the following.
 	linked as a shared library libkconfig.so. C++ is not supported for
 	shared libraries.
 
---- 4.4 Using C++ for host programs
+=== Using C++ for host programs
 
 	kbuild offers support for host programs written in C++. This was
 	introduced solely to support kconfig, and is not recommended
@@ -608,7 +571,7 @@ Both possibilities are described in the following.
 		qconf-cxxobjs := qconf.o
 		qconf-objs    := check.o
 
---- 4.5 Controlling compiler options for host programs
+=== Controlling compiler options for host programs
 
 	When compiling host programs, it is possible to set specific flags.
 	The programs will always be compiled utilising $(HOSTCC) passed
@@ -636,7 +599,7 @@ Both possibilities are described in the following.
 	When linking qconf, it will be passed the extra option
 	"-L$(QTDIR)/lib".
 
---- 4.6 When host programs are actually built
+=== When host programs are actually built
 
 	Kbuild will only build host-programs when they are referenced
 	as a prerequisite.
@@ -667,7 +630,7 @@ Both possibilities are described in the following.
 	This will tell kbuild to build lxdialog even if not referenced in
 	any rule.
 
---- 4.7 Using hostprogs-$(CONFIG_FOO)
+=== Using hostprogs-$(CONFIG_FOO)
 
 	A typical pattern in a Kbuild file looks like this:
 
@@ -681,7 +644,7 @@ Both possibilities are described in the following.
 	like hostprogs-y. But only hostprogs-y is recommended to be used
 	when no CONFIG symbols are involved.
 
-=== 5 Kbuild clean infrastructure
+== Kbuild clean infrastructure
 
 "make clean" deletes most generated files in the obj tree where the kernel
 is compiled. This includes generated files such as host programs.
@@ -741,7 +704,7 @@ is not operational at that point.
 Note 2: All directories listed in core-y, libs-y, drivers-y and net-y will
 be visited during "make clean".
 
-=== 6 Architecture Makefiles
+== Architecture Makefiles
 
 The top level Makefile sets up the environment and does the preparation,
 before starting to descend down in the individual directories.
@@ -770,7 +733,7 @@ When kbuild executes, the following steps are followed (roughly):
    - Preparing initrd images and the like
 
 
---- 6.1 Set variables to tweak the build to the architecture
+=== Set variables to tweak the build to the architecture
 
     LDFLAGS		Generic $(LD) options
 
@@ -866,7 +829,7 @@ When kbuild executes, the following steps are followed (roughly):
 	for loadable kernel modules.
 
 
---- 6.2 Add prerequisites to archprepare:
+=== Add prerequisites to archprepare:
 
 	The archprepare: rule is used to list prerequisites that need to be
 	built before starting to descend down in the subdirectories.
@@ -882,7 +845,7 @@ When kbuild executes, the following steps are followed (roughly):
 	generating offset header files.
 
 
---- 6.3 List directories to visit when descending
+=== List directories to visit when descending
 
 	An arch Makefile cooperates with the top Makefile to define variables
 	which specify how to build the vmlinux file.  Note that there is no
@@ -911,7 +874,7 @@ When kbuild executes, the following steps are followed (roughly):
 		drivers-$(CONFIG_OPROFILE)  += arch/sparc64/oprofile/
 
 
---- 6.4 Architecture-specific boot images
+=== Architecture-specific boot images
 
 	An arch Makefile specifies goals that take the vmlinux file, compress
 	it, wrap it in bootstrapping code, and copy the resulting files
@@ -962,7 +925,7 @@ When kbuild executes, the following steps are followed (roughly):
 
 	When "make" is executed without arguments, bzImage will be built.
 
---- 6.5 Building non-kbuild targets
+=== Building non-kbuild targets
 
     extra-y
 
@@ -982,7 +945,7 @@ When kbuild executes, the following steps are followed (roughly):
 	shall be built, but shall not be linked as part of built-in.o.
 
 
---- 6.6 Commands useful for building a boot image
+=== Commands useful for building a boot image
 
 	Kbuild provides a few macros that are useful when building a
 	boot image.
@@ -1048,7 +1011,7 @@ When kbuild executes, the following steps are followed (roughly):
 	      obvious reason.
 
 
---- 6.7 Custom kbuild commands
+=== Custom kbuild commands
 
 	When kbuild is executing with KBUILD_VERBOSE=0, then only a shorthand
 	of a command is normally displayed.
@@ -1075,7 +1038,7 @@ When kbuild executes, the following steps are followed (roughly):
 	will be displayed with "make KBUILD_VERBOSE=0".
 
 
---- 6.8 Preprocessing linker scripts
+=== Preprocessing linker scripts
 
 	When the vmlinux image is built, the linker script
 	arch/$(ARCH)/kernel/vmlinux.lds is used.
@@ -1106,7 +1069,7 @@ When kbuild executes, the following steps are followed (roughly):
 	architecture-specific files.
 
 
-=== 7 Kbuild Variables
+== Kbuild Variables
 
 The top Makefile exports the following variables:
 
@@ -1168,7 +1131,7 @@ The top Makefile exports the following variables:
 	INSTALL_MOD_STRIP will used as the option(s) to the strip command.
 
 
-=== 8 Makefile language
+== Makefile language
 
 The kernel Makefiles are designed to be run with GNU Make.  The Makefiles
 use only the documented features of GNU Make, but they do use many
@@ -1187,14 +1150,14 @@ time the left-hand side is used.
 There are some cases where "=" is appropriate.  Usually, though, ":="
 is the right choice.
 
-=== 9 Credits
+== Credits
 
 Original version made by Michael Elizabeth Chastain, <mailto:mec@shout.net>
 Updates by Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>
 Updates by Sam Ravnborg <sam@ravnborg.org>
 Language QA by Jan Engelhardt <jengelh@gmx.de>
 
-=== 10 TODO
+== TODO
 
 - Describe how kbuild supports shipped files with _shipped.
 - Generating offset header files.
