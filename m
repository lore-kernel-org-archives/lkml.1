Return-Path: <linux-kernel-owner+w=401wt.eu-S1762753AbXEPSoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762753AbXEPSoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761620AbXEPSnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:43:55 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:40229 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761123AbXEPSny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:43:54 -0400
Subject: [PATCH] Avoid zero size allocation in cache_k8_northbridges()
From: Ben Collins <ben.collins@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@osdl.org>
Content-Type: text/plain
Organization: Canonical
Date: Wed, 16 May 2007 14:44:02 -0400
Message-Id: <1179341042.6870.280.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc for flush_words resulted in zero size allocation when no
k8_northbridges existed. Short circuit the code path for this case.

Also remove uneeded zeroing of num_k8_northbridges just after checking
if it is zero.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>

diff --git a/arch/x86_64/kernel/k8.c b/arch/x86_64/kernel/k8.c
index bc11b32..7377ccb 100644
--- a/arch/x86_64/kernel/k8.c
+++ b/arch/x86_64/kernel/k8.c
@@ -39,10 +39,10 @@ int cache_k8_northbridges(void)
 {
 	int i;
 	struct pci_dev *dev;
+
 	if (num_k8_northbridges)
 		return 0;
 
-	num_k8_northbridges = 0;
 	dev = NULL;
 	while ((dev = next_k8_northbridge(dev)) != NULL)
 		num_k8_northbridges++;
@@ -52,6 +52,11 @@ int cache_k8_northbridges(void)
 	if (!k8_northbridges)
 		return -ENOMEM;
 
+	if (!num_k8_northbridges) {
+		k8_northbridges[0] = NULL;
+		return 0;
+	}
+
 	flush_words = kmalloc(num_k8_northbridges * sizeof(u32), GFP_KERNEL);
 	if (!flush_words) {
 		kfree(k8_northbridges);


-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

