Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZDFKvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZDFKvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 06:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZDFKvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 06:51:21 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:33611 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbZDFKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 06:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=X68BkRQiA58vWc1Agrs9uoxS5n11kKO0u2JUYSdnOr0fotjidOveukaSYRPy2jbkWs
         UICSwa/rRTztVNzHGN5HvLor0mdPoIoBuPSznuO7fxPfNFyqzeSSVk8PHPOue40HrgDQ
         2FizXlWtaJBRwauRXyZgXs65BcTVPY9NyXvdc=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: ath9k becon loss messages
Date: Mon, 6 Apr 2009 12:51:10 +0200
User-Agent: KMail/1.9.10
Cc: Michael Buesch <mb@bu3sch.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
References: <1238923439.4120.9.camel@localhost.localdomain> <200904061217.31134.mb@bu3sch.de> <87tz52xepy.fsf@litku.valot.fi>
In-Reply-To: <87tz52xepy.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061251.10965.helmut.schaa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 6. April 2009 schrieb Kalle Valo:
> Michael Buesch <mb@bu3sch.de> writes:
> 
> >> NetworkManager typically scans every 120 seconds and I can also trigger
> >> the messages by a manual scan with iwlist. I did not dig any further but
> >> the messages seem to appear right at the end of the scan. Tried with iwlagn
> >> and both sw_scan and hw_scan.
> >
> > Yeah OK. While scanning it's expected to lose some frames.
> >
> > However, the driver should probably protect against this by using the
> > scan notification callbacks. It could disable beacon-loss reporting
> > while scanning.
> 
> That case is already covered. In sw_scan mac80211 will disable power
> save and hence beacon filter is also disabled.

Ok, that explains why the beacon loss is first detected after the scan
finished.

> But ath9k nor iwlwifi don't support beacon filtering and this is a
> problem in mac80211. We need to disable the beacon loss check in
> mac80211, most probably by stopping the associated timer whenever
> scanning.

Yeah, but the first execution of the timer will then also detect
beacon loss:

1006   if (!((local->hw.flags & IEEE80211_HW_BEACON_FILTER) &&
1007         (local->hw.conf.flags & IEEE80211_CONF_PS)) &&
1008       time_after(jiffies,
1009            ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {

If the scan took longer then IEEE80211_MONITORING_INTERVAL (=2 sec) this
condition will apply just after the scan finished. Maybe this issue could be
avoided by making the beacon loss detection smarter then just checking if no
beacon was received within the last two seconds.

Helmut
