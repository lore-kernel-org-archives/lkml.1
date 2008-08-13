Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYHMRQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYHMRQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYHMRPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:15:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbYHMRPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:15:50 -0400
Message-ID: <48A316A2.9080907@redhat.com>
Date: Wed, 13 Aug 2008 13:15:14 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Bruce Duncan <bwduncan@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [git pull] ftrace for v2.6.27
References: <20080714142226.GA11412@elte.hu> <200808130248.58216.bwduncan@gmail.com>
In-Reply-To: <200808130248.58216.bwduncan@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010302060805090009080503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010302060805090009080503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Bruce Duncan wrote:
> Hi Ingo, Steven, everyone,
>
> [ Please CC me in replies ]
>
> I have just tracked down a regression in 2.6.27-rc2 wrt 2.6.26. Commit 
> 77a2b37d227483fe52aead242652aee406c25bf0 (ftrace: startup tester on dynamic 
> tracing.) causes my laptop to fail to resume from S3 (it simply reboots about 
> a second after the resume starts and the display never shows anything).
>
> The patch doesn't revert with patch -R (I don't know if there's a cleverer way 
> to ask git to revert it), but the problem goes away if I turn off 
> CONFIG_DYNAMIC_FTRACE.
>
> The commit and bisect log are attached. Please can you help me to debug this?
>   
Hi Bruce,

Seems that the issue is with the "ftraced" daemon. The patch you 
reverted was just a fix in the ftrace startup test. If something fails 
in the start up test, that something is disabled.  There was a bug in 
the start up test that caused the dynamic ftrace to fail, and thus 
disabling dynamic ftrace. The patch you reverted, was the fix to that 
bug, so you indirectly disabled dynamic ftrace with that revert.

I've been developing a way to get rid of the "ftraced" daemon. Here's a 
big patch to do so against latest git (as of today). Can you go back to 
the original git, apply this patch and see if you can resume again.

After applying this patch you need to do a "chmod +x 
scripts/recordmcount.pl" before compiling.

Thanks,

-- Steve


Note: my goodmis.org account is currently offline :-( so I'm sending 
this from my redhat account, where I use TB. I have yet to figure out 
how to send a patch inline correctly with TB, so I'm attaching it.


--------------010302060805090009080503
Content-Type: text/x-patch;
 name="ftrace-mcount-record-big.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ftrace-mcount-record-big.patch"

Index: linux-compile.git/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-compile.git.orig/include/asm-generic/vmlinux.lds.h	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/include/asm-generic/vmlinux.lds.h	2008-08-13 12:25:44.000000000 -0400
@@ -37,6 +37,13 @@
 #define MEM_DISCARD(sec) *(.mem##sec)
 #endif
 
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+#define MCOUNT_REC()	VMLINUX_SYMBOL(__start_mcount_loc) = .; \
+			*(__mcount_loc)				\
+			VMLINUX_SYMBOL(__stop_mcount_loc) = .;
+#else
+#define MCOUNT_REC()
+#endif
 
 /* .data section */
 #define DATA_DATA							\
@@ -188,6 +195,7 @@
 	/* __*init sections */						\
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
+		MCOUNT_REC()						\
 		DEV_KEEP(init.rodata)					\
 		DEV_KEEP(exit.rodata)					\
 		CPU_KEEP(init.rodata)					\
Index: linux-compile.git/scripts/Makefile.build
===================================================================
--- linux-compile.git.orig/scripts/Makefile.build	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/scripts/Makefile.build	2008-08-13 12:25:44.000000000 -0400
@@ -198,10 +198,16 @@ cmd_modversions =							\
 	fi;
 endif
 
+ifdef CONFIG_FTRACE_MCOUNT_RECORD
+cmd_record_mcount = scripts/recordmcount.pl "$(ARCH)" \
+	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" "$(@)";
+endif
+
 define rule_cc_o_c
 	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
 	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
 	$(cmd_modversions)						  \
+	$(cmd_record_mcount)						  \
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \
 	rm -f $(depfile);						  \
Index: linux-compile.git/scripts/recordmcount.pl
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile.git/scripts/recordmcount.pl	2008-08-13 12:25:44.000000000 -0400
@@ -0,0 +1,280 @@
+#!/usr/bin/perl -w
+# (c) 2008, Steven Rostedt <srostedt@redhat.com>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# recordmcount.pl - makes a section called __mcount_loc that holds
+#                   all the offsets to the calls to mcount.
+#
+#
+# What we want to end up with is a section in vmlinux called
+# __mcount_loc that contains a list of pointers to all the
+# call sites in the kernel that call mcount. Later on boot up, the kernel
+# will read this list, save the locations and turn them into nops.
+# When tracing or profiling is later enabled, these locations will then
+# be converted back to pointers to some function.
+#
+# This is no easy feat. This script is called just after the original
+# object is compiled and before it is linked.
+#
+# The references to the call sites are offsets from the section of text
+# that the call site is in. Hence, all functions in a section that
+# has a call site to mcount, will have the offset from the beginning of
+# the section and not the beginning of the function.
+#
+# The trick is to find a way to record the beginning of the section.
+# The way we do this is to look at the first function in the section
+# which will also be the location of that section after final link.
+# e.g.
+#
+#  .section ".text.sched"
+#  .globl my_func
+#  my_func:
+#        [...]
+#        call mcount  (offset: 0x5)
+#        [...]
+#        ret
+#  other_func:
+#        [...]
+#        call mcount (offset: 0x1b)
+#        [...]
+#
+# Both relocation offsets for the mcounts in the above example will be
+# offset from .text.sched. If we make another file called tmp.s with:
+#
+#  .section __mcount_loc
+#  .quad  my_func + 0x5
+#  .quad  my_func + 0x1b
+#
+# We can then compile this tmp.s into tmp.o, and link it to the original
+# object.
+#
+# But this gets hard if my_func is not globl (a static function).
+# In such a case we have:
+#
+#  .section ".text.sched"
+#  my_func:
+#        [...]
+#        call mcount  (offset: 0x5)
+#        [...]
+#        ret
+#  .globl my_func
+#  other_func:
+#        [...]
+#        call mcount (offset: 0x1b)
+#        [...]
+#
+# If we make the tmp.s the same as above, when we link together with
+# the original object, we will end up with two symbols for my_func:
+# one local, one global.  After final compile, we will end up with
+# an undefined reference to my_func.
+#
+# Since local objects can reference local variables, we need to find
+# a way to make tmp.o reference the local objects of the original object
+# file after it is linked together. To do this, we convert the my_func
+# into a global symbol before linking tmp.o. Then after we link tmp.o
+# we will only have a single symbol for my_func that is global.
+# We can convert my_func back into a local symbol and we are done.
+#
+# Here are the steps we take:
+#
+# 1) Record all the local symbols by using 'nm'
+# 2) Use objdump to find all the call site offsets and sections for
+#    mcount.
+# 3) Compile the list into its own object.
+# 4) Do we have to deal with local functions? If not, go to step 8.
+# 5) Make an object that converts these local functions to global symbols
+#    with objcopy.
+# 6) Link together this new object with the list object.
+# 7) Convert the local functions back to local symbols and rename
+#    the result as the original object.
+#    End.
+# 8) Link the object with the list object.
+# 9) Move the result back to the original object.
+#    End.
+#
+
+use strict;
+
+my $P = $0;
+$P =~ s@.*/@@g;
+
+my $V = '0.1';
+
+if ($#ARGV < 6) {
+	print "usage: $P arch objdump objcopy cc ld nm rm mv inputfile\n";
+	print "version: $V\n";
+	exit(1);
+}
+
+my ($arch, $objdump, $objcopy, $cc, $ld, $nm, $rm, $mv, $inputfile) = @ARGV;
+
+$objdump = "objdump" if ((length $objdump) == 0);
+$objcopy = "objcopy" if ((length $objcopy) == 0);
+$cc = "gcc" if ((length $cc) == 0);
+$ld = "ld" if ((length $ld) == 0);
+$nm = "nm" if ((length $nm) == 0);
+$rm = "rm" if ((length $rm) == 0);
+$mv = "mv" if ((length $mv) == 0);
+
+#print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
+#    "'$nm' '$rm' '$mv' '$inputfile'\n";
+
+my %locals;
+my %convert;
+
+my $type;
+my $section_regex;	# Find the start of a section
+my $function_regex;	# Find the name of a function (return func name)
+my $mcount_regex;	# Find the call site to mcount (return offset)
+
+if ($arch eq "x86_64") {
+    $section_regex = "Disassembly of section";
+    $function_regex = "<(.*?)>:";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\\+";
+    $type = ".quad";
+} elsif ($arch eq "i386") {
+    $section_regex = "Disassembly of section";
+    $function_regex = "<(.*?)>:";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+    $type = ".long";
+} else {
+    die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
+}
+
+my $text_found = 0;
+my $read_function = 0;
+my $opened = 0;
+my $text = "";
+my $mcount_section = "__mcount_loc";
+
+my $dirname;
+my $filename;
+my $prefix;
+my $ext;
+
+if ($inputfile =~ m,^(.*)/([^/]*)$,) {
+    $dirname = $1;
+    $filename = $2;
+} else {
+    $dirname = ".";
+    $filename = $inputfile;
+}
+
+if ($filename =~ m,^(.*)(\.\S),) {
+    $prefix = $1;
+    $ext = $2;
+} else {
+    $prefix = $filename;
+    $ext = "";
+}
+
+my $mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
+my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
+
+#
+# Step 1: find all the local symbols (static functions).
+#
+open (IN, "$nm $inputfile|") || die "error running $nm";
+while (<IN>) {
+    if (/^[0-9a-fA-F]+\s+t\s+(\S+)/) {
+	$locals{$1} = 1;
+    }
+}
+close(IN);
+
+#
+# Step 2: find the sections and mcount call sites
+#
+open(IN, "$objdump -dr $inputfile|") || die "error running $objdump";
+
+while (<IN>) {
+    # is it a section?
+    if (/$section_regex/) {
+	$read_function = 1;
+	$text_found = 0;
+    # section found, now is this a start of a function?
+    } elsif ($read_function && /$function_regex/) {
+	$read_function = 0;
+	$text_found = 1;
+	$text = $1;
+	# is this function static? If so, note this fact.
+	if (defined $locals{$text}) {
+	    $convert{$text} = 1;
+	}
+    # is this a call site to mcount? If so, print the offset from the section
+    } elsif ($text_found && /$mcount_regex/) {
+	if (!$opened) {
+	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
+	    $opened = 1;
+	    print FILE "\t.section $mcount_section,\"a\",\@progbits\n";
+	}
+	print FILE "\t$type $text + 0x$1\n";
+    }
+}
+
+# If we did not find any mcount callers, we are done (do nothing).
+if (!$opened) {
+    exit(0);
+}
+
+close(FILE);
+
+#
+# Step 3: Compile the file that holds the list of call sites to mcount.
+#
+`$cc -o $mcount_o -c $mcount_s`;
+
+my @converts = keys %convert;
+
+#
+# Step 4: Do we have sections that started with local functions?
+#
+if ($#converts >= 0) {
+    my $globallist = "";
+    my $locallist = "";
+
+    foreach my $con (@converts) {
+	$globallist .= " --globalize-symbol $con";
+	$locallist .= " --localize-symbol $con";
+    }
+
+    my $globalobj = $dirname . "/.tmp_gl_" . $filename;
+    my $globalmix = $dirname . "/.tmp_mx_" . $filename;
+
+    #
+    # Step 5: set up each local function as a global
+    #
+    `$objcopy $globallist $inputfile $globalobj`;
+
+    #
+    # Step 6: Link the global version to our list.
+    #
+    `$ld -r $globalobj $mcount_o -o $globalmix`;
+
+    #
+    # Step 7: Convert the local functions back into local symbols
+    #
+    `$objcopy $locallist $globalmix $inputfile`;
+
+    # Remove the temp files
+    `$rm $globalobj $globalmix`;
+
+} else {
+
+    my $mix = $dirname . "/.tmp_mx_" . $filename;
+
+    #
+    # Step 8: Link the object with our list of call sites object.
+    #
+    `$ld -r $inputfile $mcount_o -o $mix`;
+
+    #
+    # Step 9: Move the result back to the original object.
+    #
+    `$mv $mix $inputfile`;
+}
+
+# Clean up the temp files
+`$rm $mcount_o $mcount_s`;
+
+exit(0);
Index: linux-compile.git/kernel/trace/Kconfig
===================================================================
--- linux-compile.git.orig/kernel/trace/Kconfig	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/kernel/trace/Kconfig	2008-08-13 12:25:44.000000000 -0400
@@ -7,6 +7,9 @@ config HAVE_FTRACE
 config HAVE_DYNAMIC_FTRACE
 	bool
 
+config HAVE_FTRACE_MCOUNT_RECORD
+	bool
+
 config TRACER_MAX_TRACE
 	bool
 
@@ -121,6 +124,11 @@ config DYNAMIC_FTRACE
 	 were made. If so, it runs stop_machine (stops all CPUS)
 	 and modifies the code to jump over the call to ftrace.
 
+config FTRACE_MCOUNT_RECORD
+	def_bool y
+	depends on DYNAMIC_FTRACE
+	depends on HAVE_FTRACE_MCOUNT_RECORD
+
 config FTRACE_SELFTEST
 	bool
 
Index: linux-compile.git/include/asm-x86/ftrace.h
===================================================================
--- linux-compile.git.orig/include/asm-x86/ftrace.h	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/include/asm-x86/ftrace.h	2008-08-13 12:25:44.000000000 -0400
@@ -7,6 +7,16 @@
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
+
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	/*
+	 * call mcount is "e8 <4 byte offset>"
+	 * The addr points to the 4 byte offset and the caller of this
+	 * function wants the pointer to e8. Simply subtract one.
+	 */
+	return addr - 1;
+}
 #endif
 
 #endif /* CONFIG_FTRACE */
Index: linux-compile.git/include/linux/ftrace.h
===================================================================
--- linux-compile.git.orig/include/linux/ftrace.h	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/include/linux/ftrace.h	2008-08-13 12:25:44.000000000 -0400
@@ -141,4 +141,13 @@ static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
 #endif
 
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+extern void ftrace_init(void);
+extern void ftrace_init_module(unsigned long *start, unsigned long *end);
+#else
+static inline void ftrace_init(void) { }
+static inline void
+ftrace_init_module(unsigned long *start, unsigned long *end) { }
+#endif
+
 #endif /* _LINUX_FTRACE_H */
Index: linux-compile.git/init/main.c
===================================================================
--- linux-compile.git.orig/init/main.c	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/init/main.c	2008-08-13 12:25:44.000000000 -0400
@@ -60,6 +60,7 @@
 #include <linux/sched.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
+#include <linux/ftrace.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -687,6 +688,8 @@ asmlinkage void __init start_kernel(void
 
 	acpi_early_init(); /* before LAPIC and SMP init */
 
+	ftrace_init();
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-08-13 12:25:44.000000000 -0400
@@ -792,47 +792,7 @@ static int ftrace_update_code(void)
 	return 1;
 }
 
-static int ftraced(void *ignore)
-{
-	unsigned long usecs;
-
-	while (!kthread_should_stop()) {
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		/* check once a second */
-		schedule_timeout(HZ);
-
-		if (unlikely(ftrace_disabled))
-			continue;
-
-		mutex_lock(&ftrace_sysctl_lock);
-		mutex_lock(&ftraced_lock);
-		if (!ftraced_suspend && !ftraced_stop &&
-		    ftrace_update_code()) {
-			usecs = nsecs_to_usecs(ftrace_update_time);
-			if (ftrace_update_tot_cnt > 100000) {
-				ftrace_update_tot_cnt = 0;
-				pr_info("hm, dftrace overflow: %lu change%s"
-					" (%lu total) in %lu usec%s\n",
-					ftrace_update_cnt,
-					ftrace_update_cnt != 1 ? "s" : "",
-					ftrace_update_tot_cnt,
-					usecs, usecs != 1 ? "s" : "");
-				ftrace_disabled = 1;
-				WARN_ON_ONCE(1);
-			}
-		}
-		mutex_unlock(&ftraced_lock);
-		mutex_unlock(&ftrace_sysctl_lock);
-
-		ftrace_shutdown_replenish();
-	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
-}
-
-static int __init ftrace_dyn_table_alloc(void)
+static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 {
 	struct ftrace_page *pg;
 	int cnt;
@@ -859,7 +819,9 @@ static int __init ftrace_dyn_table_alloc
 
 	pg = ftrace_pages = ftrace_pages_start;
 
-	cnt = NR_TO_INIT / ENTRIES_PER_PAGE;
+	cnt = num_to_init / ENTRIES_PER_PAGE;
+	pr_info("ftrace: allocating %ld hash entries in %d pages\n",
+		num_to_init, cnt);
 
 	for (i = 0; i < cnt; i++) {
 		pg->next = (void *)get_zeroed_page(GFP_KERNEL);
@@ -1556,6 +1518,109 @@ static __init int ftrace_init_debugfs(vo
 
 fs_initcall(ftrace_init_debugfs);
 
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+static int ftrace_convert_nops(unsigned long *start,
+			       unsigned long *end)
+{
+	unsigned long *p;
+	unsigned long addr;
+	unsigned long flags;
+
+	p = start;
+	while (p < end) {
+		addr = ftrace_call_adjust(*p++);
+		ftrace_record_ip(addr);
+		ftrace_shutdown_replenish();
+	}
+
+	/* p is ignored */
+	local_irq_save(flags);
+	__ftrace_update_code(p);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+void ftrace_init_module(unsigned long *start, unsigned long *end)
+{
+	ftrace_convert_nops(start, end);
+}
+
+extern unsigned long __start_mcount_loc[];
+extern unsigned long __stop_mcount_loc[];
+
+void __init ftrace_init(void)
+{
+	unsigned long count, addr, flags;
+	int ret;
+
+	/* Keep the ftrace pointer to the stub */
+	addr = (unsigned long)ftrace_stub;
+
+	local_irq_save(flags);
+	ftrace_dyn_arch_init(&addr);
+	local_irq_restore(flags);
+
+	/* ftrace_dyn_arch_init places the return code in addr */
+	if (addr)
+		goto failed;
+
+	count = __stop_mcount_loc - __start_mcount_loc;
+
+	ret = ftrace_dyn_table_alloc(count);
+	if (ret)
+		goto failed;
+
+	last_ftrace_enabled = ftrace_enabled = 1;
+
+	ret = ftrace_convert_nops(__start_mcount_loc,
+				  __stop_mcount_loc);
+
+	return;
+ failed:
+	ftrace_disabled = 1;
+}
+#else /* CONFIG_FTRACE_MCOUNT_RECORD */
+static int ftraced(void *ignore)
+{
+	unsigned long usecs;
+
+	while (!kthread_should_stop()) {
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		/* check once a second */
+		schedule_timeout(HZ);
+
+		if (unlikely(ftrace_disabled))
+			continue;
+
+		mutex_lock(&ftrace_sysctl_lock);
+		mutex_lock(&ftraced_lock);
+		if (!ftraced_suspend && !ftraced_stop &&
+		    ftrace_update_code()) {
+			usecs = nsecs_to_usecs(ftrace_update_time);
+			if (ftrace_update_tot_cnt > 100000) {
+				ftrace_update_tot_cnt = 0;
+				pr_info("hm, dftrace overflow: %lu change%s"
+					" (%lu total) in %lu usec%s\n",
+					ftrace_update_cnt,
+					ftrace_update_cnt != 1 ? "s" : "",
+					ftrace_update_tot_cnt,
+					usecs, usecs != 1 ? "s" : "");
+				ftrace_disabled = 1;
+				WARN_ON_ONCE(1);
+			}
+		}
+		mutex_unlock(&ftraced_lock);
+		mutex_unlock(&ftrace_sysctl_lock);
+
+		ftrace_shutdown_replenish();
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
 static int __init ftrace_dynamic_init(void)
 {
 	struct task_struct *p;
@@ -1572,7 +1637,7 @@ static int __init ftrace_dynamic_init(vo
 		goto failed;
 	}
 
-	ret = ftrace_dyn_table_alloc();
+	ret = ftrace_dyn_table_alloc(NR_TO_INIT);
 	if (ret)
 		goto failed;
 
@@ -1593,6 +1658,8 @@ static int __init ftrace_dynamic_init(vo
 }
 
 core_initcall(ftrace_dynamic_init);
+#endif /* CONFIG_FTRACE_MCOUNT_RECORD */
+
 #else
 # define ftrace_startup()		do { } while (0)
 # define ftrace_shutdown()		do { } while (0)
Index: linux-compile.git/kernel/module.c
===================================================================
--- linux-compile.git.orig/kernel/module.c	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/kernel/module.c	2008-08-13 12:25:44.000000000 -0400
@@ -46,6 +46,7 @@
 #include <asm/cacheflush.h>
 #include <linux/license.h>
 #include <asm/sections.h>
+#include <linux/ftrace.h>
 
 #if 0
 #define DEBUGP printk
@@ -1831,6 +1832,7 @@ static struct module *load_module(void _
 #endif
 	unsigned int markersindex;
 	unsigned int markersstringsindex;
+	unsigned int mcountindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2118,6 +2120,9 @@ static struct module *load_module(void _
  	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
 					"__markers_strings");
 
+	mcountindex = find_sec(hdr, sechdrs, secstrings,
+			       "__mcount_loc");
+
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
 		const char *strtab = (char *)sechdrs[strindex].sh_addr;
@@ -2167,6 +2172,12 @@ static struct module *load_module(void _
 		marker_update_probe_range(mod->markers,
 			mod->markers + mod->num_markers);
 #endif
+
+	if (mcountindex) {
+		void *mseg = (void *)sechdrs[mcountindex].sh_addr;
+		ftrace_init_module(mseg, mseg + sechdrs[mcountindex].sh_size);
+	}
+
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
Index: linux-compile.git/include/linux/kernel.h
===================================================================
--- linux-compile.git.orig/include/linux/kernel.h	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/include/linux/kernel.h	2008-08-13 12:25:44.000000000 -0400
@@ -486,4 +486,9 @@ struct sysinfo {
 #define NUMA_BUILD 0
 #endif
 
+/* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
+#ifdef CONFIG_FTRACE_MCOUNT_RECORD
+# define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
+#endif
+
 #endif
Index: linux-compile.git/arch/x86/Kconfig
===================================================================
--- linux-compile.git.orig/arch/x86/Kconfig	2008-08-13 12:25:33.000000000 -0400
+++ linux-compile.git/arch/x86/Kconfig	2008-08-13 12:25:44.000000000 -0400
@@ -25,6 +25,7 @@ config X86
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
+	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)

--------------010302060805090009080503--
