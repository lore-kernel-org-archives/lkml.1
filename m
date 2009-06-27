Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbZF0JuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbZF0JuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 05:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZF0Jt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 05:49:56 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:54982 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbZF0Jtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 05:49:55 -0400
From: Frans Pop <elendil@planet.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.31-rc1] iwlagn (4965): no wireless due to RFKILL problem
Date: Sat, 27 Jun 2009 11:49:54 +0200
User-Agent: KMail/1.9.9
References: <200906261336.29318.elendil@planet.nl> <200906261410.58808.elendil@planet.nl> <1246048132.21314.75.camel@johannes.local>
In-Reply-To: <1246048132.21314.75.camel@johannes.local>
MIME-Version: 1.0
Content-Disposition: inline
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, linux-wireless@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906271149.56051.elendil@planet.nl>
X-OriginalArrivalTime: 27 Jun 2009 09:49:56.0659 (UTC) FILETIME=[A0D28830:01C9F70C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 June 2009, Johannes Berg wrote:
> On Fri, 2009-06-26 at 14:10 +0200, Frans Pop wrote:
> > Well, with 2.6.30 hp-wmi worked together with rfkill without
> > problems. Looking at the commit logs, it looks like the rfkill
> > rewrite by Johannes and Alan is the cause here. CCs added.
>
> Hmm, looks like there might be another polarity error, try this:
> -       int query = BIT(b + 8) | ((!!blocked) << b);
> +       int query = BIT(b + 8) | ((!blocked) << b);

Thanks Johannes, that makes wireless work again.

However, I just saw another possible issue.

When I disable wireless using the hardware switch and the enable it again
almost immediately after on 2.6.30, I get:
[disable]
iwlagn 0000:10:00.0: Radio Frequency Kill Switch is On:
Kill switch must be turned off for wireless networking to work.
usb 3-1: USB disconnect, address 2
[enable]
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
usb 3-1: new full speed USB device using uhci_hcd and address 3
usb 3-1: configuration #1 chosen from 1 choice
wlan0: no probe response from AP 00:14:c1:38:e5:15 - disassociating
iwlagn 0000:10:00.0: index 0 not used in uCode key table.
wlan0: authenticate with AP 00:14:c1:38:e5:15
wlan0: authenticate with AP 00:14:c1:38:e5:15
wlan0: authenticated
wlan0: associate with AP 00:14:c1:38:e5:15
wlan0: RX ReassocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
wlan0: associated

And without any other action networking is up again.

With 2.6.31 I get this:
[disable]
wlan0: deauthenticating by local choice (reason=3)
iwlagn 0000:10:00.0: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5
mac80211-phy0: failed to remove key (0, 00:14:c1:38:e5:15) from hardware (-5)
iwlagn 0000:10:00.0: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5
mac80211-phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-5)
usb 3-1: USB disconnect, address 2
[enable]
usb 3-1: new full speed USB device using uhci_hcd and address 3
usb 3-1: configuration #1 chosen from 1 choice

A lot uglier with those errors. And after that I have to run ifdown/ifup
before networking is up again (ifup only does not work as it will complain
"interface already configured"):

[ifdown wlan0]
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ifup wlan 0]
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: authenticate with AP 00:14:c1:38:e5:15
wlan0: authenticated
wlan0: associate with AP 00:14:c1:38:e5:15
wlan0: RX AssocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

BTW, would it make sense to bring back the first two lines shown with .30
(or at least the first one):
   iwlagn 0000:10:00.0: Radio Frequency Kill Switch is On:
   Kill switch must be turned off for wireless networking to work.
IMHO it's good to register the reason for the disconnect.

Cheers,
FJP
