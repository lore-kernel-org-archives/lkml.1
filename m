Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYJ0VHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYJ0VHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYJ0VHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:07:06 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:18065 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0VHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pjhfu0mTvqTCxyuqiezTFLiFSoKLRRsffT10Aa2hgeryEwWhZczjzBWDkaUfPr0Cs6
         UZtzdddEccudBr52rNPNLPJbr04TfqFJmRwYYUTYuOxcpv/Q0Z0FY6xFnPikIa6IgqqO
         fEoJeGbLF9YUTE6Jifl8CcEoC+DGwkL0VacME=
Message-ID: <1ba2fa240810271407o15f1f150t2d2793f4e5ad6e5b@mail.gmail.com>
Date: Mon, 27 Oct 2008 23:07:00 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Soeren Sonnenburg" <kernel@nn7.de>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200810272151.01244.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <1225134823.3796.45.camel@johannes.berg>
	 <20081027203925.GA4416@localhost.aei.mpg.de>
	 <200810272151.01244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 10:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 27 of October 2008, Carlos R. Mafra wrote:
>> On Mon 27.Oct'08 at 20:13:43 +0100, Johannes Berg wrote:
>> > On Mon, 2008-10-27 at 20:11 +0100, Carlos R. Mafra wrote:
>> >
>> > > > Do you get any kernel messages output? If you do, could you put messages
>> > > > into each line of ieee80211_set_disassoc to see where it hangs?
>> > >
>> > > No messages appear, just a black screen.
>> > >
>> > > But I can use the SysRq keys, and when I umount the
>> > > screen shows the message that umount succeed. I also tried SysRq+t but
>> > > the messages appear to fast to read.
>> >
>> > Ok, but that means you _can_ get messages, it would help a lot if you
>> > could put a few printks into the set_disassoc function before/after each
>> > other function call, so we know where exactly it hangs. Pretty much all
>> > of them could possibly hang if there is some sort of locking error
>> > happening or anything relies on userspace to be running...
>>
>> Ok, I humbly tried to do that with the patch at the end of the email,
>> but I did not appear to hang in this function tough.
>>
>> Somehow I could get some messages printed when it was a black screen
>> before (I think it has to do with the debug level I set with SysRq...)
>> and I could see all the printks I've put there.
>>
>> The good thing is that I could get the complete syslog of the boot until
>> the it failed after suspending to RAM (in 2.6.28-rc2 with my debug patch
>> below applied). The last messages before the laptop become unresponsive
>> (except for the SysRq) were these ones:
>>
>> Oct 27 21:03:06 localhost kernel: Registered led device: iwl-phy0:radio
>> Oct 27 21:03:06 localhost kernel: Registered led device: iwl-phy0:assoc
>> Oct 27 21:03:06 localhost kernel: Registered led device: iwl-phy0:RX
>> Oct 27 21:03:06 localhost kernel: Registered led device: iwl-phy0:TX
>> Oct 27 21:03:06 localhost kernel: before rcu_read_lock
>> Oct 27 21:03:06 localhost kernel: before netif_tx_stop_all_queues
>> Oct 27 21:03:06 localhost kernel: before netif_carrier_off
>> Oct 27 21:03:06 localhost kernel: before ieee80211_sta
>> Oct 27 21:03:06 localhost kernel: inside sef_disconnected 1
>> Oct 27 21:03:06 localhost kernel: before ieee8021_led_assoc
>> Oct 27 21:03:06 localhost kernel: before ieee8021_sta_send_apinfo
>> Oct 27 21:03:06 localhost kernel: before sta_info_unlink
>> Oct 27 21:03:06 localhost kernel: before rcu_read_unlock
>> Oct 27 21:03:06 localhost kernel: before sta_info_destroy
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Starting disk
>> Oct 27 21:03:06 localhost kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
>> Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
>> Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
>> Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
>> Oct 27 21:03:06 localhost kernel: ata1.00: configured for UDMA/100
>> Oct 27 21:03:06 localhost kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
>> Oct 27 21:03:06 localhost kernel: ata1: irq_stat 0x00000040, connection status changed
>> Oct 27 21:03:06 localhost kernel: ata1: hard resetting link
>> Oct 27 21:03:06 localhost kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
>> Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
>> Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd ef/90:03:00:00:00:a0 succeeded
>> Oct 27 21:03:06 localhost kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
>> Oct 27 21:03:06 localhost kernel: ata1.00: configured for UDMA/100
>> Oct 27 21:03:06 localhost kernel: ata1: EH complete
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 GB/232 GiB)
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> Oct 27 21:03:06 localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> Oct 27 21:03:06 localhost kernel: Restarting tasks ... done.
>> Oct 27 21:03:07 localhost ifplugd(wlan0)[3182]: Link beat lost.
>> Oct 27 21:03:13 localhost ifplugd(wlan0)[3182]: Executing '/etc/ifplugd/ifplugd.action wlan0 down'.
>> Oct 27 21:06:20 localhost kernel: SysRq : Changing Loglevel
>> Oct 27 21:06:20 localhost kernel: Loglevel set to 4
>> Oct 27 21:06:22 localhost kernel: SysRq : Changing Loglevel
>> Oct 27 21:06:22 localhost kernel: Loglevel set to 6
>> Oct 27 21:06:32 localhost kernel: ffff80251670>] ? autoremove_wake_function+0x0/0x40
>> Oct 27 21:06:32 localhost kernel:  [<ffffffff8024e200>] ? worker_thread+0x0/0x110
>> Oct 27 21:06:32 localhost kernel:  [<ffffffff8025119d>] kthread+0x4d/0x80
>> Oct 27 21:06:32 localhost kernel:  [<ffffffff8020d1b9>] child_rip+0xa/0x11
>>
>> and I have the complete trace also. I can try to put it somewhere in the web if it helps
>> (I already tried it, but I am new at the institute here and I could not set up my
>> webpage yet :-(
>
> Please attach it to http://bugzilla.kernel.org/show_bug.cgi?id=11845 .

Can someone try this one (it might be space broken I've just pasted
that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
(latest linux-2.6.git)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c
b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 24a1aeb..321dbc8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2090,7 +2090,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
                iwl4965_error_recovery(priv);

        iwl_power_update_mode(priv, 1);
-       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);

        if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
                iwl4965_set_mode(priv, priv->iw_mode);
@@ -2342,6 +2341,7 @@ static void iwl_bg_alive_start(struct work_struct *data)
        mutex_lock(&priv->mutex);
        iwl_alive_start(priv);
        mutex_unlock(&priv->mutex);
+       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }

 static void iwl4965_bg_rf_kill(struct work_struct *work)


Thanks
Tomas
