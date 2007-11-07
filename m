Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbXKGApZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbXKGApZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXKGApO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:45:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59322 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbXKGApM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:45:12 -0500
Date: Tue, 6 Nov 2007 16:34:54 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@osdl.org>, Stephane Eranian <eranian@hpl.hp.com>
Cc: perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071107003454.GA13374@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch against my current tree that gets the perfmon code
building and hopefully working.

Note, it needs the kobject_create_and_register() patch which is in my
tree, but I do not think it made it to -mm yet.  The next -mm cycle
should have it.

Also, the sysfs usage in the perfmon code is quite strange and not
documented at all.  Yes, there is a little bit in the documentation
about what a few of the files do, but there are _way_ more files and
even directories being created under /sys/kernel/perfmon/ that are not
documented at all here.

If you document this stuff, I think I can clean up your sysfs code a
lot, making things simpler, easier to extend, and easier to understand.
But as it is, I don't want to break anything as it's totally unknown how
this stuff is supposed to work...

Hint, use the Documentation/ABI directory to document your sysfs
interfaces, that is what it is there for...

thanks,

greg k-h

---------------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: perfmon: fix up some static kobject usages

This gets the perfmon code to build properly on the latest -mm tree, as
well as removing some static kobjects.

A lot of future kobject cleanups can be done on this code, but the
documentation for the perfmon sysfs interface is very limited and does
not describe all of the different files and subdirectories at all.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 perfmon/perfmon_sysfs.c |   37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

--- a/perfmon/perfmon_sysfs.c
+++ b/perfmon/perfmon_sysfs.c
@@ -76,7 +76,8 @@ EXPORT_SYMBOL(pfm_controls);
 
 DECLARE_PER_CPU(struct pfm_stats, pfm_stats);
 
-static struct kobject pfm_kernel_kobj, pfm_kernel_fmt_kobj;
+static struct kobject *pfm_kernel_kobj;
+static struct kobject *pfm_kernel_fmt_kobj;
 
 static void pfm_reset_stats(int cpu)
 {
@@ -402,31 +403,23 @@ static struct attribute_group pfm_kernel
 
 int __init pfm_init_sysfs(void)
 {
-	int ret;
+	int ret = -ENOMEM;
 	int i, cpu = -1;
 
-	kobject_init(&pfm_kernel_kobj);
-	kobject_init(&pfm_kernel_fmt_kobj);
-
-	pfm_kernel_kobj.parent = &kernel_subsys.kobj;
-	kobject_set_name(&pfm_kernel_kobj, "perfmon");
-
-	pfm_kernel_fmt_kobj.parent = &pfm_kernel_kobj;
-	kobject_set_name(&pfm_kernel_fmt_kobj, "formats");
-
-	ret = kobject_add(&pfm_kernel_kobj);
-	if (ret) {
-		PFM_INFO("cannot add kernel object: %d", ret);
+	pfm_kernel_kobj = kobject_create_and_register("perfmon", kernel_kobj);
+	if (!pfm_kernel_kobj) {
+		PFM_INFO("cannot create perfmon kernel object");
 		goto error;
 	}
 
-	ret = kobject_add(&pfm_kernel_fmt_kobj);
-	if (ret) {
-		PFM_INFO("cannot add fmt object: %d", ret);
+	pfm_kernel_fmt_kobj = kobject_create_and_register("formats",
+							  pfm_kernel_kobj);
+	if (!pfm_kernel_fmt_kobj) {
+		PFM_INFO("cannot add fmt object");
 		goto error_fmt;
 	}
 
-	ret = sysfs_create_group(&pfm_kernel_kobj, &pfm_kernel_attr_group);
+	ret = sysfs_create_group(pfm_kernel_kobj, &pfm_kernel_attr_group);
 	if (ret) {
 		PFM_INFO("cannot create kernel group");
 		goto error_group;
@@ -449,9 +442,9 @@ int __init pfm_init_sysfs(void)
 	return 0;
 
 error_group:
-	kobject_del(&pfm_kernel_fmt_kobj);
+	kobject_unregister(pfm_kernel_fmt_kobj);
 error_fmt:
-	kobject_del(&pfm_kernel_kobj);
+	kobject_unregister(pfm_kernel_kobj);
 
 	for (i=0; i < cpu; i++)
 		pfm_sysfs_del_cpu(i);
@@ -683,7 +676,7 @@ int pfm_sysfs_add_fmt(struct pfm_smpl_fm
 
 	kobject_set_name(&fmt->kobj, fmt->fmt_name);
 	//kobj_set_kset_s(fmt, pfm_fmt_subsys);
-	fmt->kobj.parent = &pfm_kernel_fmt_kobj;
+	fmt->kobj.parent = pfm_kernel_fmt_kobj;
 
 	ret = kobject_add(&fmt->kobj);
 	if (ret)
@@ -861,7 +854,7 @@ int pfm_sysfs_add_pmu(struct pfm_pmu_con
 	kobject_init(&pmu->kobj);
 	kobject_set_name(&pmu->kobj, "pmu_desc");
 	//kobj_set_kset_s(pmu, pfm_pmu_subsys);
-	pmu->kobj.parent = &pfm_kernel_kobj;
+	pmu->kobj.parent = pfm_kernel_kobj;
 
 	ret = kobject_add(&pmu->kobj);
 	if (ret)
