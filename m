Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbYJKGmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbYJKGmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYJKGhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:40 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45163 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbYJKGhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:37 -0400
Date: Sat, 11 Oct 2008 02:36:25 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 65/85] PNP: remove some uses of DEBUG ifdef
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <2663f60d434139298835af690f4891cec5c1e501.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use scnprintf() to build up a buffer of PNP IDs to print.  This
makes the printk atomic and helps get rid of an #ifdef.

Also remove an "#ifdef DEBUG" from some debug functions.  The
functions only produce debug output, so it's OK to run the
function and just have the output be dropped at the end.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/pnp/core.c    |   18 ++++++++----------
 drivers/pnp/support.c |    4 ----
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index a411582..7cb1ffc 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -185,6 +185,9 @@ int __pnp_add_device(struct pnp_dev *dev)
 int pnp_add_device(struct pnp_dev *dev)
 {
 	int ret;
+	char buf[128];
+	int len = 0;
+	struct pnp_id *id;
 
 	if (dev->card)
 		return -EINVAL;
@@ -193,17 +196,12 @@ int pnp_add_device(struct pnp_dev *dev)
 	if (ret)
 		return ret;
 
-#ifdef CONFIG_PNP_DEBUG
-	{
-		struct pnp_id *id;
+	buf[0] = '\0';
+	for (id = dev->id; id; id = id->next)
+		len += scnprintf(buf + len, sizeof(buf) - len, " %s", id->id);
 
-		dev_printk(KERN_DEBUG, &dev->dev, "%s device, IDs",
-			dev->protocol->name);
-		for (id = dev->id; id; id = id->next)
-			printk(" %s", id->id);
-		printk(" (%s)\n", dev->active ? "active" : "disabled");
-	}
-#endif
+	dev_dbg(&dev->dev, "%s device, IDs%s (%s)\n",
+		dev->protocol->name, buf, dev->active ? "active" : "disabled");
 	return 0;
 }
 
diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index b42df16..7149186 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -75,7 +75,6 @@ char *pnp_resource_type_name(struct resource *res)
 
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 {
-#ifdef DEBUG
 	char buf[128];
 	int len;
 	struct pnp_resource *pnp_res;
@@ -118,7 +117,6 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 		}
 		dev_dbg(&dev->dev, "%s\n", buf);
 	}
-#endif
 }
 
 char *pnp_option_priority_name(struct pnp_option *option)
@@ -136,7 +134,6 @@ char *pnp_option_priority_name(struct pnp_option *option)
 
 void dbg_pnp_show_option(struct pnp_dev *dev, struct pnp_option *option)
 {
-#ifdef DEBUG
 	char buf[128];
 	int len = 0, i;
 	struct pnp_port *port;
@@ -209,5 +206,4 @@ void dbg_pnp_show_option(struct pnp_dev *dev, struct pnp_option *option)
 		break;
 	}
 	dev_dbg(&dev->dev, "%s\n", buf);
-#endif
 }
-- 
1.5.5.1

