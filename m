Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbYBZUa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbYBZUa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763265AbYBZUaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:30:46 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:57454 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYBZUao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KBN2kYbd01Z6i/4KHg3LcC+zxGz5NyOTWfy0mnhQzrBCJeV8K3M/+ThQYNjoOtCd8n3sCEKlSyxrjOOKM2kK4CMy+JeJYDt1xCcqTEpIu3KN+GfYW6R10QYRMgSlIEiE8EmDOwcz/DWBtFwLg3JQrOjlu17dA8ay82duS/j5Fmk=
Message-ID: <a32f33a40802261230o1743773dle38684609d702959@mail.gmail.com>
Date: Tue, 26 Feb 2008 21:30:38 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Cc: "Chris Clayton" <chris2553@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
       johannes@sipsolutions.net
In-Reply-To: <20080226194838.GD3013@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <200802252104.32416.chris2553@googlemail.com>
	 <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
	 <200802261911.39577.chris2553@googlemail.com>
	 <20080226194838.GD3013@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Sorry, but that's not the case. I find the same results as without the
>  > patches. With the parameter set to 'pid', the network connection fails very
>  > quickly, but with it set to 'simple' I can ping and ftp files to and from my
>  > laptop as much as I like and the connection stays up. In fact, if anything
>  > the patches seem to have made the network even more fragile, in that it fails
>  > almost instantly once I start some network activity ( < 10 pings).
>  >
>  > I'm sure this is not the hardware - it works perfectly with Windows XP, with
>  > 2.6.23.14 plus the out-of-tree rt61 driver from serialmonkey, with the
>  > in-tree driver from 2.6.24.x and with 2.6.25-rc3 with the mac82011's
>  > ieee80211_default_rc_algo parameter set to 'simple'.
>
>  At last!  Vindication for insisting that we keep 'simple' around!
>  Bwahahaha! :-)
>
>  So, am I to understand that 'pid' works find for you with rtl8180?
>  If so, then I wonder if Stefano and Ivo can help us figure-out
>  what kind of problem is sensitive to both driver _and_ rate control
>  algorithm?

rt2x00 is known to be less sensitive then the legacy drivers, scanning
produces less and more inconsistent results (Not all AP's are reported,
even when that AP has a high rssi), and the reported RSSI is often
much lower then expected with the distance to the AP.
I have compared many register dumps, but have never managed to
find a real register setting that might cause this. So what might be
the problem is that rt2x00 is not reporting the RSSI correctly to mac80211.

With the big difference between how mac80211 handles TX rates and
how the legacy drivers handle them, it is hard to make a comparison
where exactly things are going wrong. But in the end, I think it all
comes down to rt2x00 reporting invalid RSSI values to mac80211,
and/or the rate control mechanism being too dependent on some
statistics which are not provided by the driver.

I have to admit that I haven't looked into the 'pid' algorithm closely,
but could it be that some fields in the tx status report upon txdone
are being treated as "very important" while the driver doesn't report it
(For example ack signal strength)?

Other then that I have to say that rt2x00 never has reached a particular
state where link quality issues can be traced back to mac80211 or
the rate control mechanism. It usually was caused by a bug in the driver
itself. (rt2x00 cannot be considered stable yet for a very good reason. ;) )

Ivo
