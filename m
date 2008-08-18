Return-Path: <linux-kernel-owner+w=401wt.eu-S932505AbYHRTC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbYHRTC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbYHRTBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:01:04 -0400
Received: from ns1.suse.de ([195.135.220.2]:43714 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbYHRTBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:01:01 -0400
Date: Mon, 18 Aug 2008 11:44:53 -0700
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
Subject: [patch 40/60] ALSA: ASoC: fix SNDCTL_DSP_SYNC support in Freescale
	8610 sound drivers
Message-ID: <20080818184453.GO29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-asoc-fix-sndctl_dsp_sync-support-in-freescale-8610-sound-drivers.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Timur Tabi <timur@freescale.com>

Upstream-commit-id: bf9c8c9ddef7ef761ae9747349175adad0ef16ce

If an OSS application calls SNDCTL_DSP_SYNC, then ALSA will call the driver's
_hw_params and _prepare functions again.  On the Freescale MPC8610 DMA ASoC
driver, this caused the DMA controller to be unneccessarily re-programmed, and
apparently it doesn't like that.  The DMA will then not operate when
instructed.  This patch relocates much of the DMA programming to
fsl_dma_open(), which is called only once.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/fsl/fsl_dma.c |  235 +++++++++++++++++++++++++-----------------------
 1 file changed, 124 insertions(+), 111 deletions(-)

--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -327,14 +327,75 @@ static int fsl_dma_new(struct snd_card *
  * fsl_dma_open: open a new substream.
  *
  * Each substream has its own DMA buffer.
+ *
+ * ALSA divides the DMA buffer into N periods.  We create NUM_DMA_LINKS link
+ * descriptors that ping-pong from one period to the next.  For example, if
+ * there are six periods and two link descriptors, this is how they look
+ * before playback starts:
+ *
+ *      	   The last link descriptor
+ *   ____________  points back to the first
+ *  |   	 |
+ *  V   	 |
+ *  ___    ___   |
+ * |   |->|   |->|
+ * |___|  |___|
+ *   |      |
+ *   |      |
+ *   V      V
+ *  _________________________________________
+ * |      |      |      |      |      |      |  The DMA buffer is
+ * |      |      |      |      |      |      |    divided into 6 parts
+ * |______|______|______|______|______|______|
+ *
+ * and here's how they look after the first period is finished playing:
+ *
+ *   ____________
+ *  |   	 |
+ *  V   	 |
+ *  ___    ___   |
+ * |   |->|   |->|
+ * |___|  |___|
+ *   |      |
+ *   |______________
+ *          |       |
+ *          V       V
+ *  _________________________________________
+ * |      |      |      |      |      |      |
+ * |      |      |      |      |      |      |
+ * |______|______|______|______|______|______|
+ *
+ * The first link descriptor now points to the third period.  The DMA
+ * controller is currently playing the second period.  When it finishes, it
+ * will jump back to the first descriptor and play the third period.
+ *
+ * There are four reasons we do this:
+ *
+ * 1. The only way to get the DMA controller to automatically restart the
+ *    transfer when it gets to the end of the buffer is to use chaining
+ *    mode.  Basic direct mode doesn't offer that feature.
+ * 2. We need to receive an interrupt at the end of every period.  The DMA
+ *    controller can generate an interrupt at the end of every link transfer
+ *    (aka segment).  Making each period into a DMA segment will give us the
+ *    interrupts we need.
+ * 3. By creating only two link descriptors, regardless of the number of
+ *    periods, we do not need to reallocate the link descriptors if the
+ *    number of periods changes.
+ * 4. All of the audio data is still stored in a single, contiguous DMA
+ *    buffer, which is what ALSA expects.  We're just dividing it into
+ *    contiguous parts, and creating a link descriptor for each one.
  */
 static int fsl_dma_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct fsl_dma_private *dma_private;
+	struct ccsr_dma_channel __iomem *dma_channel;
 	dma_addr_t ld_buf_phys;
+	u64 temp_link;  	/* Pointer to next link descriptor */
+	u32 mr;
 	unsigned int channel;
 	int ret = 0;
+	unsigned int i;
 
 	/*
 	 * Reject any DMA buffer whose size is not a multiple of the period
@@ -395,68 +456,74 @@ static int fsl_dma_open(struct snd_pcm_s
 	snd_soc_set_runtime_hwparams(substream, &fsl_dma_hardware);
 	runtime->private_data = dma_private;
 
+	/* Program the fixed DMA controller parameters */
+
+	dma_channel = dma_private->dma_channel;
+
+	temp_link = dma_private->ld_buf_phys +
+		sizeof(struct fsl_dma_link_descriptor);
+
+	for (i = 0; i < NUM_DMA_LINKS; i++) {
+		struct fsl_dma_link_descriptor *link = &dma_private->link[i];
+
+		link->source_attr = cpu_to_be32(CCSR_DMA_ATR_SNOOP);
+		link->dest_attr = cpu_to_be32(CCSR_DMA_ATR_SNOOP);
+		link->next = cpu_to_be64(temp_link);
+
+		temp_link += sizeof(struct fsl_dma_link_descriptor);
+	}
+	/* The last link descriptor points to the first */
+	dma_private->link[i - 1].next = cpu_to_be64(dma_private->ld_buf_phys);
+
+	/* Tell the DMA controller where the first link descriptor is */
+	out_be32(&dma_channel->clndar,
+		CCSR_DMA_CLNDAR_ADDR(dma_private->ld_buf_phys));
+	out_be32(&dma_channel->eclndar,
+		CCSR_DMA_ECLNDAR_ADDR(dma_private->ld_buf_phys));
+
+	/* The manual says the BCR must be clear before enabling EMP */
+	out_be32(&dma_channel->bcr, 0);
+
+	/*
+	 * Program the mode register for interrupts, external master control,
+	 * and source/destination hold.  Also clear the Channel Abort bit.
+	 */
+	mr = in_be32(&dma_channel->mr) &
+		~(CCSR_DMA_MR_CA | CCSR_DMA_MR_DAHE | CCSR_DMA_MR_SAHE);
+
+	/*
+	 * We want External Master Start and External Master Pause enabled,
+	 * because the SSI is controlling the DMA controller.  We want the DMA
+	 * controller to be set up in advance, and then we signal only the SSI
+	 * to start transferring.
+	 *
+	 * We want End-Of-Segment Interrupts enabled, because this will generate
+	 * an interrupt at the end of each segment (each link descriptor
+	 * represents one segment).  Each DMA segment is the same thing as an
+	 * ALSA period, so this is how we get an interrupt at the end of every
+	 * period.
+	 *
+	 * We want Error Interrupt enabled, so that we can get an error if
+	 * the DMA controller is mis-programmed somehow.
+	 */
+	mr |= CCSR_DMA_MR_EOSIE | CCSR_DMA_MR_EIE | CCSR_DMA_MR_EMP_EN |
+		CCSR_DMA_MR_EMS_EN;
+
+	/* For playback, we want the destination address to be held.  For
+	   capture, set the source address to be held. */
+	mr |= (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
+		CCSR_DMA_MR_DAHE : CCSR_DMA_MR_SAHE;
+
+	out_be32(&dma_channel->mr, mr);
+
 	return 0;
 }
 
 /**
- * fsl_dma_hw_params: allocate the DMA buffer and the DMA link descriptors.
- *
- * ALSA divides the DMA buffer into N periods.  We create NUM_DMA_LINKS link
- * descriptors that ping-pong from one period to the next.  For example, if
- * there are six periods and two link descriptors, this is how they look
- * before playback starts:
- *
- *      	   The last link descriptor
- *   ____________  points back to the first
- *  |   	 |
- *  V   	 |
- *  ___    ___   |
- * |   |->|   |->|
- * |___|  |___|
- *   |      |
- *   |      |
- *   V      V
- *  _________________________________________
- * |      |      |      |      |      |      |  The DMA buffer is
- * |      |      |      |      |      |      |    divided into 6 parts
- * |______|______|______|______|______|______|
- *
- * and here's how they look after the first period is finished playing:
- *
- *   ____________
- *  |   	 |
- *  V   	 |
- *  ___    ___   |
- * |   |->|   |->|
- * |___|  |___|
- *   |      |
- *   |______________
- *          |       |
- *          V       V
- *  _________________________________________
- * |      |      |      |      |      |      |
- * |      |      |      |      |      |      |
- * |______|______|______|______|______|______|
+ * fsl_dma_hw_params: continue initializing the DMA links
  *
- * The first link descriptor now points to the third period.  The DMA
- * controller is currently playing the second period.  When it finishes, it
- * will jump back to the first descriptor and play the third period.
- *
- * There are four reasons we do this:
- *
- * 1. The only way to get the DMA controller to automatically restart the
- *    transfer when it gets to the end of the buffer is to use chaining
- *    mode.  Basic direct mode doesn't offer that feature.
- * 2. We need to receive an interrupt at the end of every period.  The DMA
- *    controller can generate an interrupt at the end of every link transfer
- *    (aka segment).  Making each period into a DMA segment will give us the
- *    interrupts we need.
- * 3. By creating only two link descriptors, regardless of the number of
- *    periods, we do not need to reallocate the link descriptors if the
- *    number of periods changes.
- * 4. All of the audio data is still stored in a single, contiguous DMA
- *    buffer, which is what ALSA expects.  We're just dividing it into
- *    contiguous parts, and creating a link descriptor for each one.
+ * This function obtains hardware parameters about the opened stream and
+ * programs the DMA controller accordingly.
  *
  * Note that due to a quirk of the SSI's STX register, the target address
  * for the DMA operations depends on the sample size.  So we don't program
@@ -468,11 +535,8 @@ static int fsl_dma_hw_params(struct snd_
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct fsl_dma_private *dma_private = runtime->private_data;
-	struct ccsr_dma_channel __iomem *dma_channel = dma_private->dma_channel;
 
 	dma_addr_t temp_addr;   /* Pointer to next period */
-	u64 temp_link;  	/* Pointer to next link descriptor */
-	u32 mr; 		/* Temporary variable for MR register */
 
 	unsigned int i;
 
@@ -490,8 +554,6 @@ static int fsl_dma_hw_params(struct snd_
 		dma_private->dma_buf_next = dma_private->dma_buf_phys;
 
 	/*
-	 * Initialize each link descriptor.
-	 *
 	 * The actual address in STX0 (destination for playback, source for
 	 * capture) is based on the sample size, but we don't know the sample
 	 * size in this function, so we'll have to adjust that later.  See
@@ -507,16 +569,11 @@ static int fsl_dma_hw_params(struct snd_
 	 * buffer itself.
 	 */
 	temp_addr = substream->dma_buffer.addr;
-	temp_link = dma_private->ld_buf_phys +
-		sizeof(struct fsl_dma_link_descriptor);
 
 	for (i = 0; i < NUM_DMA_LINKS; i++) {
 		struct fsl_dma_link_descriptor *link = &dma_private->link[i];
 
 		link->count = cpu_to_be32(period_size);
-		link->source_attr = cpu_to_be32(CCSR_DMA_ATR_SNOOP);
-		link->dest_attr = cpu_to_be32(CCSR_DMA_ATR_SNOOP);
-		link->next = cpu_to_be64(temp_link);
 
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 			link->source_addr = cpu_to_be32(temp_addr);
@@ -524,51 +581,7 @@ static int fsl_dma_hw_params(struct snd_
 			link->dest_addr = cpu_to_be32(temp_addr);
 
 		temp_addr += period_size;
-		temp_link += sizeof(struct fsl_dma_link_descriptor);
 	}
-	/* The last link descriptor points to the first */
-	dma_private->link[i - 1].next = cpu_to_be64(dma_private->ld_buf_phys);
-
-	/* Tell the DMA controller where the first link descriptor is */
-	out_be32(&dma_channel->clndar,
-		CCSR_DMA_CLNDAR_ADDR(dma_private->ld_buf_phys));
-	out_be32(&dma_channel->eclndar,
-		CCSR_DMA_ECLNDAR_ADDR(dma_private->ld_buf_phys));
-
-	/* The manual says the BCR must be clear before enabling EMP */
-	out_be32(&dma_channel->bcr, 0);
-
-	/*
-	 * Program the mode register for interrupts, external master control,
-	 * and source/destination hold.  Also clear the Channel Abort bit.
-	 */
-	mr = in_be32(&dma_channel->mr) &
-		~(CCSR_DMA_MR_CA | CCSR_DMA_MR_DAHE | CCSR_DMA_MR_SAHE);
-
-	/*
-	 * We want External Master Start and External Master Pause enabled,
-	 * because the SSI is controlling the DMA controller.  We want the DMA
-	 * controller to be set up in advance, and then we signal only the SSI
-	 * to start transfering.
-	 *
-	 * We want End-Of-Segment Interrupts enabled, because this will generate
-	 * an interrupt at the end of each segment (each link descriptor
-	 * represents one segment).  Each DMA segment is the same thing as an
-	 * ALSA period, so this is how we get an interrupt at the end of every
-	 * period.
-	 *
-	 * We want Error Interrupt enabled, so that we can get an error if
-	 * the DMA controller is mis-programmed somehow.
-	 */
-	mr |= CCSR_DMA_MR_EOSIE | CCSR_DMA_MR_EIE | CCSR_DMA_MR_EMP_EN |
-		CCSR_DMA_MR_EMS_EN;
-
-	/* For playback, we want the destination address to be held.  For
-	   capture, set the source address to be held. */
-	mr |= (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
-		CCSR_DMA_MR_DAHE : CCSR_DMA_MR_SAHE;
-
-	out_be32(&dma_channel->mr, mr);
 
 	return 0;
 }

-- 
