Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbZJKTyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbZJKTyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 15:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZJKTyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 15:54:50 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:37011 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZJKTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 15:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=H2kHgsq0yVERJmBU1u6rExuIahUIvQjqJFidXTdInSoug4tKpMIayA1G7srPyBCTVR
         tQTpCPYfQb6O7ifpaLTGYchHDUlijzoMEoR3H7jAjiVPmQcxWe2KgmoXffgByeTO21qp
         aGoR/IcrRIsuKdlEk9vJ/wPdcosTfphk3h3Nk=
Message-ID: <4AD237E3.6000206@gmail.com>
Date: Sun, 11 Oct 2009 13:54:11 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
CC: stable@kernel.org
Subject: [PATCH] scsi: properly export media change notification capability
 in block device flags
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to some oversight, the SCSI capability for reporting media change
notifications was never actually translated into setting the appropriate
GENHD_FL_MEDIA_CHANGE_NOTIFY flag. HAL uses this flag to detect whether the
block device supports change notifications and so it never actually got
detected. Set the flag when appropriate in sd and sr.

Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

---

Gaah, am I disappointed in finding this one. Apparently people went to the
trouble of adding ATAPI AN support, and adding the appropriate flags to indicate
to userspace that it was supported, but nobody ever tested to make sure that
the support worked all the way through to actually make HAL stop polling
optical drives that support AN, which to my dismay, it doesn't. In fact even
with this patch it still doesn't seem to, but that's presumably some HAL bug.
HAL does now report that storage.removable.support_async_notification = true,
however.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8dd96dc..c1f474e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2012,6 +2012,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	gd->flags = GENHD_FL_EXT_DEVT | GENHD_FL_DRIVERFS;
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
+	if (test_bit(SDEV_EVT_MEDIA_CHANGE, sdp->supported_events))
+		gd->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index eb61f7a..485898e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -642,6 +642,8 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
+	if (test_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events))
+		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 	add_disk(disk);
 
 	sdev_printk(KERN_DEBUG, sdev,
