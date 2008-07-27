Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYG0BSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYG0BSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbYG0BSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:18:09 -0400
Received: from mx1.suse.de ([195.135.220.2]:42934 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbYG0BSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:18:04 -0400
Date: Sun, 27 Jul 2008 03:18:01 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] Add layer1 over IP support
Message-ID: <20080727011801.GG3415@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a ISDN over IP tunnel to use mISDN hardware on
remote locations.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/Kconfig       |   19 +-
 drivers/isdn/mISDN/Makefile      |    2 +
 drivers/isdn/mISDN/l1oip.h       |   91 +++
 drivers/isdn/mISDN/l1oip_codec.c |  374 ++++++++++
 drivers/isdn/mISDN/l1oip_core.c  | 1518 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 2003 insertions(+), 1 deletions(-)
 create mode 100644 drivers/isdn/mISDN/l1oip.h
 create mode 100644 drivers/isdn/mISDN/l1oip_codec.c
 create mode 100644 drivers/isdn/mISDN/l1oip_core.c

diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index 6a97e86..4938355 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -23,5 +23,22 @@ config MISDN_DSP
 	  and get more informations about this module and it's usage.
 	  If unsure, say 'N'.
 
-	source "drivers/isdn/hardware/mISDN/Kconfig"
+config MISDN_L1OIP
+	tristate "ISDN over IP tunnel"
+	depends on MISDN
+	help
+	  Enable support for ISDN over IP tunnel.
+
+	  It features:
+	    - dynamic IP exchange, if one or both peers have dynamic IPs
+	    - BRI (S0) and PRI (S2M) interface
+	    - layer 1 control via network keepalive frames
+	    - direct tunneling of physical interface via IP
+
+	  NOTE: This protocol is called 'Layer 1 over IP' and is not
+	  compatible with ISDNoIP (Agfeo) or TDMoIP. Protocol description is
+	  provided in the source code.
+
+source "drivers/isdn/hardware/mISDN/Kconfig"
+
 endif #MISDN
diff --git a/drivers/isdn/mISDN/Makefile b/drivers/isdn/mISDN/Makefile
index 7f1a218..1cb5e63 100644
--- a/drivers/isdn/mISDN/Makefile
+++ b/drivers/isdn/mISDN/Makefile
@@ -4,8 +4,10 @@
 
 obj-$(CONFIG_MISDN) += mISDN_core.o
 obj-$(CONFIG_MISDN_DSP) += mISDN_dsp.o
+obj-$(CONFIG_MISDN_L1OIP) += l1oip.o
 
 # multi objects
 
 mISDN_core-objs := core.o fsm.o socket.o hwchannel.o stack.o layer1.o layer2.o tei.o timerdev.o
 mISDN_dsp-objs := dsp_core.o dsp_cmx.o dsp_tones.o dsp_dtmf.o dsp_audio.o dsp_blowfish.o dsp_pipeline.o dsp_hwec.o
+l1oip-objs := l1oip_core.o l1oip_codec.o
diff --git a/drivers/isdn/mISDN/l1oip.h b/drivers/isdn/mISDN/l1oip.h
new file mode 100644
index 0000000..a23d575
--- /dev/null
+++ b/drivers/isdn/mISDN/l1oip.h
@@ -0,0 +1,91 @@
+/*
+ * see notice in l1oip.c
+ */
+
+/* debugging */
+#define DEBUG_L1OIP_INIT	0x00010000
+#define DEBUG_L1OIP_SOCKET	0x00020000
+#define DEBUG_L1OIP_MGR		0x00040000
+#define DEBUG_L1OIP_MSG		0x00080000
+
+/* enable to disorder received bchannels by sequence 2143658798... */
+/*
+#define REORDER_DEBUG
+*/
+
+/* frames */
+#define L1OIP_MAX_LEN		2048		/* max packet size form l2 */
+#define L1OIP_MAX_PERFRAME	1400		/* max data size in one frame */
+
+
+/* timers */
+#define L1OIP_KEEPALIVE		15
+#define L1OIP_TIMEOUT		65
+
+
+/* socket */
+#define L1OIP_DEFAULTPORT	931
+
+
+/* channel structure */
+struct l1oip_chan {
+	struct dchannel       	*dch;
+	struct bchannel       	*bch;
+	u32			tx_counter;	/* counts xmit bytes/packets */
+	u32			rx_counter;	/* counts recv bytes/packets */
+	u32			codecstate;	/* used by codec to save data */
+#ifdef REORDER_DEBUG
+	int			disorder_flag;
+	struct sk_buff		*disorder_skb;
+	u32			disorder_cnt;
+#endif
+};
+
+
+/* card structure */
+struct l1oip {
+	struct list_head        list;
+
+	/* card */
+	int			registered;	/* if registered with mISDN */
+	char			name[MISDN_MAX_IDLEN];
+	int			idx;		/* card index */
+	int			pri;		/* 1=pri, 0=bri */
+	int			d_idx;		/* current dchannel number */
+	int			b_num;		/* number of bchannels */
+	u32			id;		/* id of connection */
+	int			ondemand;	/* if transmis. is on demand */
+	int			bundle;		/* bundle channels in one frm */
+	int			codec;		/* codec to use for transmis. */
+	int			limit;		/* limit number of bchannels */
+
+	/* timer */
+	struct timer_list 	keep_tl;
+	struct timer_list 	timeout_tl;
+	int			timeout_on;
+	struct work_struct	workq;
+
+	/* socket */
+	struct socket 		*socket;	/* if set, socket is created */
+	struct completion 	socket_complete;/* completion of sock thread */
+	struct task_struct	*socket_thread;
+	spinlock_t 		socket_lock;	/* access sock outside thread */
+	u32			remoteip;	/* if all set, ip is assigned */
+	u16	 		localport;	/* must always be set */
+	u16	 		remoteport;	/* must always be set */
+	struct sockaddr_in	sin_local;	/* local socket name */
+	struct sockaddr_in	sin_remote;	/* remote socket name */
+	struct msghdr		sendmsg;	/* ip message to send */
+	struct iovec		sendiov;	/* iov for message */
+
+	/* frame */
+	struct l1oip_chan	chan[128];	/* channel instances */
+};
+
+extern int l1oip_law_to_4bit(u8 *data, int len, u8 *result, u32 *state);
+extern int l1oip_4bit_to_law(u8 *data, int len, u8 *result);
+extern int l1oip_alaw_to_ulaw(u8 *data, int len, u8 *result);
+extern int l1oip_ulaw_to_alaw(u8 *data, int len, u8 *result);
+extern void l1oip_4bit_free(void);
+extern int l1oip_4bit_alloc(int ulaw);
+
diff --git a/drivers/isdn/mISDN/l1oip_codec.c b/drivers/isdn/mISDN/l1oip_codec.c
new file mode 100644
index 0000000..a2dc457
--- /dev/null
+++ b/drivers/isdn/mISDN/l1oip_codec.c
@@ -0,0 +1,374 @@
+/*
+
+ * l1oip_codec.c  generic codec using lookup table
+ *  -> conversion from a-Law to u-Law
+ *  -> conversion from u-Law to a-Law
+ *  -> compression by reducing the number of sample resolution to 4
+ *
+ * NOTE: It is not compatible with any standard codec like ADPCM.
+ *
+ * Author	Andreas Eversberg (jolly@eversberg.eu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+ */
+
+/*
+
+How the codec works:
+--------------------
+
+The volume is increased to increase the dynamic range of the audio signal.
+Each sample is converted to a-LAW with only 16 steps of level resolution.
+A pair of two samples are stored in one byte.
+
+The first byte is stored in the upper bits, the second byte is stored in the
+lower bits.
+
+To speed up compression and decompression, two lookup tables are formed:
+
+- 16 bits index for two samples (law encoded) with 8 bit compressed result.
+- 8 bits index for one compressed data with 16 bits decompressed result.
+
+NOTE: The bytes are handled as they are law-encoded.
+
+*/
+
+#include <linux/vmalloc.h>
+#include <linux/mISDNif.h>
+#include "core.h"
+
+/* definitions of codec. don't use calculations, code may run slower. */
+
+static u8 *table_com;
+static u16 *table_dec;
+
+
+/* alaw -> ulaw */
+static u8 alaw_to_ulaw[256] =
+{
+	0xab, 0x2b, 0xe3, 0x63, 0x8b, 0x0b, 0xc9, 0x49,
+	0xba, 0x3a, 0xf6, 0x76, 0x9b, 0x1b, 0xd7, 0x57,
+	0xa3, 0x23, 0xdd, 0x5d, 0x83, 0x03, 0xc1, 0x41,
+	0xb2, 0x32, 0xeb, 0x6b, 0x93, 0x13, 0xcf, 0x4f,
+	0xaf, 0x2f, 0xe7, 0x67, 0x8f, 0x0f, 0xcd, 0x4d,
+	0xbe, 0x3e, 0xfe, 0x7e, 0x9f, 0x1f, 0xdb, 0x5b,
+	0xa7, 0x27, 0xdf, 0x5f, 0x87, 0x07, 0xc5, 0x45,
+	0xb6, 0x36, 0xef, 0x6f, 0x97, 0x17, 0xd3, 0x53,
+	0xa9, 0x29, 0xe1, 0x61, 0x89, 0x09, 0xc7, 0x47,
+	0xb8, 0x38, 0xf2, 0x72, 0x99, 0x19, 0xd5, 0x55,
+	0xa1, 0x21, 0xdc, 0x5c, 0x81, 0x01, 0xbf, 0x3f,
+	0xb0, 0x30, 0xe9, 0x69, 0x91, 0x11, 0xce, 0x4e,
+	0xad, 0x2d, 0xe5, 0x65, 0x8d, 0x0d, 0xcb, 0x4b,
+	0xbc, 0x3c, 0xfa, 0x7a, 0x9d, 0x1d, 0xd9, 0x59,
+	0xa5, 0x25, 0xde, 0x5e, 0x85, 0x05, 0xc3, 0x43,
+	0xb4, 0x34, 0xed, 0x6d, 0x95, 0x15, 0xd1, 0x51,
+	0xac, 0x2c, 0xe4, 0x64, 0x8c, 0x0c, 0xca, 0x4a,
+	0xbb, 0x3b, 0xf8, 0x78, 0x9c, 0x1c, 0xd8, 0x58,
+	0xa4, 0x24, 0xde, 0x5e, 0x84, 0x04, 0xc2, 0x42,
+	0xb3, 0x33, 0xec, 0x6c, 0x94, 0x14, 0xd0, 0x50,
+	0xb0, 0x30, 0xe8, 0x68, 0x90, 0x10, 0xce, 0x4e,
+	0xbf, 0x3f, 0xfe, 0x7e, 0xa0, 0x20, 0xdc, 0x5c,
+	0xa8, 0x28, 0xe0, 0x60, 0x88, 0x08, 0xc6, 0x46,
+	0xb7, 0x37, 0xf0, 0x70, 0x98, 0x18, 0xd4, 0x54,
+	0xaa, 0x2a, 0xe2, 0x62, 0x8a, 0x0a, 0xc8, 0x48,
+	0xb9, 0x39, 0xf4, 0x74, 0x9a, 0x1a, 0xd6, 0x56,
+	0xa2, 0x22, 0xdd, 0x5d, 0x82, 0x02, 0xc0, 0x40,
+	0xb1, 0x31, 0xea, 0x6a, 0x92, 0x12, 0xcf, 0x4f,
+	0xae, 0x2e, 0xe6, 0x66, 0x8e, 0x0e, 0xcc, 0x4c,
+	0xbd, 0x3d, 0xfc, 0x7c, 0x9e, 0x1e, 0xda, 0x5a,
+	0xa6, 0x26, 0xdf, 0x5f, 0x86, 0x06, 0xc4, 0x44,
+	0xb5, 0x35, 0xee, 0x6e, 0x96, 0x16, 0xd2, 0x52
+};
+
+/* ulaw -> alaw */
+static u8 ulaw_to_alaw[256] =
+{
+	0xab, 0x55, 0xd5, 0x15, 0x95, 0x75, 0xf5, 0x35,
+	0xb5, 0x45, 0xc5, 0x05, 0x85, 0x65, 0xe5, 0x25,
+	0xa5, 0x5d, 0xdd, 0x1d, 0x9d, 0x7d, 0xfd, 0x3d,
+	0xbd, 0x4d, 0xcd, 0x0d, 0x8d, 0x6d, 0xed, 0x2d,
+	0xad, 0x51, 0xd1, 0x11, 0x91, 0x71, 0xf1, 0x31,
+	0xb1, 0x41, 0xc1, 0x01, 0x81, 0x61, 0xe1, 0x21,
+	0x59, 0xd9, 0x19, 0x99, 0x79, 0xf9, 0x39, 0xb9,
+	0x49, 0xc9, 0x09, 0x89, 0x69, 0xe9, 0x29, 0xa9,
+	0xd7, 0x17, 0x97, 0x77, 0xf7, 0x37, 0xb7, 0x47,
+	0xc7, 0x07, 0x87, 0x67, 0xe7, 0x27, 0xa7, 0xdf,
+	0x9f, 0x7f, 0xff, 0x3f, 0xbf, 0x4f, 0xcf, 0x0f,
+	0x8f, 0x6f, 0xef, 0x2f, 0x53, 0x13, 0x73, 0x33,
+	0xb3, 0x43, 0xc3, 0x03, 0x83, 0x63, 0xe3, 0x23,
+	0xa3, 0x5b, 0xdb, 0x1b, 0x9b, 0x7b, 0xfb, 0x3b,
+	0xbb, 0xbb, 0x4b, 0x4b, 0xcb, 0xcb, 0x0b, 0x0b,
+	0x8b, 0x8b, 0x6b, 0x6b, 0xeb, 0xeb, 0x2b, 0x2b,
+	0xab, 0x54, 0xd4, 0x14, 0x94, 0x74, 0xf4, 0x34,
+	0xb4, 0x44, 0xc4, 0x04, 0x84, 0x64, 0xe4, 0x24,
+	0xa4, 0x5c, 0xdc, 0x1c, 0x9c, 0x7c, 0xfc, 0x3c,
+	0xbc, 0x4c, 0xcc, 0x0c, 0x8c, 0x6c, 0xec, 0x2c,
+	0xac, 0x50, 0xd0, 0x10, 0x90, 0x70, 0xf0, 0x30,
+	0xb0, 0x40, 0xc0, 0x00, 0x80, 0x60, 0xe0, 0x20,
+	0x58, 0xd8, 0x18, 0x98, 0x78, 0xf8, 0x38, 0xb8,
+	0x48, 0xc8, 0x08, 0x88, 0x68, 0xe8, 0x28, 0xa8,
+	0xd6, 0x16, 0x96, 0x76, 0xf6, 0x36, 0xb6, 0x46,
+	0xc6, 0x06, 0x86, 0x66, 0xe6, 0x26, 0xa6, 0xde,
+	0x9e, 0x7e, 0xfe, 0x3e, 0xbe, 0x4e, 0xce, 0x0e,
+	0x8e, 0x6e, 0xee, 0x2e, 0x52, 0x12, 0x72, 0x32,
+	0xb2, 0x42, 0xc2, 0x02, 0x82, 0x62, 0xe2, 0x22,
+	0xa2, 0x5a, 0xda, 0x1a, 0x9a, 0x7a, 0xfa, 0x3a,
+	0xba, 0xba, 0x4a, 0x4a, 0xca, 0xca, 0x0a, 0x0a,
+	0x8a, 0x8a, 0x6a, 0x6a, 0xea, 0xea, 0x2a, 0x2a
+};
+
+/* alaw -> 4bit compression */
+static u8 alaw_to_4bit[256] = {
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x08, 0x07, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x09, 0x06, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x08, 0x07, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x09, 0x06, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x08, 0x07, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0d, 0x02,
+	0x0e, 0x02, 0x09, 0x06, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x08, 0x07, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x09, 0x06, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x08, 0x07, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x09, 0x06, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x02, 0x09, 0x06, 0x0f, 0x00, 0x0b, 0x04,
+	0x0d, 0x02, 0x08, 0x07, 0x0f, 0x01, 0x0a, 0x05,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x09, 0x07, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x08, 0x07, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x09, 0x06, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x08, 0x07, 0x0f, 0x00, 0x0b, 0x04,
+	0x0e, 0x01, 0x0a, 0x05, 0x0f, 0x00, 0x0c, 0x03,
+	0x0d, 0x02, 0x09, 0x06, 0x0f, 0x00, 0x0b, 0x04,
+};
+
+/* 4bit -> alaw decompression */
+static u8 _4bit_to_alaw[16] = {
+	0x5d, 0x51, 0xd9, 0xd7, 0x5f, 0x53, 0xa3, 0x4b,
+	0x2a, 0x3a, 0x22, 0x2e, 0x26, 0x56, 0x20, 0x2c,
+};
+
+/* ulaw -> 4bit compression */
+static u8 ulaw_to_4bit[256] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+	0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+	0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+	0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03,
+	0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x04, 0x04,
+	0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04,
+	0x04, 0x04, 0x04, 0x04, 0x05, 0x05, 0x05, 0x05,
+	0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05,
+	0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06,
+	0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
+	0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x08,
+	0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
+	0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
+	0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
+	0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
+	0x0f, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
+	0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e, 0x0e,
+	0x0e, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d,
+	0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d, 0x0d,
+	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c,
+	0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0c, 0x0b, 0x0b,
+	0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0b,
+	0x0b, 0x0b, 0x0b, 0x0b, 0x0a, 0x0a, 0x0a, 0x0a,
+	0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a,
+	0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09,
+	0x09, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
+	0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x08,
+};
+
+/* 4bit -> ulaw decompression */
+static u8 _4bit_to_ulaw[16] = {
+	0x11, 0x21, 0x31, 0x40, 0x4e, 0x5c, 0x68, 0x71,
+	0xfe, 0xef, 0xe7, 0xdb, 0xcd, 0xbf, 0xaf, 0x9f,
+};
+
+
+/*
+ * Compresses data to the result buffer
+ * The result size must be at least half of the input buffer.
+ * The number of samples also must be even!
+ */
+int
+l1oip_law_to_4bit(u8 *data, int len, u8 *result, u32 *state)
+{
+	int ii, i = 0, o = 0;
+
+	if (!len)
+		return 0;
+
+	/* send saved byte and first input byte */
+	if (*state) {
+		*result++ = table_com[(((*state)<<8)&0xff00) | (*data++)];
+		len--;
+		o++;
+	}
+
+	ii = len >> 1;
+
+	while (i < ii) {
+		*result++ = table_com[(data[0]<<8) | (data[1])];
+		data += 2;
+		i++;
+		o++;
+	}
+
+	/* if len has an odd number, we save byte for next call */
+	if (len & 1)
+		*state = 0x100 + *data;
+	else
+		*state = 0;
+
+	return o;
+}
+
+/* Decompress data to the result buffer
+ * The result size must be the number of sample in packet. (2 * input data)
+ * The number of samples in the result are even!
+ */
+int
+l1oip_4bit_to_law(u8 *data, int len, u8 *result)
+{
+	int i = 0;
+	u16 r;
+
+	while (i < len) {
+		r = table_dec[*data++];
+		*result++ = r>>8;
+		*result++ = r;
+		i++;
+	}
+
+	return len << 1;
+}
+
+
+/*
+ * law conversion
+ */
+int
+l1oip_alaw_to_ulaw(u8 *data, int len, u8 *result)
+{
+	int i = 0;
+
+	while (i < len) {
+		*result++ = alaw_to_ulaw[*data++];
+		i++;
+	}
+
+	return len;
+}
+
+int
+l1oip_ulaw_to_alaw(u8 *data, int len, u8 *result)
+{
+	int i = 0;
+
+	while (i < len) {
+		*result++ = ulaw_to_alaw[*data++];
+		i++;
+	}
+
+	return len;
+}
+
+
+/*
+ * generate/free compression and decompression table
+ */
+void
+l1oip_4bit_free(void)
+{
+	if (table_dec)
+		vfree(table_dec);
+	if (table_com)
+		vfree(table_com);
+	table_com = NULL;
+	table_dec = NULL;
+}
+
+int
+l1oip_4bit_alloc(int ulaw)
+{
+	int i1, i2, c, sample;
+
+	/* in case, it is called again */
+	if (table_dec)
+		return 0;
+
+	/* alloc conversion tables */
+	table_com = vmalloc(65536);
+	table_dec = vmalloc(512);
+	if (!table_com | !table_dec) {
+		l1oip_4bit_free();
+		return -ENOMEM;
+	}
+	memset(table_com, 0, 65536);
+	memset(table_dec, 0, 512);
+	/* generate compression table */
+	i1 = 0;
+	while (i1 < 256) {
+		if (ulaw)
+			c = ulaw_to_4bit[i1];
+		else
+			c = alaw_to_4bit[i1];
+		i2 = 0;
+		while (i2 < 256) {
+			table_com[(i1<<8) | i2] |= (c<<4);
+			table_com[(i2<<8) | i1] |= c;
+			i2++;
+		}
+		i1++;
+	}
+
+	/* generate decompression table */
+	i1 = 0;
+	while (i1 < 16) {
+		if (ulaw)
+			sample = _4bit_to_ulaw[i1];
+		else
+			sample = _4bit_to_alaw[i1];
+		i2 = 0;
+		while (i2 < 16) {
+			table_dec[(i1<<4) | i2] |= (sample<<8);
+			table_dec[(i2<<4) | i1] |= sample;
+			i2++;
+		}
+		i1++;
+	}
+
+	return 0;
+}
+
+
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
new file mode 100644
index 0000000..155b997
--- /dev/null
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -0,0 +1,1518 @@
+/*
+
+ * l1oip.c  low level driver for tunneling layer 1 over IP
+ *
+ * NOTE: It is not compatible with TDMoIP nor "ISDN over IP".
+ *
+ * Author	Andreas Eversberg (jolly@eversberg.eu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
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
+/* module parameters:
+ * type:
+	Value 1	= BRI
+	Value 2	= PRI
+	Value 3 = BRI (multi channel frame, not supported yet)
+	Value 4 = PRI (multi channel frame, not supported yet)
+	A multi channel frame reduces overhead to a single frame for all
+	b-channels, but increases delay.
+	(NOTE: Multi channel frames are not implemented yet.)
+
+ * codec:
+	Value 0 = transparent (default)
+	Value 1 = transfer ALAW
+	Value 2 = transfer ULAW
+	Value 3 = transfer generic 4 bit compression.
+
+ * ulaw:
+	0 = we use a-Law (default)
+	1 = we use u-Law
+
+ * limit:
+	limitation of B-channels to control bandwidth (1...126)
+	BRI: 1 or 2
+	PRI: 1-30, 31-126 (126, because dchannel ist not counted here)
+	Also limited ressources are used for stack, resulting in less channels.
+	It is possible to have more channels than 30 in PRI mode, this must
+	be supported by the application.
+
+ * ip:
+	byte representation of remote ip address (127.0.0.1 -> 127,0,0,1)
+	If not given or four 0, no remote address is set.
+	For multiple interfaces, concat ip addresses. (127,0,0,1,127,0,0,1)
+
+ * port:
+	port number (local interface)
+	If not given or 0, port 931 is used for fist instance, 932 for next...
+	For multiple interfaces, different ports must be given.
+
+ * remoteport:
+	port number (remote interface)
+	If not given or 0, remote port equals local port
+	For multiple interfaces on equal sites, different ports must be given.
+
+ * ondemand:
+	0 = fixed (always transmit packets, even when remote side timed out)
+	1 = on demand (only transmit packets, when remote side is detected)
+	the default is 0
+	NOTE: ID must also be set for on demand.
+
+ * id:
+	optional value to identify frames. This value must be equal on both
+	peers and should be random. If omitted or 0, no ID is transmitted.
+
+ * debug:
+	NOTE: only one debug value must be given for all cards
+	enable debugging (see l1oip.h for debug options)
+
+
+Special mISDN controls:
+
+ op = MISDN_CTRL_SETPEER*
+ p1 = bytes 0-3 : remote IP address in network order (left element first)
+ p2 = bytes 1-2 : remote port in network order (high byte first)
+ optional:
+ p2 = bytes 3-4 : local port in network order (high byte first)
+
+ op = MISDN_CTRL_UNSETPEER*
+
+ * Use l1oipctrl for comfortable setting or removing ip address.
+   (Layer 1 Over IP CTRL)
+
+
+L1oIP-Protocol
+--------------
+
+Frame Header:
+
+ 7 6 5 4 3 2 1 0
++---------------+
+|Ver|T|I|Coding |
++---------------+
+|  ID byte 3 *  |
++---------------+
+|  ID byte 2 *  |
++---------------+
+|  ID byte 1 *  |
++---------------+
+|  ID byte 0 *  |
++---------------+
+|M|   Channel   |
++---------------+
+|    Length *   |
++---------------+
+| Time Base MSB |
++---------------+
+| Time Base LSB |
++---------------+
+| Data....	|
+
+...
+
+|               |
++---------------+
+|M|   Channel   |
++---------------+
+|    Length *   |
++---------------+
+| Time Base MSB |
++---------------+
+| Time Base LSB |
++---------------+
+| Data....	|
+
+...
+
+
+* Only included in some cases.
+
+- Ver = Version
+If version is missmatch, the frame must be ignored.
+
+- T = Type of interface
+Must be 0 for S0 or 1 for E1.
+
+- I = Id present
+If bit is set, four ID bytes are included in frame.
+
+- ID = Connection ID
+Additional ID to prevent Denial of Service attacs. Also it prevents hijacking
+connections with dynamic IP. The ID should be random and must not be 0.
+
+- Coding = Type of codec
+Must be 0 for no transcoding. Also for D-channel and other HDLC frames.
+ 1 and 2 are reserved for explicitly use of a-LAW or u-LAW codec.
+ 3 is used for generic table compressor.
+
+- M = More channels to come. If this flag is 1, the following byte contains
+the length of the channel data. After the data block, the next channel will
+be defined. The flag for the last channel block (or if only one channel is
+transmitted), must be 0 and no length is given.
+
+- Channel = Channel number
+0 reserved
+1-3 channel data for S0 (3 is D-channel)
+1-31 channel data for E1 (16 is D-channel)
+32-127 channel data for extended E1 (16 is D-channel)
+
+- The length is used if the M-flag is 1. It is used to find the next channel
+inside frame.
+NOTE: A value of 0 equals 256 bytes of data.
+ -> For larger data blocks, a single frame must be used.
+ -> For larger streams, a single frame or multiple blocks with same channel ID
+   must be used.
+
+- Time Base = Timestamp of first sample in frame
+The "Time Base" is used to rearange packets and to detect packet loss.
+The 16 bits are sent in network order (MSB first) and count 1/8000 th of a
+second. This causes a wrap arround each 8,192 seconds. There is no requirement
+for the initial "Time Base", but 0 should be used for the first packet.
+In case of HDLC data, this timestamp counts the packet or byte number.
+
+
+Two Timers:
+
+After initialisation, a timer of 15 seconds is started. Whenever a packet is
+transmitted, the timer is reset to 15 seconds again. If the timer expires, an
+empty packet is transmitted. This keep the connection alive.
+
+When a valid packet is received, a timer 65 seconds is started. The interface
+become ACTIVE. If the timer expires, the interface becomes INACTIVE.
+
+
+Dynamic IP handling:
+
+To allow dynamic IP, the ID must be non 0. In this case, any packet with the
+correct port number and ID will be accepted. If the remote side changes its IP
+the new IP is used for all transmitted packets until it changes again.
+
+
+On Demand:
+
+If the ondemand parameter is given, the remote IP is set to 0 on timeout.
+This will stop keepalive traffic to remote. If the remote is online again,
+traffic will continue to the remote address. This is usefull for road warriors.
+This feature only works with ID set, otherwhise it is highly unsecure.
+
+
+Socket and Thread
+-----------------
+
+The complete socket opening and closing is done by a thread.
+When the thread opened a socket, the hc->socket descriptor is set. Whenever a
+packet shall be sent to the socket, the hc->socket must be checked wheter not
+NULL. To prevent change in socket descriptor, the hc->socket_lock must be used.
+To change the socket, a recall of l1oip_socket_open() will safely kill the
+socket process and create a new one.
+
+*/
+
+#define L1OIP_VERSION	0	/* 0...3 */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/mISDNif.h>
+#include <linux/mISDNhw.h>
+#include <linux/mISDNdsp.h>
+#include <linux/init.h>
+#include <linux/in.h>
+#include <linux/inet.h>
+#include <linux/workqueue.h>
+#include <linux/kthread.h>
+#include <net/sock.h>
+#include "core.h"
+#include "l1oip.h"
+
+static const char *l1oip_revision = "2.00";
+
+static int l1oip_cnt;
+static spinlock_t l1oip_lock;
+static struct list_head l1oip_ilist;
+
+#define MAX_CARDS	16
+static u_int type[MAX_CARDS];
+static u_int codec[MAX_CARDS];
+static u_int ip[MAX_CARDS*4];
+static u_int port[MAX_CARDS];
+static u_int remoteport[MAX_CARDS];
+static u_int ondemand[MAX_CARDS];
+static u_int limit[MAX_CARDS];
+static u_int id[MAX_CARDS];
+static int debug;
+static int ulaw;
+
+MODULE_AUTHOR("Andreas Eversberg");
+MODULE_LICENSE("GPL");
+module_param_array(type, uint, NULL, S_IRUGO | S_IWUSR);
+module_param_array(codec, uint, NULL, S_IRUGO | S_IWUSR);
+module_param_array(ip, uint, NULL, S_IRUGO | S_IWUSR);
+module_param_array(port, uint, NULL, S_IRUGO | S_IWUSR);
+module_param_array(remoteport, uint, NULL, S_IRUGO | S_IWUSR);
+module_param_array(ondemand, uint, NULL, S_IRUGO | S_IWUSR);
+module_param_array(limit, uint, NULL, S_IRUGO | S_IWUSR);
+module_param_array(id, uint, NULL, S_IRUGO | S_IWUSR);
+module_param(ulaw, uint, S_IRUGO | S_IWUSR);
+module_param(debug, uint, S_IRUGO | S_IWUSR);
+
+/*
+ * send a frame via socket, if open and restart timer
+ */
+static int
+l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
+	u16 timebase, u8 *buf, int len)
+{
+	u8 *p;
+	int multi = 0;
+	u8 frame[len+32];
+	struct socket *socket = NULL;
+	mm_segment_t oldfs;
+
+	if (debug & DEBUG_L1OIP_MSG)
+		printk(KERN_DEBUG "%s: sending data to socket (len = %d)\n",
+			__func__, len);
+
+	p = frame;
+
+	/* restart timer */
+	if ((int)(hc->keep_tl.expires-jiffies) < 5*HZ) {
+		del_timer(&hc->keep_tl);
+		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE*HZ;
+		add_timer(&hc->keep_tl);
+	} else
+		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE*HZ;
+
+	if (debug & DEBUG_L1OIP_MSG)
+		printk(KERN_DEBUG "%s: resetting timer\n", __func__);
+
+	/* drop if we have no remote ip or port */
+	if (!hc->sin_remote.sin_addr.s_addr || !hc->sin_remote.sin_port) {
+		if (debug & DEBUG_L1OIP_MSG)
+			printk(KERN_DEBUG "%s: dropping frame, because remote "
+				"IP is not set.\n", __func__);
+		return len;
+	}
+
+	/* assemble frame */
+	*p++ = (L1OIP_VERSION<<6) /* version and coding */
+	     | (hc->pri?0x20:0x00) /* type */
+	     | (hc->id?0x10:0x00) /* id */
+	     | localcodec;
+	if (hc->id) {
+		*p++ = hc->id>>24; /* id */
+		*p++ = hc->id>>16;
+		*p++ = hc->id>>8;
+		*p++ = hc->id;
+	}
+	*p++ = (multi == 1)?0x80:0x00 + channel; /* m-flag, channel */
+	if (multi == 1)
+		*p++ = len; /* length */
+	*p++ = timebase>>8; /* time base */
+	*p++ = timebase;
+
+	if (buf && len) { /* add data to frame */
+		if (localcodec == 1 && ulaw)
+			l1oip_ulaw_to_alaw(buf, len, p);
+		else if (localcodec == 2 && !ulaw)
+			l1oip_alaw_to_ulaw(buf, len, p);
+		else if (localcodec == 3)
+			len = l1oip_law_to_4bit(buf, len, p,
+				&hc->chan[channel].codecstate);
+		else
+			memcpy(p, buf, len);
+	}
+	len += p - frame;
+
+	/* check for socket in safe condition */
+	spin_lock(&hc->socket_lock);
+	if (!hc->socket) {
+		spin_unlock(&hc->socket_lock);
+		return 0;
+	}
+	/* seize socket */
+	socket = hc->socket;
+	hc->socket = NULL;
+	spin_unlock(&hc->socket_lock);
+	/* send packet */
+	if (debug & DEBUG_L1OIP_MSG)
+		printk(KERN_DEBUG "%s: sending packet to socket (len "
+			"= %d)\n", __func__, len);
+	hc->sendiov.iov_base = frame;
+	hc->sendiov.iov_len  = len;
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+	len = sock_sendmsg(socket, &hc->sendmsg, len);
+	set_fs(oldfs);
+	/* give socket back */
+	hc->socket = socket; /* no locking required */
+
+	return len;
+}
+
+
+/*
+ * receive channel data from socket
+ */
+static void
+l1oip_socket_recv(struct l1oip *hc, u8 remotecodec, u8 channel, u16 timebase,
+	u8 *buf, int len)
+{
+	struct sk_buff *nskb;
+	struct bchannel *bch;
+	struct dchannel *dch;
+	u8 *p;
+	u32 rx_counter;
+
+	if (len == 0) {
+		if (debug & DEBUG_L1OIP_MSG)
+			printk(KERN_DEBUG "%s: received empty keepalive data, "
+				"ignoring\n", __func__);
+		return;
+	}
+
+	if (debug & DEBUG_L1OIP_MSG)
+		printk(KERN_DEBUG "%s: received data, sending to mISDN (%d)\n",
+			__func__, len);
+
+	if (channel < 1 || channel > 127) {
+		printk(KERN_WARNING "%s: packet error - channel %d out of "
+			"range\n", __func__, channel);
+		return;
+	}
+	dch = hc->chan[channel].dch;
+	bch = hc->chan[channel].bch;
+	if (!dch && !bch) {
+		printk(KERN_WARNING "%s: packet error - channel %d not in "
+			"stack\n", __func__, channel);
+		return;
+	}
+
+	/* prepare message */
+	nskb = mI_alloc_skb((remotecodec == 3)?(len<<1):len, GFP_ATOMIC);
+	if (!nskb) {
+		printk(KERN_ERR "%s: No mem for skb.\n", __func__);
+		return;
+	}
+	p = skb_put(nskb, (remotecodec == 3)?(len<<1):len);
+
+	if (remotecodec == 1 && ulaw)
+		l1oip_alaw_to_ulaw(buf, len, p);
+	else if (remotecodec == 2 && !ulaw)
+		l1oip_ulaw_to_alaw(buf, len, p);
+	else if (remotecodec == 3)
+		len = l1oip_4bit_to_law(buf, len, p);
+	else
+		memcpy(p, buf, len);
+
+	/* send message up */
+	if (dch && len >= 2) {
+		dch->rx_skb = nskb;
+		recv_Dchannel(dch);
+	}
+	if (bch) {
+		/* expand 16 bit sequence number to 32 bit sequence number */
+		rx_counter = hc->chan[channel].rx_counter;
+		if (((s16)(timebase - rx_counter)) >= 0) {
+			/* time has changed forward */
+			if (timebase >= (rx_counter & 0xffff))
+				rx_counter =
+					(rx_counter & 0xffff0000) | timebase;
+			else
+				rx_counter = ((rx_counter & 0xffff0000)+0x10000)
+					| timebase;
+		} else {
+			/* time has changed backwards */
+			if (timebase < (rx_counter & 0xffff))
+				rx_counter =
+					(rx_counter & 0xffff0000) | timebase;
+			else
+				rx_counter = ((rx_counter & 0xffff0000)-0x10000)
+					| timebase;
+		}
+		hc->chan[channel].rx_counter = rx_counter;
+
+#ifdef REORDER_DEBUG
+		if (hc->chan[channel].disorder_flag) {
+			struct sk_buff *skb;
+			int cnt;
+			skb = hc->chan[channel].disorder_skb;
+			hc->chan[channel].disorder_skb = nskb;
+			nskb = skb;
+			cnt = hc->chan[channel].disorder_cnt;
+			hc->chan[channel].disorder_cnt = rx_counter;
+			rx_counter = cnt;
+		}
+		hc->chan[channel].disorder_flag ^= 1;
+		if (nskb)
+#endif
+		queue_ch_frame(&bch->ch, PH_DATA_IND, rx_counter, nskb);
+	}
+}
+
+
+/*
+ * parse frame and extract channel data
+ */
+static void
+l1oip_socket_parse(struct l1oip *hc, struct sockaddr_in *sin, u8 *buf, int len)
+{
+	u32			id;
+	u8			channel;
+	u8			remotecodec;
+	u16			timebase;
+	int			m, mlen;
+	int			len_start = len; /* initial frame length */
+	struct dchannel		*dch = hc->chan[hc->d_idx].dch;
+
+	if (debug & DEBUG_L1OIP_MSG)
+		printk(KERN_DEBUG "%s: received frame, parsing... (%d)\n",
+			__func__, len);
+
+	/* check lenght */
+	if (len < 1+1+2) {
+		printk(KERN_WARNING "%s: packet error - length %d below "
+			"4 bytes\n", __func__, len);
+		return;
+	}
+
+	/* check version */
+	if (((*buf)>>6) != L1OIP_VERSION) {
+		printk(KERN_WARNING "%s: packet error - unknown version %d\n",
+			__func__, buf[0]>>6);
+		return;
+	}
+
+	/* check type */
+	if (((*buf)&0x20) && !hc->pri) {
+		printk(KERN_WARNING "%s: packet error - received E1 packet "
+			"on S0 interface\n", __func__);
+		return;
+	}
+	if (!((*buf)&0x20) && hc->pri) {
+		printk(KERN_WARNING "%s: packet error - received S0 packet "
+			"on E1 interface\n", __func__);
+		return;
+	}
+
+	/* get id flag */
+	id = (*buf>>4)&1;
+
+	/* check coding */
+	remotecodec = (*buf) & 0x0f;
+	if (remotecodec > 3) {
+		printk(KERN_WARNING "%s: packet error - remotecodec %d "
+			"unsupported\n", __func__, remotecodec);
+		return;
+	}
+	buf++;
+	len--;
+
+	/* check id */
+	if (id) {
+		if (!hc->id) {
+			printk(KERN_WARNING "%s: packet error - packet has id "
+				"0x%x, but we have not\n", __func__, id);
+			return;
+		}
+		if (len < 4) {
+			printk(KERN_WARNING "%s: packet error - packet too "
+				"short for ID value\n", __func__);
+			return;
+		}
+		id = (*buf++) << 24;
+		id += (*buf++) << 16;
+		id += (*buf++) << 8;
+		id += (*buf++);
+		len -= 4;
+
+		if (id != hc->id) {
+			printk(KERN_WARNING "%s: packet error - ID mismatch, "
+				"got 0x%x, we 0x%x\n",
+				__func__, id, hc->id);
+			return;
+		}
+	} else {
+		if (hc->id) {
+			printk(KERN_WARNING "%s: packet error - packet has no "
+				"ID, but we have\n", __func__);
+			return;
+		}
+	}
+
+multiframe:
+	if (len < 1) {
+		printk(KERN_WARNING "%s: packet error - packet too short, "
+			"channel expected at position %d.\n",
+			__func__, len-len_start+1);
+		return;
+	}
+
+	/* get channel and multiframe flag */
+	channel = *buf&0x7f;
+	m = *buf >> 7;
+	buf++;
+	len--;
+
+	/* check length on multiframe */
+	if (m) {
+		if (len < 1) {
+			printk(KERN_WARNING "%s: packet error - packet too "
+				"short, length expected at position %d.\n",
+				__func__, len_start-len-1);
+			return;
+		}
+
+		mlen = *buf++;
+		len--;
+		if (mlen == 0)
+			mlen = 256;
+		if (len < mlen+3) {
+			printk(KERN_WARNING "%s: packet error - length %d at "
+				"position %d exceeds total length %d.\n",
+				__func__, mlen, len_start-len-1, len_start);
+			return;
+		}
+		if (len == mlen+3) {
+			printk(KERN_WARNING "%s: packet error - length %d at "
+				"position %d will not allow additional "
+				"packet.\n",
+				__func__, mlen, len_start-len+1);
+			return;
+		}
+	} else
+		mlen = len-2; /* single frame, substract timebase */
+
+	if (len < 2) {
+		printk(KERN_WARNING "%s: packet error - packet too short, time "
+			"base expected at position %d.\n",
+			__func__, len-len_start+1);
+		return;
+	}
+
+	/* get time base */
+	timebase = (*buf++) << 8;
+	timebase |= (*buf++);
+	len -= 2;
+
+	/* if inactive, we send up a PH_ACTIVATE and activate */
+	if (!test_bit(FLG_ACTIVE, &dch->Flags)) {
+		if (debug & (DEBUG_L1OIP_MSG|DEBUG_L1OIP_SOCKET))
+			printk(KERN_DEBUG "%s: interface become active due to "
+				"received packet\n", __func__);
+		test_and_set_bit(FLG_ACTIVE, &dch->Flags);
+		_queue_data(&dch->dev.D, PH_ACTIVATE_IND, MISDN_ID_ANY, 0,
+			NULL, GFP_ATOMIC);
+	}
+
+	/* distribute packet */
+	l1oip_socket_recv(hc, remotecodec, channel, timebase, buf, mlen);
+	buf += mlen;
+	len -= mlen;
+
+	/* multiframe */
+	if (m)
+		goto multiframe;
+
+	/* restart timer */
+	if ((int)(hc->timeout_tl.expires-jiffies) < 5*HZ || !hc->timeout_on) {
+		hc->timeout_on = 1;
+		del_timer(&hc->timeout_tl);
+		hc->timeout_tl.expires = jiffies + L1OIP_TIMEOUT*HZ;
+		add_timer(&hc->timeout_tl);
+	} else /* only adjust timer */
+		hc->timeout_tl.expires = jiffies + L1OIP_TIMEOUT*HZ;
+
+	/* if ip or source port changes */
+	if ((hc->sin_remote.sin_addr.s_addr != sin->sin_addr.s_addr)
+	 || (hc->sin_remote.sin_port != sin->sin_port)) {
+		if (debug & DEBUG_L1OIP_SOCKET)
+			printk(KERN_DEBUG "%s: remote address changes from "
+				"0x%08x to 0x%08x (port %d to %d)\n", __func__,
+				ntohl(hc->sin_remote.sin_addr.s_addr),
+				ntohl(sin->sin_addr.s_addr),
+				ntohs(hc->sin_remote.sin_port),
+				ntohs(sin->sin_port));
+		hc->sin_remote.sin_addr.s_addr = sin->sin_addr.s_addr;
+		hc->sin_remote.sin_port = sin->sin_port;
+	}
+}
+
+
+/*
+ * socket stuff
+ */
+static int
+l1oip_socket_thread(void *data)
+{
+	struct l1oip *hc = (struct l1oip *)data;
+	int ret = 0;
+	struct msghdr msg;
+	struct iovec iov;
+	mm_segment_t oldfs;
+	struct sockaddr_in sin_rx;
+	unsigned char recvbuf[1500];
+	int recvlen;
+	struct socket *socket = NULL;
+	DECLARE_COMPLETION(wait);
+
+	/* make daemon */
+	allow_signal(SIGTERM);
+
+	/* create socket */
+	if (sock_create(PF_INET, SOCK_DGRAM, IPPROTO_UDP, &socket)) {
+		printk(KERN_ERR "%s: Failed to create socket.\n", __func__);
+		return -EIO;
+	}
+
+	/* set incoming address */
+	hc->sin_local.sin_family = AF_INET;
+	hc->sin_local.sin_addr.s_addr = INADDR_ANY;
+	hc->sin_local.sin_port = htons((unsigned short)hc->localport);
+
+	/* set outgoing address */
+	hc->sin_remote.sin_family = AF_INET;
+	hc->sin_remote.sin_addr.s_addr = htonl(hc->remoteip);
+	hc->sin_remote.sin_port = htons((unsigned short)hc->remoteport);
+
+	/* bind to incomming port */
+	if (socket->ops->bind(socket, (struct sockaddr *)&hc->sin_local,
+	    sizeof(hc->sin_local))) {
+		printk(KERN_ERR "%s: Failed to bind socket to port %d.\n",
+			__func__, hc->localport);
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	/* check sk */
+	if (socket->sk == NULL) {
+		printk(KERN_ERR "%s: socket->sk == NULL\n", __func__);
+		ret = -EIO;
+		goto fail;
+	}
+
+	/* build receive message */
+	msg.msg_name = &sin_rx;
+	msg.msg_namelen = sizeof(sin_rx);
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	/* build send message */
+	hc->sendmsg.msg_name = &hc->sin_remote;
+	hc->sendmsg.msg_namelen = sizeof(hc->sin_remote);
+	hc->sendmsg.msg_control = NULL;
+	hc->sendmsg.msg_controllen = 0;
+	hc->sendmsg.msg_iov    = &hc->sendiov;
+	hc->sendmsg.msg_iovlen = 1;
+
+	/* give away socket */
+	spin_lock(&hc->socket_lock);
+	hc->socket = socket;
+	spin_unlock(&hc->socket_lock);
+
+	/* read loop */
+	if (debug & DEBUG_L1OIP_SOCKET)
+		printk(KERN_DEBUG "%s: socket created and open\n",
+			__func__);
+	while (!signal_pending(current)) {
+		iov.iov_base = recvbuf;
+		iov.iov_len = sizeof(recvbuf);
+		oldfs = get_fs();
+		set_fs(KERNEL_DS);
+		recvlen = sock_recvmsg(socket, &msg, sizeof(recvbuf), 0);
+		set_fs(oldfs);
+		if (recvlen > 0) {
+			l1oip_socket_parse(hc, &sin_rx, recvbuf, recvlen);
+		} else {
+			if (debug & DEBUG_L1OIP_SOCKET)
+			    printk(KERN_WARNING "%s: broken pipe on socket\n",
+				__func__);
+		}
+	}
+
+	/* get socket back, check first if in use, maybe by send function */
+	spin_lock(&hc->socket_lock);
+	/* if hc->socket is NULL, it is in use until it is given back */
+	while (!hc->socket) {
+		spin_unlock(&hc->socket_lock);
+		schedule_timeout(HZ/10);
+		spin_lock(&hc->socket_lock);
+	}
+	hc->socket = NULL;
+	spin_unlock(&hc->socket_lock);
+
+	if (debug & DEBUG_L1OIP_SOCKET)
+		printk(KERN_DEBUG "%s: socket thread terminating\n",
+			__func__);
+
+fail:
+	/* close socket */
+	if (socket)
+		sock_release(socket);
+
+	/* if we got killed, signal completion */
+	complete(&hc->socket_complete);
+	hc->socket_thread = NULL; /* show termination of thread */
+
+	if (debug & DEBUG_L1OIP_SOCKET)
+		printk(KERN_DEBUG "%s: socket thread terminated\n",
+			__func__);
+	return ret;
+}
+
+static void
+l1oip_socket_close(struct l1oip *hc)
+{
+	/* kill thread */
+	if (hc->socket_thread) {
+		if (debug & DEBUG_L1OIP_SOCKET)
+			printk(KERN_DEBUG "%s: socket thread exists, "
+				"killing...\n", __func__);
+		send_sig(SIGTERM, hc->socket_thread, 0);
+		wait_for_completion(&hc->socket_complete);
+	}
+}
+
+static int
+l1oip_socket_open(struct l1oip *hc)
+{
+	/* in case of reopen, we need to close first */
+	l1oip_socket_close(hc);
+
+	init_completion(&hc->socket_complete);
+
+	/* create receive process */
+	hc->socket_thread = kthread_run(l1oip_socket_thread, hc, "l1oip_%s",
+		hc->name);
+	if (IS_ERR(hc->socket_thread)) {
+		int err = PTR_ERR(hc->socket_thread);
+		printk(KERN_ERR "%s: Failed (%d) to create socket process.\n",
+			__func__, err);
+		hc->socket_thread = NULL;
+		sock_release(hc->socket);
+		return err;
+	}
+	if (debug & DEBUG_L1OIP_SOCKET)
+		printk(KERN_DEBUG "%s: socket thread created\n", __func__);
+
+	return 0;
+}
+
+
+static void
+l1oip_send_bh(struct work_struct *work)
+{
+	struct l1oip *hc = container_of(work, struct l1oip, workq);
+
+	if (debug & (DEBUG_L1OIP_MSG|DEBUG_L1OIP_SOCKET))
+		printk(KERN_DEBUG "%s: keepalive timer expired, sending empty "
+			"frame on dchannel\n", __func__);
+
+	/* send an empty l1oip frame at D-channel */
+	l1oip_socket_send(hc, 0, hc->d_idx, 0, 0, NULL, 0);
+}
+
+
+/*
+ * timer stuff
+ */
+static void
+l1oip_keepalive(void *data)
+{
+	struct l1oip *hc = (struct l1oip *)data;
+
+	schedule_work(&hc->workq);
+}
+
+static void
+l1oip_timeout(void *data)
+{
+	struct l1oip			*hc = (struct l1oip *)data;
+	struct dchannel		*dch = hc->chan[hc->d_idx].dch;
+
+	if (debug & DEBUG_L1OIP_MSG)
+		printk(KERN_DEBUG "%s: timeout timer expired, turn layer one "
+			"down.\n", __func__);
+
+	hc->timeout_on = 0; /* state that timer must be initialized next time */
+
+	/* if timeout, we send up a PH_DEACTIVATE and deactivate */
+	if (test_bit(FLG_ACTIVE, &dch->Flags)) {
+		if (debug & (DEBUG_L1OIP_MSG|DEBUG_L1OIP_SOCKET))
+			printk(KERN_DEBUG "%s: interface become deactivated "
+				"due to timeout\n", __func__);
+		test_and_clear_bit(FLG_ACTIVE, &dch->Flags);
+		_queue_data(&dch->dev.D, PH_DEACTIVATE_IND, MISDN_ID_ANY, 0,
+			NULL, GFP_ATOMIC);
+	}
+
+	/* if we have ondemand set, we remove ip address */
+	if (hc->ondemand) {
+		if (debug & DEBUG_L1OIP_MSG)
+			printk(KERN_DEBUG "%s: on demand causes ip address to "
+				"be removed\n", __func__);
+		hc->sin_remote.sin_addr.s_addr = 0;
+	}
+}
+
+
+/*
+ * message handling
+ */
+static int
+handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
+{
+	struct mISDNdevice	*dev = container_of(ch, struct mISDNdevice, D);
+	struct dchannel		*dch = container_of(dev, struct dchannel, dev);
+	struct l1oip			*hc = dch->hw;
+	struct mISDNhead	*hh = mISDN_HEAD_P(skb);
+	int			ret = -EINVAL;
+	int			l, ll;
+	unsigned char		*p;
+
+	switch (hh->prim) {
+	case PH_DATA_REQ:
+		if (skb->len < 1) {
+			printk(KERN_WARNING "%s: skb too small\n",
+				__func__);
+			break;
+		}
+		if (skb->len > MAX_DFRAME_LEN_L1 || skb->len > L1OIP_MAX_LEN) {
+			printk(KERN_WARNING "%s: skb too large\n",
+				__func__);
+			break;
+		}
+		/* send frame */
+		p = skb->data;
+		l = skb->len;
+		while (l) {
+			ll = (l < L1OIP_MAX_PERFRAME)?l:L1OIP_MAX_PERFRAME;
+			l1oip_socket_send(hc, 0, dch->slot, 0,
+				hc->chan[dch->slot].tx_counter++, p, ll);
+			p += ll;
+			l -= ll;
+		}
+		skb_trim(skb, 0);
+		queue_ch_frame(ch, PH_DATA_CNF, hh->id, skb);
+		return 0;
+	case PH_ACTIVATE_REQ:
+		if (debug & (DEBUG_L1OIP_MSG|DEBUG_L1OIP_SOCKET))
+			printk(KERN_DEBUG "%s: PH_ACTIVATE channel %d (1..%d)\n"
+				, __func__, dch->slot, hc->b_num+1);
+		skb_trim(skb, 0);
+		if (test_bit(FLG_ACTIVE, &dch->Flags))
+			queue_ch_frame(ch, PH_ACTIVATE_IND, hh->id, skb);
+		else
+			queue_ch_frame(ch, PH_DEACTIVATE_IND, hh->id, skb);
+		return 0;
+	case PH_DEACTIVATE_REQ:
+		if (debug & (DEBUG_L1OIP_MSG|DEBUG_L1OIP_SOCKET))
+			printk(KERN_DEBUG "%s: PH_DEACTIVATE channel %d "
+				"(1..%d)\n", __func__, dch->slot,
+				hc->b_num+1);
+		skb_trim(skb, 0);
+		if (test_bit(FLG_ACTIVE, &dch->Flags))
+			queue_ch_frame(ch, PH_ACTIVATE_IND, hh->id, skb);
+		else
+			queue_ch_frame(ch, PH_DEACTIVATE_IND, hh->id, skb);
+		return 0;
+	}
+	if (!ret)
+		dev_kfree_skb(skb);
+	return ret;
+}
+
+static int
+channel_dctrl(struct dchannel *dch, struct mISDN_ctrl_req *cq)
+{
+	int	ret = 0;
+	struct l1oip	*hc = dch->hw;
+
+	switch (cq->op) {
+	case MISDN_CTRL_GETOP:
+		cq->op = MISDN_CTRL_SETPEER | MISDN_CTRL_UNSETPEER;
+		break;
+	case MISDN_CTRL_SETPEER:
+		hc->remoteip = (u32)cq->p1;
+		hc->remoteport = cq->p2 & 0xffff;
+		hc->localport = cq->p2 >> 16;
+		if (!hc->remoteport)
+			hc->remoteport = hc->localport;
+		if (debug & DEBUG_L1OIP_SOCKET)
+			printk(KERN_DEBUG "%s: got new ip address from user "
+				"space.\n", __func__);
+			l1oip_socket_open(hc);
+		break;
+	case MISDN_CTRL_UNSETPEER:
+		if (debug & DEBUG_L1OIP_SOCKET)
+			printk(KERN_DEBUG "%s: removing ip address.\n",
+				__func__);
+		hc->remoteip = 0;
+		l1oip_socket_open(hc);
+		break;
+	default:
+		printk(KERN_WARNING "%s: unknown Op %x\n",
+		    __func__, cq->op);
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int
+open_dchannel(struct l1oip *hc, struct dchannel *dch, struct channel_req *rq)
+{
+	if (debug & DEBUG_HW_OPEN)
+		printk(KERN_DEBUG "%s: dev(%d) open from %p\n", __func__,
+		    dch->dev.id, __builtin_return_address(0));
+	if (rq->protocol == ISDN_P_NONE)
+		return -EINVAL;
+	if ((dch->dev.D.protocol != ISDN_P_NONE) &&
+	    (dch->dev.D.protocol != rq->protocol)) {
+		if (debug & DEBUG_HW_OPEN)
+			printk(KERN_WARNING "%s: change protocol %x to %x\n",
+			__func__, dch->dev.D.protocol, rq->protocol);
+	}
+	if (dch->dev.D.protocol != rq->protocol)
+		dch->dev.D.protocol = rq->protocol;
+
+	if (test_bit(FLG_ACTIVE, &dch->Flags)) {
+		_queue_data(&dch->dev.D, PH_ACTIVATE_IND, MISDN_ID_ANY,
+		    0, NULL, GFP_KERNEL);
+	}
+	rq->ch = &dch->dev.D;
+	if (!try_module_get(THIS_MODULE))
+		printk(KERN_WARNING "%s:cannot get module\n", __func__);
+	return 0;
+}
+
+static int
+open_bchannel(struct l1oip *hc, struct dchannel *dch, struct channel_req *rq)
+{
+	struct bchannel	*bch;
+	int		ch;
+
+	if (!test_bit(rq->adr.channel & 0x1f,
+		&dch->dev.channelmap[rq->adr.channel >> 5]))
+		return -EINVAL;
+	if (rq->protocol == ISDN_P_NONE)
+		return -EINVAL;
+	ch = rq->adr.channel; /* BRI: 1=B1 2=B2  PRI: 1..15,17.. */
+	bch = hc->chan[ch].bch;
+	if (!bch) {
+		printk(KERN_ERR "%s:internal error ch %d has no bch\n",
+		    __func__, ch);
+		return -EINVAL;
+	}
+	if (test_and_set_bit(FLG_OPEN, &bch->Flags))
+		return -EBUSY; /* b-channel can be only open once */
+	bch->ch.protocol = rq->protocol;
+	rq->ch = &bch->ch;
+	if (!try_module_get(THIS_MODULE))
+		printk(KERN_WARNING "%s:cannot get module\n", __func__);
+	return 0;
+}
+
+static int
+l1oip_dctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
+{
+	struct mISDNdevice	*dev = container_of(ch, struct mISDNdevice, D);
+	struct dchannel		*dch = container_of(dev, struct dchannel, dev);
+	struct l1oip			*hc = dch->hw;
+	struct channel_req	*rq;
+	int			err = 0;
+
+	if (dch->debug & DEBUG_HW)
+		printk(KERN_DEBUG "%s: cmd:%x %p\n",
+		    __func__, cmd, arg);
+	switch (cmd) {
+	case OPEN_CHANNEL:
+		rq = arg;
+		switch (rq->protocol) {
+		case ISDN_P_TE_S0:
+		case ISDN_P_NT_S0:
+			if (hc->pri) {
+				err = -EINVAL;
+				break;
+			}
+			err = open_dchannel(hc, dch, rq);
+			break;
+		case ISDN_P_TE_E1:
+		case ISDN_P_NT_E1:
+			if (!hc->pri) {
+				err = -EINVAL;
+				break;
+			}
+			err = open_dchannel(hc, dch, rq);
+			break;
+		default:
+			err = open_bchannel(hc, dch, rq);
+		}
+		break;
+	case CLOSE_CHANNEL:
+		if (debug & DEBUG_HW_OPEN)
+			printk(KERN_DEBUG "%s: dev(%d) close from %p\n",
+			    __func__, dch->dev.id,
+			    __builtin_return_address(0));
+		module_put(THIS_MODULE);
+		break;
+	case CONTROL_CHANNEL:
+		err = channel_dctrl(dch, arg);
+		break;
+	default:
+		if (dch->debug & DEBUG_HW)
+			printk(KERN_DEBUG "%s: unknown command %x\n",
+			    __func__, cmd);
+		err = -EINVAL;
+	}
+	return err;
+}
+
+static int
+handle_bmsg(struct mISDNchannel *ch, struct sk_buff *skb)
+{
+	struct bchannel		*bch = container_of(ch, struct bchannel, ch);
+	struct l1oip			*hc = bch->hw;
+	int			ret = -EINVAL;
+	struct mISDNhead	*hh = mISDN_HEAD_P(skb);
+	int			l, ll, i;
+	unsigned char		*p;
+
+	switch (hh->prim) {
+	case PH_DATA_REQ:
+		if (skb->len <= 0) {
+			printk(KERN_WARNING "%s: skb too small\n",
+				__func__);
+			break;
+		}
+		if (skb->len > MAX_DFRAME_LEN_L1 || skb->len > L1OIP_MAX_LEN) {
+			printk(KERN_WARNING "%s: skb too large\n",
+				__func__);
+			break;
+		}
+		/* check for AIS / ulaw-silence */
+		p = skb->data;
+		l = skb->len;
+		for (i = 0; i < l; i++) {
+			if (*p++ != 0xff)
+				break;
+		}
+		if (i == l) {
+			if (debug & DEBUG_L1OIP_MSG)
+				printk(KERN_DEBUG "%s: got AIS, not sending, "
+					"but counting\n", __func__);
+			hc->chan[bch->slot].tx_counter += l;
+			skb_trim(skb, 0);
+			queue_ch_frame(ch, PH_DATA_CNF, hh->id, skb);
+			return 0;
+		}
+		/* check for silence */
+		p = skb->data;
+		l = skb->len;
+		for (i = 0; i < l; i++) {
+			if (*p++ != 0x2a)
+				break;
+		}
+		if (i == l) {
+			if (debug & DEBUG_L1OIP_MSG)
+				printk(KERN_DEBUG "%s: got silence, not sending"
+					", but counting\n", __func__);
+			hc->chan[bch->slot].tx_counter += l;
+			skb_trim(skb, 0);
+			queue_ch_frame(ch, PH_DATA_CNF, hh->id, skb);
+			return 0;
+		}
+
+		/* send frame */
+		p = skb->data;
+		l = skb->len;
+		while (l) {
+			ll = (l < L1OIP_MAX_PERFRAME)?l:L1OIP_MAX_PERFRAME;
+			l1oip_socket_send(hc, hc->codec, bch->slot, 0,
+				hc->chan[bch->slot].tx_counter, p, ll);
+			hc->chan[bch->slot].tx_counter += ll;
+			p += ll;
+			l -= ll;
+		}
+		skb_trim(skb, 0);
+		queue_ch_frame(ch, PH_DATA_CNF, hh->id, skb);
+		return 0;
+	case PH_ACTIVATE_REQ:
+		if (debug & (DEBUG_L1OIP_MSG|DEBUG_L1OIP_SOCKET))
+			printk(KERN_DEBUG "%s: PH_ACTIVATE channel %d (1..%d)\n"
+				, __func__, bch->slot, hc->b_num+1);
+		hc->chan[bch->slot].codecstate = 0;
+		test_and_set_bit(FLG_ACTIVE, &bch->Flags);
+		skb_trim(skb, 0);
+		queue_ch_frame(ch, PH_ACTIVATE_IND, hh->id, skb);
+		return 0;
+	case PH_DEACTIVATE_REQ:
+		if (debug & (DEBUG_L1OIP_MSG|DEBUG_L1OIP_SOCKET))
+			printk(KERN_DEBUG "%s: PH_DEACTIVATE channel %d "
+				"(1..%d)\n", __func__, bch->slot,
+				hc->b_num+1);
+		test_and_clear_bit(FLG_ACTIVE, &bch->Flags);
+		skb_trim(skb, 0);
+		queue_ch_frame(ch, PH_DEACTIVATE_IND, hh->id, skb);
+		return 0;
+	}
+	if (!ret)
+		dev_kfree_skb(skb);
+	return ret;
+}
+
+static int
+channel_bctrl(struct bchannel *bch, struct mISDN_ctrl_req *cq)
+{
+	int			ret = 0;
+	struct dsp_features	*features =
+		(struct dsp_features *)(*((u_long *)&cq->p1));
+
+	switch (cq->op) {
+	case MISDN_CTRL_GETOP:
+		cq->op = MISDN_CTRL_HW_FEATURES_OP;
+		break;
+	case MISDN_CTRL_HW_FEATURES: /* fill features structure */
+		if (debug & DEBUG_L1OIP_MSG)
+			printk(KERN_DEBUG "%s: HW_FEATURE request\n",
+			    __func__);
+		/* create confirm */
+		features->unclocked = 1;
+		features->unordered = 1;
+		break;
+	default:
+		printk(KERN_WARNING "%s: unknown Op %x\n",
+		    __func__, cq->op);
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int
+l1oip_bctrl(struct mISDNchannel *ch, u_int cmd, void *arg)
+{
+	struct bchannel	*bch = container_of(ch, struct bchannel, ch);
+	int		err = -EINVAL;
+
+	if (bch->debug & DEBUG_HW)
+		printk(KERN_DEBUG "%s: cmd:%x %p\n",
+		    __func__, cmd, arg);
+	switch (cmd) {
+	case CLOSE_CHANNEL:
+		test_and_clear_bit(FLG_OPEN, &bch->Flags);
+		test_and_clear_bit(FLG_ACTIVE, &bch->Flags);
+		ch->protocol = ISDN_P_NONE;
+		ch->peer = NULL;
+		module_put(THIS_MODULE);
+		err = 0;
+		break;
+	case CONTROL_CHANNEL:
+		err = channel_bctrl(bch, arg);
+		break;
+	default:
+		printk(KERN_WARNING "%s: unknown prim(%x)\n",
+			__func__, cmd);
+	}
+	return err;
+}
+
+
+/*
+ * cleanup module and stack
+ */
+static void
+release_card(struct l1oip *hc)
+{
+	int	ch;
+
+	if (timer_pending(&hc->keep_tl))
+		del_timer(&hc->keep_tl);
+
+	if (timer_pending(&hc->timeout_tl))
+		del_timer(&hc->timeout_tl);
+
+	if (hc->socket_thread)
+		l1oip_socket_close(hc);
+
+	if (hc->registered && hc->chan[hc->d_idx].dch)
+		mISDN_unregister_device(&hc->chan[hc->d_idx].dch->dev);
+	for (ch = 0; ch < 128; ch++) {
+		if (hc->chan[ch].dch) {
+			mISDN_freedchannel(hc->chan[ch].dch);
+			kfree(hc->chan[ch].dch);
+		}
+		if (hc->chan[ch].bch) {
+			mISDN_freebchannel(hc->chan[ch].bch);
+			kfree(hc->chan[ch].bch);
+#ifdef REORDER_DEBUG
+			if (hc->chan[ch].disorder_skb)
+				dev_kfree_skb(hc->chan[ch].disorder_skb);
+#endif
+		}
+	}
+
+	spin_lock(&l1oip_lock);
+	list_del(&hc->list);
+	spin_unlock(&l1oip_lock);
+
+	kfree(hc);
+}
+
+static void
+l1oip_cleanup(void)
+{
+	struct l1oip *hc, *next;
+
+	list_for_each_entry_safe(hc, next, &l1oip_ilist, list)
+		release_card(hc);
+
+	l1oip_4bit_free();
+}
+
+
+/*
+ * module and stack init
+ */
+static int
+init_card(struct l1oip *hc, int pri, int bundle)
+{
+	struct dchannel	*dch;
+	struct bchannel	*bch;
+	int		ret;
+	int		i, ch;
+
+	spin_lock_init(&hc->socket_lock);
+	hc->idx = l1oip_cnt;
+	hc->pri = pri;
+	hc->d_idx = pri?16:3;
+	hc->b_num = pri?30:2;
+	hc->bundle = bundle;
+	if (hc->pri)
+		sprintf(hc->name, "l1oip-e1.%d", l1oip_cnt + 1);
+	else
+		sprintf(hc->name, "l1oip-s0.%d", l1oip_cnt + 1);
+
+	switch (codec[l1oip_cnt]) {
+	case 0: /* as is */
+	case 1: /* alaw */
+	case 2: /* ulaw */
+	case 3: /* 4bit */
+		break;
+	default:
+		printk(KERN_ERR "Codec(%d) not supported.\n",
+			codec[l1oip_cnt]);
+		return -EINVAL;
+	}
+	hc->codec = codec[l1oip_cnt];
+	if (debug & DEBUG_L1OIP_INIT)
+		printk(KERN_DEBUG "%s: using codec %d\n",
+			__func__, hc->codec);
+
+	if (id[l1oip_cnt] == 0) {
+		printk(KERN_WARNING "Warning: No 'id' value given or "
+			"0, this is highly unsecure. Please use 32 "
+			"bit randmom number 0x...\n");
+	}
+	hc->id = id[l1oip_cnt];
+	if (debug & DEBUG_L1OIP_INIT)
+		printk(KERN_DEBUG "%s: using id 0x%x\n", __func__, hc->id);
+
+	hc->ondemand = ondemand[l1oip_cnt];
+	if (hc->ondemand && !hc->id) {
+		printk(KERN_ERR "%s: ondemand option only allowed in "
+			"conjunction with non 0 ID\n", __func__);
+		return -EINVAL;
+	}
+
+	if (limit[l1oip_cnt])
+		hc->b_num = limit[l1oip_cnt];
+	if (!pri && hc->b_num > 2) {
+		printk(KERN_ERR "Maximum limit for BRI interface is 2 "
+			"channels.\n");
+		return -EINVAL;
+	}
+	if (pri && hc->b_num > 126) {
+		printk(KERN_ERR "Maximum limit for PRI interface is 126 "
+			"channels.\n");
+		return -EINVAL;
+	}
+	if (pri && hc->b_num > 30) {
+		printk(KERN_WARNING "Maximum limit for BRI interface is 30 "
+			"channels.\n");
+		printk(KERN_WARNING "Your selection of %d channels must be "
+			"supported by application.\n", hc->limit);
+	}
+
+	hc->remoteip = ip[l1oip_cnt<<2] << 24
+		     | ip[(l1oip_cnt<<2)+1] << 16
+		     | ip[(l1oip_cnt<<2)+2] << 8
+		     | ip[(l1oip_cnt<<2)+3];
+	hc->localport = port[l1oip_cnt]?:(L1OIP_DEFAULTPORT+l1oip_cnt);
+	if (remoteport[l1oip_cnt])
+		hc->remoteport = remoteport[l1oip_cnt];
+	else
+		hc->remoteport = hc->localport;
+	if (debug & DEBUG_L1OIP_INIT)
+		printk(KERN_DEBUG "%s: using local port %d remote ip "
+			"%d.%d.%d.%d port %d ondemand %d\n", __func__,
+			hc->localport, hc->remoteip >> 24,
+			(hc->remoteip >> 16) & 0xff,
+			(hc->remoteip >> 8) & 0xff, hc->remoteip & 0xff,
+			hc->remoteport, hc->ondemand);
+
+	dch = kzalloc(sizeof(struct dchannel), GFP_KERNEL);
+	if (!dch)
+		return -ENOMEM;
+	dch->debug = debug;
+	mISDN_initdchannel(dch, MAX_DFRAME_LEN_L1, NULL);
+	dch->hw = hc;
+	if (pri)
+		dch->dev.Dprotocols = (1 << ISDN_P_TE_E1) | (1 << ISDN_P_NT_E1);
+	else
+		dch->dev.Dprotocols = (1 << ISDN_P_TE_S0) | (1 << ISDN_P_NT_S0);
+	dch->dev.Bprotocols = (1 << (ISDN_P_B_RAW & ISDN_P_B_MASK)) |
+	    (1 << (ISDN_P_B_HDLC & ISDN_P_B_MASK));
+	dch->dev.D.send = handle_dmsg;
+	dch->dev.D.ctrl = l1oip_dctrl;
+	dch->dev.nrbchan = hc->b_num;
+	dch->slot = hc->d_idx;
+	hc->chan[hc->d_idx].dch = dch;
+	i = 1;
+	for (ch = 0; ch < dch->dev.nrbchan; ch++) {
+		if (ch == 15)
+			i++;
+		bch = kzalloc(sizeof(struct bchannel), GFP_KERNEL);
+		if (!bch) {
+			printk(KERN_ERR "%s: no memory for bchannel\n",
+			    __func__);
+			return -ENOMEM;
+		}
+		bch->nr = i + ch;
+		bch->slot = i + ch;
+		bch->debug = debug;
+		mISDN_initbchannel(bch, MAX_DATA_MEM);
+		bch->hw = hc;
+		bch->ch.send = handle_bmsg;
+		bch->ch.ctrl = l1oip_bctrl;
+		bch->ch.nr = i + ch;
+		list_add(&bch->ch.list, &dch->dev.bchannels);
+		hc->chan[i + ch].bch = bch;
+		test_and_set_bit(bch->nr & 0x1f,
+			&dch->dev.channelmap[bch->nr >> 5]);
+	}
+	ret = mISDN_register_device(&dch->dev, hc->name);
+	if (ret)
+		return ret;
+	hc->registered = 1;
+
+	if (debug & DEBUG_L1OIP_INIT)
+		printk(KERN_DEBUG "%s: Setting up network card(%d)\n",
+			__func__, l1oip_cnt + 1);
+	ret = l1oip_socket_open(hc);
+	if (ret)
+		return ret;
+
+	hc->keep_tl.function = (void *)l1oip_keepalive;
+	hc->keep_tl.data = (ulong)hc;
+	init_timer(&hc->keep_tl);
+	hc->keep_tl.expires = jiffies + 2*HZ; /* two seconds first time */
+	add_timer(&hc->keep_tl);
+
+	hc->timeout_tl.function = (void *)l1oip_timeout;
+	hc->timeout_tl.data = (ulong)hc;
+	init_timer(&hc->timeout_tl);
+	hc->timeout_on = 0; /* state that we have timer off */
+
+	return 0;
+}
+
+static int __init
+l1oip_init(void)
+{
+	int		pri, bundle;
+	struct l1oip		*hc;
+	int		ret;
+
+	printk(KERN_INFO "mISDN: Layer-1-over-IP driver Rev. %s\n",
+		l1oip_revision);
+
+	INIT_LIST_HEAD(&l1oip_ilist);
+	spin_lock_init(&l1oip_lock);
+
+	if (l1oip_4bit_alloc(ulaw))
+		return -ENOMEM;
+
+	l1oip_cnt = 0;
+	while (type[l1oip_cnt] && l1oip_cnt < MAX_CARDS) {
+		switch (type[l1oip_cnt] & 0xff) {
+		case 1:
+			pri = 0;
+			bundle = 0;
+			break;
+		case 2:
+			pri = 1;
+			bundle = 0;
+			break;
+		case 3:
+			pri = 0;
+			bundle = 1;
+			break;
+		case 4:
+			pri = 1;
+			bundle = 1;
+			break;
+		default:
+			printk(KERN_ERR "Card type(%d) not supported.\n",
+				type[l1oip_cnt] & 0xff);
+			l1oip_cleanup();
+			return -EINVAL;
+		}
+
+		if (debug & DEBUG_L1OIP_INIT)
+			printk(KERN_DEBUG "%s: interface %d is %s with %s.\n",
+				__func__, l1oip_cnt, pri?"PRI":"BRI",
+				bundle?"bundled IP packet for all B-channels"
+				 :"seperate IP packets for every B-channel");
+
+		hc = kzalloc(sizeof(struct l1oip), GFP_ATOMIC);
+		if (!hc) {
+			printk(KERN_ERR "No kmem for L1-over-IP driver.\n");
+			l1oip_cleanup();
+			return -ENOMEM;
+		}
+		INIT_WORK(&hc->workq, (void *)l1oip_send_bh);
+
+		spin_lock(&l1oip_lock);
+		list_add_tail(&hc->list, &l1oip_ilist);
+		spin_unlock(&l1oip_lock);
+
+		ret = init_card(hc, pri, bundle);
+		if (ret) {
+			l1oip_cleanup();
+			return ret;
+		}
+
+		l1oip_cnt++;
+	}
+	printk(KERN_INFO "%d virtual devices registered\n", l1oip_cnt);
+	return 0;
+}
+
+module_init(l1oip_init);
+module_exit(l1oip_cleanup);
+
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
