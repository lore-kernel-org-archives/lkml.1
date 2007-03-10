Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbXCJGVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbXCJGVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbXCJGU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:20:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXCJGUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:20:21 -0500
Date: Fri, 9 Mar 2007 22:18:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/20] Fix callback bug in connector
Message-ID: <20070310061842.GR31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-callback-bug-in-connector.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Philipp Reisner <philipp.reisner@linbit.com>

[CONNECTOR]: Bugfix for cn_call_callback()

When system under heavy stress and must allocate new work
instead of reusing old one, new work must use correct
completion callback.

Patch is based on Philipp's and Lars' work.
I only cleaned small stuff (and removed spaces instead of tabs).

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/connector/connector.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -128,7 +128,7 @@ EXPORT_SYMBOL_GPL(cn_netlink_send);
  */
 static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), void *data)
 {
-	struct cn_callback_entry *__cbq;
+	struct cn_callback_entry *__cbq, *__new_cbq;
 	struct cn_dev *dev = &cdev;
 	int err = -ENODEV;
 
@@ -148,27 +148,27 @@ static int cn_call_callback(struct cn_ms
 			} else {
 				struct cn_callback_data *d;
 				
-				__cbq = kzalloc(sizeof(*__cbq), GFP_ATOMIC);
-				if (__cbq) {
-					d = &__cbq->data;
+				err = -ENOMEM;
+				__new_cbq = kzalloc(sizeof(struct cn_callback_entry), GFP_ATOMIC);
+				if (__new_cbq) {
+					d = &__new_cbq->data;
 					d->callback_priv = msg;
 					d->callback = __cbq->data.callback;
 					d->ddata = data;
 					d->destruct_data = destruct_data;
-					d->free = __cbq;
+					d->free = __new_cbq;
 
-					INIT_WORK(&__cbq->work,
+					INIT_WORK(&__new_cbq->work,
 							&cn_queue_wrapper);
-					
+
 					if (queue_work(dev->cbdev->cn_queue,
-						    &__cbq->work))
+						    &__new_cbq->work))
 						err = 0;
 					else {
-						kfree(__cbq);
+						kfree(__new_cbq);
 						err = -EINVAL;
 					}
-				} else
-					err = -ENOMEM;
+				}
 			}
 			break;
 		}

-- 
