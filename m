Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829Ab0BZBCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:02:10 -0500
Received: from nereida.gnuservers.com.ar ([207.192.69.134]:43884 "EHLO
	nereida.gnuservers.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934805Ab0BZBCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:02:08 -0500
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2010 20:02:08 EST
Date: Thu, 25 Feb 2010 21:51:44 -0300
From: Margarita Manterola <marga@debian.org>
To: linux-kernel@vger.kernel.org
Subject: Problems regarding Line-In for snd_hda_intel - chipset ALC268
Message-ID: <20100226005144.GA2616@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have an ALC268 snd_hda_intel sound card, and the line-in used to work up
till 2.6.26 (Debian version).  After upgrading to 2.6.30, it stopped
working, I waited for a few releases and when it still didn't work I
decided to take action and debug it.  I did some bisecting, and then
proceeded to bisect the faulty patch itself, ending up with a one-line fix.

This is the lspci line:

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)

And this is what alsamixer says about it:

Card: HDA Intel
Chip: Realtek ALC268

The motherboard model is: Intel DG31GL

The faulty patch (after bisecting) was along the road between 2.6.29 and
2.6.30:

---------------------------------------------------------
commit 4cfb91c6d764b18e81bfb6e6779e07bcecbb197c
Author: Takashi Iwai <tiwai@suse.de>
Date:   Fri Jan 23 12:53:09 2009 +0100

    ALSA: hda - Fix invalid amp init for ALC268 codec

    Fix some invalid AMP initializations for ALC268 codecs.

    Signed-off-by: Takashi Iwai <tiwai@suse.de>
---------------------------------------------------------

This patch includes quite a number of lines.  However, I was able to reduce
my fix to reverting just one line:

---------------------------------------------------------
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11672,6 +11672,7 @@ static struct hda_verb alc268_base_init_verbs[] = {
  */
 static struct hda_verb alc268_volume_init_verbs[] = {
    /* set output DAC */
+   {0x02, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
    {0x02, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
    {0x03, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
---------------------------------------------------------

This means re-adding one of the many lines that were deleted in that patch.
Note: I have NO idea of what this line does, I just was able to find that
by adding it back I could get Line-In to work.

Reverting this made my card work with v2.6.30.  However, I couldn't make my
card work with any kernels after the following patch (in the road from
2.6.30 to 2.6.31), because after this patch my card is detected as having
only one capture device instead of two, and Line-In only works when
configured in the second Capture device:

---------------------------------------------------------
commit 05f5f477082f0b192dab5ac25ccc5d468d98ecbd
Author: Takashi Iwai <tiwai@suse.de>
Date:   Tue Aug 25 13:10:18 2009 +0200

    ALSA: hda - Generalize input pin parsing in patch_realtek.c

    Provide a standard parser for input pins to create the input mixer
    and input source controls instead of having a difference one for each
    Realtek codec.  The new helper parses the codec connections dynamically
    isntead of fixed indicies.

    Signed-off-by: Takashi Iwai <tiwai@suse.de>
---------------------------------------------------------

This patch, as can be imagined by the description, is quite long.  However, it
doesn't seem that the patch itself is wrong, but that somewhere, something
about my card is not properly configured, and then it can't get properly
detected.

I tried to figure out what exactly was wrong in the card detection, but
sadly I got lost in the code.

So, I'd appreciate if the line indicated previously could be reverted, so
that Line-In works and also if my card could be properly detected again, to
have the two capture devices I used to have, I'm sorry I'm not able to
provide more info about this part.

I'm able to test patches if necessary.

-- 
Thanks!
Margarita Manterola
Debian Developer
