Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYG3WP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYG3WP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYG3WPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:15:12 -0400
Received: from aun.it.uu.se ([130.238.12.36]:43458 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbYG3WPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:15:10 -0400
Date: Thu, 31 Jul 2008 00:14:58 +0200 (MEST)
Message-Id: <200807302214.m6UMEw7l000936@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: davem@davemloft.net
Subject: [PATCH 2.6.27-rc1] sparc64: FUTEX_OP_ANDN fix
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct sparc64's implementation of FUTEX_OP_ANDN to do a
bitwise negate of the oparg parameter before applying the
AND operation. All other archs that support FUTEX_OP_ANDN
either negate oparg explicitly (frv, ia64, mips, sh, x86),
or do so indirectly by using an and-not instruction (powerpc).
Since sparc64 has and-not, I chose to use that solution.

I've not found any use of FUTEX_OP_ANDN in glibc so the
impact of this bug is probably minor. But other user-space
components may try to use it so it should still get fixed.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---

diff -rupN linux-2.6.27-rc1/arch/sparc/include/asm/futex_64.h linux-2.6.27-rc1.sparc64-FUTEX_OP_ANDN-fix/arch/sparc/include/asm/futex_64.h
--- linux-2.6.27-rc1/arch/sparc/include/asm/futex_64.h	2008-07-29 10:40:10.000000000 +0200
+++ linux-2.6.27-rc1.sparc64-FUTEX_OP_ANDN-fix/arch/sparc/include/asm/futex_64.h	2008-07-30 22:22:43.000000000 +0200
@@ -59,7 +59,7 @@ static inline int futex_atomic_op_inuser
 		__futex_cas_op("or\t%2, %4, %1", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_cas_op("and\t%2, %4, %1", ret, oldval, uaddr, oparg);
+		__futex_cas_op("andn\t%2, %4, %1", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_XOR:
 		__futex_cas_op("xor\t%2, %4, %1", ret, oldval, uaddr, oparg);
