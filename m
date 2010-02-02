Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab0BBPab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:30:31 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:60829 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab0BBPaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:30:30 -0500
Message-ID: <4B684513.8090201@ladisch.de>
Date: Tue, 02 Feb 2010 16:30:27 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Frederick V Heitkamp <heitkamp@ameritech.net>,
       Giuliano Pochini <pochini@shiny.it>, Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Crash 2.6.32.x, Echo 3G, Alsa, SCSI
References: <73211.74714.qm@web180714.mail.sp1.yahoo.com>
In-Reply-To: <73211.74714.qm@web180714.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederick V Heitkamp wrote:
> Repeatable Hard Crash.
> What else do I need to provide?
> 
> [ 5484.995249] WriteControlReg: not written, no change
> [ 5485.069621] divide error: 0000 [#1] pcm_hw_params ok
> [ 5485.070159] Prepare rate=44100 format=2 channels=2
> [ 5485.070161] set_audio_format[14] = 5
> [ 5485.070166] Prepare rate=44100 format=2 channels=2
> [ 5485.070167] set_audio_format[14] = 5
> [ 5485.070003] PREEMPT SMP 
> ...
> [ 5485.070003] EIP is at pcm_pointer+0x37/0x70 [snd_echo3g]
> ...
> [ 5485.965788]  [<c10041c0>] ? do_divide_error+0x0/0x90
> [ 5485.980619]  [<f87aa037>] ? pcm_pointer+0x37/0x70 [snd_echo3g]
> [ 5485.998047]  [<c104764e>] ? run_timer_softirq+0x17e/0x2e0
> [ 5486.014175]  [<f87ac9bf>] ? snd_echo_interrupt+0x11f/0x240 [snd_echo3g]
> [ 5486.033940]  [<c107a5d5>] ? handle_IRQ_event+0x45/0x190

bytes_to_frames() divides by runtime->frame_bits which is not set until
after the hw_params callback has succeeded, but the corresponding
chip->substream[] entry is set in that callback, by init_engine().  It
should probably have been set in the prepare callback.

Frederick, please try the patch below.

Takashi, is there any reason why the runtime-> fields are initialized
after the hw_params callback?  


Regards,
Clemens


--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -403,12 +403,6 @@
 	if (err < 0)
 		goto _error;
 
-	if (substream->ops->hw_params != NULL) {
-		err = substream->ops->hw_params(substream, params);
-		if (err < 0)
-			goto _error;
-	}
-
 	runtime->access = params_access(params);
 	runtime->format = params_format(params);
 	runtime->subformat = params_subformat(params);
@@ -446,6 +440,13 @@
 		runtime->boundary *= 2;
 
 	snd_pcm_timer_resolution_change(substream);
+
+	if (substream->ops->hw_params != NULL) {
+		err = substream->ops->hw_params(substream, params);
+		if (err < 0)
+			goto _error;
+	}
+
 	runtime->status->state = SNDRV_PCM_STATE_SETUP;
 
 	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY,
