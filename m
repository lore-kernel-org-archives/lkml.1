Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYHSWzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYHSWzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbYHSWxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:41 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29095 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbYHSWxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 5/8] PNP: remove some uses of DEBUG ifdef
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:36 -0600
Message-ID: <20080819225336.28206.87621.stgit@tigger.helgaas>
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use scnprintf() to build up a buffer of PNP IDs to print.  This
makes the printk atomic and helps get rid of an #ifdef.

Also remove an "#ifdef DEBUG" from some debug functions.  The
functions only produce debug output, so it's OK to run the
function and just have the output be dropped at the end.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
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

