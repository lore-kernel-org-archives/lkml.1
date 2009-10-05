Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZJEGfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZJEGfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:35:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZJEGfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:35:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56053 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbZJEGfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:35:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC99361.6060906@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:34:09 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/10] x86, mce: mce_read can check args without mutex
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it before mutex_lock().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 28e1e14..2d0f9d8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1458,15 +1458,12 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	unsigned prev, next;
 	int i, err;
 
-	mutex_lock(&mce_read_mutex);
-	next = rcu_dereference(mcelog.next);
-
 	/* Only supports full reads right now */
-	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
-		mutex_unlock(&mce_read_mutex);
-
+	if (*off != 0 || usize < sizeof(struct mce) * MCE_LOG_LEN)
 		return -EINVAL;
-	}
+
+	mutex_lock(&mce_read_mutex);
+	next = rcu_dereference(mcelog.next);
 
 	err = 0;
 	prev = 0;
-- 
1.6.4.3


