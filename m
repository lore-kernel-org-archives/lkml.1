Return-Path: <linux-kernel-owner+w=401wt.eu-S1758551AbYG0BNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551AbYG0BNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757208AbYG0BN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:13:29 -0400
Received: from mail.suse.de ([195.135.220.2]:42725 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419AbYG0BNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:13:18 -0400
Date: Sun, 27 Jul 2008 03:13:11 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] Add mISDN DSP
Message-ID: <20080727011311.GD3415@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable support for digital audio processing capability.
This module may be used for special applications that require
cross connecting of bchannels, conferencing, dtmf decoding
echo cancelation, tone generation, and Blowfish encryption and
decryption.
It may use hardware features if available.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/Kconfig        |   18 +
 drivers/isdn/mISDN/Makefile       |    2 +
 drivers/isdn/mISDN/dsp.h          |  263 ++++++
 drivers/isdn/mISDN/dsp_audio.c    |  434 +++++++++
 drivers/isdn/mISDN/dsp_biquad.h   |   65 ++
 drivers/isdn/mISDN/dsp_blowfish.c |  672 +++++++++++++
 drivers/isdn/mISDN/dsp_cmx.c      | 1886 +++++++++++++++++++++++++++++++++++++
 drivers/isdn/mISDN/dsp_core.c     | 1191 +++++++++++++++++++++++
 drivers/isdn/mISDN/dsp_dtmf.c     |  303 ++++++
 drivers/isdn/mISDN/dsp_ecdis.h    |  110 +++
 drivers/isdn/mISDN/dsp_hwec.c     |  138 +++
 drivers/isdn/mISDN/dsp_hwec.h     |   10 +
 drivers/isdn/mISDN/dsp_pipeline.c |  348 +++++++
 drivers/isdn/mISDN/dsp_tones.c    |  551 +++++++++++
 include/linux/mISDNdsp.h          |   37 +
 15 files changed, 6028 insertions(+), 0 deletions(-)
 create mode 100644 drivers/isdn/mISDN/dsp.h
 create mode 100644 drivers/isdn/mISDN/dsp_audio.c
 create mode 100644 drivers/isdn/mISDN/dsp_biquad.h
 create mode 100644 drivers/isdn/mISDN/dsp_blowfish.c
 create mode 100644 drivers/isdn/mISDN/dsp_cmx.c
 create mode 100644 drivers/isdn/mISDN/dsp_core.c
 create mode 100644 drivers/isdn/mISDN/dsp_dtmf.c
 create mode 100644 drivers/isdn/mISDN/dsp_ecdis.h
 create mode 100644 drivers/isdn/mISDN/dsp_hwec.c
 create mode 100644 drivers/isdn/mISDN/dsp_hwec.h
 create mode 100644 drivers/isdn/mISDN/dsp_pipeline.c
 create mode 100644 drivers/isdn/mISDN/dsp_tones.c
 create mode 100644 include/linux/mISDNdsp.h

diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index 231bd0d..6a97e86 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -7,3 +7,21 @@ menuconfig MISDN
 	help
 	  Enable support for the modular ISDN driver.
 
+if MISDN != n
+
+config MISDN_DSP
+	tristate "Digital Audio Processing of transparent data"
+	depends on MISDN
+	help
+	  Enable support for digital audio processing capability.
+	  This module may be used for special applications that require
+	  cross connecting of bchannels, conferencing, dtmf decoding
+	  echo cancelation, tone generation, and Blowfish encryption and
+	  decryption.
+	  It may use hardware features if available.
+	  E.g. it is required for PBX4Linux. Go to http://isdn.eversberg.eu
+	  and get more informations about this module and it's usage.
+	  If unsure, say 'N'.
+
+	source "drivers/isdn/hardware/mISDN/Kconfig"
+endif #MISDN
diff --git a/drivers/isdn/mISDN/Makefile b/drivers/isdn/mISDN/Makefile
index 87c563d..7f1a218 100644
--- a/drivers/isdn/mISDN/Makefile
+++ b/drivers/isdn/mISDN/Makefile
@@ -3,7 +3,9 @@
 #
 
 obj-$(CONFIG_MISDN) += mISDN_core.o
+obj-$(CONFIG_MISDN_DSP) += mISDN_dsp.o
 
 # multi objects
 
 mISDN_core-objs := core.o fsm.o socket.o hwchannel.o stack.o layer1.o layer2.o tei.o timerdev.o
+mISDN_dsp-objs := dsp_core.o dsp_cmx.o dsp_tones.o dsp_dtmf.o dsp_audio.o dsp_blowfish.o dsp_pipeline.o dsp_hwec.o
diff --git a/drivers/isdn/mISDN/dsp.h b/drivers/isdn/mISDN/dsp.h
new file mode 100644
index 0000000..6c3fed6
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp.h
@@ -0,0 +1,263 @@
+/*
+ * Audio support data for ISDN4Linux.
+ *
+ * Copyright 2002/2003 by Andreas Eversberg (jolly@eversberg.eu)
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ *
+ */
+
+#define DEBUG_DSP_CTRL		0x0001
+#define DEBUG_DSP_CORE		0x0002
+#define DEBUG_DSP_DTMF		0x0004
+#define DEBUG_DSP_CMX		0x0010
+#define DEBUG_DSP_TONE		0x0020
+#define DEBUG_DSP_BLOWFISH	0x0040
+#define DEBUG_DSP_DELAY		0x0100
+#define DEBUG_DSP_DTMFCOEFF	0x8000 /* heavy output */
+
+/* options may be:
+ *
+ * bit 0 = use ulaw instead of alaw
+ * bit 1 = enable hfc hardware accelleration for all channels
+ *
+ */
+#define DSP_OPT_ULAW		(1<<0)
+#define DSP_OPT_NOHARDWARE	(1<<1)
+
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+
+#include "dsp_ecdis.h"
+
+extern int dsp_options;
+extern int dsp_debug;
+extern int dsp_poll;
+extern int dsp_tics;
+extern spinlock_t dsp_lock;
+extern struct work_struct dsp_workq;
+extern u32 dsp_poll_diff; /* calculated fix-comma corrected poll value */
+
+/***************
+ * audio stuff *
+ ***************/
+
+extern s32 dsp_audio_alaw_to_s32[256];
+extern s32 dsp_audio_ulaw_to_s32[256];
+extern s32 *dsp_audio_law_to_s32;
+extern u8 dsp_audio_s16_to_law[65536];
+extern u8 dsp_audio_alaw_to_ulaw[256];
+extern u8 dsp_audio_mix_law[65536];
+extern u8 dsp_audio_seven2law[128];
+extern u8 dsp_audio_law2seven[256];
+extern void dsp_audio_generate_law_tables(void);
+extern void dsp_audio_generate_s2law_table(void);
+extern void dsp_audio_generate_seven(void);
+extern void dsp_audio_generate_mix_table(void);
+extern void dsp_audio_generate_ulaw_samples(void);
+extern void dsp_audio_generate_volume_changes(void);
+extern u8 dsp_silence;
+
+
+/*************
+ * cmx stuff *
+ *************/
+
+#define MAX_POLL	256	/* maximum number of send-chunks */
+
+#define CMX_BUFF_SIZE	0x8000	/* must be 2**n (0x1000 about 1/2 second) */
+#define CMX_BUFF_HALF	0x4000	/* CMX_BUFF_SIZE / 2 */
+#define CMX_BUFF_MASK	0x7fff	/* CMX_BUFF_SIZE - 1 */
+
+/* how many seconds will we check the lowest delay until the jitter buffer
+   is reduced by that delay */
+#define MAX_SECONDS_JITTER_CHECK 5
+
+extern struct timer_list dsp_spl_tl;
+extern u32 dsp_spl_jiffies;
+
+/* the structure of conferences:
+ *
+ * each conference has a unique number, given by user space.
+ * the conferences are linked in a chain.
+ * each conference has members linked in a chain.
+ * each dsplayer points to a member, each member points to a dsplayer.
+ */
+
+/* all members within a conference (this is linked 1:1 with the dsp) */
+struct dsp;
+struct dsp_conf_member {
+	struct list_head	list;
+	struct dsp		*dsp;
+};
+
+/* the list of all conferences */
+struct dsp_conf {
+	struct list_head	list;
+	u32			id;
+				/* all cmx stacks with the same ID are
+				 connected */
+	struct list_head	mlist;
+	int			software; /* conf is processed by software */
+	int			hardware; /* conf is processed by hardware */
+				/* note: if both unset, has only one member */
+};
+
+
+/**************
+ * DTMF stuff *
+ **************/
+
+#define DSP_DTMF_NPOINTS 102
+
+#define ECHOCAN_BUFLEN (4*128)
+
+struct dsp_dtmf {
+	int		treshold; /* above this is dtmf (square of) */
+	int		software; /* dtmf uses software decoding */
+	int		hardware; /* dtmf uses hardware decoding */
+	int		size; /* number of bytes in buffer */
+	signed short	buffer[DSP_DTMF_NPOINTS];
+		/* buffers one full dtmf frame */
+	u8		lastwhat, lastdigit;
+	int		count;
+	u8		digits[16]; /* just the dtmf result */
+};
+
+
+/******************
+ * pipeline stuff *
+ ******************/
+struct dsp_pipeline {
+	rwlock_t  lock;
+	struct list_head list;
+	int inuse;
+};
+
+/***************
+ * tones stuff *
+ ***************/
+
+struct dsp_tone {
+	int		software; /* tones are generated by software */
+	int		hardware; /* tones are generated by hardware */
+	int		tone;
+	void		*pattern;
+	int		count;
+	int		index;
+	struct timer_list tl;
+};
+
+/*****************
+ * general stuff *
+ *****************/
+
+struct dsp {
+	struct list_head list;
+	struct mISDNchannel	ch;
+	struct mISDNchannel	*up;
+	unsigned char	name[64];
+	int		b_active;
+	int		echo; /* echo is enabled */
+	int		rx_disabled; /* what the user wants */
+	int		rx_is_off; /* what the card is */
+	int		tx_mix;
+	struct dsp_tone	tone;
+	struct dsp_dtmf	dtmf;
+	int		tx_volume, rx_volume;
+
+	/* queue for sending frames */
+	struct work_struct	workq;
+	struct sk_buff_head	sendq;
+	int		hdlc;	/* if mode is hdlc */
+	int		data_pending;	/* currently an unconfirmed frame */
+
+	/* conference stuff */
+	u32		conf_id;
+	struct dsp_conf	*conf;
+	struct dsp_conf_member
+			*member;
+
+	/* buffer stuff */
+	int		rx_W; /* current write pos for data without timestamp */
+	int		rx_R; /* current read pos for transmit clock */
+	int		rx_init; /* if set, pointers will be adjusted first */
+	int		tx_W; /* current write pos for transmit data */
+	int		tx_R; /* current read pos for transmit clock */
+	int		rx_delay[MAX_SECONDS_JITTER_CHECK];
+	int		tx_delay[MAX_SECONDS_JITTER_CHECK];
+	u8		tx_buff[CMX_BUFF_SIZE];
+	u8		rx_buff[CMX_BUFF_SIZE];
+	int		last_tx; /* if set, we transmitted last poll interval */
+	int		cmx_delay; /* initial delay of buffers,
+				or 0 for dynamic jitter buffer */
+	int		tx_dejitter; /* if set, dejitter tx buffer */
+	int		tx_data; /* enables tx-data of CMX to upper layer */
+
+	/* hardware stuff */
+	struct dsp_features features;
+	int		features_rx_off; /* set if rx_off is featured */
+	int		pcm_slot_rx; /* current PCM slot (or -1) */
+	int		pcm_bank_rx;
+	int		pcm_slot_tx;
+	int		pcm_bank_tx;
+	int		hfc_conf; /* unique id of current conference (or -1) */
+
+	/* encryption stuff */
+	int		bf_enable;
+	u32		bf_p[18];
+	u32		bf_s[1024];
+	int		bf_crypt_pos;
+	u8		bf_data_in[9];
+	u8		bf_crypt_out[9];
+	int		bf_decrypt_in_pos;
+	int		bf_decrypt_out_pos;
+	u8		bf_crypt_inring[16];
+	u8		bf_data_out[9];
+	int		bf_sync;
+
+	struct dsp_pipeline
+			pipeline;
+};
+
+/* functions */
+
+extern void dsp_change_volume(struct sk_buff *skb, int volume);
+
+extern struct list_head dsp_ilist;
+extern struct list_head conf_ilist;
+extern void dsp_cmx_debug(struct dsp *dsp);
+extern void dsp_cmx_hardware(struct dsp_conf *conf, struct dsp *dsp);
+extern int dsp_cmx_conf(struct dsp *dsp, u32 conf_id);
+extern void dsp_cmx_receive(struct dsp *dsp, struct sk_buff *skb);
+extern void dsp_cmx_hdlc(struct dsp *dsp, struct sk_buff *skb);
+extern void dsp_cmx_send(void *arg);
+extern void dsp_cmx_transmit(struct dsp *dsp, struct sk_buff *skb);
+extern int dsp_cmx_del_conf_member(struct dsp *dsp);
+extern int dsp_cmx_del_conf(struct dsp_conf *conf);
+
+extern void dsp_dtmf_goertzel_init(struct dsp *dsp);
+extern void dsp_dtmf_hardware(struct dsp *dsp);
+extern u8 *dsp_dtmf_goertzel_decode(struct dsp *dsp, u8 *data, int len,
+		int fmt);
+
+extern int dsp_tone(struct dsp *dsp, int tone);
+extern void dsp_tone_copy(struct dsp *dsp, u8 *data, int len);
+extern void dsp_tone_timeout(void *arg);
+
+extern void dsp_bf_encrypt(struct dsp *dsp, u8 *data, int len);
+extern void dsp_bf_decrypt(struct dsp *dsp, u8 *data, int len);
+extern int dsp_bf_init(struct dsp *dsp, const u8 *key, unsigned int keylen);
+extern void dsp_bf_cleanup(struct dsp *dsp);
+
+extern int  dsp_pipeline_module_init(void);
+extern void dsp_pipeline_module_exit(void);
+extern int  dsp_pipeline_init(struct dsp_pipeline *pipeline);
+extern void dsp_pipeline_destroy(struct dsp_pipeline *pipeline);
+extern int  dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg);
+extern void dsp_pipeline_process_tx(struct dsp_pipeline *pipeline, u8 *data,
+		int len);
+extern void dsp_pipeline_process_rx(struct dsp_pipeline *pipeline, u8 *data,
+		int len);
+
diff --git a/drivers/isdn/mISDN/dsp_audio.c b/drivers/isdn/mISDN/dsp_audio.c
new file mode 100644
index 0000000..1c2dd56
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_audio.c
@@ -0,0 +1,434 @@
+/*
+ * Audio support data for mISDN_dsp.
+ *
+ * Copyright 2002/2003 by Andreas Eversberg (jolly@eversberg.eu)
+ * Rewritten by Peter
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/mISDNif.h>
+#include <linux/mISDNdsp.h>
+#include "core.h"
+#include "dsp.h"
+
+/* ulaw[unsigned char] -> signed 16-bit */
+s32 dsp_audio_ulaw_to_s32[256];
+/* alaw[unsigned char] -> signed 16-bit */
+s32 dsp_audio_alaw_to_s32[256];
+
+s32 *dsp_audio_law_to_s32;
+EXPORT_SYMBOL(dsp_audio_law_to_s32);
+
+/* signed 16-bit -> law */
+u8 dsp_audio_s16_to_law[65536];
+EXPORT_SYMBOL(dsp_audio_s16_to_law);
+
+/* alaw -> ulaw */
+u8 dsp_audio_alaw_to_ulaw[256];
+/* ulaw -> alaw */
+u8 dsp_audio_ulaw_to_alaw[256];
+u8 dsp_silence;
+
+
+/*****************************************************
+ * generate table for conversion of s16 to alaw/ulaw *
+ *****************************************************/
+
+#define AMI_MASK 0x55
+
+static inline unsigned char linear2alaw(short int linear)
+{
+	int mask;
+	int seg;
+	int pcm_val;
+	static int seg_end[8] = {
+		0xFF, 0x1FF, 0x3FF, 0x7FF, 0xFFF, 0x1FFF, 0x3FFF, 0x7FFF
+	};
+
+	pcm_val = linear;
+	if (pcm_val >= 0) {
+		/* Sign (7th) bit = 1 */
+		mask = AMI_MASK | 0x80;
+	} else {
+		/* Sign bit = 0 */
+		mask = AMI_MASK;
+		pcm_val = -pcm_val;
+	}
+
+	/* Convert the scaled magnitude to segment number. */
+	for (seg = 0;  seg < 8;  seg++) {
+		if (pcm_val <= seg_end[seg])
+			break;
+	}
+	/* Combine the sign, segment, and quantization bits. */
+	return  ((seg << 4) |
+		 ((pcm_val >> ((seg)  ?  (seg + 3)  :  4)) & 0x0F)) ^ mask;
+}
+
+
+static inline short int alaw2linear(unsigned char alaw)
+{
+	int i;
+	int seg;
+
+	alaw ^= AMI_MASK;
+	i = ((alaw & 0x0F) << 4) + 8 /* rounding error */;
+	seg = (((int) alaw & 0x70) >> 4);
+	if (seg)
+		i = (i + 0x100) << (seg - 1);
+	return (short int) ((alaw & 0x80)  ?  i  :  -i);
+}
+
+static inline short int ulaw2linear(unsigned char ulaw)
+{
+	short mu, e, f, y;
+	static short etab[] = {0, 132, 396, 924, 1980, 4092, 8316, 16764};
+
+	mu = 255 - ulaw;
+	e = (mu & 0x70) / 16;
+	f = mu & 0x0f;
+	y = f * (1 << (e + 3));
+	y += etab[e];
+	if (mu & 0x80)
+		y = -y;
+	return y;
+}
+
+#define BIAS 0x84   /*!< define the add-in bias for 16 bit samples */
+
+static unsigned char linear2ulaw(short sample)
+{
+	static int exp_lut[256] = {
+		0, 0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3,
+		4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
+		5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
+		5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
+		6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+		6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+		6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+		6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7};
+	int sign, exponent, mantissa;
+	unsigned char ulawbyte;
+
+	/* Get the sample into sign-magnitude. */
+	sign = (sample >> 8) & 0x80;	  /* set aside the sign */
+	if (sign != 0)
+		sample = -sample;	      /* get magnitude */
+
+	/* Convert from 16 bit linear to ulaw. */
+	sample = sample + BIAS;
+	exponent = exp_lut[(sample >> 7) & 0xFF];
+	mantissa = (sample >> (exponent + 3)) & 0x0F;
+	ulawbyte = ~(sign | (exponent << 4) | mantissa);
+
+	return ulawbyte;
+}
+
+static int reverse_bits(int i)
+{
+	int z, j;
+	z = 0;
+
+	for (j = 0; j < 8; j++) {
+		if ((i & (1 << j)) != 0)
+			z |= 1 << (7 - j);
+	}
+	return z;
+}
+
+
+void dsp_audio_generate_law_tables(void)
+{
+	int i;
+	for (i = 0; i < 256; i++)
+		dsp_audio_alaw_to_s32[i] = alaw2linear(reverse_bits(i));
+
+	for (i = 0; i < 256; i++)
+		dsp_audio_ulaw_to_s32[i] = ulaw2linear(reverse_bits(i));
+
+	for (i = 0; i < 256; i++) {
+		dsp_audio_alaw_to_ulaw[i] =
+			linear2ulaw(dsp_audio_alaw_to_s32[i]);
+		dsp_audio_ulaw_to_alaw[i] =
+			linear2alaw(dsp_audio_ulaw_to_s32[i]);
+	}
+}
+
+void
+dsp_audio_generate_s2law_table(void)
+{
+	int i;
+
+	if (dsp_options & DSP_OPT_ULAW) {
+		/* generating ulaw-table */
+		for (i = -32768; i < 32768; i++) {
+			dsp_audio_s16_to_law[i & 0xffff] =
+				reverse_bits(linear2ulaw(i));
+		}
+	} else {
+		/* generating alaw-table */
+		for (i = -32768; i < 32768; i++) {
+			dsp_audio_s16_to_law[i & 0xffff] =
+				reverse_bits(linear2alaw(i));
+		}
+	}
+}
+
+
+/*
+ * the seven bit sample is the number of every second alaw-sample ordered by
+ * aplitude. 0x00 is negative, 0x7f is positive amplitude.
+ */
+u8 dsp_audio_seven2law[128];
+u8 dsp_audio_law2seven[256];
+
+/********************************************************************
+ * generate table for conversion law from/to 7-bit alaw-like sample *
+ ********************************************************************/
+
+void
+dsp_audio_generate_seven(void)
+{
+	int i, j, k;
+	u8 spl;
+	u8 sorted_alaw[256];
+
+	/* generate alaw table, sorted by the linear value */
+	for (i = 0; i < 256; i++) {
+		j = 0;
+		for (k = 0; k < 256; k++) {
+			if (dsp_audio_alaw_to_s32[k]
+				< dsp_audio_alaw_to_s32[i]) {
+			j++;
+			}
+		}
+		sorted_alaw[j] = i;
+	}
+
+	/* generate tabels */
+	for (i = 0; i < 256; i++) {
+		/* spl is the source: the law-sample (converted to alaw) */
+		spl = i;
+		if (dsp_options & DSP_OPT_ULAW)
+			spl = dsp_audio_ulaw_to_alaw[i];
+		/* find the 7-bit-sample */
+		for (j = 0; j < 256; j++) {
+			if (sorted_alaw[j] == spl)
+				break;
+		}
+		/* write 7-bit audio value */
+		dsp_audio_law2seven[i] = j >> 1;
+	}
+	for (i = 0; i < 128; i++) {
+		spl = sorted_alaw[i << 1];
+		if (dsp_options & DSP_OPT_ULAW)
+			spl = dsp_audio_alaw_to_ulaw[spl];
+		dsp_audio_seven2law[i] = spl;
+	}
+}
+
+
+/* mix 2*law -> law */
+u8 dsp_audio_mix_law[65536];
+
+/******************************************************
+ * generate mix table to mix two law samples into one *
+ ******************************************************/
+
+void
+dsp_audio_generate_mix_table(void)
+{
+	int i, j;
+	s32 sample;
+
+	i = 0;
+	while (i < 256) {
+		j = 0;
+		while (j < 256) {
+			sample = dsp_audio_law_to_s32[i];
+			sample += dsp_audio_law_to_s32[j];
+			if (sample > 32767)
+				sample = 32767;
+			if (sample < -32768)
+				sample = -32768;
+			dsp_audio_mix_law[(i<<8)|j] =
+				dsp_audio_s16_to_law[sample & 0xffff];
+			j++;
+		}
+		i++;
+	}
+}
+
+
+/*************************************
+ * generate different volume changes *
+ *************************************/
+
+static u8 dsp_audio_reduce8[256];
+static u8 dsp_audio_reduce7[256];
+static u8 dsp_audio_reduce6[256];
+static u8 dsp_audio_reduce5[256];
+static u8 dsp_audio_reduce4[256];
+static u8 dsp_audio_reduce3[256];
+static u8 dsp_audio_reduce2[256];
+static u8 dsp_audio_reduce1[256];
+static u8 dsp_audio_increase1[256];
+static u8 dsp_audio_increase2[256];
+static u8 dsp_audio_increase3[256];
+static u8 dsp_audio_increase4[256];
+static u8 dsp_audio_increase5[256];
+static u8 dsp_audio_increase6[256];
+static u8 dsp_audio_increase7[256];
+static u8 dsp_audio_increase8[256];
+
+static u8 *dsp_audio_volume_change[16] = {
+	dsp_audio_reduce8,
+	dsp_audio_reduce7,
+	dsp_audio_reduce6,
+	dsp_audio_reduce5,
+	dsp_audio_reduce4,
+	dsp_audio_reduce3,
+	dsp_audio_reduce2,
+	dsp_audio_reduce1,
+	dsp_audio_increase1,
+	dsp_audio_increase2,
+	dsp_audio_increase3,
+	dsp_audio_increase4,
+	dsp_audio_increase5,
+	dsp_audio_increase6,
+	dsp_audio_increase7,
+	dsp_audio_increase8,
+};
+
+void
+dsp_audio_generate_volume_changes(void)
+{
+	register s32 sample;
+	int i;
+	int num[]   = { 110, 125, 150, 175, 200, 300, 400, 500 };
+	int denum[] = { 100, 100, 100, 100, 100, 100, 100, 100 };
+
+	i = 0;
+	while (i < 256) {
+		dsp_audio_reduce8[i] = dsp_audio_s16_to_law[
+			(dsp_audio_law_to_s32[i] * denum[7] / num[7]) & 0xffff];
+		dsp_audio_reduce7[i] = dsp_audio_s16_to_law[
+			(dsp_audio_law_to_s32[i] * denum[6] / num[6]) & 0xffff];
+		dsp_audio_reduce6[i] = dsp_audio_s16_to_law[
+			(dsp_audio_law_to_s32[i] * denum[5] / num[5]) & 0xffff];
+		dsp_audio_reduce5[i] = dsp_audio_s16_to_law[
+			(dsp_audio_law_to_s32[i] * denum[4] / num[4]) & 0xffff];
+		dsp_audio_reduce4[i] = dsp_audio_s16_to_law[
+			(dsp_audio_law_to_s32[i] * denum[3] / num[3]) & 0xffff];
+		dsp_audio_reduce3[i] = dsp_audio_s16_to_law[
+			(dsp_audio_law_to_s32[i] * denum[2] / num[2]) & 0xffff];
+		dsp_audio_reduce2[i] = dsp_audio_s16_to_law[
+			(dsp_audio_law_to_s32[i] * denum[1] / num[1]) & 0xffff];
+		dsp_audio_reduce1[i] = dsp_audio_s16_to_law[
+			(dsp_audio_law_to_s32[i] * denum[0] / num[0]) & 0xffff];
+		sample = dsp_audio_law_to_s32[i] * num[0] / denum[0];
+		if (sample < -32768)
+			sample = -32768;
+		else if (sample > 32767)
+			sample = 32767;
+		dsp_audio_increase1[i] = dsp_audio_s16_to_law[sample & 0xffff];
+		sample = dsp_audio_law_to_s32[i] * num[1] / denum[1];
+		if (sample < -32768)
+			sample = -32768;
+		else if (sample > 32767)
+			sample = 32767;
+		dsp_audio_increase2[i] = dsp_audio_s16_to_law[sample & 0xffff];
+		sample = dsp_audio_law_to_s32[i] * num[2] / denum[2];
+		if (sample < -32768)
+			sample = -32768;
+		else if (sample > 32767)
+			sample = 32767;
+		dsp_audio_increase3[i] = dsp_audio_s16_to_law[sample & 0xffff];
+		sample = dsp_audio_law_to_s32[i] * num[3] / denum[3];
+		if (sample < -32768)
+			sample = -32768;
+		else if (sample > 32767)
+			sample = 32767;
+		dsp_audio_increase4[i] = dsp_audio_s16_to_law[sample & 0xffff];
+		sample = dsp_audio_law_to_s32[i] * num[4] / denum[4];
+		if (sample < -32768)
+			sample = -32768;
+		else if (sample > 32767)
+			sample = 32767;
+		dsp_audio_increase5[i] = dsp_audio_s16_to_law[sample & 0xffff];
+		sample = dsp_audio_law_to_s32[i] * num[5] / denum[5];
+		if (sample < -32768)
+			sample = -32768;
+		else if (sample > 32767)
+			sample = 32767;
+		dsp_audio_increase6[i] = dsp_audio_s16_to_law[sample & 0xffff];
+		sample = dsp_audio_law_to_s32[i] * num[6] / denum[6];
+		if (sample < -32768)
+			sample = -32768;
+		else if (sample > 32767)
+			sample = 32767;
+		dsp_audio_increase7[i] = dsp_audio_s16_to_law[sample & 0xffff];
+		sample = dsp_audio_law_to_s32[i] * num[7] / denum[7];
+		if (sample < -32768)
+			sample = -32768;
+		else if (sample > 32767)
+			sample = 32767;
+		dsp_audio_increase8[i] = dsp_audio_s16_to_law[sample & 0xffff];
+
+		i++;
+	}
+}
+
+
+/**************************************
+ * change the volume of the given skb *
+ **************************************/
+
+/* this is a helper function for changing volume of skb. the range may be
+ * -8 to 8, which is a shift to the power of 2. 0 == no volume, 3 == volume*8
+ */
+void
+dsp_change_volume(struct sk_buff *skb, int volume)
+{
+	u8 *volume_change;
+	int i, ii;
+	u8 *p;
+	int shift;
+
+	if (volume == 0)
+		return;
+
+	/* get correct conversion table */
+	if (volume < 0) {
+		shift = volume + 8;
+		if (shift < 0)
+			shift = 0;
+	} else {
+		shift = volume + 7;
+		if (shift > 15)
+			shift = 15;
+	}
+	volume_change = dsp_audio_volume_change[shift];
+	i = 0;
+	ii = skb->len;
+	p = skb->data;
+	/* change volume */
+	while (i < ii) {
+		*p = volume_change[*p];
+		p++;
+		i++;
+	}
+}
+
diff --git a/drivers/isdn/mISDN/dsp_biquad.h b/drivers/isdn/mISDN/dsp_biquad.h
new file mode 100644
index 0000000..038191b
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_biquad.h
@@ -0,0 +1,65 @@
+/*
+ * SpanDSP - a series of DSP components for telephony
+ *
+ * biquad.h - General telephony bi-quad section routines (currently this just
+ *            handles canonic/type 2 form)
+ *
+ * Written by Steve Underwood <steveu@coppice.org>
+ *
+ * Copyright (C) 2001 Steve Underwood
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+struct biquad2_state {
+	int32_t gain;
+	int32_t a1;
+	int32_t a2;
+	int32_t b1;
+	int32_t b2;
+
+	int32_t z1;
+	int32_t z2;
+};
+
+static inline void biquad2_init(struct biquad2_state *bq,
+    int32_t gain, int32_t a1, int32_t a2, int32_t b1, int32_t b2)
+{
+	bq->gain = gain;
+	bq->a1 = a1;
+	bq->a2 = a2;
+	bq->b1 = b1;
+	bq->b2 = b2;
+
+	bq->z1 = 0;
+	bq->z2 = 0;
+}
+
+static inline int16_t biquad2(struct biquad2_state *bq, int16_t sample)
+{
+	int32_t y;
+	int32_t z0;
+
+	z0 = sample*bq->gain + bq->z1*bq->a1 + bq->z2*bq->a2;
+	y = z0 + bq->z1*bq->b1 + bq->z2*bq->b2;
+
+	bq->z2 = bq->z1;
+	bq->z1 = z0 >> 15;
+	y >>= 15;
+	return  y;
+}
diff --git a/drivers/isdn/mISDN/dsp_blowfish.c b/drivers/isdn/mISDN/dsp_blowfish.c
new file mode 100644
index 0000000..18e411e
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_blowfish.c
@@ -0,0 +1,672 @@
+/*
+ * Blowfish encryption/decryption for mISDN_dsp.
+ *
+ * Copyright Andreas Eversberg (jolly@eversberg.eu)
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ *
+ */
+
+#include <linux/mISDNif.h>
+#include <linux/mISDNdsp.h>
+#include "core.h"
+#include "dsp.h"
+
+/*
+ * how to encode a sample stream to 64-bit blocks that will be encryped
+ *
+ * first of all, data is collected until a block of 9 samples are received.
+ * of course, a packet may have much more than 9 sample, but is may have
+ * not excacly the multiple of 9 samples. if there is a rest, the next
+ * received data will complete the block.
+ *
+ * the block is then converted to 9 uLAW samples without the least sigificant
+ * bit. the result is a 7-bit encoded sample.
+ *
+ * the samples will be reoganised to form 8 bytes of data:
+ * (5(6) means: encoded sample no. 5, bit 6)
+ *
+ * 0(6) 0(5) 0(4) 0(3) 0(2) 0(1) 0(0) 1(6)
+ * 1(5) 1(4) 1(3) 1(2) 1(1) 1(0) 2(6) 2(5)
+ * 2(4) 2(3) 2(2) 2(1) 2(0) 3(6) 3(5) 3(4)
+ * 3(3) 3(2) 3(1) 3(0) 4(6) 4(5) 4(4) 4(3)
+ * 4(2) 4(1) 4(0) 5(6) 5(5) 5(4) 5(3) 5(2)
+ * 5(1) 5(0) 6(6) 6(5) 6(4) 6(3) 6(2) 6(1)
+ * 6(0) 7(6) 7(5) 7(4) 7(3) 7(2) 7(1) 7(0)
+ * 8(6) 8(5) 8(4) 8(3) 8(2) 8(1) 8(0)
+ *
+ * the missing bit 0 of the last byte is filled with some
+ * random noise, to fill all 8 bytes.
+ *
+ * the 8 bytes will be encrypted using blowfish.
+ *
+ * the result will be converted into 9 bytes. the bit 7 is used for
+ * checksumme (CS) for sync (0, 1) and for the last bit:
+ * (5(6) means: crypted byte 5, bit 6)
+ *
+ * 1    0(7) 0(6) 0(5) 0(4) 0(3) 0(2) 0(1)
+ * 0    0(0) 1(7) 1(6) 1(5) 1(4) 1(3) 1(2)
+ * 0    1(1) 1(0) 2(7) 2(6) 2(5) 2(4) 2(3)
+ * 0    2(2) 2(1) 2(0) 3(7) 3(6) 3(5) 3(4)
+ * 0    3(3) 3(2) 3(1) 3(0) 4(7) 4(6) 4(5)
+ * CS   4(4) 4(3) 4(2) 4(1) 4(0) 5(7) 5(6)
+ * CS   5(5) 5(4) 5(3) 5(2) 5(1) 5(0) 6(7)
+ * CS   6(6) 6(5) 6(4) 6(3) 6(2) 6(1) 6(0)
+ * 7(0) 7(6) 7(5) 7(4) 7(3) 7(2) 7(1) 7(0)
+ *
+ * the checksum is used to detect transmission errors and frame drops.
+ *
+ * synchronisation of received block is done by shifting the upper bit of each
+ * byte (bit 7) to a shift register. if the rigister has the first five bits
+ * (10000), this is used to find the sync. only if sync has been found, the
+ * current block of 9 received bytes are decrypted. before that the check
+ * sum is calculated. if it is incorrect the block is dropped.
+ * this will avoid loud noise due to corrupt encrypted data.
+ *
+ * if the last block is corrupt, the current decoded block is repeated
+ * until a valid block has been received.
+ */
+
+/*
+ *  some blowfish parts are taken from the
+ * crypto-api for faster implementation
+ */
+
+struct bf_ctx {
+	u32 p[18];
+	u32 s[1024];
+};
+
+static const u32 bf_pbox[16 + 2] = {
+	0x243f6a88, 0x85a308d3, 0x13198a2e, 0x03707344,
+	0xa4093822, 0x299f31d0, 0x082efa98, 0xec4e6c89,
+	0x452821e6, 0x38d01377, 0xbe5466cf, 0x34e90c6c,
+	0xc0ac29b7, 0xc97c50dd, 0x3f84d5b5, 0xb5470917,
+	0x9216d5d9, 0x8979fb1b,
+};
+
+static const u32 bf_sbox[256 * 4] = {
+	0xd1310ba6, 0x98dfb5ac, 0x2ffd72db, 0xd01adfb7,
+	0xb8e1afed, 0x6a267e96, 0xba7c9045, 0xf12c7f99,
+	0x24a19947, 0xb3916cf7, 0x0801f2e2, 0x858efc16,
+	0x636920d8, 0x71574e69, 0xa458fea3, 0xf4933d7e,
+	0x0d95748f, 0x728eb658, 0x718bcd58, 0x82154aee,
+	0x7b54a41d, 0xc25a59b5, 0x9c30d539, 0x2af26013,
+	0xc5d1b023, 0x286085f0, 0xca417918, 0xb8db38ef,
+	0x8e79dcb0, 0x603a180e, 0x6c9e0e8b, 0xb01e8a3e,
+	0xd71577c1, 0xbd314b27, 0x78af2fda, 0x55605c60,
+	0xe65525f3, 0xaa55ab94, 0x57489862, 0x63e81440,
+	0x55ca396a, 0x2aab10b6, 0xb4cc5c34, 0x1141e8ce,
+	0xa15486af, 0x7c72e993, 0xb3ee1411, 0x636fbc2a,
+	0x2ba9c55d, 0x741831f6, 0xce5c3e16, 0x9b87931e,
+	0xafd6ba33, 0x6c24cf5c, 0x7a325381, 0x28958677,
+	0x3b8f4898, 0x6b4bb9af, 0xc4bfe81b, 0x66282193,
+	0x61d809cc, 0xfb21a991, 0x487cac60, 0x5dec8032,
+	0xef845d5d, 0xe98575b1, 0xdc262302, 0xeb651b88,
+	0x23893e81, 0xd396acc5, 0x0f6d6ff3, 0x83f44239,
+	0x2e0b4482, 0xa4842004, 0x69c8f04a, 0x9e1f9b5e,
+	0x21c66842, 0xf6e96c9a, 0x670c9c61, 0xabd388f0,
+	0x6a51a0d2, 0xd8542f68, 0x960fa728, 0xab5133a3,
+	0x6eef0b6c, 0x137a3be4, 0xba3bf050, 0x7efb2a98,
+	0xa1f1651d, 0x39af0176, 0x66ca593e, 0x82430e88,
+	0x8cee8619, 0x456f9fb4, 0x7d84a5c3, 0x3b8b5ebe,
+	0xe06f75d8, 0x85c12073, 0x401a449f, 0x56c16aa6,
+	0x4ed3aa62, 0x363f7706, 0x1bfedf72, 0x429b023d,
+	0x37d0d724, 0xd00a1248, 0xdb0fead3, 0x49f1c09b,
+	0x075372c9, 0x80991b7b, 0x25d479d8, 0xf6e8def7,
+	0xe3fe501a, 0xb6794c3b, 0x976ce0bd, 0x04c006ba,
+	0xc1a94fb6, 0x409f60c4, 0x5e5c9ec2, 0x196a2463,
+	0x68fb6faf, 0x3e6c53b5, 0x1339b2eb, 0x3b52ec6f,
+	0x6dfc511f, 0x9b30952c, 0xcc814544, 0xaf5ebd09,
+	0xbee3d004, 0xde334afd, 0x660f2807, 0x192e4bb3,
+	0xc0cba857, 0x45c8740f, 0xd20b5f39, 0xb9d3fbdb,
+	0x5579c0bd, 0x1a60320a, 0xd6a100c6, 0x402c7279,
+	0x679f25fe, 0xfb1fa3cc, 0x8ea5e9f8, 0xdb3222f8,
+	0x3c7516df, 0xfd616b15, 0x2f501ec8, 0xad0552ab,
+	0x323db5fa, 0xfd238760, 0x53317b48, 0x3e00df82,
+	0x9e5c57bb, 0xca6f8ca0, 0x1a87562e, 0xdf1769db,
+	0xd542a8f6, 0x287effc3, 0xac6732c6, 0x8c4f5573,
+	0x695b27b0, 0xbbca58c8, 0xe1ffa35d, 0xb8f011a0,
+	0x10fa3d98, 0xfd2183b8, 0x4afcb56c, 0x2dd1d35b,
+	0x9a53e479, 0xb6f84565, 0xd28e49bc, 0x4bfb9790,
+	0xe1ddf2da, 0xa4cb7e33, 0x62fb1341, 0xcee4c6e8,
+	0xef20cada, 0x36774c01, 0xd07e9efe, 0x2bf11fb4,
+	0x95dbda4d, 0xae909198, 0xeaad8e71, 0x6b93d5a0,
+	0xd08ed1d0, 0xafc725e0, 0x8e3c5b2f, 0x8e7594b7,
+	0x8ff6e2fb, 0xf2122b64, 0x8888b812, 0x900df01c,
+	0x4fad5ea0, 0x688fc31c, 0xd1cff191, 0xb3a8c1ad,
+	0x2f2f2218, 0xbe0e1777, 0xea752dfe, 0x8b021fa1,
+	0xe5a0cc0f, 0xb56f74e8, 0x18acf3d6, 0xce89e299,
+	0xb4a84fe0, 0xfd13e0b7, 0x7cc43b81, 0xd2ada8d9,
+	0x165fa266, 0x80957705, 0x93cc7314, 0x211a1477,
+	0xe6ad2065, 0x77b5fa86, 0xc75442f5, 0xfb9d35cf,
+	0xebcdaf0c, 0x7b3e89a0, 0xd6411bd3, 0xae1e7e49,
+	0x00250e2d, 0x2071b35e, 0x226800bb, 0x57b8e0af,
+	0x2464369b, 0xf009b91e, 0x5563911d, 0x59dfa6aa,
+	0x78c14389, 0xd95a537f, 0x207d5ba2, 0x02e5b9c5,
+	0x83260376, 0x6295cfa9, 0x11c81968, 0x4e734a41,
+	0xb3472dca, 0x7b14a94a, 0x1b510052, 0x9a532915,
+	0xd60f573f, 0xbc9bc6e4, 0x2b60a476, 0x81e67400,
+	0x08ba6fb5, 0x571be91f, 0xf296ec6b, 0x2a0dd915,
+	0xb6636521, 0xe7b9f9b6, 0xff34052e, 0xc5855664,
+	0x53b02d5d, 0xa99f8fa1, 0x08ba4799, 0x6e85076a,
+	0x4b7a70e9, 0xb5b32944, 0xdb75092e, 0xc4192623,
+	0xad6ea6b0, 0x49a7df7d, 0x9cee60b8, 0x8fedb266,
+	0xecaa8c71, 0x699a17ff, 0x5664526c, 0xc2b19ee1,
+	0x193602a5, 0x75094c29, 0xa0591340, 0xe4183a3e,
+	0x3f54989a, 0x5b429d65, 0x6b8fe4d6, 0x99f73fd6,
+	0xa1d29c07, 0xefe830f5, 0x4d2d38e6, 0xf0255dc1,
+	0x4cdd2086, 0x8470eb26, 0x6382e9c6, 0x021ecc5e,
+	0x09686b3f, 0x3ebaefc9, 0x3c971814, 0x6b6a70a1,
+	0x687f3584, 0x52a0e286, 0xb79c5305, 0xaa500737,
+	0x3e07841c, 0x7fdeae5c, 0x8e7d44ec, 0x5716f2b8,
+	0xb03ada37, 0xf0500c0d, 0xf01c1f04, 0x0200b3ff,
+	0xae0cf51a, 0x3cb574b2, 0x25837a58, 0xdc0921bd,
+	0xd19113f9, 0x7ca92ff6, 0x94324773, 0x22f54701,
+	0x3ae5e581, 0x37c2dadc, 0xc8b57634, 0x9af3dda7,
+	0xa9446146, 0x0fd0030e, 0xecc8c73e, 0xa4751e41,
+	0xe238cd99, 0x3bea0e2f, 0x3280bba1, 0x183eb331,
+	0x4e548b38, 0x4f6db908, 0x6f420d03, 0xf60a04bf,
+	0x2cb81290, 0x24977c79, 0x5679b072, 0xbcaf89af,
+	0xde9a771f, 0xd9930810, 0xb38bae12, 0xdccf3f2e,
+	0x5512721f, 0x2e6b7124, 0x501adde6, 0x9f84cd87,
+	0x7a584718, 0x7408da17, 0xbc9f9abc, 0xe94b7d8c,
+	0xec7aec3a, 0xdb851dfa, 0x63094366, 0xc464c3d2,
+	0xef1c1847, 0x3215d908, 0xdd433b37, 0x24c2ba16,
+	0x12a14d43, 0x2a65c451, 0x50940002, 0x133ae4dd,
+	0x71dff89e, 0x10314e55, 0x81ac77d6, 0x5f11199b,
+	0x043556f1, 0xd7a3c76b, 0x3c11183b, 0x5924a509,
+	0xf28fe6ed, 0x97f1fbfa, 0x9ebabf2c, 0x1e153c6e,
+	0x86e34570, 0xeae96fb1, 0x860e5e0a, 0x5a3e2ab3,
+	0x771fe71c, 0x4e3d06fa, 0x2965dcb9, 0x99e71d0f,
+	0x803e89d6, 0x5266c825, 0x2e4cc978, 0x9c10b36a,
+	0xc6150eba, 0x94e2ea78, 0xa5fc3c53, 0x1e0a2df4,
+	0xf2f74ea7, 0x361d2b3d, 0x1939260f, 0x19c27960,
+	0x5223a708, 0xf71312b6, 0xebadfe6e, 0xeac31f66,
+	0xe3bc4595, 0xa67bc883, 0xb17f37d1, 0x018cff28,
+	0xc332ddef, 0xbe6c5aa5, 0x65582185, 0x68ab9802,
+	0xeecea50f, 0xdb2f953b, 0x2aef7dad, 0x5b6e2f84,
+	0x1521b628, 0x29076170, 0xecdd4775, 0x619f1510,
+	0x13cca830, 0xeb61bd96, 0x0334fe1e, 0xaa0363cf,
+	0xb5735c90, 0x4c70a239, 0xd59e9e0b, 0xcbaade14,
+	0xeecc86bc, 0x60622ca7, 0x9cab5cab, 0xb2f3846e,
+	0x648b1eaf, 0x19bdf0ca, 0xa02369b9, 0x655abb50,
+	0x40685a32, 0x3c2ab4b3, 0x319ee9d5, 0xc021b8f7,
+	0x9b540b19, 0x875fa099, 0x95f7997e, 0x623d7da8,
+	0xf837889a, 0x97e32d77, 0x11ed935f, 0x16681281,
+	0x0e358829, 0xc7e61fd6, 0x96dedfa1, 0x7858ba99,
+	0x57f584a5, 0x1b227263, 0x9b83c3ff, 0x1ac24696,
+	0xcdb30aeb, 0x532e3054, 0x8fd948e4, 0x6dbc3128,
+	0x58ebf2ef, 0x34c6ffea, 0xfe28ed61, 0xee7c3c73,
+	0x5d4a14d9, 0xe864b7e3, 0x42105d14, 0x203e13e0,
+	0x45eee2b6, 0xa3aaabea, 0xdb6c4f15, 0xfacb4fd0,
+	0xc742f442, 0xef6abbb5, 0x654f3b1d, 0x41cd2105,
+	0xd81e799e, 0x86854dc7, 0xe44b476a, 0x3d816250,
+	0xcf62a1f2, 0x5b8d2646, 0xfc8883a0, 0xc1c7b6a3,
+	0x7f1524c3, 0x69cb7492, 0x47848a0b, 0x5692b285,
+	0x095bbf00, 0xad19489d, 0x1462b174, 0x23820e00,
+	0x58428d2a, 0x0c55f5ea, 0x1dadf43e, 0x233f7061,
+	0x3372f092, 0x8d937e41, 0xd65fecf1, 0x6c223bdb,
+	0x7cde3759, 0xcbee7460, 0x4085f2a7, 0xce77326e,
+	0xa6078084, 0x19f8509e, 0xe8efd855, 0x61d99735,
+	0xa969a7aa, 0xc50c06c2, 0x5a04abfc, 0x800bcadc,
+	0x9e447a2e, 0xc3453484, 0xfdd56705, 0x0e1e9ec9,
+	0xdb73dbd3, 0x105588cd, 0x675fda79, 0xe3674340,
+	0xc5c43465, 0x713e38d8, 0x3d28f89e, 0xf16dff20,
+	0x153e21e7, 0x8fb03d4a, 0xe6e39f2b, 0xdb83adf7,
+	0xe93d5a68, 0x948140f7, 0xf64c261c, 0x94692934,
+	0x411520f7, 0x7602d4f7, 0xbcf46b2e, 0xd4a20068,
+	0xd4082471, 0x3320f46a, 0x43b7d4b7, 0x500061af,
+	0x1e39f62e, 0x97244546, 0x14214f74, 0xbf8b8840,
+	0x4d95fc1d, 0x96b591af, 0x70f4ddd3, 0x66a02f45,
+	0xbfbc09ec, 0x03bd9785, 0x7fac6dd0, 0x31cb8504,
+	0x96eb27b3, 0x55fd3941, 0xda2547e6, 0xabca0a9a,
+	0x28507825, 0x530429f4, 0x0a2c86da, 0xe9b66dfb,
+	0x68dc1462, 0xd7486900, 0x680ec0a4, 0x27a18dee,
+	0x4f3ffea2, 0xe887ad8c, 0xb58ce006, 0x7af4d6b6,
+	0xaace1e7c, 0xd3375fec, 0xce78a399, 0x406b2a42,
+	0x20fe9e35, 0xd9f385b9, 0xee39d7ab, 0x3b124e8b,
+	0x1dc9faf7, 0x4b6d1856, 0x26a36631, 0xeae397b2,
+	0x3a6efa74, 0xdd5b4332, 0x6841e7f7, 0xca7820fb,
+	0xfb0af54e, 0xd8feb397, 0x454056ac, 0xba489527,
+	0x55533a3a, 0x20838d87, 0xfe6ba9b7, 0xd096954b,
+	0x55a867bc, 0xa1159a58, 0xcca92963, 0x99e1db33,
+	0xa62a4a56, 0x3f3125f9, 0x5ef47e1c, 0x9029317c,
+	0xfdf8e802, 0x04272f70, 0x80bb155c, 0x05282ce3,
+	0x95c11548, 0xe4c66d22, 0x48c1133f, 0xc70f86dc,
+	0x07f9c9ee, 0x41041f0f, 0x404779a4, 0x5d886e17,
+	0x325f51eb, 0xd59bc0d1, 0xf2bcc18f, 0x41113564,
+	0x257b7834, 0x602a9c60, 0xdff8e8a3, 0x1f636c1b,
+	0x0e12b4c2, 0x02e1329e, 0xaf664fd1, 0xcad18115,
+	0x6b2395e0, 0x333e92e1, 0x3b240b62, 0xeebeb922,
+	0x85b2a20e, 0xe6ba0d99, 0xde720c8c, 0x2da2f728,
+	0xd0127845, 0x95b794fd, 0x647d0862, 0xe7ccf5f0,
+	0x5449a36f, 0x877d48fa, 0xc39dfd27, 0xf33e8d1e,
+	0x0a476341, 0x992eff74, 0x3a6f6eab, 0xf4f8fd37,
+	0xa812dc60, 0xa1ebddf8, 0x991be14c, 0xdb6e6b0d,
+	0xc67b5510, 0x6d672c37, 0x2765d43b, 0xdcd0e804,
+	0xf1290dc7, 0xcc00ffa3, 0xb5390f92, 0x690fed0b,
+	0x667b9ffb, 0xcedb7d9c, 0xa091cf0b, 0xd9155ea3,
+	0xbb132f88, 0x515bad24, 0x7b9479bf, 0x763bd6eb,
+	0x37392eb3, 0xcc115979, 0x8026e297, 0xf42e312d,
+	0x6842ada7, 0xc66a2b3b, 0x12754ccc, 0x782ef11c,
+	0x6a124237, 0xb79251e7, 0x06a1bbe6, 0x4bfb6350,
+	0x1a6b1018, 0x11caedfa, 0x3d25bdd8, 0xe2e1c3c9,
+	0x44421659, 0x0a121386, 0xd90cec6e, 0xd5abea2a,
+	0x64af674e, 0xda86a85f, 0xbebfe988, 0x64e4c3fe,
+	0x9dbc8057, 0xf0f7c086, 0x60787bf8, 0x6003604d,
+	0xd1fd8346, 0xf6381fb0, 0x7745ae04, 0xd736fccc,
+	0x83426b33, 0xf01eab71, 0xb0804187, 0x3c005e5f,
+	0x77a057be, 0xbde8ae24, 0x55464299, 0xbf582e61,
+	0x4e58f48f, 0xf2ddfda2, 0xf474ef38, 0x8789bdc2,
+	0x5366f9c3, 0xc8b38e74, 0xb475f255, 0x46fcd9b9,
+	0x7aeb2661, 0x8b1ddf84, 0x846a0e79, 0x915f95e2,
+	0x466e598e, 0x20b45770, 0x8cd55591, 0xc902de4c,
+	0xb90bace1, 0xbb8205d0, 0x11a86248, 0x7574a99e,
+	0xb77f19b6, 0xe0a9dc09, 0x662d09a1, 0xc4324633,
+	0xe85a1f02, 0x09f0be8c, 0x4a99a025, 0x1d6efe10,
+	0x1ab93d1d, 0x0ba5a4df, 0xa186f20f, 0x2868f169,
+	0xdcb7da83, 0x573906fe, 0xa1e2ce9b, 0x4fcd7f52,
+	0x50115e01, 0xa70683fa, 0xa002b5c4, 0x0de6d027,
+	0x9af88c27, 0x773f8641, 0xc3604c06, 0x61a806b5,
+	0xf0177a28, 0xc0f586e0, 0x006058aa, 0x30dc7d62,
+	0x11e69ed7, 0x2338ea63, 0x53c2dd94, 0xc2c21634,
+	0xbbcbee56, 0x90bcb6de, 0xebfc7da1, 0xce591d76,
+	0x6f05e409, 0x4b7c0188, 0x39720a3d, 0x7c927c24,
+	0x86e3725f, 0x724d9db9, 0x1ac15bb4, 0xd39eb8fc,
+	0xed545578, 0x08fca5b5, 0xd83d7cd3, 0x4dad0fc4,
+	0x1e50ef5e, 0xb161e6f8, 0xa28514d9, 0x6c51133c,
+	0x6fd5c7e7, 0x56e14ec4, 0x362abfce, 0xddc6c837,
+	0xd79a3234, 0x92638212, 0x670efa8e, 0x406000e0,
+	0x3a39ce37, 0xd3faf5cf, 0xabc27737, 0x5ac52d1b,
+	0x5cb0679e, 0x4fa33742, 0xd3822740, 0x99bc9bbe,
+	0xd5118e9d, 0xbf0f7315, 0xd62d1c7e, 0xc700c47b,
+	0xb78c1b6b, 0x21a19045, 0xb26eb1be, 0x6a366eb4,
+	0x5748ab2f, 0xbc946e79, 0xc6a376d2, 0x6549c2c8,
+	0x530ff8ee, 0x468dde7d, 0xd5730a1d, 0x4cd04dc6,
+	0x2939bbdb, 0xa9ba4650, 0xac9526e8, 0xbe5ee304,
+	0xa1fad5f0, 0x6a2d519a, 0x63ef8ce2, 0x9a86ee22,
+	0xc089c2b8, 0x43242ef6, 0xa51e03aa, 0x9cf2d0a4,
+	0x83c061ba, 0x9be96a4d, 0x8fe51550, 0xba645bd6,
+	0x2826a2f9, 0xa73a3ae1, 0x4ba99586, 0xef5562e9,
+	0xc72fefd3, 0xf752f7da, 0x3f046f69, 0x77fa0a59,
+	0x80e4a915, 0x87b08601, 0x9b09e6ad, 0x3b3ee593,
+	0xe990fd5a, 0x9e34d797, 0x2cf0b7d9, 0x022b8b51,
+	0x96d5ac3a, 0x017da67d, 0xd1cf3ed6, 0x7c7d2d28,
+	0x1f9f25cf, 0xadf2b89b, 0x5ad6b472, 0x5a88f54c,
+	0xe029ac71, 0xe019a5e6, 0x47b0acfd, 0xed93fa9b,
+	0xe8d3c48d, 0x283b57cc, 0xf8d56629, 0x79132e28,
+	0x785f0191, 0xed756055, 0xf7960e44, 0xe3d35e8c,
+	0x15056dd4, 0x88f46dba, 0x03a16125, 0x0564f0bd,
+	0xc3eb9e15, 0x3c9057a2, 0x97271aec, 0xa93a072a,
+	0x1b3f6d9b, 0x1e6321f5, 0xf59c66fb, 0x26dcf319,
+	0x7533d928, 0xb155fdf5, 0x03563482, 0x8aba3cbb,
+	0x28517711, 0xc20ad9f8, 0xabcc5167, 0xccad925f,
+	0x4de81751, 0x3830dc8e, 0x379d5862, 0x9320f991,
+	0xea7a90c2, 0xfb3e7bce, 0x5121ce64, 0x774fbe32,
+	0xa8b6e37e, 0xc3293d46, 0x48de5369, 0x6413e680,
+	0xa2ae0810, 0xdd6db224, 0x69852dfd, 0x09072166,
+	0xb39a460a, 0x6445c0dd, 0x586cdecf, 0x1c20c8ae,
+	0x5bbef7dd, 0x1b588d40, 0xccd2017f, 0x6bb4e3bb,
+	0xdda26a7e, 0x3a59ff45, 0x3e350a44, 0xbcb4cdd5,
+	0x72eacea8, 0xfa6484bb, 0x8d6612ae, 0xbf3c6f47,
+	0xd29be463, 0x542f5d9e, 0xaec2771b, 0xf64e6370,
+	0x740e0d8d, 0xe75b1357, 0xf8721671, 0xaf537d5d,
+	0x4040cb08, 0x4eb4e2cc, 0x34d2466a, 0x0115af84,
+	0xe1b00428, 0x95983a1d, 0x06b89fb4, 0xce6ea048,
+	0x6f3f3b82, 0x3520ab82, 0x011a1d4b, 0x277227f8,
+	0x611560b1, 0xe7933fdc, 0xbb3a792b, 0x344525bd,
+	0xa08839e1, 0x51ce794b, 0x2f32c9b7, 0xa01fbac9,
+	0xe01cc87e, 0xbcc7d1f6, 0xcf0111c3, 0xa1e8aac7,
+	0x1a908749, 0xd44fbd9a, 0xd0dadecb, 0xd50ada38,
+	0x0339c32a, 0xc6913667, 0x8df9317c, 0xe0b12b4f,
+	0xf79e59b7, 0x43f5bb3a, 0xf2d519ff, 0x27d9459c,
+	0xbf97222c, 0x15e6fc2a, 0x0f91fc71, 0x9b941525,
+	0xfae59361, 0xceb69ceb, 0xc2a86459, 0x12baa8d1,
+	0xb6c1075e, 0xe3056a0c, 0x10d25065, 0xcb03a442,
+	0xe0ec6e0e, 0x1698db3b, 0x4c98a0be, 0x3278e964,
+	0x9f1f9532, 0xe0d392df, 0xd3a0342b, 0x8971f21e,
+	0x1b0a7441, 0x4ba3348c, 0xc5be7120, 0xc37632d8,
+	0xdf359f8d, 0x9b992f2e, 0xe60b6f47, 0x0fe3f11d,
+	0xe54cda54, 0x1edad891, 0xce6279cf, 0xcd3e7e6f,
+	0x1618b166, 0xfd2c1d05, 0x848fd2c5, 0xf6fb2299,
+	0xf523f357, 0xa6327623, 0x93a83531, 0x56cccd02,
+	0xacf08162, 0x5a75ebb5, 0x6e163697, 0x88d273cc,
+	0xde966292, 0x81b949d0, 0x4c50901b, 0x71c65614,
+	0xe6c6c7bd, 0x327a140a, 0x45e1d006, 0xc3f27b9a,
+	0xc9aa53fd, 0x62a80f00, 0xbb25bfe2, 0x35bdd2f6,
+	0x71126905, 0xb2040222, 0xb6cbcf7c, 0xcd769c2b,
+	0x53113ec0, 0x1640e3d3, 0x38abbd60, 0x2547adf0,
+	0xba38209c, 0xf746ce76, 0x77afa1c5, 0x20756060,
+	0x85cbfe4e, 0x8ae88dd8, 0x7aaaf9b0, 0x4cf9aa7e,
+	0x1948c25c, 0x02fb8a8c, 0x01c36ae4, 0xd6ebe1f9,
+	0x90d4f869, 0xa65cdea0, 0x3f09252d, 0xc208e69f,
+	0xb74e6132, 0xce77e25b, 0x578fdfe3, 0x3ac372e6,
+};
+
+/*
+ * Round loop unrolling macros, S is a pointer to a S-Box array
+ * organized in 4 unsigned longs at a row.
+ */
+#define GET32_3(x) (((x) & 0xff))
+#define GET32_2(x) (((x) >> (8)) & (0xff))
+#define GET32_1(x) (((x) >> (16)) & (0xff))
+#define GET32_0(x) (((x) >> (24)) & (0xff))
+
+#define bf_F(x) (((S[GET32_0(x)] + S[256 + GET32_1(x)]) ^ \
+    S[512 + GET32_2(x)]) + S[768 + GET32_3(x)])
+
+#define EROUND(a, b, n)  do { b ^= P[n]; a ^= bf_F(b); } while (0)
+#define DROUND(a, b, n)  do { a ^= bf_F(b); b ^= P[n]; } while (0)
+
+
+/*
+ * encrypt isdn data frame
+ * every block with 9 samples is encrypted
+ */
+void
+dsp_bf_encrypt(struct dsp *dsp, u8 *data, int len)
+{
+	int i = 0, j = dsp->bf_crypt_pos;
+	u8 *bf_data_in = dsp->bf_data_in;
+	u8 *bf_crypt_out = dsp->bf_crypt_out;
+	u32 *P = dsp->bf_p;
+	u32 *S = dsp->bf_s;
+	u32 yl, yr;
+	u32 cs;
+	u8 nibble;
+
+	while (i < len) {
+		/* collect a block of 9 samples */
+		if (j < 9) {
+			bf_data_in[j] = *data;
+			*data++ = bf_crypt_out[j++];
+			i++;
+			continue;
+		}
+		j = 0;
+		/* transcode 9 samples xlaw to 8 bytes */
+		yl = dsp_audio_law2seven[bf_data_in[0]];
+		yl = (yl<<7) | dsp_audio_law2seven[bf_data_in[1]];
+		yl = (yl<<7) | dsp_audio_law2seven[bf_data_in[2]];
+		yl = (yl<<7) | dsp_audio_law2seven[bf_data_in[3]];
+		nibble = dsp_audio_law2seven[bf_data_in[4]];
+		yr = nibble;
+		yl = (yl<<4) | (nibble>>3);
+		yr = (yr<<7) | dsp_audio_law2seven[bf_data_in[5]];
+		yr = (yr<<7) | dsp_audio_law2seven[bf_data_in[6]];
+		yr = (yr<<7) | dsp_audio_law2seven[bf_data_in[7]];
+		yr = (yr<<7) | dsp_audio_law2seven[bf_data_in[8]];
+		yr = (yr<<1) | (bf_data_in[0] & 1);
+
+		/* fill unused bit with random noise of audio input */
+		/* encrypt */
+
+		EROUND(yr, yl, 0);
+		EROUND(yl, yr, 1);
+		EROUND(yr, yl, 2);
+		EROUND(yl, yr, 3);
+		EROUND(yr, yl, 4);
+		EROUND(yl, yr, 5);
+		EROUND(yr, yl, 6);
+		EROUND(yl, yr, 7);
+		EROUND(yr, yl, 8);
+		EROUND(yl, yr, 9);
+		EROUND(yr, yl, 10);
+		EROUND(yl, yr, 11);
+		EROUND(yr, yl, 12);
+		EROUND(yl, yr, 13);
+		EROUND(yr, yl, 14);
+		EROUND(yl, yr, 15);
+		yl ^= P[16];
+		yr ^= P[17];
+
+		/* calculate 3-bit checksumme */
+		cs = yl ^ (yl>>3) ^ (yl>>6) ^ (yl>>9) ^ (yl>>12) ^ (yl>>15)
+			^ (yl>>18) ^ (yl>>21) ^ (yl>>24) ^ (yl>>27) ^ (yl>>30)
+			^ (yr<<2) ^ (yr>>1) ^ (yr>>4) ^ (yr>>7) ^ (yr>>10)
+			^ (yr>>13) ^ (yr>>16) ^ (yr>>19) ^ (yr>>22) ^ (yr>>25)
+			^ (yr>>28) ^ (yr>>31);
+
+		/*
+		 * transcode 8 crypted bytes to 9 data bytes with sync
+		 * and checksum information
+		 */
+		bf_crypt_out[0] = (yl>>25) | 0x80;
+		bf_crypt_out[1] = (yl>>18) & 0x7f;
+		bf_crypt_out[2] = (yl>>11) & 0x7f;
+		bf_crypt_out[3] = (yl>>4) & 0x7f;
+		bf_crypt_out[4] = ((yl<<3) & 0x78) | ((yr>>29) & 0x07);
+		bf_crypt_out[5] = ((yr>>22) & 0x7f) | ((cs<<5) & 0x80);
+		bf_crypt_out[6] = ((yr>>15) & 0x7f) | ((cs<<6) & 0x80);
+		bf_crypt_out[7] = ((yr>>8) & 0x7f) | (cs<<7);
+		bf_crypt_out[8] = yr;
+	}
+
+	/* write current count */
+	dsp->bf_crypt_pos = j;
+
+}
+
+
+/*
+ * decrypt isdn data frame
+ * every block with 9 bytes is decrypted
+ */
+void
+dsp_bf_decrypt(struct dsp *dsp, u8 *data, int len)
+{
+	int i = 0;
+	u8 j = dsp->bf_decrypt_in_pos;
+	u8 k = dsp->bf_decrypt_out_pos;
+	u8 *bf_crypt_inring = dsp->bf_crypt_inring;
+	u8 *bf_data_out = dsp->bf_data_out;
+	u16 sync = dsp->bf_sync;
+	u32 *P = dsp->bf_p;
+	u32 *S = dsp->bf_s;
+	u32 yl, yr;
+	u8 nibble;
+	u8 cs, cs0, cs1, cs2;
+
+	while (i < len) {
+		/*
+		 * shift upper bit and rotate data to buffer ring
+		 * send current decrypted data
+		 */
+		sync = (sync<<1) | ((*data)>>7);
+		bf_crypt_inring[j++ & 15] = *data;
+		*data++ = bf_data_out[k++];
+		i++;
+		if (k == 9)
+			k = 0; /* repeat if no sync has been found */
+		/* check if not in sync */
+		if ((sync&0x1f0) != 0x100)
+			continue;
+		j -= 9;
+		/* transcode receive data to 64 bit block of encrypted data */
+		yl = bf_crypt_inring[j++ & 15];
+		yl = (yl<<7) | bf_crypt_inring[j++ & 15]; /* bit7 = 0 */
+		yl = (yl<<7) | bf_crypt_inring[j++ & 15]; /* bit7 = 0 */
+		yl = (yl<<7) | bf_crypt_inring[j++ & 15]; /* bit7 = 0 */
+		nibble = bf_crypt_inring[j++ & 15]; /* bit7 = 0 */
+		yr = nibble;
+		yl = (yl<<4) | (nibble>>3);
+		cs2 = bf_crypt_inring[j++ & 15];
+		yr = (yr<<7) | (cs2 & 0x7f);
+		cs1 = bf_crypt_inring[j++ & 15];
+		yr = (yr<<7) | (cs1 & 0x7f);
+		cs0 = bf_crypt_inring[j++ & 15];
+		yr = (yr<<7) | (cs0 & 0x7f);
+		yr = (yr<<8) | bf_crypt_inring[j++ & 15];
+
+		/* calculate 3-bit checksumme */
+		cs = yl ^ (yl>>3) ^ (yl>>6) ^ (yl>>9) ^ (yl>>12) ^ (yl>>15)
+			^ (yl>>18) ^ (yl>>21) ^ (yl>>24) ^ (yl>>27) ^ (yl>>30)
+			^ (yr<<2) ^ (yr>>1) ^ (yr>>4) ^ (yr>>7) ^ (yr>>10)
+			^ (yr>>13) ^ (yr>>16) ^ (yr>>19) ^ (yr>>22) ^ (yr>>25)
+			^ (yr>>28) ^ (yr>>31);
+
+		/* check if frame is valid */
+		if ((cs&0x7) != (((cs2>>5)&4) | ((cs1>>6)&2) | (cs0 >> 7))) {
+			if (dsp_debug & DEBUG_DSP_BLOWFISH)
+				printk(KERN_DEBUG
+				    "DSP BLOWFISH: received corrupt frame, "
+				    "checksumme is not correct\n");
+			continue;
+		}
+
+		/* decrypt */
+		yr ^= P[17];
+		yl ^= P[16];
+		DROUND(yl, yr, 15);
+		DROUND(yr, yl, 14);
+		DROUND(yl, yr, 13);
+		DROUND(yr, yl, 12);
+		DROUND(yl, yr, 11);
+		DROUND(yr, yl, 10);
+		DROUND(yl, yr, 9);
+		DROUND(yr, yl, 8);
+		DROUND(yl, yr, 7);
+		DROUND(yr, yl, 6);
+		DROUND(yl, yr, 5);
+		DROUND(yr, yl, 4);
+		DROUND(yl, yr, 3);
+		DROUND(yr, yl, 2);
+		DROUND(yl, yr, 1);
+		DROUND(yr, yl, 0);
+
+		/* transcode 8 crypted bytes to 9 sample bytes */
+		bf_data_out[0] = dsp_audio_seven2law[(yl>>25) & 0x7f];
+		bf_data_out[1] = dsp_audio_seven2law[(yl>>18) & 0x7f];
+		bf_data_out[2] = dsp_audio_seven2law[(yl>>11) & 0x7f];
+		bf_data_out[3] = dsp_audio_seven2law[(yl>>4) & 0x7f];
+		bf_data_out[4] = dsp_audio_seven2law[((yl<<3) & 0x78) |
+		    ((yr>>29) & 0x07)];
+
+		bf_data_out[5] = dsp_audio_seven2law[(yr>>22) & 0x7f];
+		bf_data_out[6] = dsp_audio_seven2law[(yr>>15) & 0x7f];
+		bf_data_out[7] = dsp_audio_seven2law[(yr>>8) & 0x7f];
+		bf_data_out[8] = dsp_audio_seven2law[(yr>>1) & 0x7f];
+		k = 0; /* start with new decoded frame */
+	}
+
+	/* write current count and sync */
+	dsp->bf_decrypt_in_pos = j;
+	dsp->bf_decrypt_out_pos = k;
+	dsp->bf_sync = sync;
+}
+
+
+/* used to encrypt S and P boxes */
+static inline void
+encrypt_block(const u32 *P, const u32 *S, u32 *dst, u32 *src)
+{
+	u32 yl = src[0];
+	u32 yr = src[1];
+
+	EROUND(yr, yl, 0);
+	EROUND(yl, yr, 1);
+	EROUND(yr, yl, 2);
+	EROUND(yl, yr, 3);
+	EROUND(yr, yl, 4);
+	EROUND(yl, yr, 5);
+	EROUND(yr, yl, 6);
+	EROUND(yl, yr, 7);
+	EROUND(yr, yl, 8);
+	EROUND(yl, yr, 9);
+	EROUND(yr, yl, 10);
+	EROUND(yl, yr, 11);
+	EROUND(yr, yl, 12);
+	EROUND(yl, yr, 13);
+	EROUND(yr, yl, 14);
+	EROUND(yl, yr, 15);
+
+	yl ^= P[16];
+	yr ^= P[17];
+
+	dst[0] = yr;
+	dst[1] = yl;
+}
+
+/*
+ * initialize the dsp for encryption and decryption using the same key
+ * Calculates the blowfish S and P boxes for encryption and decryption.
+ * The margin of keylen must be 4-56 bytes.
+ * returns 0 if ok.
+ */
+int
+dsp_bf_init(struct dsp *dsp, const u8 *key, uint keylen)
+{
+	short i, j, count;
+	u32 data[2], temp;
+	u32 *P = (u32 *)dsp->bf_p;
+	u32 *S = (u32 *)dsp->bf_s;
+
+	if (keylen < 4 || keylen > 56)
+		return 1;
+
+	/* Set dsp states */
+	i = 0;
+	while (i < 9) {
+		dsp->bf_crypt_out[i] = 0xff;
+		dsp->bf_data_out[i] = dsp_silence;
+		i++;
+	}
+	dsp->bf_crypt_pos = 0;
+	dsp->bf_decrypt_in_pos = 0;
+	dsp->bf_decrypt_out_pos = 0;
+	dsp->bf_sync = 0x1ff;
+	dsp->bf_enable = 1;
+
+	/* Copy the initialization s-boxes */
+	for (i = 0, count = 0; i < 256; i++)
+		for (j = 0; j < 4; j++, count++)
+			S[count] = bf_sbox[count];
+
+	/* Set the p-boxes */
+	for (i = 0; i < 16 + 2; i++)
+		P[i] = bf_pbox[i];
+
+	/* Actual subkey generation */
+	for (j = 0, i = 0; i < 16 + 2; i++) {
+		temp = (((u32)key[j] << 24) |
+		    ((u32)key[(j + 1) % keylen] << 16) |
+		    ((u32)key[(j + 2) % keylen] << 8) |
+		    ((u32)key[(j + 3) % keylen]));
+
+		P[i] = P[i] ^ temp;
+		j = (j + 4) % keylen;
+	}
+
+	data[0] = 0x00000000;
+	data[1] = 0x00000000;
+
+	for (i = 0; i < 16 + 2; i += 2) {
+		encrypt_block(P, S, data, data);
+
+		P[i] = data[0];
+		P[i + 1] = data[1];
+	}
+
+	for (i = 0; i < 4; i++) {
+		for (j = 0, count = i * 256; j < 256; j += 2, count += 2) {
+			encrypt_block(P, S, data, data);
+
+			S[count] = data[0];
+			S[count + 1] = data[1];
+		}
+	}
+
+	return 0;
+}
+
+
+/*
+ * turn encryption off
+ */
+void
+dsp_bf_cleanup(struct dsp *dsp)
+{
+	dsp->bf_enable = 0;
+}
diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
new file mode 100644
index 0000000..e92b1ba
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -0,0 +1,1886 @@
+/*
+ * Audio crossconnecting/conferrencing (hardware level).
+ *
+ * Copyright 2002 by Andreas Eversberg (jolly@eversberg.eu)
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ *
+ */
+
+/*
+ * The process of adding and removing parties to/from a conference:
+ *
+ * There is a chain of struct dsp_conf which has one or more members in a chain
+ * of struct dsp_conf_member.
+ *
+ * After a party is added, the conference is checked for hardware capability.
+ * Also if a party is removed, the conference is checked again.
+ *
+ * There are 3 different solutions: -1 = software, 0 = hardware-crossconnect
+ * 1-n = hardware-conference. The n will give the conference number.
+ *
+ * Depending on the change after removal or insertion of a party, hardware
+ * commands are given.
+ *
+ * The current solution is stored within the struct dsp_conf entry.
+ */
+
+/*
+ * HOW THE CMX WORKS:
+ *
+ * There are 3 types of interaction: One member is alone, in this case only
+ * data flow from upper to lower layer is done.
+ * Two members will also exchange their data so they are crossconnected.
+ * Three or more members will be added in a conference and will hear each
+ * other but will not receive their own speech (echo) if not enabled.
+ *
+ * Features of CMX are:
+ *  - Crossconnecting or even conference, if more than two members are together.
+ *  - Force mixing of transmit data with other crossconnect/conference members.
+ *  - Echo generation to benchmark the delay of audio processing.
+ *  - Use hardware to minimize cpu load, disable FIFO load and minimize delay.
+ *  - Dejittering and clock generation.
+ *
+ * There are 2 buffers:
+ *
+ *
+ * RX-Buffer
+ *                 R             W
+ *                 |             |
+ * ----------------+-------------+-------------------
+ *
+ * The rx-buffer is a ring buffer used to store the received data for each
+ * individual member. This is only the case if data needs to be dejittered
+ * or in case of a conference where different clocks require reclocking.
+ * The transmit-clock (R) will read the buffer.
+ * If the clock overruns the write-pointer, we will have a buffer underrun.
+ * If the write pointer always has a certain distance from the transmit-
+ * clock, we will have a delay. The delay will dynamically be increased and
+ * reduced.
+ *
+ *
+ * TX-Buffer
+ *                  R        W
+ *                  |        |
+ * -----------------+--------+-----------------------
+ *
+ * The tx-buffer is a ring buffer to queue the transmit data from user space
+ * until it will be mixed or sent. There are two pointers, R and W. If the write
+ * pointer W would reach or overrun R, the buffer would overrun. In this case
+ * (some) data is dropped so that it will not overrun.
+ * Additionally a dynamic dejittering can be enabled. this allows data from
+ * user space that have jitter and different clock source.
+ *
+ *
+ * Clock:
+ *
+ * A Clock is not required, if the data source has exactly one clock. In this
+ * case the data source is forwarded to the destination.
+ *
+ * A Clock is required, because the data source
+ *  - has multiple clocks.
+ *  - has no usable clock due to jitter or packet loss (VoIP).
+ * In this case the system's clock is used. The clock resolution depends on
+ * the jiffie resolution.
+ *
+ * If a member joins a conference:
+ *
+ * - If a member joins, its rx_buff is set to silence and change read pointer
+ *   to transmit clock.
+ *
+ * The procedure of received data from card is explained in cmx_receive.
+ * The procedure of received data from user space is explained in cmx_transmit.
+ * The procedure of transmit data to card is cmx_send.
+ *
+ *
+ * Interaction with other features:
+ *
+ * DTMF:
+ * DTMF decoding is done before the data is crossconnected.
+ *
+ * Volume change:
+ * Changing rx-volume is done before the data is crossconnected. The tx-volume
+ * must be changed whenever data is transmitted to the card by the cmx.
+ *
+ * Tones:
+ * If a tone is enabled, it will be processed whenever data is transmitted to
+ * the card. It will replace the tx-data from the user space.
+ * If tones are generated by hardware, this conference member is removed for
+ * this time.
+ *
+ * Disable rx-data:
+ * If cmx is realized in hardware, rx data will be disabled if requested by
+ * the upper layer. If dtmf decoding is done by software and enabled, rx data
+ * will not be diabled but blocked to the upper layer.
+ *
+ * HFC conference engine:
+ * If it is possible to realize all features using hardware, hardware will be
+ * used if not forbidden by control command. Disabling rx-data provides
+ * absolutely traffic free audio processing. (except for the quick 1-frame
+ * upload of a tone loop, only once for a new tone)
+ *
+ */
+
+/* delay.h is required for hw_lock.h */
+
+#include <linux/delay.h>
+#include <linux/mISDNif.h>
+#include <linux/mISDNdsp.h>
+#include "core.h"
+#include "dsp.h"
+/*
+ * debugging of multi party conference,
+ * by using conference even with two members
+ */
+
+/* #define CMX_CONF_DEBUG */
+
+/*#define CMX_DEBUG * massive read/write pointer output */
+/*#define CMX_TX_DEBUG * massive read/write on tx-buffer with content */
+
+static inline int
+count_list_member(struct list_head *head)
+{
+	int			cnt = 0;
+	struct list_head	*m;
+
+	list_for_each(m, head)
+		cnt++;
+	return cnt;
+}
+
+/*
+ * debug cmx memory structure
+ */
+void
+dsp_cmx_debug(struct dsp *dsp)
+{
+	struct dsp_conf	*conf;
+	struct dsp_conf_member	*member;
+	struct dsp		*odsp;
+
+	printk(KERN_DEBUG "-----Current DSP\n");
+	list_for_each_entry(odsp, &dsp_ilist, list) {
+		printk(KERN_DEBUG "* %s echo=%d txmix=%d",
+		    odsp->name, odsp->echo, odsp->tx_mix);
+		if (odsp->conf)
+			printk(" (Conf %d)", odsp->conf->id);
+		if (dsp == odsp)
+			printk(" *this*");
+		printk("\n");
+	}
+	printk(KERN_DEBUG "-----Current Conf:\n");
+	list_for_each_entry(conf, &conf_ilist, list) {
+		printk(KERN_DEBUG "* Conf %d (%p)\n", conf->id, conf);
+		list_for_each_entry(member, &conf->mlist, list) {
+			printk(KERN_DEBUG
+			    "  - member = %s (slot_tx %d, bank_tx %d, "
+			    "slot_rx %d, bank_rx %d hfc_conf %d)%s\n",
+			    member->dsp->name, member->dsp->pcm_slot_tx,
+			    member->dsp->pcm_bank_tx, member->dsp->pcm_slot_rx,
+			    member->dsp->pcm_bank_rx, member->dsp->hfc_conf,
+			    (member->dsp == dsp) ? " *this*" : "");
+		}
+	}
+	printk(KERN_DEBUG "-----end\n");
+}
+
+/*
+ * search conference
+ */
+static struct dsp_conf *
+dsp_cmx_search_conf(u32 id)
+{
+	struct dsp_conf *conf;
+
+	if (!id) {
+		printk(KERN_WARNING "%s: conference ID is 0.\n", __func__);
+		return NULL;
+	}
+
+	/* search conference */
+	list_for_each_entry(conf, &conf_ilist, list)
+		if (conf->id == id)
+			return conf;
+
+	return NULL;
+}
+
+
+/*
+ * add member to conference
+ */
+static int
+dsp_cmx_add_conf_member(struct dsp *dsp, struct dsp_conf *conf)
+{
+	struct dsp_conf_member *member;
+
+	if (!conf || !dsp) {
+		printk(KERN_WARNING "%s: conf or dsp is 0.\n", __func__);
+		return -EINVAL;
+	}
+	if (dsp->member) {
+		printk(KERN_WARNING "%s: dsp is already member in a conf.\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (dsp->conf) {
+		printk(KERN_WARNING "%s: dsp is already in a conf.\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	member = kzalloc(sizeof(struct dsp_conf_member), GFP_ATOMIC);
+	if (!member) {
+		printk(KERN_ERR "kmalloc struct dsp_conf_member failed\n");
+		return -ENOMEM;
+	}
+	member->dsp = dsp;
+	/* clear rx buffer */
+	memset(dsp->rx_buff, dsp_silence, sizeof(dsp->rx_buff));
+	dsp->rx_init = 1; /* rx_W and rx_R will be adjusted on first frame */
+	dsp->rx_W = 0;
+	dsp->rx_R = 0;
+
+	list_add_tail(&member->list, &conf->mlist);
+
+	dsp->conf = conf;
+	dsp->member = member;
+
+	return 0;
+}
+
+
+/*
+ * del member from conference
+ */
+int
+dsp_cmx_del_conf_member(struct dsp *dsp)
+{
+	struct dsp_conf_member *member;
+
+	if (!dsp) {
+		printk(KERN_WARNING "%s: dsp is 0.\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (!dsp->conf) {
+		printk(KERN_WARNING "%s: dsp is not in a conf.\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (list_empty(&dsp->conf->mlist)) {
+		printk(KERN_WARNING "%s: dsp has linked an empty conf.\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	/* find us in conf */
+	list_for_each_entry(member, &dsp->conf->mlist, list) {
+		if (member->dsp == dsp) {
+			list_del(&member->list);
+			dsp->conf = NULL;
+			dsp->member = NULL;
+			kfree(member);
+			return 0;
+		}
+	}
+	printk(KERN_WARNING
+	    "%s: dsp is not present in its own conf_meber list.\n",
+	    __func__);
+
+	return -EINVAL;
+}
+
+
+/*
+ * new conference
+ */
+static struct dsp_conf
+*dsp_cmx_new_conf(u32 id)
+{
+	struct dsp_conf *conf;
+
+	if (!id) {
+		printk(KERN_WARNING "%s: id is 0.\n",
+		    __func__);
+		return NULL;
+	}
+
+	conf = kzalloc(sizeof(struct dsp_conf), GFP_ATOMIC);
+	if (!conf) {
+		printk(KERN_ERR "kmalloc struct dsp_conf failed\n");
+		return NULL;
+	}
+	INIT_LIST_HEAD(&conf->mlist);
+	conf->id = id;
+
+	list_add_tail(&conf->list, &conf_ilist);
+
+	return conf;
+}
+
+
+/*
+ * del conference
+ */
+int
+dsp_cmx_del_conf(struct dsp_conf *conf)
+{
+	if (!conf) {
+		printk(KERN_WARNING "%s: conf is null.\n",
+		    __func__);
+		return -EINVAL;
+	}
+
+	if (!list_empty(&conf->mlist)) {
+		printk(KERN_WARNING "%s: conf not empty.\n",
+		    __func__);
+		return -EINVAL;
+	}
+	list_del(&conf->list);
+	kfree(conf);
+
+	return 0;
+}
+
+
+/*
+ * send HW message to hfc card
+ */
+static void
+dsp_cmx_hw_message(struct dsp *dsp, u32 message, u32 param1, u32 param2,
+    u32 param3, u32 param4)
+{
+	struct mISDN_ctrl_req cq;
+
+	memset(&cq, 0, sizeof(cq));
+	cq.op = message;
+	cq.p1 = param1 | (param2 << 8);
+	cq.p2 = param3 | (param4 << 8);
+	if (dsp->ch.peer)
+		dsp->ch.peer->ctrl(dsp->ch.peer, CONTROL_CHANNEL, &cq);
+}
+
+
+/*
+ * do hardware update and set the software/hardware flag
+ *
+ * either a conference or a dsp instance can be given
+ * if only dsp instance is given, the instance is not associated with a conf
+ * and therefore removed. if a conference is given, the dsp is expected to
+ * be member of that conference.
+ */
+void
+dsp_cmx_hardware(struct dsp_conf *conf, struct dsp *dsp)
+{
+	struct dsp_conf_member	*member, *nextm;
+	struct dsp		*finddsp;
+	int		memb = 0, i, ii, i1, i2;
+	int		freeunits[8];
+	u_char		freeslots[256];
+	int		same_hfc = -1, same_pcm = -1, current_conf = -1,
+	    all_conf = 1;
+
+	/* dsp gets updated (no conf) */
+	if (!conf) {
+		if (!dsp)
+			return;
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG "%s checking dsp %s\n",
+			    __func__, dsp->name);
+one_member:
+		/* remove HFC conference if enabled */
+		if (dsp->hfc_conf >= 0) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s removing %s from HFC conf %d "
+				    "because dsp is split\n", __func__,
+				    dsp->name, dsp->hfc_conf);
+			dsp_cmx_hw_message(dsp, MISDN_CTRL_HFC_CONF_SPLIT,
+			    0, 0, 0, 0);
+			dsp->hfc_conf = -1;
+		}
+		/* process hw echo */
+		if (dsp->features.pcm_banks < 1)
+			return;
+		if (!dsp->echo) {
+			/* NO ECHO: remove PCM slot if assigned */
+			if (dsp->pcm_slot_tx >= 0 || dsp->pcm_slot_rx >= 0) {
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG "%s removing %s from"
+					    " PCM slot %d (TX) %d (RX) because"
+					    " dsp is split (no echo)\n",
+					    __func__, dsp->name,
+					    dsp->pcm_slot_tx, dsp->pcm_slot_rx);
+				dsp_cmx_hw_message(dsp, MISDN_CTRL_HFC_PCM_DISC,
+				    0, 0, 0, 0);
+				dsp->pcm_slot_tx = -1;
+				dsp->pcm_bank_tx = -1;
+				dsp->pcm_slot_rx = -1;
+				dsp->pcm_bank_rx = -1;
+			}
+			return;
+		}
+		/* ECHO: already echo */
+		if (dsp->pcm_slot_tx >= 0 && dsp->pcm_slot_rx < 0 &&
+		    dsp->pcm_bank_tx == 2 && dsp->pcm_bank_rx == 2)
+			return;
+		/* ECHO: if slot already assigned */
+		if (dsp->pcm_slot_tx >= 0) {
+			dsp->pcm_slot_rx = dsp->pcm_slot_tx;
+			dsp->pcm_bank_tx = 2; /* 2 means loop */
+			dsp->pcm_bank_rx = 2;
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s refresh %s for echo using slot %d\n",
+				    __func__, dsp->name,
+				    dsp->pcm_slot_tx);
+			dsp_cmx_hw_message(dsp, MISDN_CTRL_HFC_PCM_CONN,
+			    dsp->pcm_slot_tx, 2, dsp->pcm_slot_rx, 2);
+			return;
+		}
+		/* ECHO: find slot */
+		dsp->pcm_slot_tx = -1;
+		dsp->pcm_slot_rx = -1;
+		memset(freeslots, 1, sizeof(freeslots));
+		list_for_each_entry(finddsp, &dsp_ilist, list) {
+			if (finddsp->features.pcm_id == dsp->features.pcm_id) {
+				if (finddsp->pcm_slot_rx >= 0 &&
+				    finddsp->pcm_slot_rx < sizeof(freeslots))
+					freeslots[finddsp->pcm_slot_tx] = 0;
+				if (finddsp->pcm_slot_tx >= 0 &&
+				    finddsp->pcm_slot_tx < sizeof(freeslots))
+					freeslots[finddsp->pcm_slot_rx] = 0;
+			}
+		}
+		i = 0;
+		ii = dsp->features.pcm_slots;
+		while (i < ii) {
+			if (freeslots[i])
+				break;
+			i++;
+		}
+		if (i == ii) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s no slot available for echo\n",
+				    __func__);
+			/* no more slots available */
+			return;
+		}
+		/* assign free slot */
+		dsp->pcm_slot_tx = i;
+		dsp->pcm_slot_rx = i;
+		dsp->pcm_bank_tx = 2; /* loop */
+		dsp->pcm_bank_rx = 2;
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG
+			    "%s assign echo for %s using slot %d\n",
+			    __func__, dsp->name, dsp->pcm_slot_tx);
+		dsp_cmx_hw_message(dsp, MISDN_CTRL_HFC_PCM_CONN,
+		    dsp->pcm_slot_tx, 2, dsp->pcm_slot_rx, 2);
+		return;
+	}
+
+	/* conf gets updated (all members) */
+	if (dsp_debug & DEBUG_DSP_CMX)
+		printk(KERN_DEBUG "%s checking conference %d\n",
+		    __func__, conf->id);
+
+	if (list_empty(&conf->mlist)) {
+		printk(KERN_ERR "%s: conference whithout members\n",
+		    __func__);
+		return;
+	}
+	member = list_entry(conf->mlist.next, struct dsp_conf_member, list);
+	same_hfc = member->dsp->features.hfc_id;
+	same_pcm = member->dsp->features.pcm_id;
+	/* check all members in our conference */
+	list_for_each_entry(member, &conf->mlist, list) {
+		/* check if member uses mixing */
+		if (member->dsp->tx_mix) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "tx_mix is turned on\n", __func__,
+				    member->dsp->name);
+conf_software:
+			list_for_each_entry(member, &conf->mlist, list) {
+				dsp = member->dsp;
+				/* remove HFC conference if enabled */
+				if (dsp->hfc_conf >= 0) {
+					if (dsp_debug & DEBUG_DSP_CMX)
+						printk(KERN_DEBUG
+						    "%s removing %s from HFC "
+						    "conf %d because not "
+						    "possible with hardware\n",
+						    __func__,
+						    dsp->name,
+						    dsp->hfc_conf);
+					dsp_cmx_hw_message(dsp,
+					    MISDN_CTRL_HFC_CONF_SPLIT,
+					    0, 0, 0, 0);
+					dsp->hfc_conf = -1;
+				}
+				/* remove PCM slot if assigned */
+				if (dsp->pcm_slot_tx >= 0 ||
+				    dsp->pcm_slot_rx >= 0) {
+					if (dsp_debug & DEBUG_DSP_CMX)
+						printk(KERN_DEBUG "%s removing "
+						    "%s from PCM slot %d (TX)"
+						    " slot %d (RX) because not"
+						    " possible with hardware\n",
+						    __func__,
+						    dsp->name,
+						    dsp->pcm_slot_tx,
+						    dsp->pcm_slot_rx);
+					dsp_cmx_hw_message(dsp,
+					    MISDN_CTRL_HFC_PCM_DISC,
+					    0, 0, 0, 0);
+					dsp->pcm_slot_tx = -1;
+					dsp->pcm_bank_tx = -1;
+					dsp->pcm_slot_rx = -1;
+					dsp->pcm_bank_rx = -1;
+				}
+			}
+			conf->hardware = 0;
+			conf->software = 1;
+			return;
+		}
+		/* check if member has echo turned on */
+		if (member->dsp->echo) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "echo is turned on\n", __func__,
+				    member->dsp->name);
+			goto conf_software;
+		}
+		/* check if member has tx_mix turned on */
+		if (member->dsp->tx_mix) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "tx_mix is turned on\n",
+				    __func__, member->dsp->name);
+			goto conf_software;
+		}
+		/* check if member changes volume at an not suppoted level */
+		if (member->dsp->tx_volume) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "tx_volume is changed\n",
+				    __func__, member->dsp->name);
+			goto conf_software;
+		}
+		if (member->dsp->rx_volume) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "rx_volume is changed\n",
+				    __func__, member->dsp->name);
+			goto conf_software;
+		}
+		/* check if tx-data turned on */
+		if (member->dsp->tx_data) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "tx_data is turned on\n",
+				    __func__, member->dsp->name);
+			goto conf_software;
+		}
+		/* check if pipeline exists */
+		if (member->dsp->pipeline.inuse) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "pipeline exists\n", __func__,
+				    member->dsp->name);
+			goto conf_software;
+		}
+		/* check if encryption is enabled */
+		if (member->dsp->bf_enable) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG "%s dsp %s cannot form a "
+				    "conf, because encryption is enabled\n",
+				    __func__, member->dsp->name);
+			goto conf_software;
+		}
+		/* check if member is on a card with PCM support */
+		if (member->dsp->features.pcm_id < 0) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "dsp has no PCM bus\n",
+				    __func__, member->dsp->name);
+			goto conf_software;
+		}
+		/* check if relations are on the same PCM bus */
+		if (member->dsp->features.pcm_id != same_pcm) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s dsp %s cannot form a conf, because "
+				    "dsp is on a different PCM bus than the "
+				    "first dsp\n",
+				    __func__, member->dsp->name);
+			goto conf_software;
+		}
+		/* determine if members are on the same hfc chip */
+		if (same_hfc != member->dsp->features.hfc_id)
+			same_hfc = -1;
+		/* if there are members already in a conference */
+		if (current_conf < 0 && member->dsp->hfc_conf >= 0)
+			current_conf = member->dsp->hfc_conf;
+		/* if any member is not in a conference */
+		if (member->dsp->hfc_conf < 0)
+			all_conf = 0;
+
+		memb++;
+	}
+
+	/* if no member, this is an error */
+	if (memb < 1)
+		return;
+
+	/* one member */
+	if (memb == 1) {
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG
+			    "%s conf %d cannot form a HW conference, "
+			    "because dsp is alone\n", __func__, conf->id);
+		conf->hardware = 0;
+		conf->software = 0;
+		member = list_entry(conf->mlist.next, struct dsp_conf_member,
+			list);
+		dsp = member->dsp;
+		goto one_member;
+	}
+
+	/*
+	 * ok, now we are sure that all members are on the same pcm.
+	 * now we will see if we have only two members, so we can do
+	 * crossconnections, which don't have any limitations.
+	 */
+
+	/* if we have only two members */
+	if (memb == 2) {
+		member = list_entry(conf->mlist.next, struct dsp_conf_member,
+			list);
+		nextm = list_entry(member->list.next, struct dsp_conf_member,
+			list);
+		/* remove HFC conference if enabled */
+		if (member->dsp->hfc_conf >= 0) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s removing %s from HFC conf %d because "
+				    "two parties require only a PCM slot\n",
+				    __func__, member->dsp->name,
+				    member->dsp->hfc_conf);
+			dsp_cmx_hw_message(member->dsp,
+			    MISDN_CTRL_HFC_CONF_SPLIT, 0, 0, 0, 0);
+			member->dsp->hfc_conf = -1;
+		}
+		if (nextm->dsp->hfc_conf >= 0) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s removing %s from HFC conf %d because "
+				    "two parties require only a PCM slot\n",
+				    __func__, nextm->dsp->name,
+				    nextm->dsp->hfc_conf);
+			dsp_cmx_hw_message(nextm->dsp,
+			    MISDN_CTRL_HFC_CONF_SPLIT, 0, 0, 0, 0);
+			nextm->dsp->hfc_conf = -1;
+		}
+		/* if members have two banks (and not on the same chip) */
+		if (member->dsp->features.pcm_banks > 1 &&
+		    nextm->dsp->features.pcm_banks > 1 &&
+		    member->dsp->features.hfc_id !=
+		    nextm->dsp->features.hfc_id) {
+			/* if both members have same slots with crossed banks */
+			if (member->dsp->pcm_slot_tx >= 0 &&
+			    member->dsp->pcm_slot_rx >= 0 &&
+			    nextm->dsp->pcm_slot_tx >= 0 &&
+			    nextm->dsp->pcm_slot_rx >= 0 &&
+			    nextm->dsp->pcm_slot_tx ==
+			    member->dsp->pcm_slot_rx &&
+			    nextm->dsp->pcm_slot_rx ==
+			    member->dsp->pcm_slot_tx &&
+			    nextm->dsp->pcm_slot_tx ==
+			    member->dsp->pcm_slot_tx &&
+			    member->dsp->pcm_bank_tx !=
+			    member->dsp->pcm_bank_rx &&
+			    nextm->dsp->pcm_bank_tx !=
+			    nextm->dsp->pcm_bank_rx) {
+				/* all members have same slot */
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG
+					    "%s dsp %s & %s stay joined on "
+					    "PCM slot %d bank %d (TX) bank %d "
+					    "(RX) (on different chips)\n",
+					    __func__,
+					    member->dsp->name,
+					    nextm->dsp->name,
+					    member->dsp->pcm_slot_tx,
+					    member->dsp->pcm_bank_tx,
+					    member->dsp->pcm_bank_rx);
+				conf->hardware = 0;
+				conf->software = 1;
+				return;
+			}
+			/* find a new slot */
+			memset(freeslots, 1, sizeof(freeslots));
+			list_for_each_entry(dsp, &dsp_ilist, list) {
+				if (dsp != member->dsp &&
+				    dsp != nextm->dsp &&
+				    member->dsp->features.pcm_id ==
+				    dsp->features.pcm_id) {
+					if (dsp->pcm_slot_rx >= 0 &&
+					    dsp->pcm_slot_rx <
+					    sizeof(freeslots))
+						freeslots[dsp->pcm_slot_tx] = 0;
+					if (dsp->pcm_slot_tx >= 0 &&
+					    dsp->pcm_slot_tx <
+					    sizeof(freeslots))
+						freeslots[dsp->pcm_slot_rx] = 0;
+				}
+			}
+			i = 0;
+			ii = member->dsp->features.pcm_slots;
+			while (i < ii) {
+				if (freeslots[i])
+					break;
+				i++;
+			}
+			if (i == ii) {
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG
+					    "%s no slot available for "
+					    "%s & %s\n", __func__,
+					    member->dsp->name,
+					    nextm->dsp->name);
+				/* no more slots available */
+				goto conf_software;
+			}
+			/* assign free slot */
+			member->dsp->pcm_slot_tx = i;
+			member->dsp->pcm_slot_rx = i;
+			nextm->dsp->pcm_slot_tx = i;
+			nextm->dsp->pcm_slot_rx = i;
+			member->dsp->pcm_bank_rx = 0;
+			member->dsp->pcm_bank_tx = 1;
+			nextm->dsp->pcm_bank_rx = 1;
+			nextm->dsp->pcm_bank_tx = 0;
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s adding %s & %s to new PCM slot %d "
+				    "(TX and RX on different chips) because "
+				    "both members have not same slots\n",
+				    __func__,
+				    member->dsp->name,
+				    nextm->dsp->name,
+				    member->dsp->pcm_slot_tx);
+			dsp_cmx_hw_message(member->dsp, MISDN_CTRL_HFC_PCM_CONN,
+			    member->dsp->pcm_slot_tx, member->dsp->pcm_bank_tx,
+			    member->dsp->pcm_slot_rx, member->dsp->pcm_bank_rx);
+			dsp_cmx_hw_message(nextm->dsp, MISDN_CTRL_HFC_PCM_CONN,
+			    nextm->dsp->pcm_slot_tx, nextm->dsp->pcm_bank_tx,
+			    nextm->dsp->pcm_slot_rx, nextm->dsp->pcm_bank_rx);
+			conf->hardware = 1;
+			conf->software = 0;
+			return;
+		/* if members have one bank (or on the same chip) */
+		} else {
+			/* if both members have different crossed slots */
+			if (member->dsp->pcm_slot_tx >= 0 &&
+			    member->dsp->pcm_slot_rx >= 0 &&
+			    nextm->dsp->pcm_slot_tx >= 0 &&
+			    nextm->dsp->pcm_slot_rx >= 0 &&
+			    nextm->dsp->pcm_slot_tx ==
+			    member->dsp->pcm_slot_rx &&
+			    nextm->dsp->pcm_slot_rx ==
+			    member->dsp->pcm_slot_tx &&
+			    member->dsp->pcm_slot_tx !=
+			    member->dsp->pcm_slot_rx &&
+			    member->dsp->pcm_bank_tx == 0 &&
+			    member->dsp->pcm_bank_rx == 0 &&
+			    nextm->dsp->pcm_bank_tx == 0 &&
+			    nextm->dsp->pcm_bank_rx == 0) {
+				/* all members have same slot */
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG
+					    "%s dsp %s & %s stay joined on PCM "
+					    "slot %d (TX) %d (RX) on same chip "
+					    "or one bank PCM)\n", __func__,
+					    member->dsp->name,
+					    nextm->dsp->name,
+					    member->dsp->pcm_slot_tx,
+					    member->dsp->pcm_slot_rx);
+				conf->hardware = 0;
+				conf->software = 1;
+				return;
+			}
+			/* find two new slot */
+			memset(freeslots, 1, sizeof(freeslots));
+			list_for_each_entry(dsp, &dsp_ilist, list) {
+				if (dsp != member->dsp &&
+				    dsp != nextm->dsp &&
+				    member->dsp->features.pcm_id ==
+				    dsp->features.pcm_id) {
+					if (dsp->pcm_slot_rx >= 0 &&
+					    dsp->pcm_slot_rx <
+					    sizeof(freeslots))
+						freeslots[dsp->pcm_slot_tx] = 0;
+					if (dsp->pcm_slot_tx >= 0 &&
+					    dsp->pcm_slot_tx <
+					    sizeof(freeslots))
+						freeslots[dsp->pcm_slot_rx] = 0;
+				}
+			}
+			i1 = 0;
+			ii = member->dsp->features.pcm_slots;
+			while (i1 < ii) {
+				if (freeslots[i1])
+					break;
+				i1++;
+			}
+			if (i1 == ii) {
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG
+					    "%s no slot available "
+					    "for %s & %s\n", __func__,
+					    member->dsp->name,
+					    nextm->dsp->name);
+				/* no more slots available */
+				goto conf_software;
+			}
+			i2 = i1+1;
+			while (i2 < ii) {
+				if (freeslots[i2])
+					break;
+				i2++;
+			}
+			if (i2 == ii) {
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG
+					    "%s no slot available "
+					    "for %s & %s\n",
+					    __func__,
+					    member->dsp->name,
+					    nextm->dsp->name);
+				/* no more slots available */
+				goto conf_software;
+			}
+			/* assign free slots */
+			member->dsp->pcm_slot_tx = i1;
+			member->dsp->pcm_slot_rx = i2;
+			nextm->dsp->pcm_slot_tx = i2;
+			nextm->dsp->pcm_slot_rx = i1;
+			member->dsp->pcm_bank_rx = 0;
+			member->dsp->pcm_bank_tx = 0;
+			nextm->dsp->pcm_bank_rx = 0;
+			nextm->dsp->pcm_bank_tx = 0;
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s adding %s & %s to new PCM slot %d "
+				    "(TX) %d (RX) on same chip or one bank "
+				    "PCM, because both members have not "
+				    "crossed slots\n", __func__,
+				    member->dsp->name,
+				    nextm->dsp->name,
+				    member->dsp->pcm_slot_tx,
+				    member->dsp->pcm_slot_rx);
+			dsp_cmx_hw_message(member->dsp, MISDN_CTRL_HFC_PCM_CONN,
+			    member->dsp->pcm_slot_tx, member->dsp->pcm_bank_tx,
+			    member->dsp->pcm_slot_rx, member->dsp->pcm_bank_rx);
+			dsp_cmx_hw_message(nextm->dsp, MISDN_CTRL_HFC_PCM_CONN,
+			    nextm->dsp->pcm_slot_tx, nextm->dsp->pcm_bank_tx,
+			    nextm->dsp->pcm_slot_rx, nextm->dsp->pcm_bank_rx);
+			conf->hardware = 1;
+			conf->software = 0;
+			return;
+		}
+	}
+
+	/*
+	 * if we have more than two, we may check if we have a conference
+	 * unit available on the chip. also all members must be on the same
+	 */
+
+	/* if not the same HFC chip */
+	if (same_hfc < 0) {
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG
+			    "%s conference %d cannot be formed, because "
+			    "members are on different chips or not "
+			    "on HFC chip\n",
+			    __func__, conf->id);
+		goto conf_software;
+	}
+
+	/* for more than two members.. */
+
+	/* in case of hdlc, we change to software */
+	if (dsp->hdlc)
+		goto conf_software;
+
+	/* if all members already have the same conference */
+	if (all_conf)
+		return;
+
+	/*
+	 * if there is an existing conference, but not all members have joined
+	 */
+	if (current_conf >= 0) {
+join_members:
+		list_for_each_entry(member, &conf->mlist, list) {
+			/* join to current conference */
+			if (member->dsp->hfc_conf == current_conf)
+				continue;
+			/* get a free timeslot first */
+			memset(freeslots, 1, sizeof(freeslots));
+			list_for_each_entry(dsp, &dsp_ilist, list) {
+				/*
+				 * not checking current member, because
+				 * slot will be overwritten.
+				 */
+				if (
+				    dsp != member->dsp &&
+				/* dsp must be on the same PCM */
+				    member->dsp->features.pcm_id ==
+				    dsp->features.pcm_id) {
+					/* dsp must be on a slot */
+					if (dsp->pcm_slot_tx >= 0 &&
+					    dsp->pcm_slot_tx <
+					    sizeof(freeslots))
+						freeslots[dsp->pcm_slot_tx] = 0;
+					if (dsp->pcm_slot_rx >= 0 &&
+					    dsp->pcm_slot_rx <
+					    sizeof(freeslots))
+						freeslots[dsp->pcm_slot_rx] = 0;
+				}
+			}
+			i = 0;
+			ii = member->dsp->features.pcm_slots;
+			while (i < ii) {
+				if (freeslots[i])
+					break;
+				i++;
+			}
+			if (i == ii) {
+				/* no more slots available */
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG
+					    "%s conference %d cannot be formed,"
+					    " because no slot free\n",
+					    __func__, conf->id);
+				goto conf_software;
+			}
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "%s changing dsp %s to HW conference "
+				    "%d slot %d\n", __func__,
+				    member->dsp->name, current_conf, i);
+			/* assign free slot & set PCM & join conf */
+			member->dsp->pcm_slot_tx = i;
+			member->dsp->pcm_slot_rx = i;
+			member->dsp->pcm_bank_tx = 2; /* loop */
+			member->dsp->pcm_bank_rx = 2;
+			member->dsp->hfc_conf = current_conf;
+			dsp_cmx_hw_message(member->dsp, MISDN_CTRL_HFC_PCM_CONN,
+			    i, 2, i, 2);
+			dsp_cmx_hw_message(member->dsp,
+			    MISDN_CTRL_HFC_CONF_JOIN, current_conf, 0, 0, 0);
+		}
+		return;
+	}
+
+	/*
+	 * no member is in a conference yet, so we find a free one
+	 */
+	memset(freeunits, 1, sizeof(freeunits));
+	list_for_each_entry(dsp, &dsp_ilist, list) {
+		/* dsp must be on the same chip */
+		if (dsp->features.hfc_id == same_hfc &&
+		    /* dsp must have joined a HW conference */
+		    dsp->hfc_conf >= 0 &&
+		    /* slot must be within range */
+		    dsp->hfc_conf < 8)
+			freeunits[dsp->hfc_conf] = 0;
+	}
+	i = 0;
+	ii = 8;
+	while (i < ii) {
+		if (freeunits[i])
+			break;
+		i++;
+	}
+	if (i == ii) {
+		/* no more conferences available */
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG
+			    "%s conference %d cannot be formed, because "
+			    "no conference number free\n",
+			    __func__, conf->id);
+		goto conf_software;
+	}
+	/* join all members */
+	current_conf = i;
+	goto join_members;
+}
+
+
+/*
+ * conf_id != 0: join or change conference
+ * conf_id == 0: split from conference if not already
+ */
+int
+dsp_cmx_conf(struct dsp *dsp, u32 conf_id)
+{
+	int err;
+	struct dsp_conf *conf;
+	struct dsp_conf_member	*member;
+
+	/* if conference doesn't change */
+	if (dsp->conf_id == conf_id)
+		return 0;
+
+	/* first remove us from current conf */
+	if (dsp->conf_id) {
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG "removing us from conference %d\n",
+				dsp->conf->id);
+		/* remove us from conf */
+		conf = dsp->conf;
+		err = dsp_cmx_del_conf_member(dsp);
+		if (err)
+			return err;
+		dsp->conf_id = 0;
+
+		/* update hardware */
+		dsp_cmx_hardware(NULL, dsp);
+
+		/* conf now empty? */
+		if (list_empty(&conf->mlist)) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "conference is empty, so we remove it.\n");
+			err = dsp_cmx_del_conf(conf);
+			if (err)
+				return err;
+		} else {
+			/* update members left on conf */
+			dsp_cmx_hardware(conf, NULL);
+		}
+	}
+
+	/* if split */
+	if (!conf_id)
+		return 0;
+
+	/* now add us to conf */
+	if (dsp_debug & DEBUG_DSP_CMX)
+		printk(KERN_DEBUG "searching conference %d\n",
+			conf_id);
+	conf = dsp_cmx_search_conf(conf_id);
+	if (!conf) {
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG
+			    "conference doesn't exist yet, creating.\n");
+		/* the conference doesn't exist, so we create */
+		conf = dsp_cmx_new_conf(conf_id);
+		if (!conf)
+			return -EINVAL;
+	} else if (!list_empty(&conf->mlist)) {
+		member = list_entry(conf->mlist.next, struct dsp_conf_member,
+			list);
+		if (dsp->hdlc && !member->dsp->hdlc) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "cannot join transparent conference.\n");
+			return -EINVAL;
+		}
+		if (!dsp->hdlc && member->dsp->hdlc) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "cannot join hdlc conference.\n");
+			return -EINVAL;
+		}
+	}
+	/* add conference member */
+	err = dsp_cmx_add_conf_member(dsp, conf);
+	if (err)
+		return err;
+	dsp->conf_id = conf_id;
+
+	/* if we are alone, we do nothing! */
+	if (list_empty(&conf->mlist)) {
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG
+			    "we are alone in this conference, so exit.\n");
+		/* update hardware */
+		dsp_cmx_hardware(NULL, dsp);
+		return 0;
+	}
+
+	/* update members on conf */
+	dsp_cmx_hardware(conf, NULL);
+
+	return 0;
+}
+
+
+/*
+ * audio data is received from card
+ */
+void
+dsp_cmx_receive(struct dsp *dsp, struct sk_buff *skb)
+{
+	u8 *d, *p;
+	int len = skb->len;
+	struct mISDNhead *hh = mISDN_HEAD_P(skb);
+	int w, i, ii;
+
+	/* check if we have sompen */
+	if (len < 1)
+		return;
+
+	/* half of the buffer should be larger than maximum packet size */
+	if (len >= CMX_BUFF_HALF) {
+		printk(KERN_ERR
+		    "%s line %d: packet from card is too large (%d bytes). "
+		    "please make card send smaller packets OR increase "
+		    "CMX_BUFF_SIZE\n", __FILE__, __LINE__, len);
+		return;
+	}
+
+	/*
+	 * initialize pointers if not already -
+	 * also add delay if requested by PH_SIGNAL
+	 */
+	if (dsp->rx_init) {
+		dsp->rx_init = 0;
+		if (dsp->features.unordered) {
+			dsp->rx_R = (hh->id & CMX_BUFF_MASK);
+			dsp->rx_W = (dsp->rx_R + dsp->cmx_delay)
+				& CMX_BUFF_MASK;
+		} else {
+			dsp->rx_R = 0;
+			dsp->rx_W = dsp->cmx_delay;
+		}
+	}
+	/* if frame contains time code, write directly */
+	if (dsp->features.unordered) {
+		dsp->rx_W = (hh->id & CMX_BUFF_MASK);
+		/* printk(KERN_DEBUG "%s %08x\n", dsp->name, hh->id); */
+	}
+	/*
+	 * if we underrun (or maybe overrun),
+	 * we set our new read pointer, and write silence to buffer
+	 */
+	if (((dsp->rx_W-dsp->rx_R) & CMX_BUFF_MASK) >= CMX_BUFF_HALF) {
+		if (dsp_debug & DEBUG_DSP_CMX)
+			printk(KERN_DEBUG
+			    "cmx_receive(dsp=%lx): UNDERRUN (or overrun the "
+			    "maximum delay), adjusting read pointer! "
+			    "(inst %s)\n", (u_long)dsp, dsp->name);
+		/* flush buffer */
+		if (dsp->features.unordered) {
+			dsp->rx_R = (hh->id & CMX_BUFF_MASK);
+			dsp->rx_W = (dsp->rx_R + dsp->cmx_delay)
+				& CMX_BUFF_MASK;
+		} else {
+			dsp->rx_R = 0;
+			dsp->rx_W = dsp->cmx_delay;
+		}
+		memset(dsp->rx_buff, dsp_silence, sizeof(dsp->rx_buff));
+	}
+	/* if we have reached double delay, jump back to middle */
+	if (dsp->cmx_delay)
+		if (((dsp->rx_W - dsp->rx_R) & CMX_BUFF_MASK) >=
+		    (dsp->cmx_delay << 1)) {
+			if (dsp_debug & DEBUG_DSP_CMX)
+				printk(KERN_DEBUG
+				    "cmx_receive(dsp=%lx): OVERRUN (because "
+				    "twice the delay is reached), adjusting "
+				    "read pointer! (inst %s)\n",
+				    (u_long)dsp, dsp->name);
+		/* flush buffer */
+		if (dsp->features.unordered) {
+			dsp->rx_R = (hh->id & CMX_BUFF_MASK);
+			dsp->rx_W = (dsp->rx_R + dsp->cmx_delay)
+				& CMX_BUFF_MASK;
+		} else {
+			dsp->rx_R = 0;
+			dsp->rx_W = dsp->cmx_delay;
+		}
+		memset(dsp->rx_buff, dsp_silence, sizeof(dsp->rx_buff));
+	}
+
+	/* show where to write */
+#ifdef CMX_DEBUG
+	printk(KERN_DEBUG
+	    "cmx_receive(dsp=%lx): rx_R(dsp)=%05x rx_W(dsp)=%05x len=%d %s\n",
+	    (u_long)dsp, dsp->rx_R, dsp->rx_W, len, dsp->name);
+#endif
+
+	/* write data into rx_buffer */
+	p = skb->data;
+	d = dsp->rx_buff;
+	w = dsp->rx_W;
+	i = 0;
+	ii = len;
+	while (i < ii) {
+		d[w++ & CMX_BUFF_MASK] = *p++;
+		i++;
+	}
+
+	/* increase write-pointer */
+	dsp->rx_W = ((dsp->rx_W+len) & CMX_BUFF_MASK);
+}
+
+
+/*
+ * send (mixed) audio data to card and control jitter
+ */
+static void
+dsp_cmx_send_member(struct dsp *dsp, int len, s32 *c, int members)
+{
+	struct dsp_conf *conf = dsp->conf;
+	struct dsp *member, *other;
+	register s32 sample;
+	u8 *d, *p, *q, *o_q;
+	struct sk_buff *nskb, *txskb;
+	int r, rr, t, tt, o_r, o_rr;
+	int preload = 0;
+	struct mISDNhead *hh, *thh;
+
+	/* don't process if: */
+	if (!dsp->b_active) { /* if not active */
+		dsp->last_tx = 0;
+		return;
+	}
+	if (dsp->pcm_slot_tx >= 0 && /* connected to pcm slot */
+	    dsp->tx_R == dsp->tx_W && /* AND no tx-data */
+	    !(dsp->tone.tone && dsp->tone.software)) { /* AND not soft tones */
+		dsp->last_tx = 0;
+		return;
+	}
+
+#ifdef CMX_DEBUG
+	printk(KERN_DEBUG
+	    "SEND members=%d dsp=%s, conf=%p, rx_R=%05x rx_W=%05x\n",
+	    members, dsp->name, conf, dsp->rx_R, dsp->rx_W);
+#endif
+
+	/* preload if we have delay set */
+	if (dsp->cmx_delay && !dsp->last_tx) {
+		preload = len;
+		if (preload < 128)
+			preload = 128;
+	}
+
+	/* PREPARE RESULT */
+	nskb = mI_alloc_skb(len + preload, GFP_ATOMIC);
+	if (!nskb) {
+		printk(KERN_ERR
+		    "FATAL ERROR in mISDN_dsp.o: cannot alloc %d bytes\n",
+		    len + preload);
+		return;
+	}
+	hh = mISDN_HEAD_P(nskb);
+	hh->prim = PH_DATA_REQ;
+	hh->id = 0;
+	dsp->last_tx = 1;
+
+	/* set pointers, indexes and stuff */
+	member = dsp;
+	p = dsp->tx_buff; /* transmit data */
+	q = dsp->rx_buff; /* received data */
+	d = skb_put(nskb, preload + len); /* result */
+	t = dsp->tx_R; /* tx-pointers */
+	tt = dsp->tx_W;
+	r = dsp->rx_R; /* rx-pointers */
+	rr = (r + len) & CMX_BUFF_MASK;
+
+	/* preload with silence, if required */
+	if (preload) {
+		memset(d, dsp_silence, preload);
+		d += preload;
+	}
+
+	/* PROCESS TONES/TX-DATA ONLY */
+	if (dsp->tone.tone && dsp->tone.software) {
+		/* -> copy tone */
+		dsp_tone_copy(dsp, d, len);
+		dsp->tx_R = 0; /* clear tx buffer */
+		dsp->tx_W = 0;
+		goto send_packet;
+	}
+	/* if we have tx-data but do not use mixing */
+	if (!dsp->tx_mix && t != tt) {
+		/* -> send tx-data and continue when not enough */
+#ifdef CMX_TX_DEBUG
+	sprintf(debugbuf, "TX sending (%04x-%04x)%p: ", t, tt, p);
+#endif
+		while (r != rr && t != tt) {
+#ifdef CMX_TX_DEBUG
+			if (strlen(debugbuf) < 48)
+			    sprintf(debugbuf+strlen(debugbuf), " %02x", p[t]);
+#endif
+			*d++ = p[t]; /* write tx_buff */
+			t = (t+1) & CMX_BUFF_MASK;
+			r = (r+1) & CMX_BUFF_MASK;
+		}
+		if (r == rr) {
+			dsp->tx_R = t;
+#ifdef CMX_TX_DEBUG
+	printk(KERN_DEBUG "%s\n", debugbuf);
+#endif
+			goto send_packet;
+		}
+	}
+#ifdef CMX_TX_DEBUG
+	printk(KERN_DEBUG "%s\n", debugbuf);
+#endif
+
+	/* PROCESS DATA (one member / no conf) */
+	if (!conf || members <= 1) {
+		/* -> if echo is NOT enabled */
+		if (!dsp->echo) {
+			/* -> send tx-data if available or use 0-volume */
+			while (r != rr && t != tt) {
+				*d++ = p[t]; /* write tx_buff */
+				t = (t+1) & CMX_BUFF_MASK;
+				r = (r+1) & CMX_BUFF_MASK;
+			}
+			if (r != rr)
+				memset(d, dsp_silence, (rr-r)&CMX_BUFF_MASK);
+		/* -> if echo is enabled */
+		} else {
+			/*
+			 * -> mix tx-data with echo if available,
+			 * or use echo only
+			 */
+			while (r != rr && t != tt) {
+				*d++ = dsp_audio_mix_law[(p[t]<<8)|q[r]];
+				t = (t+1) & CMX_BUFF_MASK;
+				r = (r+1) & CMX_BUFF_MASK;
+			}
+			while (r != rr) {
+				*d++ = q[r]; /* echo */
+				r = (r+1) & CMX_BUFF_MASK;
+			}
+		}
+		dsp->tx_R = t;
+		goto send_packet;
+	}
+	/* PROCESS DATA (two members) */
+#ifdef CMX_CONF_DEBUG
+	if (0) {
+#else
+	if (members == 2) {
+#endif
+		/* "other" becomes other party */
+		other = (list_entry(conf->mlist.next,
+		    struct dsp_conf_member, list))->dsp;
+		if (other == member)
+			other = (list_entry(conf->mlist.prev,
+			    struct dsp_conf_member, list))->dsp;
+		o_q = other->rx_buff; /* received data */
+		o_rr = (other->rx_R + len) & CMX_BUFF_MASK;
+			/* end of rx-pointer */
+		o_r = (o_rr - rr + r) & CMX_BUFF_MASK;
+			/* start rx-pointer at current read position*/
+		/* -> if echo is NOT enabled */
+		if (!dsp->echo) {
+			/*
+			 * -> copy other member's rx-data,
+			 * if tx-data is available, mix
+			 */
+			while (o_r != o_rr && t != tt) {
+				*d++ = dsp_audio_mix_law[(p[t]<<8)|o_q[o_r]];
+				t = (t+1) & CMX_BUFF_MASK;
+				o_r = (o_r+1) & CMX_BUFF_MASK;
+			}
+			while (o_r != o_rr) {
+				*d++ = o_q[o_r];
+				o_r = (o_r+1) & CMX_BUFF_MASK;
+			}
+		/* -> if echo is enabled */
+		} else {
+			/*
+			 * -> mix other member's rx-data with echo,
+			 * if tx-data is available, mix
+			 */
+			while (r != rr && t != tt) {
+				sample = dsp_audio_law_to_s32[p[t]] +
+				    dsp_audio_law_to_s32[q[r]] +
+				    dsp_audio_law_to_s32[o_q[o_r]];
+				if (sample < -32768)
+					sample = -32768;
+				else if (sample > 32767)
+					sample = 32767;
+				*d++ = dsp_audio_s16_to_law[sample & 0xffff];
+				    /* tx-data + rx_data + echo */
+				t = (t+1) & CMX_BUFF_MASK;
+				r = (r+1) & CMX_BUFF_MASK;
+				o_r = (o_r+1) & CMX_BUFF_MASK;
+			}
+			while (r != rr) {
+				*d++ = dsp_audio_mix_law[(q[r]<<8)|o_q[o_r]];
+				r = (r+1) & CMX_BUFF_MASK;
+				o_r = (o_r+1) & CMX_BUFF_MASK;
+			}
+		}
+		dsp->tx_R = t;
+		goto send_packet;
+	}
+#ifdef DSP_NEVER_DEFINED
+	}
+#endif
+	/* PROCESS DATA (three or more members) */
+	/* -> if echo is NOT enabled */
+	if (!dsp->echo) {
+		/*
+		 * -> substract rx-data from conf-data,
+		 * if tx-data is available, mix
+		 */
+		while (r != rr && t != tt) {
+			sample = dsp_audio_law_to_s32[p[t]] + *c++ -
+			    dsp_audio_law_to_s32[q[r]];
+			if (sample < -32768)
+				sample = -32768;
+			else if (sample > 32767)
+				sample = 32767;
+			*d++ = dsp_audio_s16_to_law[sample & 0xffff];
+			    /* conf-rx+tx */
+			r = (r+1) & CMX_BUFF_MASK;
+			t = (t+1) & CMX_BUFF_MASK;
+		}
+		while (r != rr) {
+			sample = *c++ - dsp_audio_law_to_s32[q[r]];
+			if (sample < -32768)
+				sample = -32768;
+			else if (sample > 32767)
+				sample = 32767;
+			*d++ = dsp_audio_s16_to_law[sample & 0xffff];
+			    /* conf-rx */
+			r = (r+1) & CMX_BUFF_MASK;
+		}
+	/* -> if echo is enabled */
+	} else {
+		/*
+		 * -> encode conf-data, if tx-data
+		 * is available, mix
+		 */
+		while (r != rr && t != tt) {
+			sample = dsp_audio_law_to_s32[p[t]] + *c++;
+			if (sample < -32768)
+				sample = -32768;
+			else if (sample > 32767)
+				sample = 32767;
+			*d++ = dsp_audio_s16_to_law[sample & 0xffff];
+			    /* conf(echo)+tx */
+			t = (t+1) & CMX_BUFF_MASK;
+			r = (r+1) & CMX_BUFF_MASK;
+		}
+		while (r != rr) {
+			sample = *c++;
+			if (sample < -32768)
+				sample = -32768;
+			else if (sample > 32767)
+				sample = 32767;
+			*d++ = dsp_audio_s16_to_law[sample & 0xffff];
+			    /* conf(echo) */
+			r = (r+1) & CMX_BUFF_MASK;
+		}
+	}
+	dsp->tx_R = t;
+	goto send_packet;
+
+send_packet:
+	/*
+	 * send tx-data if enabled - don't filter,
+	 * becuase we want what we send, not what we filtered
+	 */
+	if (dsp->tx_data) {
+		/* PREPARE RESULT */
+		txskb = mI_alloc_skb(len, GFP_ATOMIC);
+		if (!txskb) {
+			printk(KERN_ERR
+			    "FATAL ERROR in mISDN_dsp.o: "
+			    "cannot alloc %d bytes\n", len);
+		} else {
+			thh = mISDN_HEAD_P(txskb);
+			thh->prim = DL_DATA_REQ;
+			thh->id = 0;
+			memcpy(skb_put(txskb, len), nskb->data+preload, len);
+			/* queue (trigger later) */
+			skb_queue_tail(&dsp->sendq, txskb);
+		}
+	}
+	/* adjust volume */
+	if (dsp->tx_volume)
+		dsp_change_volume(nskb, dsp->tx_volume);
+	/* pipeline */
+	if (dsp->pipeline.inuse)
+		dsp_pipeline_process_tx(&dsp->pipeline, nskb->data, nskb->len);
+	/* crypt */
+	if (dsp->bf_enable)
+		dsp_bf_encrypt(dsp, nskb->data, nskb->len);
+	/* queue and trigger */
+	skb_queue_tail(&dsp->sendq, nskb);
+	schedule_work(&dsp->workq);
+}
+
+u32	samplecount;
+struct timer_list dsp_spl_tl;
+u32	dsp_spl_jiffies; /* calculate the next time to fire */
+u32	dsp_start_jiffies; /* jiffies at the time, the calculation begins */
+struct timeval dsp_start_tv; /* time at start of calculation */
+
+void
+dsp_cmx_send(void *arg)
+{
+	struct dsp_conf *conf;
+	struct dsp_conf_member *member;
+	struct dsp *dsp;
+	int mustmix, members;
+	s32 mixbuffer[MAX_POLL+100], *c;
+	u8 *p, *q;
+	int r, rr;
+	int jittercheck = 0, delay, i;
+	u_long flags;
+	struct timeval tv;
+	u32 elapsed;
+	s16 length;
+
+	/* lock */
+	spin_lock_irqsave(&dsp_lock, flags);
+
+	if (!dsp_start_tv.tv_sec) {
+		do_gettimeofday(&dsp_start_tv);
+		length = dsp_poll;
+	} else {
+		do_gettimeofday(&tv);
+		elapsed = ((tv.tv_sec - dsp_start_tv.tv_sec) * 8000)
+		    + ((s32)(tv.tv_usec / 125) - (dsp_start_tv.tv_usec / 125));
+		dsp_start_tv.tv_sec = tv.tv_sec;
+		dsp_start_tv.tv_usec = tv.tv_usec;
+		length = elapsed;
+	}
+	if (length > MAX_POLL + 100)
+		length = MAX_POLL + 100;
+/* printk(KERN_DEBUG "len=%d dsp_count=0x%x.%04x dsp_poll_diff=0x%x.%04x\n",
+ length, dsp_count >> 16, dsp_count & 0xffff, dsp_poll_diff >> 16,
+ dsp_poll_diff & 0xffff);
+ */
+
+	/*
+	 * check if jitter needs to be checked
+	 * (this is about every second = 8192 samples)
+	 */
+	samplecount += length;
+	if ((samplecount & 8191) < length)
+		jittercheck = 1;
+
+	/* loop all members that do not require conference mixing */
+	list_for_each_entry(dsp, &dsp_ilist, list) {
+		if (dsp->hdlc)
+			continue;
+		conf = dsp->conf;
+		mustmix = 0;
+		members = 0;
+		if (conf) {
+			members = count_list_member(&conf->mlist);
+#ifdef CMX_CONF_DEBUG
+			if (conf->software && members > 1)
+#else
+			if (conf->software && members > 2)
+#endif
+				mustmix = 1;
+		}
+
+		/* transmission required */
+		if (!mustmix) {
+			dsp_cmx_send_member(dsp, length, mixbuffer, members);
+
+			/*
+			 * unused mixbuffer is given to prevent a
+			 * potential null-pointer-bug
+			 */
+		}
+	}
+
+	/* loop all members that require conference mixing */
+	list_for_each_entry(conf, &conf_ilist, list) {
+		/* count members and check hardware */
+		members = count_list_member(&conf->mlist);
+#ifdef CMX_CONF_DEBUG
+		if (conf->software && members > 1) {
+#else
+		if (conf->software && members > 2) {
+#endif
+			/* check for hdlc conf */
+			member = list_entry(conf->mlist.next,
+				struct dsp_conf_member, list);
+			if (member->dsp->hdlc)
+				continue;
+			/* mix all data */
+			memset(mixbuffer, 0, length*sizeof(s32));
+			list_for_each_entry(member, &conf->mlist, list) {
+				dsp = member->dsp;
+				/* get range of data to mix */
+				c = mixbuffer;
+				q = dsp->rx_buff;
+				r = dsp->rx_R;
+				rr = (r + length) & CMX_BUFF_MASK;
+				/* add member's data */
+				while (r != rr) {
+					*c++ += dsp_audio_law_to_s32[q[r]];
+					r = (r+1) & CMX_BUFF_MASK;
+				}
+			}
+
+			/* process each member */
+			list_for_each_entry(member, &conf->mlist, list) {
+				/* transmission */
+				dsp_cmx_send_member(member->dsp, length,
+				    mixbuffer, members);
+			}
+		}
+	}
+
+	/* delete rx-data, increment buffers, change pointers */
+	list_for_each_entry(dsp, &dsp_ilist, list) {
+		if (dsp->hdlc)
+			continue;
+		p = dsp->rx_buff;
+		q = dsp->tx_buff;
+		r = dsp->rx_R;
+		/* move receive pointer when receiving */
+		if (!dsp->rx_is_off) {
+			rr = (r + length) & CMX_BUFF_MASK;
+			/* delete rx-data */
+			while (r != rr) {
+				p[r] = dsp_silence;
+				r = (r+1) & CMX_BUFF_MASK;
+			}
+			/* increment rx-buffer pointer */
+			dsp->rx_R = r; /* write incremented read pointer */
+		}
+
+		/* check current rx_delay */
+		delay = (dsp->rx_W-dsp->rx_R) & CMX_BUFF_MASK;
+		if (delay >= CMX_BUFF_HALF)
+			delay = 0; /* will be the delay before next write */
+		/* check for lower delay */
+		if (delay < dsp->rx_delay[0])
+			dsp->rx_delay[0] = delay;
+		/* check current tx_delay */
+		delay = (dsp->tx_W-dsp->tx_R) & CMX_BUFF_MASK;
+		if (delay >= CMX_BUFF_HALF)
+			delay = 0; /* will be the delay before next write */
+		/* check for lower delay */
+		if (delay < dsp->tx_delay[0])
+			dsp->tx_delay[0] = delay;
+		if (jittercheck) {
+			/* find the lowest of all rx_delays */
+			delay = dsp->rx_delay[0];
+			i = 1;
+			while (i < MAX_SECONDS_JITTER_CHECK) {
+				if (delay > dsp->rx_delay[i])
+					delay = dsp->rx_delay[i];
+				i++;
+			}
+			/*
+			 * remove rx_delay only if we have delay AND we
+			 * have not preset cmx_delay
+			 */
+			if (delay && !dsp->cmx_delay) {
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG
+					    "%s lowest rx_delay of %d bytes for"
+					    " dsp %s are now removed.\n",
+					    __func__, delay,
+					    dsp->name);
+				r = dsp->rx_R;
+				rr = (r + delay) & CMX_BUFF_MASK;
+				/* delete rx-data */
+				while (r != rr) {
+					p[r] = dsp_silence;
+					r = (r+1) & CMX_BUFF_MASK;
+				}
+				/* increment rx-buffer pointer */
+				dsp->rx_R = r;
+				    /* write incremented read pointer */
+			}
+			/* find the lowest of all tx_delays */
+			delay = dsp->tx_delay[0];
+			i = 1;
+			while (i < MAX_SECONDS_JITTER_CHECK) {
+				if (delay > dsp->tx_delay[i])
+					delay = dsp->tx_delay[i];
+				i++;
+			}
+			/*
+			 * remove delay only if we have delay AND we
+			 * have enabled tx_dejitter
+			 */
+			if (delay && dsp->tx_dejitter) {
+				if (dsp_debug & DEBUG_DSP_CMX)
+					printk(KERN_DEBUG
+					    "%s lowest tx_delay of %d bytes for"
+					    " dsp %s are now removed.\n",
+					    __func__, delay,
+					    dsp->name);
+				r = dsp->tx_R;
+				rr = (r + delay) & CMX_BUFF_MASK;
+				/* delete tx-data */
+				while (r != rr) {
+					q[r] = dsp_silence;
+					r = (r+1) & CMX_BUFF_MASK;
+				}
+				/* increment rx-buffer pointer */
+				dsp->tx_R = r;
+				    /* write incremented read pointer */
+			}
+			/* scroll up delays */
+			i = MAX_SECONDS_JITTER_CHECK - 1;
+			while (i) {
+				dsp->rx_delay[i] = dsp->rx_delay[i-1];
+				dsp->tx_delay[i] = dsp->tx_delay[i-1];
+				i--;
+			}
+			dsp->tx_delay[0] = CMX_BUFF_HALF; /* (infinite) delay */
+			dsp->rx_delay[0] = CMX_BUFF_HALF; /* (infinite) delay */
+		}
+	}
+
+	/* if next event would be in the past ... */
+	if ((s32)(dsp_spl_jiffies+dsp_tics-jiffies) <= 0)
+		dsp_spl_jiffies = jiffies + 1;
+	else
+		dsp_spl_jiffies += dsp_tics;
+
+	dsp_spl_tl.expires = dsp_spl_jiffies;
+	add_timer(&dsp_spl_tl);
+
+	/* unlock */
+	spin_unlock_irqrestore(&dsp_lock, flags);
+}
+
+/*
+ * audio data is transmitted from upper layer to the dsp
+ */
+void
+dsp_cmx_transmit(struct dsp *dsp, struct sk_buff *skb)
+{
+	u_int w, ww;
+	u8 *d, *p;
+	int space; /* todo: , l = skb->len; */
+#ifdef CMX_TX_DEBUG
+	char debugbuf[256] = "";
+#endif
+
+	/* check if there is enough space, and then copy */
+	w = dsp->tx_W;
+	ww = dsp->tx_R;
+	p = dsp->tx_buff;
+	d = skb->data;
+	space = ww-w;
+	if (space <= 0)
+		space += CMX_BUFF_SIZE;
+	/* write-pointer should not overrun nor reach read pointer */
+	if (space-1 < skb->len)
+		/* write to the space we have left */
+		ww = (ww - 1) & CMX_BUFF_MASK;
+	else
+		/* write until all byte are copied */
+		ww = (w + skb->len) & CMX_BUFF_MASK;
+	dsp->tx_W = ww;
+
+	/* show current buffer */
+#ifdef CMX_DEBUG
+	printk(KERN_DEBUG
+	    "cmx_transmit(dsp=%lx) %d bytes to 0x%x-0x%x. %s\n",
+	    (u_long)dsp, (ww-w)&CMX_BUFF_MASK, w, ww, dsp->name);
+#endif
+
+	/* copy transmit data to tx-buffer */
+#ifdef CMX_TX_DEBUG
+	sprintf(debugbuf, "TX getting (%04x-%04x)%p: ", w, ww, p);
+#endif
+	while (w != ww) {
+#ifdef CMX_TX_DEBUG
+		if (strlen(debugbuf) < 48)
+			sprintf(debugbuf+strlen(debugbuf), " %02x", *d);
+#endif
+		p[w] = *d++;
+		w = (w+1) & CMX_BUFF_MASK;
+	}
+#ifdef CMX_TX_DEBUG
+	printk(KERN_DEBUG "%s\n", debugbuf);
+#endif
+
+}
+
+/*
+ * hdlc data is received from card and sent to all members.
+ */
+void
+dsp_cmx_hdlc(struct dsp *dsp, struct sk_buff *skb)
+{
+	struct sk_buff *nskb = NULL;
+	struct dsp_conf_member *member;
+	struct mISDNhead *hh;
+
+	/* not if not active */
+	if (!dsp->b_active)
+		return;
+
+	/* check if we have sompen */
+	if (skb->len < 1)
+		return;
+
+	/* no conf */
+	if (!dsp->conf) {
+		/* in case of hardware (echo) */
+		if (dsp->pcm_slot_tx >= 0)
+			return;
+		if (dsp->echo)
+			nskb = skb_clone(skb, GFP_ATOMIC);
+			if (nskb) {
+				hh = mISDN_HEAD_P(nskb);
+				hh->prim = PH_DATA_REQ;
+				hh->id = 0;
+				skb_queue_tail(&dsp->sendq, nskb);
+				schedule_work(&dsp->workq);
+			}
+		return;
+	}
+	/* in case of hardware conference */
+	if (dsp->conf->hardware)
+		return;
+	list_for_each_entry(member, &dsp->conf->mlist, list) {
+		if (dsp->echo || member->dsp != dsp) {
+			nskb = skb_clone(skb, GFP_ATOMIC);
+			if (nskb) {
+				hh = mISDN_HEAD_P(nskb);
+				hh->prim = PH_DATA_REQ;
+				hh->id = 0;
+				skb_queue_tail(&member->dsp->sendq, nskb);
+				schedule_work(&member->dsp->workq);
+			}
+		}
+	}
+}
+
+
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
new file mode 100644
index 0000000..2f10ed8
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -0,0 +1,1191 @@
+/*
+ * Author       Andreas Eversberg (jolly@eversberg.eu)
+ * Based on source code structure by
+ *		Karsten Keil (keil@isdn4linux.de)
+ *
+ *		This file is (c) under GNU PUBLIC LICENSE
+ *		For changes and modifications please read
+ *		../../../Documentation/isdn/mISDN.cert
+ *
+ * Thanks to    Karsten Keil (great drivers)
+ *              Cologne Chip (great chips)
+ *
+ * This module does:
+ *		Real-time tone generation
+ *		DTMF detection
+ *		Real-time cross-connection and conferrence
+ *		Compensate jitter due to system load and hardware fault.
+ *		All features are done in kernel space and will be realized
+ *		using hardware, if available and supported by chip set.
+ *		Blowfish encryption/decryption
+ */
+
+/* STRUCTURE:
+ *
+ * The dsp module provides layer 2 for b-channels (64kbit). It provides
+ * transparent audio forwarding with special digital signal processing:
+ *
+ * - (1) generation of tones
+ * - (2) detection of dtmf tones
+ * - (3) crossconnecting and conferences (clocking)
+ * - (4) echo generation for delay test
+ * - (5) volume control
+ * - (6) disable receive data
+ * - (7) pipeline
+ * - (8) encryption/decryption
+ *
+ * Look:
+ *             TX            RX
+ *         ------upper layer------
+ *             |             ^
+ *             |             |(6)
+ *             v             |
+ *       +-----+-------------+-----+
+ *       |(3)(4)                   |
+ *       |           CMX           |
+ *       |                         |
+ *       |           +-------------+
+ *       |           |       ^
+ *       |           |       |
+ *       |+---------+|  +----+----+
+ *       ||(1)      ||  |(2)      |
+ *       ||         ||  |         |
+ *       ||  Tones  ||  |  DTMF   |
+ *       ||         ||  |         |
+ *       ||         ||  |         |
+ *       |+----+----+|  +----+----+
+ *       +-----+-----+       ^
+ *             |             |
+ *             v             |
+ *        +----+----+   +----+----+
+ *        |(5)      |   |(5)      |
+ *        |         |   |         |
+ *        |TX Volume|   |RX Volume|
+ *        |         |   |         |
+ *        |         |   |         |
+ *        +----+----+   +----+----+
+ *             |             ^
+ *             |             |
+ *             v             |
+ *        +----+-------------+----+
+ *        |(7)                    |
+ *        |                       |
+ *        |  Pipeline Processing  |
+ *        |                       |
+ *        |                       |
+ *        +----+-------------+----+
+ *             |             ^
+ *             |             |
+ *             v             |
+ *        +----+----+   +----+----+
+ *        |(8)      |   |(8)      |
+ *        |         |   |         |
+ *        | Encrypt |   | Decrypt |
+ *        |         |   |         |
+ *        |         |   |         |
+ *        +----+----+   +----+----+
+ *             |             ^
+ *             |             |
+ *             v             |
+ *         ------card  layer------
+ *             TX            RX
+ *
+ * Above you can see the logical data flow. If software is used to do the
+ * process, it is actually the real data flow. If hardware is used, data
+ * may not flow, but hardware commands to the card, to provide the data flow
+ * as shown.
+ *
+ * NOTE: The channel must be activated in order to make dsp work, even if
+ * no data flow to the upper layer is intended. Activation can be done
+ * after and before controlling the setting using PH_CONTROL requests.
+ *
+ * DTMF: Will be detected by hardware if possible. It is done before CMX
+ * processing.
+ *
+ * Tones: Will be generated via software if endless looped audio fifos are
+ * not supported by hardware. Tones will override all data from CMX.
+ * It is not required to join a conference to use tones at any time.
+ *
+ * CMX: Is transparent when not used. When it is used, it will do
+ * crossconnections and conferences via software if not possible through
+ * hardware. If hardware capability is available, hardware is used.
+ *
+ * Echo: Is generated by CMX and is used to check performane of hard and
+ * software CMX.
+ *
+ * The CMX has special functions for conferences with one, two and more
+ * members. It will allow different types of data flow. Receive and transmit
+ * data to/form upper layer may be swithed on/off individually without loosing
+ * features of CMX, Tones and DTMF.
+ *
+ * Echo Cancellation: Sometimes we like to cancel echo from the interface.
+ * Note that a VoIP call may not have echo caused by the IP phone. The echo
+ * is generated by the telephone line connected to it. Because the delay
+ * is high, it becomes an echo. RESULT: Echo Cachelation is required if
+ * both echo AND delay is applied to an interface.
+ * Remember that software CMX always generates a more or less delay.
+ *
+ * If all used features can be realized in hardware, and if transmit and/or
+ * receive data ist disabled, the card may not send/receive any data at all.
+ * Not receiving is usefull if only announcements are played. Not sending is
+ * usefull if an answering machine records audio. Not sending and receiving is
+ * usefull during most states of the call. If supported by hardware, tones
+ * will be played without cpu load. Small PBXs and NT-Mode applications will
+ * not need expensive hardware when processing calls.
+ *
+ *
+ * LOCKING:
+ *
+ * When data is received from upper or lower layer (card), the complete dsp
+ * module is locked by a global lock.  This lock MUST lock irq, because it
+ * must lock timer events by DSP poll timer.
+ * When data is ready to be transmitted down, the data is queued and sent
+ * outside lock and timer event.
+ * PH_CONTROL must not change any settings, join or split conference members
+ * during process of data.
+ *
+ * HDLC:
+ *
+ * It works quite the same as transparent, except that HDLC data is forwarded
+ * to all other conference members if no hardware bridging is possible.
+ * Send data will be writte to sendq. Sendq will be sent if confirm is received.
+ * Conference cannot join, if one member is not hdlc.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/mISDNif.h>
+#include <linux/mISDNdsp.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include "core.h"
+#include "dsp.h"
+
+const char *mISDN_dsp_revision = "2.0";
+
+static int debug;
+static int options;
+static int poll;
+static int dtmfthreshold = 100;
+
+MODULE_AUTHOR("Andreas Eversberg");
+module_param(debug, uint, S_IRUGO | S_IWUSR);
+module_param(options, uint, S_IRUGO | S_IWUSR);
+module_param(poll, uint, S_IRUGO | S_IWUSR);
+module_param(dtmfthreshold, uint, S_IRUGO | S_IWUSR);
+MODULE_LICENSE("GPL");
+
+/*int spinnest = 0;*/
+
+spinlock_t dsp_lock; /* global dsp lock */
+struct list_head dsp_ilist;
+struct list_head conf_ilist;
+int dsp_debug;
+int dsp_options;
+int dsp_poll, dsp_tics;
+
+/* check if rx may be turned off or must be turned on */
+static void
+dsp_rx_off_member(struct dsp *dsp)
+{
+	struct mISDN_ctrl_req	cq;
+	int rx_off = 1;
+
+	if (!dsp->features_rx_off)
+		return;
+
+	/* not disabled */
+	if (!dsp->rx_disabled)
+		rx_off = 0;
+	/* software dtmf */
+	else if (dsp->dtmf.software)
+		rx_off = 0;
+	/* echo in software */
+	else if (dsp->echo && dsp->pcm_slot_tx < 0)
+		rx_off = 0;
+	/* bridge in software */
+	else if (dsp->conf) {
+		if (dsp->conf->software)
+			rx_off = 0;
+	}
+
+	if (rx_off == dsp->rx_is_off)
+		return;
+
+	if (!dsp->ch.peer) {
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: no peer, no rx_off\n",
+				__func__);
+		return;
+	}
+	cq.op = MISDN_CTRL_RX_OFF;
+	cq.p1 = rx_off;
+	if (dsp->ch.peer->ctrl(dsp->ch.peer, CONTROL_CHANNEL, &cq)) {
+		printk(KERN_DEBUG "%s: 2nd CONTROL_CHANNEL failed\n",
+			__func__);
+		return;
+	}
+	dsp->rx_is_off = rx_off;
+	if (dsp_debug & DEBUG_DSP_CORE)
+		printk(KERN_DEBUG "%s: %s set rx_off = %d\n",
+			__func__, dsp->name, rx_off);
+}
+static void
+dsp_rx_off(struct dsp *dsp)
+{
+	struct dsp_conf_member	*member;
+
+	if (dsp_options & DSP_OPT_NOHARDWARE)
+		return;
+
+	/* no conf */
+	if (!dsp->conf) {
+		dsp_rx_off_member(dsp);
+		return;
+	}
+	/* check all members in conf */
+	list_for_each_entry(member, &dsp->conf->mlist, list) {
+		dsp_rx_off_member(member->dsp);
+	}
+}
+
+static int
+dsp_control_req(struct dsp *dsp, struct mISDNhead *hh, struct sk_buff *skb)
+{
+	struct		sk_buff *nskb;
+	int ret = 0;
+	int cont;
+	u8 *data;
+	int len;
+
+	if (skb->len < sizeof(int))
+		printk(KERN_ERR "%s: PH_CONTROL message too short\n", __func__);
+	cont = *((int *)skb->data);
+	len = skb->len - sizeof(int);
+	data = skb->data + sizeof(int);
+
+	switch (cont) {
+	case DTMF_TONE_START: /* turn on DTMF */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: start dtmf\n", __func__);
+		if (len == sizeof(int)) {
+			printk(KERN_NOTICE "changing DTMF Threshold "
+				"to %d\n", *((int *)data));
+			dsp->dtmf.treshold = (*(int *)data) * 10000;
+		}
+		/* init goertzel */
+		dsp_dtmf_goertzel_init(dsp);
+
+		/* check dtmf hardware */
+		dsp_dtmf_hardware(dsp);
+		break;
+	case DTMF_TONE_STOP: /* turn off DTMF */
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: stop dtmf\n", __func__);
+		dsp->dtmf.hardware = 0;
+		dsp->dtmf.software = 0;
+		break;
+	case DSP_CONF_JOIN: /* join / update conference */
+		if (len < sizeof(int)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (*((u32 *)data) == 0)
+			goto conf_split;
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: join conference %d\n",
+				__func__, *((u32 *)data));
+		ret = dsp_cmx_conf(dsp, *((u32 *)data));
+			/* dsp_cmx_hardware will also be called here */
+		dsp_rx_off(dsp);
+		if (dsp_debug & DEBUG_DSP_CMX)
+			dsp_cmx_debug(dsp);
+		break;
+	case DSP_CONF_SPLIT: /* remove from conference */
+conf_split:
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: release conference\n", __func__);
+		ret = dsp_cmx_conf(dsp, 0);
+			/* dsp_cmx_hardware will also be called here */
+		if (dsp_debug & DEBUG_DSP_CMX)
+			dsp_cmx_debug(dsp);
+		dsp_rx_off(dsp);
+		break;
+	case DSP_TONE_PATT_ON: /* play tone */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len < sizeof(int)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: turn tone 0x%x on\n",
+				__func__, *((int *)skb->data));
+		ret = dsp_tone(dsp, *((int *)data));
+		if (!ret) {
+			dsp_cmx_hardware(dsp->conf, dsp);
+			dsp_rx_off(dsp);
+		}
+		if (!dsp->tone.tone)
+			goto tone_off;
+		break;
+	case DSP_TONE_PATT_OFF: /* stop tone */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: turn tone off\n", __func__);
+		dsp_tone(dsp, 0);
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_rx_off(dsp);
+		/* reset tx buffers (user space data) */
+tone_off:
+		dsp->rx_W = 0;
+		dsp->rx_R = 0;
+		break;
+	case DSP_VOL_CHANGE_TX: /* change volume */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len < sizeof(int)) {
+			ret = -EINVAL;
+			break;
+		}
+		dsp->tx_volume = *((int *)data);
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: change tx vol to %d\n",
+				__func__, dsp->tx_volume);
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_dtmf_hardware(dsp);
+		dsp_rx_off(dsp);
+		break;
+	case DSP_VOL_CHANGE_RX: /* change volume */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len < sizeof(int)) {
+			ret = -EINVAL;
+			break;
+		}
+		dsp->rx_volume = *((int *)data);
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: change rx vol to %d\n",
+				__func__, dsp->tx_volume);
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_dtmf_hardware(dsp);
+		dsp_rx_off(dsp);
+		break;
+	case DSP_ECHO_ON: /* enable echo */
+		dsp->echo = 1; /* soft echo */
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: enable cmx-echo\n", __func__);
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_rx_off(dsp);
+		if (dsp_debug & DEBUG_DSP_CMX)
+			dsp_cmx_debug(dsp);
+		break;
+	case DSP_ECHO_OFF: /* disable echo */
+		dsp->echo = 0;
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: disable cmx-echo\n", __func__);
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_rx_off(dsp);
+		if (dsp_debug & DEBUG_DSP_CMX)
+			dsp_cmx_debug(dsp);
+		break;
+	case DSP_RECEIVE_ON: /* enable receive to user space */
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: enable receive to user "
+				"space\n", __func__);
+		dsp->rx_disabled = 0;
+		dsp_rx_off(dsp);
+		break;
+	case DSP_RECEIVE_OFF: /* disable receive to user space */
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: disable receive to "
+				"user space\n", __func__);
+		dsp->rx_disabled = 1;
+		dsp_rx_off(dsp);
+		break;
+	case DSP_MIX_ON: /* enable mixing of tx data */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: enable mixing of "
+				"tx-data with conf mebers\n", __func__);
+		dsp->tx_mix = 1;
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_rx_off(dsp);
+		if (dsp_debug & DEBUG_DSP_CMX)
+			dsp_cmx_debug(dsp);
+		break;
+	case DSP_MIX_OFF: /* disable mixing of tx data */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: disable mixing of "
+				"tx-data with conf mebers\n", __func__);
+		dsp->tx_mix = 0;
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_rx_off(dsp);
+		if (dsp_debug & DEBUG_DSP_CMX)
+			dsp_cmx_debug(dsp);
+		break;
+	case DSP_TXDATA_ON: /* enable txdata */
+		dsp->tx_data = 1;
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: enable tx-data\n", __func__);
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_rx_off(dsp);
+		if (dsp_debug & DEBUG_DSP_CMX)
+			dsp_cmx_debug(dsp);
+		break;
+	case DSP_TXDATA_OFF: /* disable txdata */
+		dsp->tx_data = 0;
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: disable tx-data\n", __func__);
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_rx_off(dsp);
+		if (dsp_debug & DEBUG_DSP_CMX)
+			dsp_cmx_debug(dsp);
+		break;
+	case DSP_DELAY: /* use delay algorithm instead of dynamic
+			   jitter algorithm */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len < sizeof(int)) {
+			ret = -EINVAL;
+			break;
+		}
+		dsp->cmx_delay = (*((int *)data)) << 3;
+			/* miliseconds to samples */
+		if (dsp->cmx_delay >= (CMX_BUFF_HALF>>1))
+			/* clip to half of maximum usable buffer
+			(half of half buffer) */
+			dsp->cmx_delay = (CMX_BUFF_HALF>>1) - 1;
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: use delay algorithm to "
+				"compensate jitter (%d samples)\n",
+				__func__, dsp->cmx_delay);
+		break;
+	case DSP_JITTER: /* use dynamic jitter algorithm instead of
+		    delay algorithm */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		dsp->cmx_delay = 0;
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: use jitter algorithm to "
+				"compensate jitter\n", __func__);
+		break;
+	case DSP_TX_DEJITTER: /* use dynamic jitter algorithm for tx-buffer */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		dsp->tx_dejitter = 1;
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: use dejitter on TX "
+				"buffer\n", __func__);
+		break;
+	case DSP_TX_DEJ_OFF: /* use tx-buffer without dejittering*/
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		dsp->tx_dejitter = 0;
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: use TX buffer without "
+				"dejittering\n", __func__);
+		break;
+	case DSP_PIPELINE_CFG:
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len > 0 && ((char *)data)[len - 1]) {
+			printk(KERN_DEBUG "%s: pipeline config string "
+				"is not NULL terminated!\n", __func__);
+			ret = -EINVAL;
+		} else {
+			dsp->pipeline.inuse = 1;
+			dsp_cmx_hardware(dsp->conf, dsp);
+			ret = dsp_pipeline_build(&dsp->pipeline,
+				len > 0 ? (char *)data : NULL);
+			dsp_cmx_hardware(dsp->conf, dsp);
+			dsp_rx_off(dsp);
+		}
+		break;
+	case DSP_BF_ENABLE_KEY: /* turn blowfish on */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (len < 4 || len > 56) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: turn blowfish on (key "
+				"not shown)\n", __func__);
+		ret = dsp_bf_init(dsp, (u8 *)data, len);
+		/* set new cont */
+		if (!ret)
+			cont = DSP_BF_ACCEPT;
+		else
+			cont = DSP_BF_REJECT;
+		/* send indication if it worked to set it */
+		nskb = _alloc_mISDN_skb(PH_CONTROL_IND, MISDN_ID_ANY,
+			sizeof(int), &cont, GFP_ATOMIC);
+		if (nskb) {
+			if (dsp->up) {
+				if (dsp->up->send(dsp->up, nskb))
+					dev_kfree_skb(nskb);
+			} else
+				dev_kfree_skb(nskb);
+		}
+		if (!ret) {
+			dsp_cmx_hardware(dsp->conf, dsp);
+			dsp_dtmf_hardware(dsp);
+			dsp_rx_off(dsp);
+		}
+		break;
+	case DSP_BF_DISABLE: /* turn blowfish off */
+		if (dsp->hdlc) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: turn blowfish off\n", __func__);
+		dsp_bf_cleanup(dsp);
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_dtmf_hardware(dsp);
+		dsp_rx_off(dsp);
+		break;
+	default:
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: ctrl req %x unhandled\n",
+				__func__, cont);
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static void
+get_features(struct mISDNchannel *ch)
+{
+	struct dsp		*dsp = container_of(ch, struct dsp, ch);
+	struct mISDN_ctrl_req	cq;
+
+	if (dsp_options & DSP_OPT_NOHARDWARE)
+		return;
+	if (!ch->peer) {
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: no peer, no features\n",
+				__func__);
+		return;
+	}
+	memset(&cq, 0, sizeof(cq));
+	cq.op = MISDN_CTRL_GETOP;
+	if (ch->peer->ctrl(ch->peer, CONTROL_CHANNEL, &cq) < 0) {
+		printk(KERN_DEBUG "%s: CONTROL_CHANNEL failed\n",
+			__func__);
+		return;
+	}
+	if (cq.op & MISDN_CTRL_RX_OFF)
+		dsp->features_rx_off = 1;
+	if ((cq.op & MISDN_CTRL_HW_FEATURES_OP)) {
+		cq.op = MISDN_CTRL_HW_FEATURES;
+		*((u_long *)&cq.p1) = (u_long)&dsp->features;
+		if (ch->peer->ctrl(ch->peer, CONTROL_CHANNEL, &cq)) {
+			printk(KERN_DEBUG "%s: 2nd CONTROL_CHANNEL failed\n",
+				__func__);
+		}
+	} else
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: features not supported for %s\n",
+				__func__, dsp->name);
+}
+
+static int
+dsp_function(struct mISDNchannel *ch,  struct sk_buff *skb)
+{
+	struct dsp			*dsp = container_of(ch, struct dsp, ch);
+	struct mISDNhead	*hh;
+	int			ret = 0;
+	u8			*digits;
+	int			cont;
+	struct			sk_buff *nskb;
+	u_long			flags;
+
+	hh = mISDN_HEAD_P(skb);
+	switch (hh->prim) {
+	/* FROM DOWN */
+	case (PH_DATA_CNF):
+		dsp->data_pending = 0;
+		/* trigger next hdlc frame, if any */
+		if (dsp->hdlc) {
+			spin_lock_irqsave(&dsp_lock, flags);
+			if (dsp->b_active)
+				schedule_work(&dsp->workq);
+			spin_unlock_irqrestore(&dsp_lock, flags);
+		}
+		break;
+	case (PH_DATA_IND):
+	case (DL_DATA_IND):
+		if (skb->len < 1) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp->rx_is_off) {
+			if (dsp_debug & DEBUG_DSP_CORE)
+				printk(KERN_DEBUG "%s: rx-data during rx_off"
+					" for %s\n",
+				__func__, dsp->name);
+		}
+		if (dsp->hdlc) {
+			/* hdlc */
+			spin_lock_irqsave(&dsp_lock, flags);
+			dsp_cmx_hdlc(dsp, skb);
+			spin_unlock_irqrestore(&dsp_lock, flags);
+			if (dsp->rx_disabled) {
+				/* if receive is not allowed */
+				break;
+			}
+			hh->prim = DL_DATA_IND;
+			if (dsp->up)
+				return dsp->up->send(dsp->up, skb);
+			break;
+		}
+
+		/* decrypt if enabled */
+		if (dsp->bf_enable)
+			dsp_bf_decrypt(dsp, skb->data, skb->len);
+		/* pipeline */
+		if (dsp->pipeline.inuse)
+			dsp_pipeline_process_rx(&dsp->pipeline, skb->data,
+				skb->len);
+		/* change volume if requested */
+		if (dsp->rx_volume)
+			dsp_change_volume(skb, dsp->rx_volume);
+
+		/* check if dtmf soft decoding is turned on */
+		if (dsp->dtmf.software) {
+			digits = dsp_dtmf_goertzel_decode(dsp, skb->data,
+				skb->len, (dsp_options&DSP_OPT_ULAW)?1:0);
+			while (*digits) {
+				if (dsp_debug & DEBUG_DSP_DTMF)
+					printk(KERN_DEBUG "%s: digit"
+					    "(%c) to layer %s\n",
+					    __func__, *digits, dsp->name);
+				cont = DTMF_TONE_VAL | *digits;
+				nskb = _alloc_mISDN_skb(PH_CONTROL_IND,
+				    MISDN_ID_ANY, sizeof(int), &cont,
+				    GFP_ATOMIC);
+				if (nskb) {
+					if (dsp->up) {
+						if (dsp->up->send(
+						    dsp->up, nskb))
+						dev_kfree_skb(nskb);
+					} else
+						dev_kfree_skb(nskb);
+				}
+				digits++;
+			}
+		}
+		/* we need to process receive data if software */
+		spin_lock_irqsave(&dsp_lock, flags);
+		if (dsp->pcm_slot_tx < 0 && dsp->pcm_slot_rx < 0) {
+			/* process data from card at cmx */
+			dsp_cmx_receive(dsp, skb);
+		}
+		spin_unlock_irqrestore(&dsp_lock, flags);
+
+		if (dsp->rx_disabled) {
+			/* if receive is not allowed */
+			break;
+		}
+		hh->prim = DL_DATA_IND;
+		if (dsp->up)
+			return dsp->up->send(dsp->up, skb);
+		break;
+	case (PH_CONTROL_IND):
+		if (dsp_debug & DEBUG_DSP_DTMFCOEFF)
+			printk(KERN_DEBUG "%s: PH_CONTROL INDICATION "
+				"received: %x (len %d) %s\n", __func__,
+				hh->id, skb->len, dsp->name);
+		switch (hh->id) {
+		case (DTMF_HFC_COEF): /* getting coefficients */
+			if (!dsp->dtmf.hardware) {
+				if (dsp_debug & DEBUG_DSP_DTMFCOEFF)
+					printk(KERN_DEBUG "%s: ignoring DTMF "
+						"coefficients from HFC\n",
+						__func__);
+				break;
+			}
+			digits = dsp_dtmf_goertzel_decode(dsp, skb->data,
+				skb->len, 2);
+			while (*digits) {
+				int k;
+				struct sk_buff *nskb;
+				if (dsp_debug & DEBUG_DSP_DTMF)
+					printk(KERN_DEBUG "%s: digit"
+					    "(%c) to layer %s\n",
+					    __func__, *digits, dsp->name);
+				k = *digits | DTMF_TONE_VAL;
+				nskb = _alloc_mISDN_skb(PH_CONTROL_IND,
+					MISDN_ID_ANY, sizeof(int), &k,
+					GFP_ATOMIC);
+				if (nskb) {
+					if (dsp->up) {
+						if (dsp->up->send(
+						    dsp->up, nskb))
+						dev_kfree_skb(nskb);
+					} else
+						dev_kfree_skb(nskb);
+				}
+				digits++;
+			}
+			break;
+		case (HFC_VOL_CHANGE_TX): /* change volume */
+			if (skb->len != sizeof(int)) {
+				ret = -EINVAL;
+				break;
+			}
+			spin_lock_irqsave(&dsp_lock, flags);
+			dsp->tx_volume = *((int *)skb->data);
+			if (dsp_debug & DEBUG_DSP_CORE)
+				printk(KERN_DEBUG "%s: change tx volume to "
+					"%d\n", __func__, dsp->tx_volume);
+			dsp_cmx_hardware(dsp->conf, dsp);
+			dsp_dtmf_hardware(dsp);
+			dsp_rx_off(dsp);
+			spin_unlock_irqrestore(&dsp_lock, flags);
+			break;
+		default:
+			if (dsp_debug & DEBUG_DSP_CORE)
+				printk(KERN_DEBUG "%s: ctrl ind %x unhandled "
+					"%s\n", __func__, hh->id, dsp->name);
+			ret = -EINVAL;
+		}
+		break;
+	case (PH_ACTIVATE_IND):
+	case (PH_ACTIVATE_CNF):
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: b_channel is now active %s\n",
+				__func__, dsp->name);
+		/* bchannel now active */
+		spin_lock_irqsave(&dsp_lock, flags);
+		dsp->b_active = 1;
+		dsp->data_pending = 0;
+		dsp->rx_init = 1;
+			/* rx_W and rx_R will be adjusted on first frame */
+		dsp->rx_W = 0;
+		dsp->rx_R = 0;
+		memset(dsp->rx_buff, 0, sizeof(dsp->rx_buff));
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_dtmf_hardware(dsp);
+		dsp_rx_off(dsp);
+		spin_unlock_irqrestore(&dsp_lock, flags);
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: done with activation, sending "
+				"confirm to user space. %s\n", __func__,
+				dsp->name);
+		/* send activation to upper layer */
+		hh->prim = DL_ESTABLISH_CNF;
+		if (dsp->up)
+			return dsp->up->send(dsp->up, skb);
+		break;
+	case (PH_DEACTIVATE_IND):
+	case (PH_DEACTIVATE_CNF):
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: b_channel is now inactive %s\n",
+				__func__, dsp->name);
+		/* bchannel now inactive */
+		spin_lock_irqsave(&dsp_lock, flags);
+		dsp->b_active = 0;
+		dsp->data_pending = 0;
+		dsp_cmx_hardware(dsp->conf, dsp);
+		dsp_rx_off(dsp);
+		spin_unlock_irqrestore(&dsp_lock, flags);
+		hh->prim = DL_RELEASE_CNF;
+		if (dsp->up)
+			return dsp->up->send(dsp->up, skb);
+		break;
+	/* FROM UP */
+	case (DL_DATA_REQ):
+	case (PH_DATA_REQ):
+		if (skb->len < 1) {
+			ret = -EINVAL;
+			break;
+		}
+		if (dsp->hdlc) {
+			/* hdlc */
+			spin_lock_irqsave(&dsp_lock, flags);
+			if (dsp->b_active) {
+				skb_queue_tail(&dsp->sendq, skb);
+				schedule_work(&dsp->workq);
+			}
+			spin_unlock_irqrestore(&dsp_lock, flags);
+			return 0;
+		}
+		/* send data to tx-buffer (if no tone is played) */
+		if (!dsp->tone.tone) {
+			spin_lock_irqsave(&dsp_lock, flags);
+			dsp_cmx_transmit(dsp, skb);
+			spin_unlock_irqrestore(&dsp_lock, flags);
+		}
+		break;
+	case (PH_CONTROL_REQ):
+		spin_lock_irqsave(&dsp_lock, flags);
+		ret = dsp_control_req(dsp, hh, skb);
+		spin_unlock_irqrestore(&dsp_lock, flags);
+		break;
+	case (DL_ESTABLISH_REQ):
+	case (PH_ACTIVATE_REQ):
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: activating b_channel %s\n",
+				__func__, dsp->name);
+		if (dsp->dtmf.hardware || dsp->dtmf.software)
+			dsp_dtmf_goertzel_init(dsp);
+		get_features(ch);
+		/* send ph_activate */
+		hh->prim = PH_ACTIVATE_REQ;
+		if (ch->peer)
+			return ch->recv(ch->peer, skb);
+		break;
+	case (DL_RELEASE_REQ):
+	case (PH_DEACTIVATE_REQ):
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: releasing b_channel %s\n",
+				__func__, dsp->name);
+		spin_lock_irqsave(&dsp_lock, flags);
+		dsp->tone.tone = 0;
+		dsp->tone.hardware = 0;
+		dsp->tone.software = 0;
+		if (timer_pending(&dsp->tone.tl))
+			del_timer(&dsp->tone.tl);
+		if (dsp->conf)
+			dsp_cmx_conf(dsp, 0); /* dsp_cmx_hardware will also be
+						 called here */
+		skb_queue_purge(&dsp->sendq);
+		spin_unlock_irqrestore(&dsp_lock, flags);
+		hh->prim = PH_DEACTIVATE_REQ;
+		if (ch->peer)
+			return ch->recv(ch->peer, skb);
+		break;
+	default:
+		if (dsp_debug & DEBUG_DSP_CORE)
+			printk(KERN_DEBUG "%s: msg %x unhandled %s\n",
+				__func__, hh->prim, dsp->name);
+		ret = -EINVAL;
+	}
+	if (!ret)
+		dev_kfree_skb(skb);
+	return ret;
+}
+
+static int
+dsp_ctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
+{
+	struct dsp		*dsp = container_of(ch, struct dsp, ch);
+	u_long		flags;
+	int		err = 0;
+
+	if (debug & DEBUG_DSP_CTRL)
+	printk(KERN_DEBUG "%s:(%x)\n", __func__, cmd);
+
+	switch (cmd) {
+	case OPEN_CHANNEL:
+		break;
+	case CLOSE_CHANNEL:
+		if (dsp->ch.peer)
+			dsp->ch.peer->ctrl(dsp->ch.peer, CLOSE_CHANNEL, NULL);
+
+		/* wait until workqueue has finished,
+		 * must lock here, or we may hit send-process currently
+		 * queueing. */
+		spin_lock_irqsave(&dsp_lock, flags);
+		dsp->b_active = 0;
+		spin_unlock_irqrestore(&dsp_lock, flags);
+		/* MUST not be locked, because it waits until queue is done. */
+		cancel_work_sync(&dsp->workq);
+		spin_lock_irqsave(&dsp_lock, flags);
+		if (timer_pending(&dsp->tone.tl))
+			del_timer(&dsp->tone.tl);
+		skb_queue_purge(&dsp->sendq);
+		if (dsp_debug & DEBUG_DSP_CTRL)
+			printk(KERN_DEBUG "%s: releasing member %s\n",
+				__func__, dsp->name);
+		dsp->b_active = 0;
+		dsp_cmx_conf(dsp, 0); /* dsp_cmx_hardware will also be called
+					 here */
+		dsp_pipeline_destroy(&dsp->pipeline);
+
+		if (dsp_debug & DEBUG_DSP_CTRL)
+			printk(KERN_DEBUG "%s: remove & destroy object %s\n",
+				__func__, dsp->name);
+		list_del(&dsp->list);
+		spin_unlock_irqrestore(&dsp_lock, flags);
+
+		if (dsp_debug & DEBUG_DSP_CTRL)
+			printk(KERN_DEBUG "%s: dsp instance released\n",
+				__func__);
+		vfree(dsp);
+		module_put(THIS_MODULE);
+		break;
+	}
+	return err;
+}
+
+static void
+dsp_send_bh(struct work_struct *work)
+{
+	struct dsp *dsp = container_of(work, struct dsp, workq);
+	struct sk_buff *skb;
+	struct mISDNhead	*hh;
+
+	if (dsp->hdlc && dsp->data_pending)
+		return; /* wait until data has been acknowledged */
+
+	/* send queued data */
+	while ((skb = skb_dequeue(&dsp->sendq))) {
+		/* in locked date, we must have still data in queue */
+		if (dsp->data_pending) {
+			if (dsp_debug & DEBUG_DSP_CORE)
+				printk(KERN_DEBUG "%s: fifo full %s, this is "
+					"no bug!\n", __func__, dsp->name);
+			/* flush transparent data, if not acked */
+			dev_kfree_skb(skb);
+			continue;
+		}
+		hh = mISDN_HEAD_P(skb);
+		if (hh->prim == DL_DATA_REQ) {
+			/* send packet up */
+			if (dsp->up) {
+				if (dsp->up->send(dsp->up, skb))
+					dev_kfree_skb(skb);
+			} else
+				dev_kfree_skb(skb);
+		} else {
+			/* send packet down */
+			if (dsp->ch.peer) {
+				dsp->data_pending = 1;
+				if (dsp->ch.recv(dsp->ch.peer, skb)) {
+					dev_kfree_skb(skb);
+					dsp->data_pending = 0;
+				}
+			} else
+				dev_kfree_skb(skb);
+		}
+	}
+}
+
+static int
+dspcreate(struct channel_req *crq)
+{
+	struct dsp		*ndsp;
+	u_long		flags;
+
+	if (crq->protocol != ISDN_P_B_L2DSP
+	 && crq->protocol != ISDN_P_B_L2DSPHDLC)
+		return -EPROTONOSUPPORT;
+	ndsp = vmalloc(sizeof(struct dsp));
+	if (!ndsp) {
+		printk(KERN_ERR "%s: vmalloc struct dsp failed\n", __func__);
+		return -ENOMEM;
+	}
+	memset(ndsp, 0, sizeof(struct dsp));
+	if (dsp_debug & DEBUG_DSP_CTRL)
+		printk(KERN_DEBUG "%s: creating new dsp instance\n", __func__);
+
+	/* default enabled */
+	INIT_WORK(&ndsp->workq, (void *)dsp_send_bh);
+	skb_queue_head_init(&ndsp->sendq);
+	ndsp->ch.send = dsp_function;
+	ndsp->ch.ctrl = dsp_ctrl;
+	ndsp->up = crq->ch;
+	crq->ch = &ndsp->ch;
+	if (crq->protocol == ISDN_P_B_L2DSP) {
+		crq->protocol = ISDN_P_B_RAW;
+		ndsp->hdlc = 0;
+	} else {
+		crq->protocol = ISDN_P_B_HDLC;
+		ndsp->hdlc = 1;
+	}
+	if (!try_module_get(THIS_MODULE))
+		printk(KERN_WARNING "%s:cannot get module\n",
+			__func__);
+
+	sprintf(ndsp->name, "DSP_C%x(0x%p)",
+		ndsp->up->st->dev->id + 1, ndsp);
+	/* set frame size to start */
+	ndsp->features.hfc_id = -1; /* current PCM id */
+	ndsp->features.pcm_id = -1; /* current PCM id */
+	ndsp->pcm_slot_rx = -1; /* current CPM slot */
+	ndsp->pcm_slot_tx = -1;
+	ndsp->pcm_bank_rx = -1;
+	ndsp->pcm_bank_tx = -1;
+	ndsp->hfc_conf = -1; /* current conference number */
+	/* set tone timer */
+	ndsp->tone.tl.function = (void *)dsp_tone_timeout;
+	ndsp->tone.tl.data = (long) ndsp;
+	init_timer(&ndsp->tone.tl);
+
+	if (dtmfthreshold < 20 || dtmfthreshold > 500)
+		dtmfthreshold = 200;
+	ndsp->dtmf.treshold = dtmfthreshold*10000;
+
+	/* init pipeline append to list */
+	spin_lock_irqsave(&dsp_lock, flags);
+	dsp_pipeline_init(&ndsp->pipeline);
+	list_add_tail(&ndsp->list, &dsp_ilist);
+	spin_unlock_irqrestore(&dsp_lock, flags);
+
+	return 0;
+}
+
+
+static struct Bprotocol DSP = {
+	.Bprotocols = (1 << (ISDN_P_B_L2DSP & ISDN_P_B_MASK))
+		| (1 << (ISDN_P_B_L2DSPHDLC & ISDN_P_B_MASK)),
+	.name = "dsp",
+	.create = dspcreate
+};
+
+static int dsp_init(void)
+{
+	int err;
+	int tics;
+
+	printk(KERN_INFO "DSP modul %s\n", mISDN_dsp_revision);
+
+	dsp_options = options;
+	dsp_debug = debug;
+
+	/* set packet size */
+	dsp_poll = poll;
+	if (dsp_poll) {
+		if (dsp_poll > MAX_POLL) {
+			printk(KERN_ERR "%s: Wrong poll value (%d), use %d "
+				"maximum.\n", __func__, poll, MAX_POLL);
+			err = -EINVAL;
+			return err;
+		}
+		if (dsp_poll < 8) {
+			printk(KERN_ERR "%s: Wrong poll value (%d), use 8 "
+				"minimum.\n", __func__, dsp_poll);
+			err = -EINVAL;
+			return err;
+		}
+		dsp_tics = poll * HZ / 8000;
+		if (dsp_tics * 8000 != poll * HZ) {
+			printk(KERN_INFO "mISDN_dsp: Cannot clock every %d "
+				"samples (0,125 ms). It is not a multiple of "
+				"%d HZ.\n", poll, HZ);
+			err = -EINVAL;
+			return err;
+		}
+	} else {
+		poll = 8;
+		while (poll <= MAX_POLL) {
+			tics = poll * HZ / 8000;
+			if (tics * 8000 == poll * HZ) {
+				dsp_tics = tics;
+				dsp_poll = poll;
+				if (poll >= 64)
+					break;
+			}
+			poll++;
+		}
+	}
+	if (dsp_poll == 0) {
+		printk(KERN_INFO "mISDN_dsp: There is no multiple of kernel "
+			"clock that equals exactly the duration of 8-256 "
+			"samples. (Choose kernel clock speed like 100, 250, "
+			"300, 1000)\n");
+		err = -EINVAL;
+		return err;
+	}
+	printk(KERN_INFO "mISDN_dsp: DSP clocks every %d samples. This equals "
+		"%d jiffies.\n", dsp_poll, dsp_tics);
+
+	spin_lock_init(&dsp_lock);
+	INIT_LIST_HEAD(&dsp_ilist);
+	INIT_LIST_HEAD(&conf_ilist);
+
+	/* init conversion tables */
+	dsp_audio_generate_law_tables();
+	dsp_silence = (dsp_options&DSP_OPT_ULAW)?0xff:0x2a;
+	dsp_audio_law_to_s32 = (dsp_options&DSP_OPT_ULAW)?dsp_audio_ulaw_to_s32:
+		dsp_audio_alaw_to_s32;
+	dsp_audio_generate_s2law_table();
+	dsp_audio_generate_seven();
+	dsp_audio_generate_mix_table();
+	if (dsp_options & DSP_OPT_ULAW)
+		dsp_audio_generate_ulaw_samples();
+	dsp_audio_generate_volume_changes();
+
+	err = dsp_pipeline_module_init();
+	if (err) {
+		printk(KERN_ERR "mISDN_dsp: Can't initialize pipeline, "
+			"error(%d)\n", err);
+		return err;
+	}
+
+	err = mISDN_register_Bprotocol(&DSP);
+	if (err) {
+		printk(KERN_ERR "Can't register %s error(%d)\n", DSP.name, err);
+		return err;
+	}
+
+	/* set sample timer */
+	dsp_spl_tl.function = (void *)dsp_cmx_send;
+	dsp_spl_tl.data = 0;
+	init_timer(&dsp_spl_tl);
+	dsp_spl_tl.expires = jiffies + dsp_tics;
+	dsp_spl_jiffies = dsp_spl_tl.expires;
+	add_timer(&dsp_spl_tl);
+
+	return 0;
+}
+
+
+static void dsp_cleanup(void)
+{
+	mISDN_unregister_Bprotocol(&DSP);
+
+	if (timer_pending(&dsp_spl_tl))
+		del_timer(&dsp_spl_tl);
+
+	if (!list_empty(&dsp_ilist)) {
+		printk(KERN_ERR "mISDN_dsp: Audio DSP object inst list not "
+			"empty.\n");
+	}
+	if (!list_empty(&conf_ilist)) {
+		printk(KERN_ERR "mISDN_dsp: Conference list not empty. Not "
+			"all memory freed.\n");
+	}
+
+	dsp_pipeline_module_exit();
+}
+
+module_init(dsp_init);
+module_exit(dsp_cleanup);
+
diff --git a/drivers/isdn/mISDN/dsp_dtmf.c b/drivers/isdn/mISDN/dsp_dtmf.c
new file mode 100644
index 0000000..efc371c
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_dtmf.c
@@ -0,0 +1,303 @@
+/*
+ * DTMF decoder.
+ *
+ * Copyright            by Andreas Eversberg (jolly@eversberg.eu)
+ *			based on different decoders such as ISDN4Linux
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ *
+ */
+
+#include <linux/mISDNif.h>
+#include <linux/mISDNdsp.h>
+#include "core.h"
+#include "dsp.h"
+
+#define NCOEFF            8     /* number of frequencies to be analyzed */
+
+/* For DTMF recognition:
+ * 2 * cos(2 * PI * k / N) precalculated for all k
+ */
+static u64 cos2pik[NCOEFF] =
+{
+	/* k << 15 (source: hfc-4s/8s documentation (www.colognechip.de)) */
+	55960, 53912, 51402, 48438, 38146, 32650, 26170, 18630
+};
+
+/* digit matrix */
+static char dtmf_matrix[4][4] =
+{
+	{'1', '2', '3', 'A'},
+	{'4', '5', '6', 'B'},
+	{'7', '8', '9', 'C'},
+	{'*', '0', '#', 'D'}
+};
+
+/* dtmf detection using goertzel algorithm
+ * init function
+ */
+void dsp_dtmf_goertzel_init(struct dsp *dsp)
+{
+	dsp->dtmf.size = 0;
+	dsp->dtmf.lastwhat = '\0';
+	dsp->dtmf.lastdigit = '\0';
+	dsp->dtmf.count = 0;
+}
+
+/* check for hardware or software features
+ */
+void dsp_dtmf_hardware(struct dsp *dsp)
+{
+	int hardware = 1;
+
+	if (!dsp->features.hfc_dtmf)
+		hardware = 0;
+
+	/* check for volume change */
+	if (dsp->tx_volume) {
+		if (dsp_debug & DEBUG_DSP_DTMF)
+			printk(KERN_DEBUG "%s dsp %s cannot do hardware DTMF, "
+				"because tx_volume is changed\n",
+				__func__, dsp->name);
+		hardware = 0;
+	}
+	if (dsp->rx_volume) {
+		if (dsp_debug & DEBUG_DSP_DTMF)
+			printk(KERN_DEBUG "%s dsp %s cannot do hardware DTMF, "
+				"because rx_volume is changed\n",
+				__func__, dsp->name);
+		hardware = 0;
+	}
+	/* check if encryption is enabled */
+	if (dsp->bf_enable) {
+		if (dsp_debug & DEBUG_DSP_DTMF)
+			printk(KERN_DEBUG "%s dsp %s cannot do hardware DTMF, "
+				"because encryption is enabled\n",
+				__func__, dsp->name);
+		hardware = 0;
+	}
+	/* check if pipeline exists */
+	if (dsp->pipeline.inuse) {
+		if (dsp_debug & DEBUG_DSP_DTMF)
+			printk(KERN_DEBUG "%s dsp %s cannot do hardware DTMF, "
+				"because pipeline exists.\n",
+				__func__, dsp->name);
+		hardware = 0;
+	}
+
+	dsp->dtmf.hardware = hardware;
+	dsp->dtmf.software = !hardware;
+}
+
+
+/*************************************************************
+ * calculate the coefficients of the given sample and decode *
+ *************************************************************/
+
+/* the given sample is decoded. if the sample is not long enough for a
+ * complete frame, the decoding is finished and continued with the next
+ * call of this function.
+ *
+ * the algorithm is very good for detection with a minimum of errors. i
+ * tested it allot. it even works with very short tones (40ms). the only
+ * disadvantage is, that it doesn't work good with different volumes of both
+ * tones. this will happen, if accoustically coupled dialers are used.
+ * it sometimes detects tones during speach, which is normal for decoders.
+ * use sequences to given commands during calls.
+ *
+ * dtmf - points to a structure of the current dtmf state
+ * spl and len - the sample
+ * fmt - 0 = alaw, 1 = ulaw, 2 = coefficients from HFC DTMF hw-decoder
+ */
+
+u8
+*dsp_dtmf_goertzel_decode(struct dsp *dsp, u8 *data, int len, int fmt)
+{
+	u8 what;
+	int size;
+	signed short *buf;
+	s32 sk, sk1, sk2;
+	int k, n, i;
+	s32 *hfccoeff;
+	s32 result[NCOEFF], tresh, treshl;
+	int lowgroup, highgroup;
+	s64 cos2pik_;
+
+	dsp->dtmf.digits[0] = '\0';
+
+	/* Note: The function will loop until the buffer has not enough samples
+	 * left to decode a full frame.
+	 */
+again:
+	/* convert samples */
+	size = dsp->dtmf.size;
+	buf = dsp->dtmf.buffer;
+	switch (fmt) {
+	case 0: /* alaw */
+	case 1: /* ulaw */
+		while (size < DSP_DTMF_NPOINTS && len) {
+			buf[size++] = dsp_audio_law_to_s32[*data++];
+			len--;
+		}
+		break;
+
+	case 2: /* HFC coefficients */
+	default:
+		if (len < 64) {
+			if (len > 0)
+				printk(KERN_ERR "%s: coefficients have invalid "
+					"size. (is=%d < must=%d)\n",
+					__func__, len, 64);
+			return dsp->dtmf.digits;
+		}
+		hfccoeff = (s32 *)data;
+		for (k = 0; k < NCOEFF; k++) {
+			sk2 = (*hfccoeff++)>>4;
+			sk = (*hfccoeff++)>>4;
+			if (sk > 32767 || sk < -32767 || sk2 > 32767
+			    || sk2 < -32767)
+				printk(KERN_WARNING
+					"DTMF-Detection overflow\n");
+			/* compute |X(k)|**2 */
+			result[k] =
+				 (sk * sk) -
+				 (((cos2pik[k] * sk) >> 15) * sk2) +
+				 (sk2 * sk2);
+		}
+		data += 64;
+		len -= 64;
+		goto coefficients;
+		break;
+	}
+	dsp->dtmf.size = size;
+
+	if (size < DSP_DTMF_NPOINTS)
+		return dsp->dtmf.digits;
+
+	dsp->dtmf.size = 0;
+
+	/* now we have a full buffer of signed long samples - we do goertzel */
+	for (k = 0; k < NCOEFF; k++) {
+		sk = 0;
+		sk1 = 0;
+		sk2 = 0;
+		buf = dsp->dtmf.buffer;
+		cos2pik_ = cos2pik[k];
+		for (n = 0; n < DSP_DTMF_NPOINTS; n++) {
+			sk = ((cos2pik_*sk1)>>15) - sk2 + (*buf++);
+			sk2 = sk1;
+			sk1 = sk;
+		}
+		sk >>= 8;
+		sk2 >>= 8;
+		if (sk > 32767 || sk < -32767 || sk2 > 32767 || sk2 < -32767)
+			printk(KERN_WARNING "DTMF-Detection overflow\n");
+		/* compute |X(k)|**2 */
+		result[k] =
+			(sk * sk) -
+			(((cos2pik[k] * sk) >> 15) * sk2) +
+			(sk2 * sk2);
+	}
+
+	/* our (squared) coefficients have been calculated, we need to process
+	 * them.
+	 */
+coefficients:
+	tresh = 0;
+	for (i = 0; i < NCOEFF; i++) {
+		if (result[i] < 0)
+			result[i] = 0;
+		if (result[i] > dsp->dtmf.treshold) {
+			if (result[i] > tresh)
+				tresh = result[i];
+		}
+	}
+
+	if (tresh == 0) {
+		what = 0;
+		goto storedigit;
+	}
+
+	if (dsp_debug & DEBUG_DSP_DTMFCOEFF)
+		printk(KERN_DEBUG "a %3d %3d %3d %3d %3d %3d %3d %3d"
+			" tr:%3d r %3d %3d %3d %3d %3d %3d %3d %3d\n",
+			result[0]/10000, result[1]/10000, result[2]/10000,
+			result[3]/10000, result[4]/10000, result[5]/10000,
+			result[6]/10000, result[7]/10000, tresh/10000,
+			result[0]/(tresh/100), result[1]/(tresh/100),
+			result[2]/(tresh/100), result[3]/(tresh/100),
+			result[4]/(tresh/100), result[5]/(tresh/100),
+			result[6]/(tresh/100), result[7]/(tresh/100));
+
+	/* calc digit (lowgroup/highgroup) */
+	lowgroup = -1;
+	highgroup = -1;
+	treshl = tresh >> 3;  /* tones which are not on, must be below 9 dB */
+	tresh = tresh >> 2;  /* touchtones must match within 6 dB */
+	for (i = 0; i < NCOEFF; i++) {
+		if (result[i] < treshl)
+			continue;  /* ignore */
+		if (result[i] < tresh) {
+			lowgroup = -1;
+			highgroup = -1;
+			break;  /* noise inbetween */
+		}
+		/* good level found. This is allowed only one time per group */
+		if (i < NCOEFF/2) {
+			/* lowgroup */
+			if (lowgroup >= 0) {
+				/* Bad. Another tone found. */
+				lowgroup = -1;
+				break;
+			} else
+				lowgroup = i;
+		} else {
+			/* higroup */
+			if (highgroup >= 0) {
+				/* Bad. Another tone found. */
+				highgroup = -1;
+				break;
+			} else
+				highgroup = i-(NCOEFF/2);
+		}
+	}
+
+	/* get digit or null */
+	what = 0;
+	if (lowgroup >= 0 && highgroup >= 0)
+		what = dtmf_matrix[lowgroup][highgroup];
+
+storedigit:
+	if (what && (dsp_debug & DEBUG_DSP_DTMF))
+		printk(KERN_DEBUG "DTMF what: %c\n", what);
+
+	if (dsp->dtmf.lastwhat != what)
+		dsp->dtmf.count = 0;
+
+	/* the tone (or no tone) must remain 3 times without change */
+	if (dsp->dtmf.count == 2) {
+		if (dsp->dtmf.lastdigit != what) {
+			dsp->dtmf.lastdigit = what;
+			if (what) {
+				if (dsp_debug & DEBUG_DSP_DTMF)
+					printk(KERN_DEBUG "DTMF digit: %c\n",
+						what);
+				if ((strlen(dsp->dtmf.digits)+1)
+					< sizeof(dsp->dtmf.digits)) {
+					dsp->dtmf.digits[strlen(
+						dsp->dtmf.digits)+1] = '\0';
+					dsp->dtmf.digits[strlen(
+						dsp->dtmf.digits)] = what;
+				}
+			}
+		}
+	} else
+		dsp->dtmf.count++;
+
+	dsp->dtmf.lastwhat = what;
+
+	goto again;
+}
+
+
diff --git a/drivers/isdn/mISDN/dsp_ecdis.h b/drivers/isdn/mISDN/dsp_ecdis.h
new file mode 100644
index 0000000..8a20af4
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_ecdis.h
@@ -0,0 +1,110 @@
+/*
+ * SpanDSP - a series of DSP components for telephony
+ *
+ * ec_disable_detector.h - A detector which should eventually meet the
+ *                         G.164/G.165 requirements for detecting the
+ *                         2100Hz echo cancellor disable tone.
+ *
+ * Written by Steve Underwood <steveu@coppice.org>
+ *
+ * Copyright (C) 2001 Steve Underwood
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include "dsp_biquad.h"
+
+struct ec_disable_detector_state {
+	struct biquad2_state notch;
+	int notch_level;
+	int channel_level;
+	int tone_present;
+	int tone_cycle_duration;
+	int good_cycles;
+	int hit;
+};
+
+
+#define FALSE 0
+#define TRUE (!FALSE)
+
+static inline void
+echo_can_disable_detector_init(struct ec_disable_detector_state *det)
+{
+    /* Elliptic notch */
+    /* This is actually centred at 2095Hz, but gets the balance we want, due
+       to the asymmetric walls of the notch */
+	biquad2_init(&det->notch,
+		(int32_t) (-0.7600000*32768.0),
+		(int32_t) (-0.1183852*32768.0),
+		(int32_t) (-0.5104039*32768.0),
+		(int32_t) (0.1567596*32768.0),
+		(int32_t) (1.0000000*32768.0));
+
+	det->channel_level = 0;
+	det->notch_level = 0;
+	det->tone_present = FALSE;
+	det->tone_cycle_duration = 0;
+	det->good_cycles = 0;
+	det->hit = 0;
+}
+/*- End of function --------------------------------------------------------*/
+
+static inline int
+echo_can_disable_detector_update(struct ec_disable_detector_state *det,
+int16_t amp)
+{
+	int16_t notched;
+
+	notched = biquad2(&det->notch, amp);
+	/* Estimate the overall energy in the channel, and the energy in
+	   the notch (i.e. overall channel energy - tone energy => noise).
+	   Use abs instead of multiply for speed (is it really faster?).
+	   Damp the overall energy a little more for a stable result.
+	   Damp the notch energy a little less, so we don't damp out the
+	   blip every time the phase reverses */
+	det->channel_level += ((abs(amp) - det->channel_level) >> 5);
+	det->notch_level += ((abs(notched) - det->notch_level) >> 4);
+	if (det->channel_level > 280) {
+		/* There is adequate energy in the channel.
+		 Is it mostly at 2100Hz? */
+		if (det->notch_level*6 < det->channel_level) {
+			/* The notch says yes, so we have the tone. */
+			if (!det->tone_present) {
+				/* Do we get a kick every 450+-25ms? */
+				if (det->tone_cycle_duration >= 425*8
+					&& det->tone_cycle_duration <= 475*8) {
+					det->good_cycles++;
+					if (det->good_cycles > 2)
+					det->hit = TRUE;
+				}
+				det->tone_cycle_duration = 0;
+			}
+			det->tone_present = TRUE;
+		} else
+			det->tone_present = FALSE;
+		det->tone_cycle_duration++;
+	} else {
+		det->tone_present = FALSE;
+		det->tone_cycle_duration = 0;
+		det->good_cycles = 0;
+	}
+	return det->hit;
+}
+/*- End of function --------------------------------------------------------*/
+/*- End of file ------------------------------------------------------------*/
diff --git a/drivers/isdn/mISDN/dsp_hwec.c b/drivers/isdn/mISDN/dsp_hwec.c
new file mode 100644
index 0000000..eb892d9
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_hwec.c
@@ -0,0 +1,138 @@
+/*
+ * dsp_hwec.c:
+ * builtin mISDN dsp pipeline element for enabling the hw echocanceller
+ *
+ * Copyright (C) 2007, Nadi Sarrar
+ *
+ * Nadi Sarrar <nadi@beronet.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/mISDNdsp.h>
+#include <linux/mISDNif.h>
+#include "core.h"
+#include "dsp.h"
+#include "dsp_hwec.h"
+
+static struct mISDN_dsp_element_arg args[] = {
+	{ "deftaps", "128", "Set the number of taps of cancellation." },
+};
+
+static struct mISDN_dsp_element dsp_hwec_p = {
+	.name = "hwec",
+	.new = NULL,
+	.free = NULL,
+	.process_tx = NULL,
+	.process_rx = NULL,
+	.num_args = sizeof(args) / sizeof(struct mISDN_dsp_element_arg),
+	.args = args,
+};
+struct mISDN_dsp_element *dsp_hwec = &dsp_hwec_p;
+
+void dsp_hwec_enable(struct dsp *dsp, const char *arg)
+{
+	int deftaps = 128,
+		len;
+	struct mISDN_ctrl_req	cq;
+
+	if (!dsp) {
+		printk(KERN_ERR "%s: failed to enable hwec: dsp is NULL\n",
+			__func__);
+		return;
+	}
+
+	if (!arg)
+		goto _do;
+
+	len = strlen(arg);
+	if (!len)
+		goto _do;
+
+	{
+		char _dup[len + 1];
+		char *dup, *tok, *name, *val;
+		int tmp;
+
+		strcpy(_dup, arg);
+		dup = _dup;
+
+		while ((tok = strsep(&dup, ","))) {
+			if (!strlen(tok))
+				continue;
+			name = strsep(&tok, "=");
+			val = tok;
+
+			if (!val)
+				continue;
+
+			if (!strcmp(name, "deftaps")) {
+				if (sscanf(val, "%d", &tmp) == 1)
+					deftaps = tmp;
+			}
+		}
+	}
+
+_do:
+	printk(KERN_DEBUG "%s: enabling hwec with deftaps=%d\n",
+		__func__, deftaps);
+	memset(&cq, 0, sizeof(cq));
+	cq.op = MISDN_CTRL_HFC_ECHOCAN_ON;
+	cq.p1 = deftaps;
+	if (!dsp->ch.peer->ctrl(&dsp->ch, CONTROL_CHANNEL, &cq)) {
+		printk(KERN_DEBUG "%s: CONTROL_CHANNEL failed\n",
+			__func__);
+		return;
+	}
+}
+
+void dsp_hwec_disable(struct dsp *dsp)
+{
+	struct mISDN_ctrl_req	cq;
+
+	if (!dsp) {
+		printk(KERN_ERR "%s: failed to disable hwec: dsp is NULL\n",
+			__func__);
+		return;
+	}
+
+	printk(KERN_DEBUG "%s: disabling hwec\n", __func__);
+	memset(&cq, 0, sizeof(cq));
+	cq.op = MISDN_CTRL_HFC_ECHOCAN_OFF;
+	if (!dsp->ch.peer->ctrl(&dsp->ch, CONTROL_CHANNEL, &cq)) {
+		printk(KERN_DEBUG "%s: CONTROL_CHANNEL failed\n",
+			__func__);
+		return;
+	}
+}
+
+int dsp_hwec_init(void)
+{
+	mISDN_dsp_element_register(dsp_hwec);
+
+	return 0;
+}
+
+void dsp_hwec_exit(void)
+{
+	mISDN_dsp_element_unregister(dsp_hwec);
+}
+
diff --git a/drivers/isdn/mISDN/dsp_hwec.h b/drivers/isdn/mISDN/dsp_hwec.h
new file mode 100644
index 0000000..eebe80c
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_hwec.h
@@ -0,0 +1,10 @@
+/*
+ * dsp_hwec.h
+ */
+
+extern struct mISDN_dsp_element *dsp_hwec;
+extern void dsp_hwec_enable(struct dsp *dsp, const char *arg);
+extern void dsp_hwec_disable(struct dsp *dsp);
+extern int  dsp_hwec_init(void);
+extern void dsp_hwec_exit(void);
+
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
new file mode 100644
index 0000000..850260a
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -0,0 +1,348 @@
+/*
+ * dsp_pipeline.c: pipelined audio processing
+ *
+ * Copyright (C) 2007, Nadi Sarrar
+ *
+ * Nadi Sarrar <nadi@beronet.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/mISDNif.h>
+#include <linux/mISDNdsp.h>
+#include "dsp.h"
+#include "dsp_hwec.h"
+
+/* uncomment for debugging */
+/*#define PIPELINE_DEBUG*/
+
+struct dsp_pipeline_entry {
+	struct mISDN_dsp_element *elem;
+	void                *p;
+	struct list_head     list;
+};
+struct dsp_element_entry {
+	struct mISDN_dsp_element *elem;
+	struct device	     dev;
+	struct list_head     list;
+};
+
+static LIST_HEAD(dsp_elements);
+
+/* sysfs */
+static struct class *elements_class;
+
+static ssize_t
+attr_show_args(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mISDN_dsp_element *elem = dev_get_drvdata(dev);
+	ssize_t len = 0;
+	int i = 0;
+
+	*buf = 0;
+	for (; i < elem->num_args; ++i)
+		len = sprintf(buf, "%sName:        %s\n%s%s%sDescription: %s\n"
+			"\n", buf,
+			  elem->args[i].name,
+			  elem->args[i].def ? "Default:     " : "",
+			  elem->args[i].def ? elem->args[i].def : "",
+			  elem->args[i].def ? "\n" : "",
+			  elem->args[i].desc);
+
+	return len;
+}
+
+static struct device_attribute element_attributes[] = {
+	__ATTR(args, 0444, attr_show_args, NULL),
+};
+
+int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
+{
+	struct dsp_element_entry *entry;
+	int ret, i;
+
+	if (!elem)
+		return -EINVAL;
+
+	entry = kzalloc(sizeof(struct dsp_element_entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->elem = elem;
+
+	entry->dev.class = elements_class;
+	dev_set_drvdata(&entry->dev, elem);
+	snprintf(entry->dev.bus_id, BUS_ID_SIZE, elem->name);
+	ret = device_register(&entry->dev);
+	if (ret) {
+		printk(KERN_ERR "%s: failed to register %s\n",
+			__func__, elem->name);
+		goto err1;
+	}
+
+	for (i = 0; i < (sizeof(element_attributes)
+		/ sizeof(struct device_attribute)); ++i)
+		ret = device_create_file(&entry->dev,
+				&element_attributes[i]);
+		if (ret) {
+			printk(KERN_ERR "%s: failed to create device file\n",
+				__func__);
+			goto err2;
+		}
+
+	list_add_tail(&entry->list, &dsp_elements);
+
+	printk(KERN_DEBUG "%s: %s registered\n", __func__, elem->name);
+
+	return 0;
+
+err2:
+	device_unregister(&entry->dev);
+err1:
+	kfree(entry);
+	return ret;
+}
+EXPORT_SYMBOL(mISDN_dsp_element_register);
+
+void mISDN_dsp_element_unregister(struct mISDN_dsp_element *elem)
+{
+	struct dsp_element_entry *entry, *n;
+
+	if (!elem)
+		return;
+
+	list_for_each_entry_safe(entry, n, &dsp_elements, list)
+		if (entry->elem == elem) {
+			list_del(&entry->list);
+			device_unregister(&entry->dev);
+			kfree(entry);
+			printk(KERN_DEBUG "%s: %s unregistered\n",
+				__func__, elem->name);
+			return;
+		}
+	printk(KERN_ERR "%s: element %s not in list.\n", __func__, elem->name);
+}
+EXPORT_SYMBOL(mISDN_dsp_element_unregister);
+
+int dsp_pipeline_module_init(void)
+{
+	elements_class = class_create(THIS_MODULE, "dsp_pipeline");
+	if (IS_ERR(elements_class))
+		return PTR_ERR(elements_class);
+
+#ifdef PIPELINE_DEBUG
+	printk(KERN_DEBUG "%s: dsp pipeline module initialized\n", __func__);
+#endif
+
+	dsp_hwec_init();
+
+	return 0;
+}
+
+void dsp_pipeline_module_exit(void)
+{
+	struct dsp_element_entry *entry, *n;
+
+	dsp_hwec_exit();
+
+	class_destroy(elements_class);
+
+	list_for_each_entry_safe(entry, n, &dsp_elements, list) {
+		list_del(&entry->list);
+		printk(KERN_WARNING "%s: element was still registered: %s\n",
+			__func__, entry->elem->name);
+		kfree(entry);
+	}
+
+	printk(KERN_DEBUG "%s: dsp pipeline module exited\n", __func__);
+}
+
+int dsp_pipeline_init(struct dsp_pipeline *pipeline)
+{
+	if (!pipeline)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&pipeline->list);
+
+#ifdef PIPELINE_DEBUG
+	printk(KERN_DEBUG "%s: dsp pipeline ready\n", __func__);
+#endif
+
+	return 0;
+}
+
+static inline void _dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
+{
+	struct dsp_pipeline_entry *entry, *n;
+
+	list_for_each_entry_safe(entry, n, &pipeline->list, list) {
+		list_del(&entry->list);
+		if (entry->elem == dsp_hwec)
+			dsp_hwec_disable(container_of(pipeline, struct dsp,
+				pipeline));
+		else
+			entry->elem->free(entry->p);
+		kfree(entry);
+	}
+}
+
+void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
+{
+
+	if (!pipeline)
+		return;
+
+	_dsp_pipeline_destroy(pipeline);
+
+#ifdef PIPELINE_DEBUG
+	printk(KERN_DEBUG "%s: dsp pipeline destroyed\n", __func__);
+#endif
+}
+
+int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
+{
+	int len, incomplete = 0, found = 0;
+	char *dup, *tok, *name, *args;
+	struct dsp_element_entry *entry, *n;
+	struct dsp_pipeline_entry *pipeline_entry;
+	struct mISDN_dsp_element *elem;
+
+	if (!pipeline)
+		return -EINVAL;
+
+	if (!list_empty(&pipeline->list))
+		_dsp_pipeline_destroy(pipeline);
+
+	if (!cfg)
+		return 0;
+
+	len = strlen(cfg);
+	if (!len)
+		return 0;
+
+	dup = kmalloc(len + 1, GFP_KERNEL);
+	if (!dup)
+		return 0;
+	strcpy(dup, cfg);
+	while ((tok = strsep(&dup, "|"))) {
+		if (!strlen(tok))
+			continue;
+		name = strsep(&tok, "(");
+		args = strsep(&tok, ")");
+		if (args && !*args)
+			args = 0;
+
+		list_for_each_entry_safe(entry, n, &dsp_elements, list)
+			if (!strcmp(entry->elem->name, name)) {
+				elem = entry->elem;
+
+				pipeline_entry = kmalloc(sizeof(struct
+					dsp_pipeline_entry), GFP_KERNEL);
+				if (!pipeline_entry) {
+					printk(KERN_DEBUG "%s: failed to add "
+					    "entry to pipeline: %s (out of "
+					    "memory)\n", __func__, elem->name);
+					incomplete = 1;
+					goto _out;
+				}
+				pipeline_entry->elem = elem;
+
+				if (elem == dsp_hwec) {
+					/* This is a hack to make the hwec
+					   available as a pipeline module */
+					dsp_hwec_enable(container_of(pipeline,
+						struct dsp, pipeline), args);
+					list_add_tail(&pipeline_entry->list,
+						&pipeline->list);
+				} else {
+					pipeline_entry->p = elem->new(args);
+					if (pipeline_entry->p) {
+						list_add_tail(&pipeline_entry->
+							list, &pipeline->list);
+#ifdef PIPELINE_DEBUG
+						printk(KERN_DEBUG "%s: created "
+						    "instance of %s%s%s\n",
+						    __func__, name, args ?
+						    " with args " : "", args ?
+						    args : "");
+#endif
+					} else {
+						printk(KERN_DEBUG "%s: failed "
+						  "to add entry to pipeline: "
+						  "%s (new() returned NULL)\n",
+						  __func__, elem->name);
+						kfree(pipeline_entry);
+						incomplete = 1;
+					}
+				}
+				found = 1;
+				break;
+			}
+
+		if (found)
+			found = 0;
+		else {
+			printk(KERN_DEBUG "%s: element not found, skipping: "
+				"%s\n", __func__, name);
+			incomplete = 1;
+		}
+	}
+
+_out:
+	if (!list_empty(&pipeline->list))
+		pipeline->inuse = 1;
+	else
+		pipeline->inuse = 0;
+
+#ifdef PIPELINE_DEBUG
+	printk(KERN_DEBUG "%s: dsp pipeline built%s: %s\n",
+		__func__, incomplete ? " incomplete" : "", cfg);
+#endif
+	kfree(dup);
+	return 0;
+}
+
+void dsp_pipeline_process_tx(struct dsp_pipeline *pipeline, u8 *data, int len)
+{
+	struct dsp_pipeline_entry *entry;
+
+	if (!pipeline)
+		return;
+
+	list_for_each_entry(entry, &pipeline->list, list)
+		if (entry->elem->process_tx)
+			entry->elem->process_tx(entry->p, data, len);
+}
+
+void dsp_pipeline_process_rx(struct dsp_pipeline *pipeline, u8 *data, int len)
+{
+	struct dsp_pipeline_entry *entry;
+
+	if (!pipeline)
+		return;
+
+	list_for_each_entry_reverse(entry, &pipeline->list, list)
+		if (entry->elem->process_rx)
+			entry->elem->process_rx(entry->p, data, len);
+}
+
+
diff --git a/drivers/isdn/mISDN/dsp_tones.c b/drivers/isdn/mISDN/dsp_tones.c
new file mode 100644
index 0000000..23dd0dd
--- /dev/null
+++ b/drivers/isdn/mISDN/dsp_tones.c
@@ -0,0 +1,551 @@
+/*
+ * Audio support data for ISDN4Linux.
+ *
+ * Copyright Andreas Eversberg (jolly@eversberg.eu)
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ *
+ */
+
+#include <linux/mISDNif.h>
+#include <linux/mISDNdsp.h>
+#include "core.h"
+#include "dsp.h"
+
+
+#define DATA_S sample_silence
+#define SIZE_S (&sizeof_silence)
+#define DATA_GA sample_german_all
+#define SIZE_GA (&sizeof_german_all)
+#define DATA_GO sample_german_old
+#define SIZE_GO (&sizeof_german_old)
+#define DATA_DT sample_american_dialtone
+#define SIZE_DT (&sizeof_american_dialtone)
+#define DATA_RI sample_american_ringing
+#define SIZE_RI (&sizeof_american_ringing)
+#define DATA_BU sample_american_busy
+#define SIZE_BU (&sizeof_american_busy)
+#define DATA_S1 sample_special1
+#define SIZE_S1 (&sizeof_special1)
+#define DATA_S2 sample_special2
+#define SIZE_S2 (&sizeof_special2)
+#define DATA_S3 sample_special3
+#define SIZE_S3 (&sizeof_special3)
+
+/***************/
+/* tones loops */
+/***************/
+
+/* all tones are alaw encoded */
+/* the last sample+1 is in phase with the first sample. the error is low */
+
+static u8 sample_german_all[] = {
+	0x80, 0xab, 0x81, 0x6d, 0xfd, 0xdd, 0x5d, 0x9d,
+	0x4d, 0xd1, 0x89, 0x88, 0xd0, 0x4c, 0x9c, 0x5c,
+	0xdc, 0xfc, 0x6c,
+	0x80, 0xab, 0x81, 0x6d, 0xfd, 0xdd, 0x5d, 0x9d,
+	0x4d, 0xd1, 0x89, 0x88, 0xd0, 0x4c, 0x9c, 0x5c,
+	0xdc, 0xfc, 0x6c,
+	0x80, 0xab, 0x81, 0x6d, 0xfd, 0xdd, 0x5d, 0x9d,
+	0x4d, 0xd1, 0x89, 0x88, 0xd0, 0x4c, 0x9c, 0x5c,
+	0xdc, 0xfc, 0x6c,
+	0x80, 0xab, 0x81, 0x6d, 0xfd, 0xdd, 0x5d, 0x9d,
+	0x4d, 0xd1, 0x89, 0x88, 0xd0, 0x4c, 0x9c, 0x5c,
+	0xdc, 0xfc, 0x6c,
+};
+static u32 sizeof_german_all = sizeof(sample_german_all);
+
+static u8 sample_german_old[] = {
+	0xec, 0x68, 0xe1, 0x6d, 0x6d, 0x91, 0x51, 0xed,
+	0x6d, 0x01, 0x1e, 0x10, 0x0c, 0x90, 0x60, 0x70,
+	0x8c,
+	0xec, 0x68, 0xe1, 0x6d, 0x6d, 0x91, 0x51, 0xed,
+	0x6d, 0x01, 0x1e, 0x10, 0x0c, 0x90, 0x60, 0x70,
+	0x8c,
+	0xec, 0x68, 0xe1, 0x6d, 0x6d, 0x91, 0x51, 0xed,
+	0x6d, 0x01, 0x1e, 0x10, 0x0c, 0x90, 0x60, 0x70,
+	0x8c,
+	0xec, 0x68, 0xe1, 0x6d, 0x6d, 0x91, 0x51, 0xed,
+	0x6d, 0x01, 0x1e, 0x10, 0x0c, 0x90, 0x60, 0x70,
+	0x8c,
+};
+static u32 sizeof_german_old = sizeof(sample_german_old);
+
+static u8 sample_american_dialtone[] = {
+	0x2a, 0x18, 0x90, 0x6c, 0x4c, 0xbc, 0x4c, 0x6c,
+	0x10, 0x58, 0x32, 0xb9, 0x31, 0x2d, 0x8d, 0x0d,
+	0x8d, 0x2d, 0x31, 0x99, 0x0f, 0x28, 0x60, 0xf0,
+	0xd0, 0x50, 0xd0, 0x30, 0x60, 0x08, 0x8e, 0x67,
+	0x09, 0x19, 0x21, 0xe1, 0xd9, 0xb9, 0x29, 0x67,
+	0x83, 0x02, 0xce, 0xbe, 0xee, 0x1a, 0x1b, 0xef,
+	0xbf, 0xcf, 0x03, 0x82, 0x66, 0x28, 0xb8, 0xd8,
+	0xe0, 0x20, 0x18, 0x08, 0x66, 0x8f, 0x09, 0x61,
+	0x31, 0xd1, 0x51, 0xd1, 0xf1, 0x61, 0x29, 0x0e,
+	0x98, 0x30, 0x2c, 0x8c, 0x0c, 0x8c, 0x2c, 0x30,
+	0xb8, 0x33, 0x59, 0x11, 0x6d, 0x4d, 0xbd, 0x4d,
+	0x6d, 0x91, 0x19,
+};
+static u32 sizeof_american_dialtone = sizeof(sample_american_dialtone);
+
+static u8 sample_american_ringing[] = {
+	0x2a, 0xe0, 0xac, 0x0c, 0xbc, 0x4c, 0x8c, 0x90,
+	0x48, 0xc7, 0xc1, 0xed, 0xcd, 0x4d, 0xcd, 0xed,
+	0xc1, 0xb7, 0x08, 0x30, 0xec, 0xcc, 0xcc, 0x8c,
+	0x10, 0x58, 0x1a, 0x99, 0x71, 0xed, 0x8d, 0x8d,
+	0x2d, 0x41, 0x89, 0x9e, 0x20, 0x70, 0x2c, 0xec,
+	0x2c, 0x70, 0x20, 0x86, 0x77, 0xe1, 0x31, 0x11,
+	0xd1, 0xf1, 0x81, 0x09, 0xa3, 0x56, 0x58, 0x00,
+	0x40, 0xc0, 0x60, 0x38, 0x46, 0x43, 0x57, 0x39,
+	0xd9, 0x59, 0x99, 0xc9, 0x77, 0x2f, 0x2e, 0xc6,
+	0xd6, 0x28, 0xd6, 0x36, 0x26, 0x2e, 0x8a, 0xa3,
+	0x43, 0x63, 0x4b, 0x4a, 0x62, 0x42, 0xa2, 0x8b,
+	0x2f, 0x27, 0x37, 0xd7, 0x29, 0xd7, 0xc7, 0x2f,
+	0x2e, 0x76, 0xc8, 0x98, 0x58, 0xd8, 0x38, 0x56,
+	0x42, 0x47, 0x39, 0x61, 0xc1, 0x41, 0x01, 0x59,
+	0x57, 0xa2, 0x08, 0x80, 0xf0, 0xd0, 0x10, 0x30,
+	0xe0, 0x76, 0x87, 0x21, 0x71, 0x2d, 0xed, 0x2d,
+	0x71, 0x21, 0x9f, 0x88, 0x40, 0x2c, 0x8c, 0x8c,
+	0xec, 0x70, 0x98, 0x1b, 0x59, 0x11, 0x8d, 0xcd,
+	0xcd, 0xed, 0x31, 0x09, 0xb6, 0xc0, 0xec, 0xcc,
+	0x4c, 0xcc, 0xec, 0xc0, 0xc6, 0x49, 0x91, 0x8d,
+	0x4d, 0xbd, 0x0d, 0xad, 0xe1,
+};
+static u32 sizeof_american_ringing = sizeof(sample_american_ringing);
+
+static u8 sample_american_busy[] = {
+	0x2a, 0x00, 0x6c, 0x4c, 0x4c, 0x6c, 0xb0, 0x66,
+	0x99, 0x11, 0x6d, 0x8d, 0x2d, 0x41, 0xd7, 0x96,
+	0x60, 0xf0, 0x70, 0x40, 0x58, 0xf6, 0x53, 0x57,
+	0x09, 0x89, 0xd7, 0x5f, 0xe3, 0x2a, 0xe3, 0x5f,
+	0xd7, 0x89, 0x09, 0x57, 0x53, 0xf6, 0x58, 0x40,
+	0x70, 0xf0, 0x60, 0x96, 0xd7, 0x41, 0x2d, 0x8d,
+	0x6d, 0x11, 0x99, 0x66, 0xb0, 0x6c, 0x4c, 0x4c,
+	0x6c, 0x00, 0x2a, 0x01, 0x6d, 0x4d, 0x4d, 0x6d,
+	0xb1, 0x67, 0x98, 0x10, 0x6c, 0x8c, 0x2c, 0x40,
+	0xd6, 0x97, 0x61, 0xf1, 0x71, 0x41, 0x59, 0xf7,
+	0x52, 0x56, 0x08, 0x88, 0xd6, 0x5e, 0xe2, 0x2a,
+	0xe2, 0x5e, 0xd6, 0x88, 0x08, 0x56, 0x52, 0xf7,
+	0x59, 0x41, 0x71, 0xf1, 0x61, 0x97, 0xd6, 0x40,
+	0x2c, 0x8c, 0x6c, 0x10, 0x98, 0x67, 0xb1, 0x6d,
+	0x4d, 0x4d, 0x6d, 0x01,
+};
+static u32 sizeof_american_busy = sizeof(sample_american_busy);
+
+static u8 sample_special1[] = {
+	0x2a, 0x2c, 0xbc, 0x6c, 0xd6, 0x71, 0xbd, 0x0d,
+	0xd9, 0x80, 0xcc, 0x4c, 0x40, 0x39, 0x0d, 0xbd,
+	0x11, 0x86, 0xec, 0xbc, 0xec, 0x0e, 0x51, 0xbd,
+	0x8d, 0x89, 0x30, 0x4c, 0xcc, 0xe0, 0xe1, 0xcd,
+	0x4d, 0x31, 0x88, 0x8c, 0xbc, 0x50, 0x0f, 0xed,
+	0xbd, 0xed, 0x87, 0x10, 0xbc, 0x0c, 0x38, 0x41,
+	0x4d, 0xcd, 0x81, 0xd8, 0x0c, 0xbc, 0x70, 0xd7,
+	0x6d, 0xbd, 0x2d,
+};
+static u32 sizeof_special1 = sizeof(sample_special1);
+
+static u8 sample_special2[] = {
+	0x2a, 0xcc, 0x8c, 0xd7, 0x4d, 0x2d, 0x18, 0xbc,
+	0x10, 0xc1, 0xbd, 0xc1, 0x10, 0xbc, 0x18, 0x2d,
+	0x4d, 0xd7, 0x8c, 0xcc, 0x2a, 0xcd, 0x8d, 0xd6,
+	0x4c, 0x2c, 0x19, 0xbd, 0x11, 0xc0, 0xbc, 0xc0,
+	0x11, 0xbd, 0x19, 0x2c, 0x4c, 0xd6, 0x8d, 0xcd,
+	0x2a, 0xcc, 0x8c, 0xd7, 0x4d, 0x2d, 0x18, 0xbc,
+	0x10, 0xc1, 0xbd, 0xc1, 0x10, 0xbc, 0x18, 0x2d,
+	0x4d, 0xd7, 0x8c, 0xcc, 0x2a, 0xcd, 0x8d, 0xd6,
+	0x4c, 0x2c, 0x19, 0xbd, 0x11, 0xc0, 0xbc, 0xc0,
+	0x11, 0xbd, 0x19, 0x2c, 0x4c, 0xd6, 0x8d, 0xcd,
+};
+static u32 sizeof_special2 = sizeof(sample_special2);
+
+static u8 sample_special3[] = {
+	0x2a, 0xbc, 0x18, 0xcd, 0x11, 0x2c, 0x8c, 0xc1,
+	0x4d, 0xd6, 0xbc, 0xd6, 0x4d, 0xc1, 0x8c, 0x2c,
+	0x11, 0xcd, 0x18, 0xbc, 0x2a, 0xbd, 0x19, 0xcc,
+	0x10, 0x2d, 0x8d, 0xc0, 0x4c, 0xd7, 0xbd, 0xd7,
+	0x4c, 0xc0, 0x8d, 0x2d, 0x10, 0xcc, 0x19, 0xbd,
+	0x2a, 0xbc, 0x18, 0xcd, 0x11, 0x2c, 0x8c, 0xc1,
+	0x4d, 0xd6, 0xbc, 0xd6, 0x4d, 0xc1, 0x8c, 0x2c,
+	0x11, 0xcd, 0x18, 0xbc, 0x2a, 0xbd, 0x19, 0xcc,
+	0x10, 0x2d, 0x8d, 0xc0, 0x4c, 0xd7, 0xbd, 0xd7,
+	0x4c, 0xc0, 0x8d, 0x2d, 0x10, 0xcc, 0x19, 0xbd,
+};
+static u32 sizeof_special3 = sizeof(sample_special3);
+
+static u8 sample_silence[] = {
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+	0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
+};
+static u32 sizeof_silence = sizeof(sample_silence);
+
+struct tones_samples {
+	u32 *len;
+	u8 *data;
+};
+static struct
+tones_samples samples[] = {
+	{&sizeof_german_all, sample_german_all},
+	{&sizeof_german_old, sample_german_old},
+	{&sizeof_american_dialtone, sample_american_dialtone},
+	{&sizeof_american_ringing, sample_american_ringing},
+	{&sizeof_american_busy, sample_american_busy},
+	{&sizeof_special1, sample_special1},
+	{&sizeof_special2, sample_special2},
+	{&sizeof_special3, sample_special3},
+	{NULL, NULL},
+};
+
+/***********************************
+ * generate ulaw from alaw samples *
+ ***********************************/
+
+void
+dsp_audio_generate_ulaw_samples(void)
+{
+	int i, j;
+
+	i = 0;
+	while (samples[i].len) {
+		j = 0;
+		while (j < (*samples[i].len)) {
+			samples[i].data[j] =
+				dsp_audio_alaw_to_ulaw[samples[i].data[j]];
+			j++;
+		}
+		i++;
+	}
+}
+
+
+/****************************
+ * tone sequence definition *
+ ****************************/
+
+struct pattern {
+	int tone;
+	u8 *data[10];
+	u32 *siz[10];
+	u32 seq[10];
+} pattern[] = {
+	{TONE_GERMAN_DIALTONE,
+	{DATA_GA, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GA, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{1900, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_OLDDIALTONE,
+	{DATA_GO, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GO, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{1998, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_AMERICAN_DIALTONE,
+	{DATA_DT, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_DT, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{8000, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_DIALPBX,
+	{DATA_GA, DATA_S, DATA_GA, DATA_S, DATA_GA, DATA_S, 0, 0, 0, 0},
+	{SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, 0, 0, 0, 0},
+	{2000, 2000, 2000, 2000, 2000, 12000, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_OLDDIALPBX,
+	{DATA_GO, DATA_S, DATA_GO, DATA_S, DATA_GO, DATA_S, 0, 0, 0, 0},
+	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, 0, 0, 0, 0},
+	{2000, 2000, 2000, 2000, 2000, 12000, 0, 0, 0, 0} },
+
+	{TONE_AMERICAN_DIALPBX,
+	{DATA_DT, DATA_S, DATA_DT, DATA_S, DATA_DT, DATA_S, 0, 0, 0, 0},
+	{SIZE_DT, SIZE_S, SIZE_DT, SIZE_S, SIZE_DT, SIZE_S, 0, 0, 0, 0},
+	{2000, 2000, 2000, 2000, 2000, 12000, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_RINGING,
+	{DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{8000, 32000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_OLDRINGING,
+	{DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{8000, 40000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_AMERICAN_RINGING,
+	{DATA_RI, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_RI, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{8000, 32000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_RINGPBX,
+	{DATA_GA, DATA_S, DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0},
+	{SIZE_GA, SIZE_S, SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{4000, 4000, 4000, 28000, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_OLDRINGPBX,
+	{DATA_GO, DATA_S, DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0},
+	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{4000, 4000, 4000, 28000, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_AMERICAN_RINGPBX,
+	{DATA_RI, DATA_S, DATA_RI, DATA_S, 0, 0, 0, 0, 0, 0},
+	{SIZE_RI, SIZE_S, SIZE_RI, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{4000, 4000, 4000, 28000, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_BUSY,
+	{DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{4000, 4000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_OLDBUSY,
+	{DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{1000, 5000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_AMERICAN_BUSY,
+	{DATA_BU, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_BU, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{4000, 4000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_HANGUP,
+	{DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{4000, 4000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_OLDHANGUP,
+	{DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{1000, 5000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_AMERICAN_HANGUP,
+	{DATA_DT, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_DT, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{8000, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_SPECIAL_INFO,
+	{DATA_S1, DATA_S2, DATA_S3, DATA_S, 0, 0, 0, 0, 0, 0},
+	{SIZE_S1, SIZE_S2, SIZE_S3, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{2666, 2666, 2666, 8002, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_GASSENBESETZT,
+	{DATA_GA, DATA_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{SIZE_GA, SIZE_S, 0, 0, 0, 0, 0, 0, 0, 0},
+	{2000, 2000, 0, 0, 0, 0, 0, 0, 0, 0} },
+
+	{TONE_GERMAN_AUFSCHALTTON,
+	{DATA_GO, DATA_S, DATA_GO, DATA_S, 0, 0, 0, 0, 0, 0},
+	{SIZE_GO, SIZE_S, SIZE_GO, SIZE_S, 0, 0, 0, 0, 0, 0},
+	{1000, 5000, 1000, 17000, 0, 0, 0, 0, 0, 0} },
+
+	{0,
+	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
+	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
+};
+
+/******************
+ * copy tone data *
+ ******************/
+
+/* an sk_buff is generated from the number of samples needed.
+ * the count will be changed and may begin from 0 each pattern period.
+ * the clue is to precalculate the pointers and legths to use only one
+ * memcpy per function call, or two memcpy if the tone sequence changes.
+ *
+ * pattern - the type of the pattern
+ * count - the sample from the beginning of the pattern (phase)
+ * len - the number of bytes
+ *
+ * return - the sk_buff with the sample
+ *
+ * if tones has finished (e.g. knocking tone), dsp->tones is turned off
+ */
+void dsp_tone_copy(struct dsp *dsp, u8 *data, int len)
+{
+	int index, count, start, num;
+	struct pattern *pat;
+	struct dsp_tone *tone = &dsp->tone;
+
+	/* if we have no tone, we copy silence */
+	if (!tone->tone) {
+		memset(data, dsp_silence, len);
+		return;
+	}
+
+	/* process pattern */
+	pat = (struct pattern *)tone->pattern;
+		/* points to the current pattern */
+	index = tone->index; /* gives current sequence index */
+	count = tone->count; /* gives current sample */
+
+	/* copy sample */
+	while (len) {
+		/* find sample to start with */
+		while (42) {
+			/* warp arround */
+			if (!pat->seq[index]) {
+				count = 0;
+				index = 0;
+			}
+			/* check if we are currently playing this tone */
+			if (count < pat->seq[index])
+				break;
+			if (dsp_debug & DEBUG_DSP_TONE)
+				printk(KERN_DEBUG "%s: reaching next sequence "
+					"(index=%d)\n", __func__, index);
+			count -= pat->seq[index];
+			index++;
+		}
+		/* calculate start and number of samples */
+		start = count % (*(pat->siz[index]));
+		num = len;
+		if (num+count > pat->seq[index])
+			num = pat->seq[index] - count;
+		if (num+start > (*(pat->siz[index])))
+			num = (*(pat->siz[index])) - start;
+		/* copy memory */
+		memcpy(data, pat->data[index]+start, num);
+		/* reduce length */
+		data += num;
+		count += num;
+		len -= num;
+	}
+	tone->index = index;
+	tone->count = count;
+
+	/* return sk_buff */
+	return;
+}
+
+
+/*******************************
+ * send HW message to hfc card *
+ *******************************/
+
+static void
+dsp_tone_hw_message(struct dsp *dsp, u8 *sample, int len)
+{
+	struct sk_buff *nskb;
+
+	/* unlocking is not required, because we don't expect a response */
+	nskb = _alloc_mISDN_skb(PH_CONTROL_REQ,
+		(len)?HFC_SPL_LOOP_ON:HFC_SPL_LOOP_OFF, len, sample,
+		GFP_ATOMIC);
+	if (nskb) {
+		if (dsp->ch.peer) {
+			if (dsp->ch.recv(dsp->ch.peer, nskb))
+				dev_kfree_skb(nskb);
+		} else
+			dev_kfree_skb(nskb);
+	}
+}
+
+
+/*****************
+ * timer expires *
+ *****************/
+void
+dsp_tone_timeout(void *arg)
+{
+	struct dsp *dsp = arg;
+	struct dsp_tone *tone = &dsp->tone;
+	struct pattern *pat = (struct pattern *)tone->pattern;
+	int index = tone->index;
+
+	if (!tone->tone)
+		return;
+
+	index++;
+	if (!pat->seq[index])
+		index = 0;
+	tone->index = index;
+
+	/* set next tone */
+	if (pat->data[index] == DATA_S)
+		dsp_tone_hw_message(dsp, 0, 0);
+	else
+		dsp_tone_hw_message(dsp, pat->data[index], *(pat->siz[index]));
+	/* set timer */
+	init_timer(&tone->tl);
+	tone->tl.expires = jiffies + (pat->seq[index] * HZ) / 8000;
+	add_timer(&tone->tl);
+}
+
+
+/********************
+ * set/release tone *
+ ********************/
+
+/*
+ * tones are relaized by streaming or by special loop commands if supported
+ * by hardware. when hardware is used, the patterns will be controlled by
+ * timers.
+ */
+int
+dsp_tone(struct dsp *dsp, int tone)
+{
+	struct pattern *pat;
+	int i;
+	struct dsp_tone *tonet = &dsp->tone;
+
+	tonet->software = 0;
+	tonet->hardware = 0;
+
+	/* we turn off the tone */
+	if (!tone) {
+		if (dsp->features.hfc_loops)
+		if (timer_pending(&tonet->tl))
+			del_timer(&tonet->tl);
+		if (dsp->features.hfc_loops)
+			dsp_tone_hw_message(dsp, NULL, 0);
+		tonet->tone = 0;
+		return 0;
+	}
+
+	pat = NULL;
+	i = 0;
+	while (pattern[i].tone) {
+		if (pattern[i].tone == tone) {
+			pat = &pattern[i];
+			break;
+		}
+		i++;
+	}
+	if (!pat) {
+		printk(KERN_WARNING "dsp: given tone 0x%x is invalid\n", tone);
+		return -EINVAL;
+	}
+	if (dsp_debug & DEBUG_DSP_TONE)
+		printk(KERN_DEBUG "%s: now starting tone %d (index=%d)\n",
+			__func__, tone, 0);
+	tonet->tone = tone;
+	tonet->pattern = pat;
+	tonet->index = 0;
+	tonet->count = 0;
+
+	if (dsp->features.hfc_loops) {
+		tonet->hardware = 1;
+		/* set first tone */
+		dsp_tone_hw_message(dsp, pat->data[0], *(pat->siz[0]));
+		/* set timer */
+		if (timer_pending(&tonet->tl))
+			del_timer(&tonet->tl);
+		init_timer(&tonet->tl);
+		tonet->tl.expires = jiffies + (pat->seq[0] * HZ) / 8000;
+		add_timer(&tonet->tl);
+	} else {
+		tonet->software = 1;
+	}
+
+	return 0;
+}
+
+
+
+
+
diff --git a/include/linux/mISDNdsp.h b/include/linux/mISDNdsp.h
new file mode 100644
index 0000000..6b71d2d
--- /dev/null
+++ b/include/linux/mISDNdsp.h
@@ -0,0 +1,37 @@
+#ifndef __mISDNdsp_H__
+#define __mISDNdsp_H__
+
+struct mISDN_dsp_element_arg {
+	char	*name;
+	char	*def;
+	char	*desc;
+};
+
+struct mISDN_dsp_element {
+	char	*name;
+	void	*(*new)(const char *arg);
+	void	(*free)(void *p);
+	void	(*process_tx)(void *p, unsigned char *data, int len);
+	void	(*process_rx)(void *p, unsigned char *data, int len);
+	int	num_args;
+	struct mISDN_dsp_element_arg
+		*args;
+};
+
+extern int  mISDN_dsp_element_register(struct mISDN_dsp_element *elem);
+extern void mISDN_dsp_element_unregister(struct mISDN_dsp_element *elem);
+
+struct dsp_features {
+	int	hfc_id; /* unique id to identify the chip (or -1) */
+	int	hfc_dtmf; /* set if HFCmulti card supports dtmf */
+	int	hfc_loops; /* set if card supports tone loops */
+	int	hfc_echocanhw; /* set if card supports echocancelation*/
+	int	pcm_id; /* unique id to identify the pcm bus (or -1) */
+	int	pcm_slots; /* number of slots on the pcm bus */
+	int	pcm_banks; /* number of IO banks of pcm bus */
+	int	unclocked; /* data is not clocked (has jitter/loss) */
+	int	unordered; /* data is unordered (packets have index) */
+};
+
+#endif
+
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
