Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbYDUOwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbYDUOwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYDUOwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:52:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44227 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYDUOwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:52:32 -0400
Date: Mon, 21 Apr 2008 08:52:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [DOC PATCH] Remove mention of semaphores from kernel-locking
Message-ID: <20080421145230.GX20637@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since the consensus seems to be to eliminate semaphores where possible,
we shouldn't be educating people about how to use them as locks.  Use
mutexes instead.  Semaphores should be described in a separate document
if we end up keeping them.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

(I'll put this patch in the semaphore git tree tomorrow unless I hear
complaints.)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index 435413c..e1f4655 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -222,7 +222,7 @@
    <title>Three Main Types of Kernel Locks: Spinlocks, Mutexes and Semaphores</title>
 
    <para>
-     There are three main types of kernel locks.  The fundamental type
+     There are two main types of kernel locks.  The fundamental type
      is the spinlock 
      (<filename class="headerfile">include/asm/spinlock.h</filename>),
      which is a very simple single-holder lock: if you can't get the 
@@ -240,14 +240,6 @@
      use a spinlock instead.
    </para>
    <para>
-     The third type is a semaphore
-     (<filename class="headerfile">include/linux/semaphore.h</filename>): it
-     can have more than one holder at any time (the number decided at
-     initialization time), although it is most commonly used as a
-     single-holder lock (a mutex).  If you can't get a semaphore, your
-     task will be suspended and later on woken up - just like for mutexes.
-   </para>
-   <para>
      Neither type of lock is recursive: see
      <xref linkend="deadlock"/>.
    </para>
@@ -278,7 +270,7 @@
     </para>
 
     <para>
-      Semaphores still exist, because they are required for
+      Mutexes still exist, because they are required for
       synchronization between <firstterm linkend="gloss-usercontext">user 
       contexts</firstterm>, as we will see below.
     </para>
@@ -289,18 +281,17 @@
 
      <para>
        If you have a data structure which is only ever accessed from
-       user context, then you can use a simple semaphore
-       (<filename>linux/linux/semaphore.h</filename>) to protect it.  This
-       is the most trivial case: you initialize the semaphore to the number 
-       of resources available (usually 1), and call
-       <function>down_interruptible()</function> to grab the semaphore, and 
-       <function>up()</function> to release it.  There is also a 
-       <function>down()</function>, which should be avoided, because it 
+       user context, then you can use a simple mutex
+       (<filename>include/linux/mutex.h</filename>) to protect it.  This
+       is the most trivial case: you initialize the mutex.  Then you can
+       call <function>mutex_lock_interruptible()</function> to grab the mutex,
+       and <function>mutex_unlock()</function> to release it.  There is also a 
+       <function>mutex_lock()</function>, which should be avoided, because it 
        will not return if a signal is received.
      </para>
 
      <para>
-       Example: <filename>linux/net/core/netfilter.c</filename> allows 
+       Example: <filename>net/netfilter/nf_sockopt.c</filename> allows 
        registration of new <function>setsockopt()</function> and 
        <function>getsockopt()</function> calls, with
        <function>nf_register_sockopt()</function>.  Registration and 
@@ -515,7 +506,7 @@
       <listitem>
 	<para>
           If you are in a process context (any syscall) and want to
-	lock other process out, use a semaphore.  You can take a semaphore
+	lock other process out, use a mutex.  You can take a mutex
 	and sleep (<function>copy_from_user*(</function> or
 	<function>kmalloc(x,GFP_KERNEL)</function>).
       </para>
@@ -662,7 +653,7 @@
 <entry>SLBH</entry>
 <entry>SLBH</entry>
 <entry>SLBH</entry>
-<entry>DI</entry>
+<entry>MLI</entry>
 <entry>None</entry>
 </row>
 
@@ -692,8 +683,8 @@
 <entry>spin_lock_bh</entry>
 </row>
 <row>
-<entry>DI</entry>
-<entry>down_interruptible</entry>
+<entry>MLI</entry>
+<entry>mutex_lock_interruptible</entry>
 </row>
 
 </tbody>
@@ -1285,7 +1276,7 @@ as Alan Cox says, <quote>Lock data, not code</quote>.
     <para>
       There is a coding bug where a piece of code tries to grab a
       spinlock twice: it will spin forever, waiting for the lock to
-      be released (spinlocks, rwlocks and semaphores are not
+      be released (spinlocks, rwlocks and mutexes are not
       recursive in Linux).  This is trivial to diagnose: not a
       stay-up-five-nights-talk-to-fluffy-code-bunnies kind of
       problem.
@@ -1310,7 +1301,7 @@ as Alan Cox says, <quote>Lock data, not code</quote>.
 
     <para>
       This complete lockup is easy to diagnose: on SMP boxes the
-      watchdog timer or compiling with <symbol>DEBUG_SPINLOCKS</symbol> set
+      watchdog timer or compiling with <symbol>DEBUG_SPINLOCK</symbol> set
       (<filename>include/linux/spinlock.h</filename>) will show this up 
       immediately when it happens.
     </para>
@@ -1533,7 +1524,7 @@ the amount of locking which needs to be done.
    <title>Read/Write Lock Variants</title>
 
    <para>
-      Both spinlocks and semaphores have read/write variants:
+      Both spinlocks and mutexes have read/write variants:
       <type>rwlock_t</type> and <structname>struct rw_semaphore</structname>.
       These divide users into two classes: the readers and the writers.  If
       you are only reading the data, you can get a read lock, but to write to
@@ -1656,7 +1647,7 @@ the amount of locking which needs to be done.
  #include &lt;linux/slab.h&gt;
  #include &lt;linux/string.h&gt;
 +#include &lt;linux/rcupdate.h&gt;
- #include &lt;linux/semaphore.h&gt;
+ #include &lt;linux/mutex.h&gt;
  #include &lt;asm/errno.h&gt;
 
  struct object
@@ -1888,7 +1879,7 @@ machines due to caching.
        </listitem>
        <listitem>
         <para>
-          <function> put_user()</function>
+          <function>put_user()</function>
         </para>
        </listitem>
       </itemizedlist>
@@ -1902,13 +1893,13 @@ machines due to caching.
 
      <listitem>
       <para>
-      <function>down_interruptible()</function> and
-      <function>down()</function>
+      <function>mutex_lock_interruptible()</function> and
+      <function>mutex_lock()</function>
       </para>
       <para>
-       There is a <function>down_trylock()</function> which can be
+       There is a <function>mutex_trylock()</function> which can be
        used inside interrupt context, as it will not sleep.
-       <function>up()</function> will also never sleep.
+       <function>mutex_unlock()</function> will also never sleep.
       </para>
      </listitem>
     </itemizedlist>
@@ -1998,7 +1989,7 @@ machines due to caching.
       <para>
         Prior to 2.5, or when <symbol>CONFIG_PREEMPT</symbol> is
         unset, processes in user context inside the kernel would not
-        preempt each other (ie. you had that CPU until you have it up,
+        preempt each other (ie. you had that CPU until you gave it up,
         except for interrupts).  With the addition of
         <symbol>CONFIG_PREEMPT</symbol> in 2.5.4, this changed: when
         in user context, higher priority tasks can "cut in": spinlocks

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
