Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYBNPoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYBNPoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbYBNPj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:39:29 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:49928 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753437AbYBNPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:39:14 -0500
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
       =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
Subject: [PATCH 12/14] fs/binfmt_aout.c: Use time_* macros
Date: Thu, 14 Feb 2008 17:36:50 +0200
Message-Id: <1203003412-11594-13-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: y
References: y
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: linux-arch@vger.kernel.org
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 fs/binfmt_aout.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index a1bb224..72757fe 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -6,6 +6,7 @@
 
 #include <linux/module.h>
 
+#include <linux/jiffies.h>
 #include <linux/time.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -374,14 +375,14 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	} else {
 		static unsigned long error_time, error_time2;
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
-		    (N_MAGIC(ex) != NMAGIC) && (jiffies-error_time2) > 5*HZ)
+		    (N_MAGIC(ex) != NMAGIC) && time_after(jiffies, error_time2 + 5 * HZ))
 		{
 			printk(KERN_NOTICE "executable not page aligned\n");
 			error_time2 = jiffies;
 		}
 
 		if ((fd_offset & ~PAGE_MASK) != 0 &&
-		    (jiffies-error_time) > 5*HZ)
+		    time_after(jiffies, error_time + 5 * HZ))
 		{
 			printk(KERN_WARNING 
 			       "fd_offset is not page aligned. Please convert program: %s\n",
@@ -498,7 +499,7 @@ static int load_aout_library(struct file *file)
 		static unsigned long error_time;
 		loff_t pos = N_TXTOFF(ex);
 
-		if ((jiffies-error_time) > 5*HZ)
+		if (time_after(jiffies ,error_time + 5 * HZ))
 		{
 			printk(KERN_WARNING 
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
-- 
1.5.3.7

