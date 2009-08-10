Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZHJGFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZHJGFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 02:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZHJGFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 02:05:17 -0400
Received: from smtp.nokia.com ([192.100.105.134]:51423 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZHJGFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 02:05:15 -0400
Date: Mon, 10 Aug 2009 09:06:10 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Mike Rapoport <mike@compulab.co.il>
Cc: Felipe Balbi <me@felipebalbi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: userspace: use sysfs_create_group
Message-ID: <20090810060610.GN14802@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1249840885-13498-1-git-send-email-me@felipebalbi.com>
 <4A7FAE22.80809@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7FAE22.80809@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Aug 2009 06:04:46.0253 (UTC) FILETIME=[762B2DD0:01CA1980]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 07:20:34AM +0200, ext Mike Rapoport wrote:
> 
> 
> Felipe Balbi wrote:
> > Signed-off-by: Felipe Balbi <me@felipebalbi.com>
> > ---
> 
> NAK
> 
> >  drivers/regulator/userspace-consumer.c |   44 ++++++++++++++++----------------
> >  1 files changed, 22 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
> > index 06d2fa9..a7e8e0b 100644
> > --- a/drivers/regulator/userspace-consumer.c
> > +++ b/drivers/regulator/userspace-consumer.c
> > @@ -93,16 +93,20 @@ static ssize_t reg_set_state(struct device *dev, struct device_attribute *attr,
> >  static DEVICE_ATTR(name, 0444, reg_show_name, NULL);
> >  static DEVICE_ATTR(state, 0644, reg_show_state, reg_set_state);
> >  
> > -static struct device_attribute *attributes[] = {
> > -	&dev_attr_name,
> > -	&dev_attr_state,
> > +static struct attribute *attributes[] = {
> > +	&dev_attr_name.attr,
> > +	&dev_attr_state.attr,
> 
> NULL?
> Except that patch is Ok.

oops, sorry for that, here's updated version

================================ CUT HERE =====================================

>From 5e3502b30b2cbd30946e1240d62905db33716dbd Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@nokia.com>
Date: Mon, 10 Aug 2009 09:05:13 +0300
Subject: [PATCH] regulator: userspace: use sysfs_create_group

and avoid introducing our own loops for creating
several sysfs entries.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/regulator/userspace-consumer.c |   45 ++++++++++++++++---------------
 1 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
index 06d2fa9..44917da 100644
--- a/drivers/regulator/userspace-consumer.c
+++ b/drivers/regulator/userspace-consumer.c
@@ -93,16 +93,21 @@ static ssize_t reg_set_state(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(name, 0444, reg_show_name, NULL);
 static DEVICE_ATTR(state, 0644, reg_show_state, reg_set_state);
 
-static struct device_attribute *attributes[] = {
-	&dev_attr_name,
-	&dev_attr_state,
+static struct attribute *attributes[] = {
+	&dev_attr_name.attr,
+	&dev_attr_state.attr,
+	NULL,
+};
+
+static const struct attribute_group attr_group = {
+	.attrs	= attributes,
 };
 
 static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 {
 	struct regulator_userspace_consumer_data *pdata;
 	struct userspace_consumer_data *drvdata;
-	int ret, i;
+	int ret;
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata)
@@ -125,31 +130,29 @@ static int regulator_userspace_consumer_probe(struct platform_device *pdev)
 		goto err_alloc_supplies;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(attributes); i++) {
-		ret = device_create_file(&pdev->dev, attributes[i]);
-		if (ret != 0)
-			goto err_create_attrs;
-	}
+	ret = sysfs_create_group(&pdev->dev.kobj, &attr_group);
+	if (ret != 0)
+		goto err_create_attrs;
 
-	if (pdata->init_on)
+	if (pdata->init_on) {
 		ret = regulator_bulk_enable(drvdata->num_supplies,
 					    drvdata->supplies);
-
-	drvdata->enabled = pdata->init_on;
-
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to set initial state: %d\n", ret);
-		goto err_create_attrs;
+		if (ret) {
+			dev_err(&pdev->dev,
+				"Failed to set initial state: %d\n", ret);
+			goto err_enable;
+		}
 	}
 
+	drvdata->enabled = pdata->init_on;
 	platform_set_drvdata(pdev, drvdata);
 
 	return 0;
 
-err_create_attrs:
-	for (i = 0; i < ARRAY_SIZE(attributes); i++)
-		device_remove_file(&pdev->dev, attributes[i]);
+err_enable:
+	sysfs_remove_group(&pdev->dev.kobj, &attr_group);
 
+err_create_attrs:
 	regulator_bulk_free(drvdata->num_supplies, drvdata->supplies);
 
 err_alloc_supplies:
@@ -160,10 +163,8 @@ err_alloc_supplies:
 static int regulator_userspace_consumer_remove(struct platform_device *pdev)
 {
 	struct userspace_consumer_data *data = platform_get_drvdata(pdev);
-	int i;
 
-	for (i = 0; i < ARRAY_SIZE(attributes); i++)
-		device_remove_file(&pdev->dev, attributes[i]);
+	sysfs_remove_group(&pdev->dev.kobj, &attr_group);
 
 	if (data->enabled)
 		regulator_bulk_disable(data->num_supplies, data->supplies);
-- 
1.6.3.3.385.g60647

-- 
balbi
