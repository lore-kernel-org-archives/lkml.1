Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZKTQ3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZKTQ3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZKTQ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:29:15 -0500
Received: from mail1.microsoft.com ([131.107.115.212]:59580 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZKTQ3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:29:14 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'gregkh@suse.de'" <gregkh@suse.de>, Hank Janssen <hjanssen@microsoft.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: hv: Fix vmbus event handler bug
Thread-Topic: [PATCH] Staging: hv: Fix vmbus event handler bug
Thread-Index: AQHKafdNSiK6YVrk+0exzA2+sXwakpE/J0Ug
Date: Fri, 20 Nov 2009 16:29:17 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF721E431CF3@TK5EX14MBXC130.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Fix vmbus event handler bug.
The flag ENABLE_POLLING is always enabled in original Makefile, 
but accidently removed during porting to mainline kernel. The patch 
fixes this bug which can cause stalled network communication. 
Credit needs to go to Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
For pointing out a typo in the original code as well.

This patch needs to be applied to the 2.6.32 mainline.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index d649ee1..746370e 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -611,7 +611,7 @@ void VmbusChannelClose(struct vmbus_channel *Channel)
 
 	/* Stop callback and cancel the timer asap */
 	Channel->OnChannelCallback = NULL;
-	del_timer(&Channel->poll_timer);
+	del_timer_sync(&Channel->poll_timer);
 
 	/* Send a closing message */
 	info = kmalloc(sizeof(*info) +
@@ -978,14 +978,10 @@ void VmbusChannelOnChannelEvent(struct vmbus_channel *Channel)
 {
 	DumpVmbusChannel(Channel);
 	ASSERT(Channel->OnChannelCallback);
-#ifdef ENABLE_POLLING
-	del_timer(&Channel->poll_timer);
-	Channel->OnChannelCallback(Channel->ChannelCallbackContext);
-	channel->poll_timer.expires(jiffies + usecs_to_jiffies(100);
-	add_timer(&channel->poll_timer);
-#else
+
 	Channel->OnChannelCallback(Channel->ChannelCallbackContext);
-#endif
+
+	mod_timer(&Channel->poll_timer, jiffies + usecs_to_jiffies(100));
 }
 
 /**
@@ -997,10 +993,6 @@ void VmbusChannelOnTimer(unsigned long data)
 
 	if (channel->OnChannelCallback) {
 		channel->OnChannelCallback(channel->ChannelCallbackContext);
-#ifdef ENABLE_POLLING
-		channel->poll_timer.expires(jiffies + usecs_to_jiffies(100);
-		add_timer(&channel->poll_timer);
-#endif
 	}
 }
 
diff --git a/drivers/staging/hv/ChannelMgmt.c b/drivers/staging/hv/ChannelMgmt.c
index 3db62ca..ef38467 100644
--- a/drivers/staging/hv/ChannelMgmt.c
+++ b/drivers/staging/hv/ChannelMgmt.c
@@ -119,7 +119,7 @@ static inline void ReleaseVmbusChannel(void *context)
  */
 void FreeVmbusChannel(struct vmbus_channel *Channel)
 {
-	del_timer(&Channel->poll_timer);
+	del_timer_sync(&Channel->poll_timer);
 
 	/*
 	 * We have to release the channel's workqueue/thread in the vmbus's
