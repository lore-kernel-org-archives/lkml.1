Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0BLWjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:39:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:44580 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab0BLWjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:39:47 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 6/7] kgdb,docs: Update the kgdb docs to include kms
Date: Fri, 12 Feb 2010 16:36:27 -0600
Message-Id: <1266014188-29505-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:39:28.0424 (UTC) FILETIME=[3C594280:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the kgdb docs to include information about kernel mode setting support.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl     |   82 +++++++++++++++++++++++++++++++----
 Documentation/kernel-parameters.txt |    9 +++-
 2 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index cc81879..498267b 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -200,12 +200,29 @@
    only make use of <constant>kgdbwait</constant> and early debugging
    if you build kgdboc into the kernel as a builtins.
    </para>
+   <para>Optionally you can elect to activate kms (Kernel Mode
+   Setting) integration.  When you use kms with kgdboc and you have a
+   video driver that has atomic mode setting hooks, it is possible to
+   enter the debugger on the graphics console.  When the kernel
+   execution is resumed, the graphics previous graphics mode will get
+   restored.  This integration can serve as a useful tool to aid in
+   dianosing crashes or doing analysis of memory with kdb while
+   allowing the full graphics console applications to run.
+   </para>
    <sect2 id="kgdbocArgs">
    <title>kgdboc arguments</title>
-   <para>Usage: <constant>kgdboc=[kbd][[,]serial_device][,baud]</constant></para>
-   <para>You can configure kgdboc to use the keyboard, and or a serial device
-   depending on if you are using kdb and or kgdb, in one of the
-   following scenarios.
+   <para>Usage: <constant>kgdboc=[kms][[,]kbd][[,]serial_device][,baud]</constant></para>
+   <para>Abreviations:
+   <itemizedlist>
+   <listitem><para>kms = Kernel Mode Setting</para></listitem>
+   <listitem><para>kbd = Keyboard</para></listitem>
+   </itemizedlist>
+   </para>
+   <para>You can configure kgdboc to use the keyboard, and or a serial
+   device depending on if you are using kdb and or kgdb, in one of the
+   following scenarios.  The order listed above must be observed if
+   you use any of the optional configurations together.  Using kms +
+   only gdb is generally not a usful combination.
    <orderedlist>
    <listitem><para>kdb and kgdb over only a serial port</para>
    <para><constant>kgdboc=&lt;serial_device&gt;[,baud]</constant></para>
@@ -218,6 +235,12 @@
    <listitem><para>kdb with a keyboard</para>
    <para><constant>kgdboc=kbd</constant></para>
    </listitem>
+   <listitem><para>kdb with kernel modesetting</para>
+   <para><constant>kgdboc=kms,kbd</constant></para>
+   </listitem>
+   <listitem><para>kdb with kernel modesetting and kgdb over a serial port</para>
+   <para><constant>kgdboc=kbd,kbd,ttyS0,115200</constant></para>
+   </listitem>
    </orderedlist>
    </para>
    <para>You can configure kgdboc via sysfs or a module or kernel boot line
@@ -613,6 +636,8 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
       <listitem><para>The logic to perform safe memory reads and writes to memory while using the debugger</para></listitem>
       <listitem><para>A full implementation for software breakpoints unless overridden by the arch</para></listitem>
       <listitem><para>The API to invoke either the kdb or kgdb frontend to the debug core.</para></listitem>
+      <listitem><para>The structures and call back API for atomic kernel mode setting.</para>
+      <para>NOTE: kgdboc is where the kms callbacks are invoked.</para></listitem>
       </itemizedlist>
       </para>
       </listitem>
@@ -721,6 +746,8 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
   </sect1>
   <sect1 id="kgdbocDesign">
   <title>kgdboc internals</title>
+  <sect2>
+  <title>kgdboc and uarts</title>
   <para>
   The kgdboc driver is actually a very thin driver that relies on the
   underlying low level to the hardware driver having "polling hooks"
@@ -729,10 +756,7 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
   low level uart hook for doing polled mode reading and writing of a
   single character while in an atomic context.  When kgdb makes an I/O
   request to the debugger, kgdboc invokes a call back in the serial
-  core which in turn uses the call back in the uart driver.  It is
-  certainly possible to extend kgdboc to work with non-uart based
-  consoles in the future.
-  </para>
+  core which in turn uses the call back in the uart driver.</para>
   <para>
   When using kgdboc with a uart, the uart driver must implement two callbacks in the <constant>struct uart_ops</constant>. Example from drivers/8250.c:<programlisting>
 #ifdef CONFIG_CONSOLE_POLL
@@ -746,9 +770,49 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
   that they can be called from an atomic context and have to restore
   the state of the uart chip on return such that the system can return
   to normal when the debugger detaches.  You need to be very careful
-  with any kind of lock you consider, because failing here is most
+  with any kind of lock you consider, because failing here is most likely
   going to mean pressing the reset button.
   </para>
+  </sect2>
+  <sect2 id="kgdbocKbd">
+  <title>kgdboc and keyboards</title>
+  <para>The kgdboc driver contains logic to configure communications
+  with an attached keyboard.  The keyboard infrastructure is only
+  compiled into the kernel when CONFIG_KDB_KEYBOARD=y is set in the
+  kernel configuration.</para>
+  <para>The core polled keyboard driver driver for PS/2 type keyboards
+  is in drivers/char/kdb_keyboard.c.  This driver is hooked into the
+  debug core when kgdboc populates the callback in the arrary
+  called <constant>kdb_poll_funcs[]</constant>.  The
+  kdb_get_kbd_char() is the top level function which polls hardware
+  for single character input.
+  </para>
+  </sect2>
+  <sect2 id="kgdbocKms">
+  <title>kgdboc and kms</title>
+  <para>The kgdboc driver contains logic to request the grpahics
+  display to switch to a text context if you are using
+  kgdboc=kms,... and you have a video driver which has a framebuffer
+  console and atomic kernel mode setting support.  Every time kernel
+  debugger is entered it calls kgdboc_pre_exp_handler() which in turn
+  calls dbg_kms_ops->activate_console().  On resuming kernel
+  execution, the kernel debugger calls kgdboc_post_exp_handler() which
+  in turn calls dbg_kms_ops->restore_console().</para>
+  <para>Any video driver that wants to be compatible with the kernel
+  debugger and the atomic kms callbacks must implement the
+  mode_set_base_atomic operation.  The following is an example from
+  drivers/gpu/drm/i915/intel_display.c:
+  <informalexample>
+  <programlisting>
+static const struct drm_crtc_helper_funcs intel_helper_funcs = {
+[...]
+        .mode_set_base_atomic = intel_pipe_set_base_atomic,
+[...]
+};
+  </programlisting>
+  </informalexample>
+  </para>
+  </sect2>
   </sect1>
   </chapter>
   <chapter id="credits">
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index af8b8e8..b340445 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1106,9 +1106,12 @@ and is between 256 and 4096 characters. It is defined in the file
 	kgdboc=		[KGDB,HW] kgdb over consoles.
 			Requires a tty driver that supports console polling,
 			or a supported polling keyboard driver (non-usb).
-			Serial only format: <serial_device>[,baud]
-			keyboard only format: kbd
-			keyboard and serial format: kbd,<serial_device>[,baud]
+			 Serial only format: <serial_device>[,baud]
+			 keyboard only format: kbd
+			 keyboard and serial format: kbd,<serial_device>[,baud]
+			Optional Kernal mode setting:
+			 kms, kbd format: kms,kbd
+			 kms, kbd and serial format: kms,kbd,<ser_dev>[,baud]
 
 	kgdbwait	[KGDB] Stop kernel execution and enter the
 			kernel debugger at the earliest opportunity if
-- 
1.6.4.rc1

