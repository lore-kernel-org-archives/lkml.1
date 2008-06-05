Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYFEPbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYFEPbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYFEPbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:31:10 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49166 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYFEPbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:31:09 -0400
Date: Thu, 5 Jun 2008 11:30:08 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Nix <nix@esperi.org.uk>, dhazelton@enter.net
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Message-ID: <20080605153008.GC7311@c2.user-mode-linux.org>
References: <20080603190235.GA9511@c2.user-mode-linux.org> <20080603123211.e129c222.akpm@linux-foundation.org> <200806031543.56864.dhazelton@enter.net> <878wxmfg99.fsf@hades.wkstn.nix> <20080603130709.fcf6a751.akpm@linux-foundation.org> <20080603210048.GA12182@c2.user-mode-linux.org> <4846A75E.40305@goop.org> <20080604193715.GA11943@c2.user-mode-linux.org> <4846F577.10603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4846F577.10603@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 09:05:11PM +0100, Jeremy Fitzhardinge wrote:
> You can either read the monotonic clock directly, or use it as a time 
> source for a monotonic timer.  clock_gettime(CLOCK_MONOTONIC, &ts) will 
> return the time in ns, and you can just feed that directly into the guest 
> as a clocksource.

Aha, I was looking at timer_* and not getting reasonable-looking
results.  The one questionable aspect of this is that I need to pull
in a new library (librt) and I wonder how many people don't have it
installed...

Anyway, the patch below seems to make the guest behave reasonably in
the face of the host time doing funky things...

Give it a spin and let me know how it does.  If there aren't any
problems, I'll get it into mainline.

    	    	Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.22/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/time.c	2008-06-02 15:38:34.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/time.c	2008-06-04 19:49:16.000000000 -0400
@@ -56,6 +56,11 @@ static inline long long timeval_to_ns(co
 		tv->tv_usec * UM_NSEC_PER_USEC;
 }
 
+static inline long long timespec_to_ns(const struct timespec *ts)
+{
+	return ((long long) ts->tv_sec * UM_NSEC_PER_SEC) + ts->tv_nsec;
+}
+
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
@@ -72,12 +77,22 @@ long long disable_timer(void)
 	return remain;
 }
 
-long long os_nsecs(void)
+static inline long long nsecs(int clock)
 {
-	struct timeval tv;
+	struct timespec ts;
+
+	clock_gettime(clock, &ts);
+	return timespec_to_ns(&ts);
+}
+
+long long os_wall_nsecs(void)
+{
+	return nsecs(CLOCK_REALTIME);
+}
 
-	gettimeofday(&tv, NULL);
-	return timeval_to_ns(&tv);
+long long os_mono_nsecs(void)
+{
+	return nsecs(CLOCK_MONOTONIC);
 }
 
 extern void alarm_handler(int sig, struct sigcontext *sc);
@@ -104,13 +119,9 @@ unsigned long long skew;
 
 static void deliver_alarm(void)
 {
-	unsigned long long this_tick = os_nsecs();
+	unsigned long long this_tick = os_mono_nsecs();
 	int one_tick = UM_NSEC_PER_SEC / UM_HZ;
 
-	/* Protection against the host's time going backwards */
-	if ((last_tick != 0) && (this_tick < last_tick))
-		this_tick = last_tick;
-
 	if (last_tick == 0)
 		last_tick = this_tick - one_tick;
 
Index: linux-2.6.22/arch/um/Makefile
===================================================================
--- linux-2.6.22.orig/arch/um/Makefile	2008-05-29 11:21:25.000000000 -0400
+++ linux-2.6.22/arch/um/Makefile	2008-06-04 19:42:09.000000000 -0400
@@ -126,7 +126,7 @@ define cmd_vmlinux__
 	$(CC) $(CFLAGS_vmlinux) -o $@ \
 	-Wl,-T,$(vmlinux-lds) $(vmlinux-init) \
 	-Wl,--start-group $(vmlinux-main) -Wl,--end-group \
-	-lutil \
+	-lutil -lrt \
 	$(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o \
 	FORCE ,$^) ; rm -f linux
 endef
Index: linux-2.6.22/arch/um/include/os.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/os.h	2008-06-02 15:38:34.000000000 -0400
+++ linux-2.6.22/arch/um/include/os.h	2008-06-04 19:51:55.000000000 -0400
@@ -244,7 +244,8 @@ extern int set_interval(void);
 extern int timer_one_shot(int ticks);
 extern long long disable_timer(void);
 extern void uml_idle_timer(void);
-extern long long os_nsecs(void);
+extern long long os_wall_nsecs(void);
+extern long long os_mono_nsecs(void);
 
 /* skas/mem.c */
 extern long run_syscall_stub(struct mm_id * mm_idp,
Index: linux-2.6.22/arch/um/kernel/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/time.c	2008-06-02 15:38:33.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/time.c	2008-06-04 19:51:59.000000000 -0400
@@ -74,7 +74,7 @@ static irqreturn_t um_timer(int irq, voi
 
 static cycle_t itimer_read(void)
 {
-	return os_nsecs() / 1000;
+	return os_mono_nsecs() / 1000;
 }
 
 static struct clocksource itimer_clocksource = {
@@ -117,7 +117,7 @@ void __init time_init(void)
 
 	timer_init();
 
-	nsecs = os_nsecs();
+	nsecs = os_wall_nsecs();
 	set_normalized_timespec(&wall_to_monotonic, -nsecs / NSEC_PER_SEC,
 				-nsecs % NSEC_PER_SEC);
 	set_normalized_timespec(&xtime, nsecs / NSEC_PER_SEC,
Index: linux-2.6.22/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/skas/process.c	2008-06-04 19:51:05.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/skas/process.c	2008-06-04 19:51:59.000000000 -0400
@@ -359,7 +359,7 @@ void userspace(struct uml_pt_regs *regs)
 		printk(UM_KERN_ERR "Failed to get itimer, errno = %d\n", errno);
 	nsecs = timer.it_value.tv_sec * UM_NSEC_PER_SEC +
 		timer.it_value.tv_usec * UM_NSEC_PER_USEC;
-	nsecs += os_nsecs();
+	nsecs += os_mono_nsecs();
 
 	while (1) {
 		/*
@@ -420,7 +420,7 @@ void userspace(struct uml_pt_regs *regs)
 				relay_signal(SIGTRAP, regs);
 				break;
 			case SIGVTALRM:
-				now = os_nsecs();
+				now = os_mono_nsecs();
 				if (now < nsecs)
 					break;
 				block_signals();
@@ -430,7 +430,7 @@ void userspace(struct uml_pt_regs *regs)
 					UM_NSEC_PER_SEC +
 					timer.it_value.tv_usec *
 					UM_NSEC_PER_USEC;
-				nsecs += os_nsecs();
+				nsecs += os_mono_nsecs();
 				break;
 			case SIGIO:
 			case SIGILL:
