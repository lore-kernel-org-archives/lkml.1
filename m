Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbZHMUs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbZHMUs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbZHMUs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:48:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:62544 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbZHMUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:48:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABsZhEqrR7O6/2dsb2JhbAC7QogrkRoFhBk
X-IronPort-AV: E=Sophos;i="4.43,376,1246838400"; 
   d="scan'208";a="366937749"
From: Roland Dreier <rdreier@cisco.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Use bool for boolean flag in printk_once()
X-Message-Flag: Warning: May contain useful information
Date: Thu, 13 Aug 2009 13:48:26 -0700
Message-ID: <adak5174ezp.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Aug 2009 20:48:26.0652 (UTC) FILETIME=[680745C0:01CA1C57]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the type bool (instead of int) for the __print_once flag in the
printk_once() macro matches the intent of the code better, and allows
the compiler to generate smaller code; eg a typical callsite with gcc
4.3.3 on i386:

add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-6 (-6)
function                                     old     new   delta
static.__print_once                            4       1      -3
get_cpu_vendor                               146     143      -3

Saving 6 bytes of object size per callsite by slightly improving the
readability of the source seems like a win to me.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 include/linux/kernel.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d6320a3..f828ce9 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -249,10 +249,10 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
 #define printk_once(x...) ({			\
-	static int __print_once = 1;		\
+	static bool __print_once = true;	\
 						\
 	if (__print_once) {			\
-		__print_once = 0;		\
+		__print_once = false;		\
 		printk(x);			\
 	}					\
 })
