Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbZCWSGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbZCWSGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758282AbZCWSEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:04:30 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:35008
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757852AbZCWSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:04:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/11] xen/sys/hypervisor: change writable_pt to features
Date: Mon, 23 Mar 2009 10:55:07 -0700
Message-Id: <1237830911-6249-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

/sys/hypervisor/properties/writable_pt was misnamed.  Rename to features,
expressed as a bit array in hex.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/sys-hypervisor.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index cb29d1c..1267d6f 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -293,37 +293,48 @@ static ssize_t pagesize_show(struct hyp_sysfs_attr *attr, char *buffer)
 
 HYPERVISOR_ATTR_RO(pagesize);
 
-/* eventually there will be several more features to export */
 static ssize_t xen_feature_show(int index, char *buffer)
 {
-	int ret = -ENOMEM;
-	struct xen_feature_info *info;
+	ssize_t ret;
+	struct xen_feature_info info;
 
-	info = kmalloc(sizeof(struct xen_feature_info), GFP_KERNEL);
-	if (info) {
-		info->submap_idx = index;
-		ret = HYPERVISOR_xen_version(XENVER_get_features, info);
-		if (!ret)
-			ret = sprintf(buffer, "%d\n", info->submap);
-		kfree(info);
-	}
+	info.submap_idx = index;
+	ret = HYPERVISOR_xen_version(XENVER_get_features, &info);
+	if (!ret)
+		ret = sprintf(buffer, "%08x", info.submap);
 
 	return ret;
 }
 
-static ssize_t writable_pt_show(struct hyp_sysfs_attr *attr, char *buffer)
+static ssize_t features_show(struct hyp_sysfs_attr *attr, char *buffer)
 {
-	return xen_feature_show(XENFEAT_writable_page_tables, buffer);
+	ssize_t len;
+	int i;
+
+	len = 0;
+	for (i = XENFEAT_NR_SUBMAPS-1; i >= 0; i--) {
+		int ret = xen_feature_show(i, buffer + len);
+		if (ret < 0) {
+			if (len == 0)
+				len = ret;
+			break;
+		}
+		len += ret;
+	}
+	if (len > 0)
+		buffer[len++] = '\n';
+
+	return len;
 }
 
-HYPERVISOR_ATTR_RO(writable_pt);
+HYPERVISOR_ATTR_RO(features);
 
 static struct attribute *xen_properties_attrs[] = {
 	&capabilities_attr.attr,
 	&changeset_attr.attr,
 	&virtual_start_attr.attr,
 	&pagesize_attr.attr,
-	&writable_pt_attr.attr,
+	&features_attr.attr,
 	NULL
 };
 
-- 
1.6.0.6

