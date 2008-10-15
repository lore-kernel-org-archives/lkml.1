Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbYJORsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbYJORsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbYJORsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:48:14 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:49165 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYJORsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:48:12 -0400
Message-Id: <20081015174414.674150911@de.ibm.com>
References: <20081015174215.337001494@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 15 Oct 2008 19:42:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, stable@kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 5/5] Fix sysdev class file creation.
Content-Disposition: inline; filename=005-smp-sysdev.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Use sysdev_class_create_file() to create create sysdev class attributes
instead of sysfs_create_file(). Using sysfs_create_file() wasn't a very
good idea since the show and store functions have a different amount of
parameters for sysfs files and sysdev class files.
In particular the pointer to the buffer is the last argument and
therefore accesses to random memory regions happened.
Still worked surprisingly well until we got a kernel panic.

Cc: stable@kernel.org
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/smp.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

Index: quilt-2.6/arch/s390/kernel/smp.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/smp.c
+++ quilt-2.6/arch/s390/kernel/smp.c
@@ -1119,9 +1119,7 @@ out:
 	return rc;
 }
 
-static ssize_t __ref rescan_store(struct sys_device *dev,
-				  struct sysdev_attribute *attr,
-				  const char *buf,
+static ssize_t __ref rescan_store(struct sysdev_class *class, const char *buf,
 				  size_t count)
 {
 	int rc;
@@ -1129,12 +1127,10 @@ static ssize_t __ref rescan_store(struct
 	rc = smp_rescan_cpus();
 	return rc ? rc : count;
 }
-static SYSDEV_ATTR(rescan, 0200, NULL, rescan_store);
+static SYSDEV_CLASS_ATTR(rescan, 0200, NULL, rescan_store);
 #endif /* CONFIG_HOTPLUG_CPU */
 
-static ssize_t dispatching_show(struct sys_device *dev,
-				struct sysdev_attribute *attr,
-				char *buf)
+static ssize_t dispatching_show(struct sysdev_class *class, char *buf)
 {
 	ssize_t count;
 
@@ -1144,9 +1140,8 @@ static ssize_t dispatching_show(struct s
 	return count;
 }
 
-static ssize_t dispatching_store(struct sys_device *dev,
-				 struct sysdev_attribute *attr,
-				 const char *buf, size_t count)
+static ssize_t dispatching_store(struct sysdev_class *dev, const char *buf,
+				 size_t count)
 {
 	int val, rc;
 	char delim;
@@ -1168,7 +1163,8 @@ out:
 	put_online_cpus();
 	return rc ? rc : count;
 }
-static SYSDEV_ATTR(dispatching, 0644, dispatching_show, dispatching_store);
+static SYSDEV_CLASS_ATTR(dispatching, 0644, dispatching_show,
+			 dispatching_store);
 
 static int __init topology_init(void)
 {
@@ -1178,13 +1174,11 @@ static int __init topology_init(void)
 	register_cpu_notifier(&smp_cpu_nb);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
-			       &attr_rescan.attr);
+	rc = sysdev_class_create_file(&cpu_sysdev_class, &attr_rescan);
 	if (rc)
 		return rc;
 #endif
-	rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
-			       &attr_dispatching.attr);
+	rc = sysdev_class_create_file(&cpu_sysdev_class, &attr_dispatching);
 	if (rc)
 		return rc;
 	for_each_present_cpu(cpu) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

