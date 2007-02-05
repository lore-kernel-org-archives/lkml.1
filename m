Return-Path: <linux-kernel-owner+w=401wt.eu-S933469AbXBEV2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbXBEV2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933477AbXBEV2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:28:31 -0500
Received: from smtp.nokia.com ([131.228.20.172]:25234 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464AbXBEV2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:28:30 -0500
Message-ID: <45C7A2B4.10505@indt.org.br>
Date: Mon, 05 Feb 2007 17:33:40 -0400
From: Anderson Briglia <anderson.briglia@indt.org.br>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: ext Pierre Ossman <drzeus-list@drzeus.cx>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       "Lizardo Anderson (EXT-INdT/Manaus)" <anderson.lizardo@indt.org.br>,
       linux-kernel@vger.kernel.org,
       "Aguiar Carlos (EXT-INdT/Manaus)" <carlos.aguiar@indt.org.br>,
       Tony Lindgren <tony@atomide.com>,
       ext David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 4/4] Add MMC Password Protection (lock/unlock) support
 V9: mmc_sysfs.diff
References: <4582F007.7030100@indt.org.br> <459B9C4E.3020406@indt.org.br> <45A021B2.4090104@drzeus.cx> <45BE3E70.9050505@indt.org.br> <45BF8A28.5010605@drzeus.cx> <45BFB818.3020908@indt.org.br> <45C49FFA.70104@drzeus.cx>
In-Reply-To: <45C49FFA.70104@drzeus.cx>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/mixed;
 boundary="------------070800020207080008090709"
X-OriginalArrivalTime: 05 Feb 2007 21:27:08.0157 (UTC) FILETIME=[63B6D2D0:01C7496C]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070205232518-5D94FBB0-0A15B775/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800020207080008090709
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hi Pierre,

ext Pierre Ossman wrote:
> Anderson Briglia wrote:
>> Hi Pierre,
>>
>> How about now? Is better?
>>
>>   
> 
> Locking problem is still there. You need to unclaim the host even when
> claim fails.

Bug fixed. Is there anything else to improve?

Regards,

Anderson Briglia

--------------070800020207080008090709
Content-Type: text/plain;
 name="mmc_sysfs.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mmc_sysfs.diff"

Implement MMC password force erase, remove password, change password,
unlock card and assign password operations. It uses the sysfs mechanism
to send commands to the MMC subsystem. 

Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Anderson Lizardo <anderson.lizardo@indt.org.br>
Signed-off-by: Anderson Briglia <anderson.briglia@indt.org.br>

Index: linux-linus-2.6/drivers/mmc/mmc_sysfs.c
===================================================================
--- linux-linus-2.6.orig/drivers/mmc/mmc_sysfs.c	2007-02-05 17:32:05.000000000 -0400
+++ linux-linus-2.6/drivers/mmc/mmc_sysfs.c	2007-02-05 17:32:19.000000000 -0400
@@ -17,6 +17,7 @@
 #include <linux/idr.h>
 #include <linux/workqueue.h>
 #include <linux/key.h>
+#include <linux/err.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -65,6 +66,102 @@ static struct device_attribute mmc_dev_a
 
 static struct device_attribute mmc_dev_attr_scr = MMC_ATTR_RO(scr);
 
+#ifdef	CONFIG_MMC_PASSWORDS
+
+static ssize_t
+mmc_lockable_show(struct device *dev, struct device_attribute *att, char *buf)
+{
+	struct mmc_card *card = dev_to_mmc_card(dev);
+
+	if (!mmc_card_lockable(card))
+		return sprintf(buf, "unsupported\n");
+	else
+		return sprintf(buf, "%slocked\n", mmc_card_locked(card) ?
+			"" : "un");
+}
+
+/*
+ * implement MMC password functions: force erase, remove password, change
+ * password, unlock card and assign password.
+ */
+static ssize_t
+mmc_lockable_store(struct device *dev, struct device_attribute *att,
+	const char *data, size_t len)
+{
+	struct mmc_card *card = dev_to_mmc_card(dev);
+	int ret;
+
+	if(!mmc_card_lockable(card))
+		return -EINVAL;
+
+	ret = mmc_card_claim_host(card);
+	if (ret != MMC_ERR_NONE) {
+		mmc_card_release_host(card);
+		return -EINVAL;
+	}
+
+	ret = -EINVAL;
+	if (mmc_card_locked(card) && !strncmp(data, "erase", 5)) {
+		/* forced erase only works while card is locked */
+		mmc_lock_unlock(card, NULL, MMC_LOCK_MODE_ERASE);
+		ret = len;
+	} else if (!mmc_card_locked(card) && !strncmp(data, "remove", 6)) {
+		/* remove password only works while card is unlocked */
+		struct key *mmc_key = request_key(&mmc_key_type, "mmc:key", "remove");
+
+		if (!IS_ERR(mmc_key)) {
+			ret =  mmc_lock_unlock(card, mmc_key, MMC_LOCK_MODE_CLR_PWD);
+			if (!ret)
+				ret = len;
+		} else
+			dev_dbg(&card->dev, "request_key returned error %ld\n", PTR_ERR(mmc_key));
+	} else if (!mmc_card_locked(card) && ((!strncmp(data, "assign", 6)) ||
+					      (!strncmp(data, "change", 6)))) {
+		/* assign or change */
+		struct key *mmc_key;
+
+		if(!(strncmp(data, "assign", 6)))
+			mmc_key = request_key(&mmc_key_type, "mmc:key", "assign");
+		else
+			mmc_key = request_key(&mmc_key_type, "mmc:key", "change");
+
+		if (!IS_ERR(mmc_key)) {
+			ret =  mmc_lock_unlock(card, mmc_key, MMC_LOCK_MODE_SET_PWD);
+			if (!ret)
+				ret = len;
+		} else
+			dev_dbg(&card->dev, "request_key returned error %ld\n", PTR_ERR(mmc_key));
+	} else if (mmc_card_locked(card) && !strncmp(data, "unlock", 6)) {
+		/* unlock */
+		struct key *mmc_key = request_key(&mmc_key_type, "mmc:key", "unlock");
+		if (!IS_ERR(mmc_key)) {
+			ret = mmc_lock_unlock(card, mmc_key, MMC_LOCK_MODE_UNLOCK);
+			if (ret) {
+				dev_dbg(&card->dev, "Wrong password\n");
+				ret = -EINVAL;
+			}
+			else {
+				mmc_card_release_host(card);
+				device_release_driver(dev);
+				ret = device_attach(dev);
+				if(!ret)
+					return -EINVAL;
+				else
+					return len;
+			}
+		} else
+			dev_dbg(&card->dev, "request_key returned error %ld\n", PTR_ERR(mmc_key));
+	}
+
+	mmc_card_release_host(card);
+	return ret;
+}
+
+static struct device_attribute mmc_dev_attr_lockable =
+	__ATTR(lockable, S_IWUSR | S_IRUGO,
+		 mmc_lockable_show, mmc_lockable_store);
+
+#endif
 
 static void mmc_release_card(struct device *dev)
 {
@@ -234,6 +331,11 @@ int mmc_register_card(struct mmc_card *c
 			if (ret)
 				device_del(&card->dev);
 		}
+#ifdef CONFIG_MMC_PASSWORDS
+		ret = device_create_file(&card->dev, &mmc_dev_attr_lockable);
+		if (ret)
+			device_del(&card->dev);
+#endif
 	}
 	return ret;
 }
@@ -248,6 +350,9 @@ void mmc_remove_card(struct mmc_card *ca
 		if (mmc_card_sd(card))
 			device_remove_file(&card->dev, &mmc_dev_attr_scr);
 
+#ifdef CONFIG_MMC_PASSWORDS
+		device_remove_file(&card->dev, &mmc_dev_attr_lockable);
+#endif
 		device_del(&card->dev);
 	}
 

--------------070800020207080008090709--
