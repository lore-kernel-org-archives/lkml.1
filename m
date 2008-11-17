Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYKQTLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYKQTLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 14:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYKQTLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 14:11:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54511 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKQTLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 14:11:05 -0500
Message-Id: <20081117191059.408002035@goodmis.org>
References: <20081117190948.619751203@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 17 Nov 2008 14:09:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] ftrace,ppc: fix test of 24bit jump
Content-Disposition: inline; filename=0002-ftrace-ppc-fix-test-of-24bit-jump.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix of test if an address is 26 bits away or not

Paul Mackerras pointed out that the test of the 24bit offset jump was
incorrect. For one thing, it is a 26 bit distance since we multiply
by 4 to account for the alignment. Another is that it may produce an
incorrect result on a negative jump of exactly the offset size.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 9360fd1..918a5d2 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -114,12 +114,19 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
  */
 static int test_24bit_addr(unsigned long ip, unsigned long addr)
 {
-	unsigned long diff;
+	long diff;
 
-	/* can we get to addr from ip in 24 bits? */
-	diff = ip > addr ? ip - addr : addr - ip;
+	/*
+	 * Can we get to addr from ip in 24 bits?
+	 *  (26 really, since we mulitply by 4 for 4 byte alignment)
+	 */
+	diff = addr - ip;
 
-	return !(diff & ((unsigned long)-1 << 24));
+	/*
+	 * Return true if diff is less than 1 << 25
+	 *  and greater than -1 << 26.
+	 */
+	return (diff < (1 << 25)) && (diff > (-1 << 26));
 }
 
 static int is_bl_op(unsigned int op)
-- 
1.5.6.5

-- 
