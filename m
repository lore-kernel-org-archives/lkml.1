Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbYJ0UjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbYJ0UjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYJ0Uix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:38:53 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:34788 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbYJ0Uiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:38:52 -0400
Date: Mon, 27 Oct 2008 21:39:25 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Message-ID: <20081027203925.GA4416@localhost.aei.mpg.de>
References: <20081027162054.GA4015@localhost.aei.mpg.de> <200810271832.40717.rjw@sisk.pl> <1225130844.4466.0.camel@localhost> <1225132278.3796.32.camel@johannes.berg> <1225133082.3796.35.camel@johannes.berg> <20081027190011.GA3951@localhost.aei.mpg.de> <1225134195.3796.39.camel@johannes.berg> <20081027191118.GA4058@localhost.aei.mpg.de> <1225134823.3796.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225134823.3796.45.camel@johannes.berg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Oct'08 at 20:13:43 +0100, Johannes Berg wrote:
> On Mon, 2008-10-27 at 20:11 +0100, Carlos R. Mafra wrote:
> 
> > > Do you get any kernel messages output? If you do, could you put messages
> > > into each line of ieee80211_set_disassoc to see where it hangs?
> > 
> > No messages appear, just a black screen.
> > 
> > But I can use the SysRq keys, and when I umount the
> > screen shows the message that umount succeed. I also tried SysRq+t but
> > the messages appear to fast to read.
> 
> Ok, but that means you _can_ get messages, it would help a lot if you
> could put a few printks into the set_disassoc function before/after each
> other function call, so we know where exactly it hangs. Pretty much all
> of them could possibly hang if there is some sort of locking error
> happening or anything relies on userspace to be running...

Ok, I humbly tried to do that with the patch at the end of the email,
but I did not appear to hang in this function tough.

Somehow I could get some messages printed when it was a black screen
before (I think it has to do with the debug level I set with SysRq...)
and I could see all the printks I've put there. 

The good thing is that I could get the complete syslog of the boot until 
the it failed after suspending to RAM (in 2.6.28-rc2 with my debug patch
below applied). The last messages before the laptop become unresponsive
(except for the SysRq) were these ones:

Oct 27 21:03:06 localhost kernel: Registered led device: iwl-phy0:radio
Oct 27 21:03:06 localhost kernel: Registered led device: iwl-phy0:assoc
Oct 27 21:03:06 localhost kernel: Registered led device: iwl-phy0:RX
Oct 27 21:03:06 localhost kernel: Registered led device: iwl-phy0:TX
Oct 27 21:03:06 localhost kernel: before rcu_read_lock
Oct 27 21:03:06 localhost kernel: before netif_tx_stop_all_queues
Oct 27 21:03:06 localhost kernel: before netif_carrier_off
Oct 27 21:03:06 localhost kernel: before ieee80211_sta
Oct 27 21:03:06 localhost kernel: inside sef_disconnected 1
Oct 27 21:03:06 localhost kernel: before ieee8021_led_assoc
Oct 27 21:03:06 localhost kernel: before ieee8021_sta_send_apinfo
Oct 27 21:03:06 localhost kernel: before sta_info_unlink
Oct 27 21:03:06 localhost kernel: before rcu_read_unlock
Oct 27 21:03:06 localhost kernel: before sta_info_destroy
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Starting disk
Oct 27 21:03:06 localhost kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
Oct 27 21:03:06 localhost kernel: ata1.00: configured for UDMA/100
Oct 27 21:03:06 localhost kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
Oct 27 21:03:06 localhost kernel: ata1: irq_stat 0x00000040, connection status changed
Oct 27 21:03:06 localhost kernel: ata1: hard resetting link
Oct 27 21:03:06 localhost kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
Oct 27 21:03:06 localhost kernel: ata1.00: configured for UDMA/100
Oct 27 21:03:06 localhost kernel: ata1: EH complete
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 27 21:03:06 localhost kernel: Restarting tasks ... done.
Oct 27 21:03:07 localhost ifplugd(wlan0)[3182]: Link beat lost.
Oct 27 21:03:13 localhost ifplugd(wlan0)[3182]: Executing '/etc/ifplugd/ifplugd.action wlan0 down'.
Oct 27 21:06:20 localhost kernel: SysRq : Changing Loglevel
Oct 27 21:06:20 localhost kernel: Loglevel set to 4
Oct 27 21:06:22 localhost kernel: SysRq : Changing Loglevel
Oct 27 21:06:22 localhost kernel: Loglevel set to 6
Oct 27 21:06:32 localhost kernel: ffff80251670>] ? autoremove_wake_function+0x0/0x40
Oct 27 21:06:32 localhost kernel:  [<ffffffff8024e200>] ? worker_thread+0x0/0x110
Oct 27 21:06:32 localhost kernel:  [<ffffffff8025119d>] kthread+0x4d/0x80
Oct 27 21:06:32 localhost kernel:  [<ffffffff8020d1b9>] child_rip+0xa/0x11

and I have the complete trace also. I can try to put it somewhere in the web if it helps
(I already tried it, but I am new at the institute here and I could not set up my
webpage yet :-(

This is the patch I applied, I don't know if this helps or not...

---
 net/mac80211/mlme.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 87665d7..c6e3338 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -819,10 +819,12 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	u32 changed = BSS_CHANGED_ASSOC;
 
+	printk("before rcu_read_lock\n");
 	rcu_read_lock();
 
 	sta = sta_info_get(local, ifsta->bssid);
 	if (!sta) {
+		printk("before rcu_read_unlock\n");
 		rcu_read_unlock();
 		return;
 	}
@@ -834,18 +836,24 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	ifsta->assoc_scan_tries = 0;
 	ifsta->assoc_tries = 0;
 
+	printk("before netif_tx_stop_all_queues\n");
 	netif_tx_stop_all_queues(sdata->dev);
+	printk("before netif_carrier_off\n");
 	netif_carrier_off(sdata->dev);
 
+	printk("before ieee80211_sta\n");
 	ieee80211_sta_tear_down_BA_sessions(sdata, sta->sta.addr);
 
 	if (self_disconnected) {
-		if (deauth)
+		if (deauth) {
+			printk("inside sef_disconnected 1\n");
 			ieee80211_send_deauth_disassoc(sdata,
 				IEEE80211_STYPE_DEAUTH, reason);
-		else
+		} else {
+			printk("inside sef_disconnected 2\n");
 			ieee80211_send_deauth_disassoc(sdata,
 				IEEE80211_STYPE_DISASSOC, reason);
+		}
 	}
 
 	ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
@@ -858,18 +866,23 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sdata->bss_conf.ht_conf = NULL;
 	sdata->bss_conf.ht_bss_conf = NULL;
 
+	printk("before ieee8021_led_assoc\n");
 	ieee80211_led_assoc(local, 0);
 	sdata->bss_conf.assoc = 0;
 
+	printk("before ieee8021_sta_send_apinfo\n");
 	ieee80211_sta_send_apinfo(sdata, ifsta);
 
 	if (self_disconnected)
 		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 
+	printk("before sta_info_unlink\n");
 	sta_info_unlink(&sta);
 
+	printk("before rcu_read_unlock\n");
 	rcu_read_unlock();
 
+	printk("before sta_info_destroy\n");
 	sta_info_destroy(sta);
 }
 




