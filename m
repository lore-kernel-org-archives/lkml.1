Return-Path: <linux-kernel-owner+w=401wt.eu-S1423233AbXBHRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423233AbXBHRWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423236AbXBHRWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:22:18 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:2961 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965736AbXBHRWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:22:17 -0500
Date: Thu, 8 Feb 2007 11:19:37 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@localhost.localdomain
To: Jeff Garzik <jgarzik@pobox.com>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH][RESEND] gianfar: Convert network devices to use struct device
 instead of class_device
Message-ID: <Pine.LNX.4.64.0702081118090.29779@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert network devices to use struct device instead of class_device.  Greg
missed this one in his cleanup path.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

---

Got Jeff's email wrong the first time.

commit 24c316396f71c6164f11ca1398151d8b15fd06e0
tree d02ee36eaf848d200dacf3bf795abaec1e55cbc2
parent b892afd1e60132a981b963929e352eabf3306ba2
author Kumar Gala <galak@kernel.crashing.org> Thu, 08 Feb 2007 11:07:11 -0600
committer Kumar Gala <galak@kernel.crashing.org> Thu, 08 Feb 2007 11:07:11 -0600

  drivers/net/gianfar_sysfs.c |  108 ++++++++++++++++++++++---------------------
  1 files changed, 55 insertions(+), 53 deletions(-)

diff --git a/drivers/net/gianfar_sysfs.c b/drivers/net/gianfar_sysfs.c
index 9dd387f..6e2166a 100644
--- a/drivers/net/gianfar_sysfs.c
+++ b/drivers/net/gianfar_sysfs.c
@@ -39,13 +39,15 @@
  #include "gianfar.h"

  #define GFAR_ATTR(_name) \
-static ssize_t gfar_show_##_name(struct class_device *cdev, char *buf); \
-static ssize_t gfar_set_##_name(struct class_device *cdev, \
+static ssize_t gfar_show_##_name(struct device *dev, \
+	 struct device_attribute *attr, char *buf); \
+static ssize_t gfar_set_##_name(struct device *dev, \
+		struct device_attribute *attr, \
  		const char *buf, size_t count); \
-static CLASS_DEVICE_ATTR(_name, 0644, gfar_show_##_name, gfar_set_##_name)
+static DEVICE_ATTR(_name, 0644, gfar_show_##_name, gfar_set_##_name)

  #define GFAR_CREATE_FILE(_dev, _name) \
-	class_device_create_file(&_dev->class_dev, &class_device_attr_##_name)
+	device_create_file(&_dev->dev, &dev_attr_##_name)

  GFAR_ATTR(bd_stash);
  GFAR_ATTR(rx_stash_size);
@@ -54,29 +56,28 @@ GFAR_ATTR(fifo_threshold);
  GFAR_ATTR(fifo_starve);
  GFAR_ATTR(fifo_starve_off);

-#define to_net_dev(cd) container_of(cd, struct net_device, class_dev)
-
-static ssize_t gfar_show_bd_stash(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_bd_stash(struct device *dev,
+				  struct device_attribute *attr, char *buf)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));

-	return sprintf(buf, "%s\n", priv->bd_stash_en? "on" : "off");
+	return sprintf(buf, "%s\n", priv->bd_stash_en ? "on" : "off");
  }

-static ssize_t gfar_set_bd_stash(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_bd_stash(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
  	int new_setting = 0;
  	u32 temp;
  	unsigned long flags;

  	/* Find out the new setting */
-	if (!strncmp("on", buf, count-1) || !strncmp("1", buf, count-1))
+	if (!strncmp("on", buf, count - 1) || !strncmp("1", buf, count - 1))
  		new_setting = 1;
-	else if (!strncmp("off", buf, count-1) || !strncmp("0", buf, count-1))
+	else if (!strncmp("off", buf, count - 1)
+		 || !strncmp("0", buf, count - 1))
  		new_setting = 0;
  	else
  		return count;
@@ -100,19 +101,19 @@ static ssize_t gfar_set_bd_stash(struct class_device *cdev,
  	return count;
  }

-static ssize_t gfar_show_rx_stash_size(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_rx_stash_size(struct device *dev,
+				       struct device_attribute *attr, char *buf)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));

  	return sprintf(buf, "%d\n", priv->rx_stash_size);
  }

-static ssize_t gfar_set_rx_stash_size(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_rx_stash_size(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
  	unsigned int length = simple_strtoul(buf, NULL, 0);
  	u32 temp;
  	unsigned long flags;
@@ -146,21 +147,21 @@ static ssize_t gfar_set_rx_stash_size(struct class_device *cdev,
  	return count;
  }

-
  /* Stashing will only be enabled when rx_stash_size != 0 */
-static ssize_t gfar_show_rx_stash_index(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_rx_stash_index(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));

  	return sprintf(buf, "%d\n", priv->rx_stash_index);
  }

-static ssize_t gfar_set_rx_stash_index(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_rx_stash_index(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
  	unsigned short index = simple_strtoul(buf, NULL, 0);
  	u32 temp;
  	unsigned long flags;
@@ -184,19 +185,20 @@ static ssize_t gfar_set_rx_stash_index(struct class_device *cdev,
  	return count;
  }

-static ssize_t gfar_show_fifo_threshold(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_fifo_threshold(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));

  	return sprintf(buf, "%d\n", priv->fifo_threshold);
  }

-static ssize_t gfar_set_fifo_threshold(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_fifo_threshold(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
  	unsigned int length = simple_strtoul(buf, NULL, 0);
  	u32 temp;
  	unsigned long flags;
@@ -218,20 +220,19 @@ static ssize_t gfar_set_fifo_threshold(struct class_device *cdev,
  	return count;
  }

-static ssize_t gfar_show_fifo_starve(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_fifo_starve(struct device *dev,
+				     struct device_attribute *attr, char *buf)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));

  	return sprintf(buf, "%d\n", priv->fifo_starve);
  }

-
-static ssize_t gfar_set_fifo_starve(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_fifo_starve(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
  	unsigned int num = simple_strtoul(buf, NULL, 0);
  	u32 temp;
  	unsigned long flags;
@@ -253,19 +254,20 @@ static ssize_t gfar_set_fifo_starve(struct class_device *cdev,
  	return count;
  }

-static ssize_t gfar_show_fifo_starve_off(struct class_device *cdev, char *buf)
+static ssize_t gfar_show_fifo_starve_off(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));

  	return sprintf(buf, "%d\n", priv->fifo_starve_off);
  }

-static ssize_t gfar_set_fifo_starve_off(struct class_device *cdev,
-		const char *buf, size_t count)
+static ssize_t gfar_set_fifo_starve_off(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
  {
-	struct net_device *dev = to_net_dev(cdev);
-	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar_private *priv = netdev_priv(to_net_dev(dev));
  	unsigned int num = simple_strtoul(buf, NULL, 0);
  	u32 temp;
  	unsigned long flags;
