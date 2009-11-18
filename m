Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZKRM7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZKRM7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 07:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZKRM7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 07:59:51 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39801 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbZKRM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 07:59:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Y2gfFrAhojyCKSlkpEp/AVsOetbTvTiCSxD4wDucU64QC6hdQhebiy6WshRvNBrSA8
         g89FG0h4UOtO1NbwxfTDuVw4vtlDcHgAtfMkEF+Z1ShcFHt36rRvqODmKAOfE8yPQJ77
         DoAx0xgdCMjYk7jgvfaNgLEo9T8vQWyuFACpQ=
Message-ID: <4B03F2BF.4000402@gmail.com>
Date: Wed, 18 Nov 2009 14:12:31 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>, gregkh@suse.de,
       linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: FIX bitfield istl_flip:1, make it unsigned.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

istl_flip is a signed bitfield of one bit so it can be -1 or 0.
However in drivers/usb/host/isp1362-hcd.c:1103:

finish_iso_transfers(isp1362_hcd,
	&isp1362_hcd->istl_queue[isp1362_hcd->istl_flip]);

So if isp1362_hcd->istl_flip is set, the 2nd argument becomes
&isp1362_hcd->istl_queue[-1], which is invalid.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
FYI:
drivers/usb/host/isp1362.h:543:
struct isp1362_hcd {
...
	struct isp1362_ep_queue istl_queue[2];
};

The change of the other bitfield may not be strictly necessary
but is preferred, I thought.

Roel

diff --git a/drivers/usb/host/isp1362.h b/drivers/usb/host/isp1362.h
index 1a253eb..5151516 100644
--- a/drivers/usb/host/isp1362.h
+++ b/drivers/usb/host/isp1362.h
@@ -534,8 +534,8 @@ struct isp1362_hcd {
 
 	/* periodic schedule: isochronous */
 	struct list_head	isoc;
-	int			istl_flip:1;
-	int			irq_active:1;
+	unsigned int		istl_flip:1;
+	unsigned int		irq_active:1;
 
 	/* Schedules for the current frame */
 	struct isp1362_ep_queue atl_queue;
