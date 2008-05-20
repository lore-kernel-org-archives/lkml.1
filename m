Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbYETStx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbYETStx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756541AbYETStn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:49:43 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:28038 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbYETStm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=NK2oa0i/bsxKWoYflkgMnu/UFRZKHfi7ZX8th7NOAdfpuRacxJTeiJ8S91bZ36cppz5pfET5hf76H+CnhydkR9c1EDVlx7GFhiqO6gMq+wTg/CJgkA79jMrLWs3jwlyUJJXNcOejEvTXFy8TSPoMErH4ynODZcE522vti4N24sQ=
Date: Tue, 20 May 2008 21:49:30 +0300
From: m.s.tsirkin@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, johannes@sipsolutions.net,
       flamingice@sourmilk.net
Subject: regression iwl3945/mac80211: association times out since 2.6.26-rc1
Message-ID: <20080520184859.GA8168@robinhood.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
In all  of 2.6.26-rc1, rc2 and rc3, my iwl3945 wifi card can't associate with my access point.
It does associate in 2.6.25.

under 2.6.-26-rc[1,2,3] wpa_supplicant reports:

	Trying to associate with 00:16:e3:ef:5d:f0 (SSID='' freq=0 MHz)
	Authentication with 00:00:00:00:00:00 timed out.

where under 2.6.25 I was associating with 
	Trying to associate with 00:16:e3:ef:5d:f0 (SSID='SIEMENS-EF5DF0' freq=2437 MHz)
	Associated with 00:16:e3:ef:5d:f0
	WPA: Key negotiation completed with 00:16:e3:ef:5d:f0 [PTK=CCMP GTK=CCMP]

I tried bisecting, and I got as far as
git-bisect good 4b119e21d0c66c22e8ca03df05d9de623d0eb50f
git-bisect bad 96d510566e4908f77f03ff1436c78ae7162a17d0

but a point between these 2 commits gets me iwl driver that hangs kernel
when it's loaded, so I gave up on bisecting at this point.
Still this leaves us with 91 candidates that might be introducing the regression
(get their list with git log
 4b119e21d0c66c22e8ca03df05d9de623d0eb50f..96d510566e4908f77f03ff1436c78ae7162a17d0)

Additional info:

I get this in dmesg

[   99.153033] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   99.204031] PM: Adding info for No Bus:iwl-phy1:radio
[   99.204031] Registered led device: iwl-phy1:radio
[   99.204031] PM: Adding info for No Bus:iwl-phy1:assoc
[   99.204031] Registered led device: iwl-phy1:assoc
[   99.204031] PM: Adding info for No Bus:iwl-phy1:RX
[   99.204031] Registered led device: iwl-phy1:RX
[   99.204031] PM: Adding info for No Bus:iwl-phy1:TX
[   99.204031] Registered led device: iwl-phy1:TX
[   99.220405] ADDRCONF(NETDEV_UP): wlan0: link is not ready

and even though the led now lights up, there's no association.

portions of .config: 2.6.26-rc3:

CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
# CONFIG_IWLWIFI_LEDS is not set
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=m
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
CONFIG_IWL3945_DEBUG=y

2.6.25:
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=m
CONFIG_IWL3945_QOS=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_DEBUG=y


What kind of additional information would be useful for debugging this regression?

Thanks!

-- 
MST
