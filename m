Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZKPPwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZKPPwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZKPPwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:52:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:58744 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZKPPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=MkKJTpPLcvDv0BUKquKnhr/Ke94OTL8MN7baXF2wV66Ts+yGPWW/4uqwt91DbRGB+o
         kwAwZvxBN3mm4sg80cy7uoGohT4X59Rh0tKKvlRcikkHtQ/RKIeMnNC4mKPb/VhH0t6a
         dkJik3bSGAUyZYYbnKhpOUSffitod1C1EQO7Y=
Message-ID: <4B01782E.80802@gmail.com>
Date: Mon, 16 Nov 2009 17:05:02 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] OSS: keep index within bounds of midi_devs[]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the {orig,midi}_dev equals num_midis, that's one too
large already.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
In MIDIbuf_open() sound/oss/midibuf.c:166

        if (num_midis > MAX_MIDI_DEV)
        {
                printk(KERN_ERR "midi: Too many midi interfaces\n");
                num_midis = MAX_MIDI_DEV;
        }

num_midis is at most MAX_MIDI_DEV.

`git grep -n MAX_MIDI_DEV' and note that when the index equals
num_midis this causes reads/writes outside array bounds for
midi_devs, midi2synth, dev_conf and others (below check in patch).

 sound/oss/midi_synth.c |    2 +-
 sound/oss/mpu401.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/oss/midi_synth.c b/sound/oss/midi_synth.c
index 9e45098..3bc7104 100644
--- a/sound/oss/midi_synth.c
+++ b/sound/oss/midi_synth.c
@@ -426,7 +426,7 @@ midi_synth_open(int dev, int mode)
 	int             err;
 	struct midi_input_info *inc;
 
-	if (orig_dev < 0 || orig_dev > num_midis || midi_devs[orig_dev] == NULL)
+	if (orig_dev < 0 || orig_dev >= num_midis || midi_devs[orig_dev] == NULL)
 		return -ENXIO;
 
 	midi2synth[orig_dev] = dev;
diff --git a/sound/oss/mpu401.c b/sound/oss/mpu401.c
index 734b8f9..0af9d24 100644
--- a/sound/oss/mpu401.c
+++ b/sound/oss/mpu401.c
@@ -770,7 +770,7 @@ static int mpu_synth_ioctl(int dev, unsigned int cmd, void __user *arg)
 
 	midi_dev = synth_devs[dev]->midi_dev;
 
-	if (midi_dev < 0 || midi_dev > num_midis || midi_devs[midi_dev] == NULL)
+	if (midi_dev < 0 || midi_dev >= num_midis || midi_devs[midi_dev] == NULL)
 		return -ENXIO;
 
 	devc = &dev_conf[midi_dev];
