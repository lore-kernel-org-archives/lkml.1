Return-Path: <linux-kernel-owner+w=401wt.eu-S933582AbXJLWkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbXJLWkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbXJLWUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:20:35 -0400
Received: from ns.suse.de ([195.135.220.2]:53336 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582AbXJLWUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:20:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/75] Driver core: Make platform_device.id an int
Date: Fri, 12 Oct 2007 15:16:41 -0700
Message-Id: <11922276163147-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1192227611369-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

While platform_device.id is a u32, platform_device_add() handles "-1"
as a special id value. This has potential for confusion and bugs.
Making it an int instead should prevent problems from happening in
the future.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c         |    7 ++++---
 include/linux/platform_device.h |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index a2e3910..fb56092 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -161,7 +161,7 @@ static void platform_device_release(struct device *dev)
  *	Create a platform device object which can have other objects attached
  *	to it, and which will have attached objects freed when it is released.
  */
-struct platform_device *platform_device_alloc(const char *name, unsigned int id)
+struct platform_device *platform_device_alloc(const char *name, int id)
 {
 	struct platform_object *pa;
 
@@ -245,7 +245,8 @@ int platform_device_add(struct platform_device *pdev)
 	pdev->dev.bus = &platform_bus_type;
 
 	if (pdev->id != -1)
-		snprintf(pdev->dev.bus_id, BUS_ID_SIZE, "%s.%u", pdev->name, pdev->id);
+		snprintf(pdev->dev.bus_id, BUS_ID_SIZE, "%s.%d", pdev->name,
+			 pdev->id);
 	else
 		strlcpy(pdev->dev.bus_id, pdev->name, BUS_ID_SIZE);
 
@@ -359,7 +360,7 @@ EXPORT_SYMBOL_GPL(platform_device_unregister);
  *	the Linux driver model.  In particular, when such drivers are built
  *	as modules, they can't be "hotplugged".
  */
-struct platform_device *platform_device_register_simple(char *name, unsigned int id,
+struct platform_device *platform_device_register_simple(char *name, int id,
 							struct resource *res, unsigned int num)
 {
 	struct platform_device *pdev;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 8bbd459..e808043 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -15,7 +15,7 @@
 
 struct platform_device {
 	const char	* name;
-	u32		id;
+	int		id;
 	struct device	dev;
 	u32		num_resources;
 	struct resource	* resource;
@@ -35,9 +35,10 @@ extern struct resource *platform_get_resource_byname(struct platform_device *, u
 extern int platform_get_irq_byname(struct platform_device *, char *);
 extern int platform_add_devices(struct platform_device **, int);
 
-extern struct platform_device *platform_device_register_simple(char *, unsigned int, struct resource *, unsigned int);
+extern struct platform_device *platform_device_register_simple(char *, int id,
+					struct resource *, unsigned int);
 
-extern struct platform_device *platform_device_alloc(const char *name, unsigned int id);
+extern struct platform_device *platform_device_alloc(const char *name, int id);
 extern int platform_device_add_resources(struct platform_device *pdev, struct resource *res, unsigned int num);
 extern int platform_device_add_data(struct platform_device *pdev, const void *data, size_t size);
 extern int platform_device_add(struct platform_device *pdev);
-- 
1.5.3.4

