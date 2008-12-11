Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbYLKTea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbYLKTea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbYLKTSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:53 -0500
Received: from kroah.org ([198.145.64.141]:56303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757765AbYLKTSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:51 -0500
Date: Thu, 11 Dec 2008 11:15:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [patch 46/83] ALSA: hda - Fix ALC269 capture source
Message-ID: <20081211191515.GT5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-alc269-capture-source.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e01bf5091f044011823aefa1882eb3fba0434918 upstream

ALC269 capture source wasn't properly set up.
It's an independent MUX (0x23), not a source of ADC.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11038,6 +11038,14 @@ static hda_nid_t alc269_adc_nids[1] = {
 	0x08,
 };
 
+static hda_nid_t alc269_capsrc_nids[1] = {
+	0x23,
+};
+
+/* NOTE: ADC2 (0x07) is connected from a recording *MIXER* (0x24),
+ *       not a mux!
+ */
+
 static struct hda_input_mux alc269_eeepc_dmic_capture_source = {
 	.num_items = 2,
 	.items = {
@@ -11404,6 +11412,10 @@ static int alc269_parse_auto_config(stru
 	spec->init_verbs[spec->num_init_verbs++] = alc269_init_verbs;
 	spec->num_mux_defs = 1;
 	spec->input_mux = &spec->private_imux;
+	/* set default input source */
+	snd_hda_codec_write_cache(codec, alc269_capsrc_nids[0],
+				  0, AC_VERB_SET_CONNECT_SEL,
+				  spec->input_mux->items[0].index);
 
 	err = alc_auto_add_mic_boost(codec);
 	if (err < 0)
@@ -11536,6 +11548,7 @@ static int patch_alc269(struct hda_codec
 
 	spec->adc_nids = alc269_adc_nids;
 	spec->num_adc_nids = ARRAY_SIZE(alc269_adc_nids);
+	spec->capsrc_nids = alc269_capsrc_nids;
 
 	codec->patch_ops = alc_patch_ops;
 	if (board_config == ALC269_AUTO)

