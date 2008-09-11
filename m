Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbYIKSct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbYIKSct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYIKSck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:32:40 -0400
Received: from mail.queued.net ([207.210.101.209]:2383 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbYIKScj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:32:39 -0400
Date: Thu, 11 Sep 2008 14:32:16 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080911143216.3d618691@dev.queued.net>
In-Reply-To: <20080911090103.ZZRA012@mailhub.coreip.homeip.net>
References: <20080813152459.4d6bb0cb@ephemeral>
	<20080815031435.GD9438@anvil.corenet.prv>
	<20080910175513.17d900bc@dev.queued.net>
	<20080911010124.79166d64@dev.queued.net>
	<20080911013209.3d7c70da@dev.queued.net>
	<20080911090103.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 09:05:22 -0400
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Thu, Sep 11, 2008 at 01:32:09AM -0400, Andres Salomon wrote:
> > 
> > And here's the current touchpad driver after updating based upon
> > your comments.
> > 
> 
> Looks good. Care to respin it all thogether based on the attribute
> change I requested so I can be sure I'm applying the latest version of
> everything? Ummm....
> 

Here's the patch.  This is on top of the other 2 psmouse patches that
were previously sent.




From: Andres Salomon <dilinger@debian.org>
Subject: [PATCH] psmouse: tweak PSMOUSE_DEFINE_ATTR to support raw set callbacks

We want to support attr->set callbacks that may need psmouse->state to
not be updated, or may want to manually deal w/ enabling and disabling
the device.  To do that, we create __PSMOUSE_DEFINE_ATTR which enables
us to set a 'protect' argument specifying whether or not the set
callback should be protected with psmouse_disable and state setting.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/input/mouse/psmouse-base.c |   30 +++++++++++++++++-------------
 drivers/input/mouse/psmouse.h      |    7 ++++++-
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 488ba95..f7278e6 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1401,25 +1401,29 @@ ssize_t psmouse_attr_set_helper(struct device *dev, struct device_attribute *dev
 
 	psmouse = serio_get_drvdata(serio);
 
-	if (psmouse->state == PSMOUSE_IGNORE) {
-		retval = -ENODEV;
-		goto out_unlock;
-	}
+	if (attr->protect) {
+		if (psmouse->state == PSMOUSE_IGNORE) {
+			retval = -ENODEV;
+			goto out_unlock;
+		}
 
-	if (serio->parent && serio->id.type == SERIO_PS_PSTHRU) {
-		parent = serio_get_drvdata(serio->parent);
-		psmouse_deactivate(parent);
-	}
+		if (serio->parent && serio->id.type == SERIO_PS_PSTHRU) {
+			parent = serio_get_drvdata(serio->parent);
+			psmouse_deactivate(parent);
+		}
 
-	psmouse_deactivate(psmouse);
+		psmouse_deactivate(psmouse);
+	}
 
 	retval = attr->set(psmouse, attr->data, buf, count);
 
-	if (retval != -ENODEV)
-		psmouse_activate(psmouse);
+	if (attr->protect) {
+		if (retval != -ENODEV)
+			psmouse_activate(psmouse);
 
-	if (parent)
-		psmouse_activate(parent);
+		if (parent)
+			psmouse_activate(parent);
+	}
 
  out_unlock:
 	mutex_unlock(&psmouse_mutex);
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index 48e0112..0f13c1b 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -106,6 +106,7 @@ struct psmouse_attribute {
 	ssize_t (*show)(struct psmouse *psmouse, void *data, char *buf);
 	ssize_t (*set)(struct psmouse *psmouse, void *data,
 			const char *buf, size_t count);
+	int protect;
 };
 #define to_psmouse_attr(a)	container_of((a), struct psmouse_attribute, dattr)
 
@@ -114,7 +115,7 @@ ssize_t psmouse_attr_show_helper(struct device *dev, struct device_attribute *at
 ssize_t psmouse_attr_set_helper(struct device *dev, struct device_attribute *attr,
 				const char *buf, size_t count);
 
-#define PSMOUSE_DEFINE_ATTR(_name, _mode, _data, _show, _set)			\
+#define __PSMOUSE_DEFINE_ATTR(_name, _mode, _data, _show, _set, _protect)	\
 static ssize_t _show(struct psmouse *, void *data, char *);			\
 static ssize_t _set(struct psmouse *, void *data, const char *, size_t);	\
 static struct psmouse_attribute psmouse_attr_##_name = {			\
@@ -129,6 +130,10 @@ static struct psmouse_attribute psmouse_attr_##_name = {			\
 	.data	= _data,							\
 	.show	= _show,							\
 	.set	= _set,								\
+	.protect = _protect,							\
 }
 
+#define PSMOUSE_DEFINE_ATTR(_name, _mode, _data, _show, _set)	\
+		__PSMOUSE_DEFINE_ATTR(_name, _mode, _data, _show, _set, 1)
+
 #endif /* _PSMOUSE_H */
-- 
1.5.6.5

