Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbYHRTB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbYHRTB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761950AbYHRS7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:59:49 -0400
Received: from ns.suse.de ([195.135.220.2]:43571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761946AbYHRS7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:59:48 -0400
Date: Mon, 18 Aug 2008 11:44:45 -0700
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
       alan@lxorguk.ukuu.org.uk, Timur Tabi <timur@freescale.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 37/60] ALSA: asoc: restrict sample rate and size in
	Freescale MPC8610 sound drivers
Message-ID: <20080818184445.GL29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-asoc-restrict-sample-rate-and-size-in-freescale-mpc8610-sound-drivers.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Timur Tabi <timur@freescale.com>

Upstream-commid-id: be41e941d5f1a48bde7f44d09d56e8d2605f98e1

The Freescale MPC8610 SSI device has the option of using one clock for both
transmit and receive (synchronous mode), or independent clocks (asynchronous).
The SSI driver, however, programs the SSI into synchronous mode and then
tries to program the clock registers independently.  The result is that the wrong
sample size is usually generated during recording.

This patch fixes the discrepancy by restricting the sample rate and sample size
of the playback and capture streams.  The SSI driver remembers which stream
is opened first.  When a second stream is opened, that stream is constrained
to the same sample rate and size as the first stream.

A future version of this driver will lift the sample size restriction.
Supporting independent sample rates is more difficult, because only certain
codecs provide dual independent clocks.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/fsl/fsl_dma.c |    7 +++-
 sound/soc/fsl/fsl_ssi.c |   74 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 70 insertions(+), 11 deletions(-)

--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -132,12 +132,17 @@ struct fsl_dma_private {
  * Since each link descriptor has a 32-bit byte count field, we set
  * period_bytes_max to the largest 32-bit number.  We also have no maximum
  * number of periods.
+ *
+ * Note that we specify SNDRV_PCM_INFO_JOINT_DUPLEX here, but only because a
+ * limitation in the SSI driver requires the sample rates for playback and
+ * capture to be the same.
  */
 static const struct snd_pcm_hardware fsl_dma_hardware = {
 
 	.info   		= SNDRV_PCM_INFO_INTERLEAVED |
 				  SNDRV_PCM_INFO_MMAP |
-				  SNDRV_PCM_INFO_MMAP_VALID,
+				  SNDRV_PCM_INFO_MMAP_VALID |
+				  SNDRV_PCM_INFO_JOINT_DUPLEX,
 	.formats		= FSLDMA_PCM_FORMATS,
 	.rates  		= FSLDMA_PCM_RATES,
 	.rate_min       	= 5512,
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -67,6 +67,8 @@
  * @ssi: pointer to the SSI's registers
  * @ssi_phys: physical address of the SSI registers
  * @irq: IRQ of this SSI
+ * @first_stream: pointer to the stream that was opened first
+ * @second_stream: pointer to second stream
  * @dev: struct device pointer
  * @playback: the number of playback streams opened
  * @capture: the number of capture streams opened
@@ -79,6 +81,8 @@ struct fsl_ssi_private {
 	struct ccsr_ssi __iomem *ssi;
 	dma_addr_t ssi_phys;
 	unsigned int irq;
+	struct snd_pcm_substream *first_stream;
+	struct snd_pcm_substream *second_stream;
 	struct device *dev;
 	unsigned int playback;
 	unsigned int capture;
@@ -342,6 +346,49 @@ static int fsl_ssi_startup(struct snd_pc
 		 */
 	}
 
+	if (!ssi_private->first_stream)
+		ssi_private->first_stream = substream;
+	else {
+		/* This is the second stream open, so we need to impose sample
+		 * rate and maybe sample size constraints.  Note that this can
+		 * cause a race condition if the second stream is opened before
+		 * the first stream is fully initialized.
+		 *
+		 * We provide some protection by checking to make sure the first
+		 * stream is initialized, but it's not perfect.  ALSA sometimes
+		 * re-initializes the driver with a different sample rate or
+		 * size.  If the second stream is opened before the first stream
+		 * has received its final parameters, then the second stream may
+		 * be constrained to the wrong sample rate or size.
+		 *
+		 * FIXME: This code does not handle opening and closing streams
+		 * repeatedly.  If you open two streams and then close the first
+		 * one, you may not be able to open another stream until you
+		 * close the second one as well.
+		 */
+		struct snd_pcm_runtime *first_runtime =
+			ssi_private->first_stream->runtime;
+
+		if (!first_runtime->rate || !first_runtime->sample_bits) {
+			dev_err(substream->pcm->card->dev,
+				"set sample rate and size in %s stream first\n",
+				substream->stream == SNDRV_PCM_STREAM_PLAYBACK
+				? "capture" : "playback");
+			return -EAGAIN;
+		}
+
+		snd_pcm_hw_constraint_minmax(substream->runtime,
+			SNDRV_PCM_HW_PARAM_RATE,
+			first_runtime->rate, first_runtime->rate);
+
+		snd_pcm_hw_constraint_minmax(substream->runtime,
+			SNDRV_PCM_HW_PARAM_SAMPLE_BITS,
+			first_runtime->sample_bits,
+			first_runtime->sample_bits);
+
+		ssi_private->second_stream = substream;
+	}
+
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		ssi_private->playback++;
 
@@ -371,18 +418,16 @@ static int fsl_ssi_prepare(struct snd_pc
 	struct fsl_ssi_private *ssi_private = rtd->dai->cpu_dai->private_data;
 
 	struct ccsr_ssi __iomem *ssi = ssi_private->ssi;
-	u32 wl;
 
-	wl = CCSR_SSI_SxCCR_WL(snd_pcm_format_width(runtime->format));
+	if (substream == ssi_private->first_stream) {
+		u32 wl;
 
-	clrbits32(&ssi->scr, CCSR_SSI_SCR_SSIEN);
+		/* The SSI should always be disabled at this points (SSIEN=0) */
+		wl = CCSR_SSI_SxCCR_WL(snd_pcm_format_width(runtime->format));
 
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		/* In synchronous mode, the SSI uses STCCR for capture */
 		clrsetbits_be32(&ssi->stccr, CCSR_SSI_SxCCR_WL_MASK, wl);
-	else
-		clrsetbits_be32(&ssi->srccr, CCSR_SSI_SxCCR_WL_MASK, wl);
-
-	setbits32(&ssi->scr, CCSR_SSI_SCR_SSIEN);
+	}
 
 	return 0;
 }
@@ -407,9 +452,13 @@ static int fsl_ssi_trigger(struct snd_pc
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-			setbits32(&ssi->scr, CCSR_SSI_SCR_TE);
+			clrbits32(&ssi->scr, CCSR_SSI_SCR_SSIEN);
+			setbits32(&ssi->scr,
+				CCSR_SSI_SCR_SSIEN | CCSR_SSI_SCR_TE);
 		} else {
-			setbits32(&ssi->scr, CCSR_SSI_SCR_RE);
+			clrbits32(&ssi->scr, CCSR_SSI_SCR_SSIEN);
+			setbits32(&ssi->scr,
+				CCSR_SSI_SCR_SSIEN | CCSR_SSI_SCR_RE);
 
 			/*
 			 * I think we need this delay to allow time for the SSI
@@ -452,6 +501,11 @@ static void fsl_ssi_shutdown(struct snd_
 	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
 		ssi_private->capture--;
 
+	if (ssi_private->first_stream == substream)
+		ssi_private->first_stream = ssi_private->second_stream;
+
+	ssi_private->second_stream = NULL;
+
 	/*
 	 * If this is the last active substream, disable the SSI and release
 	 * the IRQ.

-- 
