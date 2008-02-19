Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbYBSJ1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbYBSJ1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYBSJ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:27:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:50194 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYBSJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:27:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=fb9eH10DF9EDeuG560J+uGtjGn2vvtmVYd9+KIy21syI/NScsUz8g+7dMeRGcor//0b+DPfYeJGpiZVrhtp/4WwoPs3hx+pf3W1b0BsNIIbR9N0OnYW6DNDRL/nXz3xfYOmE0K1HKrHIy1kmq8X4Y8LK5y0KFD90+3vjjrjP9h4=
To: chris2553@googlemail.com
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Tue, 19 Feb 2008 10:26:57 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802181911.32128.IvDoorn@gmail.com> <200802182251.35630.chris2553@googlemail.com>
In-Reply-To: <200802182251.35630.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191026.57640.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > I have a series of tests I would like to request from you,
> > you mentioned you already enabled debugfs, and that is just what we need. ;)
> > Please use attached script to create dumps of the hardware register contents.
> > 
> > There are specific moments that should be dumped:
> > - kernel 2.6.24 (last known working version for you).
> > - kernel 2.6.25-rc2 (after ifup, before TX dies)
> > - kernel 2.6.25-rc2 (after ifup, after TX dies)
> >  
> 
> These diagnostics are attached, with obvious filenames.

Thanks. I think I found something, please test below patch:

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 015738a..8df1991 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -249,10 +249,10 @@ static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->link.ant.flags &= ~ANTENNA_TX_DIVERSITY;
 
 	if (rt2x00dev->hw->conf.antenna_sel_rx == 0 &&
-	    rt2x00dev->default_ant.rx != ANTENNA_SW_DIVERSITY)
+	    rt2x00dev->default_ant.rx == ANTENNA_SW_DIVERSITY)
 		rt2x00dev->link.ant.flags |= ANTENNA_RX_DIVERSITY;
 	if (rt2x00dev->hw->conf.antenna_sel_tx == 0 &&
-	    rt2x00dev->default_ant.tx != ANTENNA_SW_DIVERSITY)
+	    rt2x00dev->default_ant.tx == ANTENNA_SW_DIVERSITY)
 		rt2x00dev->link.ant.flags |= ANTENNA_TX_DIVERSITY;
 
 	if (!(rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) &&



