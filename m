Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab0BQVBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:01:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:61314 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab0BQVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:01:21 -0500
Message-ID: <4B7C5902.1030306@windriver.com>
Date: Wed, 17 Feb 2010 15:00:50 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu
Subject: Re: [Kgdb-bugreport] [PATCH 15/28] kgdb,	docs: Update the kgdb docs
 to include kdb
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com> <1266014143-29444-16-git-send-email-jason.wessel@windriver.com> <4B7705B4.5080009@xenotime.net>
In-Reply-To: <4B7705B4.5080009@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2010 21:00:49.0651 (UTC) FILETIME=[488CEC30:01CAB014]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On 02/12/10 14:35, Jason Wessel wrote:
>> Update the kgdb docs to reflect the new directory structure and API.
>>
>> Merge in the kdb shell information.
> 
> See comments/corrections inline below.
> 

Thank very much for the comments.  Would you like a credit in the
manual?

I merged in all your edits.

Here is the interdiff in case you were curious.

Thanks,
Jason.

 DocBook/kgdb.tmpl     |  208 ++++++++++++++++++++++++++++----------------------
 kernel-parameters.txt |    3 
 2 files changed, 118 insertions(+), 93 deletions(-)

diff -u b/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
--- b/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -50,20 +50,20 @@
     if you configure the kernel properly at compile and runtime.
     </para>
     <para>
-    Kdb is simplistic shell style interface which you can use on a
+    Kdb is simplistic shell-style interface which you can use on a
     system console with a keyboard or serial console.  You can use it
     to inspect memory, registers, process lists, dmesg, and even set
     breakpoints to stop in a certain location.  Kdb is not a source
     level debugger, although you can set breakpoints and execute some
     basic kernel run control.  Kdb is mainly aimed at doing some
     analysis to aid in development or diagnosing kernel problems.  You
-    can access some symbols by name in kernel builtins or in kernel
+    can access some symbols by name in kernel built-ins or in kernel
     modules if the code was built
     with <symbol>CONFIG_KALLSYMS</symbol>.
     </para>
     <para>
-    Kgdb was intended to be used as a source level debugger for the
-    linux kernel. It is used along with gdb to debug a linux kernel.
+    Kgdb is intended to be used as a source level debugger for the
+    Linux kernel. It is used along with gdb to debug a Linux kernel.
     The expectation is that gdb can be used to "break in" to the
     kernel to inspect memory, variables and look through call stack
     information similar to the way an application developer would use
@@ -79,7 +79,7 @@
     uImage...).  In gdb the developer specifies the connection
     parameters and connects to kgdb.  The type of connection a
     developer makes with gdb depends on the availability of kgdb I/O
-    modules compiled as builtins or kernel modules in the test
+    modules compiled as built-ins or loadable kernel modules in the test
     machine's kernel.
     </para>
   </chapter>
@@ -104,15 +104,15 @@
     vmlinux file, gdb tends not to be very useful without the symbolic
     data, so you will want to turn
     on <symbol>CONFIG_DEBUG_INFO</symbol> which is called "Compile the
-    kernel with debug info" in the menu config.
+    kernel with debug info" in the config menu.
     </para>
     <para>
     It is advised, but not required that you turn on the
     <symbol>CONFIG_FRAME_POINTER</symbol> kernel option which is called "Compile the
-    kernel with frame pointers" in the menu config.  This option
+    kernel with frame pointers" in the config menu.  This option
     inserts code to into the compiled executable which saves the frame
     information in registers or on the stack at different points which
-    will allow a debugger such as gdb to more accurately construct
+    allows a debugger such as gdb to more accurately construct
     stack back traces while debugging the kernel.
     </para>
     <para>
@@ -132,9 +132,10 @@
     must be built into the kernel directly. Kgdb I/O driver
     configuration takes place via kernel or module parameters which
     you can learn more about in the in the section that describes the
-    kernel parameter kgdboc.
+    parameter "kgdboc".
     </para>
-    <para>Here is an example set of .config to enable kgdb:
+    <para>Here is an example set of .config symbols to enable or
+    disable for kgdb:
     <itemizedlist>
     <listitem><para># CONFIG_DEBUG_RODATA is not set</para></listitem>
     <listitem><para>CONFIG_FRAME_POINTER=y</para></listitem>
@@ -146,7 +147,7 @@
   <sect1 id="CompileKDB">
     <title>Kernel config options for kdb</title>
     <para>Kdb is quite a bit more complex than the simple gdbstub
-    sitting on top of the kernel's debug core.  Kdb must implement an
+    sitting on top of the kernel's debug core.  Kdb must implement a
     shell, and also adds some helper functions in other parts of the
     kernel, responsible for printing out interesting data such as what
     you would see if you ran "lsmod", or "ps".  In order to build kdb
@@ -154,19 +155,18 @@
     </para>
     <para>The main config option for kdb
     is <symbol>CONFIG_KGDB_KDB</symbol> which is called "KGDB_KDB:
-    include kdb frontend for kgdb" in the menu config.  In theory you
+    include kdb frontend for kgdb" in the config menu.  In theory you
     would have already also selected an I/O driver such as the
     CONFIG_KGDB_SERIAL_CONSOLE interface if you plan on using kdb on a
     serial port, when you were configuring kgdb.
     </para>
-    <para>If you want to use a ps/2 style keyboard with kdb you would
+    <para>If you want to use a PS/2-style keyboard with kdb, you would
     select CONFIG_KDB_KEYBOARD which is called "KGDB_KDB: keyboard as
-    input device" in the menu config.  This option really does do
-    anything for the gdb interface to kgdb it only works with kdb,
-    because it is not really meaningful to manually type in gdb
-    remote protocol commands.
+    input device" in the config menu.  The CONFIG_KDB_KEYBOARD option
+    is not used for anything in the gdb interface to kgdb.  The
+    CONFIG_KDB_KEYBOARD option only works with kdb.
     </para>
-    <para>Here is an example set of .config to enable kdb:
+    <para>Here is an example set of .config symbols to enable/disable kdb:
     <itemizedlist>
     <listitem><para># CONFIG_DEBUG_RODATA is not set</para></listitem>
     <listitem><para>CONFIG_FRAME_POINTER=y</para></listitem>
@@ -180,10 +180,10 @@
   </chapter>
   <chapter id="kgdbKernelArgs">
   <title>Kernel Debugger Boot Arguments</title>
-  <para>This section will describe the various runtime kernel
+  <para>This section describes the various runtime kernel
   parameters that affect the configuration of the kernel debugger.
-  The following chapter will cover using kdb and kgdb as well as
-  provide some examples of the configuration parameters.</para>
+  The following chapter covers using kdb and kgdb as well as
+  provides some examples of the configuration parameters.</para>
    <sect1 id="kgdboc">
    <title>Kernel parameter: kgdboc</title>
    <para>The kgdboc driver was originally an abbreviation meant to
@@ -192,17 +192,54 @@
    devices you want to use to interact with the kdb shell.
    </para>
    <para>For kgdb/gdb, kgdboc is designed to work with a single serial
-   port. It was meant to cover the circumstance where you wanted to
+   port. It is intended to cover the circumstance where you want to
    use a serial console as your primary console as well as using it to
    perform kernel debugging.  It is also possible to use kgdb on a
    serial port which is not designated as a system console.  Kgdboc
-   may be configured as a kernel built-in or a kernel module.  You can
-   only make use of <constant>kgdbwait</constant> and early debugging
-   if you build kgdboc into the kernel as a builtins.
+   may be configured as a kernel built-in or a kernel loadable module.
+   You can only make use of <constant>kgdbwait</constant> and early
+   debugging if you build kgdboc into the kernel as a built-in.
    </para>
    <sect2 id="kgdbocArgs">
    <title>kgdboc arguments</title>
    <para>Usage: <constant>kgdboc=[kbd][[,]serial_device][,baud]</constant></para>
+   <sect3 id="kgdbocArgs1">
+   <title>Using loadable module or built-in</title>
+   <para>
+   <orderedlist>
+   <listitem><para>As a kernel built-in:</para>
+   <para>Use the kernel boot argument: <constant>kgdboc=&lt;tty-device&gt;,[baud]</constant></para></listitem>
+   <listitem>
+   <para>As a kernel loadable module:</para>
+   <para>Use the command: <constant>modprobe kgdboc kgdboc=&lt;tty-device&gt;,[baud]</constant></para>
+   <para>Here are two examples of how you might formate the kgdboc
+   string. The first is for an x86 target using the first serial port.
+   The second example is for the ARM Versatile AB using the second
+   serial port.
+   <orderedlist>
+   <listitem><para><constant>kgdboc=ttyS0,115200</constant></para></listitem>
+   <listitem><para><constant>kgdboc=ttyAMA1,115200</constant></para></listitem>
+   </orderedlist>
+   </para>
+   </listitem>
+   </orderedlist></para>
+   </sect3>
+   <sect3 id="kgdbocArgs2">
+   <title>Configure kgdboc at runtime with sysfs</title>
+   <para>At run time you can enable or disable kgdboc by echoing a
+   parameters into the sysfs.  Here are two examples:</para>
+   <orderedlist>
+   <listitem><para>Enable kgdboc on ttyS0</para>
+   <para><constant>echo ttyS0 &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para></listitem>
+   <listitem><para>Disable kgdboc</para>
+   <para><constant>echo "" &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para></listitem>
+   </orderedlist>
+   <para>NOTE: You do not need to specify the baud if you are
+   configuring the console on tty which is already configured or
+   open.</para>
+   </sect3>
+   <sect3 id="kgdbocArgs3">
+   <title>More examples</title>
    <para>You can configure kgdboc to use the keyboard, and or a serial device
    depending on if you are using kdb and or kgdb, in one of the
    following scenarios.
@@ -220,42 +257,19 @@
    </listitem>
    </orderedlist>
    </para>
-   <para>You can configure kgdboc via sysfs or a module or kernel boot line
-   parameter depending on if you build with CONFIG_KGDBOC as a module
-   or built-in.
-   <orderedlist>
-   <listitem><para>From the module load or build-in</para>
-   <para>As a kernel argument: <constant>kgdboc=&lt;tty-device&gt;,[baud]</constant></para>
-   <para>As a kernel module: <constant>modprobe kgdboc kgdboc=&lt;tty-device&gt;,[baud]</constant></para>
-   <para>Here are two examples, the first for an x86 target using the
-   first serial port and the second for the ARM Versatile AB using the
-   second serial port.
-   <orderedlist>
-   <listitem><para><constant>kgdboc=ttyS0,115200</constant></para></listitem>
-   <listitem><para><constant>kgdboc=ttyAMA1,115200</constant></para></listitem>
-   </orderedlist>
-   </para>
-   </listitem>
-   <listitem><para>From sysfs</para>
-   <para><constant>echo ttyS0 &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para>
-   <para>NOTE: You do not need to specify the baud if you are
-   configuring the console on tty which is already configured or
-   open.</para>
-   </listitem>
-   </orderedlist>
-   </para>
+   </sect3>
    <para>NOTE: Kgdboc does not support interrupting the target via the
    gdb remote protocol.  You must manually send a sysrq-g unless you
    have a proxy that splits console output to a terminal program.
-   A console proxy has a separate tcp port for the debugger and a separate
-   tcp port for the "human" console.  The proxy can take care of sending
+   A console proxy has a separate TCP port for the debugger and a separate
+   TCP port for the "human" console.  The proxy can take care of sending
    the sysrq-g for you.
    </para>
    <para>When using kgdboc with no debugger proxy, you can end up
-    connecting the debugger for one of two entry points.  If an
-    exception occurs after you have loaded kgdboc a message should
+    connecting the debugger at one of two entry points.  If an
+    exception occurs after you have loaded kgdboc, a message should
     print on the console stating it is waiting for the debugger.  In
-    case you disconnect your terminal program and then connect the
+    this case you disconnect your terminal program and then connect the
     debugger in its place.  If you want to interrupt the target system
     and forcibly enter a debug session you have to issue a Sysrq
     sequence and then type the letter <constant>g</constant>.  Then
@@ -280,8 +294,9 @@
    </para>
    <para>
    The kernel will stop and wait as early as the I/O driver and
-   architecture will allow when you use this option.  If you build the
-   kgdb I/O driver as a kernel module kgdbwait will not do anything.
+   architecture allows when you use this option.  If you build the
+   kgdb I/O driver as a loadable kernel module kgdbwait will not do
+   anything.
    </para>
    </sect1>
    <sect1 id="kgdbcon">
@@ -297,7 +312,7 @@
    <listitem><para>Activate with the kernel command line option:</para>
    <para><constant>kgdbcon</constant></para>
    </listitem>
-   <listitem><para>Use sysfs before configuring an io driver</para>
+   <listitem><para>Use sysfs before configuring an I/O driver</para>
    <para>
    <constant>echo 1 &gt; /sys/module/kgdb/parameters/kgdb_use_con</constant>
    </para>
@@ -309,7 +324,7 @@
    </listitem>
    </orderedlist>
    <para>IMPORTANT NOTE: You cannot use kgdboc + kgdbcon on a tty that is an
-   active system console IE: console=ttyS0,115200 kgdboc=ttyS0 kgdbcon
+   active system console.  An example incorrect usage is <constant>console=ttyS0,115200 kgdboc=ttyS0 kgdbcon</constant>
    </para>
    <para>It is possible to use this option with kgdboc on a tty that is not a system console.
    </para>
@@ -322,20 +337,20 @@
   </para>
   <sect1 id="quickKDBserial">
   <title>Quick start for kdb on a serial port</title>
-  <para>This is a quick example of how to use kdb</para>
+  <para>This is a quick example of how to use kdb.</para>
   <para><orderedlist>
   <listitem><para>Boot kernel with arguments:
   <itemizedlist>
   <listitem><para><constant>console=ttyS0,115200 kgdboc=ttyS0,115200</constant></para></listitem>
   </itemizedlist></para>
   <para>OR</para>
-  <para>Configure kgdboc after the kernel booted assuming your are using a serial port console:
+  <para>Configure kgdboc after the kernel booted; assuming you are using a serial port console:
   <itemizedlist>
   <listitem><para><constant>echo ttyS0 &gt; /sys/module/kgdboc/parameters/kgdboc</constant></para></listitem>
   </itemizedlist>
   </para>
   </listitem>
-  <listitem><para>Enter the kernel debugger manually or by waiting for an opps or fault.  There are several ways you can enter the kernel debugger manually, all involve using the sysrq-g, which means you have to enabled CONFIG_MAGIC_SYSRQ=y in your kernel config</para>
+  <listitem><para>Enter the kernel debugger manually or by waiting for an oops or fault.  There are several ways you can enter the kernel debugger manually; all involve using the sysrq-g, which means you must have enabled CONFIG_MAGIC_SYSRQ=y in your kernel config.</para>
   <itemizedlist>
   <listitem><para>When logged in as root or with a super user session you can run:</para>
    <para><constant>echo g &gt; /proc/sysrq-trigger</constant></para></listitem>
@@ -366,13 +381,19 @@
   </para>
   </listitem>
   <listitem>
-  <para>When you are done using kdb you need to consider rebooting the system or using the "go" command to resuming normal kernel execution.  If you have paused the kernel for a lengthy period of time, applications that rely on timely networking or anything to do with real wall clock time could get adversely affected, so you should take this into consideration when using the kernel debugger.</para>
+  <para>When you are done using kdb you need to consider rebooting the
+  system or using the "go" command to resuming normal kernel
+  execution.  If you have paused the kernel for a lengthy period of
+  time, applications that rely on timely networking or anything to do
+  with real wall clock time could be adversely affected, so you
+  should take this into consideration when using the kernel
+  debugger.</para>
   </listitem>
   </orderedlist></para>
   </sect1>
   <sect1 id="quickKDBkeyboard">
   <title>Quick start for kdb using a keyboard connected console</title>
-  <para>This is a quick example of how to use kdb with a keyboard</para>
+  <para>This is a quick example of how to use kdb with a keyboard.</para>
   <para><orderedlist>
   <listitem><para>Boot kernel with arguments:
   <itemizedlist>
@@ -385,7 +406,7 @@
   </itemizedlist>
   </para>
   </listitem>
-  <listitem><para>Enter the kernel debugger manually or by waiting for an opps or fault.  There are several ways you can enter the kernel debugger manually, all involve using the sysrq-g, which means you have to enabled CONFIG_MAGIC_SYSRQ=y in your kernel config</para>
+  <listitem><para>Enter the kernel debugger manually or by waiting for an oops or fault.  There are several ways you can enter the kernel debugger manually; all involve using the sysrq-g, which means you must have enabled CONFIG_MAGIC_SYSRQ=y in your kernel config.</para>
   <itemizedlist>
   <listitem><para>When logged in as root or with a super user session you can run:</para>
    <para><constant>echo g &gt; /proc/sysrq-trigger</constant></para></listitem>
@@ -397,7 +418,7 @@
   <para>Press and release: <constant>g</constant></para>
   <para>Release: <constant>Alt</constant></para>
   </listitem>
-  <listitem><para>Example using a PS/2 101 keyboard</para>
+  <listitem><para>Example using a PS/2 101-key keyboard</para>
   <para>Press and hold down: <constant>Alt</constant></para>
   <para>Press and release the key with the label: <constant>SysRq</constant></para>
   <para>Press and release: <constant>g</constant></para>
@@ -427,7 +448,7 @@
    The driver can be unconfigured by passing an empty string.  You cannot
    change the configuration while the debugger is attached.  Make sure
    to detach the debugger with the <constant>detach</constant> command
-   prior to trying unconfigure a kgdb I/O driver.
+   prior to trying to unconfigure a kgdb I/O driver.
    </para>
   <sect1 id="ConnectingGDB">
   <title>Connecting with gdb to a serial port</title>
@@ -445,10 +466,10 @@
   </listitem>
   <listitem>
   <para>Stop kernel execution (break into the debugger)</para>
-  <para>In order to connect to gdb to the via kgdboc the kernel must
+  <para>In order to connect to gdb via kgdboc, the kernel must
   first be stopped.  There are several ways to stop the kernel which
   include using kgdbwait as a boot argument, via a sysrq-g, or running
-  the kernel until it takes an an exception where it waits for the
+  the kernel until it takes an exception where it waits for the
   debugger to attach.
   <itemizedlist>
   <listitem><para>When logged in as root or with a super user session you can run:</para>
@@ -478,7 +499,7 @@
     (gdb) target remote /dev/ttyS0
     </programlisting>
     <para>
-    Example (kgdb to a terminal server on tcp port 2012):
+    Example (kgdb to a terminal server on TCP port 2012):
     </para>
     <programlisting>
     % gdb ./vmlinux
@@ -497,8 +518,8 @@
     </para>
   </listitem>
   </orderedlist>
-  <para>Remember if you continue in gdb, and need "break in" again,
-  you need to issue an other sysrq.  It is easy to create an simple
+  <para>Remember if you continue in gdb, and need to "break in" again,
+  you need to issue an other sysrq-g.  It is easy to create a simple
   entry point by putting a breakpoint at <constant>sys_sync</constant>
   and then you can run "sync" from a shell or script to break into the
   debugger.</para>
@@ -514,11 +535,11 @@
   <sect2>
   <title>Switching from kgdb to kdb</title>
   <para>
-  There are two ways to switch from kgdb to kdb, you can use gdb to
+  There are two ways to switch from kgdb to kdb: you can use gdb to
   issue a maintenance packet, or you can blindly type the command $3#33.
-  When ever kernel debugger stops in kgdb mode it will print the
+  Whenever kernel debugger stops in kgdb mode it will print the
   message <constant>KGDB or $3#33 for KDB</constant>.  It is important
-  to note, that you have to type the sequence correctly in one pass.
+  to note that you have to type the sequence correctly in one pass.
   You cannot type a backspace or delete because kgdb will interpret
   that as part of the debug stream.
   <orderedlist>
@@ -526,7 +547,8 @@
   <para><constant>$3#33</constant></para></listitem>
   <listitem><para>Change from kgdb to kdb with gdb</para>
   <para><constant>maintenance packet 3</constant></para>
-  <para>NOTE: Now you must kill gdb</para></listitem>
+  <para>NOTE: Now you must kill gdb. Typically you press control-z and
+  issue the command: kill -9 %</para></listitem>
   </orderedlist>
   </para>
   </sect2>
@@ -554,7 +576,7 @@
   state of the kernel debugger.  You should be using gdb for
   breakpoints and run control operations if you have gdb connected.
   The more useful commands to run are things like lsmod, dmesg, ps or
-  possibly some of the memory information.  To see all the kdb
+  possibly some of the memory information commands.  To see all the kdb
   commands you can run <constant>monitor help</constant>.</para>
   <para>Example:
   <informalexample><programlisting>
@@ -607,24 +629,26 @@
       <para>
       The debug core is found in kernel/debugger/debug_core.c.  It contains:
       <itemizedlist>
-      <listitem><para>A generic OS exception handler which includes sync'ing the processors into a stopped state on an multi cpu system.</para></listitem>
+      <listitem><para>A generic OS exception handler which includes
+      sync'ing the processors into a stopped state on an multi-CPU
+      system.</para></listitem>
       <listitem><para>The API to talk to the kgdb I/O drivers</para></listitem>
-      <listitem><para>The API to make calls to the arch specific kgdb implementation</para></listitem>
+      <listitem><para>The API to make calls to the arch-specific kgdb implementation</para></listitem>
       <listitem><para>The logic to perform safe memory reads and writes to memory while using the debugger</para></listitem>
       <listitem><para>A full implementation for software breakpoints unless overridden by the arch</para></listitem>
       <listitem><para>The API to invoke either the kdb or kgdb frontend to the debug core.</para></listitem>
       </itemizedlist>
       </para>
       </listitem>
-      <listitem><para>kgdb arch specific implementation</para>
+      <listitem><para>kgdb arch-specific implementation</para>
       <para>
       This implementation is generally found in arch/*/kernel/kgdb.c.
       As an example, arch/x86/kernel/kgdb.c contains the specifics to
       implement HW breakpoint as well as the initialization to
       dynamically register and unregister for the trap handlers on
-      this architecture.  The arch specific portion implements:
+      this architecture.  The arch-specific portion implements:
       <itemizedlist>
-      <listitem><para>contains an arch specific trap catcher which
+      <listitem><para>contains an arch-specific trap catcher which
       invokes kgdb_handle_exception() to start kgdb about doing its
       work</para></listitem>
       <listitem><para>translation to and from gdb specific packet format to pt_regs</para></listitem>
@@ -644,16 +668,18 @@
       <listitem><para>kdb frontend</para>
       <para>The kdb debugger shell is broken down into a number of
       components.  The kdb core is located in kernel/debug/kdb.  There
-      are number of helper functions in some of the other kernel
-      components to make it possible for kdb to examine report
+      are a number of helper functions in some of the other kernel
+      components to make it possible for kdb to examine and report
       information about the kernel without taking locks that could
       cause a kernel deadlock.  The kdb core contains implements the following functionality.</para>
       <itemizedlist>
         <listitem><para>A simple shell</para></listitem>
         <listitem><para>The kdb core command set</para></listitem>
         <listitem><para>A registration API to register additional kdb shell commands.</para>
-        <para>A good example of a self contained kdb module is the "ftdump" command for dumping the ftrace buffer.  See: kernel/trace/trace_kdb.c</para></listitem>
-        <listitem><para>The implementation for kdb_printf() which emit messages directly to I/O drivers, bypassing the kernel log.</para></listitem>
+        <para>A good example of a self-contained kdb module is the "ftdump" command for dumping the ftrace buffer.  See: kernel/trace/trace_kdb.c</para></listitem>
+        <listitem><para>The implementation for kdb_printf() which
+        emits messages directly to I/O drivers, bypassing the kernel
+        log.</para></listitem>
         <listitem><para>SW / HW breakpoint management for the kdb shell</para></listitem>
       </itemizedlist>
       </listitem>
@@ -661,7 +687,7 @@
       <para>
       Each kgdb I/O driver has to provide an implementation for the following:
       <itemizedlist>
-      <listitem><para>configuration via builtin or module</para></listitem>
+      <listitem><para>configuration via built-in or module</para></listitem>
       <listitem><para>dynamic configuration and kgdb hook registration calls</para></listitem>
       <listitem><para>read and write character interface</para></listitem>
       <listitem><para>A cleanup handler for unconfiguring from the kgdb core</para></listitem>
@@ -726,15 +752,15 @@
   underlying low level to the hardware driver having "polling hooks"
   which the to which the tty driver is attached.  In the initial
   implementation of kgdboc it the serial_core was changed to expose a
-  low level uart hook for doing polled mode reading and writing of a
+  low level UART hook for doing polled mode reading and writing of a
   single character while in an atomic context.  When kgdb makes an I/O
   request to the debugger, kgdboc invokes a call back in the serial
-  core which in turn uses the call back in the uart driver.  It is
-  certainly possible to extend kgdboc to work with non-uart based
+  core which in turn uses the call back in the UART driver.  It is
+  certainly possible to extend kgdboc to work with non-UART based
   consoles in the future.
   </para>
   <para>
-  When using kgdboc with a uart, the uart driver must implement two callbacks in the <constant>struct uart_ops</constant>. Example from drivers/8250.c:<programlisting>
+  When using kgdboc with a UART, the UART driver must implement two callbacks in the <constant>struct uart_ops</constant>. Example from drivers/8250.c:<programlisting>
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char = serial8250_get_poll_char,
 	.poll_put_char = serial8250_put_poll_char,
@@ -744,7 +770,7 @@
   <constant>#ifdef CONFIG_CONSOLE_POLL</constant>, as shown above.
   Keep in mind that polling hooks have to be implemented in such a way
   that they can be called from an atomic context and have to restore
-  the state of the uart chip on return such that the system can return
+  the state of the UART chip on return such that the system can return
   to normal when the debugger detaches.  You need to be very careful
   with any kind of lock you consider, because failing here is most
   going to mean pressing the reset button.
diff -u b/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
--- b/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1111,8 +1111,7 @@
 			keyboard and serial format: kbd,<serial_device>[,baud]
 
 	kgdbwait	[KGDB] Stop kernel execution and enter the
-			kernel debugger at the earliest opportunity if
-			kgdb was configured on as a boot argument.
+			kernel debugger at the earliest opportunity.
 
 	kmac=		[MIPS] korina ethernet MAC address.
 			Configure the RouterBoard 532 series on-chip

