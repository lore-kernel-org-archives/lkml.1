Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYDQCKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYDQCKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 22:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYDQCKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 22:10:07 -0400
Received: from sous-sol.org ([216.99.217.87]:54950 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYDQCKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 22:10:05 -0400
Message-Id: <20080417010400.234642889@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Parisc List <linux-parisc@vger.kernel.org>,
       Kyle McMartin <kyle@shortfin.cabal.ca>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: PARISC futex: special case cmpxchg NULL in kernel space
Content-Disposition: inline; filename=parisc-futex-special-case-cmpxchg-null-in-kernel-space.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Kyle McMartin <kyle@shortfin.cabal.ca>

upstream commit: c20a84c91048c76c1379011c96b1a5cee5c7d9a0

commit f9e77acd4060fefbb60a351cdb8d30fca27fe194
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sun Feb 24 02:10:05 2008 +0000

    futex: runtime enable pi and robust functionality
 

which was backported to stable based on mainline Commit
a0c1e9073ef7428a14309cba010633a6cd6719ea added code to futex.c
to detect whether futex_atomic_cmpxchg_inatomic was implemented at run
time:

+       curval = cmpxchg_futex_value_locked(NULL, 0, 0);
+       if (curval == -EFAULT)
+               futex_cmpxchg_enabled = 1;

This is bogus on parisc, since page zero in kernel virtual space is the
gateway page for syscall entry, and should not be read from the kernel.
(That, and we really don't like the kernel faulting on its own address
 space...)

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/asm-parisc/futex.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/asm-parisc/futex.h
+++ b/include/asm-parisc/futex.h
@@ -56,6 +56,12 @@ futex_atomic_cmpxchg_inatomic(int __user
 	int err = 0;
 	int uval;
 
+	/* futex.c wants to do a cmpxchg_inatomic on kernel NULL, which is
+	 * our gateway page, and causes no end of trouble...
+	 */
+	if (segment_eq(KERNEL_DS, get_fs()) && !uaddr)
+		return -EFAULT;
+
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
@@ -67,5 +73,5 @@ futex_atomic_cmpxchg_inatomic(int __user
 	return uval;
 }
 
-#endif
-#endif
+#endif /*__KERNEL__*/
+#endif /*_ASM_PARISC_FUTEX_H*/

-- 
