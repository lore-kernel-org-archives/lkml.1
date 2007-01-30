Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbXA3VXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbXA3VXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 16:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXA3VXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 16:23:40 -0500
Received: from smtp.nokia.com ([131.228.20.170]:47986 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbXA3VXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 16:23:39 -0500
Message-ID: <45BFB818.3020908@indt.org.br>
Date: Tue, 30 Jan 2007 17:26:48 -0400
From: Anderson Briglia <anderson.briglia@indt.org.br>
User-Agent: Icedove 1.5.0.8 (X11/20061128)
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
References: <4582F007.7030100@indt.org.br> <459B9C4E.3020406@indt.org.br> <45A021B2.4090104@drzeus.cx> <45BE3E70.9050505@indt.org.br> <45BF8A28.5010605@drzeus.cx>
In-Reply-To: <45BF8A28.5010605@drzeus.cx>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/mixed;
 boundary="------------050504060001050200090701"
X-OriginalArrivalTime: 30 Jan 2007 21:20:29.0841 (UTC) FILETIME=[77D22010:01C744B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050504060001050200090701
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hi Pierre,

How about now? Is better?

Regards,

Anderson Briglia

ext Pierre Ossman wrote:
> Anderson Briglia wrote:
>> Hi Pierre,
>>
>> Sorry about the delay.
>> I changed a bit the code to align with your latest suggestions.
>>
>>   
> 
> Nice, but the locking is broken again.
> 
>> I believe now the number of goto's is ok.
>>
>>   
> 
> Actually, the ones you have left are completely useless. So you can just
> remove the last bunch aswell.
> 
> Rgds
> 


--------------050504060001050200090701
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
--- linux-linus-2.6.orig/drivers/mmc/mmc_sysfs.c	2007-01-30 16:28:38.000000000 -0400
+++ linux-linus-2.6/drivers/mmc/mmc_sysfs.c	2007-01-30 16:28:42.000000000 -0400
@@ -17,6 +17,7 @@
 #include <linux/idr.h>
 #include <linux/workqueue.h>
 #include <linux/key.h>
+#include <linux/err.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -65,6 +66,100 @@ static struct device_attribute mmc_dev_a
 
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
+	if (ret != MMC_ERR_NONE)
+		return -EINVAL;
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
@@ -234,6 +329,11 @@ int mmc_register_card(struct mmc_card *c
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
@@ -248,6 +348,9 @@ void mmc_remove_card(struct mmc_card *ca
 		if (mmc_card_sd(card))
 			device_remove_file(&card->dev, &mmc_dev_attr_scr);
 
+#ifdef CONFIG_MMC_PASSWORDS
+		device_remove_file(&card->dev, &mmc_dev_attr_lockable);
+#endif
 		device_del(&card->dev);
 	}
 

--------------050504060001050200090701--
