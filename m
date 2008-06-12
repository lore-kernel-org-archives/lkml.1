Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYFLQzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYFLQzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbYFLQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:55:41 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:16223 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYFLQzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:55:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ENNKgAfRMEjj8m3Rkcdx3cQxJPT7BXFGI0cgNZXzWtRANO75Cm6cZyFgxhKkKdD11I
         i2ombBR4ET2npzJEs8IHxlrNGNCJ9e6uAkB8XQ9pdIml3+5chWC5kbZCJyc1pUEt0W9r
         3pKIQyayaccGVgJbYLY2FsRFo7hdg1/BxXVvE=
Message-ID: <19f34abd0806120955r4734bca8h44774bacc65aca37@mail.gmail.com>
Date: Thu, 12 Jun 2008 18:55:40 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h8wxarauf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <19f34abd0806120603q2ddc6654r9562dfea556c2791@mail.gmail.com>
	 <s5hlk1are3o.wl%tiwai@suse.de>
	 <19f34abd0806120648j4f15b762r8e72c348c14b946f@mail.gmail.com>
	 <s5hhcbyrcak.wl%tiwai@suse.de>
	 <19f34abd0806120655u75df09bfuaf33f1d54128b0b7@mail.gmail.com>
	 <s5hej72rbsh.wl%tiwai@suse.de>
	 <19f34abd0806120718g21ddfa3bjbf6f194aa1d3d37d@mail.gmail.com>
	 <s5h8wxarauf.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 4:23 PM, Takashi Iwai <tiwai@suse.de> wrote:
> Hmm, then it's all what I can guess right now.
> There might be some vendor-specific settings I don't know of.
>
> To be sure, try the following git tree (master branch), pull on
> 2.6.26:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
>
> This contains the patches for the next kernel, and some of them are
> related with Realtek codecs.

Thanks, I've now tried it, but still it doesn't work.

At least the right model is detected, because this is my laptop:

hda_codec.c:2352: hda_codec: model 'acer' is selected for config
1025:11e (Acer Aspire 5720z)

I also applied this patch for some extra debug output (and teach me a
bit about how registers change in response to alsamixer changes):

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index d2e1093..588b69c 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -129,6 +129,7 @@ unsigned int snd_hda_codec_read(struct hda_codec *codec, hda
_nid_t nid,
                res = (unsigned int)-1;
        mutex_unlock(&codec->bus->cmd_mutex);
        snd_hda_power_down(codec);
+       snd_printdd("read verb %08x parm %08x = %d\n", verb, parm, res);
        return res;
 }

@@ -153,6 +154,7 @@ int snd_hda_codec_write(struct hda_codec *codec, hda_nid_t n
id, int direct,
        err = codec->bus->ops.command(codec, nid, direct, verb, parm);
        mutex_unlock(&codec->bus->cmd_mutex);
        snd_hda_power_down(codec);
+       snd_printdd("write verb %08x parm %08x = %d\n", verb, parm, err);
        return err;
 }

..and in the log, I have this when modifying the "Capture" control:

hda_codec.c:157: write verb 00000300 parm 0000a01a = 0
hda_codec.c:157: write verb 00000300 parm 0000901a = 0

Now I consulted the HDA specification, and I find this surprising:

Verb 3h (set Amplifier Gain/Mute) has the following payload bits:

15 Set Output Amp
14 Set Input Amp

...but the payloads that I logged (a01a and 901a) would correspond to
bit 15 being set, which is the Output Amp!

Does that seem immediately obvious to you?

I will dig some more. Thanks for the help so far.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
