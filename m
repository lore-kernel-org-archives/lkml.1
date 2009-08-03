Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZHCURZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZHCURZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZHCURZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:17:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:13811 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZHCURX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LIVU9ux+gTlsa6nH8YhHMWCqTsAVIy0BYE8nrIN00qaR4DBXy/wKtzx2qCBLB3f0mr
         XSW27DhcVAVf3UmivrqrogRqs/AAd1NFhfM+qL9fSZ8Wo89V8lUVomexRu9vv6mscKvh
         wi6/ytBscinWiZWUqgSLfRmiNMU34quBn4nd8=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: chris2553@googlemail.com
Subject: Re: [Bug #13846] Possible regression in rt61pci driver
Date: Mon, 3 Aug 2009 22:17:19 +0200
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-wireless@vger.kernel.org
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.pRC.1cgdKB@chimera> <200908031931.27427.chris2553@googlemail.com>
In-Reply-To: <200908031931.27427.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032217.19947.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Sunday 02 August 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> 
> The folks on the wireless project have concluded that the problem I reported is down to a hardware 
> problem when power saving is switched on on for my Belkin cardbus wireless adapter, so now I simply 
> turn power-saving off when wlan0 comes up. I did, however, ask whether anyone was going to fix the 
> fact that once power-saving turns the LEDs off, they never come back on again, but I haven't had an 
> answer. Is that a regression? I guess the answer is no, because power saving in the rt61pci driver 
> is feature that is new to 2.6.31. Should it be fixed? I think the answer is yes, but being unable 
> to do it myself, I probably don't have a vote :-)

Can't recall this issue was ever reported, but that might just be me having overlooked some emails
or have completely forgotten all about it. But here is a test patch to see if this helps in the issue,
it is not really correct for upstream, but if it works I can see if there is a better solution.

Thanks,

Ivo
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 3845316..6fe70b1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -196,6 +196,12 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00dev->ops->lib->config(rt2x00dev, &libconf, ieee80211_flags);
 
+	if (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) {
+		rt2x00led_led_activity(rt2x00dev, !(conf->flags & IEEE80211_CONF_PS));
+		rt2x00leds_led_assoc(rt2x00dev, !(conf->flags & IEEE80211_CONF_PS));
+		rt2x00leds_led_radio(rt2x00dev, !(conf->flags & IEEE80211_CONF_PS));
+	}
+
 	/*
 	 * Some configuration changes affect the link quality
 	 * which means we need to reset the link tuner.
