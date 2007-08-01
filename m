Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbXHAXBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbXHAXBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXHAXBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:01:36 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39180 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbXHAXBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:01:36 -0400
Date: Thu, 2 Aug 2007 01:00:21 +0200 (MEST)
Message-Id: <200708012300.l71N0LRX008930@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] unbreak generic futex_atomic_cmpxchg_inatomic() on UP
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, mingo@redhat.com,
       rmk@arm.linux.org.uk, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend. I messed up the To: line the first time]

As has been reported recently by Lennert Buytenhek, robust futexes
are broken on ARM:

>If you're also running into glibc's tst-robust1 test suite test
>locking up your ARM machine, you're probably running into the fact
>that asm-arm/futex.h includes asm-generic/futex.h, and
>asm-generic/futex.h defines futex_atomic_cmpxchg_inatomic() to
>return -ENOSYS.  This causes handle_futex_death() to loop forever.

I can confirm this statement: building glibc-2.4 with NPTL on
ARM hangs the kernel when the test suite reaches tst-robust1.

The problem is that kernel/futex.c expects futex_atomic_cmpxchg_inatomic()
to return -EFAULT or the new value. It doesn't expect -ENOSYS at all, and
generally -ENOSYS causes the futex code to loop, hanging the kernel.

The higher-end archs (x86, sparc64, ppc64, etc) provide fully-functional
asm/futex.h implementations, but a number of archs (alpha, arm, arm26,
avr32, blackfin, cris, h8300, m32r, m68k, mk68knommu, sh64, sparc, um,
v850, and xtensa) use asm-generic/futex.h, which makes robust futexes
horribly broken on them. There have also been reports recently that PI
futexes are broken due to the generic futex_atomic_cmpxchg_inatomic()
just being an -ENOSYS stub.

The patch below implements the generic futex_atomic_cmpxchg_inatomic() in
terms of __copy_{from,to}_user_inatomic() and preempt_{disable,enable}().
It obviously doesn't support SMP, but UP-only support should go a long
way for users of the affected archs.

I'm using this patch now and it has allowed me to build and use glibc-2.4
with NPTL on ARM (glibc-2.4-11.src.rpm from FC5 + ARM fixes).
(Finally I can ditch LinuxThreads :->)

Comments?

/Mikael

--- linux-2.6.22/include/asm-generic/futex.h.~1~	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.22/include/asm-generic/futex.h	2007-08-01 19:03:43.000000000 +0200
@@ -4,6 +4,7 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/preempt.h>
 #include <asm/errno.h>
 #include <asm/uaccess.h>
 
@@ -52,7 +53,34 @@ futex_atomic_op_inuser (int encoded_op, 
 static inline int
 futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 {
+#ifdef CONFIG_SMP
 	return -ENOSYS;
+#else
+	int curval, ret;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	preempt_disable();
+
+	ret = -EFAULT;
+	if (__copy_from_user_inatomic(&curval, uaddr, sizeof(int)))
+		goto out;
+
+	ret = curval;
+	if (curval != oldval)
+		goto out;
+
+	ret = -EFAULT;
+	if (__copy_to_user_inatomic(uaddr, &newval, sizeof(int)))
+		goto out;
+
+	ret = newval;
+
+ out:
+	preempt_enable();
+	return ret;
+#endif
 }
 
 #endif
