Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbYGFXRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbYGFXRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 19:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbYGFXRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 19:17:46 -0400
Received: from saeurebad.de ([85.214.36.134]:33805 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbYGFXRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 19:17:45 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mathieu Chouquet-Stringer <mchouque@free.fr>,
       Jaroslav Kysela <perex@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Longstanding bug in ac97/intel8x0 resume/init
References: <87hcca3xkx.fsf@saeurebad.de>
	<8763rsa5qk.fsf@skyscraper.fehenstaub.lan>
	<m3iqvq7nt0.fsf@mobydick.mine.nu> <s5h63rpen37.wl%tiwai@suse.de>
	<87k5g54qmh.fsf@skyscraper.fehenstaub.lan>
	<s5h1w2dek7p.wl%tiwai@suse.de>
	<87fxqt4p19.fsf@skyscraper.fehenstaub.lan>
	<s5hvdzpd484.wl%tiwai@suse.de>
Date: Mon, 07 Jul 2008 01:17:38 +0200
In-Reply-To: <s5hvdzpd484.wl%tiwai@suse.de> (Takashi Iwai's message of "Tue,
	01 Jul 2008 17:16:43 +0200")
Message-ID: <87wsjyr4a5.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Takashi Iwai <tiwai@suse.de> writes:

> At Tue, 01 Jul 2008 17:12:02 +0200,
> Johannes Weiner wrote:
>> 
>> Hi,
>> 
>> Takashi Iwai <tiwai@suse.de> writes:
>> 
>> > At Tue, 01 Jul 2008 16:37:42 +0200,
>> > Johannes Weiner wrote:
>> >> 
>> >> Hi,
>> >> 
>> >> Takashi Iwai <tiwai@suse.de> writes:
>> >> 
>> >> > At 30 Jun 2008 20:58:03 +0200,
>> >> > Mathieu Chouquet-Stringer wrote:
>> >> >> 
>> >> >>         Hey there,
>> >> >> 
>> >> >> hannes@saeurebad.de (Johannes Weiner) writes:
>> >> >> > Johannes Weiner <hannes@saeurebad.de> writes:
>> >> >> > > my laptop has muted sound after resuming the soundcard (by
>> >> >> > > s2ram/hibernation).  The problem seems to be that the cached register
>> >> >> > > values are not written back to the device properly.
>> >> >> 
>> >> >> I've got the same exact issue on a Thinkpad T30:
>> >> >> 
>> >> >>  0 [I82801CAICH3   ]: ICH - Intel 82801CA-ICH3
>> >> >>                       Intel 82801CA-ICH3 with AD1881A at irq 5
>> >> >> 
>> >> >> 00:1f.5 Multimedia audio controller: Intel Corporation 82801CA/CAM AC'97 Audio Controller (rev 02)
>> >> >
>> >> > Does this happen for both hibernation and S2RAM?
>> >> > And, resetting the mixer repairs the mute state, right?
>> >> > If yes, the problem appears independently from the codec chip.  Hmm...
>> >> 
>> >> Yes, happens in both cases here.
>> >> 
>> >> The alsamixer shows the state of the channels before the suspension(!).
>> >
>> > Yes.  The driver returns the cached values.
>> 
>> Okay.
>> 
>> >> If I change the channel state, the sound works again.  No complete reset
>> >> needed at all, I just have to increase/decrease the value a bit (for
>> >> each affected channel).
>> >
>> > Just touching one mixer element?
>> 
>> What means `element' here?  I have to touch MASTER and PCM in order to
>> get some output again, at least ;)
>
> Well, for example, some laptops with maestro3 have a similar problem,
> but in that case, you just need to touch one mixer element
> (e.g. Master), and you don't have to re-adjust PCM volume.
>
>> >> >From my experiments with the code, I figured that the cached register
>> >> values are not written back properly on resume.  The cache is in the
>> >> correct state but the hardware is not.  This also explains the behaviour
>> >> when changing the channels with alsamixer; the register cache is touched
>> >> and written back (and this time, the value really gets through to the
>> >> hardware).
>> >
>> > Right.  
>> >
>> > snd_ac97_resume() has a check whether the write to MASTER register
>> > succeeds, but its timeout is 100ms.  Could you check whether this
>> > check passes at resume or failed?  I remember that some device
>> > actually passed the test but didn't update the real hardware state.
>> > If it failed on yours, we may simply extend the timeout, or make it
>> > pending somehow.  If the hardware fools us, however, it'd be toucher.
>> 
>> By experimentation I found that the writeback works with a two seconds
>> delay before writeback.  I can't remember if it was before or after the
>> check.  Another approach was to hammer down the value by writing and
>> reading back in a loop until the hardware responded with the correct
>> value.
>> 
>> I will redo the tests later and report back to you what helped.
>
> Yeah, that'll be appreciated.

Okay, I redid the test with something (pretty stupid) like this:

--- a/sound/pci/ac97/ac97_codec.c
+++ b/sound/pci/ac97/ac97_codec.c
@@ -28,6 +28,7 @@
 #include <linux/pci.h>
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
+#include <linux/kallsyms.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/tlv.h>
@@ -2456,8 +2457,23 @@ static void snd_ac97_restore_status(struct snd_ac97 *ac97)
                 * are accessed..!
                 */
                if (test_bit(i, ac97->reg_accessed)) {
+                       printk("restoring register %d\n", i);
                        snd_ac97_write(ac97, i, ac97->regs[i]);
-                       snd_ac97_read(ac97, i);
+                       msleep(800);
+                       if (snd_ac97_read(ac97, i) != ac97->regs[i]) {
+                               printk("double write register %d\n", i);
+                               snd_ac97_write(ac97, i, ac97->regs[i]);
+                       }
+                       msleep(800);
+                       if (snd_ac97_read(ac97, i) != ac97->regs[i]) {
+                               printk("triple write register %d\n", i);
+                               snd_ac97_write(ac97, i, ac97->regs[i]);
+                       }
+                       msleep(800);
+                       if (snd_ac97_read(ac97, i) != ac97->regs[i]) {
+                               printk("quadruple write register %d\n", i);
+                               snd_ac97_write(ac97, i, ac97->regs[i]);
+                       }
                }
        }
 }

This makes the device resume properly, but the delays are insanely long
and still sometimes it comes to the third write!

I suspect that this issue is not a problem in the writeback code but in
the init/exit code of the driver (either intel8x0 or ac97 itself, no
idea).

Because the following behaviour can be seen:

  1. modprobe snd-intel8x0: everything fine.
  2. rmmod snd-intel8x0: everything fine.
  3. modprobe snd-intel8x0:
     ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
     PCI: Setting latency timer of device 0000:00:1f.5 to 64
     ALSA sound/pci/ac97/ac97_codec.c:2054: AC'97 0 does not respond - RESET
     ACPI: PCI interrupt for device 0000:00:1f.5 disabled
     Intel ICH: probe of 0000:00:1f.5 failed with error -13
  2. rmmod snd-intel8x0: everything fine.
  3. modprobe snd-intel8x0: everything fine

So I suspect that the device is not shut down properly on
deactivation/suspension.

Therefor this module reloading fails and the resume tries to writeback
registers on the not-properly-initialized hardware.  The delays appear
way too long for me to be expectable from this hardware if it is
properly initialized, no?

May this be a possible?

If you need any more information, please say so.  This bug is really
annoying :/

	Hannes
