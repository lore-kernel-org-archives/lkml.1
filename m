Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968378Ab0B1C5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 21:57:11 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46033 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966874Ab0B1C5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 21:57:09 -0500
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 27 Feb 2010 18:57:02 -0800
Message-ID: <m1pr3qcbk1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Evgeniy Polyakov <zbr@ioremap.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Why does connector use a work queue???
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These days netlink callbacks for messages happen in the context of the
process who sent the message.  Things like permission checks are much
more complicated if we don't use that process context.

I was looking at removing NETLINK_CB(skb).eff_cap but I discovered
that connected takes the netlink messages, them from their
perfectly good process context, and puts the into a workqueue
for reasons that are not apparent to me.

Unless I am misreading something we should just be able to remove the
work queues and greatly simplify the connector code.

Something like:

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 537c29a..4c9af0a 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -120,52 +120,28 @@ EXPORT_SYMBOL_GPL(cn_netlink_send);
  */
 static int cn_call_callback(struct sk_buff *skb)
 {
-	struct cn_callback_entry *__cbq, *__new_cbq;
+	struct cn_callback_entry *__cbq;
 	struct cn_dev *dev = &cdev;
 	struct cn_msg *msg = NLMSG_DATA(nlmsg_hdr(skb));
 	int err = -ENODEV;
+	void (*callback)(struct cn_msg *req, struct netlink_skb_parms *nsp);
 
+	callback = NULL;
 	spin_lock_bh(&dev->cbdev->queue_lock);
 	list_for_each_entry(__cbq, &dev->cbdev->queue_list, callback_entry) {
 		if (cn_cb_equal(&__cbq->id.id, &msg->id)) {
-			if (likely(!work_pending(&__cbq->work) &&
-					__cbq->data.skb == NULL)) {
-				__cbq->data.skb = skb;
-
-				if (queue_cn_work(__cbq, &__cbq->work))
-					err = 0;
-				else
-					err = -EINVAL;
-			} else {
-				struct cn_callback_data *d;
-
-				err = -ENOMEM;
-				__new_cbq = kzalloc(sizeof(struct cn_callback_entry), GFP_ATOMIC);
-				if (__new_cbq) {
-					d = &__new_cbq->data;
-					d->skb = skb;
-					d->callback = __cbq->data.callback;
-					d->free = __new_cbq;
-
-					__new_cbq->pdev = __cbq->pdev;
-
-					INIT_WORK(&__new_cbq->work,
-							&cn_queue_wrapper);
-
-					if (queue_cn_work(__new_cbq,
-						    &__new_cbq->work))
-						err = 0;
-					else {
-						kfree(__new_cbq);
-						err = -EINVAL;
-					}
-				}
-			}
+			callback = __cbq->data.callback;
+			err = 0;
 			break;
 		}
 	}
 	spin_unlock_bh(&dev->cbdev->queue_lock);
 
+	if (!err) {
+		callback(msg, &NETLINK_CB(skb));
+		kfree_skb(skb);
+	}
+
 	return err;
 }
 
