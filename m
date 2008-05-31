Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYEaJKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYEaJKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 05:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYEaJKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 05:10:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:36628 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYEaJKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 05:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=iNom9oe15gU1Nr3HQt6TpvAjQmKU2XIy1QysoEfu6XEIeh7M+y2GKwqr1d+scKYYdsE094C6jCu3g+6E8CCa19NWtPU7WlXC9D9HBp/xp9sHLYl6mn2Kb7WG3ftCBmtmlfpvL/hwITjNJ5iHAZAM251Rw8h6wjX9zB68Wi4xrdI=
Date: Sat, 31 May 2008 17:09:08 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: davem@davemloft.net
Cc: arjan@linux.intel.com, marcel@holtmann.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] rfcomm deadlock fix
Message-ID: <20080531090908.GA5399@darkstar.domain.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
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
net/bluetooth/rfcomm/tty.c  |    9 +++++++++
1 files changed, 9 insertions(+)

diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
--- linux/net/bluetooth/rfcomm/tty.c	2008-05-30 15:46:33.000000000 +0800
+++ linux.new/net/bluetooth/rfcomm/tty.c	2008-05-30 16:02:38.000000000 +0800
@@ -566,11 +566,20 @@ static void rfcomm_dev_state_change(stru
 	if (dlc->state == BT_CLOSED) {
 		if (!dev->tty) {
 			if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
+				/* Drop DLC lock here to avoid deadlock
+				 * 1. rfcomm_dev_get will take rfcomm_dev_lock
+				 *    but in rfcomm_dev_add there's lock order:
+				 *    rfcomm_dev_lock -> dlc lock
+				 * 2. rfcomm_dev_put will deaklock if it's
+				 *    the last reference
+				 */
+				rfcomm_dlc_unlock(dlc);
 				if (rfcomm_dev_get(dev->id) == NULL)
 					return;
 
 				rfcomm_dev_del(dev);
 				rfcomm_dev_put(dev);
+				rfcomm_dlc_lock(dlc);
 			}
 		} else
 			tty_hangup(dev->tty);
