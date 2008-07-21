Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYGUTnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYGUTnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYGUTnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:43:35 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:35026 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbYGUTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:43:34 -0400
Message-ID: <4884E6E6.7010800@lwfinger.net>
Date: Mon, 21 Jul 2008 14:43:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Schram <ischram@telenet.be>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       wireless <linux-wireless@vger.kernel.org>, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <20080721134506.GA27598@elte.hu> <20080721143023.GA32451@elte.hu> <20080721150446.GA17746@elte.hu> <20080721.082419.70392960.davem@davemloft.net> <4884D2F1.2030704@telenet.be> <20080721190646.GA19044@elte.hu> <4884DFEE.4060003@lwfinger.net> <20080721193425.GA29287@elte.hu>
In-Reply-To: <20080721193425.GA29287@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> Ingo Molnar wrote:
>>> * Ian Schram <ischram@telenet.be> wrote:
>>>
>>>> I was looking at this out of interest, but I'm in no way familiar 
>>>> with the code.
>>> thanks Ian for the patch, i'll test it.
>>>
>>> Note that it was whitespace damaged, find below a tidied up version of  
>>> the patch that i've applied to tip/out-of-tree.
>>>
>>> 	Ingo
>> This patch may be needed to fix error handling in the hw_sim code, but 
>> I get the crash even with that code disabled. I'm currently bisecting 
>> to find the culprit.
> 
> ok. I just reactivated CONFIG_MAC80211_HWSIM, applied Ian's fix and the 
> crash went away:
> 
>  calling  iwl4965_init+0x0/0x6c
>  iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.3.27kd
>  iwl4965: Copyright(c) 2003-2008 Intel Corporation
>  initcall iwl4965_init+0x0/0x6c returned 0 after 10 msecs
>  calling  init_mac80211_hwsim+0x0/0x31c
>  mac80211_hwsim: Initializing radio 0
>  PM: Adding info for No Bus:hwsim0
>  PM: Adding info for No Bus:phy0
>  PM: Adding info for No Bus:wmaster0
>  phy0: Failed to select rate control algorithm
>  phy0: Failed to initialize rate control algorithm
>  PM: Removing info for No Bus:wmaster0
>  PM: Removing info for No Bus:phy0
>  mac80211_hwsim: ieee80211_register_hw failed (-2)
>  PM: Removing info for No Bus:hwsim0
>  initcall init_mac80211_hwsim+0x0/0x31c returned -2 after 58 msecs
>  initcall init_mac80211_hwsim+0x0/0x31c returned with error code -2
>  calling  dmfe_init_module+0x0/0xea
>  dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
>  initcall dmfe_init_module+0x0/0xea returned 0 after 5 msecs
> 
> So at least as far as the init_mac80211_hwsim() deinit crash goes:
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Yes, I'm chasing a distinct bug. The header for mine is

Jul 21 12:19:37 larrylap kernel: kernel BUG at net/core/dev.c:1328!
Jul 21 12:19:37 larrylap kernel: invalid opcode: 0000 [1] SMP
Jul 21 12:19:37 larrylap kernel: CPU 0
Jul 21 12:19:37 larrylap kernel: Modules linked in: af_packet rfkill_input nfs 
lockd nfs_acl sunrpc cpufreq_conservative cpu
freq_userspace cpufreq_powersave powernow_k8 fuse loop dm_mod arc4 ecb 
crypto_blkcipher b43 firmware_class rfkill mac80211 c
fg80211 snd_hda_intel snd_pcm snd_timer led_class snd k8temp input_polldev 
sr_mod soundcore button battery hwmon cdrom force
deth ac serio_raw ssb snd_page_alloc sg ehci_hcd sd_mod ohci_hcd usbcore edd fan 
thermal processor ext3 mbcache jbd pata_amd
  ahci libata scsi_mod dock
Jul 21 12:19:37 larrylap kernel: Pid: 2057, comm: b43 Not tainted 
2.6.26-Linus-git-05253-g14b395e #1
Jul 21 12:19:37 larrylap kernel: RIP: 0010:[<ffffffff8039ec4d>] 
[<ffffffff8039ec4d>] __netif_schedule+0x12/0x75
Jul 21 12:19:37 larrylap kernel: RSP: 0000:ffff8800b9ae1de0  EFLAGS: 00010246

With an invalid opcode, mine is likely due to stack corruption.

Larry
