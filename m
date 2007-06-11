Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbXFKTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbXFKTYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXFKTYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:24:15 -0400
Received: from mga06.intel.com ([134.134.136.21]:7513 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbXFKTYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:24:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="253173632"
Message-ID: <466DA14D.6080309@linux.intel.com>
Date: Mon, 11 Jun 2007 12:23:57 -0700
From: James Ketrenos <jketreno@linux.intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Zhu Yi <yi.zhu@intel.com>
Subject: Re: ipw3945 driver in recent -mm kernels
References: <20070609192703.GA6410@elf.ucw.cz> <20070609215712.GA13678@elf.ucw.cz>
In-Reply-To: <20070609215712.GA13678@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> I tried to use `subj`, but hit few problems:
>>
>> There's no maintainers entry. Should
>>
>>  James P. Ketrenos <ipw2100-admin@linux.intel.com> 

Forgot to include changes outside of drivers/net/wireless/mac80211/iwlwifi/

Zhu Yi is the maintainer for the iwlwifi driver (Cc: on this email)

>>
>> be listed as a maintainer?
>>
>> Kconfig mentions...
>>
>>           See <file:Documentation/networking/README.iwlwifi> for
>>           information on the capabilities currently enabled in this
>>           driver and for tips for debugging issues and problems.

We'll remove that from the Kconfig until we get the document updated
to reflect the current status.

>> ...but that file does not exist.
> 
> More problems: 
> 
> I managed to load the firmware and insert the module.... but I had
> radio kill switch on. It complained that kill switch is on, but
> turning it off did not help. Module unload/reload was neccessary to
> get it to work.

We're working on this one.  http://bughost.org/bugzilla/show_bug.cgi?id=1209

> I still do not see the wlan led. It seems to scan okay, but I can't
> seem to connect, and I get this in logs:
> 
> Jun  9 23:53:21 amd kernel: wlan0: deauthenticated
> Jun  9 23:53:21 amd kernel: wlan0: RX deauthentication from
> 00:11:2f:0e:95:a0 (reason=4)

>From Table 19 in the IEEE 802.11 spec lists reason 4 a 
'disassociation due to inactivity'  Odd that it would happen during
 association.  Were you able to associate at all before you
started seeing the problem?

> Jun  9 23:53:21 amd last message repeated 2 times
> Jun  9 23:53:22 amd kernel: wlan0: authenticate with AP
> 00:11:2f:0e:95:a0
> Jun  9 23:53:22 amd kernel: wlan0: RX authentication from
> 00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
> Jun  9 23:53:22 amd kernel: wlan0: authenticated
> Jun  9 23:53:22 amd kernel: wlan0: associate with AP 00:11:2f:0e:95:a0
> Jun  9 23:53:22 amd kernel: wlan0: authentication frame received from
> 00:11:2f:0e:95:a0, but not in authenticate state - ignored
> Jun  9 23:53:22 amd last message repeated 2 times
> Jun  9 23:53:22 amd kernel: wlan0: RX ReassocResp from
> 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=2)
> Jun  9 23:53:22 amd kernel: wlan0: associated
> Jun  9 23:53:24 amd kernel: wlan0: No ProbeResp from current AP
> 00:11:2f:0e:95:a0 - assume out of range

This may be related to mac80211's link activity detection
at times immediately following an association/reassociation.

I've seen similar behavior here; a temporary work around I am using is 
to disable the 'lost link detection' in mac80211.  

Can you try this and see if it helps your association situation (it 
may introduce other problems related to roaming and automatic 
disassociation...)

---
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 9f30ae4..b296530 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -736,11 +736,15 @@ static void ieee80211_associated(struct net_device *dev,
 		if (time_after(jiffies,
 			       sta->last_rx + IEEE80211_MONITORING_INTERVAL)) {
 			if (ifsta->probereq_poll) {
+/*
 				printk(KERN_DEBUG "%s: No ProbeResp from "
 				       "current AP " MAC_FMT " - assume out of "
 				       "range\n",
 				       dev->name, MAC_ARG(ifsta->bssid));
 				disassoc = 1;
+*/
+				printk(KERN_DEBUG "%s: Ignoring 'lost link "
+				       "detection'\n", dev->name);
 				sta_info_free(sta, 0);
 				ifsta->probereq_poll = 0;
 			} else {

---
...
> Jun  9 23:54:12 amd kernel: iwl3945: Microcode SW error detected.
> Restarting 0x82000000.
> Jun  9 23:54:12 amd kernel: iwl3945: Error Reply type 0x0000003A cmd
> REPLY_RXON_ASSOC (0x11) seq 0x0447 ser 0x00000000
> Jun  9 23:54:12 amd kernel: iwl3945: Error setting RXON_ASSOC
> configuration (-5).
> Jun  9 23:54:13 amd kernel: iwl3945: Error sending REPLY_RXON: time
> out after 500ms.

Loading the module with debug=0x40000 will turn on the the uCode event 
log dumping which may help in isolating the uCode reset problem.  Can
you load the module with the module parameter debug=0x40000 and send us 
the resulting syslog output when the error is tripped?

Thanks,
James
