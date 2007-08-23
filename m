Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXHWWcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXHWWcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932540AbXHWW24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50805 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbXHWW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:54 -0400
Date: Thu, 23 Aug 2007 15:26:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/28] Fix soft-fp underflow handling.
Message-ID: <20070823222648.GL18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-soft-fp-underflow-handling.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Miller <davem@davemloft.net>

The underflow exception cases were wrong.

This is one weird area of ieee1754 handling in that the underflow
behavior changes based upon whether underflow is enabled in the trap
enable mask of the FPU control register.  As a specific case the Sparc
V9 manual gives us the following description:

--------------------
If UFM = 0:     Underflow occurs if a nonzero result is tiny and a
                loss of accuracy occurs.  Tininess may be detected
                before or after rounding.  Loss of accuracy may be
                either a denormalization loss or an inexact result.

If UFM = 1:     Underflow occurs if a nonzero result is tiny.
                Tininess may be detected before or after rounding.
--------------------

What this amounts to in the packing case is if we go subnormal,
we set underflow if any of the following are true:

1) rounding sets inexact
2) we ended up rounding back up to normal (this is the case where
   we set the exponent to 1 and set the fraction to zero), this
   should set inexact too
3) underflow is set in FPU control register trap-enable mask

The initially discovered example was "DBL_MIN / 16.0" which
incorrectly generated an underflow.  It should not, unless underflow
is set in the trap-enable mask of the FPU csr.

Another example, "0x0.0000000000001p-1022 / 16.0", should signal both
inexact and underflow.  The cpu implementations and ieee1754
literature is very clear about this.  This is case #2 above.

However, if underflow is set in the trap enable mask, only underflow
should be set and reported as a trap.  That is handled properly by the
prioritization logic in

arch/sparc{,64}/math-emu/math.c:record_exception().

Based upon a report and test case from Jakub Jelinek.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-sparc/sfp-machine.h   |    6 ++++++
 include/asm-sparc64/sfp-machine.h |    2 ++
 include/math-emu/op-common.h      |    5 ++++-
 include/math-emu/soft-fp.h        |    7 +++++++
 4 files changed, 19 insertions(+), 1 deletion(-)

--- a/include/asm-sparc/sfp-machine.h
+++ b/include/asm-sparc/sfp-machine.h
@@ -203,4 +203,10 @@ extern struct task_struct *last_task_use
 #define FP_INHIBIT_RESULTS ((last_task_used_math->thread.fsr >> 23) & _fex)
 #endif
 
+#ifdef CONFIG_SMP
+#define FP_TRAPPING_EXCEPTIONS ((current->thread.fsr >> 23) & 0x1f)
+#else
+#define FP_TRAPPING_EXCEPTIONS ((last_task_used_math->thread.fsr >> 23) & 0x1f)
+#endif
+
 #endif
--- a/include/asm-sparc64/sfp-machine.h
+++ b/include/asm-sparc64/sfp-machine.h
@@ -88,4 +88,6 @@
 
 #define FP_INHIBIT_RESULTS ((current_thread_info()->xfsr[0] >> 23) & _fex)
 
+#define FP_TRAPPING_EXCEPTIONS ((current_thread_info()->xfsr[0] >> 23) & 0x1f)
+
 #endif
--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -145,13 +145,16 @@ do {								\
 	      {							\
 	        X##_e = 1;					\
 	        _FP_FRAC_SET_##wc(X, _FP_ZEROFRAC_##wc);	\
+	        FP_SET_EXCEPTION(FP_EX_INEXACT);		\
 	      }							\
 	    else						\
 	      {							\
 		X##_e = 0;					\
 		_FP_FRAC_SRL_##wc(X, _FP_WORKBITS);		\
-		FP_SET_EXCEPTION(FP_EX_UNDERFLOW);		\
 	      }							\
+	    if ((FP_CUR_EXCEPTIONS & FP_EX_INEXACT) ||		\
+		(FP_TRAPPING_EXCEPTIONS & FP_EX_UNDERFLOW))	\
+		FP_SET_EXCEPTION(FP_EX_UNDERFLOW);		\
 	  }							\
 	else							\
 	  {							\
--- a/include/math-emu/soft-fp.h
+++ b/include/math-emu/soft-fp.h
@@ -97,12 +97,19 @@
 #define FP_INHIBIT_RESULTS 0
 #endif
 
+#ifndef FP_TRAPPING_EXCEPTIONS
+#define FP_TRAPPING_EXCEPTIONS 0
+#endif
+
 #define FP_SET_EXCEPTION(ex)				\
   _fex |= (ex)
   
 #define FP_UNSET_EXCEPTION(ex)				\
   _fex &= ~(ex)
 
+#define FP_CUR_EXCEPTIONS				\
+  (_fex)
+
 #define FP_CLEAR_EXCEPTIONS				\
   _fex = 0
 

-- 
