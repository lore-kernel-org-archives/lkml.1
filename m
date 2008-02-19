Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbYBSTqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbYBSTqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYBSTqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:46:23 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:37720 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbYBSTqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:46:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=sLxBAS5+8dijUfhSue6jkNe7J7eQa2nf6278bJ0uWa6RLPAt6NjUq9/VmvEhvN3Hzywm3zuf781IaJ4DaYSH9XatQewot+d6rM8zQ+3arOgS9h9GT0AAPvtpsxuzG/e7Qrh5vULEaZvnPG0Gk03S5uxZ7qOBsudJlBBnE7SjYcI=
To: chris2553@googlemail.com
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Tue, 19 Feb 2008 20:46:14 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802191026.57640.IvDoorn@gmail.com> <200802191900.09543.chris2553@googlemail.com>
In-Reply-To: <200802191900.09543.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192046.14184.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[added rt2400-devel (rt2x00 development mailinglist) to the CC list.]

> > > > I have a series of tests I would like to request from you,
> > > > you mentioned you already enabled debugfs, and that is just what we need. ;)
> > > > Please use attached script to create dumps of the hardware register contents.
> > > > 
> > > > There are specific moments that should be dumped:
> > > > - kernel 2.6.24 (last known working version for you).
> > > > - kernel 2.6.25-rc2 (after ifup, before TX dies)
> > > > - kernel 2.6.25-rc2 (after ifup, after TX dies)
> > > >  
> > > 
> > > These diagnostics are attached, with obvious filenames.
> > 
> > Thanks. I think I found something, please test below patch:
> > 
> 
> I've tried the patch but, unfortunately, my wireless LAN still dies after a few pings.

Could you use below patch instead, and make a new dump of the register?
I'm still convinced the breakage occurs in the antenna diversity (or rather, I believe
it attempts a software diversity for your card while in fact it shouldn't).

> The frame dump diagnostics you asked for are attached. This is a fresh dump taken
> tonight running the driver with your patch applied.

Thanks, I think I miss some information in that dump,
but that is okay for now.

Ivo

---

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 015738a..65a512f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -223,7 +223,7 @@ static void rt2x00lib_evaluate_antenna_eval(struct rt2x00_dev *rt2x00dev)
 	 * sample the rssi from the other antenna to make a valid
 	 * comparison between the 2 antennas.
 	 */
-	if ((rssi_curr - rssi_old) > -5 || (rssi_curr - rssi_old) < 5)
+	if (abs(rssi_curr - rssi_old) < 5)
 		return;
 
 	rt2x00dev->link.ant.flags |= ANTENNA_MODE_SAMPLE;
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

