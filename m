Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab0CHPPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:15:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34335 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0CHPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:15:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=kDKePN9ipQw7VOX2CxoA:9 a=yUSeBmLAHi5Y8-ghQRgA:7 a=skzS0igDqoiKe4P7xnt0WdXM_ygA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=hGmZHQazYuw5ZoYq:21 a=1kVZGtVzNcbB4VZD:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B94A816.4090608@cn.fujitsu.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 10:15:12 -0500
Message-ID: <1268061312.10871.1810.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 15:32 +0800, Li Zefan wrote:

> > And Li seems to see the same thing.
> 
> Yes, and more than this. I can see segmentation fault while testing,
> both my testing threads and kernel building threads that are running
> at the same time can get segfault.

Segfaults??

This sounds like the compiler may have screwed up again. Can you compile
with this patch and see if it catches anything?

-- Steve

commit 7e91e8a8cc4e2269146107dc91455a7f70a360b4
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Nov 19 23:41:02 2009 -0500

    tracing/x86: Add check to detect GCC messing with mcount prologue
    
    Latest versions of GCC create a funny prologue for some functions.
    Instead of the typical:
    
    		push   %ebp
    		mov    %esp,%ebp
    		and    $0xffffffe0,%esp
    		[...]
    		call   mcount
    
    GCC may try to align the stack before setting up the frame pointer
    register:
    
    		push   %edi
    		lea    0x8(%esp),%edi
    		and    $0xffffffe0,%esp
    		pushl  -0x4(%edi)
    		push   %ebp
    		mov    %esp,%ebp
    		[...]
    		call   mcount
    
    This crazy code places a copy of the return address into the
    frame pointer. The function graph tracer uses this pointer to
    save and replace the return address of the calling function to jump
    to the function graph tracer's return handler, which will put back
    the return address. But instead instead of the typical return:
    
    		mov    %ebp,%esp
    		pop    %ebp
    		ret
    
    The return of the function performs:
    
    		lea    -0x8(%edi),%esp
    		pop    %edi
    		ret
    
    The function graph tracer return handler will not be called at the exit
    of the function, but the parent function will call it. Because we missed
    the return of the child function, the handler will replace the parent's
    return address with that of the child. Obviously this will cause a crash
    (Note, there is code to detect this case and safely panic the kernel).
    
    The kicker is that this happens to just a handful of functions.
    And only with certain gcc options.
    
    Compiling with: 	-march=pentium-mmx
    will cause the problem to appear. But if you were to change
    pentium-mmx to i686 or add -mtune=generic, then the problem goes away.
    
    I first saw this problem when compiling with optimize for size.
    But it seems that various other options may cause this issue to arise.
    
    Instead of completely disabling the function graph tracer for i386 builds
    this patch adds a check to recordmcount.pl to make sure that all
    functions that contain a call to mcount start with "push %ebp".
    If not, it will fail the compile and print out the nasty warning:
    
      CC      kernel/time/timer_stats.o
    
    ********************************************************
      Your version of GCC breaks the function graph tracer
      Please disable CONFIG_FUNCTION_GRAPH_TRACER
      Failed function was "timer_stats_update_stats"
    ********************************************************
    
    The script recordmcount.pl is given a new parameter "do_check". If
    this is negative, the script will only perform this check without
    creating the mcount caller section. This will be executed for x86_32
    when CONFIG_FUNCTION_GRAPH_TRACER is enabled and CONFIG_DYNAMIC_FTRACE
    is not.
    
    If the arch is x86_32 and $do_check is greater than 1, it will perform
    the check while processing the mcount callers. If $do_check is 0, then
    no check will be performed. This is for non x86_32 archs and when
    compiling without CONFIG_FUNCTION_GRAPH_TRACER enabled, even on x86_32.
    
    Reported-by: Thomas Gleixner <tglx@linutronix.de>
    LKML-Reference: <alpine.LFD.2.00.0911191423190.24119@localhost.localdomain>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d006554..380e815 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -143,7 +143,6 @@ config FUNCTION_GRAPH_TRACER
 	bool "Kernel Function Graph Tracer"
 	depends on HAVE_FUNCTION_GRAPH_TRACER
 	depends on FUNCTION_TRACER
-	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
 	default y
 	help
 	  Enable the kernel to trace a function at both its return
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 341b589..3b897f2 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -206,10 +206,33 @@ cmd_modversions =							\
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
+
+ ifdef CONFIG_FUNCTION_GRAPH_TRACER
+  ifdef CONFIG_X86_32
+   rm_do_check = 1
+  else
+   rm_do_check = 0
+  endif
+ else
+  rm_do_check = 0
+ endif
+
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
-	"$(if $(part-of-module),1,0)" "$(@)";
+	"$(if $(part-of-module),1,0)" "$(rm_do_check)" "$(@)";
+
+else
+
+ ifdef CONFIG_X86_32
+ ifdef CONFIG_FUNCTION_GRAPH_TRACER
+   cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+	"$(if $(CONFIG_64BIT),64,32)" \
+	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
+	"$(if $(part-of-module),1,0)" "-1" "$(@)";
+ endif
+ endif
+
 endif
 
 define rule_cc_o_c
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index f0d1445..f3b45a5 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -113,14 +113,14 @@ $P =~ s@.*/@@g;
 
 my $V = '0.1';
 
-if ($#ARGV != 10) {
-	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
+if ($#ARGV < 11) {
+	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module do_check inputfile\n";
 	print "version: $V\n";
 	exit(1);
 }
 
 my ($arch, $bits, $objdump, $objcopy, $cc,
-    $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
+    $ld, $nm, $rm, $mv, $is_module, $do_check, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
 if ($inputfile =~ m,kernel/trace/ftrace\.o$,) {
@@ -144,6 +144,60 @@ $nm = "nm" if ((length $nm) == 0);
 $rm = "rm" if ((length $rm) == 0);
 $mv = "mv" if ((length $mv) == 0);
 
+# gcc can do stupid things with the stack pointer on x86_32.
+# It may pass a copy of the return address to mcount, which will
+# break the function graph tracer. If this happens then we need
+# to flag it and break the build.
+#
+# For x86_32, the parameter do_check will be negative if we only
+# want to perform the check, and positive if we should od the check.
+# If function graph tracing is not enabled, do_check will be zero.
+#
+
+my $check_next_line = 0;
+my $line_failed = 0;
+my $last_function;
+
+sub test_x86_32_prologue
+{
+    if ($check_next_line) {
+	if (!/push\s*\%ebp/) {
+	    $line_failed = 1;
+	}
+    }
+
+    if ($line_failed && /mcount/) {
+	print STDERR "\n********************************************************\n";
+	print STDERR "  Your version of GCC breaks the function graph tracer\n";
+	print STDERR "  Please disable CONFIG_FUNCTION_GRAPH_TRACER\n";
+	print STDERR "  Failed function was \"$last_function\"\n";
+	print STDERR "********************************************************\n\n";
+	exit -1;
+    }
+    $check_next_line = 0;
+
+    # check the first line after a function starts for
+    #  push %ebp
+    if (/^[0-9a-fA-F]+\s+<([a-zA-Z_].*)>:$/) {
+	$last_function = $1;
+	$check_next_line = 1;
+	$line_failed = 0;
+    }
+}
+
+if ($do_check < 0) {
+    # Only perform the check and quit
+    open(IN, "$objdump -dr $inputfile|") || die "error running $objdump";
+
+    while (<IN>) {
+	test_x86_32_prologue;
+    }
+    close (IN);
+    exit 0;
+}
+
+my $check = 0;
+
 #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
 #    "'$nm' '$rm' '$mv' '$inputfile'\n";
 
@@ -202,6 +256,12 @@ if ($arch eq "x86") {
     }
 }
 
+if ($arch eq "i386") {
+    if ($do_check) {
+	$check = 1;
+    }
+}
+
 #
 # We base the defaults off of i386, the other archs may
 # feel free to change them in the below if statements.
@@ -401,6 +461,13 @@ my $read_headers = 1;
 
 while (<IN>) {
 
+    # x86_32 may need to test the start of every function to see
+    # if GCC did not mess up the mcount prologue. All functions must
+    # start with push %ebp, otherwise it is broken.
+    if ($check) {
+	test_x86_32_prologue;
+    }
+
     if ($read_headers && /$mcount_section/) {
 	#
 	# Somehow the make process can execute this script on an


