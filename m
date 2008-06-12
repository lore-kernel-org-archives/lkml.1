Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYFLRaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYFLRaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYFLR37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:29:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:12163 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYFLR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PCUryMpHy5YStt0BgMtPtUvUfwwa/15wUaZUUwmuHLgSJVHfDS//SMXv0RKv8Ue4UN
         LD0JynXHyjic8vhSLuMyP3/OXPdylhlmpPZrtekCIh6AdeSockh10O9ZPIAezqglvemE
         4NNcDSbHgJM3dHgLUgmhQcppR11jTAf2bJCHs=
Message-ID: <19f34abd0806121029j1f9cabf0nc852c6e1a0a98d4f@mail.gmail.com>
Date: Thu, 12 Jun 2008 19:29:57 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0806120955r4734bca8h44774bacc65aca37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <19f34abd0806120603q2ddc6654r9562dfea556c2791@mail.gmail.com>
	 <s5hlk1are3o.wl%tiwai@suse.de>
	 <19f34abd0806120648j4f15b762r8e72c348c14b946f@mail.gmail.com>
	 <s5hhcbyrcak.wl%tiwai@suse.de>
	 <19f34abd0806120655u75df09bfuaf33f1d54128b0b7@mail.gmail.com>
	 <s5hej72rbsh.wl%tiwai@suse.de>
	 <19f34abd0806120718g21ddfa3bjbf6f194aa1d3d37d@mail.gmail.com>
	 <s5h8wxarauf.wl%tiwai@suse.de>
	 <19f34abd0806120955r4734bca8h44774bacc65aca37@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 6:55 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> Now I consulted the HDA specification, and I find this surprising:
>
> Verb 3h (set Amplifier Gain/Mute) has the following payload bits:
>
> 15 Set Output Amp
> 14 Set Input Amp
>
> ...but the payloads that I logged (a01a and 901a) would correspond to
> bit 15 being set, which is the Output Amp!

I applied this as well, just to make sure, and I tested again:

@@ -906,6 +908,9 @@ int snd_hda_codec_amp_update(struct hda_codec
*codec, hda_nid_t nid, int ch,
 {
        struct hda_amp_info *info;

+       printk(KERN_ERR "snd_hda_codec_amp_update(): direction = %s\n",
+               direction == HDA_OUTPUT ? "output" : "input");
+
        info = get_alloc_amp_hash(codec, HDA_HASH_KEY(nid, direction, idx));
        if (!info)
                return 0;

..and yes, changing the "Capture" level does indeed set the Output bit
when modifying this control. Maybe there's something wrong with the
set-up of mixer or pin controls that makes ALSA think this is an
output stream?

Is there something strange here:

Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Pin Default 0x02a19840: [Jack] Mic at Ext Front

Node 0x19 [Pin Complex] wcaps 0x40008b: Stereo Amp-In
  Pin Default 0x99a30941: [Fixed] Mic at Int ATAPI

Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Pin Default 0x0281304e: [Jack] Line In at Ext Front

..or it certainly seems that all the inputs claim to have output
capability too. Maybe this is what is confusing ALSA?

I will try to change the Gain/Mute levels manually using hda-verb
using the Input bit instead of Output and see how it goes.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
