Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbXD0TL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbXD0TL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbXD0TLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:11:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:35243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbXD0S5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Eric Rannaud <eric.rannaud@gmail.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/46] uevent: use add_uevent_var() instead of open coding it
Date: Fri, 27 Apr 2007 11:53:30 -0700
Message-Id: <11777000963332-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000923797-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Rannaud <eric.rannaud@gmail.com>

Make use of add_uevent_var() instead of (often incorrectly) open coding it.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Eric Rannaud <eric.rannaud@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/amba/bus.c           |   13 +++----
 drivers/ieee1394/nodemgr.c   |   14 +++----
 drivers/mmc/mmc_sysfs.c      |   27 ++++++--------
 drivers/s390/crypto/ap_bus.c |   28 +++++++--------
 net/core/net-sysfs.c         |   28 ++++++---------
 sound/aoa/soundbus/core.c    |   80 +++++++++++++++++-------------------------
 6 files changed, 79 insertions(+), 111 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index fd54750..268e301 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -47,14 +47,13 @@ static int amba_match(struct device *dev, struct device_driver *drv)
 static int amba_uevent(struct device *dev, char **envp, int nr_env, char *buf, int bufsz)
 {
 	struct amba_device *pcdev = to_amba_device(dev);
+	int retval = 0, i = 0, len = 0;
 
-	if (nr_env < 2)
-		return -ENOMEM;
-
-	snprintf(buf, bufsz, "AMBA_ID=%08x", pcdev->periphid);
-	*envp++ = buf;
-	*envp++ = NULL;
-	return 0;
+	retval = add_uevent_var(envp, nr_env, &i,
+				buf, bufsz, &len,
+				"AMBA_ID=%08x", pcdev->periphid);
+	envp[i] = NULL;
+	return retval;
 }
 #else
 #define amba_uevent NULL
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index c5ace19..1644e6f 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -1163,6 +1163,7 @@ static int nodemgr_uevent(struct class_device *cdev, char **envp, int num_envp,
 	struct unit_directory *ud;
 	int i = 0;
 	int length = 0;
+	int retval = 0;
 	/* ieee1394:venNmoNspNverN */
 	char buf[8 + 1 + 3 + 8 + 2 + 8 + 2 + 8 + 3 + 8 + 1];
 
@@ -1176,14 +1177,11 @@ static int nodemgr_uevent(struct class_device *cdev, char **envp, int num_envp,
 
 #define PUT_ENVP(fmt,val) 					\
 do {								\
-    	int printed;						\
-	envp[i++] = buffer;					\
-	printed = snprintf(buffer, buffer_size - length,	\
-			   fmt, val);				\
-	if ((buffer_size - (length+printed) <= 0) || (i >= num_envp))	\
-		return -ENOMEM;					\
-	length += printed+1;					\
-	buffer += printed+1;					\
+	retval = add_uevent_var(envp, num_envp, &i,		\
+				buffer, buffer_size, &length,	\
+				fmt, val);			\
+	if (retval)						\
+		return retval;					\
 } while (0)
 
 	PUT_ENVP("VENDOR_ID=%06x", ud->vendor_id);
diff --git a/drivers/mmc/mmc_sysfs.c b/drivers/mmc/mmc_sysfs.c
index d32698b..e0e82d8 100644
--- a/drivers/mmc/mmc_sysfs.c
+++ b/drivers/mmc/mmc_sysfs.c
@@ -86,31 +86,26 @@ mmc_bus_uevent(struct device *dev, char **envp, int num_envp, char *buf,
 {
 	struct mmc_card *card = dev_to_mmc_card(dev);
 	char ccc[13];
-	int i = 0;
-
-#define add_env(fmt,val)						\
-	({								\
-		int len, ret = -ENOMEM;					\
-		if (i < num_envp) {					\
-			envp[i++] = buf;				\
-			len = snprintf(buf, buf_size, fmt, val) + 1;	\
-			buf_size -= len;				\
-			buf += len;					\
-			if (buf_size >= 0)				\
-				ret = 0;				\
-		}							\
-		ret;							\
-	})
+	int retval = 0, i = 0, length = 0;
+
+#define add_env(fmt,val) do {					\
+	retval = add_uevent_var(envp, num_envp, &i,		\
+				buf, buf_size, &length,		\
+				fmt, val);			\
+	if (retval)						\
+		return retval;					\
+} while (0);
 
 	for (i = 0; i < 12; i++)
 		ccc[i] = card->csd.cmdclass & (1 << i) ? '1' : '0';
 	ccc[12] = '\0';
 
-	i = 0;
 	add_env("MMC_CCC=%s", ccc);
 	add_env("MMC_MANFID=%06x", card->cid.manfid);
 	add_env("MMC_NAME=%s", mmc_card_name(card));
 	add_env("MMC_OEMID=%04x", card->cid.oemid);
+#undef add_env
+	envp[i] = NULL;
 
 	return 0;
 }
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index bf37cdf..5aac0ec 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -423,27 +423,25 @@ static int ap_uevent (struct device *dev, char **envp, int num_envp,
 		       char *buffer, int buffer_size)
 {
 	struct ap_device *ap_dev = to_ap_dev(dev);
-	int length;
+	int retval = 0, length = 0, i = 0;
 
 	if (!ap_dev)
 		return -ENODEV;
 
 	/* Set up DEV_TYPE environment variable. */
-	envp[0] = buffer;
-	length = scnprintf(buffer, buffer_size, "DEV_TYPE=%04X",
-			   ap_dev->device_type);
-	if (buffer_size - length <= 0)
-		return -ENOMEM;
-	buffer += length;
-	buffer_size -= length;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buffer, buffer_size, &length,
+				"DEV_TYPE=%04X", ap_dev->device_type);
+	if (retval)
+		return retval;
+
 	/* Add MODALIAS= */
-	envp[1] = buffer;
-	length = scnprintf(buffer, buffer_size, "MODALIAS=ap:t%02X",
-			   ap_dev->device_type);
-	if (buffer_size - length <= 0)
-		return -ENOMEM;
-	envp[2] = NULL;
-	return 0;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buffer, buffer_size, &length,
+				"MODALIAS=ap:t%02X", ap_dev->device_type);
+
+	envp[i] = NULL;
+	return retval;
 }
 
 static struct bus_type ap_bus_type = {
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e441ec7..b21307b 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -412,31 +412,25 @@ static int netdev_uevent(struct device *d, char **envp,
 			 int num_envp, char *buf, int size)
 {
 	struct net_device *dev = to_net_dev(d);
-	int i = 0;
-	int n;
+	int retval, len = 0, i = 0;
 
 	/* pass interface to uevent. */
-	envp[i++] = buf;
-	n = snprintf(buf, size, "INTERFACE=%s", dev->name) + 1;
-	buf += n;
-	size -= n;
-
-	if ((size <= 0) || (i >= num_envp))
-		return -ENOMEM;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buf, size, &len,
+				"INTERFACE=%s", dev->name);
+	if (retval)
+		goto exit;
 
 	/* pass ifindex to uevent.
 	 * ifindex is useful as it won't change (interface name may change)
 	 * and is what RtNetlink uses natively. */
-	envp[i++] = buf;
-	n = snprintf(buf, size, "IFINDEX=%d", dev->ifindex) + 1;
-	buf += n;
-	size -= n;
-
-	if ((size <= 0) || (i >= num_envp))
-		return -ENOMEM;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buf, size, &len,
+				"IFINDEX=%d", dev->ifindex);
 
+exit:
 	envp[i] = NULL;
-	return 0;
+	return retval;
 }
 #endif
 
diff --git a/sound/aoa/soundbus/core.c b/sound/aoa/soundbus/core.c
index 47b3e37..418a98a 100644
--- a/sound/aoa/soundbus/core.c
+++ b/sound/aoa/soundbus/core.c
@@ -61,9 +61,9 @@ static int soundbus_uevent(struct device *dev, char **envp, int num_envp,
 {
 	struct soundbus_dev * soundbus_dev;
 	struct of_device * of;
-	char *scratch, *compat, *compat2;
-	int i = 0;
-	int length, cplen, cplen2, seen = 0;
+	char *compat;
+	int retval = 0, i = 0, length = 0;
+	int cplen, seen = 0;
 
 	if (!dev)
 		return -ENODEV;
@@ -75,63 +75,47 @@ static int soundbus_uevent(struct device *dev, char **envp, int num_envp,
 	of = &soundbus_dev->ofdev;
 
 	/* stuff we want to pass to /sbin/hotplug */
-	envp[i++] = scratch = buffer;
-	length = scnprintf (scratch, buffer_size, "OF_NAME=%s", of->node->name);
-	++length;
-	buffer_size -= length;
-	if ((buffer_size <= 0) || (i >= num_envp))
-		return -ENOMEM;
-	scratch += length;
-
-	envp[i++] = scratch;
-	length = scnprintf (scratch, buffer_size, "OF_TYPE=%s", of->node->type);
-	++length;
-	buffer_size -= length;
-	if ((buffer_size <= 0) || (i >= num_envp))
-		return -ENOMEM;
-	scratch += length;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buffer, buffer_size, &length,
+				"OF_NAME=%s", of->node->name);
+	if (retval)
+		return retval;
+
+	retval = add_uevent_var(envp, num_envp, &i,
+				buffer, buffer_size, &length,
+				"OF_TYPE=%s", of->node->type);
+	if (retval)
+		return retval;
 
 	/* Since the compatible field can contain pretty much anything
 	 * it's not really legal to split it out with commas. We split it
 	 * up using a number of environment variables instead. */
 
 	compat = (char *) get_property(of->node, "compatible", &cplen);
-	compat2 = compat;
-	cplen2= cplen;
 	while (compat && cplen > 0) {
-		envp[i++] = scratch;
-		length = scnprintf (scratch, buffer_size,
-				     "OF_COMPATIBLE_%d=%s", seen, compat);
-		++length;
-		buffer_size -= length;
-		if ((buffer_size <= 0) || (i >= num_envp))
-			return -ENOMEM;
-		scratch += length;
-		length = strlen (compat) + 1;
-		compat += length;
-		cplen -= length;
-		seen++;
+		int tmp = length;
+		retval = add_uevent_var(envp, num_envp, &i,
+					buffer, buffer_size, &length,
+					"OF_COMPATIBLE_%d=%s", seen, compat);
+		if (retval)
+			return retval;
+		compat += length - tmp;
+		cplen -= length - tmp;
+		seen += 1;
 	}
 
-	envp[i++] = scratch;
-	length = scnprintf (scratch, buffer_size, "OF_COMPATIBLE_N=%d", seen);
-	++length;
-	buffer_size -= length;
-	if ((buffer_size <= 0) || (i >= num_envp))
-		return -ENOMEM;
-	scratch += length;
-
-	envp[i++] = scratch;
-	length = scnprintf (scratch, buffer_size, "MODALIAS=%s",
-			soundbus_dev->modalias);
-
-	buffer_size -= length;
-	if ((buffer_size <= 0) || (i >= num_envp))
-		return -ENOMEM;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buffer, buffer_size, &length,
+				"OF_COMPATIBLE_N=%d", seen);
+	if (retval)
+		return retval;
+	retval = add_uevent_var(envp, num_envp, &i,
+				buffer, buffer_size, &length,
+				"MODALIAS=%s", soundbus_dev->modalias);
 
 	envp[i] = NULL;
 
-	return 0;
+	return retval;
 }
 
 static int soundbus_device_remove(struct device *dev)
-- 
1.5.1.2

