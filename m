Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbXKSEvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbXKSEvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 23:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXKSEvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 23:51:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:7320 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbXKSEvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 23:51:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=iWVnFCkidLcGdQu5KDwrD6srdJtCb51JgbIc5LlO8DYvZ3pJce8wXQCFGJ+8pDl0LGFu+NQPfCYVatkUsG4TZ+LwZXqJ3qvLDIinrdZvGaJKka0OxwTd6219mLFwJRRNMsgOUQDNcxJxmMq1PblZCyoJOAwSZr4rAktrhsDlcMo=
Date: Mon, 19 Nov 2007 12:57:33 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH][another try]bluetooth rfcomm tty_close before destruct
Message-ID: <20071119045733.GA3829@darkstar.te-china.tietoenator.com>
References: <20071105045921.GA3556@darkstar.te-china.tietoenator.com> <20071119030005.GA3420@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119030005.GA3420@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This is the right patch which will not touch original tty logic. Please ignore last one submited by me.

Regards
dave

Subject:
rfcomm_dev_del could be called twice time in release function.
one by rfcomm_tty_hangup, another by rfcomm_release_dev, this will cause the device being destructed before rfcomm_tty_close.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
tty.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
--- linux/net/bluetooth/rfcomm/tty.c	2007-11-19 10:48:32.000000000 +0800
+++ linux.new/net/bluetooth/rfcomm/tty.c	2007-11-19 12:48:10.000000000 +0800
@@ -424,8 +424,8 @@ static int rfcomm_release_dev(void __use
 	/* Shut down TTY synchronously before freeing rfcomm_dev */
 	if (dev->tty)
 		tty_vhangup(dev->tty);
-
-	rfcomm_dev_del(dev);
+	else if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags))
+		rfcomm_dev_del(dev);
 	rfcomm_dev_put(dev);
 	return 0;
 }
