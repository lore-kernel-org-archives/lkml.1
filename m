Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbXDPEVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbXDPEVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 00:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbXDPEVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 00:21:30 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:40816 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbXDPEVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 00:21:30 -0400
Date: Mon, 16 Apr 2007 00:19:33 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sparc64: modalias support for of_device
Message-ID: <20070416041933.GE23783@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Quick patch to add modalias support for of_device to arch/sparc64 so
sbus drivers can be automatically loaded (I hope :)

Untested, as I'm sparc-less at the moment.

Cheers,
	Kyle

diff --git a/arch/sparc64/kernel/of_device.c b/arch/sparc64/kernel/of_device.c
index fb9bf1e..d00ed90 100644
--- a/arch/sparc64/kernel/of_device.c
+++ b/arch/sparc64/kernel/of_device.c
@@ -173,6 +173,19 @@ struct of_device *of_find_device_by_node(struct device_node *dp)
 }
 EXPORT_SYMBOL(of_find_device_by_node);
 
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	ssize_t len;
+	struct of_device *d = to_of_device(dev);
+	struct device_node *node = d->node;
+
+	len = sprintf(buf, "of:N%sT%sC%s\n",
+		      node->name, node->type, "*");
+
+	return len;
+}
+
 #ifdef CONFIG_PCI
 struct bus_type isa_bus_type = {
        .name	= "isa",
@@ -207,9 +220,15 @@ struct bus_type sbus_bus_type = {
 EXPORT_SYMBOL(sbus_bus_type);
 #endif
 
+static struct device_attribute of_dev_attrs[] = {
+	__ATTR_RO(modalias),
+	__ATTR_NULL
+};
+
 struct bus_type of_bus_type = {
        .name	= "of",
        .match	= of_platform_bus_match,
+       .dev_attrs	= of_dev_attrs,
        .probe	= of_device_probe,
        .remove	= of_device_remove,
        .suspend	= of_device_suspend,
