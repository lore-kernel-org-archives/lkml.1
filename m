Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbYAYIEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbYAYIEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764059AbYAYH7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:44 -0500
Received: from mail.suse.de ([195.135.220.2]:59320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764043AbYAYH7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Dominik Brodowski <linux@brodo.de>,
       Ashok Raj <ashok.raj@intel.com>, Jacob Shin <jacob.shin@amd.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 113/196] Kobject: change drivers/cpufreq/cpufreq.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:22 -0800
Message-Id: <1201246425-5058-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Dominik Brodowski <linux@brodo.de>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/cpufreq/cpufreq.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 79581fa..9e102af 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -828,11 +828,8 @@ static int cpufreq_add_dev (struct sys_device * sys_dev)
 	memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
 
 	/* prepare interface data */
-	policy->kobj.parent = &sys_dev->kobj;
-	policy->kobj.ktype = &ktype_cpufreq;
-	kobject_set_name(&policy->kobj, "cpufreq");
-
-	ret = kobject_register(&policy->kobj);
+	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq, &sys_dev->kobj,
+				   "cpufreq");
 	if (ret) {
 		unlock_policy_rwsem_write(cpu);
 		goto err_out_driver_exit;
@@ -902,6 +899,7 @@ static int cpufreq_add_dev (struct sys_device * sys_dev)
 		goto err_out_unregister;
 	}
 
+	kobject_uevent(&policy->kobj, KOBJ_ADD);
 	module_put(cpufreq_driver->owner);
 	dprintk("initialization complete\n");
 	cpufreq_debug_enable_ratelimit();
-- 
1.5.3.8

