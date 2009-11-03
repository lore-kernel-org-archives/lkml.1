Return-Path: <linux-kernel-owner+w=401wt.eu-S1751277AbZKCFb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbZKCFb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 00:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbZKCFb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 00:31:57 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:61068 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZKCFbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 00:31:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ewDgvkPya/mXwq+pnHvAOzBVoLh/7zSTaVZHcPxSckbm1pSpbjwWuSXPn+oAInOYCm
         qY7jDURt6/QuILpGbU1blm4XEAPV130uCZYjiZCTxnr85SIPMxEgr8lSibBGRisZ4J2X
         UndYenACaeFgm8xNcKL+m5/Xu1/W2svFOZ4CE=
Date: Mon, 2 Nov 2009 21:31:56 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Please consider reverting 7d930bc33653d5592dc386a76a38f39c2e962344
Message-ID: <20091103053156.GA3212@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It looks like

commit 7d930bc33653d5592dc386a76a38f39c2e962344
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Oct 20 15:08:53 2009 +0900

    cfg80211: sme: deauthenticate on assoc failure

    When the in-kernel SME gets an association failure from
    the AP we don't deauthenticate, and thus get into a very
    confused state which will lead to warnings later on. Fix
    this by actually deauthenticating when the AP indicates
    an association failure.

    (Brought to you by the hacking session at Kernel Summit 2009 in Tokyo,
    Japan. -- JWL)

    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

is causing oops on resume:

Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588844] BUG: unable to handle kernel NULL pointer dereference at (null)
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588852] IP: [<ffffffffa0b6d4d3>] cfg80211_conn_work+0x87/0x128 [cfg80211]
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588869] PGD 110bb4067 PUD 11a605067 PMD 0
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588875] Oops: 0000 [#1] PREEMPT SMP
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588880] last sysfs file: /sys/power/state
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588884] CPU 0
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588886] Modules linked in: fuse rfcomm sco bnep l2cap crc16 sunrpc autofs4 coretemp hwmon vmnet vmblock vsock vmci vmmon acpi_cpufreq uinput arc4 ecb snd_hda_codec_idt iwl3945 joydev iwlcore snd_hda_intel firewire_ohci snd_hda_codec snd_hwdep snd_pcm ppdev mac80211 tg3 firewire_core parport_pc psmouse snd_timer yenta_socket dell_laptop parport cfg80211 dcdbas nvidia(P) wmi video ac btusb bluetooth crc_itu_t rsrc_nonstatic serio_raw snd libphy battery pcspkr output iTCO_wdt soundcore snd_page_alloc i2c_i801 i2c_core iTCO_vendor_support ohci_hcd [last unloaded: microcode]
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588957] Pid: 9, comm: events/0 Tainted: P           2.6.32-rc5 #78 Latitude D630
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588960] RIP: 0010:[<ffffffffa0b6d4d3>]  [<ffffffffa0b6d4d3>] cfg80211_conn_work+0x87/0x128 [cfg80211]
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588970] RSP: 0000:ffff88011f8afd10  EFLAGS: 00010246
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588973] RAX: 0000000000000000 RBX: ffff8801183d4810 RCX: 0000000000000000
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588975] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8801183d4810
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588978] RBP: ffff88011f8afd80 R08: ffff8801183d4870 R09: 0000000000000000
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588981] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880118de0000
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588983] R13: ffff88011f8afd40 R14: ffff880118de00f8 R15: ffff880118de0018
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588986] FS:  0000000000000000(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588989] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588992] CR2: 0000000000000000 CR3: 000000011afe5000 CR4: 00000000000006f0
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588995] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.588997] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589001] Process events/0 (pid: 9, threadinfo ffff88011f8ae000, task ffff88011f8b8000)
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589003] Stack:
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589005]  0000000000000000 ffffffff8105b93e ffff880100000000 0000000000000046
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006] <0> ffff88011f8afd50 ffff880118de0170 ffff88011f8afdf0 0000000000000246
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006] <0> ffff88011f8afd60 ffff8800282169c0 ffff88011f8b8000 ffff880118de0260
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006] Call Trace:
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8105b93e>] ? run_workqueue+0x12f/0x26d
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8105b990>] run_workqueue+0x181/0x26d
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8105b93e>] ? run_workqueue+0x12f/0x26d
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffffa0b6d44c>] ? cfg80211_conn_work+0x0/0x128 [cfg80211]
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8105bb5c>] worker_thread+0xe0/0xf3
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8105f951>] ? autoremove_wake_function+0x0/0x34
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8105ba7c>] ? worker_thread+0x0/0xf3
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8105f5ed>] kthread+0x7a/0x82
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8100cc9a>] child_rip+0xa/0x20
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8100c600>] ? restore_args+0x0/0x30
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8105f573>] ? kthread+0x0/0x82
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  [<ffffffff8100cc90>] ? child_rip+0x0/0x20
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006] Code: eb 7f 48 89 df e8 ba e7 ff ff 48 8b 43 20 f6 40 48 01 74 5d 83 bb fc 00 00 00 01 75 54 48 8b 83 00 01 00 00 48 89 df 48 8b 40 08 <8b> 10 41 89 55 00 66 8b 40 04 66 41 89 45 04 e8 c6 eb ff ff 85
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006] RIP  [<ffffffffa0b6d4d3>] cfg80211_conn_work+0x87/0x128 [cfg80211]
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006]  RSP <ffff88011f8afd10>
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589006] CR2: 0000000000000000
Nov  2 20:24:01 dtor-d630 kernel: [ 4696.589257] ---[ end trace 7169bd444788bb37 ]---

Reverting this particular commit allows me to suspend/resume again.

Thanks!

-- 
Dmitry
