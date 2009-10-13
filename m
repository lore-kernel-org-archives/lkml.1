Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZJMMzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZJMMzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZJMMzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:55:24 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:47846 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZJMMzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fAzd+3QtVXwNzBXRXUPd9JOs6Ht8XUo1OR1BnNMuRALkUovcg78dEiWIXUftaZFefN
         2VEG/o6Bni/AwZ6/BFZZq1WJmKn0NXDVroMGJpljkUKTMUdb5iv9SYRI+s9VX+jEBMhy
         QjzSnD8xdy10Ds9WqD3foozrbnsMRrlne9hnE=
MIME-Version: 1.0
In-Reply-To: <s5h63ajx1nh.wl%tiwai@suse.de>
References: <20091010130110.GA5445@nb-core2.darkstar.lan>
	 <s5hk4z1f90p.wl%tiwai@suse.de>
	 <68676e00910121239qd2d87cbnbdab32efe041a65d@mail.gmail.com>
	 <s5h63ajx1nh.wl%tiwai@suse.de>
Date: Tue, 13 Oct 2009 14:54:46 +0200
Message-ID: <68676e00910130554x418f8689x10bccec31df8d49c@mail.gmail.com>
Subject: Re: [BUG] GPF in snd_hda_intel
From: Luca Tettamanti <kronos.it@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 8:12 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 12 Oct 2009 21:39:21 +0200,
> Luca Tettamanti wrote:
>>
>> On Mon, Oct 12, 2009 at 7:58 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Sat, 10 Oct 2009 15:01:10 +0200,
>> > Luca Tettamanti wrote:
>> >>
>> >> Hello,
>> >> with current git kernel (bd381934) I see a GPF when the snd_hda_intel driver is
>> >> loaded; the regression is recent, 0eca52a works fine.
>> >> The machine is an ASUS laptop (F3Sa), this is the sound card:
>> >
>> > Could you load the snd-hda-intel module with probe_only=1 option,
>> > and give the output of "alsa-info.sh --no-upload" ?
>> >
>> > If 0eca52a worked, there are only a few changes regarding hda-intel.
>> >
>> > f8f25ba3563dab14b1c3ea4d829642b8a61ca5d7
>> >    ALSA: hda - Add a workaround for ASUS A7K
>>
>> This is probably related; I haven't actually tested yet, but I have
>> one more information: I had "model=lenovo" in modprobe configuration.
>
> Ah, this is it.  I can reproduce the problem with my emulator now.
> The patch below fixes the issue.

Yup, no more GPF.

> From 2d9c648295d7bc376305337d29f540a5e411f632 Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Tue, 13 Oct 2009 08:06:55 +0200
> Subject: [PATCH] ALSA: hda - Fix overflow of spec->init_verbs in patch_realtek.c
>
> ALC861-VD lenovo model causes overflow of spec->init_verbs entries due to
> the recent changes.  Simply increase the array size to avoid the overflow.
>
> Reported-by: Luca Tettamanti <kronos.it@gmail.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Tested-by: Luca Tettamanti <kronos.it@gmail.com>

> ---
>  sound/pci/hda/patch_realtek.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index 470fd74..c08ca66 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -275,7 +275,7 @@ struct alc_spec {
>        struct snd_kcontrol_new *cap_mixer;     /* capture mixer */
>        unsigned int beep_amp;  /* beep amp value, set via set_beep_amp() */
>
> -       const struct hda_verb *init_verbs[5];   /* initialization verbs
> +       const struct hda_verb *init_verbs[10];  /* initialization verbs
>                                                 * don't forget NULL
>                                                 * termination!
>                                                 */
> --
> 1.6.4.2
>
>
