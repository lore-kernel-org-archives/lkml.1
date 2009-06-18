Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZFRFxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZFRFxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 01:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFRFx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 01:53:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34177 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZFRFxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 01:53:25 -0400
Message-ID: <4A39D654.3050001@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 14:53:24 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86, mce: fix error path in mce_create_device()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't skip removing mce_attrs in route from error2.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 81f69b7..260e219 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1791,7 +1791,7 @@ static cpumask_var_t mce_dev_initialized;
 static __cpuinit int mce_create_device(unsigned int cpu)
 {
 	int err;
-	int i;
+	int i, j;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
@@ -1809,9 +1809,9 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 		if (err)
 			goto error;
 	}
-	for (i = 0; i < banks; i++) {
+	for (j = 0; j < banks; j++) {
 		err = sysdev_create_file(&per_cpu(mce_dev, cpu),
-					&bank_attrs[i]);
+					&bank_attrs[j]);
 		if (err)
 			goto error2;
 	}
@@ -1819,8 +1819,8 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 
 	return 0;
 error2:
-	while (--i >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &bank_attrs[i]);
+	while (--j >= 0)
+		sysdev_remove_file(&per_cpu(mce_dev, cpu), &bank_attrs[j]);
 error:
 	while (--i >= 0)
 		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
-- 
1.6.3

