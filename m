Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYIWSA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYIWSA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIWSAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:00:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:49227 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbYIWSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:00:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=d/70h+vNqB/yI2LhbTIEgOmKEllw/FigkPume8TsFwryn2w/RNpv8o182nabHmtwfe
         51cmJedeb7bnALqYXsL+klfupcR/HIZE4GnknwGQNUPi93dXmhw52OFa3poA3Tb5zsKc
         jEvv8HU3Jhs88gLEwQXTLLN9daq4Uq7YC7UCQ=
Date: Tue, 23 Sep 2008 20:00:08 +0200
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Edgar Kalkowski <eMail@edgar-kalkowski.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sound: use the right lock in snd_ctl_dev_disconnect
Message-ID: <20080923180008.GA11701@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I never saw any follow-up on this, so here's the patch (in case it was
simply forgotten). Please ignore if it has already been applied to some
development tree. Compile-tested only.


Vegard


>From 14865508117c3727d2c11569201bef6fbcaeb434 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 23 Sep 2008 19:50:48 +0200
Subject: [PATCH] sound: use the right lock in snd_ctl_dev_disconnect

&card->ctl_files is protected by &card->ctl_files_rwlock, not
&card->controls_rwsem. Fix it.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 sound/core/control.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 281b2e2..236bbb1 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1427,12 +1427,12 @@ static int snd_ctl_dev_disconnect(struct snd_device *device)
 	cardnum = card->number;
 	snd_assert(cardnum >= 0 && cardnum < SNDRV_CARDS, return -ENXIO);
 
-	down_read(&card->controls_rwsem);
+	read_lock(&card->ctl_files_rwlock);
 	list_for_each_entry(ctl, &card->ctl_files, list) {
 		wake_up(&ctl->change_sleep);
 		kill_fasync(&ctl->fasync, SIGIO, POLL_ERR);
 	}
-	up_read(&card->controls_rwsem);
+	read_unlock(&card->ctl_files_rwlock);
 
 	if ((err = snd_unregister_device(SNDRV_DEVICE_TYPE_CONTROL,
 					 card, -1)) < 0)
-- 
1.5.5.1

