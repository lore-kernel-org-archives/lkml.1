Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZF2J2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZF2J2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZF2J2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:28:06 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:60259 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387AbZF2J2E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:28:04 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-wireless@vger.kernel.org
Subject: [2.6.31-rc1] iwlagn (4965): regression when hardware rf switch is used
Date: Mon, 29 Jun 2009 11:28:04 +0200
User-Agent: KMail/1.9.9
Cc: Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906291128.05639.elendil@planet.nl>
X-OriginalArrivalTime: 29 Jun 2009 09:28:06.0111 (UTC) FILETIME=[E88046F0:01C9F89B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Reported earlier in 'no wireless due to RFKILL problem' thread, but
Johannes suggested opening a new thread as it is a separate issue.)

I've tried .31-rc1 on my HP 2510p notebook and noticed a problem when
using the hardware rf kill switch.

If disable wireless using the hardware switch and the enable it again
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


But with 2.6.31 I get this:
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

>From lspci:
10:00.0 Network controller [0280]: Intel Corporation PRO/Wireless
        4965 AG or AGN [Kedron] Network Connection [8086:4229] (rev 61)

Cheers,
FJP
