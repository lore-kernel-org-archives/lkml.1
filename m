Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbZF2Xk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbZF2Xk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZF2Xkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:40:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:39438 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF2Xku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:40:50 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] powerpc: Fix spin_event_timeout() to be robust over context
	switches
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, timur@freescale.com,
       jonsmirl@gmail.com
Date: Mon, 29 Jun 2009 17:40:51 -0600
Message-ID: <20090629234035.12475.58493.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Current implementation of spin_event_timeout can be interrupted by an
IRQ or context switch after testing the condition, but before checking
the timeout.  This can cause the loop to report a timeout when the
condition actually became true in the middle.

This patch adds one final check of the condition upon exit of the loop
if the last test of the condition was still false.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/powerpc/include/asm/delay.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/arch/powerpc/include/asm/delay.h b/arch/powerpc/include/asm/delay.h
index 1e2eb41..52e4d54 100644
--- a/arch/powerpc/include/asm/delay.h
+++ b/arch/powerpc/include/asm/delay.h
@@ -63,6 +63,8 @@ extern void udelay(unsigned long usecs);
 			udelay(delay);                                         \
 		else                                                           \
 			cpu_relax();                                           \
+	if (!__ret)                                                            \
+		__ret = (condition);                                           \
 	__ret;		                                                       \
 })
 

