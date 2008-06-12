Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbYFLTOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbYFLTOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYFLTN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:13:58 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:40662 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753761AbYFLTN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:13:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xjRpLhPf47zqCec4kS3FmGiXFDGXjAiWnh/oRhz/gTsjViE53uNRmNE/xeEhAxv5kBlQfOLuVA1DdlEbJeoG4nfWCRuy3BOdEmfyEst/7dVMOTdUWrKgwmsGmZDidUam4coAhDKVLDBf/NXjyarixfzk+v3/fyVdT08N9NxRwjE=  ;
X-YMail-OSG: djWXigAVM1nhOUgGlDDg4PoDFZVGM73qZzq3.DSYM31ncBEREL19H3ux5.s1hcPj9LfyzzNmEncefAc5uGXoNAdZGis_77lKhdGX0uRQdxhPat8YaAfDTnhZqoCXE4cWMHKLb_eCbhxaehWg4TNmxugN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-pcmcia@lists.infradead.org
Subject: [patch 2.6.26-git] pcmcia: simplify rsrc_nonstatic attributes
Date: Thu, 12 Jun 2008 12:13:55 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <200804280105.28343.david-b@pacbell.net>
In-Reply-To: <200804280105.28343.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121213.55623.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Simplify sysfs attribute registration for sockets without static
resource mappings by using an attribute_group.  This shrinks object
size a bit:  use loops in sysfs code, but have more data.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Updated version of patch sent 28-April:
  http://lists.infradead.org/pipermail/linux-pcmcia/2008-April/005432.html

 drivers/pcmcia/rsrc_nonstatic.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

--- g26.orig/drivers/pcmcia/rsrc_nonstatic.c	2008-05-01 12:53:37.000000000 -0700
+++ g26/drivers/pcmcia/rsrc_nonstatic.c	2008-05-01 13:01:28.000000000 -0700
@@ -1008,41 +1008,34 @@ static ssize_t store_mem_db(struct devic
 }
 static DEVICE_ATTR(available_resources_mem, 0600, show_mem_db, store_mem_db);
 
-static struct device_attribute *pccard_rsrc_attributes[] = {
-	&dev_attr_available_resources_io,
-	&dev_attr_available_resources_mem,
+static struct attribute *pccard_rsrc_attributes[] = {
+	&dev_attr_available_resources_io.attr,
+	&dev_attr_available_resources_mem.attr,
 	NULL,
 };
 
+static const struct attribute_group rsrc_attributes = {
+	.attrs = pccard_rsrc_attributes,
+};
+
 static int __devinit pccard_sysfs_add_rsrc(struct device *dev,
 					   struct class_interface *class_intf)
 {
 	struct pcmcia_socket *s = dev_get_drvdata(dev);
-	struct device_attribute **attr;
-	int ret = 0;
+
 	if (s->resource_ops != &pccard_nonstatic_ops)
 		return 0;
-
-	for (attr = pccard_rsrc_attributes; *attr; attr++) {
-		ret = device_create_file(dev, *attr);
-		if (ret)
-			break;
-	}
-
-	return ret;
+	return sysfs_create_group(&dev->kobj, &rsrc_attributes);
 }
 
 static void __devexit pccard_sysfs_remove_rsrc(struct device *dev,
 					       struct class_interface *class_intf)
 {
 	struct pcmcia_socket *s = dev_get_drvdata(dev);
-	struct device_attribute **attr;
 
 	if (s->resource_ops != &pccard_nonstatic_ops)
 		return;
-
-	for (attr = pccard_rsrc_attributes; *attr; attr++)
-		device_remove_file(dev, *attr);
+	sysfs_remove_group(&dev->kobj, &rsrc_attributes);
 }
 
 static struct class_interface pccard_rsrc_interface __refdata = {
