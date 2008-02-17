Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbYBQKbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbYBQKbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 05:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbYBQKbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 05:31:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:14155 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbYBQKbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 05:31:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=XKOkmR0chxHzMnkOH917n+apE+/nBGZEsTUq/2tU0Lz2wEjRSTrI1YbTlDsCQwp3B+6gHtNISw2/UTXH1CANQOlWRpkDHxxngn05llJs7uXeUNnoWW24nPQpaFTahBdIWwy34K5TC3LoGP2rCjEl/eL0SlWvoRnJlQ8Z3u9t5eQ=
Message-ID: <47B80CED.3060903@gmail.com>
Date: Sun, 17 Feb 2008 11:31:09 +0100
From: Adel Gadllah <adel.gadllah@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>
CC: tiwai@suse.de, Chuck Ebbert <cebbert@redhat.com>
Subject: [PATCH] snd-hda-intel: don't print using snd_printdd on device open
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When CONFIG_SND_DEBUG_DETECT is set the hda-intel driver prints verbose 
info like this:

ALSA sound/pci/hda/hda_intel.c:1259: azx_pcm_prepare: bufsize=0x4400,
fragsize=0x1100, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x7,
stream=0x5, channel=0, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x5, channel=0, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x0, channel=0, format=0x0
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x7,
stream=0x0, channel=0, format=0x0
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x0, channel=0, format=0x0

Every time when an app opens the sound device.
This makes it impossible for distribution to enable this config option 
(to get more debug information for bug reports),
because its way too noisy.
SND_DEBUG_DETECT should only print stuff once when loading the driver.
 
There are some options to fix this:

1) don't print anything in functions that gets called when the device gets
opened/prepared for output.

2) use snd_printd instead of snd_printdd and make 
CONFIG_SND_DEBUG_DETECT not depend on CONFIG_SND_DEBUG (this should be 
done anyway)

3) introduce a CONFIG_SND_DEBUG_DETECT_VERBOSE and snd_printddv and use 
it in this places (this one should be disabled by distributions then)

The attached patch implements 1) if 2) or 3) is preferred I can send a 
patch to do this.

Please CC me when replying


----------

snd-hda-intel: don't print using snd_printdd on device open

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>
CC: Chuck Ebbert <cebbert@redhat.com>

diff -upNr linux-2.6.24.2.orign/sound/pci/hda/hda_codec.c 
linux-2.6.24.2/sound/pci/hda/hda_codec.c
--- linux-2.6.24.2.orign/sound/pci/hda/hda_codec.c    2008-02-11 
06:51:11.000000000 +0100
+++ linux-2.6.24.2/sound/pci/hda/hda_codec.c    2008-02-17 
11:08:58.000000000 +0100
@@ -677,9 +677,6 @@ void snd_hda_codec_setup_stream(struct h
     if (!nid)
         return;
 
-    snd_printdd("hda_codec_setup_stream: "
-            "NID=0x%x, stream=0x%x, channel=%d, format=0x%x\n",
-            nid, stream_tag, channel_id, format);
     snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_CHANNEL_STREAMID,
                 (stream_tag << 4) | channel_id);
     msleep(1);
diff -upNr linux-2.6.24.2.orign/sound/pci/hda/hda_intel.c 
linux-2.6.24.2/sound/pci/hda/hda_intel.c
--- linux-2.6.24.2.orign/sound/pci/hda/hda_intel.c    2008-02-11 
06:51:11.000000000 +0100
+++ linux-2.6.24.2/sound/pci/hda/hda_intel.c    2008-02-17 
11:10:16.000000000 +0100
@@ -1249,9 +1249,6 @@ static int azx_pcm_prepare(struct snd_pc
         return -EINVAL;
     }
 
-    snd_printdd("azx_pcm_prepare: bufsize=0x%x, fragsize=0x%x, "
-            "format=0x%x\n",
-            azx_dev->bufsize, azx_dev->fragsize, azx_dev->format_val);
     azx_setup_periods(azx_dev);
     azx_setup_controller(chip, azx_dev);
     if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)





