Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbYENPtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbYENPtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYENPsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:48:22 -0400
Received: from gw.goop.org ([64.81.55.164]:49800 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760628AbYENPsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:48:21 -0400
Message-ID: <482B09B9.5090509@goop.org>
Date: Wed, 14 May 2008 16:48:09 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] always_inline timespec_add_ns
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timespec_add_ns is used from the x86-64 vdso, which cannot call out to
other kernel code.  Make sure that timespec_add_ns is always inlined
(and only uses always_inlined functions) to make sure there are no
unexpected calls.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/time.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

===================================================================
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -170,10 +170,13 @@
  * timespec_add_ns - Adds nanoseconds to a timespec
  * @a:		pointer to timespec to be incremented
  * @ns:		unsigned nanoseconds value to be added
+ *
+ * This must always be inlined because its used from the x86-64 vdso,
+ * which cannot call other kernel functions.
  */
-static inline void timespec_add_ns(struct timespec *a, u64 ns)
+static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 {
-	a->tv_sec += iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
+	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
 	a->tv_nsec = ns;
 }
 #endif /* __KERNEL__ */


