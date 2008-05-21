Return-Path: <linux-kernel-owner+w=401wt.eu-S932999AbYEUJix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999AbYEUJix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbYEUJio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:38:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756011AbYEUJin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:38:43 -0400
Message-ID: <4833ED6D.8030606@cn.fujitsu.com>
Date: Wed, 21 May 2008 17:37:49 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: morgan@kernel.org, linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, serue@us.ibm.com,
       jmorris@namei.org
Subject: [PATCH] capabilities: fix sys_prctl() returned uninitialized value
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
And, we found *rc_p has not been initialized if switch-default 
of the function cap_task_prctl()(security/commoncap.c). When *rc_p
uninitialized, sys_prctl() will return a wrong value.

Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
---
diff --git a/security/commoncap.c b/security/commoncap.c
index 5edabc7..a4b28c8 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -649,6 +649,7 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 
 	default:
 		/* No functionality available - continue with default */
+		*rc_p = 0;
 		return 0;
 	}
 




