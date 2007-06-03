Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbXFCOqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbXFCOqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXFCOmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:42:36 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:24961 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755389AbXFCOmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:42:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=jEi0F9g5AewrTFQkc3+WBSiv0ly7sJvCKdJbNAe22It2vV67pCACbRkqadOsIZEUgNewfkurl+/EsgIprTNWh/Y7GA/DKrgYnZCSB9ZQ+lItgvpAMOakoB2h09NLrwQVwCDUpdOQwaTQquyL52idzEo908oN0Q/h2poEtTR95iU=;
X-YMail-OSG: mEeQLkQVM1m.5tzvHwr0.KKAEb8OPHQdqWtRv6v2zBBZNDbHwLhaql25yz87i.gdBkd69C2fBszB7mVzVTi4LXcM7wJ4DV1JQm6LD4Fxixtjesc46_B31qDXaMe4vT2EvSPw9_XDNw--
Date: Sun, 3 Jun 2007 07:42:33 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 21/36] drivers edac removed sysfs dead code
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <991680.64922.qm@web50108.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmission.com>

Removal of some old dead and disabled code from the edac_device sysfs
code

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
---
 edac_device_sysfs.c |  107
----------------------------------------------------
 1 file changed, 107 deletions(-)

Index: linux-2.6.22-rc1/drivers/edac/edac_device_sysfs.c
===================================================================
--- linux-2.6.22-rc1.orig/drivers/edac/edac_device_sysfs.c
+++ linux-2.6.22-rc1/drivers/edac/edac_device_sysfs.c
@@ -21,113 +21,6 @@
 #define to_edacdev(k) container_of(k, struct edac_device_ctl_info,
kobj)
 #define to_edacdev_attr(a) container_of(a, struct edacdev_attribute,
attr)
 
-#ifdef DKT
-
-static ssize_t edac_dev_ue_count_show(struct edac_device_ctl_info
*edac_dev,
-				      char *data)
-{
-	return sprintf(data, "%d\n", edac_dev->ue_count);
-}
-
-static ssize_t edac_dev_ce_count_show(struct edac_device_ctl_info
*edac_dev,
-				      char *data)
-{
-	return sprintf(data, "%d\n", edac_dev->ce_count);
-}
-
-static ssize_t edac_dev_seconds_show(struct edac_device_ctl_info
*edac_dev,
-				     char *data)
-{
-	return sprintf(data, "%ld\n", (jiffies - edac_dev->start_time) / HZ);
-}
-
-static ssize_t edac_dev_ctl_name_show(struct edac_device_ctl_info
*edac_dev,
-				      char *data)
-{
-	return sprintf(data, "%s\n", edac_dev->ctl_name);
-}
-
-struct edacdev_attribute {
-	struct attribute attr;
-	 ssize_t(*show) (struct edac_device_ctl_info *, char *);
-	 ssize_t(*store) (struct edac_device_ctl_info *, const char *,
size_t);
-};
-
-/* EDAC DEVICE show/store functions for top most object */
-static ssize_t edacdev_show(struct kobject *kobj, struct attribute
*attr,
-			    char *buffer)
-{
-	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
-	struct edacdev_attribute *edacdev_attr = to_edacdev_attr(attr);
-
-	if (edacdev_attr->show)
-		return edacdev_attr->show(edac_dev, buffer);
-
-	return -EIO;
-}
-
-static ssize_t edacdev_store(struct kobject *kobj, struct attribute
*attr,
-			     const char *buffer, size_t count)
-{
-	struct edac_device_ctl_info *edac_dev = to_edacdev(kobj);
-	struct edacdev_attribute *edacdev_attr = to_edacdev_attr(attr);
-
-	if (edacdev_attr->store)
-		return edacdev_attr->store(edac_dev, buffer, count);
-
-	return -EIO;
-}
-
-static struct sysfs_ops edac_dev_ops = {
-	.show = edacdev_show,
-	.store = edacdev_store
-};
-
-#define EDACDEV_ATTR(_name,_mode,_show,_store)			\
-static struct edacdev_attribute edac_dev_attr_##_name = {			\
-	.attr = {.name = __stringify(_name), .mode = _mode },	\
-	.show   = _show,					\
-	.store  = _store,					\
-};
-
-/* default Control file */
-EDACDEV_ATTR(reset_counters, S_IWUSR, NULL,
edac_dev_reset_counters_store);
-
-/* default Attribute files */
-EDACDEV_ATTR(mc_name, S_IRUGO, edac_dev_ctl_name_show, NULL);
-EDACDEV_ATTR(seconds_since_reset, S_IRUGO, edac_dev_seconds_show,
NULL);
-EDACDEV_ATTR(ue_count, S_IRUGO, edac_dev_ue_count_show, NULL);
-EDACDEV_ATTR(ce_count, S_IRUGO, edac_dev_ce_count_show, NULL);
-
-static struct edacdev_attribute *edacdev_attr[] = {
-	&edacdev_attr_reset_counters,
-	&edacdev_attr_mc_name,
-	&edacdev_attr_seconds_since_reset,
-	&edacdev_attr_ue_count,
-	&edacdev_attr_ce_count,
-	NULL
-};
-
-/*
- * Release of a Edac Device controlling instance
- */
-static void edac_dev_instance_release(struct kobject *kobj)
-{
-	struct edac_device_ctl_info *edac_dev;
-
-	edac_dev = to_edacdev(kobj);
-	debugf0("%s() idx=%d\n", __func__, edac_dev->dev_idx);
-	complete(&edac_dev->kobj_complete);
-}
-
-static struct kobj_type ktype_device = {
-	.release = edac_dev_instance_release,
-	.sysfs_ops = &edacdev_ops,
-	.default_attrs = (struct attribute **)edacdev_attr,
-};
-
-#endif
-
 /************************** edac_device sysfs code and data
**************/
 
 /*

