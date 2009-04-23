Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbZDWRc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbZDWRc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbZDWRcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:32:16 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:54554 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbZDWRcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:32:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=M9HWTxLFSMvFNz0DmaY2DhCuG1StYCKTLydIO1vb2yfE3dPHhVEStbNTm8eaZDx1/s7ZavWaakV+NcyKrJ9iex/RCkaOUetye4kjcGDtNFEIZi7npPCmK0Zne8yaY5wX;
Message-ID: <49F0A61D.1010002@simon.arlott.org.uk>
Date: Thu, 23 Apr 2009 18:32:13 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090328)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux DVB <linux-dvb@linuxtv.org>
Subject: [PATCH] dvb-core: Fix potential mutex_unlock without mutex_lock in
 dvb_dvr_read
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dvb_dvr_read may unlock the dmxdev mutex and return -ENODEV,
except this function is a file op and will never be called
with the mutex held.

There's existing mutex_lock and mutex_unlock around the actual
read but it's commented out. These should probably be uncommented
but the read blocks and this could block another non-blocking
reader on the mutex instead.

This change comments out the extra mutex_unlock.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
This has been on my TODO list for far too long... I did come
up with a mutex_trylock/mutex_lock_interruptible version but
claiming that it'll block when it may not doesn't make sense
(and any blocking read would cause all non-blocking reads to
continually return -EWOULDBLOCK until there is data).

 drivers/media/dvb/dvb-core/dmxdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index c35fbb8..d6d098a 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -247,7 +247,7 @@ static ssize_t dvb_dvr_read(struct file *file, char __user *buf, size_t count,
 	int ret;
 
 	if (dmxdev->exit) {
-		mutex_unlock(&dmxdev->mutex);
+		//mutex_unlock(&dmxdev->mutex);
 		return -ENODEV;
 	}
 
-- 
1.6.2.2

-- 
Simon Arlott
