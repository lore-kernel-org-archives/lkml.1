Return-Path: <linux-kernel-owner+w=401wt.eu-S1765323AbYAYIOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765323AbYAYIOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764121AbYAYIAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763894AbYAYH7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ashok Raj <ashok.raj@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 118/196] Kobject: change arch/x86/kernel/cpu/intel_cacheinfo.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:27 -0800
Message-Id: <1201246425-5058-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 9f530ff..3509542 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -733,10 +733,8 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 	if (unlikely(retval < 0))
 		return retval;
 
-	cache_kobject[cpu]->parent = &sys_dev->kobj;
-	kobject_set_name(cache_kobject[cpu], "%s", "cache");
-	cache_kobject[cpu]->ktype = &ktype_percpu_entry;
-	retval = kobject_register(cache_kobject[cpu]);
+	retval = kobject_init_and_add(cache_kobject[cpu], &ktype_percpu_entry,
+				      &sys_dev->kobj, "%s", "cache");
 	if (retval < 0) {
 		cpuid4_cache_sysfs_exit(cpu);
 		return retval;
@@ -746,10 +744,9 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 		this_object = INDEX_KOBJECT_PTR(cpu,i);
 		this_object->cpu = cpu;
 		this_object->index = i;
-		this_object->kobj.parent = cache_kobject[cpu];
-		kobject_set_name(&(this_object->kobj), "index%1lu", i);
-		this_object->kobj.ktype = &ktype_cache;
-		retval = kobject_register(&(this_object->kobj));
+		retval = kobject_init_and_add(&(this_object->kobj),
+					      &ktype_cache, cache_kobject[cpu],
+					      "index%1lu", i);
 		if (unlikely(retval)) {
 			for (j = 0; j < i; j++) {
 				kobject_unregister(
@@ -759,10 +756,12 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 			cpuid4_cache_sysfs_exit(cpu);
 			break;
 		}
+		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
 	}
 	if (!retval)
 		cpu_set(cpu, cache_dev_map);
 
+	kobject_uevent(cache_kobject[cpu], KOBJ_ADD);
 	return retval;
 }
 
-- 
1.5.3.8

