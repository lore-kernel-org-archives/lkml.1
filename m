Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYHEBaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYHEBaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 21:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbYHEB3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 21:29:30 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:13942 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYHEB32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 21:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KvaCZk72+tNkWwntmcqGPw4qhx1Cs0ZaXu2SuSM93YB4yP724nPaHu/fEOyhRe+h9X
         Sm+otRmGI5UpwJ9NRuqCduempyPtTljq1epKeEAtNZ8kX8c3a8Dyh4DHNy5baEzZFMaW
         WILEnT1rZSiGetuSyyU30+PhQz6E6sGVhBFHE=
Message-ID: <a8e1da0808041829sac34939yd9163b02e6b8b515@mail.gmail.com>
Date: Tue, 5 Aug 2008 09:29:26 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [BUG] wireless : cpu stuck for 61s
Cc: "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "Bob Copeland" <me@bobcopeland.com>
In-Reply-To: <4896D34A.1000005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729055731.GA3265@darkstar>
	 <1217334724.10489.47.camel@johannes.berg>
	 <20080730020820.8bcc00e2.akpm@linux-foundation.org>
	 <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
	 <20080730031047.54e13e2d.akpm@linux-foundation.org>
	 <a8e1da0808010032h32c18054g3712466eb40f0acf@mail.gmail.com>
	 <4896D34A.1000005@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 6:00 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Dave Young napsal(a):
>>
>> Lockdep helped me, this morning I get a lockdep warning about this,
>>
>> [  171.432140] [ INFO: possible recursive locking detected ]
>> [  171.433113] 2.6.27-rc1-smp #4
>> [  171.434079] ---------------------------------------------
>> [  171.435039] ath5k_pci/2447 is trying to acquire lock:
>> [  171.435990]  (&sc->lock){--..}, at: [<f89ee9b5>]
>> ath5k_config_interface+0xd5/0x340 [ath5k]
>> [  171.437046]
>> [  171.437048] but task is already holding lock:
>> [  171.438903]  (&sc->lock){--..}, at: [<f89ee91d>]
>> ath5k_config_interface+0x3d/0x340 [ath5k]
>> [  171.439953]
>> [  171.439954] other info that might help us debug this:
>> [  171.441795] 3 locks held by ath5k_pci/2447:
>> [  171.442729]  #0:  ((name)){--..}, at: [<c013a122>]
>> run_workqueue+0x102/0x1d0
>> [  171.443800]  #1:  (&(&local->scan_work)->work){--..}, at:
>> [<c013a122>] run_workqueue+0x102/0x1d0
>> [  171.444859]  #2:  (&sc->lock){--..}, at: [<f89ee91d>]
>> ath5k_config_interface+0x3d/0x340 [ath5k]
>>
>> Deadlock happen here, I remove the lock in the sub routine, tested and
>> fixed the problem for me.
>> I will send the patch after a while.
>
> That's some kind different. 2.6.26 can't suffer from the thing above
> (opposing to 27-rc1).

Yes, it's got with 27-rc1

>
> Pasting the original issue below. Maybe it's been fixed too? I suppose you
> don't encounter the problem anymore in 27-rc1 with your/Bob's/mine (fix for
> the same thing in the same manner) patch applied?

With the patch I cann't reproduce the bug with 27-rc1 now.

>
> BUG: soft lockup - CPU#0 stuck for 61s! [events/0:9]
> Modules linked in: radeonfb fb_ddc i2c_algo_bit snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm
> l2cap bluetooth vfat fuse rtc_cmos rtc_core psmouse intel_agp pl2303 rtc_lib
> ath5k e100 i2c_i801 serio_raw usbserial agpgart 3c59x mii snd_hda_intel
> snd_pcm mac80211 snd_timer snd_page_alloc cfg80211 snd_hwdep snd soundcore
> thermal processor button thermal_sys evdev sg
>
> Pid: 9, comm: events/0 Tainted: G        W (2.6.26-smp #3)
> EIP: 0060:[<c0450bc3>] EFLAGS: 00000246 CPU: 0
> EIP is at mutex_lock_nested+0x1b3/0x280
> EAX: 00000000 EBX: f7bf5284 ECX: f7c7e000 EDX: f7bf52a8
> ESI: f7bf5288 EDI: 00000246 EBP: f7c7fedc ESP: f7c7fe9c
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: b800c5ac CR3: 36e71000 CR4: 000006d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c02375a6>] ? debugfs_create_file+0x46/0x210
>  [<c02375a6>] ? debugfs_create_file+0x46/0x210
>  [<c02375a6>] debugfs_create_file+0x46/0x210
>  [<c02377f1>] debugfs_create_dir+0x21/0x30
>  [<f8901f6d>] ieee80211_sta_debugfs_add+0x2d/0x150 [mac80211]
>  [<f88eba89>] sta_info_debugfs_add_work+0x89/0x130 [mac80211]
>  [<f890a170>] ? rate_control_pid_add_sta_debugfs+0x0/0x30 [mac80211]
>  [<c01394c6>] run_workqueue+0x156/0x1d0
>  [<c0139472>] ? run_workqueue+0x102/0x1d0
>  [<f88eba00>] ? sta_info_debugfs_add_work+0x0/0x130 [mac80211]
>  [<c0139f18>] worker_thread+0x88/0xe0
>  [<c013cd20>] ? autoremove_wake_function+0x0/0x40
>  [<c0139e90>] ? worker_thread+0x0/0xe0
>  [<c013ca32>] kthread+0x42/0x70
>  [<c013c9f0>] ? kthread+0x0/0x70
>  [<c0104993>] kernel_thread_helper+0x7/0x14
>  =======================
> BUG: soft lockup - CPU#0 stuck for 61s! [events/0:9]
> Modules linked in: radeonfb fb_ddc i2c_algo_bit snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm
> l2cap bluetooth vfat fuse rtc_cmos rtc_core psmouse intel_agp pl2303 rtc_lib
> ath5k e100 i2c_i801 serio_raw usbserial agpgart 3c59x mii snd_hda_intel
> snd_pcm mac80211 snd_timer snd_page_alloc cfg80211 snd_hwdep snd soundcore
> thermal processor button thermal_sys evdev sg
>
> Pid: 9, comm: events/0 Tainted: G        W (2.6.26-smp #3)
> EIP: 0060:[<c0450bc3>] EFLAGS: 00000246 CPU: 0
> EIP is at mutex_lock_nested+0x1b3/0x280
> EAX: 00000000 EBX: f7bf5284 ECX: f7c7e000 EDX: f7bf52a8
> ESI: f7bf5288 EDI: 00000246 EBP: f7c7fedc ESP: f7c7fe9c
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: b800c5ac CR3: 36e71000 CR4: 000006d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c02375a6>] ? debugfs_create_file+0x46/0x210
>  [<c02375a6>] ? debugfs_create_file+0x46/0x210
>  [<c02375a6>] debugfs_create_file+0x46/0x210
>  [<c02377f1>] debugfs_create_dir+0x21/0x30
>  [<f8901f6d>] ieee80211_sta_debugfs_add+0x2d/0x150 [mac80211]
>  [<f88eba89>] sta_info_debugfs_add_work+0x89/0x130 [mac80211]
>  [<f890a170>] ? rate_control_pid_add_sta_debugfs+0x0/0x30 [mac80211]
>  [<c01394c6>] run_workqueue+0x156/0x1d0
>  [<c0139472>] ? run_workqueue+0x102/0x1d0
>  [<f88eba00>] ? sta_info_debugfs_add_work+0x0/0x130 [mac80211]
>  [<c0139f18>] worker_thread+0x88/0xe0
>  [<c013cd20>] ? autoremove_wake_function+0x0/0x40
>  [<c0139e90>] ? worker_thread+0x0/0xe0
>  [<c013ca32>] kthread+0x42/0x70
>  [<c013c9f0>] ? kthread+0x0/0x70
>  [<c0104993>] kernel_thread_helper+0x7/0x14
>  =======================
>



-- 
Regards
dave
