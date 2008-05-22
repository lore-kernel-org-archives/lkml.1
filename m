Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYEVDUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYEVDUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbYEVDU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:20:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbYEVDU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:20:27 -0400
Message-ID: <4834E639.2010209@cn.fujitsu.com>
Date: Thu, 22 May 2008 11:19:21 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, morgan@kernel.org,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org,
       ltp-list@lists.sourceforge.net
Subject: [PATCH] fix sys_prctl() returned uninitialized value
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we test kernel by the latest LTP(20080430) on ia64,
the following failure occured:
-------------------------------------
prctl01     1  PASS  :  Test Passed
prctl01     0  WARN  :  prctl() returned 2048 errno = 0 : Success
prctl01     1  PASS  :  Test Passed
prctl01     2  FAIL  :  Test Failed
-------------------------------------

We found commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
causes this failure by git-bisect.
And, we found 'error' has not been initialized in the function 
sys_prctl()(kernel/sys.c). When the capability module is not taking
responsibility for this call, sys_prctl() may return a wrong value.

Now, i fixed it.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
---
diff --git a/kernel/sys.c b/kernel/sys.c
index 895d2d4..26eb0f7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1652,7 +1652,7 @@ asmlinkage long sys_umask(int mask)
 asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5)
 {
-	long uninitialized_var(error);
+	long error = 0;
 
 	if (security_task_prctl(option, arg2, arg3, arg4, arg5, &error))
 		return error;

