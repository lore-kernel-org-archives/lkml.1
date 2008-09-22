Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYIVNLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYIVNLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYIVNLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:11:40 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:19679 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYIVNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:11:39 -0400
X-BigFish: VPS-32(zz1432R98dR936eQ62a3L1805M19c2kzz10d3izz5a6ciz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K7LLYZ-02-Y9M-01
Date: Mon, 22 Sep 2008 15:10:56 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andrea Righi <righi.andrea@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       oprofile-list@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] oprofile: BUG scheduling while atomic
Message-ID: <20080922131055.GK23557@erda.amd.com>
References: <48D51E93.90804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48D51E93.90804@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Sep 2008 13:10:59.0559 (UTC) FILETIME=[A8087F70:01C91CB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.09.08 18:02:27, Andrea Righi wrote:
> nmi_shutdown() calls unregister_die_notifier() from an atomic context
> after setting preempt_disable() via get_cpu_var():
> 
> [ 1049.404154] BUG: scheduling while atomic: oprofiled/7796/0x00000002
> [ 1049.404171] INFO: lockdep is turned off.
> [ 1049.404176] Modules linked in: oprofile af_packet rfcomm l2cap kvm_intel kvm i915 drm acpi_cpufreq cpufreq_userspace cpufreq_conservative cpufreq_ondemand cpufreq_powersave freq_table container sbs sbshc dm_mod arc4 ecb cryptomgr aead snd_hda_intel crypto_blkcipher snd_pcm_oss crypto_algapi snd_pcm iwlagn iwlcore snd_timer iTCO_wdt led_class btusb iTCO_vendor_support snd psmouse bluetooth mac80211 soundcore cfg80211 snd_page_alloc intel_agp video output button battery ac dcdbas evdev ext3 jbd mbcache sg sd_mod piix ata_piix libata scsi_mod dock tg3 libphy ehci_hcd uhci_hcd usbcore thermal processor fan fuse
> [ 1049.404362] Pid: 7796, comm: oprofiled Not tainted 2.6.27-rc5-mm1 #30
> [ 1049.404368] Call Trace:
> [ 1049.404384]  [<ffffffff804769fd>] thread_return+0x4a0/0x7d3
> [ 1049.404396]  [<ffffffff8026ad92>] generic_exec_single+0x52/0xe0
> [ 1049.404405]  [<ffffffff8026ae1a>] generic_exec_single+0xda/0xe0
> [ 1049.404414]  [<ffffffff8026aee3>] smp_call_function_single+0x73/0x150
> [ 1049.404423]  [<ffffffff804770c5>] schedule_timeout+0x95/0xd0
> [ 1049.404430]  [<ffffffff80476083>] wait_for_common+0x43/0x180
> [ 1049.404438]  [<ffffffff80476154>] wait_for_common+0x114/0x180
> [ 1049.404448]  [<ffffffff80236980>] default_wake_function+0x0/0x10
> [ 1049.404457]  [<ffffffff8024f810>] synchronize_rcu+0x30/0x40
> [ 1049.404463]  [<ffffffff8024f890>] wakeme_after_rcu+0x0/0x10
> [ 1049.404472]  [<ffffffff80479ca0>] _spin_unlock_irqrestore+0x40/0x80
> [ 1049.404482]  [<ffffffff80256def>] atomic_notifier_chain_unregister+0x3f/0x60
> [ 1049.404501]  [<ffffffffa03d8801>] nmi_shutdown+0x51/0x90 [oprofile]
> [ 1049.404517]  [<ffffffffa03d6134>] oprofile_shutdown+0x34/0x70 [oprofile]
> [ 1049.404532]  [<ffffffffa03d721e>] event_buffer_release+0xe/0x40 [oprofile]
> [ 1049.404543]  [<ffffffff802bdcdd>] __fput+0xcd/0x240
> [ 1049.404551]  [<ffffffff802baa74>] filp_close+0x54/0x90
> [ 1049.404560]  [<ffffffff8023e1d1>] put_files_struct+0xb1/0xd0
> [ 1049.404568]  [<ffffffff8023f82f>] do_exit+0x18f/0x930
> [ 1049.404576]  [<ffffffff8020be03>] restore_args+0x0/0x30
> [ 1049.404584]  [<ffffffff80240006>] do_group_exit+0x36/0xa0
> [ 1049.404592]  [<ffffffff8020b7cb>] system_call_fastpath+0x16/0x1b
> 
> This can be easily triggered with 'opcontrol --shutdown'.
> 
> Simply move get_cpu_var() above unregister_die_notifier().
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>

Acked-by: Robert Richter <robert@richter@amd.com>

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

