Return-Path: <linux-kernel-owner+w=401wt.eu-S1763656AbXEVC1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763656AbXEVC1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758228AbXEVC1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:27:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38575 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbXEVC1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:27:35 -0400
Subject: [RFC][PATCH] do_div_signed()
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Elimar Riesebieter <riesebie@lxtec.de>
Content-Type: text/plain
Date: Mon, 21 May 2007 19:27:32 -0700
Message-Id: <1179800853.5910.59.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a quick pass at adding do_div_signed() which provides a signed
version of do_div, avoiding having do_div users hack around signed
issues (like in ntp.c).

It probably could be optimized further, so let me know if you have any
suggestions.


Other thoughts?

thanks
-john


Signed-off-by: John Stultz<johnstul@us.ibm.com>


diff --git a/include/asm-arm/div64.h b/include/asm-arm/div64.h
index 0b5f881..af44e10 100644
--- a/include/asm-arm/div64.h
+++ b/include/asm-arm/div64.h
@@ -225,5 +225,6 @@
 #endif
 
 extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+extern int64_t do_div_signed(int64_t *n, int32_t base);
 
 #endif
diff --git a/include/asm-generic/div64.h b/include/asm-generic/div64.h
index a4a4937..e1cac65 100644
--- a/include/asm-generic/div64.h
+++ b/include/asm-generic/div64.h
@@ -62,4 +62,5 @@ extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 
 #endif /* BITS_PER_LONG */
 
+extern int64_t do_div_signed(int64_t *n, int32_t base);
 #endif /* _ASM_GENERIC_DIV64_H */
diff --git a/include/asm-i386/div64.h b/include/asm-i386/div64.h
index 438e980..05320a5 100644
--- a/include/asm-i386/div64.h
+++ b/include/asm-i386/div64.h
@@ -49,4 +49,5 @@ div_ll_X_l_rem(long long divs, long div, long *rem)
 }
 
 extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+extern int64_t do_div_signed(int64_t *n, int32_t base);
 #endif
diff --git a/include/asm-m68k/div64.h b/include/asm-m68k/div64.h
index 33caad1..3c76059 100644
--- a/include/asm-m68k/div64.h
+++ b/include/asm-m68k/div64.h
@@ -26,4 +26,5 @@
 })
 
 extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+extern int64_t do_div_signed(int64_t *n, int32_t base);
 #endif /* _M68K_DIV64_H */
diff --git a/include/asm-mips/div64.h b/include/asm-mips/div64.h
index 66189f5..851ce40 100644
--- a/include/asm-mips/div64.h
+++ b/include/asm-mips/div64.h
@@ -111,5 +111,6 @@ static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
 }
 
 #endif /* (_MIPS_SZLONG == 64) */
+extern int64_t do_div_signed(int64_t *n, int32_t base);
 
 #endif /* _ASM_DIV64_H */
diff --git a/include/asm-um/div64.h b/include/asm-um/div64.h
index 7b73b2c..1fc4a2c 100644
--- a/include/asm-um/div64.h
+++ b/include/asm-um/div64.h
@@ -4,4 +4,5 @@
 #include "asm/arch/div64.h"
 
 extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+extern int64_t do_div_signed(int64_t *n, int32_t base);
 #endif
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 87aa5ff..7c093ad 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -302,16 +302,11 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj = time_offset * mtemp;
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
-		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
+		    if (mtemp >= MINSEC && 
+		    		(time_status & STA_FLL || mtemp > MAXSEC)) {
 			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
-			if (time_offset < 0) {
-			    temp64 = -temp64;
-			    do_div(temp64, mtemp);
-			    freq_adj -= temp64;
-			} else {
-			    do_div(temp64, mtemp);
-			    freq_adj += temp64;
-			}
+			do_div_signed(&temp64, mtemp);
+			freq_adj += temp64;
 		    }
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
diff --git a/lib/div64.c b/lib/div64.c
index b71cf93..e6ff440 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -79,3 +79,37 @@ uint64_t div64_64(uint64_t dividend, uint64_t divisor)
 EXPORT_SYMBOL(div64_64);
 
 #endif /* BITS_PER_LONG == 32 */
+
+/* Signed 64 bit dividend, result, rem. Signed 32 bit divisor */
+int64_t do_div_signed(int64_t *n, int32_t base)
+{
+	uint64_t num, den;
+	int64_t rem;
+	int num_sign = (*n < 0);
+	int den_sign = (base < 0);
+
+	if (num_sign)
+		num = (uint64_t)(-*n);
+	else
+		num = (uint64_t)*n;
+	
+	/* XXX this is sort of obnoxious,but seems necessary 
+	 * to handle the base possibly being negative as well
+	 */
+	if (den_sign)
+		den = (uint32_t)(-base);
+	else
+	den = (uint32_t)base;
+
+	rem = do_div(num, den);
+
+	*n = (int64_t)num;
+	if(num_sign ^ den_sign)
+		*n = -*n;
+	if(num_sign)
+		rem = -rem;
+
+	return rem;
+}
+
+EXPORT_SYMBOL(do_div_signed);


