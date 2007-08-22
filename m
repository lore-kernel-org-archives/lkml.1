Return-Path: <linux-kernel-owner+w=401wt.eu-S1762871AbXHVJFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762871AbXHVJFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758751AbXHVIxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:40 -0400
Received: from 1wt.eu ([62.212.114.60]:2129 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153AbXHVIxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:36 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084034.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:29 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcel Holtmann <marcel@holtmann.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 45/58] Hangup TTY before releasing rfcomm_dev
Content-Disposition: inline; filename=0045-Hangup-TTY-before-releasing-rfcomm_dev.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The core problem is that RFCOMM socket layer ioctl can release
rfcomm_dev struct while RFCOMM TTY layer is still actively using
it. Calling tty_vhangup() is needed for a synchronous hangup before
rfcomm_dev is freed.

Addresses the oops at http://bugzilla.kernel.org/show_bug.cgi?id=7509

Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/bluetooth/rfcomm/tty.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index eb2b524..e1b8663 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -381,6 +381,10 @@ static int rfcomm_release_dev(void __user *arg)
 	if (req.flags & (1 << RFCOMM_HANGUP_NOW))
 		rfcomm_dlc_close(dev->dlc, 0);
 
+	/* Shut down TTY synchronously before freeing rfcomm_dev */
+	if (dev->tty)
+		tty_vhangup(dev->tty);
+
 	rfcomm_dev_del(dev);
 	rfcomm_dev_put(dev);
 	return 0;
-- 
1.5.2.5

-- 
