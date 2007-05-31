Return-Path: <linux-kernel-owner+w=401wt.eu-S1758989AbXEaHXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989AbXEaHXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 03:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbXEaHXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 03:23:25 -0400
Received: from ozlabs.org ([203.10.76.45]:49500 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbXEaHXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 03:23:25 -0400
Subject: [PATCH 1/3] lguest: speed up PARAVIRT_LAZY_FLUSH handling
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 31 May 2007 17:23:11 +1000
Message-Id: <1180596191.11133.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When Zach Amsden added PARAVIRT_LAZY_FLUSH I didn't realize how often
it would get called.  We only need to do something if we're actually
in lazy mode.

Before:
Time for one context switch via pipe: 10509 (9863 - 18761)
Time for one Copy-on-Write fault: 71796 (20625 - 207750)
Time to exec client once: 1076218 (1066203 - 1085937)
Time for one fork/exit/wait: 1193125 (574750 - 1197750)
Time for two PTE updates: 10844 (10659 - 20703)

After:
Time for one context switch via pipe: 6745 (6521 - 13966)
Time for one Copy-on-Write fault: 44734 (11468 - 91988)
Time to exec client once: 815984 (801218 - 878218)
Time for one fork/exit/wait: 1023250 (397687 - 1030375)
Time for two PTE updates: 6699 (6475 - 9279)

(Native for comparison):
Time for one context switch via pipe: 4031 (3212 - 4146)
Time for one Copy-on-Write fault: 4402 (4388 - 4426)
Time to exec client once: 343859 (336859 - 349484)
Time for one fork/exit/wait: 120234 (118500 - 136140)
Time for two PTE updates: 2269 (2261 - 2272)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 077496256739 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Thu May 31 16:34:17 2007 +1000
+++ b/drivers/lguest/lguest.c	Thu May 31 16:36:23 2007 +1000
@@ -58,9 +58,10 @@ static enum paravirt_lazy_mode lazy_mode
 static enum paravirt_lazy_mode lazy_mode;
 static void lguest_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	if (mode == PARAVIRT_LAZY_FLUSH)
-		hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
-	else {
+	if (mode == PARAVIRT_LAZY_FLUSH) {
+		if (unlikely(lazy_mode != PARAVIRT_LAZY_NONE))
+			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
+	} else {
 		lazy_mode = mode;
 		if (mode == PARAVIRT_LAZY_NONE)
 			hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);


