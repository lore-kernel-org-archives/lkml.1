Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZJVJGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZJVJGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 05:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZJVJGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 05:06:45 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:57898 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZJVJGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 05:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=mQ0TIY8bFaPvE5ahicdHvTqnWV6kuGM/M/eoycVOhqGxE9QoN6mrWyF6cLEf2OXptx
         ThVhrRVON9H6K2FM7TWMaIT4smhtj3PjbZ0yrZEIbdpmnlrpV6SvgLjewYovtZGYhOIW
         xuXqA2BYhG1lXuBmEuk4Ar1W5CpwFJbvV2dzI=
From: Xiaotian Feng <xtfeng@gmail.com>
To: isdn@linux-pingi.de, isdn4linux@listserv.isdn4linux.de
Cc: tilman@imap.cc, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Xiaotian Feng <xtfeng@gmail.com>
Subject: [PATCH] isdn: fix possible circular locking dependency
Date: Thu, 22 Oct 2009 17:07:04 +0800
Message-Id: <1256202424-28314-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a circular locking dependency:

---> isdn_net_get_locked_lp
    --->lock &nd->queue_lock
    --->lock &nd->queue->xmit_lock
    .....................
    ---->unlock &nd->queue_lock

---> isdn_net_writebuf_skb (called with &nd->queue->xmit_lock locked)
    ---->isdn_net_inc_frame_cnt
         ---->isdn_net_device_busy
              ----> lock &nd->queue_lock

This will trigger lockdep warnings:

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.32-rc4-testing #7
 -------------------------------------------------------
 ipppd/28379 is trying to acquire lock:
 (&netdev->queue_lock){......}, at: [<e62ad0fd>] isdn_net_device_busy+0x2c/0x74 [isdn]

 but task is already holding lock:
 (&netdev->local->xmit_lock){+.....}, at: [<e62aefc2>] isdn_net_write_super+0x3f/0x6e [isdn]

 which lock already depends on the new lock.
 .......

 We don't need to lock nd->queue->xmit_lock to protect single
isdn_net_lp_busy(). This can fix above lockdep warnings.

Reported-and-tested-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
---
 drivers/isdn/i4l/isdn_net.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_net.h b/drivers/isdn/i4l/isdn_net.h
index 74032d0..7511f08 100644
--- a/drivers/isdn/i4l/isdn_net.h
+++ b/drivers/isdn/i4l/isdn_net.h
@@ -83,19 +83,19 @@ static __inline__ isdn_net_local * isdn_net_get_locked_lp(isdn_net_dev *nd)
 
 	spin_lock_irqsave(&nd->queue_lock, flags);
 	lp = nd->queue;         /* get lp on top of queue */
-	spin_lock(&nd->queue->xmit_lock);
 	while (isdn_net_lp_busy(nd->queue)) {
-		spin_unlock(&nd->queue->xmit_lock);
 		nd->queue = nd->queue->next;
 		if (nd->queue == lp) { /* not found -- should never happen */
 			lp = NULL;
 			goto errout;
 		}
-		spin_lock(&nd->queue->xmit_lock);
 	}
 	lp = nd->queue;
 	nd->queue = nd->queue->next;
+	spin_unlock_irqrestore(&nd->queue_lock, flags);
+	spin_lock(&lp->xmit_lock);
 	local_bh_disable();
+	return lp;
 errout:
 	spin_unlock_irqrestore(&nd->queue_lock, flags);
 	return lp;
-- 
1.6.2.5

