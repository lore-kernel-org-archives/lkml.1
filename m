Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZAIFGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZAIFGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbZAIFG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:06:26 -0500
Received: from mga07.intel.com ([143.182.124.22]:26357 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753387AbZAIFGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:06:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,237,1231142400"; 
   d="scan'208";a="98082020"
Date: Fri, 9 Jan 2009 13:06:21 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] sound: INFO: possible recursive locking detected
Message-ID: <20090109050621.GA16446@localhost>
References: <20090108152037.GA25652@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108152037.GA25652@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 04:20:37PM +0100, Ingo Molnar wrote:
> 
> FYI, -tip testing found this new lockdep workqueue locking assert 
> triggered by the Intel HDA sound driver:
> 
> [   30.637612]   alloc kstat_irqs on cpu 0 node 0
> [   30.647029] IOAPIC[0]: Set routing entry (2-22 -> 0x71 -> IRQ 22 Mode:1 Active:1)
> [   30.654533] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> [   30.661782] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   30.667801] chipset global capabilities = 0x4401
> [   30.701090] codec_mask = 0x4
> [   30.701090] hda_intel: codec #2 probed OK
> [   30.709090] hda-codec: No codec parser is available
> [   30.714396] hda-intel: no codecs initialized
> [   30.718689] 
> [   30.718689] =============================================
> [   30.718689] [ INFO: possible recursive locking detected ]
> [   30.718689] 2.6.28-tip #2
> [   30.718689] ---------------------------------------------
> [   30.718689] events/0/7 is trying to acquire lock:
> [   30.718689]  (events){--..}, at: [<ffffffff80281050>] flush_workqueue+0x0/0x90
> [   30.718689] 
> [   30.718689] but task is already holding lock:
> [   30.718689]  (events){--..}, at: [<ffffffff8028076a>] run_workqueue+0x14a/0x240
> [   30.718689] 
> [   30.718689] other info that might help us debug this:
> [   30.718689] 2 locks held by events/0/7:
> [   30.718689]  #0:  (events){--..}, at: [<ffffffff8028076a>] run_workqueue+0x14a/0x240
> [   30.718689]  #1:  (&wfc.work){--..}, at: [<ffffffff8028076a>] run_workqueue+0x14a/0x240

I didn't see this bug, but ran into another one with linux-next 20090102:

[  844.111765] ALSA sound/pci/hda/hda_codec.c:882: hda_codec_cleanup_stream: NID=0x2
[  844.111915]
[  844.111916] =======================================================
[  844.112018] [ INFO: possible circular locking dependency detected ]
[  844.112076] 2.6.28-next-20090102 #33
[  844.112124] -------------------------------------------------------
[  844.112181] mplayer/3151 is trying to acquire lock:
[  844.112235]  (&pcm->open_mutex){--..}, at: [<ffffffffa004ced3>] snd_pcm_release+0x43/0xd0 [snd_pcm]
[  844.112361]
[  844.112362] but task is already holding lock:
[  844.112458]  (&mm->mmap_sem){----}, at: [<ffffffff810c0252>] sys_munmap+0x42/0x80
[  844.112576]
[  844.112577] which lock already depends on the new lock.
[  844.112578]
[  844.112712]
[  844.112713] the existing dependency chain (in reverse order) is:
[  844.112781]
[  844.112781] -> #3 (&mm->mmap_sem){----}:
[  844.112781]        [<ffffffff8107097b>] __lock_acquire+0x122b/0x1ae0
[  844.112781]        [<ffffffff810712c9>] lock_acquire+0x99/0xd0
[  844.112781]        [<ffffffff810b7a43>] might_fault+0x73/0xa0
[  844.112781]        [<ffffffffa006f44d>] snd_hda_mixer_amp_tlv+0x6d/0xf0 [snd_hda_codec]
[  844.112781]        [<ffffffffa0093f80>] alc_cap_vol_tlv+0x70/0xa0 [snd_hda_codec_realtek]
[  844.112781]        [<ffffffffa0012300>] snd_ctl_tlv_ioctl+0x180/0x1b0 [snd]
[  844.112781]        [<ffffffffa0013a27>] snd_ctl_ioctl+0x927/0xf80 [snd]
[  844.112781]        [<ffffffff810ea801>] vfs_ioctl+0x31/0xa0
[  844.112781]        [<ffffffff810ea8e6>] do_vfs_ioctl+0x76/0x4a0
[  844.112781]        [<ffffffff810ead5a>] sys_ioctl+0x4a/0x80
[  844.112781]        [<ffffffff8100c67a>] system_call_fastpath+0x16/0x1b
[  844.112781]        [<ffffffffffffffff>] 0xffffffffffffffff
[  844.112781]
[  844.112781] -> #2 (&codec->spdif_mutex){--..}:
[  844.112781]        [<ffffffff8107097b>] __lock_acquire+0x122b/0x1ae0
[  844.112781]        [<ffffffff810712c9>] lock_acquire+0x99/0xd0
[  844.112781]        [<ffffffff814344e8>] mutex_lock_nested+0xe8/0x370
[  844.112781]        [<ffffffffa006e54b>] snd_hda_multi_out_dig_open+0x2b/0x60 [snd_hda_codec]
[  844.112781]        [<ffffffffa00d2649>] intel_hdmi_playback_pcm_open+0x49/0x60 [snd_hda_codec_intelhdmi]
[  844.112781]        [<ffffffffa007fff9>] azx_pcm_open+0x209/0x280 [snd_hda_intel]
[  844.112781]        [<ffffffffa004d838>] snd_pcm_open_substream+0x58/0xd0 [snd_pcm]
[  844.112781]        [<ffffffffa004d9e7>] snd_pcm_open+0x137/0x260 [snd_pcm]
[  844.112781]        [<ffffffffa004db7c>] snd_pcm_playback_open+0x2c/0x40 [snd_pcm]
[  844.112781]        [<ffffffffa000e86e>] snd_open+0x9e/0x180 [snd]
[  844.112781]        [<ffffffff810df407>] chrdev_open+0xe7/0x1d0
[  844.112781]        [<ffffffff810da06e>] __dentry_open+0xce/0x360
[  844.112781]        [<ffffffff810da407>] nameidata_to_filp+0x57/0x70
[  844.112781]        [<ffffffff810e909e>] do_filp_open+0x20e/0x970
[  844.112781]        [<ffffffff810d9ec8>] do_sys_open+0x78/0x100
[  844.112781]        [<ffffffff810d9f7b>] sys_open+0x1b/0x20
[  844.112781]        [<ffffffff8100c67a>] system_call_fastpath+0x16/0x1b
[  844.112781]        [<ffffffffffffffff>] 0xffffffffffffffff
[  844.112781]
[  844.112781] -> #1 (&chip->open_mutex){--..}:
[  844.112781]        [<ffffffff8107097b>] __lock_acquire+0x122b/0x1ae0
[  844.112781]        [<ffffffff810712c9>] lock_acquire+0x99/0xd0
[  844.112781]        [<ffffffff814344e8>] mutex_lock_nested+0xe8/0x370
[  844.112781]        [<ffffffffa007fe38>] azx_pcm_open+0x48/0x280 [snd_hda_intel]
[  844.112781]        [<ffffffffa004d838>] snd_pcm_open_substream+0x58/0xd0 [snd_pcm]
[  844.112781]        [<ffffffffa004d9e7>] snd_pcm_open+0x137/0x260 [snd_pcm]
[  844.112781]        [<ffffffffa004db7c>] snd_pcm_playback_open+0x2c/0x40 [snd_pcm]
[  844.112781]        [<ffffffffa000e86e>] snd_open+0x9e/0x180 [snd]
[  844.112781]        [<ffffffff810df407>] chrdev_open+0xe7/0x1d0
[  844.112781]        [<ffffffff810da06e>] __dentry_open+0xce/0x360
[  844.112781]        [<ffffffff810da407>] nameidata_to_filp+0x57/0x70
[  844.112781]        [<ffffffff810e909e>] do_filp_open+0x20e/0x970
[  844.112781]        [<ffffffff810d9ec8>] do_sys_open+0x78/0x100
[  844.112781]        [<ffffffff810d9f7b>] sys_open+0x1b/0x20
[  844.112781]        [<ffffffff8100c67a>] system_call_fastpath+0x16/0x1b
[  844.112781]        [<ffffffffffffffff>] 0xffffffffffffffff
[  844.112781]
[  844.112781] -> #0 (&pcm->open_mutex){--..}:
[  844.112781]        [<ffffffff81070b1e>] __lock_acquire+0x13ce/0x1ae0
[  844.112781]        [<ffffffff810712c9>] lock_acquire+0x99/0xd0
[  844.112781]        [<ffffffff814344e8>] mutex_lock_nested+0xe8/0x370
[  844.112781]        [<ffffffffa004ced3>] snd_pcm_release+0x43/0xd0 [snd_pcm]
[  844.112781]        [<ffffffff810dd505>] __fput+0xd5/0x230
[  844.112781]        [<ffffffff810dd67d>] fput+0x1d/0x30
[  844.112781]        [<ffffffff810bed4f>] remove_vma+0x4f/0x90
[  844.112781]        [<ffffffff810c01c2>] do_munmap+0x342/0x390
[  844.112781]        [<ffffffff810c0260>] sys_munmap+0x50/0x80
[  844.112781]        [<ffffffff8100c67a>] system_call_fastpath+0x16/0x1b
[  844.112781]        [<ffffffffffffffff>] 0xffffffffffffffff
[  844.112781]
[  844.112781] other info that might help us debug this:
[  844.112781]
[  844.112781] 1 lock held by mplayer/3151:
[  844.112781]  #0:  (&mm->mmap_sem){----}, at: [<ffffffff810c0252>] sys_munmap+0x42/0x80
[  844.112781]
[  844.112781] stack backtrace:
[  844.112781] Pid: 3151, comm: mplayer Not tainted 2.6.28-next-20090102 #33
[  844.112781] Call Trace:
[  844.112781]  [<ffffffff8106f2a0>] print_circular_bug_tail+0xe0/0xf0
[  844.112781]  [<ffffffff81070b1e>] __lock_acquire+0x13ce/0x1ae0
[  844.112781]  [<ffffffff8106e916>] ? mark_held_locks+0x56/0xa0
[  844.112781]  [<ffffffff810abcf9>] ? free_hot_cold_page+0x1b9/0x2e0
[  844.112781]  [<ffffffff8106ec1d>] ? trace_hardirqs_on+0xd/0x10
[  844.112781]  [<ffffffff810712c9>] lock_acquire+0x99/0xd0
[  844.112781]  [<ffffffffa004ced3>] ? snd_pcm_release+0x43/0xd0 [snd_pcm]
[  844.112781]  [<ffffffff814344e8>] mutex_lock_nested+0xe8/0x370
[  844.112781]  [<ffffffffa004ced3>] ? snd_pcm_release+0x43/0xd0 [snd_pcm]
[  844.112781]  [<ffffffffa004ced3>] ? snd_pcm_release+0x43/0xd0 [snd_pcm]
[  844.112781]  [<ffffffffa004ced3>] snd_pcm_release+0x43/0xd0 [snd_pcm]
[  844.112781]  [<ffffffff810dd505>] __fput+0xd5/0x230
[  844.112781]  [<ffffffff810dd67d>] fput+0x1d/0x30
[  844.112781]  [<ffffffff810bed4f>] remove_vma+0x4f/0x90
[  844.112781]  [<ffffffff810c01c2>] do_munmap+0x342/0x390
[  844.112781]  [<ffffffff810c0260>] sys_munmap+0x50/0x80
[  844.112781]  [<ffffffff8100c67a>] system_call_fastpath+0x16/0x1b
[  844.119376] ALSA sound/pci/hda/hda_codec.c:882: hda_codec_cleanup_stream: NID=0x2

Which can be fixed by the following patch.

Thanks,
Fengguang
---
hda - fix lockdep warning

  ALSA sound/pci/hda/hda_codec.c:882: hda_codec_cleanup_stream: NID=0x2
 
  =======================================================
  [ INFO: possible circular locking dependency detected ]
  2.6.28-next-20090102 #33
  -------------------------------------------------------
  mplayer/3151 is trying to acquire lock:
   (&pcm->open_mutex){--..}, at: [<ffffffffa004ced3>] snd_pcm_release+0x43/0xd0 [snd_pcm]
 
  but task is already holding lock:
   (&mm->mmap_sem){----}, at: [<ffffffff810c0252>] sys_munmap+0x42/0x80
 
  which lock already depends on the new lock.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 sound/pci/hda/hda_codec.c     |    1 +
 sound/pci/hda/hda_codec.h     |    1 +
 sound/pci/hda/patch_realtek.c |   12 ++++++------
 3 files changed, 8 insertions(+), 6 deletions(-)

--- mm.orig/sound/pci/hda/hda_codec.c
+++ mm/sound/pci/hda/hda_codec.c
@@ -735,6 +735,7 @@ int /*__devinit*/ snd_hda_codec_new(stru
 	codec->bus = bus;
 	codec->addr = codec_addr;
 	mutex_init(&codec->spdif_mutex);
+	mutex_init(&codec->control_mutex);
 	init_hda_cache(&codec->amp_cache, sizeof(struct hda_amp_info));
 	init_hda_cache(&codec->cmd_cache, sizeof(struct hda_cache_head));
 	snd_array_init(&codec->mixers, sizeof(struct snd_kcontrol *), 32);
--- mm.orig/sound/pci/hda/hda_codec.h
+++ mm/sound/pci/hda/hda_codec.h
@@ -771,6 +771,7 @@ struct hda_codec {
 	struct hda_cache_rec cmd_cache;	/* cache for other commands */
 
 	struct mutex spdif_mutex;
+	struct mutex control_mutex;
 	unsigned int spdif_status;	/* IEC958 status bits */
 	unsigned short spdif_ctls;	/* SPDIF control bits */
 	unsigned int spdif_in_enable;	/* SPDIF input enable? */
--- mm.orig/sound/pci/hda/patch_realtek.c
+++ mm/sound/pci/hda/patch_realtek.c
@@ -1502,11 +1502,11 @@ static int alc_cap_vol_info(struct snd_k
 	struct alc_spec *spec = codec->spec;
 	int err;
 
-	mutex_lock(&codec->spdif_mutex); /* reuse spdif_mutex */
+	mutex_lock(&codec->control_mutex);
 	kcontrol->private_value = HDA_COMPOSE_AMP_VAL(spec->adc_nids[0], 3, 0,
 						      HDA_INPUT);
 	err = snd_hda_mixer_amp_volume_info(kcontrol, uinfo);
-	mutex_unlock(&codec->spdif_mutex); /* reuse spdif_mutex */
+	mutex_unlock(&codec->control_mutex);
 	return err;
 }
 
@@ -1517,11 +1517,11 @@ static int alc_cap_vol_tlv(struct snd_kc
 	struct alc_spec *spec = codec->spec;
 	int err;
 
-	mutex_lock(&codec->spdif_mutex); /* reuse spdif_mutex */
+	mutex_lock(&codec->control_mutex);
 	kcontrol->private_value = HDA_COMPOSE_AMP_VAL(spec->adc_nids[0], 3, 0,
 						      HDA_INPUT);
 	err = snd_hda_mixer_amp_tlv(kcontrol, op_flag, size, tlv);
-	mutex_unlock(&codec->spdif_mutex); /* reuse spdif_mutex */
+	mutex_unlock(&codec->control_mutex);
 	return err;
 }
 
@@ -1537,11 +1537,11 @@ static int alc_cap_getput_caller(struct 
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
 	int err;
 
-	mutex_lock(&codec->spdif_mutex); /* reuse spdif_mutex */
+	mutex_lock(&codec->control_mutex);
 	kcontrol->private_value = HDA_COMPOSE_AMP_VAL(spec->adc_nids[adc_idx],
 						      3, 0, HDA_INPUT);
 	err = func(kcontrol, ucontrol);
-	mutex_unlock(&codec->spdif_mutex); /* reuse spdif_mutex */
+	mutex_unlock(&codec->control_mutex);
 	return err;
 }
 
