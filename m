Return-Path: <linux-kernel-owner+w=401wt.eu-S1765214AbZD3RYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765214AbZD3RYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764451AbZD3RHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:54 -0400
Received: from kroah.org ([198.145.64.141]:56378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764589AbZD3RHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:44 2009
Message-Id: <20090430165743.983264626@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Paul Mackerras <paulus@samba.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 38/88] powerpc: Fix data-corrupting bug in __futex_atomic_op
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0068-powerpc-Fix-data-corrupting-bug-in-__futex_atomic_o.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mackerras <paulus@samba.org>

upstream commit: 306a82881b14d950d59e0b59a55093a07d82aa9a

Richard Henderson pointed out that the powerpc __futex_atomic_op has a
bug: it will write the wrong value if the stwcx. fails and it has to
retry the lwarx/stwcx. loop, since 'oparg' will have been overwritten
by the result from the first time around the loop.  This happens
because it uses the same register for 'oparg' (an input) as it uses
for the result.

This fixes it by using separate registers for 'oparg' and 'ret'.

Cc: stable@kernel.org
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/include/asm/futex.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -27,7 +27,7 @@
 	PPC_LONG "1b,4b,2b,4b\n" \
 	".previous" \
 	: "=&r" (oldval), "=&r" (ret) \
-	: "b" (uaddr), "i" (-EFAULT), "1" (oparg) \
+	: "b" (uaddr), "i" (-EFAULT), "r" (oparg) \
 	: "cr0", "memory")
 
 static inline int futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
@@ -47,19 +47,19 @@ static inline int futex_atomic_op_inuser
 
 	switch (op) {
 	case FUTEX_OP_SET:
-		__futex_atomic_op("", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("mr %1,%4\n", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op("add %1,%0,%1\n", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("add %1,%0,%4\n", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_OR:
-		__futex_atomic_op("or %1,%0,%1\n", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("or %1,%0,%4\n", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_atomic_op("andc %1,%0,%1\n", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("andc %1,%0,%4\n", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_XOR:
-		__futex_atomic_op("xor %1,%0,%1\n", ret, oldval, uaddr, oparg);
+		__futex_atomic_op("xor %1,%0,%4\n", ret, oldval, uaddr, oparg);
 		break;
 	default:
 		ret = -ENOSYS;


