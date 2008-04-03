Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbYDCJ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbYDCJ7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 05:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYDCJ71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 05:59:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:12093 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYDCJ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 05:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=OaB8NJ+Po5zivwFCXwLQYsKW2BleIPWEMefapy19QNJjEfTOQRJxorxsDP8fJSr1SUxpKA/xkeYmX2LTfalrl4rIUjXgnW0GJh4ZVaAP1a/8FzRGIrEBWjyu6OCsPwSBn1zCVnnyhrcgT0vyZWDnMkiv7co4MS+a+5SQWK6SbdA=
Date: Thu, 3 Apr 2008 11:58:19 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jaroslav Kysela <perex@perex.cz>,
       tiwai@suse.de
Subject: Re: 2.6.25-rc8-mm1 -- BUG: bad unlock balance detected!
Message-ID: <20080403095819.GC7134@slug>
References: <a44ae5cd0804020519o26603c1etfd166855e550f5b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0804020519o26603c1etfd166855e550f5b4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trimmed CC a bit, add Takashi Iwai]
Hi,
On Wed, Apr 02, 2008 at 08:19:29AM -0400, Miles Lane wrote:
> [   48.765906] [ BUG: bad unlock balance detected! ]
> [   48.765912] -------------------------------------
> [   48.765918] pulseaudio/4277 is trying to release lock
> (&codec->spdif_mutex) at:
> [   48.765930] [<c03031b7>] mutex_unlock+0x8/0xa
> [   48.765945] but there are no more locks to release!
> [   48.765950]
> [   48.765952] other info that might help us debug this:
> [   48.765959] 2 locks held by pulseaudio/4277:
> [   48.765965]  #0:  (&pcm->open_mutex){--..}, at: [<f89f134b>]
> snd_pcm_open+0xc1/0x1ba [snd_pcm]
> [   48.766003]  #1:  (&chip->open_mutex){--..}, at: [<f8b4f13d>]
> azx_pcm_open+0x36/0x184 [snd_hda_intel]
> [   48.766057]
> [   48.766059] stack backtrace:
> [   48.766066] Pid: 4277, comm: pulseaudio Not tainted 2.6.25-rc8-mm1 #12
> [   48.766086]  [<c013afc6>] print_unlock_inbalance_bug+0xce/0xd8
> [   48.766107]  [<c0109e1c>] ? save_stack_trace+0x1d/0x3b
> [   48.766130]  [<c012f54e>] ? __kernel_text_address+0x1b/0x27
> [   48.766146]  [<c0104533>] ? dump_trace+0xcd/0xd9
> [   48.766160]  [<c0109d9e>] ? save_stack_address+0x0/0x2c
> [   48.766176]  [<c013b80a>] ? find_usage_backwards+0xa4/0xc3
> [   48.766193]  [<c013cfb5>] lock_release_non_nested+0x84/0x120
> [   48.766209]  [<c03031b7>] ? mutex_unlock+0x8/0xa
> [   48.766222]  [<c013d1bb>] lock_release+0x16a/0x199
> [   48.766238]  [<c0303137>] __mutex_unlock_slowpath+0xa9/0x121
> [   48.766252]  [<c03031b7>] mutex_unlock+0x8/0xa
> [   48.766263]  [<f8b4ffd8>] snd_hda_multi_out_analog_open+0xd3/0xef
> [snd_hda_intel]
The following patch should fix it. The buggy code comes from
git-alsa-tiwai.patch .

Regards,
Frederik


diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 689d177..a6be6e3 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2665,8 +2665,8 @@ int snd_hda_multi_out_analog_open(struct hda_codec *codec,
 			if (mout->spdif_maxbps < hinfo->maxbps)
 				hinfo->maxbps = mout->spdif_maxbps;
 		}
+		mutex_unlock(&codec->spdif_mutex);
 	}
-	mutex_unlock(&codec->spdif_mutex);
 	return snd_pcm_hw_constraint_step(substream->runtime, 0,
 					  SNDRV_PCM_HW_PARAM_CHANNELS, 2);
 }
