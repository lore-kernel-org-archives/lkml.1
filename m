Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbZI1Gyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbZI1Gyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZI1Gyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:54:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42843 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZI1Gyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:54:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC05D99.7090805@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 15:54:17 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] mce-inject: allow injecting status=0 to poll handler
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com>
In-Reply-To: <4AC05BBF.3010102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can inject void data to exception handler by writing data with
status=0 and flag=MCE_INJ_EXCEPTION.  But without this patch we cannot
do same to poll handler by status=0 and flag=!MCE_INJ_EXCEPTION.

This change will allow us to test behavior of poll handler with no
data.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 7691c52..2eeb034 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -96,7 +96,7 @@ static int mce_raise_notify(struct notifier_block *self,
 
 	if (m->inject_flags & MCE_INJ_EXCEPTION)
 		raise_exception(m, args->regs);
-	else if (m->status)
+	else
 		raise_poll(m);
 
 	return NOTIFY_STOP;
@@ -136,13 +136,12 @@ static int raise_local(void)
 			ret = -EINVAL;
 		}
 		printk(KERN_INFO "MCE exception done on CPU %d\n", cpu);
-	} else if (m->status) {
+	} else {
 		printk(KERN_INFO "Starting machine check poll CPU %d\n", cpu);
 		raise_poll(m);
 		mce_notify_irq();
 		printk(KERN_INFO "Machine check poll done on CPU %d\n", cpu);
-	} else
-		m->valid = 0;
+	}
 
 	return ret;
 }
-- 
1.6.4.3


