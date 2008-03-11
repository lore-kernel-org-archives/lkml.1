Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYCKPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYCKPRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYCKPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:17:04 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56228 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYCKPRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:17:03 -0400
Message-ID: <47D6A28C.4060804@keyaccess.nl>
Date: Tue, 11 Mar 2008 16:17:32 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080311140718.8B3ABDBA2@gherkin.frus.com>
In-Reply-To: <20080311140718.8B3ABDBA2@gherkin.frus.com>
Content-Type: multipart/mixed;
 boundary="------------020605050705070702050506"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020605050705070702050506
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 11-03-08 15:07, Bob Tracy wrote:

> Both native ALSA and emulated OSS playback are broken based on last 
> night's testing.  Just to rule out sound hardware issues, this morning I
> built a 2.6.25-rc4 kernel with OSS (sb driver), and that seems to be 
> working fine.

Okay... From your testing report:

>> $ sox foo.wav -t alsa default
> 
> Playback results in infinite loop over the first quarter second or so
> of audio.  Using "aplay" results in same looping behavior over a longer
> segment of audio -- maybe a half second.

This is behaviour consistent with the IRQ being dead ...

>> > $ sox foo.wav -t ossdsp /dev/dsp
> 
> Identical results to using "play" (as expected): for the 50K ".wav"
> file, I hear the entire file approx. 1.8 times.

... and this isn't. Worse yet, we have a conflicting report from Michael 
where things are fine while using aplay and I'm seeing nothing particularly 
suspicious recently. I suppose it used to work and I suppose the behaviour 
you are describing above is 100% repeatable?

Given that you can use aplay -- probably no difference with "aplay -M" ?

To get to the bottom of this we might need to get a specific failed version 
(for readers, it's not been verified that this is a regression since 2.6.24) 
but we can try to get lucky first.

The most recent change to sound/isa/es18xx.c that's not utterly impossible 
to have made a difference is 1bc9eed379399484d3f5d5a0834674983969bc1, 
"es18xx: Enable wavetable input from ESS chips". I don't know if you're a 
GIT user. If you are, you can revert it simply with

$ git revert 1bc9eed3

If you're not a GIT user, applying the attached should work. Unlikely, but 
as said, we can try.

> I tried a few rmmod/insmod cycles with different values for dma2.
> Results as follows:
> 
> (a) dma2=1 (== dma1): no change
> (b) dma2 option omitted : no change
> (c) dma2=-1 : probe failed

Okay. A and B seem to at least confirm it's not the 16-bit DMA.

Rene.

--------------020605050705070702050506
Content-Type: text/plain;
 name="es18xx_revert_wavetable_input.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="es18xx_revert_wavetable_input.diff"

commit 8fa1de6349913b63d8ebfb27003b7045eeb9f12a
Author: Rene Herman <rene.herman@gmail.com>
Date:   Tue Mar 11 15:52:36 2008 +0100

    Revert "[ALSA] es18xx: Enable wavetable input from ESS chips"
    
    This reverts commit 1bc9eed379399484d3f5d5a0834674983969bc1e.

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 90498e4..865ab1d 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1441,8 +1441,6 @@ static int __devinit snd_es18xx_initialize(struct snd_es18xx *chip)
 		snd_es18xx_write(chip, 0xB2, 0x50);
 		/* Enable MPU and hardware volume interrupt */
 		snd_es18xx_mixer_write(chip, 0x64, 0x42);
-		/* Enable ESS wavetable input */
-		snd_es18xx_mixer_bits(chip, 0x48, 0x10, 0x10);
 	}
 	else {
 		int irqmask, dma1mask, dma2mask;

--------------020605050705070702050506--
