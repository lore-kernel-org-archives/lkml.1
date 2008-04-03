Return-Path: <linux-kernel-owner+w=401wt.eu-S1758782AbYDCOSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782AbYDCOSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbYDCOSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:18:30 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:57556 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062AbYDCOSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AT/1a0W6IfZjNECrF1pDOFOBdPUsBr20IB/UnoCYV9ZpmJ4fHx9k1Bh7kS6HoEG9zFkvngUXzvKifII8tUBIIiYg6J+64VHM8n4hzjYx9I4fiiHsKwXJLosGdNtv6URj+/GJk4jsibrsVVf6Asm1u/Hphn1D1Io+RQCczjECCPU=
Message-ID: <a44ae5cd0804030718u2a285402p31bd7b9fca239077@mail.gmail.com>
Date: Thu, 3 Apr 2008 10:18:28 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: 2.6.25-rc8-mm1 -- BUG: bad unlock balance detected!
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Jaroslav Kysela" <perex@perex.cz>,
       tiwai@suse.de
In-Reply-To: <20080403095819.GC7134@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0804020519o26603c1etfd166855e550f5b4@mail.gmail.com>
	 <20080403095819.GC7134@slug>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Frederik!  This patch seems to have done the trick.

         Miles

On Thu, Apr 3, 2008 at 5:58 AM, Frederik Deweerdt <deweerdt@free.fr> wrote:
> [Trimmed CC a bit, add Takashi Iwai]
>  Hi,
>
>
> On Wed, Apr 02, 2008 at 08:19:29AM -0400, Miles Lane wrote:
>  > [   48.765906] [ BUG: bad unlock balance detected! ]
>  > [   48.765912] -------------------------------------
>  > [   48.765918] pulseaudio/4277 is trying to release lock
>  > (&codec->spdif_mutex) at:
>  > [   48.765930] [<c03031b7>] mutex_unlock+0x8/0xa
>  > [   48.765945] but there are no more locks to release!
>  > [   48.765950]
>  > [   48.765952] other info that might help us debug this:
>  > [   48.765959] 2 locks held by pulseaudio/4277:
>  > [   48.765965]  #0:  (&pcm->open_mutex){--..}, at: [<f89f134b>]
>  > snd_pcm_open+0xc1/0x1ba [snd_pcm]
>  > [   48.766003]  #1:  (&chip->open_mutex){--..}, at: [<f8b4f13d>]
>  > azx_pcm_open+0x36/0x184 [snd_hda_intel]
>  > [   48.766057]
>  > [   48.766059] stack backtrace:
>  > [   48.766066] Pid: 4277, comm: pulseaudio Not tainted 2.6.25-rc8-mm1 #12
>  > [   48.766086]  [<c013afc6>] print_unlock_inbalance_bug+0xce/0xd8
>  > [   48.766107]  [<c0109e1c>] ? save_stack_trace+0x1d/0x3b
>  > [   48.766130]  [<c012f54e>] ? __kernel_text_address+0x1b/0x27
>  > [   48.766146]  [<c0104533>] ? dump_trace+0xcd/0xd9
>  > [   48.766160]  [<c0109d9e>] ? save_stack_address+0x0/0x2c
>  > [   48.766176]  [<c013b80a>] ? find_usage_backwards+0xa4/0xc3
>  > [   48.766193]  [<c013cfb5>] lock_release_non_nested+0x84/0x120
>  > [   48.766209]  [<c03031b7>] ? mutex_unlock+0x8/0xa
>  > [   48.766222]  [<c013d1bb>] lock_release+0x16a/0x199
>  > [   48.766238]  [<c0303137>] __mutex_unlock_slowpath+0xa9/0x121
>  > [   48.766252]  [<c03031b7>] mutex_unlock+0x8/0xa
>  > [   48.766263]  [<f8b4ffd8>] snd_hda_multi_out_analog_open+0xd3/0xef
>  > [snd_hda_intel]
>  The following patch should fix it. The buggy code comes from
>  git-alsa-tiwai.patch .
>
>  Regards,
>  Frederik
>
>
>  diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
>  index 689d177..a6be6e3 100644
>  --- a/sound/pci/hda/hda_codec.c
>  +++ b/sound/pci/hda/hda_codec.c
>  @@ -2665,8 +2665,8 @@ int snd_hda_multi_out_analog_open(struct hda_codec *codec,
>                         if (mout->spdif_maxbps < hinfo->maxbps)
>                                 hinfo->maxbps = mout->spdif_maxbps;
>                 }
>  +               mutex_unlock(&codec->spdif_mutex);
>         }
>  -       mutex_unlock(&codec->spdif_mutex);
>         return snd_pcm_hw_constraint_step(substream->runtime, 0,
>                                           SNDRV_PCM_HW_PARAM_CHANNELS, 2);
>   }
>
