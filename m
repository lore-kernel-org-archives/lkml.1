Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbXA2SbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbXA2SbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXA2SbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:31:15 -0500
Received: from smtp.nokia.com ([131.228.20.173]:18173 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXA2SbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:31:13 -0500
Message-ID: <45BE3E70.9050505@indt.org.br>
Date: Mon, 29 Jan 2007 14:35:28 -0400
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
References: <4582F007.7030100@indt.org.br> <459B9C4E.3020406@indt.org.br> <45A021B2.4090104@drzeus.cx>
In-Reply-To: <45A021B2.4090104@drzeus.cx>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/mixed;
 boundary="------------010306080809070703000306"
X-OriginalArrivalTime: 29 Jan 2007 18:29:13.0383 (UTC) FILETIME=[60295370:01C743D3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010306080809070703000306
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

Hi Pierre,

Sorry about the delay.
I changed a bit the code to align with your latest suggestions.

ext Pierre Ossman wrote:
> I've queued it up for -mm, but there a few more comments I want resolved
> before this can move to Linus...
> 
> You need to clean up mmc_lockable_store(). It had a few broken variable
> declarations that even prevented it from compiling, and after I fixed
> that I still get:
> 
> drivers/mmc/mmc_sysfs.c: In function ‘mmc_lockable_store’:
> drivers/mmc/mmc_sysfs.c:160: warning: ignoring return value of
> ‘device_attach’, declared with attribute warn_unused_result
> drivers/mmc/mmc_sysfs.c:93: warning: ‘mmc_key’ may be used uninitialized
> in this function

I'm not getting those errors anymore.
> 
> There's also no handling for an invalid string written to the sysfs node.

I believe now it is ok. If you send an invalid string to sysfs it will return -EINVAL.
> 
> And third, you're a bit excessive on the goto:s. E.g. out_unlocked is
> used in a single place, so it is completely unnecessary. Please do a
> general cleanup of the control flow.

I believe now the number of goto's is ok.

Regards,

Anderson Briglia

--------------010306080809070703000306
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
--- linux-linus-2.6.orig/drivers/mmc/mmc_sysfs.c	2007-01-29 14:26:21.000000000 -0400
+++ linux-linus-2.6/drivers/mmc/mmc_sysfs.c	2007-01-29 14:28:19.000000000 -0400
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
+	ret = mmc_card_claim_host(card);
+	if ((ret != MMC_ERR_NONE) || (!mmc_card_lockable(card)))
+		return -EINVAL;
+
+	ret = -EINVAL;
+	if (mmc_card_locked(card) && !strncmp(data, "erase", 5)) {
+		/* forced erase only works while card is locked */
+		mmc_lock_unlock(card, NULL, MMC_LOCK_MODE_ERASE);
+		ret = len;
+		goto out;
+	} else if (!mmc_card_locked(card) && !strncmp(data, "remove", 6)) {
+		/* remove password only works while card is unlocked */
+		struct key *mmc_key = request_key(&mmc_key_type, "mmc:key", "remove");
+
+		if (!IS_ERR(mmc_key)) {
+			ret =  mmc_lock_unlock(card, mmc_key, MMC_LOCK_MODE_CLR_PWD);
+			if (!ret) {
+				ret = len;
+			}	goto out;
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
+			if (!ret) {
+				ret = len;
+				goto out;
+			}
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
+				goto out;
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
+out:
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
 

--------------010306080809070703000306--
