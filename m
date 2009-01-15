Return-Path: <linux-kernel-owner+w=401wt.eu-S1763376AbZAONcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763376AbZAONcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762234AbZAONbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:31:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60791 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757695AbZAONbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:31:07 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 7/8] tty: Fix double grabbing of a spinlock
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:31:24 +0000
Message-ID: <20090115133121.21366.81872.stgit@localhost.localdomain>
In-Reply-To: <20090115132718.21366.56187.stgit@localhost.localdomain>
References: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Joseph Barrow <D.Barrow@option.com>

The HSO changes for kref introduced a recursive spinlock take. All
functions which call put_rxbuf_data already have serial->serial_lock
grabbed.

[Comment to code added-AC]

Signed-off-by: Denis Joseph Barrow <D.Barrow@option.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/net/usb/hso.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 9df04dd..e25a58f 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2044,9 +2044,8 @@ static int put_rxbuf_data(struct urb *urb, struct hso_serial *serial)
 		return -2;
 	}
 
-	spin_lock(&serial->serial_lock);
+	/* All callers to put_rxbuf_data hold serial_lock */
 	tty = tty_kref_get(serial->tty);
-	spin_unlock(&serial->serial_lock);
 
 	/* Push data to tty */
 	if (tty) {

