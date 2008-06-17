Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbYFQFVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbYFQFVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 01:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYFQFVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 01:21:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:40668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYFQFVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 01:21:45 -0400
Message-ID: <48574994.9090503@kernel.org>
Date: Tue, 17 Jun 2008 14:20:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cdrom: don't check CDC_PLAY_AUDIO in cdrom_count_tracks()
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Tue, 17 Jun 2008 05:20:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to MMC-3 (or any later versions) READ TOCs are mandatory
commands and have nothing to do with CDC_PLAY_AUDIO.  I have no idea
why the check was put there in the first place but it now only breaks
automatic actions on certain drives.

Note that this test was only effective when ide-cdrom was being used
as sr didn't mask CDC_PLAY_AUDIO according to the capabilities.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/cdrom/cdrom.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 69f26eb..11574c5 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1491,10 +1491,6 @@ static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
 	tracks->xa=0;
 	tracks->error=0;
 	cdinfo(CD_COUNT_TRACKS, "entering cdrom_count_tracks\n"); 
-        if (!CDROM_CAN(CDC_PLAY_AUDIO)) { 
-                tracks->error=CDS_NO_INFO;
-                return;
-        }        
 	/* Grab the TOC header so we can see how many tracks there are */
 	if ((ret = cdi->ops->audio_ioctl(cdi, CDROMREADTOCHDR, &header))) {
 		if (ret == -ENOMEDIUM)
