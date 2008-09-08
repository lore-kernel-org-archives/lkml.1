Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbYIHRqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbYIHRqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYIHRqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:46:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34245 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYIHRqi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:46:38 -0400
Date: Mon, 8 Sep 2008 10:45:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: tpmdd-devel@lists.sourceforge.net,
       Daniel =?ISO-8859-1?Q?Marjam=E4ki?= <danielm77@spray.se>
Subject: [PATCH bz #11425] tpm: release memory on init failure
Message-Id: <20080908104530.f9aed821.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

For kernel bugzilla #11425:
http://bugzilla.kernel.org/show_bug.cgi?id=11425

Release memory on init failure.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Daniel Marjamäki <danielm77@spray.se>
cc: tpmdd-devel@lists.sourceforge.net
---
 drivers/char/tpm/tpm.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- linux-next-20080905.orig/drivers/char/tpm/tpm.c
+++ linux-next-20080905/drivers/char/tpm/tpm.c
@@ -1183,11 +1183,8 @@ struct tpm_chip *tpm_register_hardware(s
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
 
-	if (chip == NULL || devname == NULL) {
-		kfree(chip);
-		kfree(devname);
-		return NULL;
-	}
+	if (chip == NULL || devname == NULL)
+		goto fail;
 
 	mutex_init(&chip->buffer_mutex);
 	mutex_init(&chip->tpm_mutex);
@@ -1204,8 +1201,7 @@ struct tpm_chip *tpm_register_hardware(s
 
 	if (chip->dev_num >= TPM_NUM_DEVICES) {
 		dev_err(dev, "No available tpm device numbers\n");
-		kfree(chip);
-		return NULL;
+		goto fail;
 	} else if (chip->dev_num == 0)
 		chip->vendor.miscdev.minor = TPM_MINOR;
 	else
@@ -1228,7 +1224,7 @@ struct tpm_chip *tpm_register_hardware(s
 			chip->vendor.miscdev.name,
 			chip->vendor.miscdev.minor);
 		put_device(chip->dev);
-		return NULL;
+		goto fail;
 	}
 
 	spin_lock(&driver_lock);
@@ -1241,12 +1237,17 @@ struct tpm_chip *tpm_register_hardware(s
 		list_del(&chip->list);
 		misc_deregister(&chip->vendor.miscdev);
 		put_device(chip->dev);
-		return NULL;
+		goto fail;
 	}
 
 	chip->bios_dir = tpm_bios_log_setup(devname);
 
 	return chip;
+
+fail:
+	kfree(chip);
+	kfree(devname);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
 


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
