Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZBFQth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZBFQth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZBFQt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:49:28 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:5672 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZBFQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:49:27 -0500
Date: Fri, 6 Feb 2009 09:49:06 -0700
From: Alex Chiang <achiang@hp.com>
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ia64: don't need cpu_set() when migrate_platform_irqs()
	fails
Message-ID: <20090206164906.GA2445@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, tony.luck@intel.com,
	linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e7b14036 (prevent ia64 from invoking irq handlers on
offline CPUs) removed the call to cpu_clear() before we call
migrate_platform_irqs().

Thus, if migrate_platform_irqs() fails (returns -EBUSY), we do
not need to re-set our CPU in the cpu_online_map, since it was
never cleared.

Remove the redundant call and cleanup the resulting stylistic
fallout.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

Tony, unlike my previous patch, this patch is .30 material,
thanks.

---

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 1146399..92fe9cf 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -736,10 +736,8 @@ int __cpu_disable(void)
 			return -EBUSY;
 	}
 
-	if (migrate_platform_irqs(cpu)) {
-		cpu_set(cpu, cpu_online_map);
-		return (-EBUSY);
-	}
+	if (migrate_platform_irqs(cpu))
+		return -EBUSY;
 
 	remove_siblinginfo(cpu);
 	fixup_irqs();
