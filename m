Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYBKOAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYBKOAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYBKOAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:00:10 -0500
Received: from www.tglx.de ([62.245.132.106]:48611 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYBKOAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:00:08 -0500
Date: Mon, 11 Feb 2008 14:59:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <adrian.bunk@movial.fi>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Riku Voipio <riku.voipio@movial.fi>, Mikael Pettersson <mikpe@it.uu.se>,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: futex local DoS on most architectures
In-Reply-To: <20080211130700.GF27537@movial.fi>
Message-ID: <alpine.LFD.1.00.0802111442130.12988@apollo.tec.linutronix.de>
References: <20080211130700.GF27537@movial.fi>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Adrian Bunk wrote:

> The issue described in [1] is still present and unfixed (and even the 
> fix there wasn't complete since it didn't cover SMP).

Damn, this slipped through my attention completely. Hotfix (which can
be easily backported) below.
 
> Thanks to Riku Voipio for noting that it is still unfixed.
> 
> cu
> Adrian
> 
> [1] http://lkml.org/lkml/2007/8/1/474

-------->

Subject: futex: disable PI/robust on archs w/o valid implementation
From: Thomas Gleixner <tglx@linutronix.de>

We have to disable the complete PI/robust functionality for those
archs, which do not implement futex_atomic_cmpxchg_inatomic(). The
code in question relies on a valid implementation and does not expect
-ENOSYS, which is returned by the stub implementation in
asm-generic/futex.h

Pointed out by: Mikael Pettersson, Riku Voipio and Adrian Bunk

This patch is intended for easy backporting and needs to be cleaned up
further for current mainline.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-generic/futex.h |    2 ++
 kernel/futex.c              |   13 +++++++++++++
 2 files changed, 15 insertions(+)

Index: linux-2.6/include/asm-generic/futex.h
===================================================================
--- linux-2.6.orig/include/asm-generic/futex.h
+++ linux-2.6/include/asm-generic/futex.h
@@ -55,5 +55,7 @@ futex_atomic_cmpxchg_inatomic(int __user
 	return -ENOSYS;
 }
 
+#define FUTEX_ATOMIC_CMPXCHG_NOT_IMPLEMENTED
+
 #endif
 #endif
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1870,6 +1870,9 @@ asmlinkage long
 sys_set_robust_list(struct robust_list_head __user *head,
 		    size_t len)
 {
+#ifdef FUTEX_ATOMIC_CMPXCHG_NOT_IMPLEMENTED
+	return -ENOSYS;
+#else
 	/*
 	 * The kernel knows only one size for now:
 	 */
@@ -1879,6 +1882,7 @@ sys_set_robust_list(struct robust_list_h
 	current->robust_list = head;
 
 	return 0;
+#endif
 }
 
 /**
@@ -1891,6 +1895,9 @@ asmlinkage long
 sys_get_robust_list(int pid, struct robust_list_head __user * __user *head_ptr,
 		    size_t __user *len_ptr)
 {
+#ifdef FUTEX_ATOMIC_CMPXCHG_NOT_IMPLEMENTED
+	return -ENOSYS;
+#else
 	struct robust_list_head __user *head;
 	unsigned long ret;
 
@@ -1920,6 +1927,7 @@ err_unlock:
 	rcu_read_unlock();
 
 	return ret;
+#endif
 }
 
 /*
@@ -2082,6 +2090,9 @@ long do_futex(u32 __user *uaddr, int op,
 	case FUTEX_WAKE_OP:
 		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
 		break;
+
+#ifndef FUTEX_ATOMIC_CMPXCHG_NOT_IMPLEMENTED
+
 	case FUTEX_LOCK_PI:
 		ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
 		break;
@@ -2091,6 +2102,8 @@ long do_futex(u32 __user *uaddr, int op,
 	case FUTEX_TRYLOCK_PI:
 		ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
 		break;
+#endif
+
 	default:
 		ret = -ENOSYS;
 	}
