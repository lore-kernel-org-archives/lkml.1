Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbXGEQzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbXGEQzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbXGEQzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:55:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:30181 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758934AbXGEQzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Xp34EBEE40EM+woL9JXX3ilKOjBCZNl2fFwrbAJ/ynLJpF6DdHpvRgV3n1YSWYTl3rmu9WnhIiiKSSAnJDeyz1PU1G3Leh1EQBuxfMmD30VwIRkFqIJR9n8lK+wWtvrNot6ouQJrJdODofNS75K/3v9Gu9Fkr1OWIWZXKmTA9VU=
Date: Thu, 5 Jul 2007 20:55:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] Sky Cpu and Nexus: check for platform_get_resource ret
	code
Message-ID: <20070705165508.GD7180@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for platform_get_resource() return
code to prevent possible NULL pointer usage.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    5 +++++
 drivers/misc/hdpuftrs/hdpu_nexus.c    |    7 ++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/hdpuftrs/hdpu_cpustate.c b/drivers/misc/hdpuftrs/hdpu_cpustate.c
index fdd9e2e..51e4963 100644
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c
+++ b/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -195,6 +195,11 @@ static int hdpu_cpustate_probe(struct platform_device *pdev)
 	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		printk(KERN_ERR "sky_cpustate: "
+		       "Invalid memory resource.\n");
+		return -EINVAL;
+	}
 	cpustate.set_addr = (unsigned long *)res->start;
 	cpustate.clr_addr = (unsigned long *)res->end - 1;
 
diff --git a/drivers/misc/hdpuftrs/hdpu_nexus.c b/drivers/misc/hdpuftrs/hdpu_nexus.c
index fda9998..01bc917 100644
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -62,6 +62,11 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 	int *nexus_id_addr;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		printk(KERN_ERR "sky_nexus: "
+		       "Invalid memory resource.\n");
+		return -EINVAL;
+	}
 	nexus_id_addr = ioremap(res->start,
 				(unsigned long)(res->end - res->start));
 	if (nexus_id_addr) {
@@ -69,7 +74,7 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 		chassis_id = *nexus_id_addr & 0xff;
 		iounmap(nexus_id_addr);
 	} else {
-		printk(KERN_ERR "Could not map slot id\n");
+		printk(KERN_ERR "sky_nexus: Could not map slot id\n");
 	}
 
 	hdpu_slot_id = create_proc_entry("sky_slot_id", 0666, &proc_root);
