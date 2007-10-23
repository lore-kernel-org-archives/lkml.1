Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbXJWBHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbXJWBHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 21:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXJWBH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 21:07:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:53900 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXJWBHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 21:07:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Date: Tue, 23 Oct 2007 03:06:50 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, matthew@wil.cx,
       ralf@linux-mips.org, adobriyan@gmail.com, viro@ftp.linux.org.uk,
       viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <200710222334.45667.arnd@arndb.de> <alpine.LFD.0.9999.0710222344580.3167@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710222344580.3167@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230306.51606.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19s4Z4qcPTXtjDu1X/eaJP6Aus39Z+NkVTWtK0
 QdW7vtzsJm3yipagpwxgfUUz6H66KVcuUaHoWamusGVwX4+Dki
 UTDfgyMzJHUn/ZkxIN/gA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007, Thomas Gleixner wrote:
> On Mon, 22 Oct 2007, Arnd Bergmann wrote:
>
> > I tried this as well a few years ago, and I think I hit a few places in
> > the early initialization, but nothing unfixable.
> 
> Hmm, lockdep checks this already. If it does not catch it, we need to fix it.

I've looked at the lockdep code for some time but couldn't find out how
it is trying to catch this kind of bug. AFAICS, there are all sorts of
really complex spinlock/irqflags interaction problems that lockdep checks
for, but not this really simple one ;-)

I tried the trivial annotation below and (with lockdep enabled) got a few
warnings at boot time, but only one that I could still find in the log
buffer:

[   10.298910] WARNING: at /home/arnd/linux/linux-2.6/kernel/signal.c:1799 get_signal_to_deliver()
[   10.298978]  [<c0105218>] show_trace_log_lvl+0x1a/0x2f
[   10.299072]  [<c0105c06>] show_trace+0x12/0x14
[   10.299160]  [<c0105d19>] dump_stack+0x15/0x17
[   10.299248]  [<c0129602>] get_signal_to_deliver+0x73/0x636
[   10.299338]  [<c0103574>] do_notify_resume+0x91/0x728
[   10.299427]  [<c010439c>] work_notifysig+0x13/0x1b

This one looks like in the syscall exit path, after disabling the interrupts,
we call back into a C function that first disables and then enables
interrupts again unconditionally, which seems to do the right thing here,
but still feels wrong.

I suppose lockdep should be extended to catch this kind of bug as well,
instead of the hack I used to find this.

	Arnd <><

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index c376f3b..3ece198 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -207,13 +207,8 @@ do {								\
 
 #endif
 
-#define spin_lock_irq(lock)		_spin_lock_irq(lock)
 #define spin_lock_bh(lock)		_spin_lock_bh(lock)
-
-#define read_lock_irq(lock)		_read_lock_irq(lock)
 #define read_lock_bh(lock)		_read_lock_bh(lock)
-
-#define write_lock_irq(lock)		_write_lock_irq(lock)
 #define write_lock_bh(lock)		_write_lock_bh(lock)
 
 /*
@@ -221,13 +216,25 @@ do {								\
  */
 #if defined(CONFIG_DEBUG_SPINLOCK) || defined(CONFIG_PREEMPT) || \
 	!defined(CONFIG_SMP)
+# define spin_lock_irq(lock) \
+    do { WARN_ON_ONCE(irqs_disabled()); _spin_lock_irq(lock); } while (0)
+# define read_lock_irq(lock) \
+    do { WARN_ON_ONCE(irqs_disabled()); _read_lock_irq(lock); } while (0)
+# define write_lock_irq(lock) \
+    do { WARN_ON_ONCE(irqs_disabled()); _write_lock_irq(lock); } while (0)
 # define spin_unlock(lock)		_spin_unlock(lock)
 # define read_unlock(lock)		_read_unlock(lock)
 # define write_unlock(lock)		_write_unlock(lock)
-# define spin_unlock_irq(lock)		_spin_unlock_irq(lock)
-# define read_unlock_irq(lock)		_read_unlock_irq(lock)
-# define write_unlock_irq(lock)		_write_unlock_irq(lock)
+# define spin_unlock_irq(lock) \
+    do { WARN_ON_ONCE(!irqs_disabled()); _spin_unlock_irq(lock); } while (0)
+# define read_unlock_irq(lock) \
+    do { WARN_ON_ONCE(!irqs_disabled()); _read_unlock_irq(lock); } while (0)
+# define write_unlock_irq(lock) \
+    do { WARN_ON_ONCE(!irqs_disabled()); _write_unlock_irq(lock); } while (0)
 #else
+# define spin_lock_irq(lock)		_spin_lock_irq(lock)
+# define read_lock_irq(lock)		_read_lock_irq(lock)
+# define write_lock_irq(lock)		_write_lock_irq(lock)
 # define spin_unlock(lock) \
     do {__raw_spin_unlock(&(lock)->raw_lock); __release(lock); } while (0)
 # define read_unlock(lock) \
