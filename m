Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbYIKF3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbYIKF3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYIKF3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:29:22 -0400
Received: from mail.queued.net ([207.210.101.209]:1693 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYIKF3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:29:21 -0400
Date: Thu, 11 Sep 2008 01:01:24 -0400
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080911010124.79166d64@dev.queued.net>
In-Reply-To: <20080910175513.17d900bc@dev.queued.net>
References: <20080813152459.4d6bb0cb@ephemeral>
	<20080815031435.GD9438@anvil.corenet.prv>
	<20080910175513.17d900bc@dev.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008 17:55:13 -0400
Andres Salomon <dilinger@queued.net> wrote:
[...]
> 
> 
> What do you think about either changing PSMOUSE_DEFINE_ATTR
> to take an additional 'raw' argument (meaning psmouse->state is
> not checked, and psmouse_deactivate/psmouse_activate are not
> called), or alternatively adding new helper functions that just
> handle the locking (__PSMOUSE_DEFINE_ATTR() and
> __psmouse_attr_{set,show}_helper())?  I'd prefer the raw
> argument.

Ie, something like this (I'll resend all patches later if you approve).


>From f009e1d3da0266ec99437c243482026c96c9103c Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@debian.org>
Date: Thu, 11 Sep 2008 00:38:02 -0400
Subject: [PATCH] psmouse: tweak PSMOUSE_DEFINE_ATTR to support raw set callbacks

We want to support attr->set callbacks that may need psmouse->state to
not be updated, or may want to manually deal w/ enabling and disabling
the device.  As such, add a variable to PSMOUSE_DEFINE_ATTR that
determines whether or not we protect the set callback with state
updating.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/input/mouse/logips2pp.c    |    2 +-
 drivers/input/mouse/psmouse-base.c |   40 +++++++++++++++++++----------------
 drivers/input/mouse/psmouse.h      |    4 ++-
 drivers/input/mouse/trackpoint.c   |    4 +-
 4 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/input/mouse/logips2pp.c b/drivers/input/mouse/logips2pp.c
index 0c5660d..010294f 100644
--- a/drivers/input/mouse/logips2pp.c
+++ b/drivers/input/mouse/logips2pp.c
@@ -168,7 +168,7 @@ static ssize_t ps2pp_attr_set_smartscroll(struct psmouse *psmouse, void *data, c
 	return count;
 }
 
-PSMOUSE_DEFINE_ATTR(smartscroll, S_IWUSR | S_IRUGO, NULL,
+PSMOUSE_DEFINE_ATTR(smartscroll, S_IWUSR | S_IRUGO, NULL, 1,
 			ps2pp_attr_show_smartscroll, ps2pp_attr_set_smartscroll);
 
 /*
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 488ba95..3e13059 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -65,20 +65,20 @@ module_param_named(resync_time, psmouse_resync_time, uint, 0644);
 MODULE_PARM_DESC(resync_time, "How long can mouse stay idle before forcing resync (in seconds, 0 = never).");
 
 PSMOUSE_DEFINE_ATTR(protocol, S_IWUSR | S_IRUGO,
-			NULL,
+			NULL, 1,
 			psmouse_attr_show_protocol, psmouse_attr_set_protocol);
 PSMOUSE_DEFINE_ATTR(rate, S_IWUSR | S_IRUGO,
 			(void *) offsetof(struct psmouse, rate),
-			psmouse_show_int_attr, psmouse_attr_set_rate);
+			1, psmouse_show_int_attr, psmouse_attr_set_rate);
 PSMOUSE_DEFINE_ATTR(resolution, S_IWUSR | S_IRUGO,
 			(void *) offsetof(struct psmouse, resolution),
-			psmouse_show_int_attr, psmouse_attr_set_resolution);
+			1, psmouse_show_int_attr, psmouse_attr_set_resolution);
 PSMOUSE_DEFINE_ATTR(resetafter, S_IWUSR | S_IRUGO,
 			(void *) offsetof(struct psmouse, resetafter),
-			psmouse_show_int_attr, psmouse_set_int_attr);
+			1, psmouse_show_int_attr, psmouse_set_int_attr);
 PSMOUSE_DEFINE_ATTR(resync_time, S_IWUSR | S_IRUGO,
 			(void *) offsetof(struct psmouse, resync_time),
-			psmouse_show_int_attr, psmouse_set_int_attr);
+			1, psmouse_show_int_attr, psmouse_set_int_attr);
 
 static struct attribute *psmouse_attributes[] = {
 	&psmouse_attr_protocol.dattr.attr,
@@ -1401,25 +1401,29 @@ ssize_t psmouse_attr_set_helper(struct device *dev, struct device_attribute *dev
 
 	psmouse = serio_get_drvdata(serio);
 
-	if (psmouse->state == PSMOUSE_IGNORE) {
-		retval = -ENODEV;
-		goto out_unlock;
-	}
+	if (attr->protected_set) {
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
+	if (attr->protected_set) {
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
index 48e0112..184ba43 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -106,6 +106,7 @@ struct psmouse_attribute {
 	ssize_t (*show)(struct psmouse *psmouse, void *data, char *buf);
 	ssize_t (*set)(struct psmouse *psmouse, void *data,
 			const char *buf, size_t count);
+	int protected_set;
 };
 #define to_psmouse_attr(a)	container_of((a), struct psmouse_attribute, dattr)
 
@@ -114,7 +115,7 @@ ssize_t psmouse_attr_show_helper(struct device *dev, struct device_attribute *at
 ssize_t psmouse_attr_set_helper(struct device *dev, struct device_attribute *attr,
 				const char *buf, size_t count);
 
-#define PSMOUSE_DEFINE_ATTR(_name, _mode, _data, _show, _set)			\
+#define PSMOUSE_DEFINE_ATTR(_name, _mode, _data, _protected_set, _show, _set)	\
 static ssize_t _show(struct psmouse *, void *data, char *);			\
 static ssize_t _set(struct psmouse *, void *data, const char *, size_t);	\
 static struct psmouse_attribute psmouse_attr_##_name = {			\
@@ -129,6 +130,7 @@ static struct psmouse_attribute psmouse_attr_##_name = {			\
 	.data	= _data,							\
 	.show	= _show,							\
 	.set	= _set,								\
+	.protected_set = _protected_set,					\
 }
 
 #endif /* _PSMOUSE_H */
diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 26b845f..156d2f6 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -107,7 +107,7 @@ static ssize_t trackpoint_set_int_attr(struct psmouse *psmouse, void *data,
 		.command = _command,						\
 	};									\
 	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,				\
-			    &trackpoint_attr_##_name,				\
+			    &trackpoint_attr_##_name, 1,			\
 			    trackpoint_show_int_attr, trackpoint_set_int_attr)
 
 static ssize_t trackpoint_set_bit_attr(struct psmouse *psmouse, void *data,
@@ -143,7 +143,7 @@ static ssize_t trackpoint_set_bit_attr(struct psmouse *psmouse, void *data,
 		.inverted	= _inv,						\
 	};									\
 	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,				\
-			    &trackpoint_attr_##_name,				\
+			    &trackpoint_attr_##_name, 1,			\
 			    trackpoint_show_int_attr, trackpoint_set_bit_attr)
 
 TRACKPOINT_INT_ATTR(sensitivity, TP_SENS);
-- 
1.5.6.5

