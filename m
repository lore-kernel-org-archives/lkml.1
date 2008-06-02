Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYFBBp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYFBBp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 21:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYFBBpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 21:45:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:31697 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYFBBpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 21:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=muv6onx4bvwHK7IS0pLI6V6JxgW7EVkoCYMJoXKWwjm2r6fieb8jvK2TY+qlHarEf45/sgP0tyOz8ok0MrMgpD1kJJWMedAVs7NoTS5HFbT8Pboc+SF2eq97dVz0wzV2SnCXVWX3/Sri0sDtOE1w2MrawbLZvmSTUYwjr5hKTdc=
Date: Mon, 2 Jun 2008 09:46:25 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: davem@davemloft.net
Cc: arjan@linux.intel.com, marcel@holtmann.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: [PATCH] bluetooth: rfcomm_dev_state_change deadlock fix
Message-ID: <20080602014625.GA2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's logic in __rfcomm_dlc_close:
	rfcomm_dlc_lock(d);
	d->state = BT_CLOSED;
	d->state_changed(d, err);
	rfcomm_dlc_unlock(d);

In rfcomm_dev_state_change, it's possible that rfcomm_dev_put try to take the
dlc lock, then we will deadlock.

Here fixed it by unlock dlc before rfcomm_dev_get in rfcomm_dev_state_change.

why not unlock just before rfcomm_dev_put? it's because there's another problem.
rfcomm_dev_get/rfcomm_dev_del will take rfcomm_dev_lock, but in rfcomm_dev_add
the lock order is : rfcomm_dev_lock --> dlc lock

so I unlock dlc before the taken of rfcomm_dev_lock.
 
Actually it's a regression caused by commit
1905f6c736cb618e07eca0c96e60e3c024023428, the dlc state_change could be two
callbacks : rfcomm_sk_state_change and rfcomm_dev_state_change. I missed the rfcomm_sk_state_change that time.

Thanks Arjan van de Ven <arjan@linux.intel.com> for the effort in commit
4c8411f8c115def968820a4df6658ccfd55d7f1a
but he missed the rfcomm_dev_state_change lock issue.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
net/bluetooth/rfcomm/tty.c |   13 ++++++++++++-
1 file changed, 12 insertions(+), 1 deletion(-)

diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
--- linux/net/bluetooth/rfcomm/tty.c	2008-05-30 15:46:33.000000000 +0800
+++ linux.new/net/bluetooth/rfcomm/tty.c	2008-06-02 09:16:31.000000000 +0800
@@ -566,11 +566,22 @@ static void rfcomm_dev_state_change(stru
 	if (dlc->state == BT_CLOSED) {
 		if (!dev->tty) {
 			if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
-				if (rfcomm_dev_get(dev->id) == NULL)
+				/* Drop DLC lock here to avoid deadlock
+				 * 1. rfcomm_dev_get will take rfcomm_dev_lock
+				 *    but in rfcomm_dev_add there's lock order:
+				 *    rfcomm_dev_lock -> dlc lock
+				 * 2. rfcomm_dev_put will deadlock if it's
+				 *    the last reference
+				 */
+				rfcomm_dlc_unlock(dlc);
+				if (rfcomm_dev_get(dev->id) == NULL) {
+					rfcomm_dlc_lock(dlc);
 					return;
+				}
 
 				rfcomm_dev_del(dev);
 				rfcomm_dev_put(dev);
+				rfcomm_dlc_lock(dlc);
 			}
 		} else
 			tty_hangup(dev->tty);
