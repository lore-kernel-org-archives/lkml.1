Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZA2Auc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZA2Auc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZA2AuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 19:50:24 -0500
Received: from gw.goop.org ([64.81.55.164]:41179 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZA2AuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 19:50:23 -0500
Message-ID: <4980FD4C.3030700@goop.org>
Date: Wed, 28 Jan 2009 16:50:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stable Kernel <stable@kernel.org>,
       "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>
Subject: [PATCH] xen: make sysfs files behave as their names suggest
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1: make "target_kb" only accept and produce a memory size in kilobytes.
2: add a second "target" file which produces output in bytes, and will accept
   memparse input (scaled bytes)

This fixes the rather irritating problem that writing the same value
read back into target_kb would end up shrinking the domain by a factor
of 1024, with generally bad results.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/balloon.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

===================================================================
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -586,7 +586,7 @@
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	target_bytes = memparse(buf, &endchar);
+	target_bytes = simple_strtoull(buf, &endchar, 0) * 1024;
 
 	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
 
@@ -596,8 +596,39 @@
 static SYSDEV_ATTR(target_kb, S_IRUGO | S_IWUSR,
 		   show_target_kb, store_target_kb);
 
+
+static ssize_t show_target(struct sys_device *dev, struct sysdev_attribute *attr,
+			      char *buf)
+{
+	return sprintf(buf, "%llu\n",
+		       (u64)balloon_stats.target_pages << PAGE_SHIFT);
+}
+
+static ssize_t store_target(struct sys_device *dev,
+			    struct sysdev_attribute *attr,
+			    const char *buf,
+			    size_t count)
+{
+	char *endchar;
+	unsigned long long target_bytes;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	target_bytes = memparse(buf, &endchar);
+
+	balloon_set_new_target(target_bytes >> PAGE_SHIFT);
+
+	return count;
+}
+
+static SYSDEV_ATTR(target, S_IRUGO | S_IWUSR,
+		   show_target, store_target);
+
+
 static struct sysdev_attribute *balloon_attrs[] = {
 	&attr_target_kb,
+	&attr_target,
 };
 
 static struct attribute *balloon_info_attrs[] = {


