Return-Path: <linux-kernel-owner+w=401wt.eu-S935211AbYBNBje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935211AbYBNBje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763947AbYBNBjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:39:15 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:60929 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761018AbYBNBjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:39:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GwkxVgYy+E0wOby5ShesbFWKDMagZkX6Pcv20WMw9bl1zkVsEcgeEVVMyPNzsBqAG5z452sAA2Omt8iJo0dUI+2yBJt08YMKiENxTZSdDXBcbaPjYBbB3x1s87BAk1bRfg9AGF/o33Y5q5hn3Ad4WpDMa0u/OkVOpIrxPtqWge0=
Message-ID: <47B39BB8.5030703@gmail.com>
Date: Thu, 14 Feb 2008 10:39:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] printk: clean up recursion check related static variables
References: <47B2AE7C.608@gmail.com> <20080213124548.GB6344@elte.hu> <47B38718.4030509@gmail.com>
In-Reply-To: <47B38718.4030509@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make printk_recursion_bug_msg static, drop printk prefix from recurson
variables and move them into vprintk().

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
This is slightly modified version of the clean up part.  I don't think
it's wise to pull out all static variables out of functions.  Thanks.

 kernel/printk.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

Index: work/kernel/printk.c
===================================================================
--- work.orig/kernel/printk.c
+++ work/kernel/printk.c
@@ -613,15 +613,13 @@ asmlinkage int printk(const char *fmt, .
 	return r;
 }
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int printk_cpu = UINT_MAX;
-
-const char printk_recursion_bug_msg [] =
-			KERN_CRIT "BUG: recent printk recursion!\n";
-static int printk_recursion_bug;
-
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
+	/* cpu currently holding logbuf_lock */
+	static volatile unsigned int printk_cpu = UINT_MAX;
+	static const char recursion_bug_msg [] =
+		KERN_CRIT "BUG: recent printk recursion!\n";
+	static int recursion_bug;
 	static int log_level_unknown = 1;
 	static char printk_buf[1024];
 
@@ -649,7 +647,7 @@ asmlinkage int vprintk(const char *fmt, 
 		 * it can be printed at the next appropriate moment:
 		 */
 		if (!oops_in_progress) {
-			printk_recursion_bug = 1;
+			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
 		zap_locks();
@@ -659,10 +657,10 @@ asmlinkage int vprintk(const char *fmt, 
 	spin_lock(&logbuf_lock);
 	printk_cpu = this_cpu;
 
-	if (printk_recursion_bug) {
-		printk_recursion_bug = 0;
-		strcpy(printk_buf, printk_recursion_bug_msg);
-		printed_len = sizeof(printk_recursion_bug_msg);
+	if (recursion_bug) {
+		recursion_bug = 0;
+		strcpy(printk_buf, recursion_bug_msg);
+		printed_len = sizeof(recursion_bug_msg);
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
