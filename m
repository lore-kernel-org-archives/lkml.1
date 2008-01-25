Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYAYIH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYAYIH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763762AbYAYH7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:55 -0500
Received: from mail.suse.de ([195.135.220.2]:59393 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763593AbYAYH7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tony Luck <tony.luck@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 124/196] Kobject: change arch/ia64/kernel/topology.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:33 -0800
Message-Id: <1201246425-5058-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/ia64/kernel/topology.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index 14261fe..c4311e3 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -354,17 +354,16 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	if (unlikely(retval < 0))
 		return retval;
 
-	all_cpu_cache_info[cpu].kobj.parent = &sys_dev->kobj;
-	kobject_set_name(&all_cpu_cache_info[cpu].kobj, "%s", "cache");
-	all_cpu_cache_info[cpu].kobj.ktype = &cache_ktype_percpu_entry;
-	retval = kobject_register(&all_cpu_cache_info[cpu].kobj);
+	retval = kobject_init_and_add(&all_cpu_cache_info[cpu].kobj,
+				      &cache_ktype_percpu_entry, &sys_dev->kobj,
+				      "%s", "cache");
 
 	for (i = 0; i < all_cpu_cache_info[cpu].num_cache_leaves; i++) {
 		this_object = LEAF_KOBJECT_PTR(cpu,i);
-		this_object->kobj.parent = &all_cpu_cache_info[cpu].kobj;
-		kobject_set_name(&(this_object->kobj), "index%1lu", i);
-		this_object->kobj.ktype = &cache_ktype;
-		retval = kobject_register(&(this_object->kobj));
+		retval = kobject_init_and_add(&(this_object->kobj),
+					      &cache_ktype,
+					      &all_cpu_cache_info[cpu].kobj,
+					      "index%1lu", i);
 		if (unlikely(retval)) {
 			for (j = 0; j < i; j++) {
 				kobject_unregister(
@@ -374,7 +373,9 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 			cpu_cache_sysfs_exit(cpu);
 			break;
 		}
+		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
 	}
+	kobject_uevent(&all_cpu_cache_info[cpu].kobj, KOBJ_ADD);
 	return retval;
 }
 
-- 
1.5.3.8

