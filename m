Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYAGLsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYAGLsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbYAGLrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:47:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55364 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYAGLrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:47:51 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: sleep before boot panic
To: Ingo Oeser <ioe-lkml@rameria.de>, Bernd Schubert <bernd-schubert@gmx.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Reply-To: 7eggert@gmx.de
Date: Mon, 07 Jan 2008 12:47:37 +0100
References: <9II6K-1Pg-9@gated-at.bofh.it> <9IJ2M-3l2-3@gated-at.bofh.it> <9IJme-3Nb-13@gated-at.bofh.it> <9IKrY-5vk-15@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JBqS9-0003Xp-Sh@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18EeVDh1NN0HABx6gjdLmRtiSt+CpW1sDAm/0w
 GibM0r75OxkNt4pi4O/+fSwgyI+y2IEhrZKxpw5VmZVdg0gDV8
 1aguz+il496hCYGqDOVMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Oeser <ioe-lkml@rameria.de> wrote:

> CC'ed hpa, since I'm sure he can give useful advise on that :-)
> 
> On Sunday 06 January 2008, Bernd Schubert wrote:
>> On Sunday 06 January 2008, Ingo Oeser wrote:
>> > On Sunday 06 January 2008, you wrote:

>> > > Index: zd1211rw.git.beno/init/do_mounts.c
>> > > ===================================================================
>> > > --- zd1211rw.git.beno.orig/init/do_mounts.c      2008-01-06 18:44:23.000000000
>> > > +0100
>> > > +++ zd1211rw.git.beno/init/do_mounts.c   2008-01-06 18:45:44.000000000
>> > > +0100 @@ -330,6 +330,7 @@
>> > >  printk("Please append a correct \"root=\" boot option; here are the
>> > > available partitions:\n");
>> > >
>> > >  printk_all_partitions();
>> > > +                msleep(60 * 1000);
>> >
>> > ssleep(60);
>> 
>> feel free to replace it replace it :)
> 
> Not that urgent, but if you resubmit please do it :-)

You don't need to, because ...

>> There is no dump_stack() here, but disc detection is relatively early in boot
>> process and on all these information are already scrolled off screen when the
>> panic is done. For this and any other panic it would be optimal if scrolling
>> still would work, but scrolling also requires kernel code, so I see there's a
>> reason not to this for all panics. However, for this boot problem I tend to
>> say there's no need to panic at all...
> 
> But the kernel cannot continue from that position. You would need a "soft"
> panic, which allows behavior of panic=X, but let the kernel continue.

Ingo is right, and I've done the work. The latest version is included below.
If it does not apply cleanly and there is a chance of including it, I'll
port the patch to any version you name.

> Even better is to continue with the init in the builtin ramfs. That should
> always be available and can implement any behavior desired (like droping into
> a dash).

ACK, but that's your part.


<snip>

Introduce config CONFIG_SOFTPANIC
Enabling this option changes a hard panic on boot errors to a
soft panic, which does not stop the system completely.
You can still scroll the screen and read the messages.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>

diff -pruN linux-2.6.23.base/include/linux/kernel.h
linux-2.6.23.softpanic/include/linux/kernel.h
--- linux-2.6.23.base/include/linux/kernel.h    2007-10-11 14:15:39.000000000 +0200
+++ linux-2.6.23.softpanic/include/linux/kernel.h       2007-10-11 14:45:15.000000000
+0200
@@ -108,6 +108,12 @@ extern struct atomic_notifier_head panic
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
        __attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+#ifdef SOFTPANIC
+NORET_TYPE void softpanic(const char * fmt, ...)
+       __attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+#else
+# define softpanic(...) do { panic(__VA_ARGS__); } while (0)
+#endif
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
diff -pruN linux-2.6.23.base/init/Kconfig linux-2.6.23.softpanic/init/Kconfig
--- linux-2.6.23.base/init/Kconfig      2007-10-11 14:15:42.000000000 +0200
+++ linux-2.6.23.softpanic/init/Kconfig 2007-10-11 15:19:07.000000000 +0200
@@ -441,6 +441,14 @@ config BUG
           option for embedded systems with no facilities for reporting errors.
           Just say Y.
 
+config SOFTPANIC
+       bool "Enable softpanic for boot errors" if EMBEDDED
+       default y
+       help
+               Enabling this option changes a hard panic on boot errors to a
+               soft panic, which does not stop the system completely.
+               You can still scroll the screen and read the messages.
+
 config ELF_CORE
        default y
        bool "Enable ELF core dumps" if EMBEDDED
diff -pruN linux-2.6.23.base/init/do_mounts.c
linux-2.6.23.softpanic/init/do_mounts.c
--- linux-2.6.23.base/init/do_mounts.c  2007-10-11 14:15:42.000000000 +0200
+++ linux-2.6.23.softpanic/init/do_mounts.c     2007-10-11 14:48:51.000000000 +0200
@@ -330,7 +330,7 @@ retry:
                printk("Please append a correct \"root=\" boot option; here are the available
partitions:\n");
 
                printk_all_partitions();
-               panic("VFS: Unable to mount root fs on %s", b);
+               softpanic("VFS: Unable to mount root fs on %s", b);
        }
 
        printk("List of all partitions:\n");
@@ -342,7 +342,7 @@ retry:
 #ifdef CONFIG_BLOCK
        __bdevname(ROOT_DEV, b);
 #endif
-       panic("VFS: Unable to mount root fs on %s", b);
+       softpanic("VFS: Unable to mount root fs on %s", b);
 out:
        putname(fs_names);
 }
diff -pruN linux-2.6.23.base/init/main.c linux-2.6.23.softpanic/init/main.c
--- linux-2.6.23.base/init/main.c       2007-10-11 14:15:42.000000000 +0200
+++ linux-2.6.23.softpanic/init/main.c  2007-10-11 14:40:06.000000000 +0200
@@ -590,7 +590,7 @@ asmlinkage void __init start_kernel(void
         */
        console_init();
        if (panic_later)
-               panic(panic_later, panic_param);
+               softpanic(panic_later, panic_param);
 
        lockdep_info();
 
@@ -807,7 +807,7 @@ static int noinline init_post(void)
        run_init_process("/bin/init");
        run_init_process("/bin/sh");
 
-       panic("No init found.  Try passing init= option to kernel.");
+       softpanic("No init found.  Try passing init= option to kernel.");
 }
 
 static int __init kernel_init(void * unused)
diff -pruN linux-2.6.23.base/kernel/panic.c
linux-2.6.23.softpanic/kernel/panic.c
--- linux-2.6.23.base/kernel/panic.c    2007-10-11 14:15:42.000000000 +0200
+++ linux-2.6.23.softpanic/kernel/panic.c       2007-10-11 14:53:42.000000000 +0200
@@ -139,7 +139,66 @@ NORET_TYPE void panic(const char * fmt, 
        }
 }
 
+#ifdef SOFTPANIC
+NORET_TYPE void softpanic(const char * fmt, ...)
+{
+       long i;
+       static char buf[1024];
+       va_list args;
+#if defined(CONFIG_S390)
+        unsigned long caller = (unsigned long) __builtin_return_address(0);
+#endif
+
+       va_start(args, fmt);
+       vsnprintf(buf, sizeof(buf), fmt, args);
+       va_end(args);
+       printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+
+       atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
+
+       if (!panic_blink)
+               panic_blink = no_blink;
+
+       if (panic_timeout > 0) {
+               /*
+                * Delay timeout seconds before rebooting the machine. 
+                * We can't use the "normal" timers since we just panicked..
+                */
+               printk(KERN_EMERG "Rebooting in %d seconds..",panic_timeout);
+               for (i = 0; i < panic_timeout*1000; ) {
+                       touch_nmi_watchdog();
+                       i += panic_blink(i);
+                       mdelay(1);
+                       i++;
+               }
+               /*      This will not be a clean reboot, with everything
+                *      shutting down.  But if there is a chance of
+                *      rebooting the system it will be rebooted.
+                */
+               kernel_restart(NULL);
+       }
+#ifdef __sparc__
+       {
+               extern int stop_a_enabled;
+               /* Make sure the user can actually press Stop-A (L1-A) */
+               stop_a_enabled = 1;
+               printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
+       }
+#endif
+#if defined(CONFIG_S390)
+        disabled_wait(caller);
+#endif
+       for (i = 0;;) {
+               touch_softlockup_watchdog();
+               i += panic_blink(i);
+               msleep(1);
+               i++;
+       }
+}
+#endif
+
 EXPORT_SYMBOL(panic);
+EXPORT_SYMBOL(softpanic);
 
 /**
  *     print_tainted - return a string to represent the kernel taint state.

