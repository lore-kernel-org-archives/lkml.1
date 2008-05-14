Return-Path: <linux-kernel-owner+w=401wt.eu-S1762372AbYENRvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762372AbYENRvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762922AbYENRui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:50:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38234 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758695AbYENRuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:50:25 -0400
Date: Wed, 14 May 2008 19:49:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080514174955.GA515@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As some of the latency junkies on lkml already know it, commit 8e3e076 
("BKL: revert back to the old spinlock implementation") in v2.6.26-rc2 
removed the preemptible BKL feature and made the Big Kernel Lock a 
spinlock and thus turned it into non-preemptible code again. This commit 
returned the BKL code to the 2.6.7 state of affairs in essence.

Linus also indicated that pretty much the only acceptable way to change 
this (to us -rt folks rather unfortunate) latency source and to get rid 
of this non-preemptible locking complication is to remove the BKL.

This task is not easy at all. 12 years after Linux has been converted to 
an SMP OS we still have 1300+ legacy BKL using sites. There are 400+ 
lock_kernel() critical sections and 800+ ioctls. They are spread out 
across rather difficult areas of often legacy code that few people 
understand and few people dare to touch.

It takes top people like Alan Cox to map the semantics and to remove BKL 
code, and even for Alan (who is doing this for the TTY code) it is a 
long and difficult task.

According to my quick & dirty git-log analysis, at the current pace of 
BKL removal we'd have to wait more than 10 years to remove most BKL 
critical sections from the kernel and to get acceptable latencies again.
 
The biggest technical complication is that the BKL is unlike any other 
lock: it "self-releases" when schedule() is called. This makes the BKL 
spinlock very "sticky", "invisible" and viral: it's very easy to add it 
to a piece of code (even unknowingly) and you never really know whether 
it's held or not. PREEMPT_BKL made it even more invisible, because it 
made its effects even less visible to ordinary users.

Furthermore, the BKL is not covered by lockdep, so its dependencies are 
largely unknown and invisible, and it is all lost in the haze of the 
past ~15 years of code changes. All this has built up to a kind of Fear, 
Uncertainty and Doubt about the BKL: nobody really knows it, nobody 
really dares to touch it and code can break silently and subtly if BKL 
locking is wrong.

So with these current rules of the game we cannot realistically fix this 
amount of BKL code in the kernel. People wont just be able to change 
1300 very difficult and fragile legacy codepaths in the kernel 
overnight, just to improve the latencies of the kernel.

So ... because i find a 10+ year wait rather unacceptable, here is a 
different attempt: lets try and change the rules of the game :-)

The technical goal is to make BKL removal much more easy and much more 
natural - to make the BKL more visible and to remove its FUD component.

To achieve those goals i've created and uploaded the "kill-the-BKL" 
prototype branch to the -tip tree, which branch consists of 19 various 
commits at the moment:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git kill-the-BKL

This branch (against latest -git) implements the biggest (and by far 
most critical) core kernel changes towards fast BKL elimination:

 - it fixes all "the BKL auto-releases on schedule()" assumptions i 
   could trigger on my testboxes.

 - it adds a handful of debug facilities to warn about common BKL 
   assumptions that are not valid anymore under the new locking model

 - it turns the BKL into an ordinary mutex and removes all 
   "auto-release" BKL legacy code from the scheduler.

 - it thus adds lockdep support to the BKL

 - it activates the BKL on UP && !PREEMPT too - this makes the code 
   simpler and more universal and hopefully activates more people to get 
   rid of the BKL.

 - makes BKL sections again preemptible

 - ... simplifies the BKL code greatly, and moves it out of the core 
   kernel

In other words: the kill-the-BKL tree turns the BKL into an ordinary 
albeit somewhat big mutex, with a quirky lock/unlock interface called 
"lock_kernel()" and "unlock_kernel()".

Certainly the most interesting commit to check is aa3187000:

   "remove the BKL: remove it from the core kernel!".

Once this tree stabilizes, elimination of the BKL can be done the usual 
and well-known way of eliminating big locks: by pushing it down into 
subsystems and replacing it with subsystem locks, and splitting those 
locks and eliminating them. We've done this countless times in the past 
and there are lots of capable developers who can attack such problems.

In the future we might also want to try to eliminate the self-recursion 
(nested locking) feature of the BKL - this would make BKL code even more 
apparent.

Shortlog, diffstat and patches can be found below. I've build and boot 
tested it on 32-bit and 64-bit x86.

NOTE: the code is highly experimental - it is recommended to try this 
with PROVE_LOCKING and SOFTLOCKUP_DEBUG enabled. If you trigger a 
lockdep warning and a softlockup warning, please report it.

Linus, Alan: the increased visibility and debuggability of the BKL 
already uncovered a rather serious regression in upstream -git. You 
might want to cherry pick this single fix, it will apply just fine to 
current -git:

| commit d70785165e2ef13df53d7b365013aaf9c8b4444d
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Wed May 14 17:11:46 2008 +0200
|
|     tty: fix BKL related leak and crash

This bug might explain a so far undebugged atomic-scheduling crash i saw 
in overnight randconfig boot testing. I tried to keep the fix minimal 
and safe. (although it might make sense to refactor the opost() code to 
have a single exit site in the future)

Bugreports, comments and any other feedback is more than welcome,

	Ingo

------------>
Ingo Molnar (19):
      revert ("BKL: revert back to the old spinlock implementation")
      remove the BKL: change get_fs_type() BKL dependency
      remove the BKL: reduce BKL locking during bootup
      remove the BKL: restruct ->bd_mutex and BKL dependency
      remove the BKL: change ext3 BKL assumption
      remove the BKL: reduce misc_open() BKL dependency
      remove the BKL: remove "BKL auto-drop" assumption from vt_waitactive()
      remove the BKL: remove it from the core kernel!
      softlockup helper: print BKL owner
      remove the BKL: flush_workqueue() debug helper & fix
      remove the BKL: tty updates
      remove the BKL: lockdep self-test fix
      remove the BKL: request_module() debug helper
      remove the BKL: procfs debug helper and BKL elimination
      remove the BKL: do not take the BKL in init code
      remove the BKL: restructure NFS code
      tty: fix BKL related leak and crash
      remove the BKL: fix UP build
      remove the BKL: use the BKL mutex on !SMP too

 arch/mn10300/Kconfig     |   11 ++++
 drivers/char/misc.c      |    8 +++
 drivers/char/n_tty.c     |   13 +++-
 drivers/char/tty_io.c    |   14 ++++-
 drivers/char/vt_ioctl.c  |    8 +++
 fs/block_dev.c           |    4 +-
 fs/ext3/super.c          |    4 -
 fs/filesystems.c         |   12 ++++
 fs/proc/generic.c        |   12 ++--
 fs/proc/inode.c          |    3 -
 fs/proc/root.c           |    9 +--
 include/linux/hardirq.h  |   18 +++---
 include/linux/smp_lock.h |   36 ++---------
 init/Kconfig             |    5 --
 init/main.c              |    7 +-
 kernel/fork.c            |    4 +
 kernel/kmod.c            |   22 +++++++
 kernel/sched.c           |   16 +-----
 kernel/softlockup.c      |    3 +
 kernel/workqueue.c       |   13 ++++
 lib/Makefile             |    4 +-
 lib/kernel_lock.c        |  142 +++++++++++++---------------------------------
 net/sunrpc/sched.c       |    6 ++
 23 files changed, 180 insertions(+), 194 deletions(-)

commit aa3187000a86db1faaa7fb5069b1422046c6d265
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 18:14:51 2008 +0200

    remove the BKL: use the BKL mutex on !SMP too
    
    we need as much help with removing the BKL as we can: use the BKL
    mutex on UP && !PREEMPT too.
    
    This simplifies the code, gets us lockdep reports, animates UP
    developers to get rid of this overhead, etc., etc.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index c5269fe..48b92dd 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -2,9 +2,7 @@
 #define __LINUX_SMPLOCK_H
 
 #include <linux/compiler.h>
-
-#ifdef CONFIG_LOCK_KERNEL
-# include <linux/sched.h>
+#include <linux/sched.h>
 
 extern void __lockfunc lock_kernel(void)	__acquires(kernel_lock);
 extern void __lockfunc unlock_kernel(void)	__releases(kernel_lock);
@@ -16,10 +14,4 @@ static inline int kernel_locked(void)
 
 extern void debug_print_bkl(void);
 
-#else
-static inline void lock_kernel(void)		__acquires(kernel_lock) { }
-static inline void unlock_kernel(void)		__releases(kernel_lock) { }
-static inline int  kernel_locked(void)		{ return 1; }
-static inline void debug_print_bkl(void)	{ }
-#endif
 #endif
diff --git a/init/Kconfig b/init/Kconfig
index 6135d07..7527c6e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -56,11 +56,6 @@ config BROKEN_ON_SMP
 	depends on BROKEN || !SMP
 	default y
 
-config LOCK_KERNEL
-	bool
-	depends on SMP || PREEMPT
-	default y
-
 config INIT_ENV_ARG_LIMIT
 	int
 	default 32 if !UML
diff --git a/lib/Makefile b/lib/Makefile
index 74b0cfb..d1c81fa 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -14,7 +14,8 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o
+	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
+	 kernel_lock.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
@@ -32,7 +33,6 @@ lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
 lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
 obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
-obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
 obj-$(CONFIG_PLIST) += plist.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o

commit d46328b4f115a24d0745d47e3c79657289f5b297
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 18:12:09 2008 +0200

    remove the BKL: fix UP build
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index c318a60..c5269fe 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_SMPLOCK_H
 #define __LINUX_SMPLOCK_H
 
+#include <linux/compiler.h>
+
 #ifdef CONFIG_LOCK_KERNEL
 # include <linux/sched.h>
 
@@ -15,9 +17,9 @@ static inline int kernel_locked(void)
 extern void debug_print_bkl(void);
 
 #else
-static inline lock_kernel(void)			__acquires(kernel_lock) { }
+static inline void lock_kernel(void)		__acquires(kernel_lock) { }
 static inline void unlock_kernel(void)		__releases(kernel_lock) { }
-static inline int kernel_locked(void)		{ return 1; }
+static inline int  kernel_locked(void)		{ return 1; }
 static inline void debug_print_bkl(void)	{ }
 #endif
 #endif

commit d70785165e2ef13df53d7b365013aaf9c8b4444d
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 17:11:46 2008 +0200

    tty: fix BKL related leak and crash
    
    enabling the BKL to be lockdep tracked uncovered the following
    upstream kernel bug in the tty code, which caused a BKL
    reference leak:
    
      ================================================
      [ BUG: lock held when returning to user space! ]
      ------------------------------------------------
      dmesg/3121 is leaving the kernel with locks still held!
      1 lock held by dmesg/3121:
       #0:  (kernel_mutex){--..}, at: [<c02f34d9>] opost+0x24/0x194
    
    this might explain some of the atomicity warnings and crashes
    that -tip tree testing has been experiencing since the BKL
    was converted back to a spinlock.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 19105ec..8096389 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -282,16 +282,20 @@ static int opost(unsigned char c, struct tty_struct *tty)
 			if (O_ONLRET(tty))
 				tty->column = 0;
 			if (O_ONLCR(tty)) {
-				if (space < 2)
+				if (space < 2) {
+					unlock_kernel();
 					return -1;
+				}
 				tty_put_char(tty, '\r');
 				tty->column = 0;
 			}
 			tty->canon_column = tty->column;
 			break;
 		case '\r':
-			if (O_ONOCR(tty) && tty->column == 0)
+			if (O_ONOCR(tty) && tty->column == 0) {
+				unlock_kernel();
 				return 0;
+			}
 			if (O_OCRNL(tty)) {
 				c = '\n';
 				if (O_ONLRET(tty))
@@ -303,10 +307,13 @@ static int opost(unsigned char c, struct tty_struct *tty)
 		case '\t':
 			spaces = 8 - (tty->column & 7);
 			if (O_TABDLY(tty) == XTABS) {
-				if (space < spaces)
+				if (space < spaces) {
+					unlock_kernel();
 					return -1;
+				}
 				tty->column += spaces;
 				tty->ops->write(tty, "        ", spaces);
+				unlock_kernel();
 				return 0;
 			}
 			tty->column += spaces;

commit 352e0d25def53e6b36234e4dc2083ca7f5d712a9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 17:31:41 2008 +0200

    remove the BKL: restructure NFS code
    
    the naked schedule() in rpc_wait_bit_killable() caused the BKL to
    be auto-dropped in the past.
    
    avoid the immediate hang in such code. Note that this still leaves
    some other locking dependencies to be sorted out in the NFS code.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 6eab9bf..e12e571 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -224,9 +224,15 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
 
 static int rpc_wait_bit_killable(void *word)
 {
+	int bkl = kernel_locked();
+
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
+	if (bkl)
+		unlock_kernel();
 	schedule();
+	if (bkl)
+		lock_kernel();
 	return 0;
 }
 

commit 89c25297465376321cf54438d86441a5947bbd11
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 15:10:37 2008 +0200

    remove the BKL: do not take the BKL in init code
    
    this doesnt want to run under the BKL:
    
    ------------[ cut here ]------------
    WARNING: at fs/proc/generic.c:669 create_proc_entry+0x33/0xb9()
    Modules linked in:
    Pid: 0, comm: swapper Not tainted 2.6.26-rc2-sched-devel.git #475
     [<c013d2ed>] warn_on_slowpath+0x41/0x6d
     [<c0158530>] ? mark_held_locks+0x4e/0x66
     [<c01586e7>] ? trace_hardirqs_on+0xb/0xd
     [<c01586a7>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c01586e7>] ? trace_hardirqs_on+0xb/0xd
     [<c0158530>] ? mark_held_locks+0x4e/0x66
     [<c01586e7>] ? trace_hardirqs_on+0xb/0xd
     [<c01586a7>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c01586e7>] ? trace_hardirqs_on+0xb/0xd
     [<c017870f>] ? free_hot_cold_page+0x178/0x1b1
     [<c0178787>] ? free_hot_page+0xa/0xc
     [<c01787ae>] ? __free_pages+0x25/0x30
     [<c01787e2>] ? free_pages+0x29/0x2b
     [<c01c87b2>] create_proc_entry+0x33/0xb9
     [<c01c9de2>] ? loadavg_read_proc+0x0/0xdc
     [<c06f22f8>] proc_misc_init+0x1c/0x25e
     [<c06f2226>] proc_root_init+0x4a/0x97
     [<c06db853>] start_kernel+0x2c4/0x2ec
     [<c06db008>] __init_begin+0x8/0xa
    
    early init code. perhaps safe. needs more tea ...
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/init/main.c b/init/main.c
index c97d36c..e293de0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -668,6 +668,7 @@ asmlinkage void __init start_kernel(void)
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();
+	unlock_kernel();
 #ifdef CONFIG_PROC_FS
 	proc_root_init();
 #endif
@@ -677,7 +678,6 @@ asmlinkage void __init start_kernel(void)
 	delayacct_init();
 
 	check_bugs();
-	unlock_kernel();
 
 	acpi_early_init(); /* before LAPIC and SMP init */
 

commit 5fff2843de609b77d4590e87de5c976b8ac1aacd
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 14:30:33 2008 +0200

    remove the BKL: procfs debug helper and BKL elimination
    
    Add checks for the BKL in create_proc_entry() and proc_create_data().
    
    The functions, if called from the BKL, show that the calling site
    might have a dependency on the procfs code previously using the BKL
    in the dir-entry manipulation functions.
    
    With these warnings in place it is safe to remove the dir-entry BKL
    locking from fs/procfs/.
    
    This untangles the following BKL dependency:
    
    ------------->
    =======================================================
    [ INFO: possible circular locking dependency detected ]
    2.6.26-rc2-sched-devel.git #468
    -------------------------------------------------------
    mount/679 is trying to acquire lock:
     (&type->i_mutex_dir_key#3){--..}, at: [<c019a111>] do_lookup+0x72/0x146
    
    but task is already holding lock:
     (kernel_mutex){--..}, at: [<c04ae4c3>] lock_kernel+0x1e/0x25
    
    which lock already depends on the new lock.
    
    the existing dependency chain (in reverse order) is:
    
    -> #1 (kernel_mutex){--..}:
           [<c01593e9>] __lock_acquire+0x97d/0xae6
           [<c01598be>] lock_acquire+0x4e/0x6c
           [<c04acd18>] mutex_lock_nested+0xc2/0x22a
           [<c04ae4c3>] lock_kernel+0x1e/0x25
           [<c01c84e1>] proc_lookup_de+0x15/0xbf
           [<c01c8818>] proc_lookup+0x12/0x16
           [<c01c4dc4>] proc_root_lookup+0x11/0x2b
           [<c019a148>] do_lookup+0xa9/0x146
           [<c019bd64>] __link_path_walk+0x77a/0xb7a
           [<c019c1b0>] path_walk+0x4c/0x9b
           [<c019c4b9>] do_path_lookup+0x134/0x19a
           [<c019ce95>] __path_lookup_intent_open+0x42/0x74
           [<c019cf20>] path_lookup_open+0x10/0x12
           [<c019d184>] do_filp_open+0x9d/0x695
           [<c0192061>] do_sys_open+0x40/0xb6
           [<c0192119>] sys_open+0x1e/0x26
           [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
           [<ffffffff>] 0xffffffff
    
    -> #0 (&type->i_mutex_dir_key#3){--..}:
           [<c0159310>] __lock_acquire+0x8a4/0xae6
           [<c01598be>] lock_acquire+0x4e/0x6c
           [<c04acd18>] mutex_lock_nested+0xc2/0x22a
           [<c019a111>] do_lookup+0x72/0x146
           [<c019b8b9>] __link_path_walk+0x2cf/0xb7a
           [<c019c1b0>] path_walk+0x4c/0x9b
           [<c019c4b9>] do_path_lookup+0x134/0x19a
           [<c019cf34>] path_lookup+0x12/0x14
           [<c01a873e>] do_mount+0xe7/0x1b5
           [<c01a8870>] sys_mount+0x64/0x9b
           [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
           [<ffffffff>] 0xffffffff
    
    other info that might help us debug this:
    
    1 lock held by mount/679:
     #0:  (kernel_mutex){--..}, at: [<c04ae4c3>] lock_kernel+0x1e/0x25
    
    stack backtrace:
    Pid: 679, comm: mount Not tainted 2.6.26-rc2-sched-devel.git #468
     [<c0157adb>] print_circular_bug_tail+0x5b/0x66
     [<c0157f5c>] ? print_circular_bug_header+0xa6/0xb1
     [<c0159310>] __lock_acquire+0x8a4/0xae6
     [<c01598be>] lock_acquire+0x4e/0x6c
     [<c019a111>] ? do_lookup+0x72/0x146
     [<c04acd18>] mutex_lock_nested+0xc2/0x22a
     [<c019a111>] ? do_lookup+0x72/0x146
     [<c019a111>] ? do_lookup+0x72/0x146
     [<c019a111>] do_lookup+0x72/0x146
     [<c019b8b9>] __link_path_walk+0x2cf/0xb7a
     [<c019c1b0>] path_walk+0x4c/0x9b
     [<c019c4b9>] do_path_lookup+0x134/0x19a
     [<c019cf34>] path_lookup+0x12/0x14
     [<c01a873e>] do_mount+0xe7/0x1b5
     [<c01586cb>] ? trace_hardirqs_on+0xb/0xd
     [<c015868b>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c04ace78>] ? mutex_lock_nested+0x222/0x22a
     [<c04ae4c3>] ? lock_kernel+0x1e/0x25
     [<c01a8870>] sys_mount+0x64/0x9b
     [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
     =======================
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 43e54e8..6f68278 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -381,7 +381,6 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 	struct inode *inode = NULL;
 	int error = -ENOENT;
 
-	lock_kernel();
 	spin_lock(&proc_subdir_lock);
 	for (de = de->subdir; de ; de = de->next) {
 		if (de->namelen != dentry->d_name.len)
@@ -399,7 +398,6 @@ struct dentry *proc_lookup_de(struct proc_dir_entry *de, struct inode *dir,
 	}
 	spin_unlock(&proc_subdir_lock);
 out_unlock:
-	unlock_kernel();
 
 	if (inode) {
 		dentry->d_op = &proc_dentry_operations;
@@ -434,8 +432,6 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret = 0;
 
-	lock_kernel();
-
 	ino = inode->i_ino;
 	i = filp->f_pos;
 	switch (i) {
@@ -489,8 +485,8 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
 			spin_unlock(&proc_subdir_lock);
 	}
 	ret = 1;
-out:	unlock_kernel();
-	return ret;	
+out:
+	return ret;
 }
 
 int proc_readdir(struct file *filp, void *dirent, filldir_t filldir)
@@ -670,6 +666,8 @@ struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 	struct proc_dir_entry *ent;
 	nlink_t nlink;
 
+	WARN_ON_ONCE(kernel_locked());
+
 	if (S_ISDIR(mode)) {
 		if ((mode & S_IALLUGO) == 0)
 			mode |= S_IRUGO | S_IXUGO;
@@ -700,6 +698,8 @@ struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
 	struct proc_dir_entry *pde;
 	nlink_t nlink;
 
+	WARN_ON_ONCE(kernel_locked());
+
 	if (S_ISDIR(mode)) {
 		if ((mode & S_IALLUGO) == 0)
 			mode |= S_IRUGO | S_IXUGO;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 6f4e8dc..2f1ed52 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -34,16 +34,13 @@ struct proc_dir_entry *de_get(struct proc_dir_entry *de)
  */
 void de_put(struct proc_dir_entry *de)
 {
-	lock_kernel();
 	if (!atomic_read(&de->count)) {
 		printk("de_put: entry %s already free!\n", de->name);
-		unlock_kernel();
 		return;
 	}
 
 	if (atomic_dec_and_test(&de->count))
 		free_proc_entry(de);
-	unlock_kernel();
 }
 
 /*
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 9511753..c48c76a 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -162,17 +162,14 @@ static int proc_root_readdir(struct file * filp,
 	unsigned int nr = filp->f_pos;
 	int ret;
 
-	lock_kernel();
-
 	if (nr < FIRST_PROCESS_ENTRY) {
 		int error = proc_readdir(filp, dirent, filldir);
-		if (error <= 0) {
-			unlock_kernel();
+
+		if (error <= 0)
 			return error;
-		}
+
 		filp->f_pos = FIRST_PROCESS_ENTRY;
 	}
-	unlock_kernel();
 
 	ret = proc_pid_readdir(filp, dirent, filldir);
 	return ret;

commit b07e615cf0f731d53a3ab431f44b1fe6ef4576e6
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 14:19:52 2008 +0200

    remove the BKL: request_module() debug helper
    
    usermodehelper blocks waiting for modprobe. We cannot do that with
    the BKL held. Also emit a (one time) warning about callsites that
    do this.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 8df97d3..6c42cdf 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -36,6 +36,8 @@
 #include <linux/resource.h>
 #include <linux/notifier.h>
 #include <linux/suspend.h>
+#include <linux/smp_lock.h>
+
 #include <asm/uaccess.h>
 
 extern int max_threads;
@@ -77,6 +79,7 @@ int request_module(const char *fmt, ...)
 	static atomic_t kmod_concurrent = ATOMIC_INIT(0);
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
+	int bkl = kernel_locked();
 
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
@@ -108,8 +111,27 @@ int request_module(const char *fmt, ...)
 		return -ENOMEM;
 	}
 
+	/*
+	 * usermodehelper blocks waiting for modprobe. We cannot
+	 * do that with the BKL held. Also emit a (one time)
+	 * warning about callsites that do this:
+	 */
+	if (bkl) {
+		if (debug_locks) {
+			WARN_ON_ONCE(1);
+			debug_show_held_locks(current);
+			debug_locks_off();
+		}
+		unlock_kernel();
+	}
+
 	ret = call_usermodehelper(modprobe_path, argv, envp, 1);
+
 	atomic_dec(&kmod_concurrent);
+
+	if (bkl)
+		lock_kernel();
+
 	return ret;
 }
 EXPORT_SYMBOL(request_module);

commit b1f6383484b0ad7b57e451ea638ec774204a7ced
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 13:51:40 2008 +0200

    remove the BKL: lockdep self-test fix
    
    the lockdep self-tests reinitialize the held locks context, so
    make sure we call it with no lock held. Move the first lock_kernel()
    later into the bootup - we are still the only task around so there's
    no serialization issues.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/init/main.c b/init/main.c
index 8d3b879..c97d36c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -554,7 +554,6 @@ asmlinkage void __init start_kernel(void)
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
-	lock_kernel();
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
@@ -626,6 +625,8 @@ asmlinkage void __init start_kernel(void)
 	 */
 	locking_selftest();
 
+	lock_kernel();
+
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
 			initrd_start < min_low_pfn << PAGE_SHIFT) {

commit d31eec64e76a4b0795b5a6b57f2925d57aeefda5
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 13:47:58 2008 +0200

    remove the BKL: tty updates
    
    untangle the following workqueue <-> BKL dependency in the TTY code:
    
    =======================================================
    [ INFO: possible circular locking dependency detected ]
    2.6.26-rc2-sched-devel.git #461
    -------------------------------------------------------
    events/1/11 is trying to acquire lock:
     (kernel_mutex){--..}, at: [<c0485203>] lock_kernel+0x1e/0x25
    
    but task is already holding lock:
     (&(&tty->buf.work)->work){--..}, at: [<c014a83d>] run_workqueue+0x80/0x18b
    
    which lock already depends on the new lock.
    
    the existing dependency chain (in reverse order) is:
    
    -> #2 (&(&tty->buf.work)->work){--..}:
           [<c0159345>] __lock_acquire+0x97d/0xae6
           [<c015981a>] lock_acquire+0x4e/0x6c
           [<c014a873>] run_workqueue+0xb6/0x18b
           [<c014b1b7>] worker_thread+0xb6/0xc2
           [<c014d4f4>] kthread+0x3b/0x63
           [<c011a737>] kernel_thread_helper+0x7/0x10
           [<ffffffff>] 0xffffffff
    
    -> #1 (events){--..}:
           [<c0159345>] __lock_acquire+0x97d/0xae6
           [<c015981a>] lock_acquire+0x4e/0x6c
           [<c014aec2>] flush_workqueue+0x3f/0x7c
           [<c014af0c>] flush_scheduled_work+0xd/0xf
           [<c0285a59>] release_dev+0x42c/0x54a
           [<c0285b89>] tty_release+0x12/0x1c
           [<c01945b8>] __fput+0xae/0x155
           [<c01948e8>] fput+0x17/0x19
           [<c0191ea6>] filp_close+0x50/0x5a
           [<c01930c2>] sys_close+0x71/0xad
           [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
           [<ffffffff>] 0xffffffff
    
    -> #0 (kernel_mutex){--..}:
           [<c015926c>] __lock_acquire+0x8a4/0xae6
           [<c015981a>] lock_acquire+0x4e/0x6c
           [<c0483a58>] mutex_lock_nested+0xc2/0x22a
           [<c0485203>] lock_kernel+0x1e/0x25
           [<c02872a9>] opost+0x24/0x194
           [<c02884a2>] n_tty_receive_buf+0xb1b/0xfaa
           [<c0283df2>] flush_to_ldisc+0xd9/0x148
           [<c014a878>] run_workqueue+0xbb/0x18b
           [<c014b1b7>] worker_thread+0xb6/0xc2
           [<c014d4f4>] kthread+0x3b/0x63
           [<c011a737>] kernel_thread_helper+0x7/0x10
           [<ffffffff>] 0xffffffff
    
    other info that might help us debug this:
    
    2 locks held by events/1/11:
     #0:  (events){--..}, at: [<c014a83d>] run_workqueue+0x80/0x18b
     #1:  (&(&tty->buf.work)->work){--..}, at: [<c014a83d>] run_workqueue+0x80/0x18b
    
    stack backtrace:
    Pid: 11, comm: events/1 Not tainted 2.6.26-rc2-sched-devel.git #461
     [<c0157a37>] print_circular_bug_tail+0x5b/0x66
     [<c015737f>] ? print_circular_bug_entry+0x39/0x43
     [<c015926c>] __lock_acquire+0x8a4/0xae6
     [<c015981a>] lock_acquire+0x4e/0x6c
     [<c0485203>] ? lock_kernel+0x1e/0x25
     [<c0483a58>] mutex_lock_nested+0xc2/0x22a
     [<c0485203>] ? lock_kernel+0x1e/0x25
     [<c0485203>] ? lock_kernel+0x1e/0x25
     [<c0485203>] lock_kernel+0x1e/0x25
     [<c02872a9>] opost+0x24/0x194
     [<c02884a2>] n_tty_receive_buf+0xb1b/0xfaa
     [<c0133bf5>] ? find_busiest_group+0x1db/0x5a0
     [<c0158470>] ? mark_held_locks+0x4e/0x66
     [<c0158470>] ? mark_held_locks+0x4e/0x66
     [<c0158627>] ? trace_hardirqs_on+0xb/0xd
     [<c01585e7>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c0158627>] ? trace_hardirqs_on+0xb/0xd
     [<c0283df2>] flush_to_ldisc+0xd9/0x148
     [<c014a878>] run_workqueue+0xbb/0x18b
     [<c014a83d>] ? run_workqueue+0x80/0x18b
     [<c0283d19>] ? flush_to_ldisc+0x0/0x148
     [<c014b1b7>] worker_thread+0xb6/0xc2
     [<c014d5b5>] ? autoremove_wake_function+0x0/0x30
     [<c014b101>] ? worker_thread+0x0/0xc2
     [<c014d4f4>] kthread+0x3b/0x63
     [<c014d4b9>] ? kthread+0x0/0x63
     [<c011a737>] kernel_thread_helper+0x7/0x10
     =======================
    kjournald starting.  Commit interval 5 seconds
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 49c1a22..b044576 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2590,9 +2590,19 @@ static void release_dev(struct file *filp)
 
 	/*
 	 * Wait for ->hangup_work and ->buf.work handlers to terminate
+	 *
+	 * It's safe to drop/reacquire the BKL here as
+	 * flush_scheduled_work() can sleep anyway:
 	 */
-
-	flush_scheduled_work();
+	{
+		int bkl = kernel_locked();
+
+		if (bkl)
+			unlock_kernel();
+		flush_scheduled_work();
+		if (bkl)
+			lock_kernel();
+	}
 
 	/*
 	 * Wait for any short term users (we know they are just driver

commit afb99e5a939d4eff43ede3155bc8a7563c10f748
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 13:35:33 2008 +0200

    remove the BKL: flush_workqueue() debug helper & fix
    
    workqueue execution can introduce nasty BKL inversion dependencies,
    root them out at their source by warning about them. Avoid hangs
    by unlocking the BKL and warning about the incident. (this is safe
    as this function will sleep anyway)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 29fc39f..ce0cb10 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -392,13 +392,26 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 void flush_workqueue(struct workqueue_struct *wq)
 {
 	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	int bkl = kernel_locked();
 	int cpu;
 
 	might_sleep();
+	if (bkl) {
+		if (debug_locks) {
+			WARN_ON_ONCE(1);
+			debug_show_held_locks(current);
+			debug_locks_off();
+		}
+		unlock_kernel();
+	}
+
 	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+
+	if (bkl)
+		lock_kernel();
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 

commit d7f03183eb55be792b3bcf255d2a9aec1c17b5df
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 13:03:11 2008 +0200

    softlockup helper: print BKL owner
    
    on softlockup, print who owns the BKL lock.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 36e23b8..c318a60 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -11,9 +11,13 @@ static inline int kernel_locked(void)
 {
 	return current->lock_depth >= 0;
 }
+
+extern void debug_print_bkl(void);
+
 #else
 static inline lock_kernel(void)			__acquires(kernel_lock) { }
 static inline void unlock_kernel(void)		__releases(kernel_lock) { }
 static inline int kernel_locked(void)		{ return 1; }
+static inline void debug_print_bkl(void)	{ }
 #endif
 #endif
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 01b6522..46080ca 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -15,6 +15,7 @@
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/smp_lock.h>
 
 #include <asm/irq_regs.h>
 
@@ -170,6 +171,8 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
 	sched_show_task(t);
 	__debug_show_held_locks(t);
 
+	debug_print_bkl();
+
 	t->last_switch_timestamp = now;
 	touch_nmi_watchdog();
 }
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 41718ce..ca03ae8 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -53,6 +53,17 @@ void __lockfunc unlock_kernel(void)
 		mutex_unlock(&kernel_mutex);
 }
 
+void debug_print_bkl(void)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	if (mutex_is_locked(&kernel_mutex)) {
+		printk(KERN_EMERG "BUG: **** BKL held by: %d:%s\n",
+			kernel_mutex.owner->task->pid,
+			kernel_mutex.owner->task->comm);
+	}
+#endif
+}
+
 EXPORT_SYMBOL(lock_kernel);
 EXPORT_SYMBOL(unlock_kernel);
 

commit 7a6e0ca35dc9bd458f331d2950fb6c875e432f18
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 09:55:53 2008 +0200

    remove the BKL: remove it from the core kernel!
    
    remove the classic Big Kernel Lock from the core kernel.
    
    this means it does not get auto-dropped anymore. Code which relies
    on this has to be fixed.
    
    the resulting lock_kernel() code is a plain mutex with a thin
    self-recursion layer ontop of it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index aab3a4c..36e23b8 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -2,38 +2,18 @@
 #define __LINUX_SMPLOCK_H
 
 #ifdef CONFIG_LOCK_KERNEL
-#include <linux/sched.h>
-
-#define kernel_locked()		(current->lock_depth >= 0)
-
-extern int __lockfunc __reacquire_kernel_lock(void);
-extern void __lockfunc __release_kernel_lock(void);
-
-/*
- * Release/re-acquire global kernel lock for the scheduler
- */
-#define release_kernel_lock(tsk) do { 		\
-	if (unlikely((tsk)->lock_depth >= 0))	\
-		__release_kernel_lock();	\
-} while (0)
-
-static inline int reacquire_kernel_lock(struct task_struct *task)
-{
-	if (unlikely(task->lock_depth >= 0))
-		return __reacquire_kernel_lock();
-	return 0;
-}
+# include <linux/sched.h>
 
 extern void __lockfunc lock_kernel(void)	__acquires(kernel_lock);
 extern void __lockfunc unlock_kernel(void)	__releases(kernel_lock);
 
+static inline int kernel_locked(void)
+{
+	return current->lock_depth >= 0;
+}
 #else
-
-#define lock_kernel()				do { } while(0)
-#define unlock_kernel()				do { } while(0)
-#define release_kernel_lock(task)		do { } while(0)
-#define reacquire_kernel_lock(task)		0
-#define kernel_locked()				1
-
-#endif /* CONFIG_LOCK_KERNEL */
-#endif /* __LINUX_SMPLOCK_H */
+static inline lock_kernel(void)			__acquires(kernel_lock) { }
+static inline void unlock_kernel(void)		__releases(kernel_lock) { }
+static inline int kernel_locked(void)		{ return 1; }
+#endif
+#endif
diff --git a/kernel/fork.c b/kernel/fork.c
index 933e60e..34bcb04 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -54,6 +54,7 @@
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1010,6 +1011,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	struct task_struct *p;
 	int cgroup_callbacks_done = 0;
 
+	if (system_state == SYSTEM_RUNNING && kernel_locked())
+		debug_check_no_locks_held(current);
+
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 59d20a5..c6d1f26 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4494,9 +4494,6 @@ need_resched:
 	prev = rq->curr;
 	switch_count = &prev->nivcsw;
 
-	release_kernel_lock(prev);
-need_resched_nonpreemptible:
-
 	schedule_debug(prev);
 
 	hrtick_clear(rq);
@@ -4549,9 +4546,6 @@ need_resched_nonpreemptible:
 
 	hrtick_set(rq);
 
-	if (unlikely(reacquire_kernel_lock(current) < 0))
-		goto need_resched_nonpreemptible;
-
 	preempt_enable_no_resched();
 	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
 		goto need_resched;
@@ -4567,8 +4561,6 @@ EXPORT_SYMBOL(schedule);
 asmlinkage void __sched preempt_schedule(void)
 {
 	struct thread_info *ti = current_thread_info();
-	struct task_struct *task = current;
-	int saved_lock_depth;
 
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
@@ -4579,16 +4571,7 @@ asmlinkage void __sched preempt_schedule(void)
 
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
-
-		/*
-		 * We keep the big kernel semaphore locked, but we
-		 * clear ->lock_depth so that schedule() doesnt
-		 * auto-release the semaphore:
-		 */
-		saved_lock_depth = task->lock_depth;
-		task->lock_depth = -1;
 		schedule();
-		task->lock_depth = saved_lock_depth;
 		sub_preempt_count(PREEMPT_ACTIVE);
 
 		/*
@@ -4609,26 +4592,15 @@ EXPORT_SYMBOL(preempt_schedule);
 asmlinkage void __sched preempt_schedule_irq(void)
 {
 	struct thread_info *ti = current_thread_info();
-	struct task_struct *task = current;
-	int saved_lock_depth;
 
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
-
-		/*
-		 * We keep the big kernel semaphore locked, but we
-		 * clear ->lock_depth so that schedule() doesnt
-		 * auto-release the semaphore:
-		 */
-		saved_lock_depth = task->lock_depth;
-		task->lock_depth = -1;
 		local_irq_enable();
 		schedule();
 		local_irq_disable();
-		task->lock_depth = saved_lock_depth;
 		sub_preempt_count(PREEMPT_ACTIVE);
 
 		/*
@@ -5535,11 +5507,6 @@ static void __cond_resched(void)
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
 	__might_sleep(__FILE__, __LINE__);
 #endif
-	/*
-	 * The BKS might be reacquired before we have dropped
-	 * PREEMPT_ACTIVE, which could trigger a second
-	 * cond_resched() call.
-	 */
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		schedule();
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index cd3e825..41718ce 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -1,66 +1,32 @@
 /*
- * lib/kernel_lock.c
+ * This is the Big Kernel Lock - the traditional lock that we
+ * inherited from the uniprocessor Linux kernel a decade ago.
  *
- * This is the traditional BKL - big kernel lock. Largely
- * relegated to obsolescence, but used by various less
+ * Largely relegated to obsolescence, but used by various less
  * important (or lazy) subsystems.
- */
-#include <linux/smp_lock.h>
-#include <linux/module.h>
-#include <linux/kallsyms.h>
-#include <linux/semaphore.h>
-
-/*
- * The 'big kernel semaphore'
- *
- * This mutex is taken and released recursively by lock_kernel()
- * and unlock_kernel().  It is transparently dropped and reacquired
- * over schedule().  It is used to protect legacy code that hasn't
- * been migrated to a proper locking design yet.
- *
- * Note: code locked by this semaphore will only be serialized against
- * other code using the same locking facility. The code guarantees that
- * the task remains on the same CPU.
  *
  * Don't use in new code.
- */
-static DECLARE_MUTEX(kernel_sem);
-
-/*
- * Re-acquire the kernel semaphore.
  *
- * This function is called with preemption off.
+ * It now has plain mutex semantics (i.e. no auto-drop on
+ * schedule() anymore), combined with a very simple self-recursion
+ * layer that allows the traditional nested use:
+ *
+ *   lock_kernel();
+ *     lock_kernel();
+ *     unlock_kernel();
+ *   unlock_kernel();
  *
- * We are executing in schedule() so the code must be extremely careful
- * about recursion, both due to the down() and due to the enabling of
- * preemption. schedule() will re-check the preemption flag after
- * reacquiring the semaphore.
+ * Please migrate all BKL using code to a plain mutex.
  */
-int __lockfunc __reacquire_kernel_lock(void)
-{
-	struct task_struct *task = current;
-	int saved_lock_depth = task->lock_depth;
-
-	BUG_ON(saved_lock_depth < 0);
-
-	task->lock_depth = -1;
-	preempt_enable_no_resched();
-
-	down(&kernel_sem);
-
-	preempt_disable();
-	task->lock_depth = saved_lock_depth;
-
-	return 0;
-}
+#include <linux/smp_lock.h>
+#include <linux/kallsyms.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 
-void __lockfunc __release_kernel_lock(void)
-{
-	up(&kernel_sem);
-}
+static DEFINE_MUTEX(kernel_mutex);
 
 /*
- * Getting the big kernel semaphore.
+ * Get the big kernel lock:
  */
 void __lockfunc lock_kernel(void)
 {
@@ -71,7 +37,7 @@ void __lockfunc lock_kernel(void)
 		/*
 		 * No recursion worries - we set up lock_depth _after_
 		 */
-		down(&kernel_sem);
+		mutex_lock(&kernel_mutex);
 
 	task->lock_depth = depth;
 }
@@ -80,10 +46,11 @@ void __lockfunc unlock_kernel(void)
 {
 	struct task_struct *task = current;
 
-	BUG_ON(task->lock_depth < 0);
+	if (WARN_ON_ONCE(task->lock_depth < 0))
+		return;
 
 	if (likely(--task->lock_depth < 0))
-		up(&kernel_sem);
+		mutex_unlock(&kernel_mutex);
 }
 
 EXPORT_SYMBOL(lock_kernel);

commit df34bbceea535a6ce4f384a096334feac05d4a33
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 18:40:41 2008 +0200

    remove the BKL: remove "BKL auto-drop" assumption from vt_waitactive()
    
    fix vt_waitactive()'s "schedule() drops the BKL automatically"
    assumption, when schedule() does not do that it can lock up,
    as reported by the softlockup detector:
    
    --------------------->
    console-kit-d D 00000000     0  1866      1
           f5aeeda0 00000046 00000001 00000000 c063d0a4 5f87b6a4 00000009 c06e6900
           c06e6000 f64da358 f64da5c0 c2a12000 00000001 00000040 f5aee000 f6797dc0
           f64da358 00000000 00000000 00000000 00000000 f64da358 c0158627 00000246
    Call Trace:
     [<c0158627>] ? trace_hardirqs_on+0xb/0xd
     [<c01585e7>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c0483a98>] mutex_lock_nested+0x142/0x22a
     [<c04851f9>] ? lock_kernel+0x1e/0x25
     [<c04851f9>] lock_kernel+0x1e/0x25
     [<c028a692>] vt_ioctl+0x25/0x15c7
     [<c013352f>] ? __resched_task+0x5f/0x63
     [<c0157291>] ? trace_hardirqs_off+0xb/0xd
     [<c0485013>] ? _spin_unlock_irqrestore+0x42/0x58
     [<c028a66d>] ? vt_ioctl+0x0/0x15c7
     [<c0286b8c>] tty_ioctl+0xdbb/0xe18
     [<c013014e>] ? kunmap_atomic+0x66/0x7c
     [<c0178c3a>] ? __alloc_pages_internal+0xee/0x3a8
     [<c017e186>] ? __inc_zone_state+0x12/0x5c
     [<c0484f44>] ? _spin_unlock+0x27/0x3c
     [<c0181a01>] ? handle_mm_fault+0x56c/0x587
     [<c0285dd1>] ? tty_ioctl+0x0/0xe18
     [<c019e172>] vfs_ioctl+0x22/0x67
     [<c019e413>] do_vfs_ioctl+0x25c/0x26a
     [<c019e461>] sys_ioctl+0x40/0x5b
     [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
     [<c0110000>] ? kvm_pic_read_irq+0xa3/0xbf
     =======================
    
    console-kit-d S f6eb0380     0  1867      1
           f65a0dc4 00000046 00000000 f6eb0380 f6eb0358 00000000 f65a0d7c c06e6900
           c06e6000 f6eb0358 f6eb05c0 c2a0a000 00000000 00000040 f65a0000 f6797dc0
           f65a0d94 fffc0957 f65a0da4 c0485013 00000003 00000004 ffffffff c013d7d1
    Call Trace:
     [<c0485013>] ? _spin_unlock_irqrestore+0x42/0x58
     [<c013d7d1>] ? release_console_sem+0x192/0x1a5
     [<c028a644>] vt_waitactive+0x70/0x99
     [<c01360a4>] ? default_wake_function+0x0/0xd
     [<c028b5b4>] vt_ioctl+0xf47/0x15c7
     [<c028a66d>] ? vt_ioctl+0x0/0x15c7
     [<c0286b8c>] tty_ioctl+0xdbb/0xe18
     [<c013014e>] ? kunmap_atomic+0x66/0x7c
     [<c0178c3a>] ? __alloc_pages_internal+0xee/0x3a8
     [<c017e186>] ? __inc_zone_state+0x12/0x5c
     [<c0484f44>] ? _spin_unlock+0x27/0x3c
     [<c0181a01>] ? handle_mm_fault+0x56c/0x587
     [<c0285dd1>] ? tty_ioctl+0x0/0xe18
     [<c019e172>] vfs_ioctl+0x22/0x67
     [<c019e413>] do_vfs_ioctl+0x25c/0x26a
     [<c019e461>] sys_ioctl+0x40/0x5b
     [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
     [<c0110000>] ? kvm_pic_read_irq+0xa3/0xbf
     =======================
    
    The fix is the drop the BKL explicitly instead of implicitly.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 3211afd..bab26e1 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1174,8 +1174,12 @@ static DECLARE_WAIT_QUEUE_HEAD(vt_activate_queue);
 int vt_waitactive(int vt)
 {
 	int retval;
+	int bkl = kernel_locked();
 	DECLARE_WAITQUEUE(wait, current);
 
+	if (bkl)
+		unlock_kernel();
+
 	add_wait_queue(&vt_activate_queue, &wait);
 	for (;;) {
 		retval = 0;
@@ -1201,6 +1205,10 @@ int vt_waitactive(int vt)
 	}
 	remove_wait_queue(&vt_activate_queue, &wait);
 	__set_current_state(TASK_RUNNING);
+
+	if (bkl)
+		lock_kernel();
+
 	return retval;
 }
 

commit 3a0bf25bb160233b902962457ce917df27550850
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 11:34:13 2008 +0200

    remove the BKL: reduce misc_open() BKL dependency
    
    fix this BKL dependency problem due to request_module():
    
    ------------------------>
    Write protecting the kernel text: 3620k
    Write protecting the kernel read-only data: 1664k
    INFO: task hwclock:700 blocked for more than 30 seconds.
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    hwclock       D c0629430     0   700    673
           f69b7d08 00000046 00000001 c0629430 00000001 00000046 00000000 c06e6900
           c06e6000 f6ead358 f6ead5c0 c1d1b000 00000001 00000040 f69b7000 f6848dc0
           00000000 fffb92ac f6ead358 f6ead830 00000001 00000000 ffffffff 00000001
    Call Trace:
     [<c048323c>] schedule_timeout+0x16/0x8b
     [<c0158470>] ? mark_held_locks+0x4e/0x66
     [<c0158627>] ? trace_hardirqs_on+0xb/0xd
     [<c01585e7>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c0158627>] ? trace_hardirqs_on+0xb/0xd
     [<c048279c>] wait_for_common+0xc3/0xfc
     [<c01360a4>] ? default_wake_function+0x0/0xd
     [<c0482857>] wait_for_completion+0x12/0x14
     [<c014a42b>] call_usermodehelper_exec+0x7f/0xbf
     [<c014a710>] request_module+0xce/0xe2
     [<c0158470>] ? mark_held_locks+0x4e/0x66
     [<c0158627>] ? trace_hardirqs_on+0xb/0xd
     [<c01585e7>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c028a252>] misc_open+0xc4/0x216
     [<c0195d77>] chrdev_open+0x156/0x172
     [<c01921d9>] __dentry_open+0x147/0x236
     [<c01922e7>] nameidata_to_filp+0x1f/0x33
     [<c0195c21>] ? chrdev_open+0x0/0x172
     [<c019d38a>] do_filp_open+0x347/0x695
     [<c0191f67>] ? get_unused_fd_flags+0xc3/0xcd
     [<c0191fb1>] do_sys_open+0x40/0xb6
     [<c023fe74>] ? trace_hardirqs_on_thunk+0xc/0x10
     [<c0192069>] sys_open+0x1e/0x26
     [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
     =======================
    1 lock held by hwclock/700:
     #0:  (kernel_sem){--..}, at: [<c04851b1>] lock_kernel+0x1e/0x25
    Kernel panic - not syncing: softlockup: blocked tasks
    Pid: 5, comm: watchdog/0 Not tainted 2.6.26-rc2-sched-devel.git #454
     [<c013d1fb>] panic+0x49/0xfa
     [<c016b177>] watchdog+0x168/0x1d1
     [<c016b00f>] ? watchdog+0x0/0x1d1
     [<c014d4f4>] kthread+0x3b/0x63
     [<c014d4b9>] ? kthread+0x0/0x63
     [<c011a737>] kernel_thread_helper+0x7/0x10
     =======================
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index eaace0d..3f2b7be 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 
 #include <linux/fs.h>
+#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
 #include <linux/kernel.h>
@@ -128,8 +129,15 @@ static int misc_open(struct inode * inode, struct file * file)
 	}
 		
 	if (!new_fops) {
+		int bkl = kernel_locked();
+
 		mutex_unlock(&misc_mtx);
+		if (bkl)
+			unlock_kernel();
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
+		if (bkl)
+			lock_kernel();
+
 		mutex_lock(&misc_mtx);
 
 		list_for_each_entry(c, &misc_list, list) {

commit 93ea4ccabef1016e6df217d5756ca5f70e37b39a
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 11:14:48 2008 +0200

    remove the BKL: change ext3 BKL assumption
    
    remove this 'we are holding the BKL' assumption from ext3:
    
    md: Autodetecting RAID arrays.
    md: Scanned 0 and added 0 devices.
    md: autorun ...
    md: ... autorun DONE.
    ------------[ cut here ]------------
    kernel BUG at lib/kernel_lock.c:83!
    invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
    Modules linked in:
    
    Pid: 1, comm: swapper Not tainted (2.6.26-rc2-sched-devel.git #451)
    EIP: 0060:[<c0485106>] EFLAGS: 00010286 CPU: 1
    EIP is at unlock_kernel+0x11/0x28
    EAX: ffffffff EBX: fffffff4 ECX: 00000000 EDX: f7cb3358
    ESI: 00000001 EDI: 00000000 EBP: f7cb4d2c ESP: f7cb4d2c
     DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
    Process swapper (pid: 1, ti=f7cb4000 task=f7cb3358 task.ti=f7cb4000)
    Stack: f7cb4dc4 c01dbc59 c023f686 00000001 00000000 0000000a 00000001 f6901bf0
           00000000 00000020 f7cb4dd8 0000000a f7cb4df8 00000002 f7240000 ffffffff
           c05a9138 f6fc6bfc 00000001 f7cb4dd8 f7cb4d8c c023f737 f7cb4da0 f7cb4da0
    Call Trace:
     [<c01dbc59>] ? ext3_fill_super+0xc8/0x13d6
     [<c023f686>] ? vsnprintf+0x3c3/0x3fc
     [<c023f737>] ? snprintf+0x1b/0x1d
     [<c01cbc37>] ? disk_name+0x5a/0x67
     [<c01958f7>] ? get_sb_bdev+0xcd/0x10b
     [<c0190100>] ? __kmalloc+0x86/0x132
     [<c01a7532>] ? alloc_vfsmnt+0xe3/0x10b
     [<c01a7532>] ? alloc_vfsmnt+0xe3/0x10b
     [<c01da253>] ? ext3_get_sb+0x13/0x15
     [<c01dbb91>] ? ext3_fill_super+0x0/0x13d6
     [<c01954df>] ? vfs_kern_mount+0x81/0xf7
     [<c0195599>] ? do_kern_mount+0x32/0xba
     [<c01a8566>] ? do_new_mount+0x46/0x74
     [<c01a872b>] ? do_mount+0x197/0x1b5
     [<c018ee49>] ? cache_alloc_debugcheck_after+0x6a/0x19c
     [<c0178f48>] ? __get_free_pages+0x1b/0x21
     [<c01a67f4>] ? copy_mount_options+0x27/0x10e
     [<c01a87a8>] ? sys_mount+0x5f/0x91
     [<c06a0a90>] ? mount_block_root+0xa3/0x1e6
     [<c02350af>] ? blk_lookup_devt+0x5e/0x64
     [<c019cc61>] ? sys_mknod+0x13/0x15
     [<c06a0c1f>] ? mount_root+0x4c/0x54
     [<c06a0d72>] ? prepare_namespace+0x14b/0x172
     [<c06a0565>] ? kernel_init+0x217/0x226
     [<c06a034e>] ? kernel_init+0x0/0x226
     [<c06a034e>] ? kernel_init+0x0/0x226
     [<c011a737>] ? kernel_thread_helper+0x7/0x10
     =======================
    Code: 11 21 00 00 89 e0 25 00 f0 ff ff f6 40 08 08 74 05 e8 2b df ff ff 5b 5e 5d c3 55 64 8b 15 80 20 6e c0 8b 42 14 89 e5 85 c0 79 04 <0f> 0b eb fe 48 89 42 14 40 75 0a b8 70 d0 63 c0 e8 c9 e7 ff ff
    EIP: [<c0485106>] unlock_kernel+0x11/0x28 SS:ESP 0068:f7cb4d2c
    Kernel panic - not syncing: Fatal exception
    Pid: 1, comm: swapper Tainted: G      D   2.6.26-rc2-sched-devel.git #451
     [<c013d1fb>] panic+0x49/0xfa
     [<c011ae8f>] die+0x11c/0x143
     [<c0485518>] do_trap+0x8a/0xa3
     [<c011b061>] ? do_invalid_op+0x0/0x76
     [<c011b0cd>] do_invalid_op+0x6c/0x76
     [<c0485106>] ? unlock_kernel+0x11/0x28
     [<c0484edc>] ? _spin_unlock+0x27/0x3c
     [<c012f143>] ? kernel_map_pages+0x108/0x11f
     [<c0485212>] error_code+0x72/0x78
     [<c0485106>] ? unlock_kernel+0x11/0x28
     [<c01dbc59>] ext3_fill_super+0xc8/0x13d6
     [<c023f686>] ? vsnprintf+0x3c3/0x3fc
     [<c023f737>] ? snprintf+0x1b/0x1d
     [<c01cbc37>] ? disk_name+0x5a/0x67
     [<c01958f7>] get_sb_bdev+0xcd/0x10b
     [<c0190100>] ? __kmalloc+0x86/0x132
     [<c01a7532>] ? alloc_vfsmnt+0xe3/0x10b
     [<c01a7532>] ? alloc_vfsmnt+0xe3/0x10b
     [<c01da253>] ext3_get_sb+0x13/0x15
     [<c01dbb91>] ? ext3_fill_super+0x0/0x13d6
     [<c01954df>] vfs_kern_mount+0x81/0xf7
     [<c0195599>] do_kern_mount+0x32/0xba
     [<c01a8566>] do_new_mount+0x46/0x74
     [<c01a872b>] do_mount+0x197/0x1b5
     [<c018ee49>] ? cache_alloc_debugcheck_after+0x6a/0x19c
     [<c0178f48>] ? __get_free_pages+0x1b/0x21
     [<c01a67f4>] ? copy_mount_options+0x27/0x10e
     [<c01a87a8>] sys_mount+0x5f/0x91
     [<c06a0a90>] mount_block_root+0xa3/0x1e6
     [<c02350af>] ? blk_lookup_devt+0x5e/0x64
     [<c019cc61>] ? sys_mknod+0x13/0x15
     [<c06a0c1f>] mount_root+0x4c/0x54
     [<c06a0d72>] prepare_namespace+0x14b/0x172
     [<c06a0565>] kernel_init+0x217/0x226
     [<c06a034e>] ? kernel_init+0x0/0x226
     [<c06a034e>] ? kernel_init+0x0/0x226
     [<c011a737>] kernel_thread_helper+0x7/0x10
     =======================
    Rebooting in 10 seconds..
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fe3119a..c05e7a7 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1522,8 +1522,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_resgid = EXT3_DEF_RESGID;
 	sbi->s_sb_block = sb_block;
 
-	unlock_kernel();
-
 	blocksize = sb_min_blocksize(sb, EXT3_MIN_BLOCK_SIZE);
 	if (!blocksize) {
 		printk(KERN_ERR "EXT3-fs: unable to set blocksize\n");
@@ -1918,7 +1916,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
 
-	lock_kernel();
 	return 0;
 
 cantfind_ext3:
@@ -1947,7 +1944,6 @@ failed_mount:
 out_fail:
 	sb->s_fs_info = NULL;
 	kfree(sbi);
-	lock_kernel();
 	return ret;
 }
 

commit a79fcbacfdd3e7dfdf04a5275e6688d37478360b
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 10:55:14 2008 +0200

    remove the BKL: restruct ->bd_mutex and BKL dependency
    
    fix this bd_mutex <-> BKL lock dependency problem (which was hidden
    until now by the BKL's auto-drop property):
    
    ------------->
    ata2.01: configured for UDMA/33
    scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
    sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
    sd 0:0:0:0: [sda] Write Protect is off
    sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
    sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
    sd 0:0:0:0: [sda] Write Protect is off
    sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
    sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
     sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
    
    =======================================================
    [ INFO: possible circular locking dependency detected ]
    2.6.26-rc2-sched-devel.git #448
    -------------------------------------------------------
    swapper/1 is trying to acquire lock:
     (kernel_sem){--..}, at: [<c04851d1>] lock_kernel+0x1e/0x25
    
    but task is already holding lock:
     (&bdev->bd_mutex){--..}, at: [<c01b4e12>] __blkdev_put+0x24/0x10f
    
    which lock already depends on the new lock.
    
    the existing dependency chain (in reverse order) is:
    
    -> #1 (&bdev->bd_mutex){--..}:
           [<c0159365>] __lock_acquire+0x97d/0xae6
           [<c015983a>] lock_acquire+0x4e/0x6c
           [<c04839f0>] mutex_lock_nested+0xc2/0x22a
           [<c01b5075>] do_open+0x65/0x277
           [<c01b5301>] __blkdev_get+0x7a/0x85
           [<c01b5319>] blkdev_get+0xd/0xf
           [<c01cc04d>] register_disk+0xcf/0x11c
           [<c02351b2>] add_disk+0x2f/0x74
           [<c03264b2>] sd_probe+0x2d2/0x379
           [<c02b5a32>] driver_probe_device+0xa0/0x11b
           [<c02b5b14>] __device_attach+0x8/0xa
           [<c02b5041>] bus_for_each_drv+0x39/0x63
           [<c02b5b86>] device_attach+0x51/0x67
           [<c02b4ec7>] bus_attach_device+0x24/0x4e
           [<c02b41b4>] device_add+0x31e/0x42c
           [<c02f2690>] scsi_sysfs_add_sdev+0x9f/0x1d3
           [<c02f0d08>] scsi_probe_and_add_lun+0x96d/0xa84
           [<c02f1861>] __scsi_add_device+0x85/0xab
           [<c0334dda>] ata_scsi_scan_host+0x99/0x217
           [<c03323c6>] ata_host_register+0x1c8/0x1e5
           [<c0339b71>] ata_pci_sff_activate_host+0x179/0x19f
           [<c0339fab>] ata_pci_sff_init_one+0x97/0xe1
           [<c034c484>] amd_init_one+0x10a/0x113
           [<c024cb8d>] pci_device_probe+0x39/0x59
           [<c02b5a32>] driver_probe_device+0xa0/0x11b
           [<c02b5aea>] __driver_attach+0x3d/0x5f
           [<c02b528b>] bus_for_each_dev+0x3e/0x60
           [<c02b58c9>] driver_attach+0x14/0x16
           [<c02b5622>] bus_add_driver+0x9d/0x1af
           [<c02b5c6a>] driver_register+0x71/0xcd
           [<c024cd4c>] __pci_register_driver+0x40/0x6c
           [<c06bfd10>] amd_init+0x14/0x16
           [<c06a0464>] kernel_init+0x116/0x226
           [<c011a737>] kernel_thread_helper+0x7/0x10
           [<ffffffff>] 0xffffffff
    
    -> #0 (kernel_sem){--..}:
           [<c015928c>] __lock_acquire+0x8a4/0xae6
           [<c015983a>] lock_acquire+0x4e/0x6c
           [<c04839f0>] mutex_lock_nested+0xc2/0x22a
           [<c04851d1>] lock_kernel+0x1e/0x25
           [<c01b4e17>] __blkdev_put+0x29/0x10f
           [<c01b4f07>] blkdev_put+0xa/0xc
           [<c01cc058>] register_disk+0xda/0x11c
           [<c02351b2>] add_disk+0x2f/0x74
           [<c03264b2>] sd_probe+0x2d2/0x379
           [<c02b5a32>] driver_probe_device+0xa0/0x11b
           [<c02b5b14>] __device_attach+0x8/0xa
           [<c02b5041>] bus_for_each_drv+0x39/0x63
           [<c02b5b86>] device_attach+0x51/0x67
           [<c02b4ec7>] bus_attach_device+0x24/0x4e
           [<c02b41b4>] device_add+0x31e/0x42c
           [<c02f2690>] scsi_sysfs_add_sdev+0x9f/0x1d3
           [<c02f0d08>] scsi_probe_and_add_lun+0x96d/0xa84
           [<c02f1861>] __scsi_add_device+0x85/0xab
           [<c0334dda>] ata_scsi_scan_host+0x99/0x217
           [<c03323c6>] ata_host_register+0x1c8/0x1e5
           [<c0339b71>] ata_pci_sff_activate_host+0x179/0x19f
           [<c0339fab>] ata_pci_sff_init_one+0x97/0xe1
           [<c034c484>] amd_init_one+0x10a/0x113
           [<c024cb8d>] pci_device_probe+0x39/0x59
           [<c02b5a32>] driver_probe_device+0xa0/0x11b
           [<c02b5aea>] __driver_attach+0x3d/0x5f
           [<c02b528b>] bus_for_each_dev+0x3e/0x60
           [<c02b58c9>] driver_attach+0x14/0x16
           [<c02b5622>] bus_add_driver+0x9d/0x1af
           [<c02b5c6a>] driver_register+0x71/0xcd
           [<c024cd4c>] __pci_register_driver+0x40/0x6c
           [<c06bfd10>] amd_init+0x14/0x16
           [<c06a0464>] kernel_init+0x116/0x226
           [<c011a737>] kernel_thread_helper+0x7/0x10
           [<ffffffff>] 0xffffffff
    
    other info that might help us debug this:
    
    2 locks held by swapper/1:
     #0:  (&shost->scan_mutex){--..}, at: [<c02f1835>] __scsi_add_device+0x59/0xab
     #1:  (&bdev->bd_mutex){--..}, at: [<c01b4e12>] __blkdev_put+0x24/0x10f
    
    stack backtrace:
    Pid: 1, comm: swapper Not tainted 2.6.26-rc2-sched-devel.git #448
     [<c0157a57>] print_circular_bug_tail+0x5b/0x66
     [<c0157ed8>] ? print_circular_bug_header+0xa6/0xb1
     [<c015928c>] __lock_acquire+0x8a4/0xae6
     [<c015983a>] lock_acquire+0x4e/0x6c
     [<c04851d1>] ? lock_kernel+0x1e/0x25
     [<c04839f0>] mutex_lock_nested+0xc2/0x22a
     [<c04851d1>] ? lock_kernel+0x1e/0x25
     [<c04851d1>] ? lock_kernel+0x1e/0x25
     [<c04851d1>] lock_kernel+0x1e/0x25
     [<c01b4e17>] __blkdev_put+0x29/0x10f
     [<c01b4f07>] blkdev_put+0xa/0xc
     [<c01cc058>] register_disk+0xda/0x11c
     [<c02351b2>] add_disk+0x2f/0x74
     [<c0234c50>] ? exact_match+0x0/0xb
     [<c0234f2f>] ? exact_lock+0x0/0x11
     [<c03264b2>] sd_probe+0x2d2/0x379
     [<c02b5a32>] driver_probe_device+0xa0/0x11b
     [<c02b5b14>] __device_attach+0x8/0xa
     [<c02b5041>] bus_for_each_drv+0x39/0x63
     [<c02b5b86>] device_attach+0x51/0x67
     [<c02b5b0c>] ? __device_attach+0x0/0xa
     [<c02b4ec7>] bus_attach_device+0x24/0x4e
     [<c02b41b4>] device_add+0x31e/0x42c
     [<c02f2690>] scsi_sysfs_add_sdev+0x9f/0x1d3
     [<c02f0d08>] scsi_probe_and_add_lun+0x96d/0xa84
     [<c02f1835>] ? __scsi_add_device+0x59/0xab
     [<c02f1861>] __scsi_add_device+0x85/0xab
     [<c0334dda>] ata_scsi_scan_host+0x99/0x217
     [<c03323c6>] ata_host_register+0x1c8/0x1e5
     [<c0339b71>] ata_pci_sff_activate_host+0x179/0x19f
     [<c033bc3f>] ? ata_sff_interrupt+0x0/0x1d5
     [<c0339fab>] ata_pci_sff_init_one+0x97/0xe1
     [<c034c484>] amd_init_one+0x10a/0x113
     [<c024cb8d>] pci_device_probe+0x39/0x59
     [<c02b5a32>] driver_probe_device+0xa0/0x11b
     [<c02b5aea>] __driver_attach+0x3d/0x5f
     [<c02b528b>] bus_for_each_dev+0x3e/0x60
     [<c02b58c9>] driver_attach+0x14/0x16
     [<c02b5aad>] ? __driver_attach+0x0/0x5f
     [<c02b5622>] bus_add_driver+0x9d/0x1af
     [<c02b5c6a>] driver_register+0x71/0xcd
     [<c0243089>] ? __spin_lock_init+0x24/0x48
     [<c024cd4c>] __pci_register_driver+0x40/0x6c
     [<c06bfd10>] amd_init+0x14/0x16
     [<c06a0464>] kernel_init+0x116/0x226
     [<c06a034e>] ? kernel_init+0x0/0x226
     [<c06a034e>] ? kernel_init+0x0/0x226
     [<c011a737>] kernel_thread_helper+0x7/0x10
     =======================
    sd 0:0:0:0: [sda] Attached SCSI disk
    sd 0:0:0:0: Attached scsi generic sg0 type 0
    scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
    sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
    Uniform CD-ROM driver Revision: 3.20
    sr 1:0:1:0: Attached scsi CD-ROM sr0
    sr 1:0:1:0: Attached scsi generic sg1 type 5
    initcall amd_init+0x0/0x16() returned 0 after 1120 msecs
    calling  artop_init+0x0/0x16()
    initcall artop_init+0x0/0x16() returned 0 after 0 msecs
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7d822fa..d680428 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1083,8 +1083,8 @@ static int __blkdev_put(struct block_device *bdev, int for_part)
 	struct gendisk *disk = bdev->bd_disk;
 	struct block_device *victim = NULL;
 
-	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	lock_kernel();
+	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (for_part)
 		bdev->bd_part_count--;
 
@@ -1112,8 +1112,8 @@ static int __blkdev_put(struct block_device *bdev, int for_part)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
 	}
-	unlock_kernel();
 	mutex_unlock(&bdev->bd_mutex);
+	unlock_kernel();
 	bdput(bdev);
 	if (victim)
 		__blkdev_put(victim, 1);

commit c50fbe69c92ff23b10d13085dbcdf3c6c29a3c62
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 10:46:40 2008 +0200

    remove the BKL: reduce BKL locking during bootup
    
    reduce BKL locking during bootup - as nothing is supposed to be
    active at this point that could race with this code (and which
    race would be prevented by the BKL):
    
    ---------------------->
    calling  firmware_class_init+0x0/0x5c()
    initcall firmware_class_init+0x0/0x5c() returned 0 after 0 msecs
    calling  loopback_init+0x0/0xf()
    
    =======================================================
    [ INFO: possible circular locking dependency detected ]
    2.6.26-rc2-sched-devel.git #441
    -------------------------------------------------------
    swapper/1 is trying to acquire lock:
     (kernel_sem){--..}, at: [<c04851c9>] lock_kernel+0x1e/0x25
    
    but task is already holding lock:
     (rtnl_mutex){--..}, at: [<c040748b>] rtnl_lock+0xf/0x11
    
    which lock already depends on the new lock.
    
    the existing dependency chain (in reverse order) is:
    
    -> #2 (rtnl_mutex){--..}:
           [<c0159361>] __lock_acquire+0x97d/0xae6
           [<c0159836>] lock_acquire+0x4e/0x6c
           [<c04839e8>] mutex_lock_nested+0xc2/0x22a
           [<c040748b>] rtnl_lock+0xf/0x11
           [<c06c4b6f>] net_ns_init+0x93/0xff
           [<c06a0469>] kernel_init+0x11b/0x22b
           [<c011a737>] kernel_thread_helper+0x7/0x10
           [<ffffffff>] 0xffffffff
    
    -> #1 (net_mutex){--..}:
           [<c0159361>] __lock_acquire+0x97d/0xae6
           [<c0159836>] lock_acquire+0x4e/0x6c
           [<c04839e8>] mutex_lock_nested+0xc2/0x22a
           [<c03fd5b1>] register_pernet_subsys+0x12/0x2f
           [<c06b7558>] proc_net_init+0x1e/0x20
           [<c06b722b>] proc_root_init+0x4f/0x97
           [<c06a0858>] start_kernel+0x2c4/0x2e7
           [<c06a0008>] __init_begin+0x8/0xa
           [<ffffffff>] 0xffffffff
    
    -> #0 (kernel_sem){--..}:
           [<c0159288>] __lock_acquire+0x8a4/0xae6
           [<c0159836>] lock_acquire+0x4e/0x6c
           [<c04839e8>] mutex_lock_nested+0xc2/0x22a
           [<c04851c9>] lock_kernel+0x1e/0x25
           [<c014a43d>] call_usermodehelper_exec+0x95/0xde
           [<c023c74e>] kobject_uevent_env+0x2cd/0x2ff
           [<c023c78a>] kobject_uevent+0xa/0xc
           [<c02b419d>] device_add+0x317/0x42c
           [<c0409b47>] netdev_register_kobject+0x6c/0x70
           [<c03ffa26>] register_netdevice+0x258/0x2c8
           [<c03ffac8>] register_netdev+0x32/0x3f
           [<c06beea1>] loopback_net_init+0x2e/0x5d
           [<c03fd4e3>] register_pernet_operations+0x13/0x15
           [<c03fd54c>] register_pernet_device+0x1f/0x4c
           [<c06bee71>] loopback_init+0xd/0xf
           [<c06a0469>] kernel_init+0x11b/0x22b
           [<c011a737>] kernel_thread_helper+0x7/0x10
           [<ffffffff>] 0xffffffff
    
    other info that might help us debug this:
    
    2 locks held by swapper/1:
     #0:  (net_mutex){--..}, at: [<c03fd540>] register_pernet_device+0x13/0x4c
     #1:  (rtnl_mutex){--..}, at: [<c040748b>] rtnl_lock+0xf/0x11
    
    stack backtrace:
    Pid: 1, comm: swapper Not tainted 2.6.26-rc2-sched-devel.git #441
     [<c0157a53>] print_circular_bug_tail+0x5b/0x66
     [<c015739b>] ? print_circular_bug_entry+0x39/0x43
     [<c0159288>] __lock_acquire+0x8a4/0xae6
     [<c0159836>] lock_acquire+0x4e/0x6c
     [<c04851c9>] ? lock_kernel+0x1e/0x25
     [<c04839e8>] mutex_lock_nested+0xc2/0x22a
     [<c04851c9>] ? lock_kernel+0x1e/0x25
     [<c0485026>] ? _spin_unlock_irq+0x2d/0x42
     [<c04851c9>] ? lock_kernel+0x1e/0x25
     [<c04851c9>] lock_kernel+0x1e/0x25
     [<c014a43d>] call_usermodehelper_exec+0x95/0xde
     [<c023c74e>] kobject_uevent_env+0x2cd/0x2ff
     [<c023c78a>] kobject_uevent+0xa/0xc
     [<c02b419d>] device_add+0x317/0x42c
     [<c0409b47>] netdev_register_kobject+0x6c/0x70
     [<c03ffa26>] register_netdevice+0x258/0x2c8
     [<c03ffac8>] register_netdev+0x32/0x3f
     [<c06beea1>] loopback_net_init+0x2e/0x5d
     [<c03fd4e3>] register_pernet_operations+0x13/0x15
     [<c03fd54c>] register_pernet_device+0x1f/0x4c
     [<c06bee71>] loopback_init+0xd/0xf
     [<c06a0469>] kernel_init+0x11b/0x22b
     [<c0110031>] ? kvm_timer_intr_post+0x11/0x1b
     [<c06a034e>] ? kernel_init+0x0/0x22b
     [<c06a034e>] ? kernel_init+0x0/0x22b
     [<c011a737>] kernel_thread_helper+0x7/0x10
     =======================
    initcall loopback_init+0x0/0xf() returned 0 after 1 msecs
    calling  init_pcmcia_bus+0x0/0x6c()
    initcall init_pcmcia_bus+0x0/0x6c() returned 0 after 0 msecs
    calling  cpufreq_gov_performance_init+0x0/0xf()
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/init/main.c b/init/main.c
index f406fef..8d3b879 100644
--- a/init/main.c
+++ b/init/main.c
@@ -461,7 +461,6 @@ static void noinline __init_refok rest_init(void)
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
-	unlock_kernel();
 
 	/*
 	 * The boot idle thread must execute schedule()
@@ -677,6 +676,7 @@ asmlinkage void __init start_kernel(void)
 	delayacct_init();
 
 	check_bugs();
+	unlock_kernel();
 
 	acpi_early_init(); /* before LAPIC and SMP init */
 
@@ -795,7 +795,6 @@ static void run_init_process(char *init_filename)
 static int noinline init_post(void)
 {
 	free_initmem();
-	unlock_kernel();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
@@ -835,7 +834,6 @@ static int noinline init_post(void)
 
 static int __init kernel_init(void * unused)
 {
-	lock_kernel();
 	/*
 	 * init can run on any cpu.
 	 */

commit 79b2b296c31fa07e8868a6c622d766bb567f6655
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 11:30:35 2008 +0200

    remove the BKL: change get_fs_type() BKL dependency
    
    solve this BKL dependency problem:
    
    ---------->
    Write protecting the kernel read-only data: 1664k
    INFO: task init:1 blocked for more than 30 seconds.
    "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
    init          D c0629430     0     1      0
           f7cb4d64 00000046 00000001 c0629430 00000001 00000046 00000000 c06e6900
           c06e6000 f7cb3358 f7cb35c0 c1d1b000 00000001 00000040 f7cb4000 f6f35dc0
           00000000 fffb8b68 f7cb3358 f7cb3830 00000001 00000000 ffffffff 00000001
    Call Trace:
     [<c0483224>] schedule_timeout+0x16/0x8b
     [<c0158450>] ? mark_held_locks+0x4e/0x66
     [<c0158607>] ? trace_hardirqs_on+0xb/0xd
     [<c01585c7>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c0158607>] ? trace_hardirqs_on+0xb/0xd
     [<c0482784>] wait_for_common+0xc3/0xfc
     [<c013609f>] ? default_wake_function+0x0/0xd
     [<c048283f>] wait_for_completion+0x12/0x14
     [<c014a40b>] call_usermodehelper_exec+0x7f/0xbf
     [<c014a6f0>] request_module+0xce/0xe2
     [<c01a0073>] ? lock_get_status+0x164/0x1fe
     [<c019bf8d>] ? __link_path_walk+0xa67/0xb7a
     [<c01a60da>] get_fs_type+0xbf/0x161
     [<c0195542>] do_kern_mount+0x1b/0xba
     [<c01a853d>] do_new_mount+0x46/0x74
     [<c01a8702>] do_mount+0x197/0x1b5
     [<c01585c7>] ? trace_hardirqs_on_caller+0xe0/0x115
     [<c0483b18>] ? mutex_lock_nested+0x222/0x22a
     [<c0485199>] ? lock_kernel+0x1e/0x25
     [<c01a8784>] sys_mount+0x64/0x9b
     [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
     =======================
    1 lock held by init/1:
     #0:  (kernel_sem){--..}, at: [<c0485199>] lock_kernel+0x1e/0x25
    Kernel panic - not syncing: softlockup: blocked tasks
    Pid: 5, comm: watchdog/0 Not tainted 2.6.26-rc2-sched-devel.git #437
     [<c013d1db>] panic+0x49/0xfa
     [<c016b157>] watchdog+0x168/0x1d1
     [<c016afef>] ? watchdog+0x0/0x1d1
     [<c014d4d4>] kthread+0x3b/0x63
     [<c014d499>] ? kthread+0x0/0x63
     [<c011a737>] kernel_thread_helper+0x7/0x10
     =======================
    <---------
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/fs/filesystems.c b/fs/filesystems.c
index f37f872..1888ec7 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -11,7 +11,9 @@
 #include <linux/slab.h>
 #include <linux/kmod.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 #include <linux/module.h>
+
 #include <asm/uaccess.h>
 
 /*
@@ -219,6 +221,14 @@ struct file_system_type *get_fs_type(const char *name)
 	struct file_system_type *fs;
 	const char *dot = strchr(name, '.');
 	unsigned len = dot ? dot - name : strlen(name);
+	int bkl = kernel_locked();
+
+	/*
+	 * We request a module that might trigger user-space
+	 * tasks. So explicitly drop the BKL here:
+	 */
+	if (bkl)
+		unlock_kernel();
 
 	read_lock(&file_systems_lock);
 	fs = *(find_filesystem(name, len));
@@ -237,6 +247,8 @@ struct file_system_type *get_fs_type(const char *name)
 		put_filesystem(fs);
 		fs = NULL;
 	}
+	if (bkl)
+		lock_kernel();
 	return fs;
 }
 

commit fc6f051a95c8774abb950f287b4b5e7f710f6977
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed May 14 09:51:42 2008 +0200

    revert ("BKL: revert back to the old spinlock implementation")
    
    revert ("BKL: revert back to the old spinlock implementation"),
    commit 8e3e076c5a78519a9f64cd384e8f18bc21882ce0.
    
    Just a technical revert, it's easier to get the new anti-BKL code
    going with the sleeping lock.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index e856218..6a6409a 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -186,6 +186,17 @@ config PREEMPT
 	  Say Y here if you are building a kernel for a desktop, embedded
 	  or real-time system.  Say N if you are unsure.
 
+config PREEMPT_BKL
+	bool "Preempt The Big Kernel Lock"
+	depends on PREEMPT
+	default y
+	help
+	  This option reduces the latency of the kernel by making the
+	  big kernel lock preemptible.
+
+	  Say Y here if you are building a kernel for a desktop system.
+	  Say N if you are unsure.
+
 config MN10300_CURRENT_IN_E2
 	bool "Hold current task address in E2 register"
 	default y
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 181006c..897f723 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -72,14 +72,6 @@
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
 
-#if defined(CONFIG_PREEMPT)
-# define PREEMPT_INATOMIC_BASE kernel_locked()
-# define PREEMPT_CHECK_OFFSET 1
-#else
-# define PREEMPT_INATOMIC_BASE 0
-# define PREEMPT_CHECK_OFFSET 0
-#endif
-
 /*
  * Are we running in atomic context?  WARNING: this macro cannot
  * always detect atomic context; in particular, it cannot know about
@@ -87,11 +79,17 @@
  * used in the general case to determine whether sleeping is possible.
  * Do not use in_atomic() in driver code.
  */
-#define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
+#define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)
+
+#ifdef CONFIG_PREEMPT
+# define PREEMPT_CHECK_OFFSET 1
+#else
+# define PREEMPT_CHECK_OFFSET 0
+#endif
 
 /*
  * Check whether we were atomic before we did preempt_disable():
- * (used by the scheduler, *after* releasing the kernel lock)
+ * (used by the scheduler)
  */
 #define in_atomic_preempt_off() \
 		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
diff --git a/kernel/sched.c b/kernel/sched.c
index 8841a91..59d20a5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4567,6 +4567,8 @@ EXPORT_SYMBOL(schedule);
 asmlinkage void __sched preempt_schedule(void)
 {
 	struct thread_info *ti = current_thread_info();
+	struct task_struct *task = current;
+	int saved_lock_depth;
 
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
@@ -4577,7 +4579,16 @@ asmlinkage void __sched preempt_schedule(void)
 
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
+
+		/*
+		 * We keep the big kernel semaphore locked, but we
+		 * clear ->lock_depth so that schedule() doesnt
+		 * auto-release the semaphore:
+		 */
+		saved_lock_depth = task->lock_depth;
+		task->lock_depth = -1;
 		schedule();
+		task->lock_depth = saved_lock_depth;
 		sub_preempt_count(PREEMPT_ACTIVE);
 
 		/*
@@ -4598,15 +4609,26 @@ EXPORT_SYMBOL(preempt_schedule);
 asmlinkage void __sched preempt_schedule_irq(void)
 {
 	struct thread_info *ti = current_thread_info();
+	struct task_struct *task = current;
+	int saved_lock_depth;
 
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
+
+		/*
+		 * We keep the big kernel semaphore locked, but we
+		 * clear ->lock_depth so that schedule() doesnt
+		 * auto-release the semaphore:
+		 */
+		saved_lock_depth = task->lock_depth;
+		task->lock_depth = -1;
 		local_irq_enable();
 		schedule();
 		local_irq_disable();
+		task->lock_depth = saved_lock_depth;
 		sub_preempt_count(PREEMPT_ACTIVE);
 
 		/*
@@ -5829,11 +5851,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-#if defined(CONFIG_PREEMPT)
-	task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
-#else
 	task_thread_info(idle)->preempt_count = 0;
-#endif
+
 	/*
 	 * The idle tasks have their own, simple scheduling class:
 	 */
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index 01a3c22..cd3e825 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -11,121 +11,79 @@
 #include <linux/semaphore.h>
 
 /*
- * The 'big kernel lock'
+ * The 'big kernel semaphore'
  *
- * This spinlock is taken and released recursively by lock_kernel()
+ * This mutex is taken and released recursively by lock_kernel()
  * and unlock_kernel().  It is transparently dropped and reacquired
  * over schedule().  It is used to protect legacy code that hasn't
  * been migrated to a proper locking design yet.
  *
+ * Note: code locked by this semaphore will only be serialized against
+ * other code using the same locking facility. The code guarantees that
+ * the task remains on the same CPU.
+ *
  * Don't use in new code.
  */
-static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kernel_flag);
-
+static DECLARE_MUTEX(kernel_sem);
 
 /*
- * Acquire/release the underlying lock from the scheduler.
+ * Re-acquire the kernel semaphore.
  *
- * This is called with preemption disabled, and should
- * return an error value if it cannot get the lock and
- * TIF_NEED_RESCHED gets set.
+ * This function is called with preemption off.
  *
- * If it successfully gets the lock, it should increment
- * the preemption count like any spinlock does.
- *
- * (This works on UP too - _raw_spin_trylock will never
- * return false in that case)
+ * We are executing in schedule() so the code must be extremely careful
+ * about recursion, both due to the down() and due to the enabling of
+ * preemption. schedule() will re-check the preemption flag after
+ * reacquiring the semaphore.
  */
 int __lockfunc __reacquire_kernel_lock(void)
 {
-	while (!_raw_spin_trylock(&kernel_flag)) {
-		if (test_thread_flag(TIF_NEED_RESCHED))
-			return -EAGAIN;
-		cpu_relax();
-	}
+	struct task_struct *task = current;
+	int saved_lock_depth = task->lock_depth;
+
+	BUG_ON(saved_lock_depth < 0);
+
+	task->lock_depth = -1;
+	preempt_enable_no_resched();
+
+	down(&kernel_sem);
+
 	preempt_disable();
+	task->lock_depth = saved_lock_depth;
+
 	return 0;
 }
 
 void __lockfunc __release_kernel_lock(void)
 {
-	_raw_spin_unlock(&kernel_flag);
-	preempt_enable_no_resched();
+	up(&kernel_sem);
 }
 
 /*
- * These are the BKL spinlocks - we try to be polite about preemption.
- * If SMP is not on (ie UP preemption), this all goes away because the
- * _raw_spin_trylock() will always succeed.
+ * Getting the big kernel semaphore.
  */
-#ifdef CONFIG_PREEMPT
-static inline void __lock_kernel(void)
+void __lockfunc lock_kernel(void)
 {
-	preempt_disable();
-	if (unlikely(!_raw_spin_trylock(&kernel_flag))) {
-		/*
-		 * If preemption was disabled even before this
-		 * was called, there's nothing we can be polite
-		 * about - just spin.
-		 */
-		if (preempt_count() > 1) {
-			_raw_spin_lock(&kernel_flag);
-			return;
-		}
+	struct task_struct *task = current;
+	int depth = task->lock_depth + 1;
 
+	if (likely(!depth))
 		/*
-		 * Otherwise, let's wait for the kernel lock
-		 * with preemption enabled..
+		 * No recursion worries - we set up lock_depth _after_
 		 */
-		do {
-			preempt_enable();
-			while (spin_is_locked(&kernel_flag))
-				cpu_relax();
-			preempt_disable();
-		} while (!_raw_spin_trylock(&kernel_flag));
-	}
-}
+		down(&kernel_sem);
 
-#else
-
-/*
- * Non-preemption case - just get the spinlock
- */
-static inline void __lock_kernel(void)
-{
-	_raw_spin_lock(&kernel_flag);
+	task->lock_depth = depth;
 }
-#endif
 
-static inline void __unlock_kernel(void)
+void __lockfunc unlock_kernel(void)
 {
-	/*
-	 * the BKL is not covered by lockdep, so we open-code the
-	 * unlocking sequence (and thus avoid the dep-chain ops):
-	 */
-	_raw_spin_unlock(&kernel_flag);
-	preempt_enable();
-}
+	struct task_struct *task = current;
 
-/*
- * Getting the big kernel lock.
- *
- * This cannot happen asynchronously, so we only need to
- * worry about other CPU's.
- */
-void __lockfunc lock_kernel(void)
-{
-	int depth = current->lock_depth+1;
-	if (likely(!depth))
-		__lock_kernel();
-	current->lock_depth = depth;
-}
+	BUG_ON(task->lock_depth < 0);
 
-void __lockfunc unlock_kernel(void)
-{
-	BUG_ON(current->lock_depth < 0);
-	if (likely(--current->lock_depth < 0))
-		__unlock_kernel();
+	if (likely(--task->lock_depth < 0))
+		up(&kernel_sem);
 }
 
 EXPORT_SYMBOL(lock_kernel);
