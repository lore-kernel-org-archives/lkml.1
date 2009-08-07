Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbZHGVvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbZHGVvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZHGVvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:51:45 -0400
Received: from bar.sig21.net ([80.81.252.164]:46798 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbZHGVvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:51:44 -0400
Date: Fri, 7 Aug 2009 23:51:55 +0200
From: Johannes Stezenbach <js@sig21.net>
To: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.31-rc5 regression: ath5k broken after suspend-to-ram
Message-ID: <20090807215155.GA17043@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.7 (---)
X-Spam-21-Report: No, score=-3.7 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.741,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On my old Thinkpad T42p running linux-2.6.31-rc5-246-g90bc1a6,
after suspend-to-RAM ath5k cannot associate to an AP using WPA
anymore.  It worked with kernel 2.6.29.1.  I'm not using network
manager etc. but connect manually with "ifup wlan0=foo" with the
following in /etc/network/interfaces:

iface foo inet dhcp
        #wpa-driver nl80211
        wpa-driver wext
        wpa-key-mgmt WPA-PSK
        wpa-ssid some string
        wpa-psk some key

If I use nl80211 the second ifup fails with
"SIOCSIFFLAGS: Input/output error" messages and the follwing
is in dmesg:

   ath5k phy0: failed to wakeup the MAC Chip
   ath5k phy0: can't reset hardware (-5)

With wext it does not give these errors, but the connection
is unstable after the second ifup.


# lspci -s 02:02.0 -v 
02:02.0 Ethernet controller: Atheros Communications Inc. AR5212 802.11abg NIC (rev 01)
	Subsystem: IBM Device 057e
	Flags: bus master, medium devsel, latency 168, IRQ 11
	Memory at c0210000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: ath5k
	Kernel modules: ath5k

dmesg after boot:

   cfg80211: Using static regulatory domain info
   cfg80211: Regulatory domain: US
           (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
           (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
           (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
           (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
           (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
           (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
           (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
   cfg80211: Calling CRDA for country: US
   ath5k 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
   ath5k 0000:02:02.0: registered as 'phy0'
   ath: EEPROM regdomain: 0x62
   ath: EEPROM indicates we should expect a direct regpair map
   ath: Country alpha2 being used: 00
   ath: Regpair used: 0x62
   phy0: Selected rate control algorithm 'minstrel'
   Registered led device: ath5k-phy0::rx
   Registered led device: ath5k-phy0::tx
   ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
   ath5k phy0: RF5112B multiband radio found (0x36)
   
   
syslog after ifup when it works:
   
   Aug  7 20:13:27 void wpa_supplicant[9932]: Failed to initiate AP scan.
   Aug  7 20:13:28 void wpa_supplicant[9932]: CTRL-EVENT-SCAN-RESULTS 
   Aug  7 20:13:28 void wpa_supplicant[9932]: Trying to associate with 00:00:00:00:00:00 (SSID='...' freq=2412 MHz)
   Aug  7 20:13:28 void wpa_supplicant[9932]: Association request to the driver failed
   Aug  7 20:13:28 void kernel: wlan0: authenticate with AP 00:00:00:00:00:00
   Aug  7 20:13:28 void kernel: wlan0: authenticated
   Aug  7 20:13:28 void kernel: wlan0: associate with AP 00:00:00:00:00:00
   Aug  7 20:13:28 void kernel: wlan0: RX AssocResp from 00:00:00:00:00:00 (capab=0x411 status=0 aid=1)
   Aug  7 20:13:28 void kernel: wlan0: associated
   Aug  7 20:13:28 void wpa_supplicant[9932]: Associated with 00:00:00:00:00:00
   Aug  7 20:13:28 void wpa_supplicant[9932]: WPA: Key negotiation completed with 00:00:00:00:00:00 [PTK=CCMP GTK=TKIP]
   Aug  7 20:13:28 void wpa_supplicant[9932]: CTRL-EVENT-CONNECTED - Connection to 00:00:00:00:00:00 completed (auth) [id=0 id_str=]
   
   
syslog after ifdown -> suspend -> resume -> ifup
   
   Aug  7 23:10:02 void wpa_supplicant[16215]: CTRL-EVENT-SCAN-RESULTS 
   Aug  7 23:10:02 void wpa_supplicant[16215]: Trying to associate with 00:00:00:00:00:00 (SSID='...' freq=2412 MHz)
   Aug  7 23:10:02 void wpa_supplicant[16215]: Association request to the driver failed
   Aug  7 23:10:07 void wpa_supplicant[16215]: Authentication with 00:00:00:00:00:00 timed out.
   Aug  7 23:10:07 void wpa_supplicant[16215]: Failed to initiate AP scan.
   Aug  7 23:10:08 void kernel: wlan0: authenticate with AP 00:00:00:00:00:00
   Aug  7 23:10:08 void kernel: wlan0: authenticated
   Aug  7 23:10:08 void kernel: wlan0: associate with AP 00:00:00:00:00:00
   Aug  7 23:10:08 void kernel: wlan0: RX AssocResp from 00:00:00:00:00:00 (capab=0x411 status=0 aid=1)
   Aug  7 23:10:08 void kernel: wlan0: associated
   Aug  7 23:10:08 void wpa_supplicant[16215]: Associated with 00:00:00:00:00:00
   Aug  7 23:10:08 void wpa_supplicant[16215]: WPA: Key negotiation completed with 00:00:00:00:00:00 [PTK=CCMP GTK=TKIP]
   Aug  7 23:10:08 void wpa_supplicant[16215]: CTRL-EVENT-CONNECTED - Connection to 00:00:00:00:00:00 completed (auth) [id=0 id_str=]
   Aug  7 23:10:12 void wpa_supplicant[16215]: CTRL-EVENT-SCAN-RESULTS 
   Aug  7 23:10:12 void wpa_supplicant[16215]: Trying to associate with 00:00:00:00:00:00 (SSID='...' freq=2412 MHz)
   Aug  7 23:10:12 void wpa_supplicant[16215]: Association request to the driver failed
   Aug  7 23:10:12 void wpa_supplicant[16215]: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
   Aug  7 23:10:17 void wpa_supplicant[16215]: Authentication with 00:00:00:00:00:00 timed out.
   (etc. -- repeats)
   
(The difference is the "Authentication with 00:00:00:00:00:00 timed out.")

   
To fix this I need to unload and reload the ath5k module
(with modprobe ath5k -r, so it actually unloads ath, mac80211
and cfg80211, too).  When I reload ath5k, it often fails with:
   
   ath5k 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
   ath5k 0000:02:02.0: registered as 'phy0'
   ath5k phy0: failed to wakeup the MAC Chip
   ath5k 0000:02:02.0: PCI INT A disabled
   ath5k: probe of 0000:02:02.0 failed with error -5


Sometimes I can fix this by unloading + reloading again,
but often I need to unload, suspend, resume, reload to
get it back in a working state.

During resume the following is logged:

   ath5k 0000:02:02.0: restoring config space at offset 0x3 (was 0x5008, writing 0xa808)
   pm_op(): pci_pm_resume+0x0/0x79 returns -16
   PM: Device 0000:00:00.0 failed to resume: error -16

Not sure if this is causing the problem?

In case it matters:
  CONFIG_MAC80211_DEFAULT_PS=y
  CONFIG_MAC80211_DEFAULT_PS_VALUE=1


Thanks,
Johannes
