Return-Path: <linux-kernel-owner+w=401wt.eu-S936221AbYEBTUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936221AbYEBTUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764051AbYEBTUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:20:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:53074 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764042AbYEBTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=b9wMOWl+uv55l0ziAxU6fqnJZNS+cWjyeQW7WPy0ROZGRGtpw8W1RTxYNoAPoKxlJLSqd2az2RLOsAMEdqsl+Fuq5ReDoUDHYoRXtvX3gpnBxPGOcpc6vfawMTA8cA7WT2patEVknwuc69QDoMUg1fnkghw4sldl/dG2tD92Ta8=
Message-ID: <481B6849.7050501@gmail.com>
Date: Fri, 02 May 2008 21:15:21 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: tiwai@suse.de
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ALSA] [regression] No sound on ALC861 Analog with current git
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Takashi,

I've found that my sound card is muted with current git: it's recognized,
controls are set correctly, etc., but there's no sound in speakers. I've
bisected it down and found that this issue was caused by:

commit f6c7e5461e9046445d50c5c7a9a4587824239623
[ALSA] hda-codec - Fix auto-configuration of Realtek codecs

This patch fixes some bugs in the auto-configurator of Realtek codecs:
- add missing pin set-up for speaker pins
- fix the speaker auto-mute function not to conflict with the existing
  "Speaker" mixer switch

Signed-off-by: Takashi Iwai <tiwai@suse.de>


Exact problem lays in alc861_auto_set_output_and_unmute() migrated to
alc_set_pin_output(), which now calls:
snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_AMP_GAIN_MUTE,
                            AMP_OUT_UNMUTE);
Previously alc861_auto_set_output_and_unmute() was using dac_idx instead of nid.
I've added some silly printks and it looks like on my system there's a mismatch
which is causing this problem:
Called alc861_init_multi_out. Line outs: 1
Called alc861_auto_set_output_and_unmute with dac_idx: 3, nid: 11
Called alc_set_pin_output with pin_type: 64

Reverting change in alc861_auto_set_output_and_unmute() fixes problem (rfc patch
below).

Details about sound card:
$ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC861 Analog [ALC861 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

$ /sbin/lspci -s 00:1b.0 -vvv
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition
Audio Controller (rev 02)
        Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10c1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at d4540000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0
        Capabilities: [100] Virtual Channel
        Capabilities: [130] Unknown (5)

--------------------------

From: Jacek Luczak <luczak.jacek@gmail.com>

[ALSA] Revert migration to alc_set_pin_output() in
alc861_auto_set_output_and_unmute().

Change done by:
	commit f6c7e5461e9046445d50c5c7a9a4587824239623
	[ALSA] hda-codec - Fix auto-configuration of Realtek codecs
broke sound on ALC861 Analog.

Signed-off-by: Jacek Luczak <luczak.jacek@gmail.com>

---
 patch_realtek.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d9783a4..0a50205 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11902,7 +11902,10 @@ static void alc861_auto_set_output_and_unmute(struct
hda_codec *codec,
                                              hda_nid_t nid,
                                              int pin_type, int dac_idx)
 {
-       alc_set_pin_output(codec, nid, pin_type);
+       snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
+                       pin_type);
+       snd_hda_codec_write(codec, dac_idx, 0, AC_VERB_SET_AMP_GAIN_MUTE,
+                       AMP_OUT_UNMUTE);
 }

 static void alc861_auto_init_multi_out(struct hda_codec *codec)

