Return-Path: <linux-kernel-owner+w=401wt.eu-S933429AbXIKGmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbXIKGmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933395AbXIKGj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:39:59 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:44385 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375AbXIKGj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:39:57 -0400
Date: Tue, 11 Sep 2007 15:39:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] hrtimer: Build fix for !KTIME_SCALAR on 32bit.
Message-ID: <20070911063947.GA18918@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On BITS_PER_LONG < 64 and !CONFIG_KTIME_SCALAR we get this:

  CC      kernel/hrtimer.o
kernel/hrtimer.c:303: error: redefinition of '__kstrtab_ktime_add_ns'
kernel/hrtimer.c:279: error: previous definition of '__kstrtab_ktime_add_ns' was here
kernel/hrtimer.c:303: error: redefinition of '__ksymtab_ktime_add_ns'
kernel/hrtimer.c:279: error: previous definition of '__ksymtab_ktime_add_ns' was here
kernel/hrtimer.c:313: error: redefinition of 'ktime_sub_ns'
kernel/hrtimer.c:289: error: previous definition of 'ktime_sub_ns' was here
make[1]: *** [kernel/hrtimer.o] Error 1
make: *** [kernel] Error 2

For some reason the ktime_sub_ns() addition was duplicated, and someone
forgot to change the name of the ktime_add_ns() symbol export they lifted.

Get it building again.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 kernel/hrtimer.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- linux-2.6.23-rc4-mm1.orig/kernel/hrtimer.c	2007-09-11 15:15:56.000000000 +0900
+++ linux-2.6.23-rc4-mm1/kernel/hrtimer.c	2007-09-11 15:30:20.000000000 +0900
@@ -300,30 +300,6 @@
 	return ktime_sub(kt, tmp);
 }
 
-EXPORT_SYMBOL_GPL(ktime_add_ns);
-
-/**
- * ktime_sub_ns - Subtract a scalar nanoseconds value from a ktime_t variable
- * @kt:		minuend
- * @nsec:	the scalar nsec value to subtract
- *
- * Returns the subtraction of @nsec from @kt in ktime_t format
- */
-ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
-{
-	ktime_t tmp;
-
-	if (likely(nsec < NSEC_PER_SEC)) {
-		tmp.tv64 = nsec;
-	} else {
-		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
-
-		tmp = ktime_set((long)nsec, rem);
-	}
-
-	return ktime_sub(kt, tmp);
-}
-
 EXPORT_SYMBOL_GPL(ktime_sub_ns);
 # endif /* !CONFIG_KTIME_SCALAR */
 
