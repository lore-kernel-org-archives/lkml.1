Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYDAChN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYDAChN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 22:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYDACg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 22:36:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:46857 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYDACg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 22:36:57 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] sound/pci/rme9652/hdspm.c: stop inlining largish static functions
Date: Tue, 1 Apr 2008 04:36:48 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_A/Z8HBiZbvUF2+/"
Message-Id: <200804010436.48348.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_A/Z8HBiZbvUF2+/
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Takashi,

Can you please take a look at this patch?

sound/pci/rme9652/hdspm.c has unusually large number
of static inline functions - 22.

I looked through them and some of them seem to be too big
to warrant inlining.

This patch removes "inline" from these static functions
(regardless of number of callsites - gcc nowadays auto-inlines
statics with one callsite).

Size difference on 32bit x86:
   text    data     bss     dec     hex filename
  20437    2160     516   23113    5a49 linux-2.6-ALLYES/sound/pci/rme9652/hdspm.o
  18036    2160     516   20712    50e8 linux-2.6.inline-ALLYES/sound/pci/rme9652/hdspm.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_A/Z8HBiZbvUF2+/
Content-Type: text/x-diff;
  charset="us-ascii";
  name="deinline_hdspm.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="deinline_hdspm.diff"

diff -urp -U 10 linux-2.6/sound/pci/rme9652/hdspm.c linux-2.6.inline/sound/pci/rme9652/hdspm.c
--- linux-2.6/sound/pci/rme9652/hdspm.c	2008-03-30 03:27:56.000000000 +0200
+++ linux-2.6.inline/sound/pci/rme9652/hdspm.c	2008-04-01 04:03:36.000000000 +0200
@@ -533,21 +533,21 @@ static int __devinit snd_hdspm_create_pc
 
 static inline void snd_hdspm_initialize_midi_flush(struct hdspm * hdspm);
 static int hdspm_update_simple_mixer_controls(struct hdspm * hdspm);
 static int hdspm_autosync_ref(struct hdspm * hdspm);
 static int snd_hdspm_set_defaults(struct hdspm * hdspm);
 static void hdspm_set_sgbuf(struct hdspm * hdspm, struct snd_sg_buf *sgbuf,
 			     unsigned int reg, int channels);
 
 static inline int HDSPM_bit2freq(int n)
 {
-	static int bit2freq_tab[] = { 0, 32000, 44100, 48000, 64000, 88200,
+	static const int bit2freq_tab[] = { 0, 32000, 44100, 48000, 64000, 88200,
 		96000, 128000, 176400, 192000 };
 	if (n < 1 || n > 9)
 		return 0;
 	return bit2freq_tab[n];
 }
 
 /* Write/read to/from HDSPM with Adresses in Bytes
    not words but only 32Bit writes are allowed */
 
 static inline void hdspm_write(struct hdspm * hdspm, unsigned int reg,
@@ -575,34 +575,34 @@ static inline int hdspm_read_in_gain(str
 }
 
 static inline int hdspm_read_pb_gain(struct hdspm * hdspm, unsigned int chan,
 				     unsigned int pb)
 {
 	if (chan >= HDSPM_MIXER_CHANNELS || pb >= HDSPM_MIXER_CHANNELS)
 		return 0;
 	return hdspm->mixer->ch[chan].pb[pb];
 }
 
-static inline int hdspm_write_in_gain(struct hdspm * hdspm, unsigned int chan,
+static int hdspm_write_in_gain(struct hdspm * hdspm, unsigned int chan,
 				      unsigned int in, unsigned short data)
 {
 	if (chan >= HDSPM_MIXER_CHANNELS || in >= HDSPM_MIXER_CHANNELS)
 		return -1;
 
 	hdspm_write(hdspm,
 		    HDSPM_MADI_mixerBase +
 		    ((in + 128 * chan) * sizeof(u32)),
 		    (hdspm->mixer->ch[chan].in[in] = data & 0xFFFF));
 	return 0;
 }
 
-static inline int hdspm_write_pb_gain(struct hdspm * hdspm, unsigned int chan,
+static int hdspm_write_pb_gain(struct hdspm * hdspm, unsigned int chan,
 				      unsigned int pb, unsigned short data)
 {
 	if (chan >= HDSPM_MIXER_CHANNELS || pb >= HDSPM_MIXER_CHANNELS)
 		return -1;
 
 	hdspm_write(hdspm,
 		    HDSPM_MADI_mixerBase +
 		    ((64 + pb + 128 * chan) * sizeof(u32)),
 		    (hdspm->mixer->ch[chan].pb[pb] = data & 0xFFFF));
 	return 0;
@@ -614,36 +614,36 @@ static inline void snd_hdspm_enable_in(s
 {
 	hdspm_write(hdspm, HDSPM_inputEnableBase + (4 * i), v);
 }
 
 static inline void snd_hdspm_enable_out(struct hdspm * hdspm, int i, int v)
 {
 	hdspm_write(hdspm, HDSPM_outputEnableBase + (4 * i), v);
 }
 
 /* check if same process is writing and reading */
-static inline int snd_hdspm_use_is_exclusive(struct hdspm * hdspm)
+static int snd_hdspm_use_is_exclusive(struct hdspm * hdspm)
 {
 	unsigned long flags;
 	int ret = 1;
 
 	spin_lock_irqsave(&hdspm->lock, flags);
 	if ((hdspm->playback_pid != hdspm->capture_pid) &&
 	    (hdspm->playback_pid >= 0) && (hdspm->capture_pid >= 0)) {
 		ret = 0;
 	}
 	spin_unlock_irqrestore(&hdspm->lock, flags);
 	return ret;
 }
 
 /* check for external sample rate */
-static inline int hdspm_external_sample_rate(struct hdspm * hdspm)
+static int hdspm_external_sample_rate(struct hdspm * hdspm)
 {
 	if (hdspm->is_aes32) {
 		unsigned int status2 = hdspm_read(hdspm, HDSPM_statusRegister2);
 		unsigned int status = hdspm_read(hdspm, HDSPM_statusRegister);
 		unsigned int timecode =
 			hdspm_read(hdspm, HDSPM_timecodeRegister);
 
 		int syncref = hdspm_autosync_ref(hdspm);
 
 		if (syncref == HDSPM_AES32_AUTOSYNC_FROM_WORD &&
@@ -780,21 +780,21 @@ static inline void hdspm_start_audio(str
 	hdspm_write(s, HDSPM_controlRegister, s->control_register);
 }
 
 static inline void hdspm_stop_audio(struct hdspm * s)
 {
 	s->control_register &= ~(HDSPM_Start | HDSPM_AudioInterruptEnable);
 	hdspm_write(s, HDSPM_controlRegister, s->control_register);
 }
 
 /* should I silence all or only opened ones ? doit all for first even is 4MB*/
-static inline void hdspm_silence_playback(struct hdspm * hdspm)
+static void hdspm_silence_playback(struct hdspm * hdspm)
 {
 	int i;
 	int n = hdspm->period_bytes;
 	void *buf = hdspm->playback_buffer;
 
 	if (buf == NULL)
 		return;
 
 	for (i = 0; i < HDSPM_MAX_CHANNELS; i++) {
 		memset(buf, 0, n);
@@ -1050,21 +1050,21 @@ static inline int snd_hdspm_midi_output_
 	else
 		fifo_bytes_used = hdspm_read(hdspm, HDSPM_midiStatusOut0);
 	fifo_bytes_used &= 0xff;
 
 	if (fifo_bytes_used < 128)
 		return  128 - fifo_bytes_used;
 	else
 		return 0;
 }
 
-static inline void snd_hdspm_flush_midi_input (struct hdspm *hdspm, int id)
+static void snd_hdspm_flush_midi_input (struct hdspm *hdspm, int id)
 {
 	while (snd_hdspm_midi_input_available (hdspm, id))
 		snd_hdspm_midi_read_byte (hdspm, id);
 }
 
 static int snd_hdspm_midi_output_write (struct hdspm_midi *hmidi)
 {
 	unsigned long flags;
 	int n_pending;
 	int to_write;

--Boundary-00=_A/Z8HBiZbvUF2+/--
