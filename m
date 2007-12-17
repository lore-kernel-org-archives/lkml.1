Return-Path: <linux-kernel-owner+w=401wt.eu-S933206AbXLQBs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206AbXLQBs0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 20:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760953AbXLQBsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 20:48:19 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:26723 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760352AbXLQBsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 20:48:18 -0500
Date: Mon, 17 Dec 2007 10:48:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: div64: Rework 64-bit type safety checks in do_div().
Message-ID: <20071217014805.GA15156@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current do_div() implementation has a bogus pointer compare to
generate build warnings on mismatch on 32-bit, unfortunately this not
only triggers for size mismatch, but also _any_ type mismatch, even on
reasonable 64-bit values:

In file included from kernel/sched.c:869:
kernel/sched_debug.c: In function 'nsec_high':
kernel/sched_debug.c:38: warning: comparison of distinct pointer types lacks a cast
kernel/sched_debug.c:41: warning: comparison of distinct pointer types lacks a cast
kernel/sched_debug.c: In function 'nsec_low':
kernel/sched_debug.c:51: warning: comparison of distinct pointer types lacks a cast
...

The options are to either 'fix' all callers of do_div() to make sure
they're using a uint64_t explicitly, or to update do_div() to make sure
that the value is 64-bits, regardless of specific type. Currently
everything that uses the generic do_div() causes a warning when using one
of 'u64', 'long long', etc. instead of 'uint64_t'.

Half-assed empirical testing indicates that the number of false positives
far outweighs any benefits of this type of checking:

$ git grep uint64_t | wc -l
947
$ git grep u64 | wc -l
13942

In short, screw uint64_t and its fan club.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/asm-generic/div64.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
index a4a4937..63e7768 100644
--- a/include/asm-generic/div64.h
+++ b/include/asm-generic/div64.h
@@ -19,6 +19,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/kernel.h>
 
 #if BITS_PER_LONG == 64
 
@@ -39,13 +40,11 @@ static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
 
 extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
 
-/* The unnecessary pointer compare is there
- * to check for type safety (n must be 64bit)
- */
+/* The BUILD_BUG_ON() is there to check for type safety (n must be 64bit) */
 # define do_div(n,base) ({				\
 	uint32_t __base = (base);			\
 	uint32_t __rem;					\
-	(void)(((typeof((n)) *)0) == ((uint64_t *)0));	\
+	BUILD_BUG_ON(sizeof(n) != sizeof(uint64_t));	\
 	if (likely(((n) >> 32) == 0)) {			\
 		__rem = (uint32_t)(n) % __base;		\
 		(n) = (uint32_t)(n) / __base;		\
