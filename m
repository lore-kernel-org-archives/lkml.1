Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbZAHJu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbZAHJu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZAHJuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:50:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:44252 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZAHJuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:50:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=O+tcuLuxzpQDJ/eExsoTh2CsRjJn0f9ij6js7YS+n5sMWma81Z51Ld6xUhJCkJq4d7
         C5jMNiqzQvNi19Tipkit5GXiqSLbKxoL55HVioNXJ7OTC+8e1gBFFoEL2ed/KqpnavEI
         Z3RiwOFrmmwHjmloZ+dXBlZ7sjTbbxXzpxidM=
Message-ID: <8447d6730901080150p217f5d71kd2512b124ed0ed4c@mail.gmail.com>
Date: Thu, 8 Jan 2009 10:50:03 +0100
From: "Davide Rizzo" <elpa.rizzo@gmail.com>
To: linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       ben-linux@fluff.org
Subject: [PATCH 2/3] Driver for user access to internal clocks
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specific for Samsung S3C24xx platforms
Allows any driver to get a device specific clock.
It recognizes also the form clkname.X

Signed-off-by: Davide Rizzo <elpa-rizzo@gmail.com>
---
diff -urNp linux-2.6.28/arch/arm/plat-s3c24xx/clock.c
linux-2.6.28.elpa/arch/arm/plat-s3c24xx/clock.c
--- linux-2.6.28/arch/arm/plat-s3c24xx/clock.c	2008-12-25
00:26:37.000000000 +0100
+++ linux-2.6.28.elpa/arch/arm/plat-s3c24xx/clock.c	2009-01-07
19:25:07.000000000 +0100
@@ -67,11 +67,19 @@ static int clk_null_enable(struct clk *c

 struct clk *clk_get(struct device *dev, const char *id)
 {
+	long idno;
+	char *name = (char *)id;
+	char *dotpos = strrchr(id, '.');
 	struct clk *p;
 	struct clk *clk = ERR_PTR(-ENOENT);
-	int idno;

-	if (dev == NULL || dev->bus != &platform_bus_type)
+	if (dotpos) {
+		int err = strict_strtol(dotpos + 1, 10, &idno);
+		if (err)
+			return ERR_PTR(err);
+		name = kstrdup(id, GFP_KERNEL);
+		name[dotpos - id] = '\0';
+	} else if (dev == NULL || dev->bus != &platform_bus_type)
 		idno = -1;
 	else
 		idno = to_platform_device(dev)->id;
@@ -80,7 +88,7 @@ struct clk *clk_get(struct device *dev,

 	list_for_each_entry(p, &clocks, list) {
 		if (p->id == idno &&
-		    strcmp(id, p->name) == 0 &&
+		    strcmp(name, p->name) == 0 &&
 		    try_module_get(p->owner)) {
 			clk = p;
 			break;
@@ -92,7 +100,7 @@ struct clk *clk_get(struct device *dev,

 	if (IS_ERR(clk)) {
 		list_for_each_entry(p, &clocks, list) {
-			if (p->id == -1 && strcmp(id, p->name) == 0 &&
+			if (p->id == -1 && strcmp(name, p->name) == 0 &&
 			    try_module_get(p->owner)) {
 				clk = p;
 				break;
@@ -101,6 +109,9 @@ struct clk *clk_get(struct device *dev,
 	}

 	mutex_unlock(&clocks_mutex);
+
+	if (dotpos)
+		kfree(name);
 	return clk;
 }
