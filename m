Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbXENJOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbXENJOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbXENJO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:14:26 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:43729
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754731AbXENJO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:14:26 -0400
Date: Mon, 14 May 2007 11:17:01 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 3/5] Use mutex instead of semaphore in CAPI 2.0 driver
Message-ID: <20070514091701.GI29206@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070514090256.GF29206@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514090256.GF29206@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The CAPI 2.0 driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 3ed34f7..9f73bc2 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -258,7 +258,7 @@ static void recv_handler(struct work_struct *work)
 	if ((!ap) || (ap->release_in_progress))
 		return;
 
-	down(&ap->recv_sem);
+	mutex_lock(&ap->recv_mtx);
 	while ((skb = skb_dequeue(&ap->recv_queue))) {
 		if (CAPIMSG_CMD(skb->data) == CAPI_DATA_B3_IND)
 			ap->nrecvdatapkt++;
@@ -267,7 +267,7 @@ static void recv_handler(struct work_struct *work)
 
 		ap->recv_message(ap, skb);
 	}
-	up(&ap->recv_sem);
+	mutex_unlock(&ap->recv_mtx);
 }
 
 void capi_ctr_handle_message(struct capi_ctr * card, u16 appl, struct sk_buff *skb)
@@ -547,7 +547,7 @@ u16 capi20_register(struct capi20_appl *ap)
 	ap->nsentctlpkt = 0;
 	ap->nsentdatapkt = 0;
 	ap->callback = NULL;
-	init_MUTEX(&ap->recv_sem);
+	mutex_init(&ap->recv_mtx);
 	skb_queue_head_init(&ap->recv_queue);
 	INIT_WORK(&ap->recv_work, recv_handler);
 	ap->release_in_progress = 0;
diff --git a/include/linux/kernelcapi.h b/include/linux/kernelcapi.h
index aea34e7..8c4350a 100644
--- a/include/linux/kernelcapi.h
+++ b/include/linux/kernelcapi.h
@@ -64,7 +64,7 @@ struct capi20_appl {
 	unsigned long nrecvdatapkt;
 	unsigned long nsentctlpkt;
 	unsigned long nsentdatapkt;
-	struct semaphore recv_sem;
+	struct mutex recv_mtx;
 	struct sk_buff_head recv_queue;
 	struct work_struct recv_work;
 	int release_in_progress;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

          Dreams and reality are opposites. Action synthesizes them
                             (Assata Shakur)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
