Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYIRSYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYIRSYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYIRSX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:23:58 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:33405 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbYIRSX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:23:57 -0400
Subject: [GIT PULL] 2.6.27-rc6 updates for s390
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 18 Sep 2008 11:23:36 -0700
Message-Id: <1221762216.20657.1.camel@skybook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following bug fixes:

Cornelia Huck (1):
      [S390] cio: Fix driver_data handling for ccwgroup devices.

Stefan Weinhuber (1):
      [S390] cio: fix orb initialization in cio_start_key

 drivers/s390/cio/ccwgroup.c |    4 +++-
 drivers/s390/cio/cio.c      |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index e0ce65f..9a50f24 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -113,7 +113,8 @@ ccwgroup_release (struct device *dev)
 
 	for (i = 0; i < gdev->count; i++) {
 		if (gdev->cdev[i]) {
-			dev_set_drvdata(&gdev->cdev[i]->dev, NULL);
+			if (dev_get_drvdata(&gdev->cdev[i]->dev) == gdev)
+				dev_set_drvdata(&gdev->cdev[i]->dev, NULL);
 			put_device(&gdev->cdev[i]->dev);
 		}
 	}
@@ -296,6 +297,7 @@ error:
 			if (dev_get_drvdata(&gdev->cdev[i]->dev) == gdev)
 				dev_set_drvdata(&gdev->cdev[i]->dev, NULL);
 			put_device(&gdev->cdev[i]->dev);
+			gdev->cdev[i] = NULL;
 		}
 	mutex_unlock(&gdev->reg_mutex);
 	put_device(&gdev->dev);
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 5954b90..326f4cc 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -174,6 +174,7 @@ cio_start_key (struct subchannel *sch,	/* subchannel structure */
 	CIO_TRACE_EVENT(4, sch->dev.bus_id);
 
 	orb = &to_io_private(sch)->orb;
+	memset(orb, 0, sizeof(union orb));
 	/* sch is always under 2G. */
 	orb->cmd.intparm = (u32)(addr_t)sch;
 	orb->cmd.fmt = 1;


