Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbZGHWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbZGHWI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZGHWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:08:47 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:59560 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbZGHWIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GXqL9NQx+ANpL+X/O0dpCIkpcT/PXDa6ic7CWtV9b2wm2cqXVMgjYbWGWJKvIxx19c
         dmHPKslqaU6WqvjvZWqi+6PVvCfmPi98R+EWXOTpo0RgqZEriQn504VFJKpBQqiI3LX6
         0CKjNp3IIUZLRRVcX06w/MlNG42uo54ImU10U=
MIME-Version: 1.0
In-Reply-To: <200907082340.07787.elendil@planet.nl>
References: <200907082340.07787.elendil@planet.nl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 8 Jul 2009 15:08:24 -0700
Message-ID: <43e72e890907081508n6fa5781an1dcbda078efc5379@mail.gmail.com>
Subject: Re: [regression] ath5k: Overrides regulatory domain set for cfg80211
To: Frans Pop <elendil@planet.nl>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 2:40 PM, Frans Pop<elendil@planet.nl> wrote:
> In /etc/modprobe.d I have a file containing:
> options cfg80211 ieee80211_regdom=EU
>
> During boot this results in:
> <snip>
> cfg80211: Using static regulatory domain info
> cfg80211: Regulatory domain: EU
>        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>        (2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
>        (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
>        (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
>        (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
>        (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
>        (5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
> cfg80211: Calling CRDA for country: EU
> </snip>
>
> But with 2.6.31-rc2 I then get (the lines marked with "!" are not there
> with .30):
> <snip>
>  ath5k 0000:02:00.0: enabling device (0000 -> 0002)
>  ath5k 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>  ath5k 0000:02:00.0: registered as 'phy0'
> ! ath: EEPROM regdomain: 0x30
> ! ath: EEPROM indicates we should expect a direct regpair map
> ! ath: Country alpha2 being used: AM
> ! ath: Regpair used: 0x30
>  phy0: Selected rate control algorithm 'minstrel'
>  ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
>  ath5k phy0: RF2112B 2GHz radio found (0x46)
> ! cfg80211: Calling CRDA for country: AM
> </snip>
>
> So it looks

*looks*

> as if ath5k has started to override the regdomain I want.

It looks as if, but you a few things you should be aware of.

First, its not that anything is being ignored, user input is always
welcomed to help compliance you are just using a wrong ISO-3166
alpha2.

EU is not a country and as such is only left on older kernels with
CONFIG_WIRELESS_OLD_REGULATORY  enabled. So "EU" is deprecated for non
CONFIG_WIRELESS_OLD_REGULATORY based kernels now. For further
information please also read
Documentation/feature-removal-schedule.txt. Please use a valid
ISO-3166 alpha2 country code, I also advise to abandon the usage of
the ieee80211_regdom module parameter which we do eventually intend on
deprecating and if you know anyone using that please suggest the same.

Eventually, as you will read from the feature-removal schedule, we
intend on getting the Linux desktop to provide automatic hints of the
user's location through things like GeoClue. Reason for removing the
module parameter is its not the proper way to pass information to the
kernel, we now have a netlink interface for this exact purpose. Until
the desktop catches up we'll keep the ieee80211_regdom module
parameter, but the proper new way to set your regulatory domain as a
user is through iw [1] which does use netlink. Some distributions
(like Fedora) automatically set your country based on the timezone
information. So in the end you should not have to do this at all as a
user.

Another thing you should note is that if a driver has a regulatory
domain hint then the driver regulatory domain is always trusted, users
can *further* help compliance by selecting their country. What this
means since Atheros drivers do have EEPROM reading for the regulatory
domain that will be used first, thus enabling only channels allowed by
the programmed EEPROM. A user input can then only disable channel, but
never enable new ones. For devices with no regulatory at all the user
can have more of a say as no driver regulatory hint is available but
by default, in the absence of a driver regulatory hint, we world roam.

[1] http://wireless.kernel.org/en/users/Documentation/iw

  Luis
