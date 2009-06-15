Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbZFOITJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbZFOITJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbZFOISv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:18:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45398 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbZFOISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:18:50 -0400
Message-ID: <4A3603E5.3030408@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:18:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 01/16] x86, mce: don't init timer if !mce_available
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mce_cpu_restart, mce_init_timer is called unconditionally.
If !mce_available (e.g. mce is disabled), there are no useful work
for timer.  Stop running it.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index fabba15..6f9db11 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1609,8 +1609,9 @@ static int mce_resume(struct sys_device *dev)
 static void mce_cpu_restart(void *data)
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
-	if (mce_available(&current_cpu_data))
-		mce_init();
+	if (!mce_available(&current_cpu_data))
+		return;
+	mce_init();
 	mce_init_timer();
 }
 
-- 
1.6.3


