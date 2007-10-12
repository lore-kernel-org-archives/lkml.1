Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbXJLMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbXJLMd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXJLMdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:33:41 -0400
Received: from verein.lst.de ([213.95.11.210]:51433 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760523AbXJLMdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:33:21 -0400
Date: Fri, 12 Oct 2007 14:33:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] iwl3945 & iwl4965: keep headers separate
Message-ID: <20071012123306.GB20794@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The iwl3945 and iwl4965 devices share some common structure, but with a
lot of difference split all over.  Currently the two drivers share a lot
of headers and use ugly preprocessor magic to manage the difference.

This patch keeps two entirely separate copies of the headers to get rid
of these hacks an ease future development.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2007-10-12 11:15:05.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2007-10-12 11:47:30.000000000 +0200
@@ -39,12 +39,9 @@
 
 #include <net/mac80211.h>
 #include <linux/wireless.h>
-
-#define IWL 3945
-
 #include "../net/mac80211/ieee80211_rate.h"
 
-#include "iwlwifi.h"
+#include "iwl-3945.h"
 
 #define RS_NAME "iwl-3945-rs"
 
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-10-12 11:14:49.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.c	2007-10-12 12:06:37.000000000 +0200
@@ -40,11 +40,8 @@
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 
-#define IWL 3945
-
-#include "iwlwifi.h"
-#include "iwl-helpers.h"
 #include "iwl-3945.h"
+#include "iwl-helpers.h"
 #include "iwl-3945-rs.h"
 
 #define IWL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-10-12 11:10:35.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-10-12 12:06:56.000000000 +0200
@@ -27,6 +27,716 @@
 #ifndef __iwl_3945_h__
 #define __iwl_3945_h__
 
+#include <linux/pci.h> /* for struct pci_device_id */
+#include <linux/kernel.h>
+#include <net/ieee80211_radiotap.h>
+
+struct iwl_priv;
+
+/* Hardware specific file defines the PCI IDs table for that hardware module */
+extern struct pci_device_id iwl_hw_card_ids[];
+
+#define DRV_NAME	"iwl3945"
+#include "iwl-3945-hw.h"
+#include "iwl-prph.h"
+
+/*
+ * Driver implementation data structures, constants, inline
+ * functions
+ *
+ * NOTE:  DO NOT PUT HARDWARE/UCODE SPECIFIC DECLRATIONS HERE
+ *
+ * Hardware specific declrations go into iwl-*hw.h
+ *
+ */
+
+#include "iwl-3945-debug.h"
+
+/* Default noise level to report when noise measurement is not available.
+ *   This may be because we're:
+ *   1)  Not associated (4965, no beacon statistics being sent to driver)
+ *   2)  Scanning (noise measurement does not apply to associated channel)
+ *   3)  Receiving CCK (3945 delivers noise info only for OFDM frames)
+ * Use default noise value of -127 ... this is below the range of measurable
+ *   Rx dBm for either 3945 or 4965, so it can indicate "unmeasurable" to user.
+ *   Also, -127 works better than 0 when averaging frames with/without
+ *   noise info (e.g. averaging might be done in app); measured dBm values are
+ *   always negative ... using a negative value as the default keeps all
+ *   averages within an s8's (used in some apps) range of negative values. */
+#define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
+
+/* Module parameters accessible from iwl-*.c */
+extern int iwl_param_disable_hw_scan;
+extern int iwl_param_debug;
+extern int iwl_param_mode;
+extern int iwl_param_disable;
+extern int iwl_param_antenna;
+extern int iwl_param_hwcrypto;
+extern int iwl_param_queues_num;
+
+enum iwl_antenna {
+	IWL_ANTENNA_DIVERSITY,
+	IWL_ANTENNA_MAIN,
+	IWL_ANTENNA_AUX
+};
+
+/*
+ * RTS threshold here is total size [2347] minus 4 FCS bytes
+ * Per spec:
+ *   a value of 0 means RTS on all data/management packets
+ *   a value > max MSDU size means no RTS
+ * else RTS for data/management frames where MPDU is larger
+ *   than RTS value.
+ */
+#define DEFAULT_RTS_THRESHOLD     2347U
+#define MIN_RTS_THRESHOLD         0U
+#define MAX_RTS_THRESHOLD         2347U
+#define MAX_MSDU_SIZE		  2304U
+#define MAX_MPDU_SIZE		  2346U
+#define DEFAULT_BEACON_INTERVAL   100U
+#define	DEFAULT_SHORT_RETRY_LIMIT 7U
+#define	DEFAULT_LONG_RETRY_LIMIT  4U
+
+struct iwl_rx_mem_buffer {
+	dma_addr_t dma_addr;
+	struct sk_buff *skb;
+	struct list_head list;
+};
+
+struct iwl_rt_rx_hdr {
+	struct ieee80211_radiotap_header rt_hdr;
+	__le64 rt_tsf;		/* TSF */
+	u8 rt_flags;		/* radiotap packet flags */
+	u8 rt_rate;		/* rate in 500kb/s */
+	__le16 rt_channelMHz;	/* channel in MHz */
+	__le16 rt_chbitmask;	/* channel bitfield */
+	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
+	s8 rt_dbmnoise;
+	u8 rt_antenna;		/* antenna number */
+	u8 payload[0];		/* payload... */
+} __attribute__ ((packed));
+
+struct iwl_rt_tx_hdr {
+	struct ieee80211_radiotap_header rt_hdr;
+	u8 rt_rate;		/* rate in 500kb/s */
+	__le16 rt_channel;	/* channel in mHz */
+	__le16 rt_chbitmask;	/* channel bitfield */
+	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
+	u8 rt_antenna;		/* antenna number */
+	u8 payload[0];		/* payload... */
+} __attribute__ ((packed));
+
+/*
+ * Generic queue structure
+ *
+ * Contains common data for Rx and Tx queues
+ */
+struct iwl_queue {
+	int n_bd;              /* number of BDs in this queue */
+	int first_empty;       /* 1-st empty entry (index) host_w*/
+	int last_used;         /* last used entry (index) host_r*/
+	dma_addr_t dma_addr;   /* physical addr for BD's */
+	int n_window;	       /* safe queue window */
+	u32 id;
+	int low_mark;	       /* low watermark, resume queue if free
+				* space more than this */
+	int high_mark;         /* high watermark, stop queue if free
+				* space less than this */
+} __attribute__ ((packed));
+
+#define MAX_NUM_OF_TBS          (20)
+
+struct iwl_tx_info {
+	struct ieee80211_tx_status status;
+	struct sk_buff *skb[MAX_NUM_OF_TBS];
+};
+
+/**
+ * struct iwl_tx_queue - Tx Queue for DMA
+ * @need_update: need to update read/write index
+ * @shed_retry: queue is HT AGG enabled
+ *
+ * Queue consists of circular buffer of BD's and required locking structures.
+ */
+struct iwl_tx_queue {
+	struct iwl_queue q;
+	struct iwl_tfd_frame *bd;
+	struct iwl_cmd *cmd;
+	dma_addr_t dma_addr_cmd;
+	struct iwl_tx_info *txb;
+	int need_update;
+	int sched_retry;
+	int active;
+};
+
+#define IWL_NUM_SCAN_RATES         (2)
+
+struct iwl_channel_tgd_info {
+	u8 type;
+	s8 max_power;
+};
+
+struct iwl_channel_tgh_info {
+	s64 last_radar_time;
+};
+
+/* current Tx power values to use, one for each rate for each channel.
+ * requested power is limited by:
+ * -- regulatory EEPROM limits for this channel
+ * -- hardware capabilities (clip-powers)
+ * -- spectrum management
+ * -- user preference (e.g. iwconfig)
+ * when requested power is set, base power index must also be set. */
+struct iwl_channel_power_info {
+	struct iwl_tx_power tpc;	/* actual radio and DSP gain settings */
+	s8 power_table_index;	/* actual (compenst'd) index into gain table */
+	s8 base_power_index;	/* gain index for power at factory temp. */
+	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
+};
+
+/* current scan Tx power values to use, one for each scan rate for each
+ * channel. */
+struct iwl_scan_power_info {
+	struct iwl_tx_power tpc;	/* actual radio and DSP gain settings */
+	s8 power_table_index;	/* actual (compenst'd) index into gain table */
+	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
+};
+
+/* Channel unlock period is 15 seconds. If no beacon or probe response
+ * has been received within 15 seconds on a locked channel then the channel
+ * remains locked. */
+#define TX_UNLOCK_PERIOD 15
+
+/* CSA lock period is 15 seconds.  If a CSA has been received on a channel in
+ * the last 15 seconds, the channel is locked */
+#define CSA_LOCK_PERIOD 15
+/*
+ * One for each channel, holds all channel setup data
+ * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
+ *     with one another!
+ */
+#define IWL4965_MAX_RATE (33)
+
+struct iwl_channel_info {
+	struct iwl_channel_tgd_info tgd;
+	struct iwl_channel_tgh_info tgh;
+	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
+	struct iwl_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
+						 * FAT channel */
+
+	u8 channel;	  /* channel number */
+	u8 flags;	  /* flags copied from EEPROM */
+	s8 max_power_avg; /* (dBm) regul. eeprom, normal Tx, any rate */
+	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) */
+	s8 min_power;	  /* always 0 */
+	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
+
+	u8 group_index;	  /* 0-4, maps channel to group1/2/3/4/5 */
+	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
+	u8 phymode;	  /* MODE_IEEE80211{A,B,G} */
+
+	/* Radio/DSP gain settings for each "normal" data Tx rate.
+	 * These include, in addition to RF and DSP gain, a few fields for
+	 *   remembering/modifying gain settings (indexes). */
+	struct iwl_channel_power_info power_info[IWL4965_MAX_RATE];
+
+	/* Radio/DSP gain settings for each scan rate, for directed scans. */
+	struct iwl_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
+};
+
+struct iwl_clip_group {
+	/* maximum power level to prevent clipping for each rate, derived by
+	 *   us from this band's saturation power in EEPROM */
+	const s8 clip_powers[IWL_MAX_RATES];
+};
+
+static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
+{
+	if (ch_info == NULL)
+		return 0;
+	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
+}
+
+static inline int is_channel_narrow(const struct iwl_channel_info *ch_info)
+{
+	return (ch_info->flags & EEPROM_CHANNEL_NARROW) ? 1 : 0;
+}
+
+static inline int is_channel_radar(const struct iwl_channel_info *ch_info)
+{
+	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
+}
+
+static inline u8 is_channel_a_band(const struct iwl_channel_info *ch_info)
+{
+	return ch_info->phymode == MODE_IEEE80211A;
+}
+
+static inline u8 is_channel_bg_band(const struct iwl_channel_info *ch_info)
+{
+	return ((ch_info->phymode == MODE_IEEE80211B) ||
+		(ch_info->phymode == MODE_IEEE80211G));
+}
+
+static inline int is_channel_passive(const struct iwl_channel_info *ch)
+{
+	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
+}
+
+static inline int is_channel_ibss(const struct iwl_channel_info *ch)
+{
+	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
+}
+
+extern const struct iwl_channel_info *iwl_get_channel_info(
+	const struct iwl_priv *priv, int phymode, u16 channel);
+
+#include "iwl-3945-rs.h"
+
+#define IWL_TX_FIFO_AC0	0
+#define IWL_TX_FIFO_AC1	1
+#define IWL_TX_FIFO_AC2	2
+#define IWL_TX_FIFO_AC3	3
+#define IWL_TX_FIFO_HCCA_1	5
+#define IWL_TX_FIFO_HCCA_2	6
+#define IWL_TX_FIFO_NONE	7
+
+/* Minimum number of queues. MAX_NUM is defined in hw specific files */
+#define IWL_MIN_NUM_QUEUES	4
+
+/* Power management (not Tx power) structures */
+
+struct iwl_power_vec_entry {
+	struct iwl_powertable_cmd cmd;
+	u8 no_dtim;
+};
+#define IWL_POWER_RANGE_0  (0)
+#define IWL_POWER_RANGE_1  (1)
+
+#define IWL_POWER_MODE_CAM	0x00	/* Continuously Aware Mode, always on */
+#define IWL_POWER_INDEX_3	0x03
+#define IWL_POWER_INDEX_5	0x05
+#define IWL_POWER_AC		0x06
+#define IWL_POWER_BATTERY	0x07
+#define IWL_POWER_LIMIT		0x07
+#define IWL_POWER_MASK		0x0F
+#define IWL_POWER_ENABLED	0x10
+#define IWL_POWER_LEVEL(x)	((x) & IWL_POWER_MASK)
+
+struct iwl_power_mgr {
+	spinlock_t lock;
+	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_AC];
+	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_AC];
+	u8 active_index;
+	u32 dtim_val;
+};
+
+#define IEEE80211_DATA_LEN              2304
+#define IEEE80211_4ADDR_LEN             30
+#define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
+#define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
+
+struct iwl_frame {
+	union {
+		struct ieee80211_hdr frame;
+		struct iwl_tx_beacon_cmd beacon;
+		u8 raw[IEEE80211_FRAME_LEN];
+		u8 cmd[360];
+	} u;
+	struct list_head list;
+};
+
+#define SEQ_TO_QUEUE(x)  ((x >> 8) & 0xbf)
+#define QUEUE_TO_SEQ(x)  ((x & 0xbf) << 8)
+#define SEQ_TO_INDEX(x) (x & 0xff)
+#define INDEX_TO_SEQ(x) (x & 0xff)
+#define SEQ_HUGE_FRAME  (0x4000)
+#define SEQ_RX_FRAME    __constant_cpu_to_le16(0x8000)
+#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
+#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
+#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
+
+enum {
+	/* CMD_SIZE_NORMAL = 0, */
+	CMD_SIZE_HUGE = (1 << 0),
+	/* CMD_SYNC = 0, */
+	CMD_ASYNC = (1 << 1),
+	/* CMD_NO_SKB = 0, */
+	CMD_WANT_SKB = (1 << 2),
+};
+
+struct iwl_cmd;
+struct iwl_priv;
+
+struct iwl_cmd_meta {
+	struct iwl_cmd_meta *source;
+	union {
+		struct sk_buff *skb;
+		int (*callback)(struct iwl_priv *priv,
+				struct iwl_cmd *cmd, struct sk_buff *skb);
+	} __attribute__ ((packed)) u;
+
+	/* The CMD_SIZE_HUGE flag bit indicates that the command
+	 * structure is stored at the end of the shared queue memory. */
+	u32 flags;
+
+} __attribute__ ((packed));
+
+struct iwl_cmd {
+	struct iwl_cmd_meta meta;
+	struct iwl_cmd_header hdr;
+	union {
+		struct iwl_addsta_cmd addsta;
+		struct iwl_led_cmd led;
+		u32 flags;
+		u8 val8;
+		u16 val16;
+		u32 val32;
+		struct iwl_bt_cmd bt;
+		struct iwl_rxon_time_cmd rxon_time;
+		struct iwl_powertable_cmd powertable;
+		struct iwl_qosparam_cmd qosparam;
+		struct iwl_tx_cmd tx;
+		struct iwl_tx_beacon_cmd tx_beacon;
+		struct iwl_rxon_assoc_cmd rxon_assoc;
+		u8 *indirect;
+		u8 payload[360];
+	} __attribute__ ((packed)) cmd;
+} __attribute__ ((packed));
+
+struct iwl_host_cmd {
+	u8 id;
+	u16 len;
+	struct iwl_cmd_meta meta;
+	const void *data;
+};
+
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
+			      sizeof(struct iwl_cmd_meta))
+
+/*
+ * RX related structures and functions
+ */
+#define RX_FREE_BUFFERS 64
+#define RX_LOW_WATERMARK 8
+
+#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
+#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
+#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
+
+/**
+ * struct iwl_rx_queue - Rx queue
+ * @processed: Internal index to last handled Rx packet
+ * @read: Shared index to newest available Rx buffer
+ * @write: Shared index to oldest written Rx packet
+ * @free_count: Number of pre-allocated buffers in rx_free
+ * @rx_free: list of free SKBs for use
+ * @rx_used: List of Rx buffers with no SKB
+ * @need_update: flag to indicate we need to update read/write index
+ *
+ * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
+ */
+struct iwl_rx_queue {
+	__le32 *bd;
+	dma_addr_t dma_addr;
+	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+	u32 processed;
+	u32 read;
+	u32 write;
+	u32 free_count;
+	struct list_head rx_free;
+	struct list_head rx_used;
+	int need_update;
+	spinlock_t lock;
+};
+
+#define IWL_SUPPORTED_RATES_IE_LEN         8
+
+#define SCAN_INTERVAL 100
+
+#define MAX_A_CHANNELS  252
+#define MIN_A_CHANNELS  7
+
+#define MAX_B_CHANNELS  14
+#define MIN_B_CHANNELS  1
+
+#define STATUS_HCMD_ACTIVE	0	/* host command in progress */
+#define STATUS_INT_ENABLED	1
+#define STATUS_RF_KILL_HW	2
+#define STATUS_RF_KILL_SW	3
+#define STATUS_INIT		4
+#define STATUS_ALIVE		5
+#define STATUS_READY		6
+#define STATUS_TEMPERATURE	7
+#define STATUS_GEO_CONFIGURED	8
+#define STATUS_EXIT_PENDING	9
+#define STATUS_IN_SUSPEND	10
+#define STATUS_STATISTICS	11
+#define STATUS_SCANNING		12
+#define STATUS_SCAN_ABORTING	13
+#define STATUS_SCAN_HW		14
+#define STATUS_POWER_PMI	15
+#define STATUS_FW_ERROR		16
+
+#define MAX_TID_COUNT        9
+
+#define IWL_INVALID_RATE     0xFF
+#define IWL_INVALID_VALUE    -1
+
+struct iwl_tid_data {
+	u16 seq_number;
+};
+
+struct iwl_hw_key {
+	enum ieee80211_key_alg alg;
+	int keylen;
+	u8 key[32];
+};
+
+union iwl_ht_rate_supp {
+	u16 rates;
+	struct {
+		u8 siso_rate;
+		u8 mimo_rate;
+	};
+};
+
+#ifdef CONFIG_IWLWIFI_QOS
+union iwl_qos_capabity {
+	struct {
+		u8 edca_count:4;	/* bit 0-3 */
+		u8 q_ack:1;		/* bit 4 */
+		u8 queue_request:1;	/* bit 5 */
+		u8 txop_request:1;	/* bit 6 */
+		u8 reserved:1;		/* bit 7 */
+	} q_AP;
+	struct {
+		u8 acvo_APSD:1;		/* bit 0 */
+		u8 acvi_APSD:1;		/* bit 1 */
+		u8 ac_bk_APSD:1;	/* bit 2 */
+		u8 ac_be_APSD:1;	/* bit 3 */
+		u8 q_ack:1;		/* bit 4 */
+		u8 max_len:2;		/* bit 5-6 */
+		u8 more_data_ack:1;	/* bit 7 */
+	} q_STA;
+	u8 val;
+};
+
+/* QoS sturctures */
+struct iwl_qos_info {
+	int qos_enable;
+	int qos_active;
+	union iwl_qos_capabity qos_cap;
+	struct iwl_qosparam_cmd def_qos_parm;
+};
+#endif /*CONFIG_IWLWIFI_QOS */
+
+#define STA_PS_STATUS_WAKE             0
+#define STA_PS_STATUS_SLEEP            1
+
+struct iwl_station_entry {
+	struct iwl_addsta_cmd sta;
+	struct iwl_tid_data tid[MAX_TID_COUNT];
+	union {
+		struct {
+			u8 rate;
+			u8 flags;
+		} s;
+		u16 rate_n_flags;
+	} current_rate;
+	u8 used;
+	u8 ps_status;
+	struct iwl_hw_key keyinfo;
+};
+
+/* one for each uCode image (inst/data, boot/init/runtime) */
+struct fw_image_desc {
+	void *v_addr;		/* access by driver */
+	dma_addr_t p_addr;	/* access by card's busmaster DMA */
+	u32 len;		/* bytes */
+};
+
+/* uCode file layout */
+struct iwl_ucode {
+	__le32 ver;		/* major/minor/subminor */
+	__le32 inst_size;	/* bytes of runtime instructions */
+	__le32 data_size;	/* bytes of runtime data */
+	__le32 init_size;	/* bytes of initialization instructions */
+	__le32 init_data_size;	/* bytes of initialization data */
+	__le32 boot_size;	/* bytes of bootstrap instructions */
+	u8 data[0];		/* data in same order as "size" elements */
+};
+
+#define IWL_IBSS_MAC_HASH_SIZE 32
+
+struct iwl_ibss_seq {
+	u8 mac[ETH_ALEN];
+	u16 seq_num;
+	u16 frag_num;
+	unsigned long packet_time;
+	struct list_head list;
+};
+
+struct iwl_driver_hw_info {
+	u16 max_txq_num;
+	u16 ac_queue_count;
+	u32 rx_buffer_size;
+	u16 tx_cmd_len;
+	u16 max_rxq_size;
+	u16 max_rxq_log;
+	u32 cck_flag;
+	u8  max_stations;
+	u8  bcast_sta_id;
+	void *shared_virt;
+	dma_addr_t shared_phys;
+};
+
+
+#define STA_FLG_RTS_MIMO_PROT_MSK	__constant_cpu_to_le32(1 << 17)
+#define STA_FLG_AGG_MPDU_8US_MSK	__constant_cpu_to_le32(1 << 18)
+#define STA_FLG_MAX_AGG_SIZE_POS	(19)
+#define STA_FLG_MAX_AGG_SIZE_MSK	__constant_cpu_to_le32(3 << 19)
+#define STA_FLG_FAT_EN_MSK		__constant_cpu_to_le32(1 << 21)
+#define STA_FLG_MIMO_DIS_MSK		__constant_cpu_to_le32(1 << 22)
+#define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
+#define STA_FLG_AGG_MPDU_DENSITY_MSK	__constant_cpu_to_le32(7 << 23)
+#define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
+#define HT_SHORT_GI_40MHZ_ONLY          (1 << 1)
+
+#define IWL_RX_HDR(x) ((struct iwl_rx_frame_hdr *)(\
+		       x->u.rx_frame.stats.payload + \
+		       x->u.rx_frame.stats.phy_count))
+#define IWL_RX_END(x) ((struct iwl_rx_frame_end *)(\
+		       IWL_RX_HDR(x)->payload + \
+		       le16_to_cpu(IWL_RX_HDR(x)->len)))
+#define IWL_RX_STATS(x) (&x->u.rx_frame.stats)
+#define IWL_RX_DATA(x) (IWL_RX_HDR(x)->payload)
+
+
+/******************************************************************************
+ *
+ * Functions implemented in iwl-base.c which are forward declared here
+ * for use by iwl-*.c
+ *
+ *****************************************************************************/
+struct iwl_addsta_cmd;
+extern int iwl_send_add_station(struct iwl_priv *priv,
+				struct iwl_addsta_cmd *sta, u8 flags);
+extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid,
+			  int is_ap, u8 flags);
+extern int iwl_is_network_packet(struct iwl_priv *priv,
+				 struct ieee80211_hdr *header);
+extern int iwl_power_init_handle(struct iwl_priv *priv);
+extern int iwl_eeprom_init(struct iwl_priv *priv);
+#ifdef CONFIG_IWLWIFI_DEBUG
+extern void iwl_report_frame(struct iwl_priv *priv,
+			     struct iwl_rx_packet *pkt,
+			     struct ieee80211_hdr *header, int group100);
+#else
+static inline void iwl_report_frame(struct iwl_priv *priv,
+				    struct iwl_rx_packet *pkt,
+				    struct ieee80211_hdr *header,
+				    int group100) {}
+#endif
+extern void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
+					   struct iwl_rx_mem_buffer *rxb,
+					   void *data, short len,
+					   struct ieee80211_rx_status *stats,
+					   u16 phy_flags);
+extern int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr
+			       *header);
+extern int iwl_rx_queue_alloc(struct iwl_priv *priv);
+extern void iwl_rx_queue_reset(struct iwl_priv *priv,
+			       struct iwl_rx_queue *rxq);
+extern int iwl_calc_db_from_ratio(int sig_ratio);
+extern int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm);
+extern int iwl_tx_queue_init(struct iwl_priv *priv,
+			     struct iwl_tx_queue *txq, int count, u32 id);
+extern void iwl_rx_replenish(void *data);
+extern void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+extern int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
+			    const void *data);
+extern int __must_check iwl_send_cmd(struct iwl_priv *priv,
+		struct iwl_host_cmd *cmd);
+extern unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
+					struct ieee80211_hdr *hdr,
+					const u8 *dest, int left);
+extern int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
+					 struct iwl_rx_queue *q);
+extern int iwl_send_statistics_request(struct iwl_priv *priv);
+extern void iwl_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
+				   u32 decrypt_res,
+				   struct ieee80211_rx_status *stats);
+
+extern const u8 BROADCAST_ADDR[ETH_ALEN];
+
+/*
+ * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
+ * call this... todo... fix that.
+*/
+extern u8 iwl_sync_station(struct iwl_priv *priv, int sta_id,
+			   u16 tx_rate, u8 flags);
+
+/******************************************************************************
+ *
+ * Functions implemented in iwl-[34]*.c which are forward declared here
+ * for use by iwl-base.c
+ *
+ * NOTE:  The implementation of these functions are hardware specific
+ * which is why they are in the hardware specific files (vs. iwl-base.c)
+ *
+ * Naming convention --
+ * iwl_         <-- Its part of iwlwifi (should be changed to iwl_)
+ * iwl_hw_      <-- Hardware specific (implemented in iwl-XXXX.c by all HW)
+ * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
+ * iwl_bg_      <-- Called from work queue context
+ * iwl_mac_     <-- mac80211 callback
+ *
+ ****************************************************************************/
+extern void iwl_hw_rx_handler_setup(struct iwl_priv *priv);
+extern void iwl_hw_setup_deferred_work(struct iwl_priv *priv);
+extern void iwl_hw_cancel_deferred_work(struct iwl_priv *priv);
+extern int iwl_hw_rxq_stop(struct iwl_priv *priv);
+extern int iwl_hw_set_hw_setting(struct iwl_priv *priv);
+extern int iwl_hw_nic_init(struct iwl_priv *priv);
+extern int iwl_hw_nic_stop_master(struct iwl_priv *priv);
+extern void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
+extern void iwl_hw_txq_ctx_stop(struct iwl_priv *priv);
+extern int iwl_hw_nic_reset(struct iwl_priv *priv);
+extern int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
+					dma_addr_t addr, u16 len);
+extern int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+extern int iwl_hw_get_temperature(struct iwl_priv *priv);
+extern int iwl_hw_tx_queue_init(struct iwl_priv *priv,
+				struct iwl_tx_queue *txq);
+extern unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
+				 struct iwl_frame *frame, u8 rate);
+extern int iwl_hw_get_rx_read(struct iwl_priv *priv);
+extern void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
+				     struct iwl_cmd *cmd,
+				     struct ieee80211_tx_control *ctrl,
+				     struct ieee80211_hdr *hdr,
+				     int sta_id, int tx_id);
+extern int iwl_hw_reg_send_txpower(struct iwl_priv *priv);
+extern int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
+extern void iwl_hw_rx_statistics(struct iwl_priv *priv,
+				 struct iwl_rx_mem_buffer *rxb);
+extern void iwl_disable_events(struct iwl_priv *priv);
+extern int iwl4965_get_temperature(const struct iwl_priv *priv);
+
+/**
+ * iwl_hw_find_station - Find station id for a given BSSID
+ * @bssid: MAC address of station ID to find
+ *
+ * NOTE:  This should not be hardware specific but the code has
+ * not yet been merged into a single common layer for managing the
+ * station tables.
+ */
+extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
+
+extern int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel);
+
 /*
  * Forward declare iwl-3945.c functions for iwl-base.c
  */
@@ -37,4 +747,244 @@ extern void iwl3945_reg_txpower_periodic
 extern int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv);
 extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags);
+
+
+#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+enum {
+	MEASUREMENT_READY = (1 << 0),
+	MEASUREMENT_ACTIVE = (1 << 1),
+};
+#endif
+
+struct iwl_priv {
+
+	/* ieee device used by generic ieee processing code */
+	struct ieee80211_hw *hw;
+	struct ieee80211_channel *ieee_channels;
+	struct ieee80211_rate *ieee_rates;
+
+	/* temporary frame storage list */
+	struct list_head free_frames;
+	int frames_count;
+
+	u8 phymode;
+	int alloc_rxb_skb;
+
+	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
+				       struct iwl_rx_mem_buffer *rxb);
+
+	const struct ieee80211_hw_mode *modes;
+
+#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+	/* spectrum measurement report caching */
+	struct iwl_spectrum_notification measure_report;
+	u8 measurement_status;
+#endif
+	/* ucode beacon time */
+	u32 ucode_beacon_time;
+
+	/* we allocate array of iwl_channel_info for NIC's valid channels.
+	 *    Access via channel # using indirect index array */
+	struct iwl_channel_info *channel_info;	/* channel info array */
+	u8 channel_count;	/* # of channels */
+
+	/* each calibration channel group in the EEPROM has a derived
+	 * clip setting for each rate. */
+	const struct iwl_clip_group clip_groups[5];
+
+	/* thermal calibration */
+	s32 temperature;	/* degrees Kelvin */
+	s32 last_temperature;
+
+	/* Scan related variables */
+	unsigned long last_scan_jiffies;
+	unsigned long scan_start;
+	unsigned long scan_pass_start;
+	unsigned long scan_start_tsf;
+	int scan_bands;
+	int one_direct_scan;
+	u8 direct_ssid_len;
+	u8 direct_ssid[IW_ESSID_MAX_SIZE];
+	struct iwl_scan_cmd *scan;
+	u8 only_active_channel;
+
+	/* spinlock */
+	spinlock_t lock;	/* protect general shared data */
+	spinlock_t hcmd_lock;	/* protect hcmd */
+	struct mutex mutex;
+
+	/* basic pci-network driver stuff */
+	struct pci_dev *pci_dev;
+
+	/* pci hardware address support */
+	void __iomem *hw_base;
+
+	/* uCode images, save to reload in case of failure */
+	struct fw_image_desc ucode_code;	/* runtime inst */
+	struct fw_image_desc ucode_data;	/* runtime data original */
+	struct fw_image_desc ucode_data_backup;	/* runtime data save/restore */
+	struct fw_image_desc ucode_init;	/* initialization inst */
+	struct fw_image_desc ucode_init_data;	/* initialization data */
+	struct fw_image_desc ucode_boot;	/* bootstrap inst */
+
+
+	struct iwl_rxon_time_cmd rxon_timing;
+
+	/* We declare this const so it can only be
+	 * changed via explicit cast within the
+	 * routines that actually update the physical
+	 * hardware */
+	const struct iwl_rxon_cmd active_rxon;
+	struct iwl_rxon_cmd staging_rxon;
+
+	int error_recovering;
+	struct iwl_rxon_cmd recovery_rxon;
+
+	/* 1st responses from initialize and runtime uCode images.
+	 * 4965's initialize alive response contains some calibration data. */
+	struct iwl_init_alive_resp card_alive_init;
+	struct iwl_alive_resp card_alive;
+
+#ifdef LED
+	/* LED related variables */
+	struct iwl_activity_blink activity;
+	unsigned long led_packets;
+	int led_state;
+#endif
+
+	u16 active_rate;
+	u16 active_rate_basic;
+
+	u8 call_post_assoc_from_beacon;
+	u8 assoc_station_added;
+
+	/* Rate scaling data */
+	s8 data_retry_limit;
+	u8 retry_rate;
+
+	wait_queue_head_t wait_command_queue;
+
+	int activity_timer_active;
+
+	/* Rx and Tx DMA processing queues */
+	struct iwl_rx_queue rxq;
+	struct iwl_tx_queue txq[IWL_MAX_NUM_QUEUES];
+
+	unsigned long status;
+	u32 config;
+
+	int last_rx_rssi;	/* From Rx packet statisitics */
+	int last_rx_noise;	/* From beacon statistics */
+
+	struct iwl_power_mgr power_data;
+
+	struct iwl_notif_statistics statistics;
+	unsigned long last_statistics_time;
+
+	/* context information */
+	u8 essid[IW_ESSID_MAX_SIZE];
+	u8 essid_len;
+	u16 rates_mask;
+
+	u32 power_mode;
+	u32 antenna;
+	u8 bssid[ETH_ALEN];
+	u16 rts_threshold;
+	u8 mac_addr[ETH_ALEN];
+
+	/*station table variables */
+	spinlock_t sta_lock;
+	int num_stations;
+	struct iwl_station_entry stations[IWL_STATION_COUNT];
+
+	/* Indication if ieee80211_ops->open has been called */
+	int is_open;
+
+	u8 mac80211_registered;
+	int is_abg;
+
+	u32 notif_missed_beacons;
+
+	/* Rx'd packet timing information */
+	u32 last_beacon_time;
+	u64 last_tsf;
+
+	/* Duplicate packet detection */
+	u16 last_seq_num;
+	u16 last_frag_num;
+	unsigned long last_packet_time;
+	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
+
+	/* eeprom */
+	struct iwl_eeprom eeprom;
+
+	int iw_mode;
+
+	struct sk_buff *ibss_beacon;
+
+	/* Last Rx'd beacon timestamp */
+	u32 timestamp0;
+	u32 timestamp1;
+	u16 beacon_int;
+	struct iwl_driver_hw_info hw_setting;
+	int interface_id;
+
+	/* Current association information needed to configure the
+	 * hardware */
+	u16 assoc_id;
+	u16 assoc_capability;
+	u8 ps_mode;
+
+#ifdef CONFIG_IWLWIFI_QOS
+	struct iwl_qos_info qos_data;
+#endif /*CONFIG_IWLWIFI_QOS */
+
+	struct workqueue_struct *workqueue;
+
+	struct work_struct up;
+	struct work_struct restart;
+	struct work_struct calibrated_work;
+	struct work_struct scan_completed;
+	struct work_struct rx_replenish;
+	struct work_struct rf_kill;
+	struct work_struct abort_scan;
+	struct work_struct update_link_led;
+	struct work_struct auth_work;
+	struct work_struct report_work;
+	struct work_struct request_scan;
+	struct work_struct beacon_update;
+
+	struct tasklet_struct irq_tasklet;
+
+	struct delayed_work init_alive_start;
+	struct delayed_work alive_start;
+	struct delayed_work activity_timer;
+	struct delayed_work thermal_periodic;
+	struct delayed_work gather_stats;
+	struct delayed_work scan_check;
+	struct delayed_work post_associate;
+
+#define IWL_DEFAULT_TX_POWER 0x0F
+	s8 user_txpower_limit;
+	s8 max_channel_txpower_limit;
+	u32 cck_power_index_compensation;
+
+#ifdef CONFIG_PM
+	u32 pm_state[16];
+#endif
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	/* debugging info */
+	u32 framecnt_to_us;
+	atomic_t restrict_refcnt;
+#endif
+};				/*iwl_priv */
+
+static inline int iwl_is_associated(struct iwl_priv *priv)
+{
+	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+}
+
+#include "iwl-3945-io.h"
+
 #endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2007-10-12 11:15:54.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2007-10-12 12:06:37.000000000 +0200
@@ -38,12 +38,9 @@
 
 #include <net/mac80211.h>
 #include <linux/wireless.h>
-
-#define IWL 4965
-
 #include "../net/mac80211/ieee80211_rate.h"
 
-#include "iwlwifi.h"
+#include "iwl-4965.h"
 #include "iwl-helpers.h"
 
 #define RS_NAME "iwl-4965-rs"
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-10-12 11:15:49.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.c	2007-10-12 12:06:37.000000000 +0200
@@ -39,9 +39,6 @@
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 
-#define IWL 4965
-
-#include "iwlwifi.h"
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-10-12 11:10:38.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-10-12 12:06:37.000000000 +0200
@@ -26,6 +26,767 @@
 #ifndef __iwl_4965_h__
 #define __iwl_4965_h__
 
+#include <linux/pci.h> /* for struct pci_device_id */
+#include <linux/kernel.h>
+#include <linux/workqueue.h>
+#include <net/ieee80211_radiotap.h>
+
+struct iwl_priv;
+
+/* Hardware specific file defines the PCI IDs table for that hardware module */
+extern struct pci_device_id iwl_hw_card_ids[];
+
+#define DRV_NAME        "iwl4965"
+#include "iwl-4965-hw.h"
+#include "iwl-prph.h"
+
+/*
+ * Driver implementation data structures, constants, inline
+ * functions
+ *
+ * NOTE:  DO NOT PUT HARDWARE/UCODE SPECIFIC DECLRATIONS HERE
+ *
+ * Hardware specific declrations go into iwl-*hw.h
+ *
+ */
+
+#include "iwl-4965-debug.h"
+
+/* Default noise level to report when noise measurement is not available.
+ *   This may be because we're:
+ *   1)  Not associated (4965, no beacon statistics being sent to driver)
+ *   2)  Scanning (noise measurement does not apply to associated channel)
+ *   3)  Receiving CCK (3945 delivers noise info only for OFDM frames)
+ * Use default noise value of -127 ... this is below the range of measurable
+ *   Rx dBm for either 3945 or 4965, so it can indicate "unmeasurable" to user.
+ *   Also, -127 works better than 0 when averaging frames with/without
+ *   noise info (e.g. averaging might be done in app); measured dBm values are
+ *   always negative ... using a negative value as the default keeps all
+ *   averages within an s8's (used in some apps) range of negative values. */
+#define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
+
+/* Module parameters accessible from iwl-*.c */
+extern int iwl_param_disable_hw_scan;
+extern int iwl_param_debug;
+extern int iwl_param_mode;
+extern int iwl_param_disable;
+extern int iwl_param_antenna;
+extern int iwl_param_hwcrypto;
+extern int iwl_param_queues_num;
+
+enum iwl_antenna {
+	IWL_ANTENNA_DIVERSITY,
+	IWL_ANTENNA_MAIN,
+	IWL_ANTENNA_AUX
+};
+
+/*
+ * RTS threshold here is total size [2347] minus 4 FCS bytes
+ * Per spec:
+ *   a value of 0 means RTS on all data/management packets
+ *   a value > max MSDU size means no RTS
+ * else RTS for data/management frames where MPDU is larger
+ *   than RTS value.
+ */
+#define DEFAULT_RTS_THRESHOLD     2347U
+#define MIN_RTS_THRESHOLD         0U
+#define MAX_RTS_THRESHOLD         2347U
+#define MAX_MSDU_SIZE		  2304U
+#define MAX_MPDU_SIZE		  2346U
+#define DEFAULT_BEACON_INTERVAL   100U
+#define	DEFAULT_SHORT_RETRY_LIMIT 7U
+#define	DEFAULT_LONG_RETRY_LIMIT  4U
+
+struct iwl_rx_mem_buffer {
+	dma_addr_t dma_addr;
+	struct sk_buff *skb;
+	struct list_head list;
+};
+
+struct iwl_rt_rx_hdr {
+	struct ieee80211_radiotap_header rt_hdr;
+	__le64 rt_tsf;		/* TSF */
+	u8 rt_flags;		/* radiotap packet flags */
+	u8 rt_rate;		/* rate in 500kb/s */
+	__le16 rt_channelMHz;	/* channel in MHz */
+	__le16 rt_chbitmask;	/* channel bitfield */
+	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
+	s8 rt_dbmnoise;
+	u8 rt_antenna;		/* antenna number */
+	u8 payload[0];		/* payload... */
+} __attribute__ ((packed));
+
+struct iwl_rt_tx_hdr {
+	struct ieee80211_radiotap_header rt_hdr;
+	u8 rt_rate;		/* rate in 500kb/s */
+	__le16 rt_channel;	/* channel in mHz */
+	__le16 rt_chbitmask;	/* channel bitfield */
+	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
+	u8 rt_antenna;		/* antenna number */
+	u8 payload[0];		/* payload... */
+} __attribute__ ((packed));
+
+/*
+ * Generic queue structure
+ *
+ * Contains common data for Rx and Tx queues
+ */
+struct iwl_queue {
+	int n_bd;              /* number of BDs in this queue */
+	int first_empty;       /* 1-st empty entry (index) host_w*/
+	int last_used;         /* last used entry (index) host_r*/
+	dma_addr_t dma_addr;   /* physical addr for BD's */
+	int n_window;	       /* safe queue window */
+	u32 id;
+	int low_mark;	       /* low watermark, resume queue if free
+				* space more than this */
+	int high_mark;         /* high watermark, stop queue if free
+				* space less than this */
+} __attribute__ ((packed));
+
+#define MAX_NUM_OF_TBS          (20)
+
+struct iwl_tx_info {
+	struct ieee80211_tx_status status;
+	struct sk_buff *skb[MAX_NUM_OF_TBS];
+};
+
+/**
+ * struct iwl_tx_queue - Tx Queue for DMA
+ * @need_update: need to update read/write index
+ * @shed_retry: queue is HT AGG enabled
+ *
+ * Queue consists of circular buffer of BD's and required locking structures.
+ */
+struct iwl_tx_queue {
+	struct iwl_queue q;
+	struct iwl_tfd_frame *bd;
+	struct iwl_cmd *cmd;
+	dma_addr_t dma_addr_cmd;
+	struct iwl_tx_info *txb;
+	int need_update;
+	int sched_retry;
+	int active;
+};
+
+#define IWL_NUM_SCAN_RATES         (2)
+
+struct iwl_channel_tgd_info {
+	u8 type;
+	s8 max_power;
+};
+
+struct iwl_channel_tgh_info {
+	s64 last_radar_time;
+};
+
+/* current Tx power values to use, one for each rate for each channel.
+ * requested power is limited by:
+ * -- regulatory EEPROM limits for this channel
+ * -- hardware capabilities (clip-powers)
+ * -- spectrum management
+ * -- user preference (e.g. iwconfig)
+ * when requested power is set, base power index must also be set. */
+struct iwl_channel_power_info {
+	struct iwl_tx_power tpc;	/* actual radio and DSP gain settings */
+	s8 power_table_index;	/* actual (compenst'd) index into gain table */
+	s8 base_power_index;	/* gain index for power at factory temp. */
+	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
+};
+
+/* current scan Tx power values to use, one for each scan rate for each
+ * channel. */
+struct iwl_scan_power_info {
+	struct iwl_tx_power tpc;	/* actual radio and DSP gain settings */
+	s8 power_table_index;	/* actual (compenst'd) index into gain table */
+	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
+};
+
+/* Channel unlock period is 15 seconds. If no beacon or probe response
+ * has been received within 15 seconds on a locked channel then the channel
+ * remains locked. */
+#define TX_UNLOCK_PERIOD 15
+
+/* CSA lock period is 15 seconds.  If a CSA has been received on a channel in
+ * the last 15 seconds, the channel is locked */
+#define CSA_LOCK_PERIOD 15
+/*
+ * One for each channel, holds all channel setup data
+ * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
+ *     with one another!
+ */
+#define IWL4965_MAX_RATE (33)
+
+struct iwl_channel_info {
+	struct iwl_channel_tgd_info tgd;
+	struct iwl_channel_tgh_info tgh;
+	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
+	struct iwl_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
+						 * FAT channel */
+
+	u8 channel;	  /* channel number */
+	u8 flags;	  /* flags copied from EEPROM */
+	s8 max_power_avg; /* (dBm) regul. eeprom, normal Tx, any rate */
+	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) */
+	s8 min_power;	  /* always 0 */
+	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
+
+	u8 group_index;	  /* 0-4, maps channel to group1/2/3/4/5 */
+	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
+	u8 phymode;	  /* MODE_IEEE80211{A,B,G} */
+
+	/* Radio/DSP gain settings for each "normal" data Tx rate.
+	 * These include, in addition to RF and DSP gain, a few fields for
+	 *   remembering/modifying gain settings (indexes). */
+	struct iwl_channel_power_info power_info[IWL4965_MAX_RATE];
+
+	/* FAT channel info */
+	s8 fat_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
+	s8 fat_curr_txpow;	/* (dBm) regulatory/spectrum/user (not h/w) */
+	s8 fat_min_power;	/* always 0 */
+	s8 fat_scan_power;	/* (dBm) eeprom, direct scans, any rate */
+	u8 fat_flags;		/* flags copied from EEPROM */
+	u8 fat_extension_channel;
+
+	/* Radio/DSP gain settings for each scan rate, for directed scans. */
+	struct iwl_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
+};
+
+struct iwl_clip_group {
+	/* maximum power level to prevent clipping for each rate, derived by
+	 *   us from this band's saturation power in EEPROM */
+	const s8 clip_powers[IWL_MAX_RATES];
+};
+
+static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
+{
+	if (ch_info == NULL)
+		return 0;
+	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
+}
+
+static inline int is_channel_narrow(const struct iwl_channel_info *ch_info)
+{
+	return (ch_info->flags & EEPROM_CHANNEL_NARROW) ? 1 : 0;
+}
+
+static inline int is_channel_radar(const struct iwl_channel_info *ch_info)
+{
+	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
+}
+
+static inline u8 is_channel_a_band(const struct iwl_channel_info *ch_info)
+{
+	return ch_info->phymode == MODE_IEEE80211A;
+}
+
+static inline u8 is_channel_bg_band(const struct iwl_channel_info *ch_info)
+{
+	return ((ch_info->phymode == MODE_IEEE80211B) ||
+		(ch_info->phymode == MODE_IEEE80211G));
+}
+
+static inline int is_channel_passive(const struct iwl_channel_info *ch)
+{
+	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
+}
+
+static inline int is_channel_ibss(const struct iwl_channel_info *ch)
+{
+	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
+}
+
+extern const struct iwl_channel_info *iwl_get_channel_info(
+	const struct iwl_priv *priv, int phymode, u16 channel);
+
+
+#include "iwl-4965-rs.h"
+
+#define IWL_TX_FIFO_AC0	0
+#define IWL_TX_FIFO_AC1	1
+#define IWL_TX_FIFO_AC2	2
+#define IWL_TX_FIFO_AC3	3
+#define IWL_TX_FIFO_HCCA_1	5
+#define IWL_TX_FIFO_HCCA_2	6
+#define IWL_TX_FIFO_NONE	7
+
+/* Minimum number of queues. MAX_NUM is defined in hw specific files */
+#define IWL_MIN_NUM_QUEUES	4
+
+/* Power management (not Tx power) structures */
+
+struct iwl_power_vec_entry {
+	struct iwl_powertable_cmd cmd;
+	u8 no_dtim;
+};
+#define IWL_POWER_RANGE_0  (0)
+#define IWL_POWER_RANGE_1  (1)
+
+#define IWL_POWER_MODE_CAM	0x00	/* Continuously Aware Mode, always on */
+#define IWL_POWER_INDEX_3	0x03
+#define IWL_POWER_INDEX_5	0x05
+#define IWL_POWER_AC		0x06
+#define IWL_POWER_BATTERY	0x07
+#define IWL_POWER_LIMIT		0x07
+#define IWL_POWER_MASK		0x0F
+#define IWL_POWER_ENABLED	0x10
+#define IWL_POWER_LEVEL(x)	((x) & IWL_POWER_MASK)
+
+struct iwl_power_mgr {
+	spinlock_t lock;
+	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_AC];
+	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_AC];
+	u8 active_index;
+	u32 dtim_val;
+};
+
+#define IEEE80211_DATA_LEN              2304
+#define IEEE80211_4ADDR_LEN             30
+#define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
+#define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
+
+struct iwl_frame {
+	union {
+		struct ieee80211_hdr frame;
+		struct iwl_tx_beacon_cmd beacon;
+		u8 raw[IEEE80211_FRAME_LEN];
+		u8 cmd[360];
+	} u;
+	struct list_head list;
+};
+
+#define SEQ_TO_QUEUE(x)  ((x >> 8) & 0xbf)
+#define QUEUE_TO_SEQ(x)  ((x & 0xbf) << 8)
+#define SEQ_TO_INDEX(x) (x & 0xff)
+#define INDEX_TO_SEQ(x) (x & 0xff)
+#define SEQ_HUGE_FRAME  (0x4000)
+#define SEQ_RX_FRAME    __constant_cpu_to_le16(0x8000)
+#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
+#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
+#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
+
+enum {
+	/* CMD_SIZE_NORMAL = 0, */
+	CMD_SIZE_HUGE = (1 << 0),
+	/* CMD_SYNC = 0, */
+	CMD_ASYNC = (1 << 1),
+	/* CMD_NO_SKB = 0, */
+	CMD_WANT_SKB = (1 << 2),
+};
+
+struct iwl_cmd;
+struct iwl_priv;
+
+struct iwl_cmd_meta {
+	struct iwl_cmd_meta *source;
+	union {
+		struct sk_buff *skb;
+		int (*callback)(struct iwl_priv *priv,
+				struct iwl_cmd *cmd, struct sk_buff *skb);
+	} __attribute__ ((packed)) u;
+
+	/* The CMD_SIZE_HUGE flag bit indicates that the command
+	 * structure is stored at the end of the shared queue memory. */
+	u32 flags;
+
+} __attribute__ ((packed));
+
+struct iwl_cmd {
+	struct iwl_cmd_meta meta;
+	struct iwl_cmd_header hdr;
+	union {
+		struct iwl_addsta_cmd addsta;
+		struct iwl_led_cmd led;
+		u32 flags;
+		u8 val8;
+		u16 val16;
+		u32 val32;
+		struct iwl_bt_cmd bt;
+		struct iwl_rxon_time_cmd rxon_time;
+		struct iwl_powertable_cmd powertable;
+		struct iwl_qosparam_cmd qosparam;
+		struct iwl_tx_cmd tx;
+		struct iwl_tx_beacon_cmd tx_beacon;
+		struct iwl_rxon_assoc_cmd rxon_assoc;
+		u8 *indirect;
+		u8 payload[360];
+	} __attribute__ ((packed)) cmd;
+} __attribute__ ((packed));
+
+struct iwl_host_cmd {
+	u8 id;
+	u16 len;
+	struct iwl_cmd_meta meta;
+	const void *data;
+};
+
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
+			      sizeof(struct iwl_cmd_meta))
+
+/*
+ * RX related structures and functions
+ */
+#define RX_FREE_BUFFERS 64
+#define RX_LOW_WATERMARK 8
+
+#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
+#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
+#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
+
+/**
+ * struct iwl_rx_queue - Rx queue
+ * @processed: Internal index to last handled Rx packet
+ * @read: Shared index to newest available Rx buffer
+ * @write: Shared index to oldest written Rx packet
+ * @free_count: Number of pre-allocated buffers in rx_free
+ * @rx_free: list of free SKBs for use
+ * @rx_used: List of Rx buffers with no SKB
+ * @need_update: flag to indicate we need to update read/write index
+ *
+ * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
+ */
+struct iwl_rx_queue {
+	__le32 *bd;
+	dma_addr_t dma_addr;
+	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
+	u32 processed;
+	u32 read;
+	u32 write;
+	u32 free_count;
+	struct list_head rx_free;
+	struct list_head rx_used;
+	int need_update;
+	spinlock_t lock;
+};
+
+#define IWL_SUPPORTED_RATES_IE_LEN         8
+
+#define SCAN_INTERVAL 100
+
+#define MAX_A_CHANNELS  252
+#define MIN_A_CHANNELS  7
+
+#define MAX_B_CHANNELS  14
+#define MIN_B_CHANNELS  1
+
+#define STATUS_HCMD_ACTIVE	0	/* host command in progress */
+#define STATUS_INT_ENABLED	1
+#define STATUS_RF_KILL_HW	2
+#define STATUS_RF_KILL_SW	3
+#define STATUS_INIT		4
+#define STATUS_ALIVE		5
+#define STATUS_READY		6
+#define STATUS_TEMPERATURE	7
+#define STATUS_GEO_CONFIGURED	8
+#define STATUS_EXIT_PENDING	9
+#define STATUS_IN_SUSPEND	10
+#define STATUS_STATISTICS	11
+#define STATUS_SCANNING		12
+#define STATUS_SCAN_ABORTING	13
+#define STATUS_SCAN_HW		14
+#define STATUS_POWER_PMI	15
+#define STATUS_FW_ERROR		16
+
+#define MAX_TID_COUNT        9
+
+#define IWL_INVALID_RATE     0xFF
+#define IWL_INVALID_VALUE    -1
+
+#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWLWIFI_HT_AGG
+struct iwl_ht_agg {
+	u16 txq_id;
+	u16 frame_count;
+	u16 wait_for_ba;
+	u16 start_idx;
+	u32 bitmap0;
+	u32 bitmap1;
+	u32 rate_n_flags;
+};
+#endif /* CONFIG_IWLWIFI_HT_AGG */
+#endif /* CONFIG_IWLWIFI_HT */
+
+struct iwl_tid_data {
+	u16 seq_number;
+#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWLWIFI_HT_AGG
+	struct iwl_ht_agg agg;
+#endif	/* CONFIG_IWLWIFI_HT_AGG */
+#endif /* CONFIG_IWLWIFI_HT */
+};
+
+struct iwl_hw_key {
+	enum ieee80211_key_alg alg;
+	int keylen;
+	u8 key[32];
+};
+
+union iwl_ht_rate_supp {
+	u16 rates;
+	struct {
+		u8 siso_rate;
+		u8 mimo_rate;
+	};
+};
+
+#ifdef CONFIG_IWLWIFI_HT
+#define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
+#define HT_IE_MAX_AMSDU_SIZE_4K     (0)
+#define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
+#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
+
+struct sta_ht_info {
+	u8 is_ht;
+	u16 rx_mimo_ps_mode;
+	u16 tx_mimo_ps_mode;
+	u16 control_channel;
+	u8 max_amsdu_size;
+	u8 ampdu_factor;
+	u8 mpdu_density;
+	u8 operating_mode;
+	u8 supported_chan_width;
+	u8 extension_chan_offset;
+	u8 is_green_field;
+	u8 sgf;
+	u8 supp_rates[16];
+	u8 tx_chan_width;
+	u8 chan_width_cap;
+};
+#endif				/*CONFIG_IWLWIFI_HT */
+
+#ifdef CONFIG_IWLWIFI_QOS
+
+union iwl_qos_capabity {
+	struct {
+		u8 edca_count:4;	/* bit 0-3 */
+		u8 q_ack:1;		/* bit 4 */
+		u8 queue_request:1;	/* bit 5 */
+		u8 txop_request:1;	/* bit 6 */
+		u8 reserved:1;		/* bit 7 */
+	} q_AP;
+	struct {
+		u8 acvo_APSD:1;		/* bit 0 */
+		u8 acvi_APSD:1;		/* bit 1 */
+		u8 ac_bk_APSD:1;	/* bit 2 */
+		u8 ac_be_APSD:1;	/* bit 3 */
+		u8 q_ack:1;		/* bit 4 */
+		u8 max_len:2;		/* bit 5-6 */
+		u8 more_data_ack:1;	/* bit 7 */
+	} q_STA;
+	u8 val;
+};
+
+/* QoS sturctures */
+struct iwl_qos_info {
+	int qos_enable;
+	int qos_active;
+	union iwl_qos_capabity qos_cap;
+	struct iwl_qosparam_cmd def_qos_parm;
+};
+#endif /*CONFIG_IWLWIFI_QOS */
+
+#define STA_PS_STATUS_WAKE             0
+#define STA_PS_STATUS_SLEEP            1
+
+struct iwl_station_entry {
+	struct iwl_addsta_cmd sta;
+	struct iwl_tid_data tid[MAX_TID_COUNT];
+	u8 used;
+	u8 ps_status;
+	struct iwl_hw_key keyinfo;
+};
+
+/* one for each uCode image (inst/data, boot/init/runtime) */
+struct fw_image_desc {
+	void *v_addr;		/* access by driver */
+	dma_addr_t p_addr;	/* access by card's busmaster DMA */
+	u32 len;		/* bytes */
+};
+
+/* uCode file layout */
+struct iwl_ucode {
+	__le32 ver;		/* major/minor/subminor */
+	__le32 inst_size;	/* bytes of runtime instructions */
+	__le32 data_size;	/* bytes of runtime data */
+	__le32 init_size;	/* bytes of initialization instructions */
+	__le32 init_data_size;	/* bytes of initialization data */
+	__le32 boot_size;	/* bytes of bootstrap instructions */
+	u8 data[0];		/* data in same order as "size" elements */
+};
+
+#define IWL_IBSS_MAC_HASH_SIZE 32
+
+struct iwl_ibss_seq {
+	u8 mac[ETH_ALEN];
+	u16 seq_num;
+	u16 frag_num;
+	unsigned long packet_time;
+	struct list_head list;
+};
+
+struct iwl_driver_hw_info {
+	u16 max_txq_num;
+	u16 ac_queue_count;
+	u32 rx_buffer_size;
+	u16 tx_cmd_len;
+	u16 max_rxq_size;
+	u16 max_rxq_log;
+	u32 cck_flag;
+	u8  max_stations;
+	u8  bcast_sta_id;
+	void *shared_virt;
+	dma_addr_t shared_phys;
+};
+
+
+#define STA_FLG_RTS_MIMO_PROT_MSK	__constant_cpu_to_le32(1 << 17)
+#define STA_FLG_AGG_MPDU_8US_MSK	__constant_cpu_to_le32(1 << 18)
+#define STA_FLG_MAX_AGG_SIZE_POS	(19)
+#define STA_FLG_MAX_AGG_SIZE_MSK	__constant_cpu_to_le32(3 << 19)
+#define STA_FLG_FAT_EN_MSK		__constant_cpu_to_le32(1 << 21)
+#define STA_FLG_MIMO_DIS_MSK		__constant_cpu_to_le32(1 << 22)
+#define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
+#define STA_FLG_AGG_MPDU_DENSITY_MSK	__constant_cpu_to_le32(7 << 23)
+#define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
+#define HT_SHORT_GI_40MHZ_ONLY          (1 << 1)
+
+#define IWL_RX_HDR(x) ((struct iwl_rx_frame_hdr *)(\
+		       x->u.rx_frame.stats.payload + \
+		       x->u.rx_frame.stats.phy_count))
+#define IWL_RX_END(x) ((struct iwl_rx_frame_end *)(\
+		       IWL_RX_HDR(x)->payload + \
+		       le16_to_cpu(IWL_RX_HDR(x)->len)))
+#define IWL_RX_STATS(x) (&x->u.rx_frame.stats)
+#define IWL_RX_DATA(x) (IWL_RX_HDR(x)->payload)
+
+
+/******************************************************************************
+ *
+ * Functions implemented in iwl-base.c which are forward declared here
+ * for use by iwl-*.c
+ *
+ *****************************************************************************/
+struct iwl_addsta_cmd;
+extern int iwl_send_add_station(struct iwl_priv *priv,
+				struct iwl_addsta_cmd *sta, u8 flags);
+extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid,
+			  int is_ap, u8 flags);
+extern int iwl_is_network_packet(struct iwl_priv *priv,
+				 struct ieee80211_hdr *header);
+extern int iwl_power_init_handle(struct iwl_priv *priv);
+extern int iwl_eeprom_init(struct iwl_priv *priv);
+#ifdef CONFIG_IWLWIFI_DEBUG
+extern void iwl_report_frame(struct iwl_priv *priv,
+			     struct iwl_rx_packet *pkt,
+			     struct ieee80211_hdr *header, int group100);
+#else
+static inline void iwl_report_frame(struct iwl_priv *priv,
+				    struct iwl_rx_packet *pkt,
+				    struct ieee80211_hdr *header,
+				    int group100) {}
+#endif
+extern void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
+					   struct iwl_rx_mem_buffer *rxb,
+					   void *data, short len,
+					   struct ieee80211_rx_status *stats,
+					   u16 phy_flags);
+extern int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr
+			       *header);
+extern int iwl_rx_queue_alloc(struct iwl_priv *priv);
+extern void iwl_rx_queue_reset(struct iwl_priv *priv,
+			       struct iwl_rx_queue *rxq);
+extern int iwl_calc_db_from_ratio(int sig_ratio);
+extern int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm);
+extern int iwl_tx_queue_init(struct iwl_priv *priv,
+			     struct iwl_tx_queue *txq, int count, u32 id);
+extern void iwl_rx_replenish(void *data);
+extern void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+extern int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
+			    const void *data);
+extern int __must_check iwl_send_cmd(struct iwl_priv *priv,
+		struct iwl_host_cmd *cmd);
+extern unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
+					struct ieee80211_hdr *hdr,
+					const u8 *dest, int left);
+extern int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
+					 struct iwl_rx_queue *q);
+extern int iwl_send_statistics_request(struct iwl_priv *priv);
+extern void iwl_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
+				   u32 decrypt_res,
+				   struct ieee80211_rx_status *stats);
+extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
+
+extern const u8 BROADCAST_ADDR[ETH_ALEN];
+
+/*
+ * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
+ * call this... todo... fix that.
+*/
+extern u8 iwl_sync_station(struct iwl_priv *priv, int sta_id,
+			   u16 tx_rate, u8 flags);
+
+
+/******************************************************************************
+ *
+ * Functions implemented in iwl-[34]*.c which are forward declared here
+ * for use by iwl-base.c
+ *
+ * NOTE:  The implementation of these functions are hardware specific
+ * which is why they are in the hardware specific files (vs. iwl-base.c)
+ *
+ * Naming convention --
+ * iwl_         <-- Its part of iwlwifi (should be changed to iwl_)
+ * iwl_hw_      <-- Hardware specific (implemented in iwl-XXXX.c by all HW)
+ * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
+ * iwl_bg_      <-- Called from work queue context
+ * iwl_mac_     <-- mac80211 callback
+ *
+ ****************************************************************************/
+extern void iwl_hw_rx_handler_setup(struct iwl_priv *priv);
+extern void iwl_hw_setup_deferred_work(struct iwl_priv *priv);
+extern void iwl_hw_cancel_deferred_work(struct iwl_priv *priv);
+extern int iwl_hw_rxq_stop(struct iwl_priv *priv);
+extern int iwl_hw_set_hw_setting(struct iwl_priv *priv);
+extern int iwl_hw_nic_init(struct iwl_priv *priv);
+extern int iwl_hw_nic_stop_master(struct iwl_priv *priv);
+extern void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
+extern void iwl_hw_txq_ctx_stop(struct iwl_priv *priv);
+extern int iwl_hw_nic_reset(struct iwl_priv *priv);
+extern int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
+					dma_addr_t addr, u16 len);
+extern int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+extern int iwl_hw_get_temperature(struct iwl_priv *priv);
+extern int iwl_hw_tx_queue_init(struct iwl_priv *priv,
+				struct iwl_tx_queue *txq);
+extern unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
+				 struct iwl_frame *frame, u8 rate);
+extern int iwl_hw_get_rx_read(struct iwl_priv *priv);
+extern void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
+				     struct iwl_cmd *cmd,
+				     struct ieee80211_tx_control *ctrl,
+				     struct ieee80211_hdr *hdr,
+				     int sta_id, int tx_id);
+extern int iwl_hw_reg_send_txpower(struct iwl_priv *priv);
+extern int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
+extern void iwl_hw_rx_statistics(struct iwl_priv *priv,
+				 struct iwl_rx_mem_buffer *rxb);
+extern void iwl_disable_events(struct iwl_priv *priv);
+extern int iwl4965_get_temperature(const struct iwl_priv *priv);
+
+/**
+ * iwl_hw_find_station - Find station id for a given BSSID
+ * @bssid: MAC address of station ID to find
+ *
+ * NOTE:  This should not be hardware specific but the code has
+ * not yet been merged into a single common layer for managing the
+ * station tables.
+ */
+extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
+
+extern int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel);
+extern int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
+
 struct iwl_priv;
 struct sta_ht_info;
 
@@ -314,7 +1075,6 @@ struct iwl_chain_noise_data {
 	u8 radio_write;
 };
 
-/* IWL4965 */
 #define RATE_MCS_CODE_MSK 0x7
 #define RATE_MCS_MIMO_POS 3
 #define RATE_MCS_MIMO_MSK 0x8
@@ -338,4 +1098,277 @@ struct iwl_chain_noise_data {
 #define	EEPROM_SEM_TIMEOUT 10
 #define EEPROM_SEM_RETRY_LIMIT 1000
 
+#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+enum {
+	MEASUREMENT_READY = (1 << 0),
+	MEASUREMENT_ACTIVE = (1 << 1),
+};
+#endif
+
+struct iwl_priv {
+	/* ieee device used by generic ieee processing code */
+	struct ieee80211_hw *hw;
+	struct ieee80211_channel *ieee_channels;
+	struct ieee80211_rate *ieee_rates;
+
+	/* temporary frame storage list */
+	struct list_head free_frames;
+	int frames_count;
+
+	u8 phymode;
+	int alloc_rxb_skb;
+
+	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
+				       struct iwl_rx_mem_buffer *rxb);
+
+	const struct ieee80211_hw_mode *modes;
+
+#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
+	/* spectrum measurement report caching */
+	struct iwl_spectrum_notification measure_report;
+	u8 measurement_status;
+#endif
+	/* ucode beacon time */
+	u32 ucode_beacon_time;
+
+	/* we allocate array of iwl_channel_info for NIC's valid channels.
+	 *    Access via channel # using indirect index array */
+	struct iwl_channel_info *channel_info;	/* channel info array */
+	u8 channel_count;	/* # of channels */
+
+	/* each calibration channel group in the EEPROM has a derived
+	 * clip setting for each rate. */
+	const struct iwl_clip_group clip_groups[5];
+
+	/* thermal calibration */
+	s32 temperature;	/* degrees Kelvin */
+	s32 last_temperature;
+
+	/* Scan related variables */
+	unsigned long last_scan_jiffies;
+	unsigned long scan_start;
+	unsigned long scan_pass_start;
+	unsigned long scan_start_tsf;
+	int scan_bands;
+	int one_direct_scan;
+	u8 direct_ssid_len;
+	u8 direct_ssid[IW_ESSID_MAX_SIZE];
+	struct iwl_scan_cmd *scan;
+	u8 only_active_channel;
+
+	/* spinlock */
+	spinlock_t lock;	/* protect general shared data */
+	spinlock_t hcmd_lock;	/* protect hcmd */
+	struct mutex mutex;
+
+	/* basic pci-network driver stuff */
+	struct pci_dev *pci_dev;
+
+	/* pci hardware address support */
+	void __iomem *hw_base;
+
+	/* uCode images, save to reload in case of failure */
+	struct fw_image_desc ucode_code;	/* runtime inst */
+	struct fw_image_desc ucode_data;	/* runtime data original */
+	struct fw_image_desc ucode_data_backup;	/* runtime data save/restore */
+	struct fw_image_desc ucode_init;	/* initialization inst */
+	struct fw_image_desc ucode_init_data;	/* initialization data */
+	struct fw_image_desc ucode_boot;	/* bootstrap inst */
+
+
+	struct iwl_rxon_time_cmd rxon_timing;
+
+	/* We declare this const so it can only be
+	 * changed via explicit cast within the
+	 * routines that actually update the physical
+	 * hardware */
+	const struct iwl_rxon_cmd active_rxon;
+	struct iwl_rxon_cmd staging_rxon;
+
+	int error_recovering;
+	struct iwl_rxon_cmd recovery_rxon;
+
+	/* 1st responses from initialize and runtime uCode images.
+	 * 4965's initialize alive response contains some calibration data. */
+	struct iwl_init_alive_resp card_alive_init;
+	struct iwl_alive_resp card_alive;
+
+#ifdef LED
+	/* LED related variables */
+	struct iwl_activity_blink activity;
+	unsigned long led_packets;
+	int led_state;
+#endif
+
+	u16 active_rate;
+	u16 active_rate_basic;
+
+	u8 call_post_assoc_from_beacon;
+	u8 assoc_station_added;
+	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
+	/* HT variables */
+	u8 is_dup;
+	u8 is_ht_enabled;
+	u8 channel_width;	/* 0=20MHZ, 1=40MHZ */
+	u8 current_channel_width;
+	u8 valid_antenna;	/* Bit mask of antennas actually connected */
+#ifdef CONFIG_IWLWIFI_SENSITIVITY
+	struct iwl_sensitivity_data sensitivity_data;
+	struct iwl_chain_noise_data chain_noise_data;
+	u8 start_calib;
+	__le16 sensitivity_tbl[HD_TABLE_SIZE];
+#endif /*CONFIG_IWLWIFI_SENSITIVITY*/
+
+#ifdef CONFIG_IWLWIFI_HT
+	struct sta_ht_info current_assoc_ht;
+#endif
+	u8 active_rate_ht[2];
+	u8 last_phy_res[100];
+
+	/* Rate scaling data */
+	struct iwl_lq_mngr lq_mngr;
+
+	/* Rate scaling data */
+	s8 data_retry_limit;
+	u8 retry_rate;
+
+	wait_queue_head_t wait_command_queue;
+
+	int activity_timer_active;
+
+	/* Rx and Tx DMA processing queues */
+	struct iwl_rx_queue rxq;
+	struct iwl_tx_queue txq[IWL_MAX_NUM_QUEUES];
+	unsigned long txq_ctx_active_msk;
+	struct iwl_kw kw;	/* keep warm address */
+	u32 scd_base_addr;	/* scheduler sram base address */
+
+	unsigned long status;
+	u32 config;
+
+	int last_rx_rssi;	/* From Rx packet statisitics */
+	int last_rx_noise;	/* From beacon statistics */
+
+	struct iwl_power_mgr power_data;
+
+	struct iwl_notif_statistics statistics;
+	unsigned long last_statistics_time;
+
+	/* context information */
+	u8 essid[IW_ESSID_MAX_SIZE];
+	u8 essid_len;
+	u16 rates_mask;
+
+	u32 power_mode;
+	u32 antenna;
+	u8 bssid[ETH_ALEN];
+	u16 rts_threshold;
+	u8 mac_addr[ETH_ALEN];
+
+	/*station table variables */
+	spinlock_t sta_lock;
+	int num_stations;
+	struct iwl_station_entry stations[IWL_STATION_COUNT];
+
+	/* Indication if ieee80211_ops->open has been called */
+	int is_open;
+
+	u8 mac80211_registered;
+	int is_abg;
+
+	u32 notif_missed_beacons;
+
+	/* Rx'd packet timing information */
+	u32 last_beacon_time;
+	u64 last_tsf;
+
+	/* Duplicate packet detection */
+	u16 last_seq_num;
+	u16 last_frag_num;
+	unsigned long last_packet_time;
+	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
+
+	/* eeprom */
+	struct iwl_eeprom eeprom;
+
+	int iw_mode;
+
+	struct sk_buff *ibss_beacon;
+
+	/* Last Rx'd beacon timestamp */
+	u32 timestamp0;
+	u32 timestamp1;
+	u16 beacon_int;
+	struct iwl_driver_hw_info hw_setting;
+	int interface_id;
+
+	/* Current association information needed to configure the
+	 * hardware */
+	u16 assoc_id;
+	u16 assoc_capability;
+	u8 ps_mode;
+
+#ifdef CONFIG_IWLWIFI_QOS
+	struct iwl_qos_info qos_data;
+#endif /*CONFIG_IWLWIFI_QOS */
+
+	struct workqueue_struct *workqueue;
+
+	struct work_struct up;
+	struct work_struct restart;
+	struct work_struct calibrated_work;
+	struct work_struct scan_completed;
+	struct work_struct rx_replenish;
+	struct work_struct rf_kill;
+	struct work_struct abort_scan;
+	struct work_struct update_link_led;
+	struct work_struct auth_work;
+	struct work_struct report_work;
+	struct work_struct request_scan;
+	struct work_struct beacon_update;
+
+	struct tasklet_struct irq_tasklet;
+
+	struct delayed_work init_alive_start;
+	struct delayed_work alive_start;
+	struct delayed_work activity_timer;
+	struct delayed_work thermal_periodic;
+	struct delayed_work gather_stats;
+	struct delayed_work scan_check;
+	struct delayed_work post_associate;
+
+#define IWL_DEFAULT_TX_POWER 0x0F
+	s8 user_txpower_limit;
+	s8 max_channel_txpower_limit;
+	u32 cck_power_index_compensation;
+
+#ifdef CONFIG_PM
+	u32 pm_state[16];
+#endif
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	/* debugging info */
+	u32 framecnt_to_us;
+	atomic_t restrict_refcnt;
+#endif
+
+	struct work_struct txpower_work;
+#ifdef CONFIG_IWLWIFI_SENSITIVITY
+	struct work_struct sensitivity_work;
+#endif
+	struct work_struct statistics_work;
+	struct timer_list statistics_periodic;
+
+#ifdef CONFIG_IWLWIFI_HT_AGG
+	struct work_struct agg_work;
+#endif
+};				/*iwl_priv */
+
+#include "iwl-4965-io.h"
+
+static inline int iwl_is_associated(struct iwl_priv *priv)
+{
+	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+}
+
 #endif				/* __iwl_4965_h__ */
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-12 11:14:07.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-10-12 12:06:37.000000000 +0200
@@ -58,9 +58,6 @@
 
 #include <asm/div64.h>
 
-#define IWL 3945
-
-#include "iwlwifi.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 
@@ -88,7 +85,7 @@ int iwl_param_queues_num = IWL_MAX_NUM_Q
 
 /*
  * module name, copyright, version, etc.
- * NOTE: DRV_NAME is defined in iwlwifi.h for use by iwl-debug.h and printk
+ * NOTE: DRV_NAME is defined in iw-3945.h for use by iwl-debug.h and printk
  */
 
 #define DRV_DESCRIPTION	\
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-12 11:15:31.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-12 12:06:37.000000000 +0200
@@ -58,9 +58,6 @@
 
 #include <asm/div64.h>
 
-#define IWL 4965
-
-#include "iwlwifi.h"
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
@@ -88,7 +85,7 @@ int iwl_param_queues_num = IWL_MAX_NUM_Q
 
 /*
  * module name, copyright, version, etc.
- * NOTE: DRV_NAME is defined in iwlwifi.h for use by iwl-debug.h and printk
+ * NOTE: DRV_NAME is defined in iwl-4965.h for use by iwl-debug.h and printk
  */
 
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link 4965AGN driver for Linux"
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwlwifi.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwlwifi.h	2007-10-12 11:10:35.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,706 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2007 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __iwlwifi_h__
-#define __iwlwifi_h__
-
-#include <linux/pci.h> /* for struct pci_device_id */
-#include <linux/kernel.h>
-#include <net/ieee80211_radiotap.h>
-
-struct iwl_priv;
-
-/* Hardware specific file defines the PCI IDs table for that hardware module */
-extern struct pci_device_id iwl_hw_card_ids[];
-
-#if IWL == 3945
-
-#define DRV_NAME	"iwl3945"
-#include "iwl-hw.h"
-#include "iwl-3945-hw.h"
-
-#elif IWL == 4965
-
-#define DRV_NAME        "iwl4965"
-#include "iwl-hw.h"
-#include "iwl-4965-hw.h"
-
-#endif
-
-#include "iwl-prph.h"
-
-/*
- * Driver implementation data structures, constants, inline
- * functions
- *
- * NOTE:  DO NOT PUT HARDWARE/UCODE SPECIFIC DECLRATIONS HERE
- *
- * Hardware specific declrations go into iwl-*hw.h
- *
- */
-
-#include "iwl-debug.h"
-
-/* Default noise level to report when noise measurement is not available.
- *   This may be because we're:
- *   1)  Not associated (4965, no beacon statistics being sent to driver)
- *   2)  Scanning (noise measurement does not apply to associated channel)
- *   3)  Receiving CCK (3945 delivers noise info only for OFDM frames)
- * Use default noise value of -127 ... this is below the range of measurable
- *   Rx dBm for either 3945 or 4965, so it can indicate "unmeasurable" to user.
- *   Also, -127 works better than 0 when averaging frames with/without
- *   noise info (e.g. averaging might be done in app); measured dBm values are
- *   always negative ... using a negative value as the default keeps all
- *   averages within an s8's (used in some apps) range of negative values. */
-#define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
-
-/* Module parameters accessible from iwl-*.c */
-extern int iwl_param_disable_hw_scan;
-extern int iwl_param_debug;
-extern int iwl_param_mode;
-extern int iwl_param_disable;
-extern int iwl_param_antenna;
-extern int iwl_param_hwcrypto;
-extern int iwl_param_queues_num;
-
-enum iwl_antenna {
-	IWL_ANTENNA_DIVERSITY,
-	IWL_ANTENNA_MAIN,
-	IWL_ANTENNA_AUX
-};
-
-/*
- * RTS threshold here is total size [2347] minus 4 FCS bytes
- * Per spec:
- *   a value of 0 means RTS on all data/management packets
- *   a value > max MSDU size means no RTS
- * else RTS for data/management frames where MPDU is larger
- *   than RTS value.
- */
-#define DEFAULT_RTS_THRESHOLD     2347U
-#define MIN_RTS_THRESHOLD         0U
-#define MAX_RTS_THRESHOLD         2347U
-#define MAX_MSDU_SIZE		  2304U
-#define MAX_MPDU_SIZE		  2346U
-#define DEFAULT_BEACON_INTERVAL   100U
-#define	DEFAULT_SHORT_RETRY_LIMIT 7U
-#define	DEFAULT_LONG_RETRY_LIMIT  4U
-
-struct iwl_rx_mem_buffer {
-	dma_addr_t dma_addr;
-	struct sk_buff *skb;
-	struct list_head list;
-};
-
-struct iwl_rt_rx_hdr {
-	struct ieee80211_radiotap_header rt_hdr;
-	__le64 rt_tsf;		/* TSF */
-	u8 rt_flags;		/* radiotap packet flags */
-	u8 rt_rate;		/* rate in 500kb/s */
-	__le16 rt_channelMHz;	/* channel in MHz */
-	__le16 rt_chbitmask;	/* channel bitfield */
-	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
-	s8 rt_dbmnoise;
-	u8 rt_antenna;		/* antenna number */
-	u8 payload[0];		/* payload... */
-} __attribute__ ((packed));
-
-struct iwl_rt_tx_hdr {
-	struct ieee80211_radiotap_header rt_hdr;
-	u8 rt_rate;		/* rate in 500kb/s */
-	__le16 rt_channel;	/* channel in mHz */
-	__le16 rt_chbitmask;	/* channel bitfield */
-	s8 rt_dbmsignal;	/* signal in dBm, kluged to signed */
-	u8 rt_antenna;		/* antenna number */
-	u8 payload[0];		/* payload... */
-} __attribute__ ((packed));
-
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues
- */
-struct iwl_queue {
-	int n_bd;              /* number of BDs in this queue */
-	int first_empty;       /* 1-st empty entry (index) host_w*/
-	int last_used;         /* last used entry (index) host_r*/
-	dma_addr_t dma_addr;   /* physical addr for BD's */
-	int n_window;	       /* safe queue window */
-	u32 id;
-	int low_mark;	       /* low watermark, resume queue if free
-				* space more than this */
-	int high_mark;         /* high watermark, stop queue if free
-				* space less than this */
-} __attribute__ ((packed));
-
-#define MAX_NUM_OF_TBS          (20)
-
-struct iwl_tx_info {
-	struct ieee80211_tx_status status;
-	struct sk_buff *skb[MAX_NUM_OF_TBS];
-};
-
-/**
- * struct iwl_tx_queue - Tx Queue for DMA
- * @need_update: need to update read/write index
- * @shed_retry: queue is HT AGG enabled
- *
- * Queue consists of circular buffer of BD's and required locking structures.
- */
-struct iwl_tx_queue {
-	struct iwl_queue q;
-	struct iwl_tfd_frame *bd;
-	struct iwl_cmd *cmd;
-	dma_addr_t dma_addr_cmd;
-	struct iwl_tx_info *txb;
-	int need_update;
-	int sched_retry;
-	int active;
-};
-
-#include "iwl-channel.h"
-
-#if IWL == 3945
-#include "iwl-3945-rs.h"
-#else
-#include "iwl-4965-rs.h"
-#endif
-
-#define IWL_TX_FIFO_AC0	0
-#define IWL_TX_FIFO_AC1	1
-#define IWL_TX_FIFO_AC2	2
-#define IWL_TX_FIFO_AC3	3
-#define IWL_TX_FIFO_HCCA_1	5
-#define IWL_TX_FIFO_HCCA_2	6
-#define IWL_TX_FIFO_NONE	7
-
-/* Minimum number of queues. MAX_NUM is defined in hw specific files */
-#define IWL_MIN_NUM_QUEUES	4
-
-/* Power management (not Tx power) structures */
-
-struct iwl_power_vec_entry {
-	struct iwl_powertable_cmd cmd;
-	u8 no_dtim;
-};
-#define IWL_POWER_RANGE_0  (0)
-#define IWL_POWER_RANGE_1  (1)
-
-#define IWL_POWER_MODE_CAM	0x00	/* Continuously Aware Mode, always on */
-#define IWL_POWER_INDEX_3	0x03
-#define IWL_POWER_INDEX_5	0x05
-#define IWL_POWER_AC		0x06
-#define IWL_POWER_BATTERY	0x07
-#define IWL_POWER_LIMIT		0x07
-#define IWL_POWER_MASK		0x0F
-#define IWL_POWER_ENABLED	0x10
-#define IWL_POWER_LEVEL(x)	((x) & IWL_POWER_MASK)
-
-struct iwl_power_mgr {
-	spinlock_t lock;
-	struct iwl_power_vec_entry pwr_range_0[IWL_POWER_AC];
-	struct iwl_power_vec_entry pwr_range_1[IWL_POWER_AC];
-	u8 active_index;
-	u32 dtim_val;
-};
-
-#define IEEE80211_DATA_LEN              2304
-#define IEEE80211_4ADDR_LEN             30
-#define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
-#define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
-
-struct iwl_frame {
-	union {
-		struct ieee80211_hdr frame;
-		struct iwl_tx_beacon_cmd beacon;
-		u8 raw[IEEE80211_FRAME_LEN];
-		u8 cmd[360];
-	} u;
-	struct list_head list;
-};
-
-#define SEQ_TO_QUEUE(x)  ((x >> 8) & 0xbf)
-#define QUEUE_TO_SEQ(x)  ((x & 0xbf) << 8)
-#define SEQ_TO_INDEX(x) (x & 0xff)
-#define INDEX_TO_SEQ(x) (x & 0xff)
-#define SEQ_HUGE_FRAME  (0x4000)
-#define SEQ_RX_FRAME    __constant_cpu_to_le16(0x8000)
-#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
-#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
-#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
-
-enum {
-	/* CMD_SIZE_NORMAL = 0, */
-	CMD_SIZE_HUGE = (1 << 0),
-	/* CMD_SYNC = 0, */
-	CMD_ASYNC = (1 << 1),
-	/* CMD_NO_SKB = 0, */
-	CMD_WANT_SKB = (1 << 2),
-};
-
-struct iwl_cmd;
-struct iwl_priv;
-
-struct iwl_cmd_meta {
-	struct iwl_cmd_meta *source;
-	union {
-		struct sk_buff *skb;
-		int (*callback)(struct iwl_priv *priv,
-				struct iwl_cmd *cmd, struct sk_buff *skb);
-	} __attribute__ ((packed)) u;
-
-	/* The CMD_SIZE_HUGE flag bit indicates that the command
-	 * structure is stored at the end of the shared queue memory. */
-	u32 flags;
-
-} __attribute__ ((packed));
-
-struct iwl_cmd {
-	struct iwl_cmd_meta meta;
-	struct iwl_cmd_header hdr;
-	union {
-		struct iwl_addsta_cmd addsta;
-		struct iwl_led_cmd led;
-		u32 flags;
-		u8 val8;
-		u16 val16;
-		u32 val32;
-		struct iwl_bt_cmd bt;
-		struct iwl_rxon_time_cmd rxon_time;
-		struct iwl_powertable_cmd powertable;
-		struct iwl_qosparam_cmd qosparam;
-		struct iwl_tx_cmd tx;
-		struct iwl_tx_beacon_cmd tx_beacon;
-		struct iwl_rxon_assoc_cmd rxon_assoc;
-		u8 *indirect;
-		u8 payload[360];
-	} __attribute__ ((packed)) cmd;
-} __attribute__ ((packed));
-
-struct iwl_host_cmd {
-	u8 id;
-	u16 len;
-	struct iwl_cmd_meta meta;
-	const void *data;
-};
-
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
-			      sizeof(struct iwl_cmd_meta))
-
-/*
- * RX related structures and functions
- */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
-
-#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
-#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
-#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
-
-/**
- * struct iwl_rx_queue - Rx queue
- * @processed: Internal index to last handled Rx packet
- * @read: Shared index to newest available Rx buffer
- * @write: Shared index to oldest written Rx packet
- * @free_count: Number of pre-allocated buffers in rx_free
- * @rx_free: list of free SKBs for use
- * @rx_used: List of Rx buffers with no SKB
- * @need_update: flag to indicate we need to update read/write index
- *
- * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
- */
-struct iwl_rx_queue {
-	__le32 *bd;
-	dma_addr_t dma_addr;
-	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
-	u32 processed;
-	u32 read;
-	u32 write;
-	u32 free_count;
-	struct list_head rx_free;
-	struct list_head rx_used;
-	int need_update;
-	spinlock_t lock;
-};
-
-#define IWL_SUPPORTED_RATES_IE_LEN         8
-
-#define SCAN_INTERVAL 100
-
-#define MAX_A_CHANNELS  252
-#define MIN_A_CHANNELS  7
-
-#define MAX_B_CHANNELS  14
-#define MIN_B_CHANNELS  1
-
-#define STATUS_HCMD_ACTIVE	0	/* host command in progress */
-#define STATUS_INT_ENABLED	1
-#define STATUS_RF_KILL_HW	2
-#define STATUS_RF_KILL_SW	3
-#define STATUS_INIT		4
-#define STATUS_ALIVE		5
-#define STATUS_READY		6
-#define STATUS_TEMPERATURE	7
-#define STATUS_GEO_CONFIGURED	8
-#define STATUS_EXIT_PENDING	9
-#define STATUS_IN_SUSPEND	10
-#define STATUS_STATISTICS	11
-#define STATUS_SCANNING		12
-#define STATUS_SCAN_ABORTING	13
-#define STATUS_SCAN_HW		14
-#define STATUS_POWER_PMI	15
-#define STATUS_FW_ERROR		16
-
-#define MAX_TID_COUNT        9
-
-#define IWL_INVALID_RATE     0xFF
-#define IWL_INVALID_VALUE    -1
-
-#if IWL == 4965
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
-struct iwl_ht_agg {
-	u16 txq_id;
-	u16 frame_count;
-	u16 wait_for_ba;
-	u16 start_idx;
-	u32 bitmap0;
-	u32 bitmap1;
-	u32 rate_n_flags;
-};
-#endif /* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
-#endif
-
-struct iwl_tid_data {
-	u16 seq_number;
-#if IWL == 4965
-#ifdef CONFIG_IWLWIFI_HT
-#ifdef CONFIG_IWLWIFI_HT_AGG
-	struct iwl_ht_agg agg;
-#endif	/* CONFIG_IWLWIFI_HT_AGG */
-#endif /* CONFIG_IWLWIFI_HT */
-#endif
-};
-
-struct iwl_hw_key {
-	enum ieee80211_key_alg alg;
-	int keylen;
-	u8 key[32];
-};
-
-union iwl_ht_rate_supp {
-	u16 rates;
-	struct {
-		u8 siso_rate;
-		u8 mimo_rate;
-	};
-};
-
-#ifdef CONFIG_IWLWIFI_HT
-#define CFG_HT_RX_AMPDU_FACTOR_DEF  (0x3)
-#define HT_IE_MAX_AMSDU_SIZE_4K     (0)
-#define CFG_HT_MPDU_DENSITY_2USEC   (0x5)
-#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_2USEC
-
-struct sta_ht_info {
-	u8 is_ht;
-	u16 rx_mimo_ps_mode;
-	u16 tx_mimo_ps_mode;
-	u16 control_channel;
-	u8 max_amsdu_size;
-	u8 ampdu_factor;
-	u8 mpdu_density;
-	u8 operating_mode;
-	u8 supported_chan_width;
-	u8 extension_chan_offset;
-	u8 is_green_field;
-	u8 sgf;
-	u8 supp_rates[16];
-	u8 tx_chan_width;
-	u8 chan_width_cap;
-};
-#endif				/*CONFIG_IWLWIFI_HT */
-
-#ifdef CONFIG_IWLWIFI_QOS
-
-union iwl_qos_capabity {
-	struct {
-		u8 edca_count:4;	/* bit 0-3 */
-		u8 q_ack:1;		/* bit 4 */
-		u8 queue_request:1;	/* bit 5 */
-		u8 txop_request:1;	/* bit 6 */
-		u8 reserved:1;		/* bit 7 */
-	} q_AP;
-	struct {
-		u8 acvo_APSD:1;		/* bit 0 */
-		u8 acvi_APSD:1;		/* bit 1 */
-		u8 ac_bk_APSD:1;	/* bit 2 */
-		u8 ac_be_APSD:1;	/* bit 3 */
-		u8 q_ack:1;		/* bit 4 */
-		u8 max_len:2;		/* bit 5-6 */
-		u8 more_data_ack:1;	/* bit 7 */
-	} q_STA;
-	u8 val;
-};
-
-/* QoS sturctures */
-struct iwl_qos_info {
-	int qos_enable;
-	int qos_active;
-	union iwl_qos_capabity qos_cap;
-	struct iwl_qosparam_cmd def_qos_parm;
-};
-#endif /*CONFIG_IWLWIFI_QOS */
-
-#define STA_PS_STATUS_WAKE             0
-#define STA_PS_STATUS_SLEEP            1
-
-struct iwl_station_entry {
-	struct iwl_addsta_cmd sta;
-	struct iwl_tid_data tid[MAX_TID_COUNT];
-#if IWL == 3945
-	union {
-		struct {
-			u8 rate;
-			u8 flags;
-		} s;
-		u16 rate_n_flags;
-	} current_rate;
-#endif
-	u8 used;
-	u8 ps_status;
-	struct iwl_hw_key keyinfo;
-};
-
-/* one for each uCode image (inst/data, boot/init/runtime) */
-struct fw_image_desc {
-	void *v_addr;		/* access by driver */
-	dma_addr_t p_addr;	/* access by card's busmaster DMA */
-	u32 len;		/* bytes */
-};
-
-/* uCode file layout */
-struct iwl_ucode {
-	__le32 ver;		/* major/minor/subminor */
-	__le32 inst_size;	/* bytes of runtime instructions */
-	__le32 data_size;	/* bytes of runtime data */
-	__le32 init_size;	/* bytes of initialization instructions */
-	__le32 init_data_size;	/* bytes of initialization data */
-	__le32 boot_size;	/* bytes of bootstrap instructions */
-	u8 data[0];		/* data in same order as "size" elements */
-};
-
-#define IWL_IBSS_MAC_HASH_SIZE 32
-
-struct iwl_ibss_seq {
-	u8 mac[ETH_ALEN];
-	u16 seq_num;
-	u16 frag_num;
-	unsigned long packet_time;
-	struct list_head list;
-};
-
-struct iwl_driver_hw_info {
-	u16 max_txq_num;
-	u16 ac_queue_count;
-	u32 rx_buffer_size;
-	u16 tx_cmd_len;
-	u16 max_rxq_size;
-	u16 max_rxq_log;
-	u32 cck_flag;
-	u8  max_stations;
-	u8  bcast_sta_id;
-	void *shared_virt;
-	dma_addr_t shared_phys;
-};
-
-
-#define STA_FLG_RTS_MIMO_PROT_MSK	__constant_cpu_to_le32(1 << 17)
-#define STA_FLG_AGG_MPDU_8US_MSK	__constant_cpu_to_le32(1 << 18)
-#define STA_FLG_MAX_AGG_SIZE_POS	(19)
-#define STA_FLG_MAX_AGG_SIZE_MSK	__constant_cpu_to_le32(3 << 19)
-#define STA_FLG_FAT_EN_MSK		__constant_cpu_to_le32(1 << 21)
-#define STA_FLG_MIMO_DIS_MSK		__constant_cpu_to_le32(1 << 22)
-#define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
-#define STA_FLG_AGG_MPDU_DENSITY_MSK	__constant_cpu_to_le32(7 << 23)
-#define HT_SHORT_GI_20MHZ_ONLY          (1 << 0)
-#define HT_SHORT_GI_40MHZ_ONLY          (1 << 1)
-
-
-#include "iwl-priv.h"
-
-/* Requires full declaration of iwl_priv before including */
-#include "iwl-io.h"
-
-#define IWL_RX_HDR(x) ((struct iwl_rx_frame_hdr *)(\
-		       x->u.rx_frame.stats.payload + \
-		       x->u.rx_frame.stats.phy_count))
-#define IWL_RX_END(x) ((struct iwl_rx_frame_end *)(\
-		       IWL_RX_HDR(x)->payload + \
-		       le16_to_cpu(IWL_RX_HDR(x)->len)))
-#define IWL_RX_STATS(x) (&x->u.rx_frame.stats)
-#define IWL_RX_DATA(x) (IWL_RX_HDR(x)->payload)
-
-
-/******************************************************************************
- *
- * Functions implemented in iwl-base.c which are forward declared here
- * for use by iwl-*.c
- *
- *****************************************************************************/
-struct iwl_addsta_cmd;
-extern int iwl_send_add_station(struct iwl_priv *priv,
-				struct iwl_addsta_cmd *sta, u8 flags);
-extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid,
-			  int is_ap, u8 flags);
-extern int iwl_is_network_packet(struct iwl_priv *priv,
-				 struct ieee80211_hdr *header);
-extern int iwl_power_init_handle(struct iwl_priv *priv);
-extern int iwl_eeprom_init(struct iwl_priv *priv);
-#ifdef CONFIG_IWLWIFI_DEBUG
-extern void iwl_report_frame(struct iwl_priv *priv,
-			     struct iwl_rx_packet *pkt,
-			     struct ieee80211_hdr *header, int group100);
-#else
-static inline void iwl_report_frame(struct iwl_priv *priv,
-				    struct iwl_rx_packet *pkt,
-				    struct ieee80211_hdr *header,
-				    int group100) {}
-#endif
-extern void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb,
-					   void *data, short len,
-					   struct ieee80211_rx_status *stats,
-					   u16 phy_flags);
-extern int is_duplicate_packet(struct iwl_priv *priv, struct ieee80211_hdr
-			       *header);
-extern int iwl_rx_queue_alloc(struct iwl_priv *priv);
-extern void iwl_rx_queue_reset(struct iwl_priv *priv,
-			       struct iwl_rx_queue *rxq);
-extern int iwl_calc_db_from_ratio(int sig_ratio);
-extern int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm);
-extern int iwl_tx_queue_init(struct iwl_priv *priv,
-			     struct iwl_tx_queue *txq, int count, u32 id);
-extern void iwl_rx_replenish(void *data);
-extern void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-extern int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
-			    const void *data);
-extern int __must_check iwl_send_cmd(struct iwl_priv *priv,
-		struct iwl_host_cmd *cmd);
-extern unsigned int iwl_fill_beacon_frame(struct iwl_priv *priv,
-					struct ieee80211_hdr *hdr,
-					const u8 *dest, int left);
-extern int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
-					 struct iwl_rx_queue *q);
-extern int iwl_send_statistics_request(struct iwl_priv *priv);
-extern void iwl_set_decrypted_flag(struct iwl_priv *priv, struct sk_buff *skb,
-				   u32 decrypt_res,
-				   struct ieee80211_rx_status *stats);
-#if IWL == 4965
-extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
-#endif
-
-extern const u8 BROADCAST_ADDR[ETH_ALEN];
-
-/*
- * Currently used by iwl-3945-rs... look at restructuring so that it doesn't
- * call this... todo... fix that.
-*/
-extern u8 iwl_sync_station(struct iwl_priv *priv, int sta_id,
-			   u16 tx_rate, u8 flags);
-
-static inline int iwl_is_associated(struct iwl_priv *priv)
-{
-	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
-}
-
-/******************************************************************************
- *
- * Functions implemented in iwl-[34]*.c which are forward declared here
- * for use by iwl-base.c
- *
- * NOTE:  The implementation of these functions are hardware specific
- * which is why they are in the hardware specific files (vs. iwl-base.c)
- *
- * Naming convention --
- * iwl_         <-- Its part of iwlwifi (should be changed to iwl_)
- * iwl_hw_      <-- Hardware specific (implemented in iwl-XXXX.c by all HW)
- * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
- * iwl_bg_      <-- Called from work queue context
- * iwl_mac_     <-- mac80211 callback
- *
- ****************************************************************************/
-extern void iwl_hw_rx_handler_setup(struct iwl_priv *priv);
-extern void iwl_hw_setup_deferred_work(struct iwl_priv *priv);
-extern void iwl_hw_cancel_deferred_work(struct iwl_priv *priv);
-extern int iwl_hw_rxq_stop(struct iwl_priv *priv);
-extern int iwl_hw_set_hw_setting(struct iwl_priv *priv);
-extern int iwl_hw_nic_init(struct iwl_priv *priv);
-extern int iwl_hw_nic_stop_master(struct iwl_priv *priv);
-extern void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
-extern void iwl_hw_txq_ctx_stop(struct iwl_priv *priv);
-extern int iwl_hw_nic_reset(struct iwl_priv *priv);
-extern int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
-					dma_addr_t addr, u16 len);
-extern int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-extern int iwl_hw_get_temperature(struct iwl_priv *priv);
-extern int iwl_hw_tx_queue_init(struct iwl_priv *priv,
-				struct iwl_tx_queue *txq);
-extern unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-				 struct iwl_frame *frame, u8 rate);
-extern int iwl_hw_get_rx_read(struct iwl_priv *priv);
-extern void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
-				     struct iwl_cmd *cmd,
-				     struct ieee80211_tx_control *ctrl,
-				     struct ieee80211_hdr *hdr,
-				     int sta_id, int tx_id);
-extern int iwl_hw_reg_send_txpower(struct iwl_priv *priv);
-extern int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
-extern void iwl_hw_rx_statistics(struct iwl_priv *priv,
-				 struct iwl_rx_mem_buffer *rxb);
-extern void iwl_disable_events(struct iwl_priv *priv);
-extern int iwl4965_get_temperature(const struct iwl_priv *priv);
-
-/**
- * iwl_hw_find_station - Find station id for a given BSSID
- * @bssid: MAC address of station ID to find
- *
- * NOTE:  This should not be hardware specific but the code has
- * not yet been merged into a single common layer for managing the
- * station tables.
- */
-extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
-
-extern int iwl_hw_channel_switch(struct iwl_priv *priv, u16 channel);
-#if IWL == 4965
-extern int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
-#endif
-#endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-debug.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-debug.h	2007-10-12 12:06:37.000000000 +0200
@@ -0,0 +1,152 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2007 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#ifndef __iwl_debug_h__
+#define __iwl_debug_h__
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+extern u32 iwl_debug_level;
+#define IWL_DEBUG(level, fmt, args...) \
+do { if (iwl_debug_level & (level)) \
+  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
+	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+
+#define IWL_DEBUG_LIMIT(level, fmt, args...) \
+do { if ((iwl_debug_level & (level)) && net_ratelimit()) \
+  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
+	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+#else
+static inline void IWL_DEBUG(int level, const char *fmt, ...)
+{
+}
+static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
+{
+}
+#endif				/* CONFIG_IWLWIFI_DEBUG */
+
+/*
+ * To use the debug system;
+ *
+ * If you are defining a new debug classification, simply add it to the #define
+ * list here in the form of:
+ *
+ * #define IWL_DL_xxxx VALUE
+ *
+ * shifting value to the left one bit from the previous entry.  xxxx should be
+ * the name of the classification (for example, WEP)
+ *
+ * You then need to either add a IWL_xxxx_DEBUG() macro definition for your
+ * classification, or use IWL_DEBUG(IWL_DL_xxxx, ...) whenever you want
+ * to send output to that classification.
+ *
+ * To add your debug level to the list of levels seen when you perform
+ *
+ * % cat /proc/net/iwl/debug_level
+ *
+ * you simply need to add your entry to the iwl_debug_levels array.
+ *
+ * If you do not see debug_level in /proc/net/iwl then you do not have
+ * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
+ *
+ */
+
+#define IWL_DL_INFO          (1<<0)
+#define IWL_DL_MAC80211      (1<<1)
+#define IWL_DL_HOST_COMMAND  (1<<2)
+#define IWL_DL_STATE         (1<<3)
+
+#define IWL_DL_RADIO         (1<<7)
+#define IWL_DL_POWER         (1<<8)
+#define IWL_DL_TEMP          (1<<9)
+
+#define IWL_DL_NOTIF         (1<<10)
+#define IWL_DL_SCAN          (1<<11)
+#define IWL_DL_ASSOC         (1<<12)
+#define IWL_DL_DROP          (1<<13)
+
+#define IWL_DL_TXPOWER       (1<<14)
+
+#define IWL_DL_AP            (1<<15)
+
+#define IWL_DL_FW            (1<<16)
+#define IWL_DL_RF_KILL       (1<<17)
+#define IWL_DL_FW_ERRORS     (1<<18)
+
+#define IWL_DL_LED           (1<<19)
+
+#define IWL_DL_RATE          (1<<20)
+
+#define IWL_DL_CALIB         (1<<21)
+#define IWL_DL_WEP           (1<<22)
+#define IWL_DL_TX            (1<<23)
+#define IWL_DL_RX            (1<<24)
+#define IWL_DL_ISR           (1<<25)
+#define IWL_DL_HT            (1<<26)
+#define IWL_DL_IO            (1<<27)
+#define IWL_DL_11H           (1<<28)
+
+#define IWL_DL_STATS         (1<<29)
+#define IWL_DL_TX_REPLY      (1<<30)
+#define IWL_DL_QOS           (1<<31)
+
+#define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
+#define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
+#define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
+
+#define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
+#define IWL_DEBUG_TEMP(f, a...)   IWL_DEBUG(IWL_DL_TEMP, f, ## a)
+#define IWL_DEBUG_SCAN(f, a...)   IWL_DEBUG(IWL_DL_SCAN, f, ## a)
+#define IWL_DEBUG_RX(f, a...)     IWL_DEBUG(IWL_DL_RX, f, ## a)
+#define IWL_DEBUG_TX(f, a...)     IWL_DEBUG(IWL_DL_TX, f, ## a)
+#define IWL_DEBUG_ISR(f, a...)    IWL_DEBUG(IWL_DL_ISR, f, ## a)
+#define IWL_DEBUG_LED(f, a...) IWL_DEBUG(IWL_DL_LED, f, ## a)
+#define IWL_DEBUG_WEP(f, a...)    IWL_DEBUG(IWL_DL_WEP, f, ## a)
+#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HOST_COMMAND, f, ## a)
+#define IWL_DEBUG_CALIB(f, a...) IWL_DEBUG(IWL_DL_CALIB, f, ## a)
+#define IWL_DEBUG_FW(f, a...) IWL_DEBUG(IWL_DL_FW, f, ## a)
+#define IWL_DEBUG_RF_KILL(f, a...) IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
+#define IWL_DEBUG_DROP(f, a...) IWL_DEBUG(IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_DROP_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_AP(f, a...) IWL_DEBUG(IWL_DL_AP, f, ## a)
+#define IWL_DEBUG_TXPOWER(f, a...) IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
+#define IWL_DEBUG_IO(f, a...) IWL_DEBUG(IWL_DL_IO, f, ## a)
+#define IWL_DEBUG_RATE(f, a...) IWL_DEBUG(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_RATE_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_NOTIF(f, a...) IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
+#define IWL_DEBUG_ASSOC(f, a...) IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_ASSOC_LIMIT(f, a...) \
+	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
+#define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
+#define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
+#define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
+#define IWL_DEBUG_POWER(f, a...)  IWL_DEBUG(IWL_DL_POWER, f, ## a)
+#define IWL_DEBUG_11H(f, a...)  IWL_DEBUG(IWL_DL_11H, f, ## a)
+
+#endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-3945-hw.h	2007-10-12 11:24:17.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-hw.h	2007-10-12 11:37:38.000000000 +0200
@@ -64,6 +64,2021 @@
 #ifndef __iwl_3945_hw__
 #define __iwl_3945_hw__
 
+/* uCode queue management definitions */
+#define IWL_CMD_QUEUE_NUM       4
+#define IWL_CMD_FIFO_NUM        4
+#define IWL_BACK_QUEUE_FIRST_ID 7
+
+/* Tx rates */
+#define IWL_CCK_RATES 4
+#define IWL_OFDM_RATES 8
+#define IWL_HT_RATES 0
+
+#define IWL_MAX_RATES  (IWL_CCK_RATES+IWL_OFDM_RATES+IWL_HT_RATES)
+
+/* Time constants */
+#define SHORT_SLOT_TIME 9
+#define LONG_SLOT_TIME 20
+
+/* RSSI to dBm */
+#define IWL_RSSI_OFFSET	95
+
+#define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
+#define IWL_EEPROM_ACCESS_DELAY		10   /* uSec */
+/* EEPROM field values */
+#define ANTENNA_SWITCH_NORMAL     0
+#define ANTENNA_SWITCH_INVERSE    1
+
+enum {
+	EEPROM_CHANNEL_VALID = (1 << 0),	/* usable for this SKU/geo */
+	EEPROM_CHANNEL_IBSS = (1 << 1),	/* usable as an IBSS channel */
+	/* Bit 2 Reserved */
+	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
+	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
+	EEPROM_CHANNEL_WIDE = (1 << 5),
+	EEPROM_CHANNEL_NARROW = (1 << 6),
+	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
+};
+
+/* EEPROM field lengths */
+#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
+
+/* EEPROM field lengths */
+#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
+#define EEPROM_REGULATORY_SKU_ID_LENGTH                 4
+#define EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH         14
+#define EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH         13
+#define EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH         12
+#define EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH         11
+#define EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH         6
+
+#define EEPROM_REGULATORY_CHANNELS_LENGTH ( \
+	EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH)
+
+#define EEPROM_REGULATORY_NUMBER_OF_BANDS               5
+
+/* SKU Capabilities */
+#define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
+#define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
+#define EEPROM_SKU_CAP_OP_MODE_MRC                      (1 << 7)
+
+/* *regulatory* channel data from eeprom, one for each channel */
+struct iwl_eeprom_channel {
+	u8 flags;		/* flags copied from EEPROM */
+	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
+} __attribute__ ((packed));
+
+/*
+ * Mapping of a Tx power level, at factory calibration temperature,
+ *   to a radio/DSP gain table index.
+ * One for each of 5 "sample" power levels in each band.
+ * v_det is measured at the factory, using the 3945's built-in power amplifier
+ *   (PA) output voltage detector.  This same detector is used during Tx of
+ *   long packets in normal operation to provide feedback as to proper output
+ *   level.
+ * Data copied from EEPROM.
+ */
+struct iwl_eeprom_txpower_sample {
+	u8 gain_index;		/* index into power (gain) setup table ... */
+	s8 power;		/* ... for this pwr level for this chnl group */
+	u16 v_det;		/* PA output voltage */
+} __attribute__ ((packed));
+
+/*
+ * Mappings of Tx power levels -> nominal radio/DSP gain table indexes.
+ * One for each channel group (a.k.a. "band") (1 for BG, 4 for A).
+ * Tx power setup code interpolates between the 5 "sample" power levels
+ *    to determine the nominal setup for a requested power level.
+ * Data copied from EEPROM.
+ * DO NOT ALTER THIS STRUCTURE!!!
+ */
+struct iwl_eeprom_txpower_group {
+	struct iwl_eeprom_txpower_sample samples[5];	/* 5 power levels */
+	s32 a, b, c, d, e;	/* coefficients for voltage->power
+				 * formula (signed) */
+	s32 Fa, Fb, Fc, Fd, Fe;	/* these modify coeffs based on
+					 * frequency (signed) */
+	s8 saturation_power;	/* highest power possible by h/w in this
+				 * band */
+	u8 group_channel;	/* "representative" channel # in this band */
+	s16 temperature;	/* h/w temperature at factory calib this band
+				 * (signed) */
+} __attribute__ ((packed));
+
+/*
+ * Temperature-based Tx-power compensation data, not band-specific.
+ * These coefficients are use to modify a/b/c/d/e coeffs based on
+ *   difference between current temperature and factory calib temperature.
+ * Data copied from EEPROM.
+ */
+struct iwl_eeprom_temperature_corr {
+	u32 Ta;
+	u32 Tb;
+	u32 Tc;
+	u32 Td;
+	u32 Te;
+} __attribute__ ((packed));
+
+struct iwl_eeprom {
+	u8 reserved0[16];
+#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
+	u16 device_id;	/* abs.ofs: 16 */
+	u8 reserved1[2];
+#define EEPROM_PMC                          (2*0x0A)	/* 2 bytes */
+	u16 pmc;		/* abs.ofs: 20 */
+	u8 reserved2[20];
+#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
+	u8 mac_address[6];	/* abs.ofs: 42 */
+	u8 reserved3[58];
+#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
+	u16 board_revision;	/* abs.ofs: 106 */
+	u8 reserved4[11];
+#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
+	u8 board_pba_number[9];	/* abs.ofs: 119 */
+	u8 reserved5[8];
+#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
+	u16 version;		/* abs.ofs: 136 */
+#define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
+	u8 sku_cap;		/* abs.ofs: 138 */
+#define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
+	u8 leds_mode;		/* abs.ofs: 139 */
+#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
+	u16 oem_mode;
+#define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
+	u16 wowlan_mode;	/* abs.ofs: 142 */
+#define EEPROM_LEDS_TIME_INTERVAL           (2*0x48)	/* 2  bytes */
+	u16 leds_time_interval;	/* abs.ofs: 144 */
+#define EEPROM_LEDS_OFF_TIME                (2*0x49)	/* 1  bytes */
+	u8 leds_off_time;	/* abs.ofs: 146 */
+#define EEPROM_LEDS_ON_TIME                 (2*0x49+1)	/* 1  bytes */
+	u8 leds_on_time;	/* abs.ofs: 147 */
+#define EEPROM_ALMGOR_M_VERSION             (2*0x4A)	/* 1  bytes */
+	u8 almgor_m_version;	/* abs.ofs: 148 */
+#define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
+	u8 antenna_switch_type;	/* abs.ofs: 149 */
+	u8 reserved6[42];
+#define EEPROM_REGULATORY_SKU_ID            (2*0x60)	/* 4  bytes */
+	u8 sku_id[4];		/* abs.ofs: 192 */
+#define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
+	u16 band_1_count;	/* abs.ofs: 196 */
+#define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
+	struct iwl_eeprom_channel band_1_channels[14];	/* abs.ofs: 196 */
+#define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
+	u16 band_2_count;	/* abs.ofs: 226 */
+#define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
+	struct iwl_eeprom_channel band_2_channels[13];	/* abs.ofs: 228 */
+#define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
+	u16 band_3_count;	/* abs.ofs: 254 */
+#define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
+	struct iwl_eeprom_channel band_3_channels[12];	/* abs.ofs: 256 */
+#define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
+	u16 band_4_count;	/* abs.ofs: 280 */
+#define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
+	struct iwl_eeprom_channel band_4_channels[11];	/* abs.ofs: 282 */
+#define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
+	u16 band_5_count;	/* abs.ofs: 304 */
+#define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
+	struct iwl_eeprom_channel band_5_channels[6];	/* abs.ofs: 306 */
+
+	u8 reserved9[194];
+
+#define EEPROM_TXPOWER_CALIB_GROUP0 0x200
+#define EEPROM_TXPOWER_CALIB_GROUP1 0x240
+#define EEPROM_TXPOWER_CALIB_GROUP2 0x280
+#define EEPROM_TXPOWER_CALIB_GROUP3 0x2c0
+#define EEPROM_TXPOWER_CALIB_GROUP4 0x300
+#define IWL_NUM_TX_CALIB_GROUPS 5
+	struct iwl_eeprom_txpower_group groups[IWL_NUM_TX_CALIB_GROUPS];
+/* abs.ofs: 512 */
+#define EEPROM_CALIB_TEMPERATURE_CORRECT 0x340
+	struct iwl_eeprom_temperature_corr corrections;	/* abs.ofs: 832 */
+	u8 reserved16[172];	/* fill out to full 1024 byte block */
+} __attribute__ ((packed));
+
+#define IWL_EEPROM_IMAGE_SIZE 1024
+
+enum {
+	REPLY_ALIVE = 0x1,
+	REPLY_ERROR = 0x2,
+
+	/* RXON and QOS commands */
+	REPLY_RXON = 0x10,
+	REPLY_RXON_ASSOC = 0x11,
+	REPLY_QOS_PARAM = 0x13,
+	REPLY_RXON_TIMING = 0x14,
+
+	/* Multi-Station support */
+	REPLY_ADD_STA = 0x18,
+	REPLY_REMOVE_STA = 0x19,	/* not used */
+	REPLY_REMOVE_ALL_STA = 0x1a,	/* not used */
+
+	/* RX, TX, LEDs */
+	REPLY_3945_RX = 0x1b,		/* 3945 only */
+	REPLY_TX = 0x1c,
+	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
+	REPLY_LEDS_CMD = 0x48,
+	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* 4965 only */
+
+	/* 802.11h related */
+	RADAR_NOTIFICATION = 0x70,	/* not used */
+	REPLY_QUIET_CMD = 0x71,		/* not used */
+	REPLY_CHANNEL_SWITCH = 0x72,
+	CHANNEL_SWITCH_NOTIFICATION = 0x73,
+	REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74,
+	SPECTRUM_MEASURE_NOTIFICATION = 0x75,
+
+	/* Power Management */
+	POWER_TABLE_CMD = 0x77,
+	PM_SLEEP_NOTIFICATION = 0x7A,
+	PM_DEBUG_STATISTIC_NOTIFIC = 0x7B,
+
+	/* Scan commands and notifications */
+	REPLY_SCAN_CMD = 0x80,
+	REPLY_SCAN_ABORT_CMD = 0x81,
+	SCAN_START_NOTIFICATION = 0x82,
+	SCAN_RESULTS_NOTIFICATION = 0x83,
+	SCAN_COMPLETE_NOTIFICATION = 0x84,
+
+	/* IBSS/AP commands */
+	BEACON_NOTIFICATION = 0x90,
+	REPLY_TX_BEACON = 0x91,
+	WHO_IS_AWAKE_NOTIFICATION = 0x94,	/* not used */
+
+	/* Miscellaneous commands */
+	QUIET_NOTIFICATION = 0x96,		/* not used */
+	REPLY_TX_PWR_TABLE_CMD = 0x97,
+	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
+
+	/* BT config command */
+	REPLY_BT_CONFIG = 0x9b,
+
+	/* 4965 Statistics */
+	REPLY_STATISTICS_CMD = 0x9c,
+	STATISTICS_NOTIFICATION = 0x9d,
+
+	/* RF-KILL commands and notifications */
+	REPLY_CARD_STATE_CMD = 0xa0,
+	CARD_STATE_NOTIFICATION = 0xa1,
+
+	/* Missed beacons notification */
+	MISSED_BEACONS_NOTIFICATION = 0xa2,
+
+	REPLY_MAX = 0xff
+};
+
+/******************************************************************************
+ * (0)
+ * Header
+ *
+ *****************************************************************************/
+
+#define IWL_CMD_FAILED_MSK 0x40
+
+struct iwl_cmd_header {
+	u8 cmd;
+	u8 flags;
+	/* We have 15 LSB to use as we please (MSB indicates
+	 * a frame Rx'd from the HW).  We encode the following
+	 * information into the sequence field:
+	 *
+	 *  0:7    index in fifo
+	 *  8:13   fifo selection
+	 * 14:14   bit indicating if this packet references the 'extra'
+	 *         storage at the end of the memory queue
+	 * 15:15   (Rx indication)
+	 *
+	 */
+	__le16 sequence;
+
+	/* command data follows immediately */
+	u8 data[0];
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (0a)
+ * Alive and Error Commands & Responses:
+ *
+ *****************************************************************************/
+
+#define UCODE_VALID_OK	__constant_cpu_to_le32(0x1)
+#define INITIALIZE_SUBTYPE    (9)
+
+/*
+ * REPLY_ALIVE = 0x1 (response only, not a command)
+ */
+struct iwl_alive_resp {
+	u8 ucode_minor;
+	u8 ucode_major;
+	__le16 reserved1;
+	u8 sw_rev[8];
+	u8 ver_type;
+	u8 ver_subtype;
+	__le16 reserved2;
+	__le32 log_event_table_ptr;
+	__le32 error_event_table_ptr;
+	__le32 timestamp;
+	__le32 is_valid;
+} __attribute__ ((packed));
+
+struct iwl_init_alive_resp {
+	u8 ucode_minor;
+	u8 ucode_major;
+	__le16 reserved1;
+	u8 sw_rev[8];
+	u8 ver_type;
+	u8 ver_subtype;
+	__le16 reserved2;
+	__le32 log_event_table_ptr;
+	__le32 error_event_table_ptr;
+	__le32 timestamp;
+	__le32 is_valid;
+} __attribute__ ((packed));
+
+union tsf {
+	u8 byte[8];
+	__le16 word[4];
+	__le32 dw[2];
+};
+
+/*
+ * REPLY_ERROR = 0x2 (response only, not a command)
+ */
+struct iwl_error_resp {
+	__le32 error_type;
+	u8 cmd_id;
+	u8 reserved1;
+	__le16 bad_cmd_seq_num;
+	__le16 reserved2;
+	__le32 error_info;
+	union tsf timestamp;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (1)
+ * RXON Commands & Responses:
+ *
+ *****************************************************************************/
+
+/*
+ * Rx config defines & structure
+ */
+/* rx_config device types  */
+enum {
+	RXON_DEV_TYPE_AP = 1,
+	RXON_DEV_TYPE_ESS = 3,
+	RXON_DEV_TYPE_IBSS = 4,
+	RXON_DEV_TYPE_SNIFFER = 6,
+};
+
+/* rx_config flags */
+/* band & modulation selection */
+#define RXON_FLG_BAND_24G_MSK           __constant_cpu_to_le32(1 << 0)
+#define RXON_FLG_CCK_MSK                __constant_cpu_to_le32(1 << 1)
+/* auto detection enable */
+#define RXON_FLG_AUTO_DETECT_MSK        __constant_cpu_to_le32(1 << 2)
+/* TGg protection when tx */
+#define RXON_FLG_TGG_PROTECT_MSK        __constant_cpu_to_le32(1 << 3)
+/* cck short slot & preamble */
+#define RXON_FLG_SHORT_SLOT_MSK          __constant_cpu_to_le32(1 << 4)
+#define RXON_FLG_SHORT_PREAMBLE_MSK     __constant_cpu_to_le32(1 << 5)
+/* antenna selection */
+#define RXON_FLG_DIS_DIV_MSK            __constant_cpu_to_le32(1 << 7)
+#define RXON_FLG_ANT_SEL_MSK            __constant_cpu_to_le32(0x0f00)
+#define RXON_FLG_ANT_A_MSK              __constant_cpu_to_le32(1 << 8)
+#define RXON_FLG_ANT_B_MSK              __constant_cpu_to_le32(1 << 9)
+/* radar detection enable */
+#define RXON_FLG_RADAR_DETECT_MSK       __constant_cpu_to_le32(1 << 12)
+#define RXON_FLG_TGJ_NARROW_BAND_MSK    __constant_cpu_to_le32(1 << 13)
+/* rx response to host with 8-byte TSF
+* (according to ON_AIR deassertion) */
+#define RXON_FLG_TSF2HOST_MSK           __constant_cpu_to_le32(1 << 15)
+
+/* rx_config filter flags */
+/* accept all data frames */
+#define RXON_FILTER_PROMISC_MSK         __constant_cpu_to_le32(1 << 0)
+/* pass control & management to host */
+#define RXON_FILTER_CTL2HOST_MSK        __constant_cpu_to_le32(1 << 1)
+/* accept multi-cast */
+#define RXON_FILTER_ACCEPT_GRP_MSK      __constant_cpu_to_le32(1 << 2)
+/* don't decrypt uni-cast frames */
+#define RXON_FILTER_DIS_DECRYPT_MSK     __constant_cpu_to_le32(1 << 3)
+/* don't decrypt multi-cast frames */
+#define RXON_FILTER_DIS_GRP_DECRYPT_MSK __constant_cpu_to_le32(1 << 4)
+/* STA is associated */
+#define RXON_FILTER_ASSOC_MSK           __constant_cpu_to_le32(1 << 5)
+/* transfer to host non bssid beacons in associated state */
+#define RXON_FILTER_BCON_AWARE_MSK      __constant_cpu_to_le32(1 << 6)
+
+/*
+ * REPLY_RXON = 0x10 (command, has simple generic response)
+ */
+struct iwl_rxon_cmd {
+	u8 node_addr[6];
+	__le16 reserved1;
+	u8 bssid_addr[6];
+	__le16 reserved2;
+	u8 wlap_bssid_addr[6];
+	__le16 reserved3;
+	u8 dev_type;
+	u8 air_propagation;
+	__le16 reserved4;
+	u8 ofdm_basic_rates;
+	u8 cck_basic_rates;
+	__le16 assoc_id;
+	__le32 flags;
+	__le32 filter_flags;
+	__le16 channel;
+	__le16 reserved5;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
+ */
+struct iwl_rxon_assoc_cmd {
+	__le32 flags;
+	__le32 filter_flags;
+	u8 ofdm_basic_rates;
+	u8 cck_basic_rates;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
+ */
+struct iwl_rxon_time_cmd {
+	union tsf timestamp;
+	__le16 beacon_interval;
+	__le16 atim_window;
+	__le32 beacon_init_val;
+	__le16 listen_interval;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct iwl_tx_power {
+	u8 tx_gain;		/* gain for analog radio */
+	u8 dsp_atten;		/* gain for DSP */
+} __attribute__ ((packed));
+
+struct iwl_power_per_rate {
+	u8 rate;		/* plcp */
+	struct iwl_tx_power tpc;
+	u8 reserved;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
+ */
+struct iwl_channel_switch_cmd {
+	u8 band;
+	u8 expect_beacon;
+	__le16 channel;
+	__le32 rxon_flags;
+	__le32 rxon_filter_flags;
+	__le32 switch_time;
+	struct iwl_power_per_rate power[IWL_MAX_RATES];
+} __attribute__ ((packed));
+
+/*
+ * CHANNEL_SWITCH_NOTIFICATION = 0x73 (notification only, not a command)
+ */
+struct iwl_csa_notification {
+	__le16 band;
+	__le16 channel;
+	__le32 status;		/* 0 - OK, 1 - fail */
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (2)
+ * Quality-of-Service (QOS) Commands & Responses:
+ *
+ *****************************************************************************/
+struct iwl_ac_qos {
+	__le16 cw_min;
+	__le16 cw_max;
+	u8 aifsn;
+	u8 reserved1;
+	__le16 edca_txop;
+} __attribute__ ((packed));
+
+/* QoS flags defines */
+#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	__constant_cpu_to_le32(0x01)
+#define QOS_PARAM_FLG_TGN_MSK		__constant_cpu_to_le32(0x02)
+#define QOS_PARAM_FLG_TXOP_TYPE_MSK	__constant_cpu_to_le32(0x10)
+
+/*
+ *  TXFIFO Queue number defines
+ */
+/* number of Access categories (AC) (EDCA), queues 0..3 */
+#define AC_NUM                4
+
+/*
+ * REPLY_QOS_PARAM = 0x13 (command, has simple generic response)
+ */
+struct iwl_qosparam_cmd {
+	__le32 qos_flags;
+	struct iwl_ac_qos ac[AC_NUM];
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (3)
+ * Add/Modify Stations Commands & Responses:
+ *
+ *****************************************************************************/
+/*
+ * Multi station support
+ */
+#define	IWL_AP_ID		0
+#define IWL_MULTICAST_ID	1
+#define	IWL_STA_ID		2
+
+#define	IWL3945_BROADCAST_ID	24
+#define IWL3945_STATION_COUNT	25
+
+#define IWL4965_BROADCAST_ID	31
+#define	IWL4965_STATION_COUNT	32
+
+#define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
+#define	IWL_INVALID_STATION 	255
+
+#define STA_FLG_TX_RATE_MSK		__constant_cpu_to_le32(1<<2);
+
+#define STA_CONTROL_MODIFY_MSK		0x01
+
+/* key flags __le16*/
+#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x7)
+#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0)
+#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x1)
+#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x2)
+#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x3)
+
+#define STA_KEY_FLG_KEYID_POS	8
+#define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
+
+/* modify flags  */
+#define	STA_MODIFY_KEY_MASK		0x01
+#define	STA_MODIFY_TID_DISABLE_TX	0x02
+#define	STA_MODIFY_TX_RATE_MSK		0x04
+#define STA_MODIFY_ADDBA_TID_MSK	0x08
+#define STA_MODIFY_DELBA_TID_MSK	0x10
+#define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
+
+/*
+ * Antenna masks:
+ * bit14:15 01 B inactive, A active
+ *          10 B active, A inactive
+ *          11 Both active
+ */
+#define RATE_MCS_ANT_A_POS	14
+#define RATE_MCS_ANT_B_POS	15
+#define RATE_MCS_ANT_A_MSK	0x4000
+#define RATE_MCS_ANT_B_MSK	0x8000
+#define RATE_MCS_ANT_AB_MSK	0xc000
+
+struct iwl_keyinfo {
+	__le16 key_flags;
+	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
+	u8 reserved1;
+	__le16 tkip_rx_ttak[5];	/* 10-byte unicast TKIP TTAK */
+	__le16 reserved2;
+	u8 key[16];		/* 16-byte unicast decryption key */
+} __attribute__ ((packed));
+
+struct sta_id_modify {
+	u8 addr[ETH_ALEN];
+	__le16 reserved1;
+	u8 sta_id;
+	u8 modify_mask;
+	__le16 reserved2;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_ADD_STA = 0x18 (command)
+ */
+struct iwl_addsta_cmd {
+	u8 mode;
+	u8 reserved[3];
+	struct sta_id_modify sta;
+	struct iwl_keyinfo key;
+	__le32 station_flags;
+	__le32 station_flags_msk;
+	__le16 tid_disable_tx;
+	__le16 rate_n_flags;
+	u8 add_immediate_ba_tid;
+	u8 remove_immediate_ba_tid;
+	__le16 add_immediate_ba_ssn;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_ADD_STA = 0x18 (response)
+ */
+struct iwl_add_sta_resp {
+	u8 status;
+} __attribute__ ((packed));
+
+#define ADD_STA_SUCCESS_MSK              0x1
+
+/******************************************************************************
+ * (4)
+ * Rx Responses:
+ *
+ *****************************************************************************/
+
+struct iwl_rx_frame_stats {
+	u8 phy_count;
+	u8 id;
+	u8 rssi;
+	u8 agc;
+	__le16 sig_avg;
+	__le16 noise_diff;
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct iwl_rx_frame_hdr {
+	__le16 channel;
+	__le16 phy_flags;
+	u8 reserved1;
+	u8 rate;
+	__le16 len;
+	u8 payload[0];
+} __attribute__ ((packed));
+
+#define	RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
+#define	RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
+
+#define	RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
+#define	RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
+#define	RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
+#define	RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
+#define	RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
+
+#define	RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
+
+#define	RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
+#define	RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
+#define	RX_RES_STATUS_DECRYPT_OK	(0x3 << 11)
+#define	RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
+#define	RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
+
+struct iwl_rx_frame_end {
+	__le32 status;
+	__le64 timestamp;
+	__le32 beacon_timestamp;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_3945_RX = 0x1b (response only, not a command)
+ *
+ * NOTE:  DO NOT dereference from casts to this structure
+ * It is provided only for calculating minimum data set size.
+ * The actual offsets of the hdr and end are dynamic based on
+ * stats.phy_count
+ */
+struct iwl_rx_frame {
+	struct iwl_rx_frame_stats stats;
+	struct iwl_rx_frame_hdr hdr;
+	struct iwl_rx_frame_end end;
+} __attribute__ ((packed));
+
+/* Fixed (non-configurable) rx data from phy */
+#define RX_PHY_FLAGS_ANTENNAE_OFFSET		(4)
+#define RX_PHY_FLAGS_ANTENNAE_MASK		(0x70)
+#define IWL_AGC_DB_MASK 	(0x3f80)	/* MASK(7,13) */
+#define IWL_AGC_DB_POS		(7)
+struct iwl4965_rx_non_cfg_phy {
+	__le16 ant_selection;	/* ant A bit 4, ant B bit 5, ant C bit 6 */
+	__le16 agc_info;	/* agc code 0:6, agc dB 7:13, reserved 14:15 */
+	u8 rssi_info[6];	/* we use even entries, 0/2/4 for A/B/C rssi */
+	u8 pad[0];
+} __attribute__ ((packed));
+
+/*
+ * REPLY_4965_RX = 0xc3 (response only, not a command)
+ * Used only for legacy (non 11n) frames.
+ */
+#define RX_RES_PHY_CNT 14
+struct iwl4965_rx_phy_res {
+	u8 non_cfg_phy_cnt;     /* non configurable DSP phy data byte count */
+	u8 cfg_phy_cnt;		/* configurable DSP phy data byte count */
+	u8 stat_id;		/* configurable DSP phy data set ID */
+	u8 reserved1;
+	__le64 timestamp;	/* TSF at on air rise */
+	__le32 beacon_time_stamp; /* beacon at on-air rise */
+	__le16 phy_flags;	/* general phy flags: band, modulation, ... */
+	__le16 channel;		/* channel number */
+	__le16 non_cfg_phy[RX_RES_PHY_CNT];	/* upto 14 phy entries */
+	__le32 reserved2;
+	__le32 rate_n_flags;
+	__le16 byte_count;		/* frame's byte-count */
+	__le16 reserved3;
+} __attribute__ ((packed));
+
+struct iwl4965_rx_mpdu_res_start {
+	__le16 byte_count;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+
+/******************************************************************************
+ * (5)
+ * Tx Commands & Responses:
+ *
+ *****************************************************************************/
+
+/* Tx flags */
+#define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
+#define TX_CMD_FLG_CTS_MSK __constant_cpu_to_le32(1 << 2)
+#define TX_CMD_FLG_ACK_MSK __constant_cpu_to_le32(1 << 3)
+#define TX_CMD_FLG_STA_RATE_MSK __constant_cpu_to_le32(1 << 4)
+#define TX_CMD_FLG_IMM_BA_RSP_MASK  __constant_cpu_to_le32(1 << 6)
+#define TX_CMD_FLG_FULL_TXOP_PROT_MSK __constant_cpu_to_le32(1 << 7)
+#define TX_CMD_FLG_ANT_SEL_MSK __constant_cpu_to_le32(0xf00)
+#define TX_CMD_FLG_ANT_A_MSK __constant_cpu_to_le32(1 << 8)
+#define TX_CMD_FLG_ANT_B_MSK __constant_cpu_to_le32(1 << 9)
+
+/* ucode ignores BT priority for this frame */
+#define TX_CMD_FLG_BT_DIS_MSK __constant_cpu_to_le32(1 << 12)
+
+/* ucode overrides sequence control */
+#define TX_CMD_FLG_SEQ_CTL_MSK __constant_cpu_to_le32(1 << 13)
+
+/* signal that this frame is non-last MPDU */
+#define TX_CMD_FLG_MORE_FRAG_MSK __constant_cpu_to_le32(1 << 14)
+
+/* calculate TSF in outgoing frame */
+#define TX_CMD_FLG_TSF_MSK __constant_cpu_to_le32(1 << 16)
+
+/* activate TX calibration. */
+#define TX_CMD_FLG_CALIB_MSK __constant_cpu_to_le32(1 << 17)
+
+/* signals that 2 bytes pad was inserted
+   after the MAC header */
+#define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
+
+/* HCCA-AP - disable duration overwriting. */
+#define TX_CMD_FLG_DUR_MSK __constant_cpu_to_le32(1 << 25)
+
+/*
+ * TX command security control
+ */
+#define TX_CMD_SEC_WEP  	0x01
+#define TX_CMD_SEC_CCM  	0x02
+#define TX_CMD_SEC_TKIP		0x03
+#define TX_CMD_SEC_MSK		0x03
+#define TX_CMD_SEC_SHIFT	6
+#define TX_CMD_SEC_KEY128	0x08
+
+/*
+ * TX command Frame life time
+ */
+
+struct iwl_dram_scratch {
+	u8 try_cnt;
+	u8 bt_kill_cnt;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_TX = 0x1c (command)
+ */
+struct iwl_tx_cmd {
+	__le16 len;
+	__le16 next_frame_len;
+	__le32 tx_flags;
+	u8 rate;
+	u8 sta_id;
+	u8 tid_tspec;
+	u8 sec_ctl;
+	u8 key[16];
+	union {
+		u8 byte[8];
+		__le16 word[4];
+		__le32 dw[2];
+	} tkip_mic;
+	__le32 next_frame_info;
+	union {
+		__le32 life_time;
+		__le32 attempt;
+	} stop_time;
+	u8 supp_rates[2];
+	u8 rts_retry_limit;	/*byte 50 */
+	u8 data_retry_limit;	/*byte 51 */
+	union {
+		__le16 pm_frame_timeout;
+		__le16 attempt_duration;
+	} timeout;
+	__le16 driver_txop;
+	u8 payload[0];
+	struct ieee80211_hdr hdr[0];
+} __attribute__ ((packed));
+
+/* TX command response is sent after *all* transmission attempts.
+ *
+ * NOTES:
+ *
+ * TX_STATUS_FAIL_NEXT_FRAG
+ *
+ * If the fragment flag in the MAC header for the frame being transmitted
+ * is set and there is insufficient time to transmit the next frame, the
+ * TX status will be returned with 'TX_STATUS_FAIL_NEXT_FRAG'.
+ *
+ * TX_STATUS_FIFO_UNDERRUN
+ *
+ * Indicates the host did not provide bytes to the FIFO fast enough while
+ * a TX was in progress.
+ *
+ * TX_STATUS_FAIL_MGMNT_ABORT
+ *
+ * This status is only possible if the ABORT ON MGMT RX parameter was
+ * set to true with the TX command.
+ *
+ * If the MSB of the status parameter is set then an abort sequence is
+ * required.  This sequence consists of the host activating the TX Abort
+ * control line, and then waiting for the TX Abort command response.  This
+ * indicates that a the device is no longer in a transmit state, and that the
+ * command FIFO has been cleared.  The host must then deactivate the TX Abort
+ * control line.  Receiving is still allowed in this case.
+ */
+enum {
+	TX_STATUS_SUCCESS = 0x01,
+	TX_STATUS_DIRECT_DONE = 0x02,
+	TX_STATUS_FAIL_SHORT_LIMIT = 0x82,
+	TX_STATUS_FAIL_LONG_LIMIT = 0x83,
+	TX_STATUS_FAIL_FIFO_UNDERRUN = 0x84,
+	TX_STATUS_FAIL_MGMNT_ABORT = 0x85,
+	TX_STATUS_FAIL_NEXT_FRAG = 0x86,
+	TX_STATUS_FAIL_LIFE_EXPIRE = 0x87,
+	TX_STATUS_FAIL_DEST_PS = 0x88,
+	TX_STATUS_FAIL_ABORTED = 0x89,
+	TX_STATUS_FAIL_BT_RETRY = 0x8a,
+	TX_STATUS_FAIL_STA_INVALID = 0x8b,
+	TX_STATUS_FAIL_FRAG_DROPPED = 0x8c,
+	TX_STATUS_FAIL_TID_DISABLE = 0x8d,
+	TX_STATUS_FAIL_FRAME_FLUSHED = 0x8e,
+	TX_STATUS_FAIL_INSUFFICIENT_CF_POLL = 0x8f,
+	TX_STATUS_FAIL_TX_LOCKED = 0x90,
+	TX_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
+};
+
+#define	TX_PACKET_MODE_REGULAR		0x0000
+#define	TX_PACKET_MODE_BURST_SEQ	0x0100
+#define	TX_PACKET_MODE_BURST_FIRST	0x0200
+
+enum {
+	TX_POWER_PA_NOT_ACTIVE = 0x0,
+};
+
+enum {
+	TX_STATUS_MSK = 0x000000ff,	/* bits 0:7 */
+	TX_STATUS_DELAY_MSK = 0x00000040,
+	TX_STATUS_ABORT_MSK = 0x00000080,
+	TX_PACKET_MODE_MSK = 0x0000ff00,	/* bits 8:15 */
+	TX_FIFO_NUMBER_MSK = 0x00070000,	/* bits 16:18 */
+	TX_RESERVED = 0x00780000,	/* bits 19:22 */
+	TX_POWER_PA_DETECT_MSK = 0x7f800000,	/* bits 23:30 */
+	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
+};
+
+/* *******************************
+ * TX aggregation state
+ ******************************* */
+
+enum {
+	AGG_TX_STATE_TRANSMITTED = 0x00,
+	AGG_TX_STATE_UNDERRUN_MSK = 0x01,
+	AGG_TX_STATE_BT_PRIO_MSK = 0x02,
+	AGG_TX_STATE_FEW_BYTES_MSK = 0x04,
+	AGG_TX_STATE_ABORT_MSK = 0x08,
+	AGG_TX_STATE_LAST_SENT_TTL_MSK = 0x10,
+	AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK = 0x20,
+	AGG_TX_STATE_LAST_SENT_BT_KILL_MSK = 0x40,
+	AGG_TX_STATE_SCD_QUERY_MSK = 0x80,
+	AGG_TX_STATE_TEST_BAD_CRC32_MSK = 0x100,
+	AGG_TX_STATE_RESPONSE_MSK = 0x1ff,
+	AGG_TX_STATE_DUMP_TX_MSK = 0x200,
+	AGG_TX_STATE_DELAY_TX_MSK = 0x400
+};
+
+#define AGG_TX_STATE_LAST_SENT_MSK \
+(AGG_TX_STATE_LAST_SENT_TTL_MSK | \
+ AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK | \
+ AGG_TX_STATE_LAST_SENT_BT_KILL_MSK)
+
+#define AGG_TX_STATE_TRY_CNT_POS 12
+#define AGG_TX_STATE_TRY_CNT_MSK 0xf000
+
+#define AGG_TX_STATE_SEQ_NUM_POS 16
+#define AGG_TX_STATE_SEQ_NUM_MSK 0xffff0000
+
+/*
+ * REPLY_TX = 0x1c (response)
+ */
+struct iwl_tx_resp {
+	u8 failure_rts;
+	u8 failure_frame;
+	u8 bt_kill_count;
+	u8 rate;
+	__le32 wireless_media_time;
+	__le32 status;	/* TX status (for aggregation status of 1st frame) */
+} __attribute__ ((packed));
+
+/*
+ * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
+ */
+struct iwl_compressed_ba_resp {
+	__le32 sta_addr_lo32;
+	__le16 sta_addr_hi16;
+	__le16 reserved;
+	u8 sta_id;
+	u8 tid;
+	__le16 ba_seq_ctl;
+	__le32 ba_bitmap0;
+	__le32 ba_bitmap1;
+	__le16 scd_flow;
+	__le16 scd_ssn;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_TX_PWR_TABLE_CMD = 0x97 (command, has simple generic response)
+ */
+struct iwl_txpowertable_cmd {
+	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
+	u8 reserved;
+	__le16 channel;
+	struct iwl_power_per_rate power[IWL_MAX_RATES];
+} __attribute__ ((packed));
+
+struct iwl_rate_scaling_info {
+	__le16 rate_n_flags;
+	u8 try_cnt;
+	u8 next_rate_index;
+} __attribute__ ((packed));
+
+/**
+ * struct iwl_rate_scaling_cmd - Rate Scaling Command & Response
+ *
+ * REPLY_RATE_SCALE = 0x47 (command, has simple generic response)
+ *
+ * NOTE: The table of rates passed to the uCode via the
+ * RATE_SCALE command sets up the corresponding order of
+ * rates used for all related commands, including rate
+ * masks, etc.
+ *
+ * For example, if you set 9MB (PLCP 0x0f) as the first
+ * rate in the rate table, the bit mask for that rate
+ * when passed through ofdm_basic_rates on the REPLY_RXON
+ * command would be bit 0 (1<<0)
+ */
+struct iwl_rate_scaling_cmd {
+	u8 table_id;
+	u8 reserved[3];
+	struct iwl_rate_scaling_info table[IWL_MAX_RATES];
+} __attribute__ ((packed));
+
+/*
+ * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
+ */
+struct iwl_bt_cmd {
+	u8 flags;
+	u8 lead_time;
+	u8 max_kill;
+	u8 reserved;
+	__le32 kill_ack_mask;
+	__le32 kill_cts_mask;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (6)
+ * Spectrum Management (802.11h) Commands, Responses, Notifications:
+ *
+ *****************************************************************************/
+
+/*
+ * Spectrum Management
+ */
+#define MEASUREMENT_FILTER_FLAG (RXON_FILTER_PROMISC_MSK         | \
+				 RXON_FILTER_CTL2HOST_MSK        | \
+				 RXON_FILTER_ACCEPT_GRP_MSK      | \
+				 RXON_FILTER_DIS_DECRYPT_MSK     | \
+				 RXON_FILTER_DIS_GRP_DECRYPT_MSK | \
+				 RXON_FILTER_ASSOC_MSK           | \
+				 RXON_FILTER_BCON_AWARE_MSK)
+
+struct iwl_measure_channel {
+	__le32 duration;	/* measurement duration in extended beacon
+				 * format */
+	u8 channel;		/* channel to measure */
+	u8 type;		/* see enum iwl_measure_type */
+	__le16 reserved;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (command)
+ */
+struct iwl_spectrum_cmd {
+	__le16 len;		/* number of bytes starting from token */
+	u8 token;		/* token id */
+	u8 id;			/* measurement id -- 0 or 1 */
+	u8 origin;		/* 0 = TGh, 1 = other, 2 = TGk */
+	u8 periodic;		/* 1 = periodic */
+	__le16 path_loss_timeout;
+	__le32 start_time;	/* start time in extended beacon format */
+	__le32 reserved2;
+	__le32 flags;		/* rxon flags */
+	__le32 filter_flags;	/* rxon filter flags */
+	__le16 channel_count;	/* minimum 1, maximum 10 */
+	__le16 reserved3;
+	struct iwl_measure_channel channels[10];
+} __attribute__ ((packed));
+
+/*
+ * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (response)
+ */
+struct iwl_spectrum_resp {
+	u8 token;
+	u8 id;			/* id of the prior command replaced, or 0xff */
+	__le16 status;		/* 0 - command will be handled
+				 * 1 - cannot handle (conflicts with another
+				 *     measurement) */
+} __attribute__ ((packed));
+
+enum iwl_measurement_state {
+	IWL_MEASUREMENT_START = 0,
+	IWL_MEASUREMENT_STOP = 1,
+};
+
+enum iwl_measurement_status {
+	IWL_MEASUREMENT_OK = 0,
+	IWL_MEASUREMENT_CONCURRENT = 1,
+	IWL_MEASUREMENT_CSA_CONFLICT = 2,
+	IWL_MEASUREMENT_TGH_CONFLICT = 3,
+	/* 4-5 reserved */
+	IWL_MEASUREMENT_STOPPED = 6,
+	IWL_MEASUREMENT_TIMEOUT = 7,
+	IWL_MEASUREMENT_PERIODIC_FAILED = 8,
+};
+
+#define NUM_ELEMENTS_IN_HISTOGRAM 8
+
+struct iwl_measurement_histogram {
+	__le32 ofdm[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 0.8usec counts */
+	__le32 cck[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 1usec counts */
+} __attribute__ ((packed));
+
+/* clear channel availability counters */
+struct iwl_measurement_cca_counters {
+	__le32 ofdm;
+	__le32 cck;
+} __attribute__ ((packed));
+
+enum iwl_measure_type {
+	IWL_MEASURE_BASIC = (1 << 0),
+	IWL_MEASURE_CHANNEL_LOAD = (1 << 1),
+	IWL_MEASURE_HISTOGRAM_RPI = (1 << 2),
+	IWL_MEASURE_HISTOGRAM_NOISE = (1 << 3),
+	IWL_MEASURE_FRAME = (1 << 4),
+	/* bits 5:6 are reserved */
+	IWL_MEASURE_IDLE = (1 << 7),
+};
+
+/*
+ * SPECTRUM_MEASURE_NOTIFICATION = 0x75 (notification only, not a command)
+ */
+struct iwl_spectrum_notification {
+	u8 id;			/* measurement id -- 0 or 1 */
+	u8 token;
+	u8 channel_index;	/* index in measurement channel list */
+	u8 state;		/* 0 - start, 1 - stop */
+	__le32 start_time;	/* lower 32-bits of TSF */
+	u8 band;		/* 0 - 5.2GHz, 1 - 2.4GHz */
+	u8 channel;
+	u8 type;		/* see enum iwl_measurement_type */
+	u8 reserved1;
+	/* NOTE:  cca_ofdm, cca_cck, basic_type, and histogram are only only
+	 * valid if applicable for measurement type requested. */
+	__le32 cca_ofdm;	/* cca fraction time in 40Mhz clock periods */
+	__le32 cca_cck;		/* cca fraction time in 44Mhz clock periods */
+	__le32 cca_time;	/* channel load time in usecs */
+	u8 basic_type;		/* 0 - bss, 1 - ofdm preamble, 2 -
+				 * unidentified */
+	u8 reserved2[3];
+	struct iwl_measurement_histogram histogram;
+	__le32 stop_time;	/* lower 32-bits of TSF */
+	__le32 status;		/* see iwl_measurement_status */
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (7)
+ * Power Management Commands, Responses, Notifications:
+ *
+ *****************************************************************************/
+
+/**
+ * struct iwl_powertable_cmd - Power Table Command
+ * @flags: See below:
+ *
+ * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
+ *
+ * PM allow:
+ *   bit 0 - '0' Driver not allow power management
+ *           '1' Driver allow PM (use rest of parameters)
+ * uCode send sleep notifications:
+ *   bit 1 - '0' Don't send sleep notification
+ *           '1' send sleep notification (SEND_PM_NOTIFICATION)
+ * Sleep over DTIM
+ *   bit 2 - '0' PM have to walk up every DTIM
+ *           '1' PM could sleep over DTIM till listen Interval.
+ * PCI power managed
+ *   bit 3 - '0' (PCI_LINK_CTRL & 0x1)
+ *           '1' !(PCI_LINK_CTRL & 0x1)
+ * Force sleep Modes
+ *   bit 31/30- '00' use both mac/xtal sleeps
+ *              '01' force Mac sleep
+ *              '10' force xtal sleep
+ *              '11' Illegal set
+ *
+ * NOTE: if sleep_interval[SLEEP_INTRVL_TABLE_SIZE-1] > DTIM period then
+ * ucode assume sleep over DTIM is allowed and we don't need to wakeup
+ * for every DTIM.
+ */
+#define IWL_POWER_VEC_SIZE 5
+
+#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le32(1<<0)
+#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le32(1<<2)
+#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le32(1<<3)
+struct iwl_powertable_cmd {
+	__le32 flags;
+	__le32 rx_data_timeout;
+	__le32 tx_data_timeout;
+	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
+} __attribute__((packed));
+
+/*
+ * PM_SLEEP_NOTIFICATION = 0x7A (notification only, not a command)
+ * 3945 and 4965 identical.
+ */
+struct iwl_sleep_notification {
+	u8 pm_sleep_mode;
+	u8 pm_wakeup_src;
+	__le16 reserved;
+	__le32 sleep_time;
+	__le32 tsf_low;
+	__le32 bcon_timer;
+} __attribute__ ((packed));
+
+/* Sleep states.  3945 and 4965 identical. */
+enum {
+	IWL_PM_NO_SLEEP = 0,
+	IWL_PM_SLP_MAC = 1,
+	IWL_PM_SLP_FULL_MAC_UNASSOCIATE = 2,
+	IWL_PM_SLP_FULL_MAC_CARD_STATE = 3,
+	IWL_PM_SLP_PHY = 4,
+	IWL_PM_SLP_REPENT = 5,
+	IWL_PM_WAKEUP_BY_TIMER = 6,
+	IWL_PM_WAKEUP_BY_DRIVER = 7,
+	IWL_PM_WAKEUP_BY_RFKILL = 8,
+	/* 3 reserved */
+	IWL_PM_NUM_OF_MODES = 12,
+};
+
+/*
+ * REPLY_CARD_STATE_CMD = 0xa0 (command, has simple generic response)
+ */
+#define CARD_STATE_CMD_DISABLE 0x00	/* Put card to sleep */
+#define CARD_STATE_CMD_ENABLE  0x01	/* Wake up card */
+#define CARD_STATE_CMD_HALT    0x02	/* Power down permanently */
+struct iwl_card_state_cmd {
+	__le32 status;		/* CARD_STATE_CMD_* request new power state */
+} __attribute__ ((packed));
+
+/*
+ * CARD_STATE_NOTIFICATION = 0xa1 (notification only, not a command)
+ */
+struct iwl_card_state_notif {
+	__le32 flags;
+} __attribute__ ((packed));
+
+#define HW_CARD_DISABLED   0x01
+#define SW_CARD_DISABLED   0x02
+#define RF_CARD_DISABLED   0x04
+#define RXON_CARD_DISABLED 0x10
+
+struct iwl_ct_kill_config {
+	__le32   reserved;
+	__le32   critical_temperature_M;
+	__le32   critical_temperature_R;
+}  __attribute__ ((packed));
+
+/******************************************************************************
+ * (8)
+ * Scan Commands, Responses, Notifications:
+ *
+ *****************************************************************************/
+
+struct iwl_scan_channel {
+	/* type is defined as:
+	 * 0:0 active (0 - passive)
+	 * 1:4 SSID direct
+	 *     If 1 is set then corresponding SSID IE is transmitted in probe
+	 * 5:7 reserved
+	 */
+	u8 type;
+	u8 channel;
+	struct iwl_tx_power tpc;
+	__le16 active_dwell;
+	__le16 passive_dwell;
+} __attribute__ ((packed));
+
+struct iwl_ssid_ie {
+	u8 id;
+	u8 len;
+	u8 ssid[32];
+} __attribute__ ((packed));
+
+#define PROBE_OPTION_MAX        0x4
+#define TX_CMD_LIFE_TIME_INFINITE	__constant_cpu_to_le32(0xFFFFFFFF)
+#define IWL_GOOD_CRC_TH		__constant_cpu_to_le16(1)
+#define IWL_MAX_SCAN_SIZE 1024
+
+/*
+ * REPLY_SCAN_CMD = 0x80 (command)
+ */
+struct iwl_scan_cmd {
+	__le16 len;
+	u8 reserved0;
+	u8 channel_count;
+	__le16 quiet_time;     /* dwell only this long on quiet chnl
+				* (active scan) */
+	__le16 quiet_plcp_th;  /* quiet chnl is < this # pkts (typ. 1) */
+	__le16 good_CRC_th;    /* passive -> active promotion threshold */
+	__le16 reserved1;
+	__le32 max_out_time;   /* max usec to be out of associated (service)
+				* chnl */
+	__le32 suspend_time;   /* pause scan this long when returning to svc
+				* chnl.
+				* 3945 -- 31:24 # beacons, 19:0 additional usec,
+				* 4965 -- 31:22 # beacons, 21:0 additional usec.
+				*/
+	__le32 flags;
+	__le32 filter_flags;
+
+	struct iwl_tx_cmd tx_cmd;
+	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
+
+	u8 data[0];
+	/*
+	 * The channels start after the probe request payload and are of type:
+	 *
+	 * struct iwl_scan_channel channels[0];
+	 *
+	 * NOTE:  Only one band of channels can be scanned per pass.  You
+	 * can not mix 2.4GHz channels and 5.2GHz channels and must
+	 * request a scan multiple times (not concurrently)
+	 *
+	 */
+} __attribute__ ((packed));
+
+/* Can abort will notify by complete notification with abort status. */
+#define CAN_ABORT_STATUS	__constant_cpu_to_le32(0x1)
+/* complete notification statuses */
+#define ABORT_STATUS            0x2
+
+/*
+ * REPLY_SCAN_CMD = 0x80 (response)
+ */
+struct iwl_scanreq_notification {
+	__le32 status;		/* 1: okay, 2: cannot fulfill request */
+} __attribute__ ((packed));
+
+/*
+ * SCAN_START_NOTIFICATION = 0x82 (notification only, not a command)
+ */
+struct iwl_scanstart_notification {
+	__le32 tsf_low;
+	__le32 tsf_high;
+	__le32 beacon_timer;
+	u8 channel;
+	u8 band;
+	u8 reserved[2];
+	__le32 status;
+} __attribute__ ((packed));
+
+#define  SCAN_OWNER_STATUS 0x1;
+#define  MEASURE_OWNER_STATUS 0x2;
+
+#define NUMBER_OF_STATISTICS 1	/* first __le32 is good CRC */
+/*
+ * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
+ */
+struct iwl_scanresults_notification {
+	u8 channel;
+	u8 band;
+	u8 reserved[2];
+	__le32 tsf_low;
+	__le32 tsf_high;
+	__le32 statistics[NUMBER_OF_STATISTICS];
+} __attribute__ ((packed));
+
+/*
+ * SCAN_COMPLETE_NOTIFICATION = 0x84 (notification only, not a command)
+ */
+struct iwl_scancomplete_notification {
+	u8 scanned_channels;
+	u8 status;
+	u8 reserved;
+	u8 last_channel;
+	__le32 tsf_low;
+	__le32 tsf_high;
+} __attribute__ ((packed));
+
+
+/******************************************************************************
+ * (9)
+ * IBSS/AP Commands and Notifications:
+ *
+ *****************************************************************************/
+
+/*
+ * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
+ */
+struct iwl_beacon_notif {
+	struct iwl_tx_resp beacon_notify_hdr;
+	__le32 low_tsf;
+	__le32 high_tsf;
+	__le32 ibss_mgr_status;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
+ */
+struct iwl_tx_beacon_cmd {
+	struct iwl_tx_cmd tx;
+	__le16 tim_idx;
+	u8 tim_size;
+	u8 reserved1;
+	struct ieee80211_hdr frame[0];	/* beacon frame */
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (10)
+ * Statistics Commands and Notifications:
+ *
+ *****************************************************************************/
+
+#define IWL_TEMP_CONVERT 260
+
+#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
+#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
+#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
+
+/* Used for passing to driver number of successes and failures per rate */
+struct rate_histogram {
+	union {
+		__le32 a[SUP_RATE_11A_MAX_NUM_CHANNELS];
+		__le32 b[SUP_RATE_11B_MAX_NUM_CHANNELS];
+		__le32 g[SUP_RATE_11G_MAX_NUM_CHANNELS];
+	} success;
+	union {
+		__le32 a[SUP_RATE_11A_MAX_NUM_CHANNELS];
+		__le32 b[SUP_RATE_11B_MAX_NUM_CHANNELS];
+		__le32 g[SUP_RATE_11G_MAX_NUM_CHANNELS];
+	} failed;
+} __attribute__ ((packed));
+
+/* statistics command response */
+
+struct statistics_rx_phy {
+	__le32 ina_cnt;
+	__le32 fina_cnt;
+	__le32 plcp_err;
+	__le32 crc32_err;
+	__le32 overrun_err;
+	__le32 early_overrun_err;
+	__le32 crc32_good;
+	__le32 false_alarm_cnt;
+	__le32 fina_sync_err_cnt;
+	__le32 sfd_timeout;
+	__le32 fina_timeout;
+	__le32 unresponded_rts;
+	__le32 rxe_frame_limit_overrun;
+	__le32 sent_ack_cnt;
+	__le32 sent_cts_cnt;
+} __attribute__ ((packed));
+
+struct statistics_rx_non_phy {
+	__le32 bogus_cts;	/* CTS received when not expecting CTS */
+	__le32 bogus_ack;	/* ACK received when not expecting ACK */
+	__le32 non_bssid_frames;	/* number of frames with BSSID that
+					 * doesn't belong to the STA BSSID */
+	__le32 filtered_frames;	/* count frames that were dumped in the
+				 * filtering process */
+	__le32 non_channel_beacons;	/* beacons with our bss id but not on
+					 * our serving channel */
+} __attribute__ ((packed));
+
+struct statistics_rx {
+	struct statistics_rx_phy ofdm;
+	struct statistics_rx_phy cck;
+	struct statistics_rx_non_phy general;
+} __attribute__ ((packed));
+
+struct statistics_tx {
+	__le32 preamble_cnt;
+	__le32 rx_detected_cnt;
+	__le32 bt_prio_defer_cnt;
+	__le32 bt_prio_kill_cnt;
+	__le32 few_bytes_cnt;
+	__le32 cts_timeout;
+	__le32 ack_timeout;
+	__le32 expected_ack_cnt;
+	__le32 actual_ack_cnt;
+} __attribute__ ((packed));
+
+struct statistics_dbg {
+	__le32 burst_check;
+	__le32 burst_count;
+	__le32 reserved[4];
+} __attribute__ ((packed));
+
+struct statistics_div {
+	__le32 tx_on_a;
+	__le32 tx_on_b;
+	__le32 exec_time;
+	__le32 probe_time;
+} __attribute__ ((packed));
+
+struct statistics_general {
+	__le32 temperature;
+	struct statistics_dbg dbg;
+	__le32 sleep_time;
+	__le32 slots_out;
+	__le32 slots_idle;
+	__le32 ttl_timestamp;
+	struct statistics_div div;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_STATISTICS_CMD = 0x9c,
+ * 3945 and 4965 identical.
+ *
+ * This command triggers an immediate response containing uCode statistics.
+ * The response is in the same format as STATISTICS_NOTIFICATION 0x9d, below.
+ *
+ * If the CLEAR_STATS configuration flag is set, uCode will clear its
+ * internal copy of the statistics (counters) after issuing the response.
+ * This flag does not affect STATISTICS_NOTIFICATIONs after beacons (see below).
+ *
+ * If the DISABLE_NOTIF configuration flag is set, uCode will not issue
+ * STATISTICS_NOTIFICATIONs after received beacons (see below).  This flag
+ * does not affect the response to the REPLY_STATISTICS_CMD 0x9c itself.
+ */
+#define IWL_STATS_CONF_CLEAR_STATS __constant_cpu_to_le32(0x1)	/* see above */
+#define IWL_STATS_CONF_DISABLE_NOTIF __constant_cpu_to_le32(0x2)/* see above */
+struct iwl_statistics_cmd {
+	__le32 configuration_flags;	/* IWL_STATS_CONF_* */
+} __attribute__ ((packed));
+
+/*
+ * STATISTICS_NOTIFICATION = 0x9d (notification only, not a command)
+ *
+ * By default, uCode issues this notification after receiving a beacon
+ * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
+ * REPLY_STATISTICS_CMD 0x9c, above.
+ *
+ * Statistics counters continue to increment beacon after beacon, but are
+ * cleared when changing channels or when driver issues REPLY_STATISTICS_CMD
+ * 0x9c with CLEAR_STATS bit set (see above).
+ *
+ * uCode also issues this notification during scans.  uCode clears statistics
+ * appropriately so that each notification contains statistics for only the
+ * one channel that has just been scanned.
+ */
+#define STATISTICS_REPLY_FLG_BAND_24G_MSK         __constant_cpu_to_le32(0x2)
+#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         __constant_cpu_to_le32(0x8)
+struct iwl_notif_statistics {
+	__le32 flag;
+	struct statistics_rx rx;
+	struct statistics_tx tx;
+	struct statistics_general general;
+} __attribute__ ((packed));
+
+
+/*
+ * MISSED_BEACONS_NOTIFICATION = 0xa2 (notification only, not a command)
+ */
+/* if ucode missed CONSECUTIVE_MISSED_BCONS_TH beacons in a row,
+ * then this notification will be sent. */
+#define CONSECUTIVE_MISSED_BCONS_TH 20
+
+struct iwl_missed_beacon_notif {
+	__le32 consequtive_missed_beacons;
+	__le32 total_missed_becons;
+	__le32 num_expected_beacons;
+	__le32 num_recvd_beacons;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (11)
+ * Rx Calibration Commands:
+ *
+ *****************************************************************************/
+
+#define PHY_CALIBRATE_DIFF_GAIN_CMD (7)
+#define HD_TABLE_SIZE  (11)
+
+struct iwl_sensitivity_cmd {
+	__le16 control;
+	__le16 table[HD_TABLE_SIZE];
+} __attribute__ ((packed));
+
+struct iwl_calibration_cmd {
+	u8 opCode;
+	u8 flags;
+	__le16 reserved;
+	s8 diff_gain_a;
+	s8 diff_gain_b;
+	s8 diff_gain_c;
+	u8 reserved1;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (12)
+ * Miscellaneous Commands:
+ *
+ *****************************************************************************/
+
+/*
+ * LEDs Command & Response
+ * REPLY_LEDS_CMD = 0x48 (command, has simple generic response)
+ *
+ * For each of 3 possible LEDs (Activity/Link/Tech, selected by "id" field),
+ * this command turns it on or off, or sets up a periodic blinking cycle.
+ */
+struct iwl_led_cmd {
+	__le32 interval;	/* "interval" in uSec */
+	u8 id;			/* 1: Activity, 2: Link, 3: Tech */
+	u8 off;			/* # intervals off while blinking;
+				 * "0", with >0 "on" value, turns LED on */
+	u8 on;			/* # intervals on while blinking;
+				 * "0", regardless of "off", turns LED off */
+	u8 reserved;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (13)
+ * Union of all expected notifications/responses:
+ *
+ *****************************************************************************/
+
+struct iwl_rx_packet {
+	__le32 len;
+	struct iwl_cmd_header hdr;
+	union {
+		struct iwl_alive_resp alive_frame;
+		struct iwl_rx_frame rx_frame;
+		struct iwl_tx_resp tx_resp;
+		struct iwl_spectrum_notification spectrum_notif;
+		struct iwl_csa_notification csa_notif;
+		struct iwl_error_resp err_resp;
+		struct iwl_card_state_notif card_state_notif;
+		struct iwl_beacon_notif beacon_status;
+		struct iwl_add_sta_resp add_sta;
+		struct iwl_sleep_notification sleep_notif;
+		struct iwl_spectrum_resp spectrum;
+		struct iwl_notif_statistics stats;
+		__le32 status;
+		u8 raw[0];
+	} u;
+} __attribute__ ((packed));
+
+#define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl_rx_frame))
+
+#define PCI_LINK_CTRL      0x0F0
+#define PCI_POWER_SOURCE   0x0C8
+#define PCI_REG_WUM8       0x0E8
+#define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
+
+/*=== CSR (control and status registers) ===*/
+#define CSR_BASE    (0x000)
+
+#define CSR_SW_VER              (CSR_BASE+0x000)
+#define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
+#define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
+#define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
+#define CSR_INT_MASK            (CSR_BASE+0x00c) /* host interrupt enable */
+#define CSR_FH_INT_STATUS       (CSR_BASE+0x010) /* busmaster int status/ack*/
+#define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
+#define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
+#define CSR_GP_CNTRL            (CSR_BASE+0x024)
+#define CSR_HW_REV              (CSR_BASE+0x028)
+#define CSR_EEPROM_REG          (CSR_BASE+0x02c)
+#define CSR_EEPROM_GP           (CSR_BASE+0x030)
+#define CSR_GP_UCODE		(CSR_BASE+0x044)
+#define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
+#define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
+#define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
+#define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
+#define CSR_LED_REG		(CSR_BASE+0x094)
+#define CSR_DRAM_INT_TBL_CTL	(CSR_BASE+0x0A0)
+#define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
+#define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
+#define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
+
+/* HW I/F configuration */
+#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MB         (0x00000100)
+#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM         (0x00000200)
+#define CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC            (0x00000400)
+#define CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
+#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
+#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
+
+/* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
+ * acknowledged (reset) by host writing "1" to flagged bits. */
+#define CSR_INT_BIT_FH_RX        (1<<31) /* Rx DMA, cmd responses, FH_INT[17:16] */
+#define CSR_INT_BIT_HW_ERR       (1<<29) /* DMA hardware error FH_INT[31] */
+#define CSR_INT_BIT_DNLD         (1<<28) /* uCode Download */
+#define CSR_INT_BIT_FH_TX        (1<<27) /* Tx DMA FH_INT[1:0] */
+#define CSR_INT_BIT_MAC_CLK_ACTV (1<<26) /* NIC controller's clock toggled on/off */
+#define CSR_INT_BIT_SW_ERR       (1<<25) /* uCode error */
+#define CSR_INT_BIT_RF_KILL      (1<<7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
+#define CSR_INT_BIT_CT_KILL      (1<<6)  /* Critical temp (chip too hot) rfkill */
+#define CSR_INT_BIT_SW_RX        (1<<3)  /* Rx, command responses, 3945 */
+#define CSR_INT_BIT_WAKEUP       (1<<1)  /* NIC controller waking up (pwr mgmt) */
+#define CSR_INT_BIT_ALIVE        (1<<0)  /* uCode interrupts once it initializes */
+
+#define CSR_INI_SET_MASK	(CSR_INT_BIT_FH_RX   | \
+				 CSR_INT_BIT_HW_ERR  | \
+				 CSR_INT_BIT_FH_TX   | \
+				 CSR_INT_BIT_SW_ERR  | \
+				 CSR_INT_BIT_RF_KILL | \
+				 CSR_INT_BIT_SW_RX   | \
+				 CSR_INT_BIT_WAKEUP  | \
+				 CSR_INT_BIT_ALIVE)
+
+/* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
+#define CSR_FH_INT_BIT_ERR       (1<<31) /* Error */
+#define CSR_FH_INT_BIT_HI_PRIOR  (1<<30) /* High priority Rx, bypass coalescing */
+#define CSR_FH_INT_BIT_RX_CHNL2  (1<<18) /* Rx channel 2 (3945 only) */
+#define CSR_FH_INT_BIT_RX_CHNL1  (1<<17) /* Rx channel 1 */
+#define CSR_FH_INT_BIT_RX_CHNL0  (1<<16) /* Rx channel 0 */
+#define CSR_FH_INT_BIT_TX_CHNL6  (1<<6)  /* Tx channel 6 (3945 only) */
+#define CSR_FH_INT_BIT_TX_CHNL1  (1<<1)  /* Tx channel 1 */
+#define CSR_FH_INT_BIT_TX_CHNL0  (1<<0)  /* Tx channel 0 */
+
+#define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
+				 CSR_FH_INT_BIT_RX_CHNL2 | \
+				 CSR_FH_INT_BIT_RX_CHNL1 | \
+				 CSR_FH_INT_BIT_RX_CHNL0)
+
+#define CSR_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL6 | \
+				 CSR_FH_INT_BIT_TX_CHNL1 | \
+				 CSR_FH_INT_BIT_TX_CHNL0 )
+
+
+/* RESET */
+#define CSR_RESET_REG_FLAG_NEVO_RESET                (0x00000001)
+#define CSR_RESET_REG_FLAG_FORCE_NMI                 (0x00000002)
+#define CSR_RESET_REG_FLAG_SW_RESET                  (0x00000080)
+#define CSR_RESET_REG_FLAG_MASTER_DISABLED           (0x00000100)
+#define CSR_RESET_REG_FLAG_STOP_MASTER               (0x00000200)
+
+/* GP (general purpose) CONTROL */
+#define CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY        (0x00000001)
+#define CSR_GP_CNTRL_REG_FLAG_INIT_DONE              (0x00000004)
+#define CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ         (0x00000008)
+#define CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP         (0x00000010)
+
+#define CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN           (0x00000001)
+
+#define CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE         (0x07000000)
+#define CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE         (0x04000000)
+#define CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW          (0x08000000)
+
+
+/* EEPROM REG */
+#define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
+#define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
+
+/* EEPROM GP */
+#define CSR_EEPROM_GP_VALID_MSK		(0x00000006)
+#define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
+#define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
+
+/* UCODE DRV GP */
+#define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
+#define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
+#define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
+#define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
+
+/* GPIO */
+#define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
+#define CSR_GPIO_IN_VAL_VAUX_PWR_SRC                (0x00000000)
+#define CSR_GPIO_IN_VAL_VMAIN_PWR_SRC		CSR_GPIO_IN_BIT_AUX_POWER
+
+/* GI Chicken Bits */
+#define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
+#define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
+
+/* CSR_ANA_PLL_CFG */
+#define CSR_ANA_PLL_CFG_SH		(0x00880300)
+
+#define CSR_LED_REG_TRUN_ON		(0x00000078)
+#define CSR_LED_REG_TRUN_OFF		(0x00000038)
+#define CSR_LED_BSM_CTRL_MSK		(0xFFFFFFDF)
+
+/* DRAM_INT_TBL_CTRL */
+#define CSR_DRAM_INT_TBL_CTRL_EN	(1<<31)
+#define CSR_DRAM_INT_TBL_CTRL_WRAP_CHK	(1<<27)
+
+/*=== HBUS (Host-side Bus) ===*/
+#define HBUS_BASE	(0x400)
+
+#define HBUS_TARG_MEM_RADDR     (HBUS_BASE+0x00c)
+#define HBUS_TARG_MEM_WADDR     (HBUS_BASE+0x010)
+#define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
+#define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
+#define HBUS_TARG_PRPH_WADDR    (HBUS_BASE+0x044)
+#define HBUS_TARG_PRPH_RADDR    (HBUS_BASE+0x048)
+#define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
+#define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
+#define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
+
+#define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
+
+
+/* SCD (Scheduler) */
+#define SCD_BASE                        (CSR_BASE + 0x2E00)
+
+#define SCD_MODE_REG                    (SCD_BASE + 0x000)
+#define SCD_ARASTAT_REG                 (SCD_BASE + 0x004)
+#define SCD_TXFACT_REG                  (SCD_BASE + 0x010)
+#define SCD_TXF4MF_REG                  (SCD_BASE + 0x014)
+#define SCD_TXF5MF_REG                  (SCD_BASE + 0x020)
+#define SCD_SBYP_MODE_1_REG             (SCD_BASE + 0x02C)
+#define SCD_SBYP_MODE_2_REG             (SCD_BASE + 0x030)
+
+/*=== FH (data Flow Handler) ===*/
+#define FH_BASE     (0x800)
+
+#define FH_CBCC_TABLE           (FH_BASE+0x140)
+#define FH_TFDB_TABLE           (FH_BASE+0x180)
+#define FH_RCSR_TABLE           (FH_BASE+0x400)
+#define FH_RSSR_TABLE           (FH_BASE+0x4c0)
+#define FH_TCSR_TABLE           (FH_BASE+0x500)
+#define FH_TSSR_TABLE           (FH_BASE+0x680)
+
+/* TFDB (Transmit Frame Buffer Descriptor) */
+#define FH_TFDB(_channel, buf) \
+	(FH_TFDB_TABLE+((_channel)*2+(buf))*0x28)
+#define ALM_FH_TFDB_CHNL_BUF_CTRL_REG(_channel) \
+	(FH_TFDB_TABLE + 0x50 * _channel)
+/* CBCC _channel is [0,2] */
+#define FH_CBCC(_channel)           (FH_CBCC_TABLE+(_channel)*0x8)
+#define FH_CBCC_CTRL(_channel)      (FH_CBCC(_channel)+0x00)
+#define FH_CBCC_BASE(_channel)      (FH_CBCC(_channel)+0x04)
+
+/* RCSR _channel is [0,2] */
+#define FH_RCSR(_channel)           (FH_RCSR_TABLE+(_channel)*0x40)
+#define FH_RCSR_CONFIG(_channel)    (FH_RCSR(_channel)+0x00)
+#define FH_RCSR_RBD_BASE(_channel)  (FH_RCSR(_channel)+0x04)
+#define FH_RCSR_WPTR(_channel)      (FH_RCSR(_channel)+0x20)
+#define FH_RCSR_RPTR_ADDR(_channel) (FH_RCSR(_channel)+0x24)
+#define FH_RSCSR_CHNL0_WPTR        (FH_RCSR_WPTR(0))
+
+/* RSSR */
+#define FH_RSSR_CTRL            (FH_RSSR_TABLE+0x000)
+#define FH_RSSR_STATUS          (FH_RSSR_TABLE+0x004)
+/* TCSR */
+#define FH_TCSR(_channel)           (FH_TCSR_TABLE+(_channel)*0x20)
+#define FH_TCSR_CONFIG(_channel)    (FH_TCSR(_channel)+0x00)
+#define FH_TCSR_CREDIT(_channel)    (FH_TCSR(_channel)+0x04)
+#define FH_TCSR_BUFF_STTS(_channel) (FH_TCSR(_channel)+0x08)
+/* TSSR */
+#define FH_TSSR_CBB_BASE        (FH_TSSR_TABLE+0x000)
+#define FH_TSSR_MSG_CONFIG      (FH_TSSR_TABLE+0x008)
+#define FH_TSSR_TX_STATUS       (FH_TSSR_TABLE+0x010)
+/* 18 - reserved */
+
+/* card static random access memory (SRAM) for processor data and instructs */
+#define RTC_INST_LOWER_BOUND			(0x000000)
+#define RTC_DATA_LOWER_BOUND			(0x800000)
+
+
+/* DBM */
+
+#define ALM_FH_SRVC_CHNL                            (6)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE     (20)
+#define ALM_FH_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH      (4)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN    (0x08000000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE        (0x80000000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE           (0x20000000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128         (0x01000000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST         (0x00001000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH               (0x00000000)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF              (0x00000000)
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRIVER           (0x00000001)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL    (0x00000000)
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD           (0x00200000)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT            (0x00000000)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE            (0x00000000)
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
+
+#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID          (0x00004000)
+
+#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_BIT_TFDB_WPTR           (0x00000001)
+
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON      (0xFF000000)
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON      (0x00FF0000)
+
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B    (0x00000400)
+
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON       (0x00000100)
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON       (0x00000080)
+
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH     (0x00000020)
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH           (0x00000005)
+
+#define ALM_TB_MAX_BYTES_COUNT      (0xFFF0)
+
+#define ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) \
+	((1LU << _channel) << 24)
+#define ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel) \
+	((1LU << _channel) << 16)
+
+#define ALM_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_channel) \
+	(ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) | \
+	 ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel))
+#define PCI_CFG_REV_ID_BIT_BASIC_SKU                (0x40)	/* bit 6    */
+#define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
+
+#define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
+
+#define TFD_QUEUE_MIN           0
+#define TFD_QUEUE_MAX           6
+#define TFD_QUEUE_SIZE_MAX      (256)
+
+/* spectrum and channel data structures */
+#define IWL_NUM_SCAN_RATES         (2)
+
+#define IWL_SCAN_FLAG_24GHZ  (1<<0)
+#define IWL_SCAN_FLAG_52GHZ  (1<<1)
+#define IWL_SCAN_FLAG_ACTIVE (1<<2)
+#define IWL_SCAN_FLAG_DIRECT (1<<3)
+
+#define IWL_MAX_CMD_SIZE 1024
+
+#define IWL_DEFAULT_TX_RETRY  15
+#define IWL_MAX_TX_RETRY      16
+
+/*********************************************/
+
+#define RFD_SIZE                              4
+#define NUM_TFD_CHUNKS                        4
+
+#define RX_QUEUE_SIZE                         256
+#define RX_QUEUE_MASK                         255
+#define RX_QUEUE_SIZE_LOG                     8
+
+/* QoS  definitions */
+
+#define CW_MIN_OFDM          15
+#define CW_MAX_OFDM          1023
+#define CW_MIN_CCK           31
+#define CW_MAX_CCK           1023
+
+#define QOS_TX0_CW_MIN_OFDM      CW_MIN_OFDM
+#define QOS_TX1_CW_MIN_OFDM      CW_MIN_OFDM
+#define QOS_TX2_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
+#define QOS_TX3_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 4 - 1)
+
+#define QOS_TX0_CW_MIN_CCK       CW_MIN_CCK
+#define QOS_TX1_CW_MIN_CCK       CW_MIN_CCK
+#define QOS_TX2_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
+#define QOS_TX3_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 4 - 1)
+
+#define QOS_TX0_CW_MAX_OFDM      CW_MAX_OFDM
+#define QOS_TX1_CW_MAX_OFDM      CW_MAX_OFDM
+#define QOS_TX2_CW_MAX_OFDM      CW_MIN_OFDM
+#define QOS_TX3_CW_MAX_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
+
+#define QOS_TX0_CW_MAX_CCK       CW_MAX_CCK
+#define QOS_TX1_CW_MAX_CCK       CW_MAX_CCK
+#define QOS_TX2_CW_MAX_CCK       CW_MIN_CCK
+#define QOS_TX3_CW_MAX_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
+
+#define QOS_TX0_AIFS            3
+#define QOS_TX1_AIFS            7
+#define QOS_TX2_AIFS            2
+#define QOS_TX3_AIFS            2
+
+#define QOS_TX0_ACM             0
+#define QOS_TX1_ACM             0
+#define QOS_TX2_ACM             0
+#define QOS_TX3_ACM             0
+
+#define QOS_TX0_TXOP_LIMIT_CCK          0
+#define QOS_TX1_TXOP_LIMIT_CCK          0
+#define QOS_TX2_TXOP_LIMIT_CCK          6016
+#define QOS_TX3_TXOP_LIMIT_CCK          3264
+
+#define QOS_TX0_TXOP_LIMIT_OFDM      0
+#define QOS_TX1_TXOP_LIMIT_OFDM      0
+#define QOS_TX2_TXOP_LIMIT_OFDM      3008
+#define QOS_TX3_TXOP_LIMIT_OFDM      1504
+
+#define DEF_TX0_CW_MIN_OFDM      CW_MIN_OFDM
+#define DEF_TX1_CW_MIN_OFDM      CW_MIN_OFDM
+#define DEF_TX2_CW_MIN_OFDM      CW_MIN_OFDM
+#define DEF_TX3_CW_MIN_OFDM      CW_MIN_OFDM
+
+#define DEF_TX0_CW_MIN_CCK       CW_MIN_CCK
+#define DEF_TX1_CW_MIN_CCK       CW_MIN_CCK
+#define DEF_TX2_CW_MIN_CCK       CW_MIN_CCK
+#define DEF_TX3_CW_MIN_CCK       CW_MIN_CCK
+
+#define DEF_TX0_CW_MAX_OFDM      CW_MAX_OFDM
+#define DEF_TX1_CW_MAX_OFDM      CW_MAX_OFDM
+#define DEF_TX2_CW_MAX_OFDM      CW_MAX_OFDM
+#define DEF_TX3_CW_MAX_OFDM      CW_MAX_OFDM
+
+#define DEF_TX0_CW_MAX_CCK       CW_MAX_CCK
+#define DEF_TX1_CW_MAX_CCK       CW_MAX_CCK
+#define DEF_TX2_CW_MAX_CCK       CW_MAX_CCK
+#define DEF_TX3_CW_MAX_CCK       CW_MAX_CCK
+
+#define DEF_TX0_AIFS            (2)
+#define DEF_TX1_AIFS            (2)
+#define DEF_TX2_AIFS            (2)
+#define DEF_TX3_AIFS            (2)
+
+#define DEF_TX0_ACM             0
+#define DEF_TX1_ACM             0
+#define DEF_TX2_ACM             0
+#define DEF_TX3_ACM             0
+
+#define DEF_TX0_TXOP_LIMIT_CCK        0
+#define DEF_TX1_TXOP_LIMIT_CCK        0
+#define DEF_TX2_TXOP_LIMIT_CCK        0
+#define DEF_TX3_TXOP_LIMIT_CCK        0
+
+#define DEF_TX0_TXOP_LIMIT_OFDM       0
+#define DEF_TX1_TXOP_LIMIT_OFDM       0
+#define DEF_TX2_TXOP_LIMIT_OFDM       0
+#define DEF_TX3_TXOP_LIMIT_OFDM       0
+
+#define QOS_QOS_SETS                  3
+#define QOS_PARAM_SET_ACTIVE          0
+#define QOS_PARAM_SET_DEF_CCK         1
+#define QOS_PARAM_SET_DEF_OFDM        2
+
+#define CTRL_QOS_NO_ACK               (0x0020)
+#define DCT_FLAG_EXT_QOS_ENABLED      (0x10)
+
+#define U32_PAD(n)		((4-(n))&0x3)
+
+/*
+ * Generic queue structure
+ *
+ * Contains common data for Rx and Tx queues
+ */
+#define TFD_CTL_COUNT_SET(n)       (n<<24)
+#define TFD_CTL_COUNT_GET(ctl)     ((ctl>>24) & 7)
+#define TFD_CTL_PAD_SET(n)         (n<<28)
+#define TFD_CTL_PAD_GET(ctl)       (ctl>>28)
+
+#define TFD_TX_CMD_SLOTS 256
+#define TFD_CMD_SLOTS 32
+
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
+			      sizeof(struct iwl_cmd_meta))
+
+/*
+ * RX related structures and functions
+ */
+#define RX_FREE_BUFFERS 64
+#define RX_LOW_WATERMARK 8
+
 #define IWL_RX_BUF_SIZE 3000
 /* card static random access memory (SRAM) for processor data and instructs */
 #define ALM_RTC_INST_UPPER_BOUND		(0x014000)
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-io.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-3945-io.h	2007-10-12 12:06:37.000000000 +0200
@@ -0,0 +1,470 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2007 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#ifndef __iwl_io_h__
+#define __iwl_io_h__
+
+#include <linux/io.h>
+
+#include "iwl-3945-debug.h"
+
+/*
+ * IO, register, and NIC memory access functions
+ *
+ * NOTE on naming convention and macro usage for these
+ *
+ * A single _ prefix before a an access function means that no state
+ * check or debug information is printed when that function is called.
+ *
+ * A double __ prefix before an access function means that state is checked
+ * (in the case of *restricted calls) and the current line number is printed
+ * in addition to any other debug output.
+ *
+ * The non-prefixed name is the #define that maps the caller into a
+ * #define that provides the caller's __LINE__ to the double prefix version.
+ *
+ * If you wish to call the function without any debug or state checking,
+ * you should use the single _ prefix version (as is used by dependent IO
+ * routines, for example _iwl_read_restricted calls the non-check version of
+ * _iwl_read32.)
+ *
+ * These declarations are *extremely* useful in quickly isolating code deltas
+ * which result in misconfiguring of the hardware I/O.  In combination with
+ * git-bisect and the IO debug level you can quickly determine the specific
+ * commit which breaks the IO sequence to the hardware.
+ *
+ */
+
+#define _iwl_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
+				 u32 ofs, u32 val)
+{
+	IWL_DEBUG_IO("write_direct32(0x%08X, 0x%08X) - %s %d\n",
+		     (u32) (ofs), (u32) (val), f, l);
+	_iwl_write32(iwl, ofs, val);
+}
+#define iwl_write32(iwl, ofs, val) \
+	__iwl_write32(__FILE__, __LINE__, iwl, ofs, val)
+#else
+#define iwl_write32(iwl, ofs, val) _iwl_write32(iwl, ofs, val)
+#endif
+
+#define _iwl_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
+{
+	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
+	return _iwl_read32(iwl, ofs);
+}
+#define iwl_read32(iwl, ofs) __iwl_read32(__FILE__, __LINE__, iwl, ofs)
+#else
+#define iwl_read32(p, o) _iwl_read32(p, o)
+#endif
+
+static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
+				u32 bits, u32 mask, int timeout)
+{
+	int i = 0;
+
+	do {
+		if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
+			return i;
+		mdelay(10);
+		i += 10;
+	} while (i < timeout);
+
+	return -ETIMEDOUT;
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_poll_bit(const char *f, u32 l,
+				 struct iwl_priv *priv, u32 addr,
+				 u32 bits, u32 mask, int timeout)
+{
+	int rc = _iwl_poll_bit(priv, addr, bits, mask, timeout);
+	if (unlikely(rc == -ETIMEDOUT))
+		IWL_DEBUG_IO
+		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) - timedout - %s %d\n",
+		     addr, bits, mask, f, l);
+	else
+		IWL_DEBUG_IO
+		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) = 0x%08X - %s %d\n",
+		     addr, bits, mask, rc, f, l);
+	return rc;
+}
+#define iwl_poll_bit(iwl, addr, bits, mask, timeout) \
+	__iwl_poll_bit(__FILE__, __LINE__, iwl, addr, bits, mask, timeout)
+#else
+#define iwl_poll_bit(p, a, b, m, t) _iwl_poll_bit(p, a, b, m, t)
+#endif
+
+static inline void _iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bit(const char *f, u32 l,
+				 struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read32(priv, reg) | mask;
+	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
+	_iwl_write32(priv, reg, val);
+}
+#define iwl_set_bit(p, r, m) __iwl_set_bit(__FILE__, __LINE__, p, r, m)
+#else
+#define iwl_set_bit(p, r, m) _iwl_set_bit(p, r, m)
+#endif
+
+static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_clear_bit(const char *f, u32 l,
+				   struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read32(priv, reg) & ~mask;
+	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
+	_iwl_write32(priv, reg, val);
+}
+#define iwl_clear_bit(p, r, m) __iwl_clear_bit(__FILE__, __LINE__, p, r, m)
+#else
+#define iwl_clear_bit(p, r, m) _iwl_clear_bit(p, r, m)
+#endif
+
+static inline int _iwl_grab_restricted_access(struct iwl_priv *priv)
+{
+	int rc;
+	u32 gp_ctl;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (atomic_read(&priv->restrict_refcnt))
+		return 0;
+#endif
+	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
+	    test_bit(STATUS_RF_KILL_SW, &priv->status)) {
+		IWL_WARNING("WARNING: Requesting MAC access during RFKILL "
+			"wakes up NIC\n");
+
+		/* 10 msec allows time for NIC to complete its data save */
+		gp_ctl = _iwl_read32(priv, CSR_GP_CNTRL);
+		if (gp_ctl & CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY) {
+			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
+				"gpctl = 0x%08x\n", gp_ctl);
+			mdelay(10);
+		} else
+			IWL_DEBUG_RF_KILL("power-down complete, "
+					  "gpctl = 0x%08x\n", gp_ctl);
+	}
+
+	/* this bit wakes up the NIC */
+	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	rc = _iwl_poll_bit(priv, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
+	if (rc < 0) {
+		IWL_ERROR("MAC is in deep sleep!\n");
+		return -EIO;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	atomic_inc(&priv->restrict_refcnt);
+#endif
+	return 0;
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_grab_restricted_access(const char *f, u32 l,
+					       struct iwl_priv *priv)
+{
+	if (atomic_read(&priv->restrict_refcnt))
+		IWL_DEBUG_INFO("Grabbing access while already held at "
+			       "line %d.\n", l);
+
+	IWL_DEBUG_IO("grabbing restricted access - %s %d\n", f, l);
+
+	return _iwl_grab_restricted_access(priv);
+}
+#define iwl_grab_restricted_access(priv) \
+	__iwl_grab_restricted_access(__FILE__, __LINE__, priv)
+#else
+#define iwl_grab_restricted_access(priv) \
+	_iwl_grab_restricted_access(priv)
+#endif
+
+static inline void _iwl_release_restricted_access(struct iwl_priv *priv)
+{
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (atomic_dec_and_test(&priv->restrict_refcnt))
+#endif
+		_iwl_clear_bit(priv, CSR_GP_CNTRL,
+			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_release_restricted_access(const char *f, u32 l,
+						   struct iwl_priv *priv)
+{
+	if (atomic_read(&priv->restrict_refcnt) <= 0)
+		IWL_ERROR("Release unheld restricted access at line %d.\n", l);
+
+	IWL_DEBUG_IO("releasing restricted access - %s %d\n", f, l);
+	_iwl_release_restricted_access(priv);
+}
+#define iwl_release_restricted_access(priv) \
+	__iwl_release_restricted_access(__FILE__, __LINE__, priv)
+#else
+#define iwl_release_restricted_access(priv) \
+	_iwl_release_restricted_access(priv)
+#endif
+
+static inline u32 _iwl_read_restricted(struct iwl_priv *priv, u32 reg)
+{
+	return _iwl_read32(priv, reg);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read_restricted(const char *f, u32 l,
+					struct iwl_priv *priv, u32 reg)
+{
+	u32 value = _iwl_read_restricted(priv, reg);
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from %s %d\n", f, l);
+	IWL_DEBUG_IO("read_restricted(0x%4X) = 0x%08x - %s %d \n", reg, value,
+		     f, l);
+	return value;
+}
+#define iwl_read_restricted(priv, reg) \
+	__iwl_read_restricted(__FILE__, __LINE__, priv, reg)
+#else
+#define iwl_read_restricted _iwl_read_restricted
+#endif
+
+static inline void _iwl_write_restricted(struct iwl_priv *priv,
+					 u32 reg, u32 value)
+{
+	_iwl_write32(priv, reg, value);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static void __iwl_write_restricted(u32 line,
+				   struct iwl_priv *priv, u32 reg, u32 value)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	_iwl_write_restricted(priv, reg, value);
+}
+#define iwl_write_restricted(priv, reg, value) \
+	__iwl_write_restricted(__LINE__, priv, reg, value)
+#else
+#define iwl_write_restricted _iwl_write_restricted
+#endif
+
+static inline void iwl_write_buffer_restricted(struct iwl_priv *priv,
+					       u32 reg, u32 len, u32 *values)
+{
+	u32 count = sizeof(u32);
+
+	if ((priv != NULL) && (values != NULL)) {
+		for (; 0 < len; len -= count, reg += count, values++)
+			_iwl_write_restricted(priv, reg, *values);
+	}
+}
+
+static inline int _iwl_poll_restricted_bit(struct iwl_priv *priv,
+					   u32 addr, u32 mask, int timeout)
+{
+	int i = 0;
+
+	do {
+		if ((_iwl_read_restricted(priv, addr) & mask) == mask)
+			return i;
+		mdelay(10);
+		i += 10;
+	} while (i < timeout);
+
+	return -ETIMEDOUT;
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
+					    struct iwl_priv *priv,
+					    u32 addr, u32 mask, int timeout)
+{
+	int rc = _iwl_poll_restricted_bit(priv, addr, mask, timeout);
+
+	if (unlikely(rc == -ETIMEDOUT))
+		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) - "
+			     "timedout - %s %d\n", addr, mask, f, l);
+	else
+		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) = 0x%08X "
+			     "- %s %d\n", addr, mask, rc, f, l);
+	return rc;
+}
+#define iwl_poll_restricted_bit(iwl, addr, mask, timeout) \
+	__iwl_poll_restricted_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
+#else
+#define iwl_poll_restricted_bit _iwl_poll_restricted_bit
+#endif
+
+static inline u32 _iwl_read_restricted_reg(struct iwl_priv *priv, u32 reg)
+{
+	_iwl_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	return _iwl_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read_restricted_reg(u32 line,
+					    struct iwl_priv *priv, u32 reg)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	return _iwl_read_restricted_reg(priv, reg);
+}
+
+#define iwl_read_restricted_reg(priv, reg) \
+	__iwl_read_restricted_reg(__LINE__, priv, reg)
+#else
+#define iwl_read_restricted_reg _iwl_read_restricted_reg
+#endif
+
+static inline void _iwl_write_restricted_reg(struct iwl_priv *priv,
+					     u32 addr, u32 val)
+{
+	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WADDR,
+			      ((addr & 0x0000FFFF) | (3 << 24)));
+	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_write_restricted_reg(u32 line,
+					      struct iwl_priv *priv,
+					      u32 addr, u32 val)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	_iwl_write_restricted_reg(priv, addr, val);
+}
+
+#define iwl_write_restricted_reg(priv, addr, val) \
+	__iwl_write_restricted_reg(__LINE__, priv, addr, val);
+#else
+#define iwl_write_restricted_reg _iwl_write_restricted_reg
+#endif
+
+#define _iwl_set_bits_restricted_reg(priv, reg, mask) \
+	_iwl_write_restricted_reg(priv, reg, \
+				  (_iwl_read_restricted_reg(priv, reg) | mask))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bits_restricted_reg(u32 line, struct iwl_priv
+						 *priv, u32 reg, u32 mask)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	_iwl_set_bits_restricted_reg(priv, reg, mask);
+}
+#define iwl_set_bits_restricted_reg(priv, reg, mask) \
+	__iwl_set_bits_restricted_reg(__LINE__, priv, reg, mask)
+#else
+#define iwl_set_bits_restricted_reg _iwl_set_bits_restricted_reg
+#endif
+
+#define _iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
+	_iwl_write_restricted_reg( \
+	    priv, reg, ((_iwl_read_restricted_reg(priv, reg) & mask) | bits))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bits_mask_restricted_reg(u32 line,
+		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	_iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask);
+}
+
+#define iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
+	__iwl_set_bits_mask_restricted_reg(__LINE__, priv, reg, bits, mask)
+#else
+#define iwl_set_bits_mask_restricted_reg _iwl_set_bits_mask_restricted_reg
+#endif
+
+static inline void iwl_clear_bits_restricted_reg(struct iwl_priv
+						 *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read_restricted_reg(priv, reg);
+	_iwl_write_restricted_reg(priv, reg, (val & ~mask));
+}
+
+static inline u32 iwl_read_restricted_mem(struct iwl_priv *priv, u32 addr)
+{
+	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, addr);
+	return iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+}
+
+static inline void iwl_write_restricted_mem(struct iwl_priv *priv, u32 addr,
+					    u32 val)
+{
+	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
+	iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, val);
+}
+
+static inline void iwl_write_restricted_mems(struct iwl_priv *priv, u32 addr,
+					     u32 len, u32 *values)
+{
+	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
+	for (; 0 < len; len -= sizeof(u32), values++)
+		iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, *values);
+}
+
+static inline void iwl_write_restricted_regs(struct iwl_priv *priv, u32 reg,
+					     u32 len, u8 *values)
+{
+	u32 reg_offset = reg;
+	u32 aligment = reg & 0x3;
+
+	/* write any non-dword-aligned stuff at the beginning */
+	if (len < sizeof(u32)) {
+		if ((aligment + len) <= sizeof(u32)) {
+			u8 size;
+			u32 value = 0;
+			size = len - 1;
+			memcpy(&value, values, len);
+			reg_offset = (reg_offset & 0x0000FFFF);
+
+			_iwl_write_restricted(priv,
+					      HBUS_TARG_PRPH_WADDR,
+					      (reg_offset | (size << 24)));
+			_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT,
+					      value);
+		}
+
+		return;
+	}
+
+	/* now write all the dword-aligned stuff */
+	for (; reg_offset < (reg + len);
+	     reg_offset += sizeof(u32), values += sizeof(u32))
+		_iwl_write_restricted_reg(priv, reg_offset, *((u32 *) values));
+}
+
+#endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-debug.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-debug.h	2007-10-12 12:06:37.000000000 +0200
@@ -0,0 +1,152 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2007 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#ifndef __iwl_debug_h__
+#define __iwl_debug_h__
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+extern u32 iwl_debug_level;
+#define IWL_DEBUG(level, fmt, args...) \
+do { if (iwl_debug_level & (level)) \
+  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
+	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+
+#define IWL_DEBUG_LIMIT(level, fmt, args...) \
+do { if ((iwl_debug_level & (level)) && net_ratelimit()) \
+  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
+	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+#else
+static inline void IWL_DEBUG(int level, const char *fmt, ...)
+{
+}
+static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
+{
+}
+#endif				/* CONFIG_IWLWIFI_DEBUG */
+
+/*
+ * To use the debug system;
+ *
+ * If you are defining a new debug classification, simply add it to the #define
+ * list here in the form of:
+ *
+ * #define IWL_DL_xxxx VALUE
+ *
+ * shifting value to the left one bit from the previous entry.  xxxx should be
+ * the name of the classification (for example, WEP)
+ *
+ * You then need to either add a IWL_xxxx_DEBUG() macro definition for your
+ * classification, or use IWL_DEBUG(IWL_DL_xxxx, ...) whenever you want
+ * to send output to that classification.
+ *
+ * To add your debug level to the list of levels seen when you perform
+ *
+ * % cat /proc/net/iwl/debug_level
+ *
+ * you simply need to add your entry to the iwl_debug_levels array.
+ *
+ * If you do not see debug_level in /proc/net/iwl then you do not have
+ * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
+ *
+ */
+
+#define IWL_DL_INFO          (1<<0)
+#define IWL_DL_MAC80211      (1<<1)
+#define IWL_DL_HOST_COMMAND  (1<<2)
+#define IWL_DL_STATE         (1<<3)
+
+#define IWL_DL_RADIO         (1<<7)
+#define IWL_DL_POWER         (1<<8)
+#define IWL_DL_TEMP          (1<<9)
+
+#define IWL_DL_NOTIF         (1<<10)
+#define IWL_DL_SCAN          (1<<11)
+#define IWL_DL_ASSOC         (1<<12)
+#define IWL_DL_DROP          (1<<13)
+
+#define IWL_DL_TXPOWER       (1<<14)
+
+#define IWL_DL_AP            (1<<15)
+
+#define IWL_DL_FW            (1<<16)
+#define IWL_DL_RF_KILL       (1<<17)
+#define IWL_DL_FW_ERRORS     (1<<18)
+
+#define IWL_DL_LED           (1<<19)
+
+#define IWL_DL_RATE          (1<<20)
+
+#define IWL_DL_CALIB         (1<<21)
+#define IWL_DL_WEP           (1<<22)
+#define IWL_DL_TX            (1<<23)
+#define IWL_DL_RX            (1<<24)
+#define IWL_DL_ISR           (1<<25)
+#define IWL_DL_HT            (1<<26)
+#define IWL_DL_IO            (1<<27)
+#define IWL_DL_11H           (1<<28)
+
+#define IWL_DL_STATS         (1<<29)
+#define IWL_DL_TX_REPLY      (1<<30)
+#define IWL_DL_QOS           (1<<31)
+
+#define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
+#define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
+#define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
+
+#define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
+#define IWL_DEBUG_TEMP(f, a...)   IWL_DEBUG(IWL_DL_TEMP, f, ## a)
+#define IWL_DEBUG_SCAN(f, a...)   IWL_DEBUG(IWL_DL_SCAN, f, ## a)
+#define IWL_DEBUG_RX(f, a...)     IWL_DEBUG(IWL_DL_RX, f, ## a)
+#define IWL_DEBUG_TX(f, a...)     IWL_DEBUG(IWL_DL_TX, f, ## a)
+#define IWL_DEBUG_ISR(f, a...)    IWL_DEBUG(IWL_DL_ISR, f, ## a)
+#define IWL_DEBUG_LED(f, a...) IWL_DEBUG(IWL_DL_LED, f, ## a)
+#define IWL_DEBUG_WEP(f, a...)    IWL_DEBUG(IWL_DL_WEP, f, ## a)
+#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HOST_COMMAND, f, ## a)
+#define IWL_DEBUG_CALIB(f, a...) IWL_DEBUG(IWL_DL_CALIB, f, ## a)
+#define IWL_DEBUG_FW(f, a...) IWL_DEBUG(IWL_DL_FW, f, ## a)
+#define IWL_DEBUG_RF_KILL(f, a...) IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
+#define IWL_DEBUG_DROP(f, a...) IWL_DEBUG(IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_DROP_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
+#define IWL_DEBUG_AP(f, a...) IWL_DEBUG(IWL_DL_AP, f, ## a)
+#define IWL_DEBUG_TXPOWER(f, a...) IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
+#define IWL_DEBUG_IO(f, a...) IWL_DEBUG(IWL_DL_IO, f, ## a)
+#define IWL_DEBUG_RATE(f, a...) IWL_DEBUG(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_RATE_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
+#define IWL_DEBUG_NOTIF(f, a...) IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
+#define IWL_DEBUG_ASSOC(f, a...) IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_ASSOC_LIMIT(f, a...) \
+	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
+#define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
+#define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
+#define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
+#define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
+#define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
+#define IWL_DEBUG_POWER(f, a...)  IWL_DEBUG(IWL_DL_POWER, f, ## a)
+#define IWL_DEBUG_11H(f, a...)  IWL_DEBUG(IWL_DL_11H, f, ## a)
+
+#endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-4965-hw.h	2007-10-12 11:24:17.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-hw.h	2007-10-12 11:38:20.000000000 +0200
@@ -64,6 +64,2186 @@
 #ifndef __iwl_4965_hw_h__
 #define __iwl_4965_hw_h__
 
+/* uCode queue management definitions */
+#define IWL_CMD_QUEUE_NUM       4
+#define IWL_CMD_FIFO_NUM        4
+#define IWL_BACK_QUEUE_FIRST_ID 7
+
+/* Tx rates */
+#define IWL_CCK_RATES 4
+#define IWL_OFDM_RATES 8
+#define IWL_HT_RATES 16
+
+#define IWL_MAX_RATES  (IWL_CCK_RATES+IWL_OFDM_RATES+IWL_HT_RATES)
+
+/* Time constants */
+#define SHORT_SLOT_TIME 9
+#define LONG_SLOT_TIME 20
+
+/* RSSI to dBm */
+#define IWL_RSSI_OFFSET	44
+
+#define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
+#define IWL_EEPROM_ACCESS_DELAY		10   /* uSec */
+/* EEPROM field values */
+#define ANTENNA_SWITCH_NORMAL     0
+#define ANTENNA_SWITCH_INVERSE    1
+
+enum {
+	EEPROM_CHANNEL_VALID = (1 << 0),	/* usable for this SKU/geo */
+	EEPROM_CHANNEL_IBSS = (1 << 1),	/* usable as an IBSS channel */
+	/* Bit 2 Reserved */
+	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
+	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
+	EEPROM_CHANNEL_WIDE = (1 << 5),
+	EEPROM_CHANNEL_NARROW = (1 << 6),
+	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
+};
+
+/* EEPROM field lengths */
+#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
+
+/* EEPROM field lengths */
+#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
+#define EEPROM_REGULATORY_SKU_ID_LENGTH                 4
+#define EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH         14
+#define EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH         13
+#define EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH         12
+#define EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH         11
+#define EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH         6
+
+#define EEPROM_REGULATORY_BAND_24_FAT_CHANNELS_LENGTH 7
+#define EEPROM_REGULATORY_BAND_52_FAT_CHANNELS_LENGTH 11
+#define EEPROM_REGULATORY_CHANNELS_LENGTH ( \
+	EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND_24_FAT_CHANNELS_LENGTH + \
+	EEPROM_REGULATORY_BAND_52_FAT_CHANNELS_LENGTH)
+
+#define EEPROM_REGULATORY_NUMBER_OF_BANDS               5
+
+/* SKU Capabilities */
+#define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
+#define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
+#define EEPROM_SKU_CAP_OP_MODE_MRC                      (1 << 7)
+
+/* *regulatory* channel data from eeprom, one for each channel */
+struct iwl_eeprom_channel {
+	u8 flags;		/* flags copied from EEPROM */
+	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
+} __attribute__ ((packed));
+
+/*
+ * Mapping of a Tx power level, at factory calibration temperature,
+ *   to a radio/DSP gain table index.
+ * One for each of 5 "sample" power levels in each band.
+ * v_det is measured at the factory, using the 3945's built-in power amplifier
+ *   (PA) output voltage detector.  This same detector is used during Tx of
+ *   long packets in normal operation to provide feedback as to proper output
+ *   level.
+ * Data copied from EEPROM.
+ */
+struct iwl_eeprom_txpower_sample {
+	u8 gain_index;		/* index into power (gain) setup table ... */
+	s8 power;		/* ... for this pwr level for this chnl group */
+	u16 v_det;		/* PA output voltage */
+} __attribute__ ((packed));
+
+/*
+ * Mappings of Tx power levels -> nominal radio/DSP gain table indexes.
+ * One for each channel group (a.k.a. "band") (1 for BG, 4 for A).
+ * Tx power setup code interpolates between the 5 "sample" power levels
+ *    to determine the nominal setup for a requested power level.
+ * Data copied from EEPROM.
+ * DO NOT ALTER THIS STRUCTURE!!!
+ */
+struct iwl_eeprom_txpower_group {
+	struct iwl_eeprom_txpower_sample samples[5];	/* 5 power levels */
+	s32 a, b, c, d, e;	/* coefficients for voltage->power
+				 * formula (signed) */
+	s32 Fa, Fb, Fc, Fd, Fe;	/* these modify coeffs based on
+					 * frequency (signed) */
+	s8 saturation_power;	/* highest power possible by h/w in this
+				 * band */
+	u8 group_channel;	/* "representative" channel # in this band */
+	s16 temperature;	/* h/w temperature at factory calib this band
+				 * (signed) */
+} __attribute__ ((packed));
+
+/*
+ * Temperature-based Tx-power compensation data, not band-specific.
+ * These coefficients are use to modify a/b/c/d/e coeffs based on
+ *   difference between current temperature and factory calib temperature.
+ * Data copied from EEPROM.
+ */
+struct iwl_eeprom_temperature_corr {
+	u32 Ta;
+	u32 Tb;
+	u32 Tc;
+	u32 Td;
+	u32 Te;
+} __attribute__ ((packed));
+
+#define EEPROM_TX_POWER_TX_CHAINS      (2)
+#define EEPROM_TX_POWER_BANDS          (8)
+#define EEPROM_TX_POWER_MEASUREMENTS   (3)
+#define EEPROM_TX_POWER_VERSION        (2)
+#define EEPROM_TX_POWER_VERSION_NEW    (5)
+
+struct iwl_eeprom_calib_measure {
+	u8 temperature;
+	u8 gain_idx;
+	u8 actual_pow;
+	s8 pa_det;
+} __attribute__ ((packed));
+
+struct iwl_eeprom_calib_ch_info {
+	u8 ch_num;
+	struct iwl_eeprom_calib_measure measurements[EEPROM_TX_POWER_TX_CHAINS]
+		[EEPROM_TX_POWER_MEASUREMENTS];
+} __attribute__ ((packed));
+
+struct iwl_eeprom_calib_subband_info {
+	u8 ch_from;
+	u8 ch_to;
+	struct iwl_eeprom_calib_ch_info ch1;
+	struct iwl_eeprom_calib_ch_info ch2;
+} __attribute__ ((packed));
+
+struct iwl_eeprom_calib_info {
+	u8 saturation_power24;
+	u8 saturation_power52;
+	s16 voltage;		/* signed */
+	struct iwl_eeprom_calib_subband_info band_info[EEPROM_TX_POWER_BANDS];
+} __attribute__ ((packed));
+
+
+struct iwl_eeprom {
+	u8 reserved0[16];
+#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
+	u16 device_id;	/* abs.ofs: 16 */
+	u8 reserved1[2];
+#define EEPROM_PMC                          (2*0x0A)	/* 2 bytes */
+	u16 pmc;		/* abs.ofs: 20 */
+	u8 reserved2[20];
+#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
+	u8 mac_address[6];	/* abs.ofs: 42 */
+	u8 reserved3[58];
+#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
+	u16 board_revision;	/* abs.ofs: 106 */
+	u8 reserved4[11];
+#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
+	u8 board_pba_number[9];	/* abs.ofs: 119 */
+	u8 reserved5[8];
+#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
+	u16 version;		/* abs.ofs: 136 */
+#define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
+	u8 sku_cap;		/* abs.ofs: 138 */
+#define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
+	u8 leds_mode;		/* abs.ofs: 139 */
+#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
+	u16 oem_mode;
+#define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
+	u16 wowlan_mode;	/* abs.ofs: 142 */
+#define EEPROM_LEDS_TIME_INTERVAL           (2*0x48)	/* 2  bytes */
+	u16 leds_time_interval;	/* abs.ofs: 144 */
+#define EEPROM_LEDS_OFF_TIME                (2*0x49)	/* 1  bytes */
+	u8 leds_off_time;	/* abs.ofs: 146 */
+#define EEPROM_LEDS_ON_TIME                 (2*0x49+1)	/* 1  bytes */
+	u8 leds_on_time;	/* abs.ofs: 147 */
+#define EEPROM_ALMGOR_M_VERSION             (2*0x4A)	/* 1  bytes */
+	u8 almgor_m_version;	/* abs.ofs: 148 */
+#define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
+	u8 antenna_switch_type;	/* abs.ofs: 149 */
+	u8 reserved6[8];
+#define EEPROM_4965_BOARD_REVISION          (2*0x4F)	/* 2 bytes */
+	u16 board_revision_4965;	/* abs.ofs: 158 */
+	u8 reserved7[13];
+#define EEPROM_4965_BOARD_PBA               (2*0x56+1)	/* 9 bytes */
+	u8 board_pba_number_4965[9];	/* abs.ofs: 173 */
+	u8 reserved8[10];
+#define EEPROM_REGULATORY_SKU_ID            (2*0x60)	/* 4  bytes */
+	u8 sku_id[4];		/* abs.ofs: 192 */
+#define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
+	u16 band_1_count;	/* abs.ofs: 196 */
+#define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
+	struct iwl_eeprom_channel band_1_channels[14];	/* abs.ofs: 196 */
+#define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
+	u16 band_2_count;	/* abs.ofs: 226 */
+#define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
+	struct iwl_eeprom_channel band_2_channels[13];	/* abs.ofs: 228 */
+#define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
+	u16 band_3_count;	/* abs.ofs: 254 */
+#define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
+	struct iwl_eeprom_channel band_3_channels[12];	/* abs.ofs: 256 */
+#define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
+	u16 band_4_count;	/* abs.ofs: 280 */
+#define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
+	struct iwl_eeprom_channel band_4_channels[11];	/* abs.ofs: 282 */
+#define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
+	u16 band_5_count;	/* abs.ofs: 304 */
+#define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
+	struct iwl_eeprom_channel band_5_channels[6];	/* abs.ofs: 306 */
+
+	u8 reserved10[2];
+#define EEPROM_REGULATORY_BAND_24_FAT_CHANNELS (2*0xA0)	/* 14 bytes */
+	struct iwl_eeprom_channel band_24_channels[7];	/* abs.ofs: 320 */
+	u8 reserved11[2];
+#define EEPROM_REGULATORY_BAND_52_FAT_CHANNELS (2*0xA8)	/* 22 bytes */
+	struct iwl_eeprom_channel band_52_channels[11];	/* abs.ofs: 336 */
+	u8 reserved12[6];
+#define EEPROM_CALIB_VERSION_OFFSET            (2*0xB6)	/* 2 bytes */
+	u16 calib_version;	/* abs.ofs: 364 */
+	u8 reserved13[2];
+#define EEPROM_SATURATION_POWER_OFFSET         (2*0xB8)	/* 2 bytes */
+	u16 satruation_power;	/* abs.ofs: 368 */
+	u8 reserved14[94];
+#define EEPROM_IWL_CALIB_TXPOWER_OFFSET        (2*0xE8)	/* 48  bytes */
+	struct iwl_eeprom_calib_info calib_info;	/* abs.ofs: 464 */
+
+	u8 reserved16[140];	/* fill out to full 1024 byte block */
+} __attribute__ ((packed));
+
+#define IWL_EEPROM_IMAGE_SIZE 1024
+
+enum {
+	REPLY_ALIVE = 0x1,
+	REPLY_ERROR = 0x2,
+
+	/* RXON and QOS commands */
+	REPLY_RXON = 0x10,
+	REPLY_RXON_ASSOC = 0x11,
+	REPLY_QOS_PARAM = 0x13,
+	REPLY_RXON_TIMING = 0x14,
+
+	/* Multi-Station support */
+	REPLY_ADD_STA = 0x18,
+	REPLY_REMOVE_STA = 0x19,	/* not used */
+	REPLY_REMOVE_ALL_STA = 0x1a,	/* not used */
+
+	/* RX, TX, LEDs */
+	REPLY_TX = 0x1c,
+	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
+	REPLY_LEDS_CMD = 0x48,
+	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* 4965 only */
+
+	/* 802.11h related */
+	RADAR_NOTIFICATION = 0x70,	/* not used */
+	REPLY_QUIET_CMD = 0x71,		/* not used */
+	REPLY_CHANNEL_SWITCH = 0x72,
+	CHANNEL_SWITCH_NOTIFICATION = 0x73,
+	REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74,
+	SPECTRUM_MEASURE_NOTIFICATION = 0x75,
+
+	/* Power Management */
+	POWER_TABLE_CMD = 0x77,
+	PM_SLEEP_NOTIFICATION = 0x7A,
+	PM_DEBUG_STATISTIC_NOTIFIC = 0x7B,
+
+	/* Scan commands and notifications */
+	REPLY_SCAN_CMD = 0x80,
+	REPLY_SCAN_ABORT_CMD = 0x81,
+	SCAN_START_NOTIFICATION = 0x82,
+	SCAN_RESULTS_NOTIFICATION = 0x83,
+	SCAN_COMPLETE_NOTIFICATION = 0x84,
+
+	/* IBSS/AP commands */
+	BEACON_NOTIFICATION = 0x90,
+	REPLY_TX_BEACON = 0x91,
+	WHO_IS_AWAKE_NOTIFICATION = 0x94,	/* not used */
+
+	/* Miscellaneous commands */
+	QUIET_NOTIFICATION = 0x96,		/* not used */
+	REPLY_TX_PWR_TABLE_CMD = 0x97,
+	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
+
+	/* BT config command */
+	REPLY_BT_CONFIG = 0x9b,
+
+	/* 4965 Statistics */
+	REPLY_STATISTICS_CMD = 0x9c,
+	STATISTICS_NOTIFICATION = 0x9d,
+
+	/* RF-KILL commands and notifications */
+	REPLY_CARD_STATE_CMD = 0xa0,
+	CARD_STATE_NOTIFICATION = 0xa1,
+
+	/* Missed beacons notification */
+	MISSED_BEACONS_NOTIFICATION = 0xa2,
+
+	REPLY_CT_KILL_CONFIG_CMD = 0xa4,
+	SENSITIVITY_CMD = 0xa8,
+	REPLY_PHY_CALIBRATION_CMD = 0xb0,
+	REPLY_RX_PHY_CMD = 0xc0,
+	REPLY_RX_MPDU_CMD = 0xc1,
+	REPLY_4965_RX = 0xc3,
+	REPLY_COMPRESSED_BA = 0xc5,
+
+	REPLY_MAX = 0xff
+};
+
+/******************************************************************************
+ * (0)
+ * Header
+ *
+ *****************************************************************************/
+
+#define IWL_CMD_FAILED_MSK 0x40
+
+struct iwl_cmd_header {
+	u8 cmd;
+	u8 flags;
+	/* We have 15 LSB to use as we please (MSB indicates
+	 * a frame Rx'd from the HW).  We encode the following
+	 * information into the sequence field:
+	 *
+	 *  0:7    index in fifo
+	 *  8:13   fifo selection
+	 * 14:14   bit indicating if this packet references the 'extra'
+	 *         storage at the end of the memory queue
+	 * 15:15   (Rx indication)
+	 *
+	 */
+	__le16 sequence;
+
+	/* command data follows immediately */
+	u8 data[0];
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (0a)
+ * Alive and Error Commands & Responses:
+ *
+ *****************************************************************************/
+
+#define UCODE_VALID_OK	__constant_cpu_to_le32(0x1)
+#define INITIALIZE_SUBTYPE    (9)
+
+/*
+ * REPLY_ALIVE = 0x1 (response only, not a command)
+ */
+struct iwl_alive_resp {
+	u8 ucode_minor;
+	u8 ucode_major;
+	__le16 reserved1;
+	u8 sw_rev[8];
+	u8 ver_type;
+	u8 ver_subtype;
+	__le16 reserved2;
+	__le32 log_event_table_ptr;
+	__le32 error_event_table_ptr;
+	__le32 timestamp;
+	__le32 is_valid;
+} __attribute__ ((packed));
+
+struct iwl_init_alive_resp {
+	u8 ucode_minor;
+	u8 ucode_major;
+	__le16 reserved1;
+	u8 sw_rev[8];
+	u8 ver_type;
+	u8 ver_subtype;
+	__le16 reserved2;
+	__le32 log_event_table_ptr;
+	__le32 error_event_table_ptr;
+	__le32 timestamp;
+	__le32 is_valid;
+
+	/* calibration values from "initialize" uCode */
+	__le32 voltage;		/* signed */
+	__le32 therm_r1[2];	/* signed 1st for normal, 2nd for FAT channel */
+	__le32 therm_r2[2];	/* signed */
+	__le32 therm_r3[2];	/* signed */
+	__le32 therm_r4[2];	/* signed */
+	__le32 tx_atten[5][2];	/* signed MIMO gain comp, 5 freq groups,
+				 * 2 Tx chains */
+} __attribute__ ((packed));
+
+union tsf {
+	u8 byte[8];
+	__le16 word[4];
+	__le32 dw[2];
+};
+
+/*
+ * REPLY_ERROR = 0x2 (response only, not a command)
+ */
+struct iwl_error_resp {
+	__le32 error_type;
+	u8 cmd_id;
+	u8 reserved1;
+	__le16 bad_cmd_seq_num;
+	__le32 error_info;
+	union tsf timestamp;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (1)
+ * RXON Commands & Responses:
+ *
+ *****************************************************************************/
+
+/*
+ * Rx config defines & structure
+ */
+/* rx_config device types  */
+enum {
+	RXON_DEV_TYPE_AP = 1,
+	RXON_DEV_TYPE_ESS = 3,
+	RXON_DEV_TYPE_IBSS = 4,
+	RXON_DEV_TYPE_SNIFFER = 6,
+};
+
+/* rx_config flags */
+/* band & modulation selection */
+#define RXON_FLG_BAND_24G_MSK           __constant_cpu_to_le32(1 << 0)
+#define RXON_FLG_CCK_MSK                __constant_cpu_to_le32(1 << 1)
+/* auto detection enable */
+#define RXON_FLG_AUTO_DETECT_MSK        __constant_cpu_to_le32(1 << 2)
+/* TGg protection when tx */
+#define RXON_FLG_TGG_PROTECT_MSK        __constant_cpu_to_le32(1 << 3)
+/* cck short slot & preamble */
+#define RXON_FLG_SHORT_SLOT_MSK          __constant_cpu_to_le32(1 << 4)
+#define RXON_FLG_SHORT_PREAMBLE_MSK     __constant_cpu_to_le32(1 << 5)
+/* antenna selection */
+#define RXON_FLG_DIS_DIV_MSK            __constant_cpu_to_le32(1 << 7)
+#define RXON_FLG_ANT_SEL_MSK            __constant_cpu_to_le32(0x0f00)
+#define RXON_FLG_ANT_A_MSK              __constant_cpu_to_le32(1 << 8)
+#define RXON_FLG_ANT_B_MSK              __constant_cpu_to_le32(1 << 9)
+/* radar detection enable */
+#define RXON_FLG_RADAR_DETECT_MSK       __constant_cpu_to_le32(1 << 12)
+#define RXON_FLG_TGJ_NARROW_BAND_MSK    __constant_cpu_to_le32(1 << 13)
+/* rx response to host with 8-byte TSF
+* (according to ON_AIR deassertion) */
+#define RXON_FLG_TSF2HOST_MSK           __constant_cpu_to_le32(1 << 15)
+
+/* rx_config filter flags */
+/* accept all data frames */
+#define RXON_FILTER_PROMISC_MSK         __constant_cpu_to_le32(1 << 0)
+/* pass control & management to host */
+#define RXON_FILTER_CTL2HOST_MSK        __constant_cpu_to_le32(1 << 1)
+/* accept multi-cast */
+#define RXON_FILTER_ACCEPT_GRP_MSK      __constant_cpu_to_le32(1 << 2)
+/* don't decrypt uni-cast frames */
+#define RXON_FILTER_DIS_DECRYPT_MSK     __constant_cpu_to_le32(1 << 3)
+/* don't decrypt multi-cast frames */
+#define RXON_FILTER_DIS_GRP_DECRYPT_MSK __constant_cpu_to_le32(1 << 4)
+/* STA is associated */
+#define RXON_FILTER_ASSOC_MSK           __constant_cpu_to_le32(1 << 5)
+/* transfer to host non bssid beacons in associated state */
+#define RXON_FILTER_BCON_AWARE_MSK      __constant_cpu_to_le32(1 << 6)
+
+/*
+ * REPLY_RXON = 0x10 (command, has simple generic response)
+ */
+struct iwl_rxon_cmd {
+	u8 node_addr[6];
+	__le16 reserved1;
+	u8 bssid_addr[6];
+	__le16 reserved2;
+	u8 wlap_bssid_addr[6];
+	__le16 reserved3;
+	u8 dev_type;
+	u8 air_propagation;
+	__le16 rx_chain;
+	u8 ofdm_basic_rates;
+	u8 cck_basic_rates;
+	__le16 assoc_id;
+	__le32 flags;
+	__le32 filter_flags;
+	__le16 channel;
+	u8 ofdm_ht_single_stream_basic_rates;
+	u8 ofdm_ht_dual_stream_basic_rates;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
+ */
+struct iwl_rxon_assoc_cmd {
+	__le32 flags;
+	__le32 filter_flags;
+	u8 ofdm_basic_rates;
+	u8 cck_basic_rates;
+	u8 ofdm_ht_single_stream_basic_rates;
+	u8 ofdm_ht_dual_stream_basic_rates;
+	__le16 rx_chain_select_flags;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
+ */
+struct iwl_rxon_time_cmd {
+	union tsf timestamp;
+	__le16 beacon_interval;
+	__le16 atim_window;
+	__le32 beacon_init_val;
+	__le16 listen_interval;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+struct iwl_tx_power {
+	u8 tx_gain;		/* gain for analog radio */
+	u8 dsp_atten;		/* gain for DSP */
+} __attribute__ ((packed));
+
+#define POWER_TABLE_NUM_ENTRIES			33
+#define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
+#define POWER_TABLE_CCK_ENTRY			32
+struct tx_power_dual_stream {
+	__le32 dw;
+} __attribute__ ((packed));
+
+struct iwl_tx_power_db {
+	struct tx_power_dual_stream power_tbl[POWER_TABLE_NUM_ENTRIES];
+} __attribute__ ((packed));
+
+/*
+ * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
+ */
+struct iwl_channel_switch_cmd {
+	u8 band;
+	u8 expect_beacon;
+	__le16 channel;
+	__le32 rxon_flags;
+	__le32 rxon_filter_flags;
+	__le32 switch_time;
+	struct iwl_tx_power_db tx_power;
+} __attribute__ ((packed));
+
+/*
+ * CHANNEL_SWITCH_NOTIFICATION = 0x73 (notification only, not a command)
+ */
+struct iwl_csa_notification {
+	__le16 band;
+	__le16 channel;
+	__le32 status;		/* 0 - OK, 1 - fail */
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (2)
+ * Quality-of-Service (QOS) Commands & Responses:
+ *
+ *****************************************************************************/
+struct iwl_ac_qos {
+	__le16 cw_min;
+	__le16 cw_max;
+	u8 aifsn;
+	u8 reserved1;
+	__le16 edca_txop;
+} __attribute__ ((packed));
+
+/* QoS flags defines */
+#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	__constant_cpu_to_le32(0x01)
+#define QOS_PARAM_FLG_TGN_MSK		__constant_cpu_to_le32(0x02)
+#define QOS_PARAM_FLG_TXOP_TYPE_MSK	__constant_cpu_to_le32(0x10)
+
+/*
+ *  TXFIFO Queue number defines
+ */
+/* number of Access categories (AC) (EDCA), queues 0..3 */
+#define AC_NUM                4
+
+/*
+ * REPLY_QOS_PARAM = 0x13 (command, has simple generic response)
+ */
+struct iwl_qosparam_cmd {
+	__le32 qos_flags;
+	struct iwl_ac_qos ac[AC_NUM];
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (3)
+ * Add/Modify Stations Commands & Responses:
+ *
+ *****************************************************************************/
+/*
+ * Multi station support
+ */
+#define	IWL_AP_ID		0
+#define IWL_MULTICAST_ID	1
+#define	IWL_STA_ID		2
+
+#define	IWL3945_BROADCAST_ID	24
+#define IWL3945_STATION_COUNT	25
+
+#define IWL4965_BROADCAST_ID	31
+#define	IWL4965_STATION_COUNT	32
+
+#define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
+#define	IWL_INVALID_STATION 	255
+
+#define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1<<8);
+
+#define STA_CONTROL_MODIFY_MSK		0x01
+
+/* key flags __le16*/
+#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x7)
+#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0)
+#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x1)
+#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x2)
+#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x3)
+
+#define STA_KEY_FLG_KEYID_POS	8
+#define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
+
+/* modify flags  */
+#define	STA_MODIFY_KEY_MASK		0x01
+#define	STA_MODIFY_TID_DISABLE_TX	0x02
+#define	STA_MODIFY_TX_RATE_MSK		0x04
+#define STA_MODIFY_ADDBA_TID_MSK	0x08
+#define STA_MODIFY_DELBA_TID_MSK	0x10
+#define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
+
+/*
+ * Antenna masks:
+ * bit14:15 01 B inactive, A active
+ *          10 B active, A inactive
+ *          11 Both active
+ */
+#define RATE_MCS_ANT_A_POS	14
+#define RATE_MCS_ANT_B_POS	15
+#define RATE_MCS_ANT_A_MSK	0x4000
+#define RATE_MCS_ANT_B_MSK	0x8000
+#define RATE_MCS_ANT_AB_MSK	0xc000
+
+struct iwl_keyinfo {
+	__le16 key_flags;
+	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
+	u8 reserved1;
+	__le16 tkip_rx_ttak[5];	/* 10-byte unicast TKIP TTAK */
+	__le16 reserved2;
+	u8 key[16];		/* 16-byte unicast decryption key */
+} __attribute__ ((packed));
+
+struct sta_id_modify {
+	u8 addr[ETH_ALEN];
+	__le16 reserved1;
+	u8 sta_id;
+	u8 modify_mask;
+	__le16 reserved2;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_ADD_STA = 0x18 (command)
+ */
+struct iwl_addsta_cmd {
+	u8 mode;
+	u8 reserved[3];
+	struct sta_id_modify sta;
+	struct iwl_keyinfo key;
+	__le32 station_flags;
+	__le32 station_flags_msk;
+	__le16 tid_disable_tx;
+	__le16	reserved1;
+	u8 add_immediate_ba_tid;
+	u8 remove_immediate_ba_tid;
+	__le16 add_immediate_ba_ssn;
+	__le32 reserved2;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_ADD_STA = 0x18 (response)
+ */
+struct iwl_add_sta_resp {
+	u8 status;
+} __attribute__ ((packed));
+
+#define ADD_STA_SUCCESS_MSK              0x1
+
+/******************************************************************************
+ * (4)
+ * Rx Responses:
+ *
+ *****************************************************************************/
+
+struct iwl_rx_frame_stats {
+	u8 phy_count;
+	u8 id;
+	u8 rssi;
+	u8 agc;
+	__le16 sig_avg;
+	__le16 noise_diff;
+	u8 payload[0];
+} __attribute__ ((packed));
+
+struct iwl_rx_frame_hdr {
+	__le16 channel;
+	__le16 phy_flags;
+	u8 reserved1;
+	u8 rate;
+	__le16 len;
+	u8 payload[0];
+} __attribute__ ((packed));
+
+#define	RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
+#define	RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
+
+#define	RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
+#define	RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
+#define	RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
+#define	RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
+#define	RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
+
+#define	RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
+#define	RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
+
+#define	RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
+#define	RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
+#define	RX_RES_STATUS_DECRYPT_OK	(0x3 << 11)
+#define	RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
+#define	RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
+
+struct iwl_rx_frame_end {
+	__le32 status;
+	__le64 timestamp;
+	__le32 beacon_timestamp;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_3945_RX = 0x1b (response only, not a command)
+ *
+ * NOTE:  DO NOT dereference from casts to this structure
+ * It is provided only for calculating minimum data set size.
+ * The actual offsets of the hdr and end are dynamic based on
+ * stats.phy_count
+ */
+struct iwl_rx_frame {
+	struct iwl_rx_frame_stats stats;
+	struct iwl_rx_frame_hdr hdr;
+	struct iwl_rx_frame_end end;
+} __attribute__ ((packed));
+
+/* Fixed (non-configurable) rx data from phy */
+#define RX_PHY_FLAGS_ANTENNAE_OFFSET		(4)
+#define RX_PHY_FLAGS_ANTENNAE_MASK		(0x70)
+#define IWL_AGC_DB_MASK 	(0x3f80)	/* MASK(7,13) */
+#define IWL_AGC_DB_POS		(7)
+struct iwl4965_rx_non_cfg_phy {
+	__le16 ant_selection;	/* ant A bit 4, ant B bit 5, ant C bit 6 */
+	__le16 agc_info;	/* agc code 0:6, agc dB 7:13, reserved 14:15 */
+	u8 rssi_info[6];	/* we use even entries, 0/2/4 for A/B/C rssi */
+	u8 pad[0];
+} __attribute__ ((packed));
+
+/*
+ * REPLY_4965_RX = 0xc3 (response only, not a command)
+ * Used only for legacy (non 11n) frames.
+ */
+#define RX_RES_PHY_CNT 14
+struct iwl4965_rx_phy_res {
+	u8 non_cfg_phy_cnt;     /* non configurable DSP phy data byte count */
+	u8 cfg_phy_cnt;		/* configurable DSP phy data byte count */
+	u8 stat_id;		/* configurable DSP phy data set ID */
+	u8 reserved1;
+	__le64 timestamp;	/* TSF at on air rise */
+	__le32 beacon_time_stamp; /* beacon at on-air rise */
+	__le16 phy_flags;	/* general phy flags: band, modulation, ... */
+	__le16 channel;		/* channel number */
+	__le16 non_cfg_phy[RX_RES_PHY_CNT];	/* upto 14 phy entries */
+	__le32 reserved2;
+	__le32 rate_n_flags;
+	__le16 byte_count;		/* frame's byte-count */
+	__le16 reserved3;
+} __attribute__ ((packed));
+
+struct iwl4965_rx_mpdu_res_start {
+	__le16 byte_count;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+
+/******************************************************************************
+ * (5)
+ * Tx Commands & Responses:
+ *
+ *****************************************************************************/
+
+/* Tx flags */
+#define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
+#define TX_CMD_FLG_CTS_MSK __constant_cpu_to_le32(1 << 2)
+#define TX_CMD_FLG_ACK_MSK __constant_cpu_to_le32(1 << 3)
+#define TX_CMD_FLG_STA_RATE_MSK __constant_cpu_to_le32(1 << 4)
+#define TX_CMD_FLG_IMM_BA_RSP_MASK  __constant_cpu_to_le32(1 << 6)
+#define TX_CMD_FLG_FULL_TXOP_PROT_MSK __constant_cpu_to_le32(1 << 7)
+#define TX_CMD_FLG_ANT_SEL_MSK __constant_cpu_to_le32(0xf00)
+#define TX_CMD_FLG_ANT_A_MSK __constant_cpu_to_le32(1 << 8)
+#define TX_CMD_FLG_ANT_B_MSK __constant_cpu_to_le32(1 << 9)
+
+/* ucode ignores BT priority for this frame */
+#define TX_CMD_FLG_BT_DIS_MSK __constant_cpu_to_le32(1 << 12)
+
+/* ucode overrides sequence control */
+#define TX_CMD_FLG_SEQ_CTL_MSK __constant_cpu_to_le32(1 << 13)
+
+/* signal that this frame is non-last MPDU */
+#define TX_CMD_FLG_MORE_FRAG_MSK __constant_cpu_to_le32(1 << 14)
+
+/* calculate TSF in outgoing frame */
+#define TX_CMD_FLG_TSF_MSK __constant_cpu_to_le32(1 << 16)
+
+/* activate TX calibration. */
+#define TX_CMD_FLG_CALIB_MSK __constant_cpu_to_le32(1 << 17)
+
+/* signals that 2 bytes pad was inserted
+   after the MAC header */
+#define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
+
+/* HCCA-AP - disable duration overwriting. */
+#define TX_CMD_FLG_DUR_MSK __constant_cpu_to_le32(1 << 25)
+
+/*
+ * TX command security control
+ */
+#define TX_CMD_SEC_WEP  	0x01
+#define TX_CMD_SEC_CCM  	0x02
+#define TX_CMD_SEC_TKIP		0x03
+#define TX_CMD_SEC_MSK		0x03
+#define TX_CMD_SEC_SHIFT	6
+#define TX_CMD_SEC_KEY128	0x08
+
+/*
+ * TX command Frame life time
+ */
+
+struct iwl_dram_scratch {
+	u8 try_cnt;
+	u8 bt_kill_cnt;
+	__le16 reserved;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_TX = 0x1c (command)
+ */
+struct iwl_tx_cmd {
+	__le16 len;
+	__le16 next_frame_len;
+	__le32 tx_flags;
+	struct iwl_dram_scratch scratch;
+	__le32 rate_n_flags;
+	u8 sta_id;
+	u8 sec_ctl;
+	u8 initial_rate_index;
+	u8 reserved;
+	u8 key[16];
+	__le16 next_frame_flags;
+	__le16 reserved2;
+	union {
+		__le32 life_time;
+		__le32 attempt;
+	} stop_time;
+	__le32 dram_lsb_ptr;
+	u8 dram_msb_ptr;
+	u8 rts_retry_limit;	/*byte 50 */
+	u8 data_retry_limit;	/*byte 51 */
+	u8 tid_tspec;
+	union {
+		__le16 pm_frame_timeout;
+		__le16 attempt_duration;
+	} timeout;
+	__le16 driver_txop;
+	u8 payload[0];
+	struct ieee80211_hdr hdr[0];
+} __attribute__ ((packed));
+
+/* TX command response is sent after *all* transmission attempts.
+ *
+ * NOTES:
+ *
+ * TX_STATUS_FAIL_NEXT_FRAG
+ *
+ * If the fragment flag in the MAC header for the frame being transmitted
+ * is set and there is insufficient time to transmit the next frame, the
+ * TX status will be returned with 'TX_STATUS_FAIL_NEXT_FRAG'.
+ *
+ * TX_STATUS_FIFO_UNDERRUN
+ *
+ * Indicates the host did not provide bytes to the FIFO fast enough while
+ * a TX was in progress.
+ *
+ * TX_STATUS_FAIL_MGMNT_ABORT
+ *
+ * This status is only possible if the ABORT ON MGMT RX parameter was
+ * set to true with the TX command.
+ *
+ * If the MSB of the status parameter is set then an abort sequence is
+ * required.  This sequence consists of the host activating the TX Abort
+ * control line, and then waiting for the TX Abort command response.  This
+ * indicates that a the device is no longer in a transmit state, and that the
+ * command FIFO has been cleared.  The host must then deactivate the TX Abort
+ * control line.  Receiving is still allowed in this case.
+ */
+enum {
+	TX_STATUS_SUCCESS = 0x01,
+	TX_STATUS_DIRECT_DONE = 0x02,
+	TX_STATUS_FAIL_SHORT_LIMIT = 0x82,
+	TX_STATUS_FAIL_LONG_LIMIT = 0x83,
+	TX_STATUS_FAIL_FIFO_UNDERRUN = 0x84,
+	TX_STATUS_FAIL_MGMNT_ABORT = 0x85,
+	TX_STATUS_FAIL_NEXT_FRAG = 0x86,
+	TX_STATUS_FAIL_LIFE_EXPIRE = 0x87,
+	TX_STATUS_FAIL_DEST_PS = 0x88,
+	TX_STATUS_FAIL_ABORTED = 0x89,
+	TX_STATUS_FAIL_BT_RETRY = 0x8a,
+	TX_STATUS_FAIL_STA_INVALID = 0x8b,
+	TX_STATUS_FAIL_FRAG_DROPPED = 0x8c,
+	TX_STATUS_FAIL_TID_DISABLE = 0x8d,
+	TX_STATUS_FAIL_FRAME_FLUSHED = 0x8e,
+	TX_STATUS_FAIL_INSUFFICIENT_CF_POLL = 0x8f,
+	TX_STATUS_FAIL_TX_LOCKED = 0x90,
+	TX_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
+};
+
+#define	TX_PACKET_MODE_REGULAR		0x0000
+#define	TX_PACKET_MODE_BURST_SEQ	0x0100
+#define	TX_PACKET_MODE_BURST_FIRST	0x0200
+
+enum {
+	TX_POWER_PA_NOT_ACTIVE = 0x0,
+};
+
+enum {
+	TX_STATUS_MSK = 0x000000ff,	/* bits 0:7 */
+	TX_STATUS_DELAY_MSK = 0x00000040,
+	TX_STATUS_ABORT_MSK = 0x00000080,
+	TX_PACKET_MODE_MSK = 0x0000ff00,	/* bits 8:15 */
+	TX_FIFO_NUMBER_MSK = 0x00070000,	/* bits 16:18 */
+	TX_RESERVED = 0x00780000,	/* bits 19:22 */
+	TX_POWER_PA_DETECT_MSK = 0x7f800000,	/* bits 23:30 */
+	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
+};
+
+/* *******************************
+ * TX aggregation state
+ ******************************* */
+
+enum {
+	AGG_TX_STATE_TRANSMITTED = 0x00,
+	AGG_TX_STATE_UNDERRUN_MSK = 0x01,
+	AGG_TX_STATE_BT_PRIO_MSK = 0x02,
+	AGG_TX_STATE_FEW_BYTES_MSK = 0x04,
+	AGG_TX_STATE_ABORT_MSK = 0x08,
+	AGG_TX_STATE_LAST_SENT_TTL_MSK = 0x10,
+	AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK = 0x20,
+	AGG_TX_STATE_LAST_SENT_BT_KILL_MSK = 0x40,
+	AGG_TX_STATE_SCD_QUERY_MSK = 0x80,
+	AGG_TX_STATE_TEST_BAD_CRC32_MSK = 0x100,
+	AGG_TX_STATE_RESPONSE_MSK = 0x1ff,
+	AGG_TX_STATE_DUMP_TX_MSK = 0x200,
+	AGG_TX_STATE_DELAY_TX_MSK = 0x400
+};
+
+#define AGG_TX_STATE_LAST_SENT_MSK \
+(AGG_TX_STATE_LAST_SENT_TTL_MSK | \
+ AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK | \
+ AGG_TX_STATE_LAST_SENT_BT_KILL_MSK)
+
+#define AGG_TX_STATE_TRY_CNT_POS 12
+#define AGG_TX_STATE_TRY_CNT_MSK 0xf000
+
+#define AGG_TX_STATE_SEQ_NUM_POS 16
+#define AGG_TX_STATE_SEQ_NUM_MSK 0xffff0000
+
+/*
+ * REPLY_TX = 0x1c (response)
+ */
+struct iwl_tx_resp {
+	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
+	u8 bt_kill_count;
+	u8 failure_rts;
+	u8 failure_frame;
+	__le32 rate_n_flags;
+	__le16 wireless_media_time;
+	__le16 reserved;
+	__le32 pa_power1;
+	__le32 pa_power2;
+	__le32 status;	/* TX status (for aggregation status of 1st frame) */
+} __attribute__ ((packed));
+
+/*
+ * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
+ */
+struct iwl_compressed_ba_resp {
+	__le32 sta_addr_lo32;
+	__le16 sta_addr_hi16;
+	__le16 reserved;
+	u8 sta_id;
+	u8 tid;
+	__le16 ba_seq_ctl;
+	__le32 ba_bitmap0;
+	__le32 ba_bitmap1;
+	__le16 scd_flow;
+	__le16 scd_ssn;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_TX_PWR_TABLE_CMD = 0x97 (command, has simple generic response)
+ */
+struct iwl_txpowertable_cmd {
+	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
+	u8 reserved;
+	__le16 channel;
+	struct iwl_tx_power_db tx_power;
+} __attribute__ ((packed));
+
+/*RS_NEW_API: only TLC_RTS remains and moved to bit 0 */
+#define  LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK	(1<<0)
+
+#define  LINK_QUAL_AC_NUM AC_NUM
+#define  LINK_QUAL_MAX_RETRY_NUM 16
+
+#define  LINK_QUAL_ANT_A_MSK (1<<0)
+#define  LINK_QUAL_ANT_B_MSK (1<<1)
+#define  LINK_QUAL_ANT_MSK   (LINK_QUAL_ANT_A_MSK|LINK_QUAL_ANT_B_MSK)
+
+struct iwl_link_qual_general_params {
+	u8 flags;
+	u8 mimo_delimiter;
+	u8 single_stream_ant_msk;
+	u8 dual_stream_ant_msk;
+	u8 start_rate_index[LINK_QUAL_AC_NUM];
+} __attribute__ ((packed));
+
+struct iwl_link_qual_agg_params {
+	__le16 agg_time_limit;
+	u8 agg_dis_start_th;
+	u8 agg_frame_cnt_limit;
+	__le32 reserved;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_TX_LINK_QUALITY_CMD = 0x4e (command, has simple generic response)
+ */
+struct iwl_link_quality_cmd {
+	u8 sta_id;
+	u8 reserved1;
+	__le16 control;
+	struct iwl_link_qual_general_params general_params;
+	struct iwl_link_qual_agg_params agg_params;
+	struct {
+		__le32 rate_n_flags;
+	} rs_table[LINK_QUAL_MAX_RETRY_NUM];
+	__le32 reserved2;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
+ */
+struct iwl_bt_cmd {
+	u8 flags;
+	u8 lead_time;
+	u8 max_kill;
+	u8 reserved;
+	__le32 kill_ack_mask;
+	__le32 kill_cts_mask;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (6)
+ * Spectrum Management (802.11h) Commands, Responses, Notifications:
+ *
+ *****************************************************************************/
+
+/*
+ * Spectrum Management
+ */
+#define MEASUREMENT_FILTER_FLAG (RXON_FILTER_PROMISC_MSK         | \
+				 RXON_FILTER_CTL2HOST_MSK        | \
+				 RXON_FILTER_ACCEPT_GRP_MSK      | \
+				 RXON_FILTER_DIS_DECRYPT_MSK     | \
+				 RXON_FILTER_DIS_GRP_DECRYPT_MSK | \
+				 RXON_FILTER_ASSOC_MSK           | \
+				 RXON_FILTER_BCON_AWARE_MSK)
+
+struct iwl_measure_channel {
+	__le32 duration;	/* measurement duration in extended beacon
+				 * format */
+	u8 channel;		/* channel to measure */
+	u8 type;		/* see enum iwl_measure_type */
+	__le16 reserved;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (command)
+ */
+struct iwl_spectrum_cmd {
+	__le16 len;		/* number of bytes starting from token */
+	u8 token;		/* token id */
+	u8 id;			/* measurement id -- 0 or 1 */
+	u8 origin;		/* 0 = TGh, 1 = other, 2 = TGk */
+	u8 periodic;		/* 1 = periodic */
+	__le16 path_loss_timeout;
+	__le32 start_time;	/* start time in extended beacon format */
+	__le32 reserved2;
+	__le32 flags;		/* rxon flags */
+	__le32 filter_flags;	/* rxon filter flags */
+	__le16 channel_count;	/* minimum 1, maximum 10 */
+	__le16 reserved3;
+	struct iwl_measure_channel channels[10];
+} __attribute__ ((packed));
+
+/*
+ * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (response)
+ */
+struct iwl_spectrum_resp {
+	u8 token;
+	u8 id;			/* id of the prior command replaced, or 0xff */
+	__le16 status;		/* 0 - command will be handled
+				 * 1 - cannot handle (conflicts with another
+				 *     measurement) */
+} __attribute__ ((packed));
+
+enum iwl_measurement_state {
+	IWL_MEASUREMENT_START = 0,
+	IWL_MEASUREMENT_STOP = 1,
+};
+
+enum iwl_measurement_status {
+	IWL_MEASUREMENT_OK = 0,
+	IWL_MEASUREMENT_CONCURRENT = 1,
+	IWL_MEASUREMENT_CSA_CONFLICT = 2,
+	IWL_MEASUREMENT_TGH_CONFLICT = 3,
+	/* 4-5 reserved */
+	IWL_MEASUREMENT_STOPPED = 6,
+	IWL_MEASUREMENT_TIMEOUT = 7,
+	IWL_MEASUREMENT_PERIODIC_FAILED = 8,
+};
+
+#define NUM_ELEMENTS_IN_HISTOGRAM 8
+
+struct iwl_measurement_histogram {
+	__le32 ofdm[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 0.8usec counts */
+	__le32 cck[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 1usec counts */
+} __attribute__ ((packed));
+
+/* clear channel availability counters */
+struct iwl_measurement_cca_counters {
+	__le32 ofdm;
+	__le32 cck;
+} __attribute__ ((packed));
+
+enum iwl_measure_type {
+	IWL_MEASURE_BASIC = (1 << 0),
+	IWL_MEASURE_CHANNEL_LOAD = (1 << 1),
+	IWL_MEASURE_HISTOGRAM_RPI = (1 << 2),
+	IWL_MEASURE_HISTOGRAM_NOISE = (1 << 3),
+	IWL_MEASURE_FRAME = (1 << 4),
+	/* bits 5:6 are reserved */
+	IWL_MEASURE_IDLE = (1 << 7),
+};
+
+/*
+ * SPECTRUM_MEASURE_NOTIFICATION = 0x75 (notification only, not a command)
+ */
+struct iwl_spectrum_notification {
+	u8 id;			/* measurement id -- 0 or 1 */
+	u8 token;
+	u8 channel_index;	/* index in measurement channel list */
+	u8 state;		/* 0 - start, 1 - stop */
+	__le32 start_time;	/* lower 32-bits of TSF */
+	u8 band;		/* 0 - 5.2GHz, 1 - 2.4GHz */
+	u8 channel;
+	u8 type;		/* see enum iwl_measurement_type */
+	u8 reserved1;
+	/* NOTE:  cca_ofdm, cca_cck, basic_type, and histogram are only only
+	 * valid if applicable for measurement type requested. */
+	__le32 cca_ofdm;	/* cca fraction time in 40Mhz clock periods */
+	__le32 cca_cck;		/* cca fraction time in 44Mhz clock periods */
+	__le32 cca_time;	/* channel load time in usecs */
+	u8 basic_type;		/* 0 - bss, 1 - ofdm preamble, 2 -
+				 * unidentified */
+	u8 reserved2[3];
+	struct iwl_measurement_histogram histogram;
+	__le32 stop_time;	/* lower 32-bits of TSF */
+	__le32 status;		/* see iwl_measurement_status */
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (7)
+ * Power Management Commands, Responses, Notifications:
+ *
+ *****************************************************************************/
+
+/**
+ * struct iwl_powertable_cmd - Power Table Command
+ * @flags: See below:
+ *
+ * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
+ *
+ * PM allow:
+ *   bit 0 - '0' Driver not allow power management
+ *           '1' Driver allow PM (use rest of parameters)
+ * uCode send sleep notifications:
+ *   bit 1 - '0' Don't send sleep notification
+ *           '1' send sleep notification (SEND_PM_NOTIFICATION)
+ * Sleep over DTIM
+ *   bit 2 - '0' PM have to walk up every DTIM
+ *           '1' PM could sleep over DTIM till listen Interval.
+ * PCI power managed
+ *   bit 3 - '0' (PCI_LINK_CTRL & 0x1)
+ *           '1' !(PCI_LINK_CTRL & 0x1)
+ * Force sleep Modes
+ *   bit 31/30- '00' use both mac/xtal sleeps
+ *              '01' force Mac sleep
+ *              '10' force xtal sleep
+ *              '11' Illegal set
+ *
+ * NOTE: if sleep_interval[SLEEP_INTRVL_TABLE_SIZE-1] > DTIM period then
+ * ucode assume sleep over DTIM is allowed and we don't need to wakeup
+ * for every DTIM.
+ */
+#define IWL_POWER_VEC_SIZE 5
+
+#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le16(1<<0)
+#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le16(1<<2)
+#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le16(1<<3)
+
+struct iwl_powertable_cmd {
+	__le16 flags;
+	u8 keep_alive_seconds;
+	u8 debug_flags;
+	__le32 rx_data_timeout;
+	__le32 tx_data_timeout;
+	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
+	__le32 keep_alive_beacons;
+} __attribute__ ((packed));
+
+/*
+ * PM_SLEEP_NOTIFICATION = 0x7A (notification only, not a command)
+ * 3945 and 4965 identical.
+ */
+struct iwl_sleep_notification {
+	u8 pm_sleep_mode;
+	u8 pm_wakeup_src;
+	__le16 reserved;
+	__le32 sleep_time;
+	__le32 tsf_low;
+	__le32 bcon_timer;
+} __attribute__ ((packed));
+
+/* Sleep states.  3945 and 4965 identical. */
+enum {
+	IWL_PM_NO_SLEEP = 0,
+	IWL_PM_SLP_MAC = 1,
+	IWL_PM_SLP_FULL_MAC_UNASSOCIATE = 2,
+	IWL_PM_SLP_FULL_MAC_CARD_STATE = 3,
+	IWL_PM_SLP_PHY = 4,
+	IWL_PM_SLP_REPENT = 5,
+	IWL_PM_WAKEUP_BY_TIMER = 6,
+	IWL_PM_WAKEUP_BY_DRIVER = 7,
+	IWL_PM_WAKEUP_BY_RFKILL = 8,
+	/* 3 reserved */
+	IWL_PM_NUM_OF_MODES = 12,
+};
+
+/*
+ * REPLY_CARD_STATE_CMD = 0xa0 (command, has simple generic response)
+ */
+#define CARD_STATE_CMD_DISABLE 0x00	/* Put card to sleep */
+#define CARD_STATE_CMD_ENABLE  0x01	/* Wake up card */
+#define CARD_STATE_CMD_HALT    0x02	/* Power down permanently */
+struct iwl_card_state_cmd {
+	__le32 status;		/* CARD_STATE_CMD_* request new power state */
+} __attribute__ ((packed));
+
+/*
+ * CARD_STATE_NOTIFICATION = 0xa1 (notification only, not a command)
+ */
+struct iwl_card_state_notif {
+	__le32 flags;
+} __attribute__ ((packed));
+
+#define HW_CARD_DISABLED   0x01
+#define SW_CARD_DISABLED   0x02
+#define RF_CARD_DISABLED   0x04
+#define RXON_CARD_DISABLED 0x10
+
+struct iwl_ct_kill_config {
+	__le32   reserved;
+	__le32   critical_temperature_M;
+	__le32   critical_temperature_R;
+}  __attribute__ ((packed));
+
+/******************************************************************************
+ * (8)
+ * Scan Commands, Responses, Notifications:
+ *
+ *****************************************************************************/
+
+struct iwl_scan_channel {
+	/* type is defined as:
+	 * 0:0 active (0 - passive)
+	 * 1:4 SSID direct
+	 *     If 1 is set then corresponding SSID IE is transmitted in probe
+	 * 5:7 reserved
+	 */
+	u8 type;
+	u8 channel;
+	struct iwl_tx_power tpc;
+	__le16 active_dwell;
+	__le16 passive_dwell;
+} __attribute__ ((packed));
+
+struct iwl_ssid_ie {
+	u8 id;
+	u8 len;
+	u8 ssid[32];
+} __attribute__ ((packed));
+
+#define PROBE_OPTION_MAX        0x4
+#define TX_CMD_LIFE_TIME_INFINITE	__constant_cpu_to_le32(0xFFFFFFFF)
+#define IWL_GOOD_CRC_TH		__constant_cpu_to_le16(1)
+#define IWL_MAX_SCAN_SIZE 1024
+
+/*
+ * REPLY_SCAN_CMD = 0x80 (command)
+ */
+struct iwl_scan_cmd {
+	__le16 len;
+	u8 reserved0;
+	u8 channel_count;
+	__le16 quiet_time;     /* dwell only this long on quiet chnl
+				* (active scan) */
+	__le16 quiet_plcp_th;  /* quiet chnl is < this # pkts (typ. 1) */
+	__le16 good_CRC_th;    /* passive -> active promotion threshold */
+	__le16 rx_chain;
+	__le32 max_out_time;   /* max usec to be out of associated (service)
+				* chnl */
+	__le32 suspend_time;   /* pause scan this long when returning to svc
+				* chnl.
+				* 3945 -- 31:24 # beacons, 19:0 additional usec,
+				* 4965 -- 31:22 # beacons, 21:0 additional usec.
+				*/
+	__le32 flags;
+	__le32 filter_flags;
+
+	struct iwl_tx_cmd tx_cmd;
+	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
+
+	u8 data[0];
+	/*
+	 * The channels start after the probe request payload and are of type:
+	 *
+	 * struct iwl_scan_channel channels[0];
+	 *
+	 * NOTE:  Only one band of channels can be scanned per pass.  You
+	 * can not mix 2.4GHz channels and 5.2GHz channels and must
+	 * request a scan multiple times (not concurrently)
+	 *
+	 */
+} __attribute__ ((packed));
+
+/* Can abort will notify by complete notification with abort status. */
+#define CAN_ABORT_STATUS	__constant_cpu_to_le32(0x1)
+/* complete notification statuses */
+#define ABORT_STATUS            0x2
+
+/*
+ * REPLY_SCAN_CMD = 0x80 (response)
+ */
+struct iwl_scanreq_notification {
+	__le32 status;		/* 1: okay, 2: cannot fulfill request */
+} __attribute__ ((packed));
+
+/*
+ * SCAN_START_NOTIFICATION = 0x82 (notification only, not a command)
+ */
+struct iwl_scanstart_notification {
+	__le32 tsf_low;
+	__le32 tsf_high;
+	__le32 beacon_timer;
+	u8 channel;
+	u8 band;
+	u8 reserved[2];
+	__le32 status;
+} __attribute__ ((packed));
+
+#define  SCAN_OWNER_STATUS 0x1;
+#define  MEASURE_OWNER_STATUS 0x2;
+
+#define NUMBER_OF_STATISTICS 1	/* first __le32 is good CRC */
+/*
+ * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
+ */
+struct iwl_scanresults_notification {
+	u8 channel;
+	u8 band;
+	u8 reserved[2];
+	__le32 tsf_low;
+	__le32 tsf_high;
+	__le32 statistics[NUMBER_OF_STATISTICS];
+} __attribute__ ((packed));
+
+/*
+ * SCAN_COMPLETE_NOTIFICATION = 0x84 (notification only, not a command)
+ */
+struct iwl_scancomplete_notification {
+	u8 scanned_channels;
+	u8 status;
+	u8 reserved;
+	u8 last_channel;
+	__le32 tsf_low;
+	__le32 tsf_high;
+} __attribute__ ((packed));
+
+
+/******************************************************************************
+ * (9)
+ * IBSS/AP Commands and Notifications:
+ *
+ *****************************************************************************/
+
+/*
+ * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
+ */
+struct iwl_beacon_notif {
+	struct iwl_tx_resp beacon_notify_hdr;
+	__le32 low_tsf;
+	__le32 high_tsf;
+	__le32 ibss_mgr_status;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
+ */
+struct iwl_tx_beacon_cmd {
+	struct iwl_tx_cmd tx;
+	__le16 tim_idx;
+	u8 tim_size;
+	u8 reserved1;
+	struct ieee80211_hdr frame[0];	/* beacon frame */
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (10)
+ * Statistics Commands and Notifications:
+ *
+ *****************************************************************************/
+
+#define IWL_TEMP_CONVERT 260
+
+#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
+#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
+#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
+
+/* Used for passing to driver number of successes and failures per rate */
+struct rate_histogram {
+	union {
+		__le32 a[SUP_RATE_11A_MAX_NUM_CHANNELS];
+		__le32 b[SUP_RATE_11B_MAX_NUM_CHANNELS];
+		__le32 g[SUP_RATE_11G_MAX_NUM_CHANNELS];
+	} success;
+	union {
+		__le32 a[SUP_RATE_11A_MAX_NUM_CHANNELS];
+		__le32 b[SUP_RATE_11B_MAX_NUM_CHANNELS];
+		__le32 g[SUP_RATE_11G_MAX_NUM_CHANNELS];
+	} failed;
+} __attribute__ ((packed));
+
+/* statistics command response */
+
+struct statistics_rx_phy {
+	__le32 ina_cnt;
+	__le32 fina_cnt;
+	__le32 plcp_err;
+	__le32 crc32_err;
+	__le32 overrun_err;
+	__le32 early_overrun_err;
+	__le32 crc32_good;
+	__le32 false_alarm_cnt;
+	__le32 fina_sync_err_cnt;
+	__le32 sfd_timeout;
+	__le32 fina_timeout;
+	__le32 unresponded_rts;
+	__le32 rxe_frame_limit_overrun;
+	__le32 sent_ack_cnt;
+	__le32 sent_cts_cnt;
+	__le32 sent_ba_rsp_cnt;
+	__le32 dsp_self_kill;
+	__le32 mh_format_err;
+	__le32 re_acq_main_rssi_sum;
+	__le32 reserved3;
+} __attribute__ ((packed));
+
+struct statistics_rx_ht_phy {
+	__le32 plcp_err;
+	__le32 overrun_err;
+	__le32 early_overrun_err;
+	__le32 crc32_good;
+	__le32 crc32_err;
+	__le32 mh_format_err;
+	__le32 agg_crc32_good;
+	__le32 agg_mpdu_cnt;
+	__le32 agg_cnt;
+	__le32 reserved2;
+} __attribute__ ((packed));
+
+struct statistics_rx_non_phy {
+	__le32 bogus_cts;	/* CTS received when not expecting CTS */
+	__le32 bogus_ack;	/* ACK received when not expecting ACK */
+	__le32 non_bssid_frames;	/* number of frames with BSSID that
+					 * doesn't belong to the STA BSSID */
+	__le32 filtered_frames;	/* count frames that were dumped in the
+				 * filtering process */
+	__le32 non_channel_beacons;	/* beacons with our bss id but not on
+					 * our serving channel */
+	__le32 channel_beacons;	/* beacons with our bss id and in our
+				 * serving channel */
+	__le32 num_missed_bcon;	/* number of missed beacons */
+	__le32 adc_rx_saturation_time;	/* count in 0.8us units the time the
+					 * ADC was in saturation */
+	__le32 ina_detection_search_time;/* total time (in 0.8us) searched
+					  * for INA */
+	__le32 beacon_silence_rssi_a;	/* RSSI silence after beacon frame */
+	__le32 beacon_silence_rssi_b;	/* RSSI silence after beacon frame */
+	__le32 beacon_silence_rssi_c;	/* RSSI silence after beacon frame */
+	__le32 interference_data_flag;	/* flag for interference data
+					 * availability. 1 when data is
+					 * available. */
+	__le32 channel_load;	/* counts RX Enable time */
+	__le32 dsp_false_alarms;	/* DSP false alarm (both OFDM
+					 * and CCK) counter */
+	__le32 beacon_rssi_a;
+	__le32 beacon_rssi_b;
+	__le32 beacon_rssi_c;
+	__le32 beacon_energy_a;
+	__le32 beacon_energy_b;
+	__le32 beacon_energy_c;
+} __attribute__ ((packed));
+
+struct statistics_rx {
+	struct statistics_rx_phy ofdm;
+	struct statistics_rx_phy cck;
+	struct statistics_rx_non_phy general;
+	struct statistics_rx_ht_phy ofdm_ht;
+} __attribute__ ((packed));
+
+struct statistics_tx_non_phy_agg {
+	__le32 ba_timeout;
+	__le32 ba_reschedule_frames;
+	__le32 scd_query_agg_frame_cnt;
+	__le32 scd_query_no_agg;
+	__le32 scd_query_agg;
+	__le32 scd_query_mismatch;
+	__le32 frame_not_ready;
+	__le32 underrun;
+	__le32 bt_prio_kill;
+	__le32 rx_ba_rsp_cnt;
+	__le32 reserved2;
+	__le32 reserved3;
+} __attribute__ ((packed));
+
+struct statistics_tx {
+	__le32 preamble_cnt;
+	__le32 rx_detected_cnt;
+	__le32 bt_prio_defer_cnt;
+	__le32 bt_prio_kill_cnt;
+	__le32 few_bytes_cnt;
+	__le32 cts_timeout;
+	__le32 ack_timeout;
+	__le32 expected_ack_cnt;
+	__le32 actual_ack_cnt;
+	__le32 dump_msdu_cnt;
+	__le32 burst_abort_next_frame_mismatch_cnt;
+	__le32 burst_abort_missing_next_frame_cnt;
+	__le32 cts_timeout_collision;
+	__le32 ack_or_ba_timeout_collision;
+	struct statistics_tx_non_phy_agg agg;
+} __attribute__ ((packed));
+
+struct statistics_dbg {
+	__le32 burst_check;
+	__le32 burst_count;
+	__le32 reserved[4];
+} __attribute__ ((packed));
+
+struct statistics_div {
+	__le32 tx_on_a;
+	__le32 tx_on_b;
+	__le32 exec_time;
+	__le32 probe_time;
+	__le32 reserved1;
+	__le32 reserved2;
+} __attribute__ ((packed));
+
+struct statistics_general {
+	__le32 temperature;
+	__le32 temperature_m;
+	struct statistics_dbg dbg;
+	__le32 sleep_time;
+	__le32 slots_out;
+	__le32 slots_idle;
+	__le32 ttl_timestamp;
+	struct statistics_div div;
+	__le32 rx_enable_counter;
+	__le32 reserved1;
+	__le32 reserved2;
+	__le32 reserved3;
+} __attribute__ ((packed));
+
+/*
+ * REPLY_STATISTICS_CMD = 0x9c,
+ * 3945 and 4965 identical.
+ *
+ * This command triggers an immediate response containing uCode statistics.
+ * The response is in the same format as STATISTICS_NOTIFICATION 0x9d, below.
+ *
+ * If the CLEAR_STATS configuration flag is set, uCode will clear its
+ * internal copy of the statistics (counters) after issuing the response.
+ * This flag does not affect STATISTICS_NOTIFICATIONs after beacons (see below).
+ *
+ * If the DISABLE_NOTIF configuration flag is set, uCode will not issue
+ * STATISTICS_NOTIFICATIONs after received beacons (see below).  This flag
+ * does not affect the response to the REPLY_STATISTICS_CMD 0x9c itself.
+ */
+#define IWL_STATS_CONF_CLEAR_STATS __constant_cpu_to_le32(0x1)	/* see above */
+#define IWL_STATS_CONF_DISABLE_NOTIF __constant_cpu_to_le32(0x2)/* see above */
+struct iwl_statistics_cmd {
+	__le32 configuration_flags;	/* IWL_STATS_CONF_* */
+} __attribute__ ((packed));
+
+/*
+ * STATISTICS_NOTIFICATION = 0x9d (notification only, not a command)
+ *
+ * By default, uCode issues this notification after receiving a beacon
+ * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
+ * REPLY_STATISTICS_CMD 0x9c, above.
+ *
+ * Statistics counters continue to increment beacon after beacon, but are
+ * cleared when changing channels or when driver issues REPLY_STATISTICS_CMD
+ * 0x9c with CLEAR_STATS bit set (see above).
+ *
+ * uCode also issues this notification during scans.  uCode clears statistics
+ * appropriately so that each notification contains statistics for only the
+ * one channel that has just been scanned.
+ */
+#define STATISTICS_REPLY_FLG_BAND_24G_MSK         __constant_cpu_to_le32(0x2)
+#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         __constant_cpu_to_le32(0x8)
+struct iwl_notif_statistics {
+	__le32 flag;
+	struct statistics_rx rx;
+	struct statistics_tx tx;
+	struct statistics_general general;
+} __attribute__ ((packed));
+
+
+/*
+ * MISSED_BEACONS_NOTIFICATION = 0xa2 (notification only, not a command)
+ */
+/* if ucode missed CONSECUTIVE_MISSED_BCONS_TH beacons in a row,
+ * then this notification will be sent. */
+#define CONSECUTIVE_MISSED_BCONS_TH 20
+
+struct iwl_missed_beacon_notif {
+	__le32 consequtive_missed_beacons;
+	__le32 total_missed_becons;
+	__le32 num_expected_beacons;
+	__le32 num_recvd_beacons;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (11)
+ * Rx Calibration Commands:
+ *
+ *****************************************************************************/
+
+#define PHY_CALIBRATE_DIFF_GAIN_CMD (7)
+#define HD_TABLE_SIZE  (11)
+
+struct iwl_sensitivity_cmd {
+	__le16 control;
+	__le16 table[HD_TABLE_SIZE];
+} __attribute__ ((packed));
+
+struct iwl_calibration_cmd {
+	u8 opCode;
+	u8 flags;
+	__le16 reserved;
+	s8 diff_gain_a;
+	s8 diff_gain_b;
+	s8 diff_gain_c;
+	u8 reserved1;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (12)
+ * Miscellaneous Commands:
+ *
+ *****************************************************************************/
+
+/*
+ * LEDs Command & Response
+ * REPLY_LEDS_CMD = 0x48 (command, has simple generic response)
+ *
+ * For each of 3 possible LEDs (Activity/Link/Tech, selected by "id" field),
+ * this command turns it on or off, or sets up a periodic blinking cycle.
+ */
+struct iwl_led_cmd {
+	__le32 interval;	/* "interval" in uSec */
+	u8 id;			/* 1: Activity, 2: Link, 3: Tech */
+	u8 off;			/* # intervals off while blinking;
+				 * "0", with >0 "on" value, turns LED on */
+	u8 on;			/* # intervals on while blinking;
+				 * "0", regardless of "off", turns LED off */
+	u8 reserved;
+} __attribute__ ((packed));
+
+/******************************************************************************
+ * (13)
+ * Union of all expected notifications/responses:
+ *
+ *****************************************************************************/
+
+struct iwl_rx_packet {
+	__le32 len;
+	struct iwl_cmd_header hdr;
+	union {
+		struct iwl_alive_resp alive_frame;
+		struct iwl_rx_frame rx_frame;
+		struct iwl_tx_resp tx_resp;
+		struct iwl_spectrum_notification spectrum_notif;
+		struct iwl_csa_notification csa_notif;
+		struct iwl_error_resp err_resp;
+		struct iwl_card_state_notif card_state_notif;
+		struct iwl_beacon_notif beacon_status;
+		struct iwl_add_sta_resp add_sta;
+		struct iwl_sleep_notification sleep_notif;
+		struct iwl_spectrum_resp spectrum;
+		struct iwl_notif_statistics stats;
+		struct iwl_compressed_ba_resp compressed_ba;
+		struct iwl_missed_beacon_notif missed_beacon;
+		__le32 status;
+		u8 raw[0];
+	} u;
+} __attribute__ ((packed));
+
+#define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl_rx_frame))
+
+#define PCI_LINK_CTRL      0x0F0
+#define PCI_POWER_SOURCE   0x0C8
+#define PCI_REG_WUM8       0x0E8
+#define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
+
+/*=== CSR (control and status registers) ===*/
+#define CSR_BASE    (0x000)
+
+#define CSR_SW_VER              (CSR_BASE+0x000)
+#define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
+#define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
+#define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
+#define CSR_INT_MASK            (CSR_BASE+0x00c) /* host interrupt enable */
+#define CSR_FH_INT_STATUS       (CSR_BASE+0x010) /* busmaster int status/ack*/
+#define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
+#define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
+#define CSR_GP_CNTRL            (CSR_BASE+0x024)
+#define CSR_HW_REV              (CSR_BASE+0x028)
+#define CSR_EEPROM_REG          (CSR_BASE+0x02c)
+#define CSR_EEPROM_GP           (CSR_BASE+0x030)
+#define CSR_GP_UCODE		(CSR_BASE+0x044)
+#define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
+#define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
+#define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
+#define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
+#define CSR_LED_REG		(CSR_BASE+0x094)
+#define CSR_DRAM_INT_TBL_CTL	(CSR_BASE+0x0A0)
+#define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
+#define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
+#define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
+
+/* HW I/F configuration */
+#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MB         (0x00000100)
+#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM         (0x00000200)
+#define CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC            (0x00000400)
+#define CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
+#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
+#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
+#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
+
+/* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
+ * acknowledged (reset) by host writing "1" to flagged bits. */
+#define CSR_INT_BIT_FH_RX        (1<<31) /* Rx DMA, cmd responses, FH_INT[17:16] */
+#define CSR_INT_BIT_HW_ERR       (1<<29) /* DMA hardware error FH_INT[31] */
+#define CSR_INT_BIT_DNLD         (1<<28) /* uCode Download */
+#define CSR_INT_BIT_FH_TX        (1<<27) /* Tx DMA FH_INT[1:0] */
+#define CSR_INT_BIT_MAC_CLK_ACTV (1<<26) /* NIC controller's clock toggled on/off */
+#define CSR_INT_BIT_SW_ERR       (1<<25) /* uCode error */
+#define CSR_INT_BIT_RF_KILL      (1<<7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
+#define CSR_INT_BIT_CT_KILL      (1<<6)  /* Critical temp (chip too hot) rfkill */
+#define CSR_INT_BIT_SW_RX        (1<<3)  /* Rx, command responses, 3945 */
+#define CSR_INT_BIT_WAKEUP       (1<<1)  /* NIC controller waking up (pwr mgmt) */
+#define CSR_INT_BIT_ALIVE        (1<<0)  /* uCode interrupts once it initializes */
+
+#define CSR_INI_SET_MASK	(CSR_INT_BIT_FH_RX   | \
+				 CSR_INT_BIT_HW_ERR  | \
+				 CSR_INT_BIT_FH_TX   | \
+				 CSR_INT_BIT_SW_ERR  | \
+				 CSR_INT_BIT_RF_KILL | \
+				 CSR_INT_BIT_SW_RX   | \
+				 CSR_INT_BIT_WAKEUP  | \
+				 CSR_INT_BIT_ALIVE)
+
+/* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
+#define CSR_FH_INT_BIT_ERR       (1<<31) /* Error */
+#define CSR_FH_INT_BIT_HI_PRIOR  (1<<30) /* High priority Rx, bypass coalescing */
+#define CSR_FH_INT_BIT_RX_CHNL2  (1<<18) /* Rx channel 2 (3945 only) */
+#define CSR_FH_INT_BIT_RX_CHNL1  (1<<17) /* Rx channel 1 */
+#define CSR_FH_INT_BIT_RX_CHNL0  (1<<16) /* Rx channel 0 */
+#define CSR_FH_INT_BIT_TX_CHNL6  (1<<6)  /* Tx channel 6 (3945 only) */
+#define CSR_FH_INT_BIT_TX_CHNL1  (1<<1)  /* Tx channel 1 */
+#define CSR_FH_INT_BIT_TX_CHNL0  (1<<0)  /* Tx channel 0 */
+
+#define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
+				 CSR_FH_INT_BIT_RX_CHNL2 | \
+				 CSR_FH_INT_BIT_RX_CHNL1 | \
+				 CSR_FH_INT_BIT_RX_CHNL0)
+
+#define CSR_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL6 | \
+				 CSR_FH_INT_BIT_TX_CHNL1 | \
+				 CSR_FH_INT_BIT_TX_CHNL0 )
+
+
+/* RESET */
+#define CSR_RESET_REG_FLAG_NEVO_RESET                (0x00000001)
+#define CSR_RESET_REG_FLAG_FORCE_NMI                 (0x00000002)
+#define CSR_RESET_REG_FLAG_SW_RESET                  (0x00000080)
+#define CSR_RESET_REG_FLAG_MASTER_DISABLED           (0x00000100)
+#define CSR_RESET_REG_FLAG_STOP_MASTER               (0x00000200)
+
+/* GP (general purpose) CONTROL */
+#define CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY        (0x00000001)
+#define CSR_GP_CNTRL_REG_FLAG_INIT_DONE              (0x00000004)
+#define CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ         (0x00000008)
+#define CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP         (0x00000010)
+
+#define CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN           (0x00000001)
+
+#define CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE         (0x07000000)
+#define CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE         (0x04000000)
+#define CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW          (0x08000000)
+
+
+/* EEPROM REG */
+#define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
+#define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
+
+/* EEPROM GP */
+#define CSR_EEPROM_GP_VALID_MSK		(0x00000006)
+#define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
+#define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
+
+/* UCODE DRV GP */
+#define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
+#define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
+#define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
+#define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
+
+/* GPIO */
+#define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
+#define CSR_GPIO_IN_VAL_VAUX_PWR_SRC                (0x00000000)
+#define CSR_GPIO_IN_VAL_VMAIN_PWR_SRC		CSR_GPIO_IN_BIT_AUX_POWER
+
+/* GI Chicken Bits */
+#define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
+#define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
+
+/* CSR_ANA_PLL_CFG */
+#define CSR_ANA_PLL_CFG_SH		(0x00880300)
+
+#define CSR_LED_REG_TRUN_ON		(0x00000078)
+#define CSR_LED_REG_TRUN_OFF		(0x00000038)
+#define CSR_LED_BSM_CTRL_MSK		(0xFFFFFFDF)
+
+/* DRAM_INT_TBL_CTRL */
+#define CSR_DRAM_INT_TBL_CTRL_EN	(1<<31)
+#define CSR_DRAM_INT_TBL_CTRL_WRAP_CHK	(1<<27)
+
+/*=== HBUS (Host-side Bus) ===*/
+#define HBUS_BASE	(0x400)
+
+#define HBUS_TARG_MEM_RADDR     (HBUS_BASE+0x00c)
+#define HBUS_TARG_MEM_WADDR     (HBUS_BASE+0x010)
+#define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
+#define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
+#define HBUS_TARG_PRPH_WADDR    (HBUS_BASE+0x044)
+#define HBUS_TARG_PRPH_RADDR    (HBUS_BASE+0x048)
+#define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
+#define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
+#define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
+
+#define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
+
+
+/* SCD (Scheduler) */
+#define SCD_BASE                        (CSR_BASE + 0x2E00)
+
+#define SCD_MODE_REG                    (SCD_BASE + 0x000)
+#define SCD_ARASTAT_REG                 (SCD_BASE + 0x004)
+#define SCD_TXFACT_REG                  (SCD_BASE + 0x010)
+#define SCD_TXF4MF_REG                  (SCD_BASE + 0x014)
+#define SCD_TXF5MF_REG                  (SCD_BASE + 0x020)
+#define SCD_SBYP_MODE_1_REG             (SCD_BASE + 0x02C)
+#define SCD_SBYP_MODE_2_REG             (SCD_BASE + 0x030)
+
+/*=== FH (data Flow Handler) ===*/
+#define FH_BASE     (0x800)
+
+#define FH_CBCC_TABLE           (FH_BASE+0x140)
+#define FH_TFDB_TABLE           (FH_BASE+0x180)
+#define FH_RCSR_TABLE           (FH_BASE+0x400)
+#define FH_RSSR_TABLE           (FH_BASE+0x4c0)
+#define FH_TCSR_TABLE           (FH_BASE+0x500)
+#define FH_TSSR_TABLE           (FH_BASE+0x680)
+
+/* TFDB (Transmit Frame Buffer Descriptor) */
+#define FH_TFDB(_channel, buf) \
+	(FH_TFDB_TABLE+((_channel)*2+(buf))*0x28)
+#define ALM_FH_TFDB_CHNL_BUF_CTRL_REG(_channel) \
+	(FH_TFDB_TABLE + 0x50 * _channel)
+/* CBCC _channel is [0,2] */
+#define FH_CBCC(_channel)           (FH_CBCC_TABLE+(_channel)*0x8)
+#define FH_CBCC_CTRL(_channel)      (FH_CBCC(_channel)+0x00)
+#define FH_CBCC_BASE(_channel)      (FH_CBCC(_channel)+0x04)
+
+/* RCSR _channel is [0,2] */
+#define FH_RCSR(_channel)           (FH_RCSR_TABLE+(_channel)*0x40)
+#define FH_RCSR_CONFIG(_channel)    (FH_RCSR(_channel)+0x00)
+#define FH_RCSR_RBD_BASE(_channel)  (FH_RCSR(_channel)+0x04)
+#define FH_RCSR_WPTR(_channel)      (FH_RCSR(_channel)+0x20)
+#define FH_RCSR_RPTR_ADDR(_channel) (FH_RCSR(_channel)+0x24)
+#define FH_RSCSR_CHNL0_WPTR        (FH_RSCSR_CHNL0_RBDCB_WPTR_REG)
+
+/* RSSR */
+#define FH_RSSR_CTRL            (FH_RSSR_TABLE+0x000)
+#define FH_RSSR_STATUS          (FH_RSSR_TABLE+0x004)
+/* TCSR */
+#define FH_TCSR(_channel)           (FH_TCSR_TABLE+(_channel)*0x20)
+#define FH_TCSR_CONFIG(_channel)    (FH_TCSR(_channel)+0x00)
+#define FH_TCSR_CREDIT(_channel)    (FH_TCSR(_channel)+0x04)
+#define FH_TCSR_BUFF_STTS(_channel) (FH_TCSR(_channel)+0x08)
+/* TSSR */
+#define FH_TSSR_CBB_BASE        (FH_TSSR_TABLE+0x000)
+#define FH_TSSR_MSG_CONFIG      (FH_TSSR_TABLE+0x008)
+#define FH_TSSR_TX_STATUS       (FH_TSSR_TABLE+0x010)
+/* 18 - reserved */
+
+/* card static random access memory (SRAM) for processor data and instructs */
+#define RTC_INST_LOWER_BOUND			(0x000000)
+#define RTC_DATA_LOWER_BOUND			(0x800000)
+
+
+/* DBM */
+
+#define ALM_FH_SRVC_CHNL                            (6)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE     (20)
+#define ALM_FH_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH      (4)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN    (0x08000000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE        (0x80000000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE           (0x20000000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128         (0x01000000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST         (0x00001000)
+
+#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH               (0x00000000)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF              (0x00000000)
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRIVER           (0x00000001)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL    (0x00000000)
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD           (0x00200000)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT            (0x00000000)
+
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE            (0x00000000)
+#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
+
+#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID          (0x00004000)
+
+#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_BIT_TFDB_WPTR           (0x00000001)
+
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON      (0xFF000000)
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON      (0x00FF0000)
+
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B    (0x00000400)
+
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON       (0x00000100)
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON       (0x00000080)
+
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH     (0x00000020)
+#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH           (0x00000005)
+
+#define ALM_TB_MAX_BYTES_COUNT      (0xFFF0)
+
+#define ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) \
+	((1LU << _channel) << 24)
+#define ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel) \
+	((1LU << _channel) << 16)
+
+#define ALM_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_channel) \
+	(ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) | \
+	 ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel))
+#define PCI_CFG_REV_ID_BIT_BASIC_SKU                (0x40)	/* bit 6    */
+#define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
+
+#define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
+
+#define TFD_QUEUE_MIN           0
+#define TFD_QUEUE_MAX           6
+#define TFD_QUEUE_SIZE_MAX      (256)
+
+/* spectrum and channel data structures */
+#define IWL_NUM_SCAN_RATES         (2)
+
+#define IWL_SCAN_FLAG_24GHZ  (1<<0)
+#define IWL_SCAN_FLAG_52GHZ  (1<<1)
+#define IWL_SCAN_FLAG_ACTIVE (1<<2)
+#define IWL_SCAN_FLAG_DIRECT (1<<3)
+
+#define IWL_MAX_CMD_SIZE 1024
+
+#define IWL_DEFAULT_TX_RETRY  15
+#define IWL_MAX_TX_RETRY      16
+
+/*********************************************/
+
+#define RFD_SIZE                              4
+#define NUM_TFD_CHUNKS                        4
+
+#define RX_QUEUE_SIZE                         256
+#define RX_QUEUE_MASK                         255
+#define RX_QUEUE_SIZE_LOG                     8
+
+/* QoS  definitions */
+
+#define CW_MIN_OFDM          15
+#define CW_MAX_OFDM          1023
+#define CW_MIN_CCK           31
+#define CW_MAX_CCK           1023
+
+#define QOS_TX0_CW_MIN_OFDM      CW_MIN_OFDM
+#define QOS_TX1_CW_MIN_OFDM      CW_MIN_OFDM
+#define QOS_TX2_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
+#define QOS_TX3_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 4 - 1)
+
+#define QOS_TX0_CW_MIN_CCK       CW_MIN_CCK
+#define QOS_TX1_CW_MIN_CCK       CW_MIN_CCK
+#define QOS_TX2_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
+#define QOS_TX3_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 4 - 1)
+
+#define QOS_TX0_CW_MAX_OFDM      CW_MAX_OFDM
+#define QOS_TX1_CW_MAX_OFDM      CW_MAX_OFDM
+#define QOS_TX2_CW_MAX_OFDM      CW_MIN_OFDM
+#define QOS_TX3_CW_MAX_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
+
+#define QOS_TX0_CW_MAX_CCK       CW_MAX_CCK
+#define QOS_TX1_CW_MAX_CCK       CW_MAX_CCK
+#define QOS_TX2_CW_MAX_CCK       CW_MIN_CCK
+#define QOS_TX3_CW_MAX_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
+
+#define QOS_TX0_AIFS            3
+#define QOS_TX1_AIFS            7
+#define QOS_TX2_AIFS            2
+#define QOS_TX3_AIFS            2
+
+#define QOS_TX0_ACM             0
+#define QOS_TX1_ACM             0
+#define QOS_TX2_ACM             0
+#define QOS_TX3_ACM             0
+
+#define QOS_TX0_TXOP_LIMIT_CCK          0
+#define QOS_TX1_TXOP_LIMIT_CCK          0
+#define QOS_TX2_TXOP_LIMIT_CCK          6016
+#define QOS_TX3_TXOP_LIMIT_CCK          3264
+
+#define QOS_TX0_TXOP_LIMIT_OFDM      0
+#define QOS_TX1_TXOP_LIMIT_OFDM      0
+#define QOS_TX2_TXOP_LIMIT_OFDM      3008
+#define QOS_TX3_TXOP_LIMIT_OFDM      1504
+
+#define DEF_TX0_CW_MIN_OFDM      CW_MIN_OFDM
+#define DEF_TX1_CW_MIN_OFDM      CW_MIN_OFDM
+#define DEF_TX2_CW_MIN_OFDM      CW_MIN_OFDM
+#define DEF_TX3_CW_MIN_OFDM      CW_MIN_OFDM
+
+#define DEF_TX0_CW_MIN_CCK       CW_MIN_CCK
+#define DEF_TX1_CW_MIN_CCK       CW_MIN_CCK
+#define DEF_TX2_CW_MIN_CCK       CW_MIN_CCK
+#define DEF_TX3_CW_MIN_CCK       CW_MIN_CCK
+
+#define DEF_TX0_CW_MAX_OFDM      CW_MAX_OFDM
+#define DEF_TX1_CW_MAX_OFDM      CW_MAX_OFDM
+#define DEF_TX2_CW_MAX_OFDM      CW_MAX_OFDM
+#define DEF_TX3_CW_MAX_OFDM      CW_MAX_OFDM
+
+#define DEF_TX0_CW_MAX_CCK       CW_MAX_CCK
+#define DEF_TX1_CW_MAX_CCK       CW_MAX_CCK
+#define DEF_TX2_CW_MAX_CCK       CW_MAX_CCK
+#define DEF_TX3_CW_MAX_CCK       CW_MAX_CCK
+
+#define DEF_TX0_AIFS            (2)
+#define DEF_TX1_AIFS            (2)
+#define DEF_TX2_AIFS            (2)
+#define DEF_TX3_AIFS            (2)
+
+#define DEF_TX0_ACM             0
+#define DEF_TX1_ACM             0
+#define DEF_TX2_ACM             0
+#define DEF_TX3_ACM             0
+
+#define DEF_TX0_TXOP_LIMIT_CCK        0
+#define DEF_TX1_TXOP_LIMIT_CCK        0
+#define DEF_TX2_TXOP_LIMIT_CCK        0
+#define DEF_TX3_TXOP_LIMIT_CCK        0
+
+#define DEF_TX0_TXOP_LIMIT_OFDM       0
+#define DEF_TX1_TXOP_LIMIT_OFDM       0
+#define DEF_TX2_TXOP_LIMIT_OFDM       0
+#define DEF_TX3_TXOP_LIMIT_OFDM       0
+
+#define QOS_QOS_SETS                  3
+#define QOS_PARAM_SET_ACTIVE          0
+#define QOS_PARAM_SET_DEF_CCK         1
+#define QOS_PARAM_SET_DEF_OFDM        2
+
+#define CTRL_QOS_NO_ACK               (0x0020)
+#define DCT_FLAG_EXT_QOS_ENABLED      (0x10)
+
+#define U32_PAD(n)		((4-(n))&0x3)
+
+/*
+ * Generic queue structure
+ *
+ * Contains common data for Rx and Tx queues
+ */
+#define TFD_CTL_COUNT_SET(n)       (n<<24)
+#define TFD_CTL_COUNT_GET(ctl)     ((ctl>>24) & 7)
+#define TFD_CTL_PAD_SET(n)         (n<<28)
+#define TFD_CTL_PAD_GET(ctl)       (ctl>>28)
+
+#define TFD_TX_CMD_SLOTS 256
+#define TFD_CMD_SLOTS 32
+
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
+			      sizeof(struct iwl_cmd_meta))
+
+/*
+ * RX related structures and functions
+ */
+#define RX_FREE_BUFFERS 64
+#define RX_LOW_WATERMARK 8
+
 #define IWL_RX_BUF_SIZE (4 * 1024)
 #define IWL_MAX_BSM_SIZE BSM_SRAM_SIZE
 #define KDR_RTC_INST_UPPER_BOUND		(0x018000)
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-io.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-4965-io.h	2007-10-12 12:06:37.000000000 +0200
@@ -0,0 +1,471 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2007 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#ifndef __iwl_io_h__
+#define __iwl_io_h__
+
+#include <linux/io.h>
+
+#include "iwl-4965-debug.h"
+
+/*
+ * IO, register, and NIC memory access functions
+ *
+ * NOTE on naming convention and macro usage for these
+ *
+ * A single _ prefix before a an access function means that no state
+ * check or debug information is printed when that function is called.
+ *
+ * A double __ prefix before an access function means that state is checked
+ * (in the case of *restricted calls) and the current line number is printed
+ * in addition to any other debug output.
+ *
+ * The non-prefixed name is the #define that maps the caller into a
+ * #define that provides the caller's __LINE__ to the double prefix version.
+ *
+ * If you wish to call the function without any debug or state checking,
+ * you should use the single _ prefix version (as is used by dependent IO
+ * routines, for example _iwl_read_restricted calls the non-check version of
+ * _iwl_read32.)
+ *
+ * These declarations are *extremely* useful in quickly isolating code deltas
+ * which result in misconfiguring of the hardware I/O.  In combination with
+ * git-bisect and the IO debug level you can quickly determine the specific
+ * commit which breaks the IO sequence to the hardware.
+ *
+ */
+
+#define _iwl_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
+				 u32 ofs, u32 val)
+{
+	IWL_DEBUG_IO("write_direct32(0x%08X, 0x%08X) - %s %d\n",
+		     (u32) (ofs), (u32) (val), f, l);
+	_iwl_write32(iwl, ofs, val);
+}
+#define iwl_write32(iwl, ofs, val) \
+	__iwl_write32(__FILE__, __LINE__, iwl, ofs, val)
+#else
+#define iwl_write32(iwl, ofs, val) _iwl_write32(iwl, ofs, val)
+#endif
+
+#define _iwl_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
+{
+	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
+	return _iwl_read32(iwl, ofs);
+}
+#define iwl_read32(iwl, ofs) __iwl_read32(__FILE__, __LINE__, iwl, ofs)
+#else
+#define iwl_read32(p, o) _iwl_read32(p, o)
+#endif
+
+static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
+				u32 bits, u32 mask, int timeout)
+{
+	int i = 0;
+
+	do {
+		if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
+			return i;
+		mdelay(10);
+		i += 10;
+	} while (i < timeout);
+
+	return -ETIMEDOUT;
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_poll_bit(const char *f, u32 l,
+				 struct iwl_priv *priv, u32 addr,
+				 u32 bits, u32 mask, int timeout)
+{
+	int rc = _iwl_poll_bit(priv, addr, bits, mask, timeout);
+	if (unlikely(rc == -ETIMEDOUT))
+		IWL_DEBUG_IO
+		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) - timedout - %s %d\n",
+		     addr, bits, mask, f, l);
+	else
+		IWL_DEBUG_IO
+		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) = 0x%08X - %s %d\n",
+		     addr, bits, mask, rc, f, l);
+	return rc;
+}
+#define iwl_poll_bit(iwl, addr, bits, mask, timeout) \
+	__iwl_poll_bit(__FILE__, __LINE__, iwl, addr, bits, mask, timeout)
+#else
+#define iwl_poll_bit(p, a, b, m, t) _iwl_poll_bit(p, a, b, m, t)
+#endif
+
+static inline void _iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bit(const char *f, u32 l,
+				 struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read32(priv, reg) | mask;
+	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
+	_iwl_write32(priv, reg, val);
+}
+#define iwl_set_bit(p, r, m) __iwl_set_bit(__FILE__, __LINE__, p, r, m)
+#else
+#define iwl_set_bit(p, r, m) _iwl_set_bit(p, r, m)
+#endif
+
+static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_clear_bit(const char *f, u32 l,
+				   struct iwl_priv *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read32(priv, reg) & ~mask;
+	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
+	_iwl_write32(priv, reg, val);
+}
+#define iwl_clear_bit(p, r, m) __iwl_clear_bit(__FILE__, __LINE__, p, r, m)
+#else
+#define iwl_clear_bit(p, r, m) _iwl_clear_bit(p, r, m)
+#endif
+
+static inline int _iwl_grab_restricted_access(struct iwl_priv *priv)
+{
+	int rc;
+	u32 gp_ctl;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (atomic_read(&priv->restrict_refcnt))
+		return 0;
+#endif
+	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
+	    test_bit(STATUS_RF_KILL_SW, &priv->status)) {
+		IWL_WARNING("WARNING: Requesting MAC access during RFKILL "
+			"wakes up NIC\n");
+
+		/* 10 msec allows time for NIC to complete its data save */
+		gp_ctl = _iwl_read32(priv, CSR_GP_CNTRL);
+		if (gp_ctl & CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY) {
+			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
+				"gpctl = 0x%08x\n", gp_ctl);
+			mdelay(10);
+		} else
+			IWL_DEBUG_RF_KILL("power-down complete, "
+					  "gpctl = 0x%08x\n", gp_ctl);
+	}
+
+	/* this bit wakes up the NIC */
+	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	rc = _iwl_poll_bit(priv, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
+	if (rc < 0) {
+		IWL_ERROR("MAC is in deep sleep!\n");
+		return -EIO;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	atomic_inc(&priv->restrict_refcnt);
+#endif
+	return 0;
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_grab_restricted_access(const char *f, u32 l,
+					       struct iwl_priv *priv)
+{
+	if (atomic_read(&priv->restrict_refcnt))
+		IWL_DEBUG_INFO("Grabbing access while already held at "
+			       "line %d.\n", l);
+
+	IWL_DEBUG_IO("grabbing restricted access - %s %d\n", f, l);
+
+	return _iwl_grab_restricted_access(priv);
+}
+#define iwl_grab_restricted_access(priv) \
+	__iwl_grab_restricted_access(__FILE__, __LINE__, priv)
+#else
+#define iwl_grab_restricted_access(priv) \
+	_iwl_grab_restricted_access(priv)
+#endif
+
+static inline void _iwl_release_restricted_access(struct iwl_priv *priv)
+{
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (atomic_dec_and_test(&priv->restrict_refcnt))
+#endif
+		_iwl_clear_bit(priv, CSR_GP_CNTRL,
+			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_release_restricted_access(const char *f, u32 l,
+						   struct iwl_priv *priv)
+{
+	if (atomic_read(&priv->restrict_refcnt) <= 0)
+		IWL_ERROR("Release unheld restricted access at line %d.\n", l);
+
+	IWL_DEBUG_IO("releasing restricted access - %s %d\n", f, l);
+	_iwl_release_restricted_access(priv);
+}
+#define iwl_release_restricted_access(priv) \
+	__iwl_release_restricted_access(__FILE__, __LINE__, priv)
+#else
+#define iwl_release_restricted_access(priv) \
+	_iwl_release_restricted_access(priv)
+#endif
+
+static inline u32 _iwl_read_restricted(struct iwl_priv *priv, u32 reg)
+{
+	return _iwl_read32(priv, reg);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read_restricted(const char *f, u32 l,
+					struct iwl_priv *priv, u32 reg)
+{
+	u32 value = _iwl_read_restricted(priv, reg);
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from %s %d\n", f, l);
+	IWL_DEBUG_IO("read_restricted(0x%4X) = 0x%08x - %s %d \n", reg, value,
+		     f, l);
+	return value;
+}
+#define iwl_read_restricted(priv, reg) \
+	__iwl_read_restricted(__FILE__, __LINE__, priv, reg)
+#else
+#define iwl_read_restricted _iwl_read_restricted
+#endif
+
+static inline void _iwl_write_restricted(struct iwl_priv *priv,
+					 u32 reg, u32 value)
+{
+	_iwl_write32(priv, reg, value);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static void __iwl_write_restricted(u32 line,
+				   struct iwl_priv *priv, u32 reg, u32 value)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	_iwl_write_restricted(priv, reg, value);
+}
+#define iwl_write_restricted(priv, reg, value) \
+	__iwl_write_restricted(__LINE__, priv, reg, value)
+#else
+#define iwl_write_restricted _iwl_write_restricted
+#endif
+
+static inline void iwl_write_buffer_restricted(struct iwl_priv *priv,
+					       u32 reg, u32 len, u32 *values)
+{
+	u32 count = sizeof(u32);
+
+	if ((priv != NULL) && (values != NULL)) {
+		for (; 0 < len; len -= count, reg += count, values++)
+			_iwl_write_restricted(priv, reg, *values);
+	}
+}
+
+static inline int _iwl_poll_restricted_bit(struct iwl_priv *priv,
+					   u32 addr, u32 mask, int timeout)
+{
+	int i = 0;
+
+	do {
+		if ((_iwl_read_restricted(priv, addr) & mask) == mask)
+			return i;
+		mdelay(10);
+		i += 10;
+	} while (i < timeout);
+
+	return -ETIMEDOUT;
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
+					    struct iwl_priv *priv,
+					    u32 addr, u32 mask, int timeout)
+{
+	int rc = _iwl_poll_restricted_bit(priv, addr, mask, timeout);
+
+	if (unlikely(rc == -ETIMEDOUT))
+		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) - "
+			     "timedout - %s %d\n", addr, mask, f, l);
+	else
+		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) = 0x%08X "
+			     "- %s %d\n", addr, mask, rc, f, l);
+	return rc;
+}
+#define iwl_poll_restricted_bit(iwl, addr, mask, timeout) \
+	__iwl_poll_restricted_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
+#else
+#define iwl_poll_restricted_bit _iwl_poll_restricted_bit
+#endif
+
+static inline u32 _iwl_read_restricted_reg(struct iwl_priv *priv, u32 reg)
+{
+	_iwl_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	return _iwl_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline u32 __iwl_read_restricted_reg(u32 line,
+					    struct iwl_priv *priv, u32 reg)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	return _iwl_read_restricted_reg(priv, reg);
+}
+
+#define iwl_read_restricted_reg(priv, reg) \
+	__iwl_read_restricted_reg(__LINE__, priv, reg)
+#else
+#define iwl_read_restricted_reg _iwl_read_restricted_reg
+#endif
+
+static inline void _iwl_write_restricted_reg(struct iwl_priv *priv,
+					     u32 addr, u32 val)
+{
+	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WADDR,
+			      ((addr & 0x0000FFFF) | (3 << 24)));
+	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
+}
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_write_restricted_reg(u32 line,
+					      struct iwl_priv *priv,
+					      u32 addr, u32 val)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	_iwl_write_restricted_reg(priv, addr, val);
+}
+
+#define iwl_write_restricted_reg(priv, addr, val) \
+	__iwl_write_restricted_reg(__LINE__, priv, addr, val);
+#else
+#define iwl_write_restricted_reg _iwl_write_restricted_reg
+#endif
+
+#define _iwl_set_bits_restricted_reg(priv, reg, mask) \
+	_iwl_write_restricted_reg(priv, reg, \
+				  (_iwl_read_restricted_reg(priv, reg) | mask))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bits_restricted_reg(u32 line, struct iwl_priv
+						 *priv, u32 reg, u32 mask)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	_iwl_set_bits_restricted_reg(priv, reg, mask);
+}
+#define iwl_set_bits_restricted_reg(priv, reg, mask) \
+	__iwl_set_bits_restricted_reg(__LINE__, priv, reg, mask)
+#else
+#define iwl_set_bits_restricted_reg _iwl_set_bits_restricted_reg
+#endif
+
+#define _iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
+	_iwl_write_restricted_reg( \
+	    priv, reg, ((_iwl_read_restricted_reg(priv, reg) & mask) | bits))
+#ifdef CONFIG_IWLWIFI_DEBUG
+static inline void __iwl_set_bits_mask_restricted_reg(u32 line,
+		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
+{
+	if (!atomic_read(&priv->restrict_refcnt))
+		IWL_ERROR("Unrestricted access from line %d\n", line);
+	_iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask);
+}
+
+#define iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
+	__iwl_set_bits_mask_restricted_reg(__LINE__, priv, reg, bits, mask)
+#else
+#define iwl_set_bits_mask_restricted_reg _iwl_set_bits_mask_restricted_reg
+#endif
+
+static inline void iwl_clear_bits_restricted_reg(struct iwl_priv
+						 *priv, u32 reg, u32 mask)
+{
+	u32 val = _iwl_read_restricted_reg(priv, reg);
+	_iwl_write_restricted_reg(priv, reg, (val & ~mask));
+}
+
+static inline u32 iwl_read_restricted_mem(struct iwl_priv *priv, u32 addr)
+{
+	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, addr);
+	return iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
+}
+
+static inline void iwl_write_restricted_mem(struct iwl_priv *priv, u32 addr,
+					    u32 val)
+{
+	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
+	iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, val);
+}
+
+static inline void iwl_write_restricted_mems(struct iwl_priv *priv, u32 addr,
+					     u32 len, u32 *values)
+{
+	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
+	for (; 0 < len; len -= sizeof(u32), values++)
+		iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, *values);
+}
+
+static inline void iwl_write_restricted_regs(struct iwl_priv *priv, u32 reg,
+					     u32 len, u8 *values)
+{
+	u32 reg_offset = reg;
+	u32 aligment = reg & 0x3;
+
+	/* write any non-dword-aligned stuff at the beginning */
+	if (len < sizeof(u32)) {
+		if ((aligment + len) <= sizeof(u32)) {
+			u8 size;
+			u32 value = 0;
+			size = len - 1;
+			memcpy(&value, values, len);
+			reg_offset = (reg_offset & 0x0000FFFF);
+
+			_iwl_write_restricted(priv,
+					      HBUS_TARG_PRPH_WADDR,
+					      (reg_offset | (size << 24)));
+			_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT,
+					      value);
+		}
+
+		return;
+	}
+
+	/* now write all the dword-aligned stuff */
+	for (; reg_offset < (reg + len);
+	     reg_offset += sizeof(u32), values += sizeof(u32))
+		_iwl_write_restricted_reg(priv, reg_offset, *((u32 *) values));
+}
+
+#endif
+
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-channel.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-channel.h	2007-10-12 11:39:00.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,161 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-#ifndef __iwl_channel_h__
-#define __iwl_channel_h__
-
-#define IWL_NUM_SCAN_RATES         (2)
-
-struct iwl_channel_tgd_info {
-	u8 type;
-	s8 max_power;
-};
-
-struct iwl_channel_tgh_info {
-	s64 last_radar_time;
-};
-
-/* current Tx power values to use, one for each rate for each channel.
- * requested power is limited by:
- * -- regulatory EEPROM limits for this channel
- * -- hardware capabilities (clip-powers)
- * -- spectrum management
- * -- user preference (e.g. iwconfig)
- * when requested power is set, base power index must also be set. */
-struct iwl_channel_power_info {
-	struct iwl_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 base_power_index;	/* gain index for power at factory temp. */
-	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
-};
-
-/* current scan Tx power values to use, one for each scan rate for each
- * channel. */
-struct iwl_scan_power_info {
-	struct iwl_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
-};
-
-/* Channel unlock period is 15 seconds. If no beacon or probe response
- * has been received within 15 seconds on a locked channel then the channel
- * remains locked. */
-#define TX_UNLOCK_PERIOD 15
-
-/* CSA lock period is 15 seconds.  If a CSA has been received on a channel in
- * the last 15 seconds, the channel is locked */
-#define CSA_LOCK_PERIOD 15
-/*
- * One for each channel, holds all channel setup data
- * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
- *     with one another!
- */
-#define IWL4965_MAX_RATE (33)
-
-struct iwl_channel_info {
-	struct iwl_channel_tgd_info tgd;
-	struct iwl_channel_tgh_info tgh;
-	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
-	struct iwl_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
-						 * FAT channel */
-
-	u8 channel;	  /* channel number */
-	u8 flags;	  /* flags copied from EEPROM */
-	s8 max_power_avg; /* (dBm) regul. eeprom, normal Tx, any rate */
-	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) */
-	s8 min_power;	  /* always 0 */
-	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
-
-	u8 group_index;	  /* 0-4, maps channel to group1/2/3/4/5 */
-	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
-	u8 phymode;	  /* MODE_IEEE80211{A,B,G} */
-
-	/* Radio/DSP gain settings for each "normal" data Tx rate.
-	 * These include, in addition to RF and DSP gain, a few fields for
-	 *   remembering/modifying gain settings (indexes). */
-	struct iwl_channel_power_info power_info[IWL4965_MAX_RATE];
-
-#if IWL == 4965
-	/* FAT channel info */
-	s8 fat_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
-	s8 fat_curr_txpow;	/* (dBm) regulatory/spectrum/user (not h/w) */
-	s8 fat_min_power;	/* always 0 */
-	s8 fat_scan_power;	/* (dBm) eeprom, direct scans, any rate */
-	u8 fat_flags;		/* flags copied from EEPROM */
-	u8 fat_extension_channel;
-#endif
-
-	/* Radio/DSP gain settings for each scan rate, for directed scans. */
-	struct iwl_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
-};
-
-struct iwl_clip_group {
-	/* maximum power level to prevent clipping for each rate, derived by
-	 *   us from this band's saturation power in EEPROM */
-	const s8 clip_powers[IWL_MAX_RATES];
-};
-
-static inline int is_channel_valid(const struct iwl_channel_info *ch_info)
-{
-	if (ch_info == NULL)
-		return 0;
-	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
-}
-
-static inline int is_channel_narrow(const struct iwl_channel_info *ch_info)
-{
-	return (ch_info->flags & EEPROM_CHANNEL_NARROW) ? 1 : 0;
-}
-
-static inline int is_channel_radar(const struct iwl_channel_info *ch_info)
-{
-	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
-}
-
-static inline u8 is_channel_a_band(const struct iwl_channel_info *ch_info)
-{
-	return ch_info->phymode == MODE_IEEE80211A;
-}
-
-static inline u8 is_channel_bg_band(const struct iwl_channel_info *ch_info)
-{
-	return ((ch_info->phymode == MODE_IEEE80211B) ||
-		(ch_info->phymode == MODE_IEEE80211G));
-}
-
-static inline int is_channel_passive(const struct iwl_channel_info *ch)
-{
-	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
-}
-
-static inline int is_channel_ibss(const struct iwl_channel_info *ch)
-{
-	return ((ch->flags & EEPROM_CHANNEL_IBSS)) ? 1 : 0;
-}
-
-extern const struct iwl_channel_info *iwl_get_channel_info(
-	const struct iwl_priv *priv, int phymode, u16 channel);
-
-#endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-commands.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-commands.h	2007-10-12 11:28:11.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,1734 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-
-#ifndef __iwl_commands_h__
-#define __iwl_commands_h__
-
-enum {
-	REPLY_ALIVE = 0x1,
-	REPLY_ERROR = 0x2,
-
-	/* RXON and QOS commands */
-	REPLY_RXON = 0x10,
-	REPLY_RXON_ASSOC = 0x11,
-	REPLY_QOS_PARAM = 0x13,
-	REPLY_RXON_TIMING = 0x14,
-
-	/* Multi-Station support */
-	REPLY_ADD_STA = 0x18,
-	REPLY_REMOVE_STA = 0x19,	/* not used */
-	REPLY_REMOVE_ALL_STA = 0x1a,	/* not used */
-
-	/* RX, TX, LEDs */
-#if IWL == 3945
-	REPLY_3945_RX = 0x1b,		/* 3945 only */
-#endif
-	REPLY_TX = 0x1c,
-	REPLY_RATE_SCALE = 0x47,	/* 3945 only */
-	REPLY_LEDS_CMD = 0x48,
-	REPLY_TX_LINK_QUALITY_CMD = 0x4e, /* 4965 only */
-
-	/* 802.11h related */
-	RADAR_NOTIFICATION = 0x70,	/* not used */
-	REPLY_QUIET_CMD = 0x71,		/* not used */
-	REPLY_CHANNEL_SWITCH = 0x72,
-	CHANNEL_SWITCH_NOTIFICATION = 0x73,
-	REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74,
-	SPECTRUM_MEASURE_NOTIFICATION = 0x75,
-
-	/* Power Management */
-	POWER_TABLE_CMD = 0x77,
-	PM_SLEEP_NOTIFICATION = 0x7A,
-	PM_DEBUG_STATISTIC_NOTIFIC = 0x7B,
-
-	/* Scan commands and notifications */
-	REPLY_SCAN_CMD = 0x80,
-	REPLY_SCAN_ABORT_CMD = 0x81,
-	SCAN_START_NOTIFICATION = 0x82,
-	SCAN_RESULTS_NOTIFICATION = 0x83,
-	SCAN_COMPLETE_NOTIFICATION = 0x84,
-
-	/* IBSS/AP commands */
-	BEACON_NOTIFICATION = 0x90,
-	REPLY_TX_BEACON = 0x91,
-	WHO_IS_AWAKE_NOTIFICATION = 0x94,	/* not used */
-
-	/* Miscellaneous commands */
-	QUIET_NOTIFICATION = 0x96,		/* not used */
-	REPLY_TX_PWR_TABLE_CMD = 0x97,
-	MEASURE_ABORT_NOTIFICATION = 0x99,	/* not used */
-
-	/* BT config command */
-	REPLY_BT_CONFIG = 0x9b,
-
-	/* 4965 Statistics */
-	REPLY_STATISTICS_CMD = 0x9c,
-	STATISTICS_NOTIFICATION = 0x9d,
-
-	/* RF-KILL commands and notifications */
-	REPLY_CARD_STATE_CMD = 0xa0,
-	CARD_STATE_NOTIFICATION = 0xa1,
-
-	/* Missed beacons notification */
-	MISSED_BEACONS_NOTIFICATION = 0xa2,
-
-#if IWL == 4965
-	REPLY_CT_KILL_CONFIG_CMD = 0xa4,
-	SENSITIVITY_CMD = 0xa8,
-	REPLY_PHY_CALIBRATION_CMD = 0xb0,
-	REPLY_RX_PHY_CMD = 0xc0,
-	REPLY_RX_MPDU_CMD = 0xc1,
-	REPLY_4965_RX = 0xc3,
-	REPLY_COMPRESSED_BA = 0xc5,
-#endif
-	REPLY_MAX = 0xff
-};
-
-/******************************************************************************
- * (0)
- * Header
- *
- *****************************************************************************/
-
-#define IWL_CMD_FAILED_MSK 0x40
-
-struct iwl_cmd_header {
-	u8 cmd;
-	u8 flags;
-	/* We have 15 LSB to use as we please (MSB indicates
-	 * a frame Rx'd from the HW).  We encode the following
-	 * information into the sequence field:
-	 *
-	 *  0:7    index in fifo
-	 *  8:13   fifo selection
-	 * 14:14   bit indicating if this packet references the 'extra'
-	 *         storage at the end of the memory queue
-	 * 15:15   (Rx indication)
-	 *
-	 */
-	__le16 sequence;
-
-	/* command data follows immediately */
-	u8 data[0];
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (0a)
- * Alive and Error Commands & Responses:
- *
- *****************************************************************************/
-
-#define UCODE_VALID_OK	__constant_cpu_to_le32(0x1)
-#define INITIALIZE_SUBTYPE    (9)
-
-/*
- * REPLY_ALIVE = 0x1 (response only, not a command)
- */
-struct iwl_alive_resp {
-	u8 ucode_minor;
-	u8 ucode_major;
-	__le16 reserved1;
-	u8 sw_rev[8];
-	u8 ver_type;
-	u8 ver_subtype;
-	__le16 reserved2;
-	__le32 log_event_table_ptr;
-	__le32 error_event_table_ptr;
-	__le32 timestamp;
-	__le32 is_valid;
-} __attribute__ ((packed));
-
-struct iwl_init_alive_resp {
-	u8 ucode_minor;
-	u8 ucode_major;
-	__le16 reserved1;
-	u8 sw_rev[8];
-	u8 ver_type;
-	u8 ver_subtype;
-	__le16 reserved2;
-	__le32 log_event_table_ptr;
-	__le32 error_event_table_ptr;
-	__le32 timestamp;
-	__le32 is_valid;
-
-#if IWL == 4965
-	/* calibration values from "initialize" uCode */
-	__le32 voltage;		/* signed */
-	__le32 therm_r1[2];	/* signed 1st for normal, 2nd for FAT channel */
-	__le32 therm_r2[2];	/* signed */
-	__le32 therm_r3[2];	/* signed */
-	__le32 therm_r4[2];	/* signed */
-	__le32 tx_atten[5][2];	/* signed MIMO gain comp, 5 freq groups,
-				 * 2 Tx chains */
-#endif
-} __attribute__ ((packed));
-
-union tsf {
-	u8 byte[8];
-	__le16 word[4];
-	__le32 dw[2];
-};
-
-/*
- * REPLY_ERROR = 0x2 (response only, not a command)
- */
-struct iwl_error_resp {
-	__le32 error_type;
-	u8 cmd_id;
-	u8 reserved1;
-	__le16 bad_cmd_seq_num;
-#if IWL == 3945
-	__le16 reserved2;
-#endif
-	__le32 error_info;
-	union tsf timestamp;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (1)
- * RXON Commands & Responses:
- *
- *****************************************************************************/
-
-/*
- * Rx config defines & structure
- */
-/* rx_config device types  */
-enum {
-	RXON_DEV_TYPE_AP = 1,
-	RXON_DEV_TYPE_ESS = 3,
-	RXON_DEV_TYPE_IBSS = 4,
-	RXON_DEV_TYPE_SNIFFER = 6,
-};
-
-/* rx_config flags */
-/* band & modulation selection */
-#define RXON_FLG_BAND_24G_MSK           __constant_cpu_to_le32(1 << 0)
-#define RXON_FLG_CCK_MSK                __constant_cpu_to_le32(1 << 1)
-/* auto detection enable */
-#define RXON_FLG_AUTO_DETECT_MSK        __constant_cpu_to_le32(1 << 2)
-/* TGg protection when tx */
-#define RXON_FLG_TGG_PROTECT_MSK        __constant_cpu_to_le32(1 << 3)
-/* cck short slot & preamble */
-#define RXON_FLG_SHORT_SLOT_MSK          __constant_cpu_to_le32(1 << 4)
-#define RXON_FLG_SHORT_PREAMBLE_MSK     __constant_cpu_to_le32(1 << 5)
-/* antenna selection */
-#define RXON_FLG_DIS_DIV_MSK            __constant_cpu_to_le32(1 << 7)
-#define RXON_FLG_ANT_SEL_MSK            __constant_cpu_to_le32(0x0f00)
-#define RXON_FLG_ANT_A_MSK              __constant_cpu_to_le32(1 << 8)
-#define RXON_FLG_ANT_B_MSK              __constant_cpu_to_le32(1 << 9)
-/* radar detection enable */
-#define RXON_FLG_RADAR_DETECT_MSK       __constant_cpu_to_le32(1 << 12)
-#define RXON_FLG_TGJ_NARROW_BAND_MSK    __constant_cpu_to_le32(1 << 13)
-/* rx response to host with 8-byte TSF
-* (according to ON_AIR deassertion) */
-#define RXON_FLG_TSF2HOST_MSK           __constant_cpu_to_le32(1 << 15)
-
-/* rx_config filter flags */
-/* accept all data frames */
-#define RXON_FILTER_PROMISC_MSK         __constant_cpu_to_le32(1 << 0)
-/* pass control & management to host */
-#define RXON_FILTER_CTL2HOST_MSK        __constant_cpu_to_le32(1 << 1)
-/* accept multi-cast */
-#define RXON_FILTER_ACCEPT_GRP_MSK      __constant_cpu_to_le32(1 << 2)
-/* don't decrypt uni-cast frames */
-#define RXON_FILTER_DIS_DECRYPT_MSK     __constant_cpu_to_le32(1 << 3)
-/* don't decrypt multi-cast frames */
-#define RXON_FILTER_DIS_GRP_DECRYPT_MSK __constant_cpu_to_le32(1 << 4)
-/* STA is associated */
-#define RXON_FILTER_ASSOC_MSK           __constant_cpu_to_le32(1 << 5)
-/* transfer to host non bssid beacons in associated state */
-#define RXON_FILTER_BCON_AWARE_MSK      __constant_cpu_to_le32(1 << 6)
-
-/*
- * REPLY_RXON = 0x10 (command, has simple generic response)
- */
-struct iwl_rxon_cmd {
-	u8 node_addr[6];
-	__le16 reserved1;
-	u8 bssid_addr[6];
-	__le16 reserved2;
-	u8 wlap_bssid_addr[6];
-	__le16 reserved3;
-	u8 dev_type;
-	u8 air_propagation;
-#if IWL == 3945
-	__le16 reserved4;
-#elif IWL == 4965
-	__le16 rx_chain;
-#endif
-	u8 ofdm_basic_rates;
-	u8 cck_basic_rates;
-	__le16 assoc_id;
-	__le32 flags;
-	__le32 filter_flags;
-	__le16 channel;
-#if IWL == 3945
-	__le16 reserved5;
-#elif IWL == 4965
-	u8 ofdm_ht_single_stream_basic_rates;
-	u8 ofdm_ht_dual_stream_basic_rates;
-#endif
-} __attribute__ ((packed));
-
-/*
- * REPLY_RXON_ASSOC = 0x11 (command, has simple generic response)
- */
-struct iwl_rxon_assoc_cmd {
-	__le32 flags;
-	__le32 filter_flags;
-	u8 ofdm_basic_rates;
-	u8 cck_basic_rates;
-#if IWL == 4965
-	u8 ofdm_ht_single_stream_basic_rates;
-	u8 ofdm_ht_dual_stream_basic_rates;
-	__le16 rx_chain_select_flags;
-#endif
-	__le16 reserved;
-} __attribute__ ((packed));
-
-/*
- * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
- */
-struct iwl_rxon_time_cmd {
-	union tsf timestamp;
-	__le16 beacon_interval;
-	__le16 atim_window;
-	__le32 beacon_init_val;
-	__le16 listen_interval;
-	__le16 reserved;
-} __attribute__ ((packed));
-
-struct iwl_tx_power {
-	u8 tx_gain;		/* gain for analog radio */
-	u8 dsp_atten;		/* gain for DSP */
-} __attribute__ ((packed));
-
-#if IWL == 3945
-struct iwl_power_per_rate {
-	u8 rate;		/* plcp */
-	struct iwl_tx_power tpc;
-	u8 reserved;
-} __attribute__ ((packed));
-
-#elif IWL == 4965
-#define POWER_TABLE_NUM_ENTRIES			33
-#define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
-#define POWER_TABLE_CCK_ENTRY			32
-struct tx_power_dual_stream {
-	__le32 dw;
-} __attribute__ ((packed));
-
-struct iwl_tx_power_db {
-	struct tx_power_dual_stream power_tbl[POWER_TABLE_NUM_ENTRIES];
-} __attribute__ ((packed));
-#endif
-
-/*
- * REPLY_CHANNEL_SWITCH = 0x72 (command, has simple generic response)
- */
-struct iwl_channel_switch_cmd {
-	u8 band;
-	u8 expect_beacon;
-	__le16 channel;
-	__le32 rxon_flags;
-	__le32 rxon_filter_flags;
-	__le32 switch_time;
-#if IWL == 3945
-	struct iwl_power_per_rate power[IWL_MAX_RATES];
-#elif IWL == 4965
-	struct iwl_tx_power_db tx_power;
-#endif
-} __attribute__ ((packed));
-
-/*
- * CHANNEL_SWITCH_NOTIFICATION = 0x73 (notification only, not a command)
- */
-struct iwl_csa_notification {
-	__le16 band;
-	__le16 channel;
-	__le32 status;		/* 0 - OK, 1 - fail */
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (2)
- * Quality-of-Service (QOS) Commands & Responses:
- *
- *****************************************************************************/
-struct iwl_ac_qos {
-	__le16 cw_min;
-	__le16 cw_max;
-	u8 aifsn;
-	u8 reserved1;
-	__le16 edca_txop;
-} __attribute__ ((packed));
-
-/* QoS flags defines */
-#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	__constant_cpu_to_le32(0x01)
-#define QOS_PARAM_FLG_TGN_MSK		__constant_cpu_to_le32(0x02)
-#define QOS_PARAM_FLG_TXOP_TYPE_MSK	__constant_cpu_to_le32(0x10)
-
-/*
- *  TXFIFO Queue number defines
- */
-/* number of Access categories (AC) (EDCA), queues 0..3 */
-#define AC_NUM                4
-
-/*
- * REPLY_QOS_PARAM = 0x13 (command, has simple generic response)
- */
-struct iwl_qosparam_cmd {
-	__le32 qos_flags;
-	struct iwl_ac_qos ac[AC_NUM];
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (3)
- * Add/Modify Stations Commands & Responses:
- *
- *****************************************************************************/
-/*
- * Multi station support
- */
-#define	IWL_AP_ID		0
-#define IWL_MULTICAST_ID	1
-#define	IWL_STA_ID		2
-
-#define	IWL3945_BROADCAST_ID	24
-#define IWL3945_STATION_COUNT	25
-
-#define IWL4965_BROADCAST_ID	31
-#define	IWL4965_STATION_COUNT	32
-
-#define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
-#define	IWL_INVALID_STATION 	255
-
-#if IWL == 3945
-#define STA_FLG_TX_RATE_MSK		__constant_cpu_to_le32(1<<2);
-#endif
-#define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1<<8);
-
-#define STA_CONTROL_MODIFY_MSK		0x01
-
-/* key flags __le16*/
-#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x7)
-#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0)
-#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x1)
-#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x2)
-#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x3)
-
-#define STA_KEY_FLG_KEYID_POS	8
-#define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
-
-/* modify flags  */
-#define	STA_MODIFY_KEY_MASK		0x01
-#define	STA_MODIFY_TID_DISABLE_TX	0x02
-#define	STA_MODIFY_TX_RATE_MSK		0x04
-#define STA_MODIFY_ADDBA_TID_MSK	0x08
-#define STA_MODIFY_DELBA_TID_MSK	0x10
-#define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
-
-/*
- * Antenna masks:
- * bit14:15 01 B inactive, A active
- *          10 B active, A inactive
- *          11 Both active
- */
-#define RATE_MCS_ANT_A_POS	14
-#define RATE_MCS_ANT_B_POS	15
-#define RATE_MCS_ANT_A_MSK	0x4000
-#define RATE_MCS_ANT_B_MSK	0x8000
-#define RATE_MCS_ANT_AB_MSK	0xc000
-
-struct iwl_keyinfo {
-	__le16 key_flags;
-	u8 tkip_rx_tsc_byte2;	/* TSC[2] for key mix ph1 detection */
-	u8 reserved1;
-	__le16 tkip_rx_ttak[5];	/* 10-byte unicast TKIP TTAK */
-	__le16 reserved2;
-	u8 key[16];		/* 16-byte unicast decryption key */
-} __attribute__ ((packed));
-
-struct sta_id_modify {
-	u8 addr[ETH_ALEN];
-	__le16 reserved1;
-	u8 sta_id;
-	u8 modify_mask;
-	__le16 reserved2;
-} __attribute__ ((packed));
-
-/*
- * REPLY_ADD_STA = 0x18 (command)
- */
-struct iwl_addsta_cmd {
-	u8 mode;
-	u8 reserved[3];
-	struct sta_id_modify sta;
-	struct iwl_keyinfo key;
-	__le32 station_flags;
-	__le32 station_flags_msk;
-	__le16 tid_disable_tx;
-#if IWL == 3945
-	__le16 rate_n_flags;
-#else
-	__le16	reserved1;
-#endif
-	u8 add_immediate_ba_tid;
-	u8 remove_immediate_ba_tid;
-	__le16 add_immediate_ba_ssn;
-#if IWL == 4965
-	__le32 reserved2;
-#endif
-} __attribute__ ((packed));
-
-/*
- * REPLY_ADD_STA = 0x18 (response)
- */
-struct iwl_add_sta_resp {
-	u8 status;
-} __attribute__ ((packed));
-
-#define ADD_STA_SUCCESS_MSK              0x1
-
-/******************************************************************************
- * (4)
- * Rx Responses:
- *
- *****************************************************************************/
-
-struct iwl_rx_frame_stats {
-	u8 phy_count;
-	u8 id;
-	u8 rssi;
-	u8 agc;
-	__le16 sig_avg;
-	__le16 noise_diff;
-	u8 payload[0];
-} __attribute__ ((packed));
-
-struct iwl_rx_frame_hdr {
-	__le16 channel;
-	__le16 phy_flags;
-	u8 reserved1;
-	u8 rate;
-	__le16 len;
-	u8 payload[0];
-} __attribute__ ((packed));
-
-#define	RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
-#define	RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
-
-#define	RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
-#define	RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
-#define	RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
-#define	RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
-#define	RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
-
-#define	RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_WEP	(0x1 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_CCMP	(0x2 << 8)
-#define	RX_RES_STATUS_SEC_TYPE_TKIP	(0x3 << 8)
-
-#define	RX_RES_STATUS_DECRYPT_TYPE_MSK	(0x3 << 11)
-#define	RX_RES_STATUS_NOT_DECRYPT	(0x0 << 11)
-#define	RX_RES_STATUS_DECRYPT_OK	(0x3 << 11)
-#define	RX_RES_STATUS_BAD_ICV_MIC	(0x1 << 11)
-#define	RX_RES_STATUS_BAD_KEY_TTAK	(0x2 << 11)
-
-struct iwl_rx_frame_end {
-	__le32 status;
-	__le64 timestamp;
-	__le32 beacon_timestamp;
-} __attribute__ ((packed));
-
-/*
- * REPLY_3945_RX = 0x1b (response only, not a command)
- *
- * NOTE:  DO NOT dereference from casts to this structure
- * It is provided only for calculating minimum data set size.
- * The actual offsets of the hdr and end are dynamic based on
- * stats.phy_count
- */
-struct iwl_rx_frame {
-	struct iwl_rx_frame_stats stats;
-	struct iwl_rx_frame_hdr hdr;
-	struct iwl_rx_frame_end end;
-} __attribute__ ((packed));
-
-/* Fixed (non-configurable) rx data from phy */
-#define RX_PHY_FLAGS_ANTENNAE_OFFSET		(4)
-#define RX_PHY_FLAGS_ANTENNAE_MASK		(0x70)
-#define IWL_AGC_DB_MASK 	(0x3f80)	/* MASK(7,13) */
-#define IWL_AGC_DB_POS		(7)
-struct iwl4965_rx_non_cfg_phy {
-	__le16 ant_selection;	/* ant A bit 4, ant B bit 5, ant C bit 6 */
-	__le16 agc_info;	/* agc code 0:6, agc dB 7:13, reserved 14:15 */
-	u8 rssi_info[6];	/* we use even entries, 0/2/4 for A/B/C rssi */
-	u8 pad[0];
-} __attribute__ ((packed));
-
-/*
- * REPLY_4965_RX = 0xc3 (response only, not a command)
- * Used only for legacy (non 11n) frames.
- */
-#define RX_RES_PHY_CNT 14
-struct iwl4965_rx_phy_res {
-	u8 non_cfg_phy_cnt;     /* non configurable DSP phy data byte count */
-	u8 cfg_phy_cnt;		/* configurable DSP phy data byte count */
-	u8 stat_id;		/* configurable DSP phy data set ID */
-	u8 reserved1;
-	__le64 timestamp;	/* TSF at on air rise */
-	__le32 beacon_time_stamp; /* beacon at on-air rise */
-	__le16 phy_flags;	/* general phy flags: band, modulation, ... */
-	__le16 channel;		/* channel number */
-	__le16 non_cfg_phy[RX_RES_PHY_CNT];	/* upto 14 phy entries */
-	__le32 reserved2;
-	__le32 rate_n_flags;
-	__le16 byte_count;		/* frame's byte-count */
-	__le16 reserved3;
-} __attribute__ ((packed));
-
-struct iwl4965_rx_mpdu_res_start {
-	__le16 byte_count;
-	__le16 reserved;
-} __attribute__ ((packed));
-
-
-/******************************************************************************
- * (5)
- * Tx Commands & Responses:
- *
- *****************************************************************************/
-
-/* Tx flags */
-#define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
-#define TX_CMD_FLG_CTS_MSK __constant_cpu_to_le32(1 << 2)
-#define TX_CMD_FLG_ACK_MSK __constant_cpu_to_le32(1 << 3)
-#define TX_CMD_FLG_STA_RATE_MSK __constant_cpu_to_le32(1 << 4)
-#define TX_CMD_FLG_IMM_BA_RSP_MASK  __constant_cpu_to_le32(1 << 6)
-#define TX_CMD_FLG_FULL_TXOP_PROT_MSK __constant_cpu_to_le32(1 << 7)
-#define TX_CMD_FLG_ANT_SEL_MSK __constant_cpu_to_le32(0xf00)
-#define TX_CMD_FLG_ANT_A_MSK __constant_cpu_to_le32(1 << 8)
-#define TX_CMD_FLG_ANT_B_MSK __constant_cpu_to_le32(1 << 9)
-
-/* ucode ignores BT priority for this frame */
-#define TX_CMD_FLG_BT_DIS_MSK __constant_cpu_to_le32(1 << 12)
-
-/* ucode overrides sequence control */
-#define TX_CMD_FLG_SEQ_CTL_MSK __constant_cpu_to_le32(1 << 13)
-
-/* signal that this frame is non-last MPDU */
-#define TX_CMD_FLG_MORE_FRAG_MSK __constant_cpu_to_le32(1 << 14)
-
-/* calculate TSF in outgoing frame */
-#define TX_CMD_FLG_TSF_MSK __constant_cpu_to_le32(1 << 16)
-
-/* activate TX calibration. */
-#define TX_CMD_FLG_CALIB_MSK __constant_cpu_to_le32(1 << 17)
-
-/* signals that 2 bytes pad was inserted
-   after the MAC header */
-#define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
-
-/* HCCA-AP - disable duration overwriting. */
-#define TX_CMD_FLG_DUR_MSK __constant_cpu_to_le32(1 << 25)
-
-/*
- * TX command security control
- */
-#define TX_CMD_SEC_WEP  	0x01
-#define TX_CMD_SEC_CCM  	0x02
-#define TX_CMD_SEC_TKIP		0x03
-#define TX_CMD_SEC_MSK		0x03
-#define TX_CMD_SEC_SHIFT	6
-#define TX_CMD_SEC_KEY128	0x08
-
-/*
- * TX command Frame life time
- */
-
-struct iwl_dram_scratch {
-	u8 try_cnt;
-	u8 bt_kill_cnt;
-	__le16 reserved;
-} __attribute__ ((packed));
-
-/*
- * REPLY_TX = 0x1c (command)
- */
-struct iwl_tx_cmd {
-	__le16 len;
-	__le16 next_frame_len;
-	__le32 tx_flags;
-#if IWL == 3945
-	u8 rate;
-	u8 sta_id;
-	u8 tid_tspec;
-#elif IWL == 4965
-	struct iwl_dram_scratch scratch;
-	__le32 rate_n_flags;
-	u8 sta_id;
-#endif
-	u8 sec_ctl;
-#if IWL == 4965
-	u8 initial_rate_index;
-	u8 reserved;
-#endif
-	u8 key[16];
-#if IWL == 3945
-	union {
-		u8 byte[8];
-		__le16 word[4];
-		__le32 dw[2];
-	} tkip_mic;
-	__le32 next_frame_info;
-#elif IWL == 4965
-	__le16 next_frame_flags;
-	__le16 reserved2;
-#endif
-	union {
-		__le32 life_time;
-		__le32 attempt;
-	} stop_time;
-#if IWL == 3945
-	u8 supp_rates[2];
-#elif IWL == 4965
-	__le32 dram_lsb_ptr;
-	u8 dram_msb_ptr;
-#endif
-	u8 rts_retry_limit;	/*byte 50 */
-	u8 data_retry_limit;	/*byte 51 */
-#if IWL == 4965
-	u8 tid_tspec;
-#endif
-	union {
-		__le16 pm_frame_timeout;
-		__le16 attempt_duration;
-	} timeout;
-	__le16 driver_txop;
-	u8 payload[0];
-	struct ieee80211_hdr hdr[0];
-} __attribute__ ((packed));
-
-/* TX command response is sent after *all* transmission attempts.
- *
- * NOTES:
- *
- * TX_STATUS_FAIL_NEXT_FRAG
- *
- * If the fragment flag in the MAC header for the frame being transmitted
- * is set and there is insufficient time to transmit the next frame, the
- * TX status will be returned with 'TX_STATUS_FAIL_NEXT_FRAG'.
- *
- * TX_STATUS_FIFO_UNDERRUN
- *
- * Indicates the host did not provide bytes to the FIFO fast enough while
- * a TX was in progress.
- *
- * TX_STATUS_FAIL_MGMNT_ABORT
- *
- * This status is only possible if the ABORT ON MGMT RX parameter was
- * set to true with the TX command.
- *
- * If the MSB of the status parameter is set then an abort sequence is
- * required.  This sequence consists of the host activating the TX Abort
- * control line, and then waiting for the TX Abort command response.  This
- * indicates that a the device is no longer in a transmit state, and that the
- * command FIFO has been cleared.  The host must then deactivate the TX Abort
- * control line.  Receiving is still allowed in this case.
- */
-enum {
-	TX_STATUS_SUCCESS = 0x01,
-	TX_STATUS_DIRECT_DONE = 0x02,
-	TX_STATUS_FAIL_SHORT_LIMIT = 0x82,
-	TX_STATUS_FAIL_LONG_LIMIT = 0x83,
-	TX_STATUS_FAIL_FIFO_UNDERRUN = 0x84,
-	TX_STATUS_FAIL_MGMNT_ABORT = 0x85,
-	TX_STATUS_FAIL_NEXT_FRAG = 0x86,
-	TX_STATUS_FAIL_LIFE_EXPIRE = 0x87,
-	TX_STATUS_FAIL_DEST_PS = 0x88,
-	TX_STATUS_FAIL_ABORTED = 0x89,
-	TX_STATUS_FAIL_BT_RETRY = 0x8a,
-	TX_STATUS_FAIL_STA_INVALID = 0x8b,
-	TX_STATUS_FAIL_FRAG_DROPPED = 0x8c,
-	TX_STATUS_FAIL_TID_DISABLE = 0x8d,
-	TX_STATUS_FAIL_FRAME_FLUSHED = 0x8e,
-	TX_STATUS_FAIL_INSUFFICIENT_CF_POLL = 0x8f,
-	TX_STATUS_FAIL_TX_LOCKED = 0x90,
-	TX_STATUS_FAIL_NO_BEACON_ON_RADAR = 0x91,
-};
-
-#define	TX_PACKET_MODE_REGULAR		0x0000
-#define	TX_PACKET_MODE_BURST_SEQ	0x0100
-#define	TX_PACKET_MODE_BURST_FIRST	0x0200
-
-enum {
-	TX_POWER_PA_NOT_ACTIVE = 0x0,
-};
-
-enum {
-	TX_STATUS_MSK = 0x000000ff,	/* bits 0:7 */
-	TX_STATUS_DELAY_MSK = 0x00000040,
-	TX_STATUS_ABORT_MSK = 0x00000080,
-	TX_PACKET_MODE_MSK = 0x0000ff00,	/* bits 8:15 */
-	TX_FIFO_NUMBER_MSK = 0x00070000,	/* bits 16:18 */
-	TX_RESERVED = 0x00780000,	/* bits 19:22 */
-	TX_POWER_PA_DETECT_MSK = 0x7f800000,	/* bits 23:30 */
-	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
-};
-
-/* *******************************
- * TX aggregation state
- ******************************* */
-
-enum {
-	AGG_TX_STATE_TRANSMITTED = 0x00,
-	AGG_TX_STATE_UNDERRUN_MSK = 0x01,
-	AGG_TX_STATE_BT_PRIO_MSK = 0x02,
-	AGG_TX_STATE_FEW_BYTES_MSK = 0x04,
-	AGG_TX_STATE_ABORT_MSK = 0x08,
-	AGG_TX_STATE_LAST_SENT_TTL_MSK = 0x10,
-	AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK = 0x20,
-	AGG_TX_STATE_LAST_SENT_BT_KILL_MSK = 0x40,
-	AGG_TX_STATE_SCD_QUERY_MSK = 0x80,
-	AGG_TX_STATE_TEST_BAD_CRC32_MSK = 0x100,
-	AGG_TX_STATE_RESPONSE_MSK = 0x1ff,
-	AGG_TX_STATE_DUMP_TX_MSK = 0x200,
-	AGG_TX_STATE_DELAY_TX_MSK = 0x400
-};
-
-#define AGG_TX_STATE_LAST_SENT_MSK \
-(AGG_TX_STATE_LAST_SENT_TTL_MSK | \
- AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK | \
- AGG_TX_STATE_LAST_SENT_BT_KILL_MSK)
-
-#define AGG_TX_STATE_TRY_CNT_POS 12
-#define AGG_TX_STATE_TRY_CNT_MSK 0xf000
-
-#define AGG_TX_STATE_SEQ_NUM_POS 16
-#define AGG_TX_STATE_SEQ_NUM_MSK 0xffff0000
-
-/*
- * REPLY_TX = 0x1c (response)
- */
-#if IWL == 4965
-struct iwl_tx_resp {
-	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
-	u8 bt_kill_count;
-	u8 failure_rts;
-	u8 failure_frame;
-	__le32 rate_n_flags;
-	__le16 wireless_media_time;
-	__le16 reserved;
-	__le32 pa_power1;
-	__le32 pa_power2;
-	__le32 status;	/* TX status (for aggregation status of 1st frame) */
-} __attribute__ ((packed));
-
-#elif IWL == 3945
-struct iwl_tx_resp {
-	u8 failure_rts;
-	u8 failure_frame;
-	u8 bt_kill_count;
-	u8 rate;
-	__le32 wireless_media_time;
-	__le32 status;	/* TX status (for aggregation status of 1st frame) */
-} __attribute__ ((packed));
-#endif
-
-/*
- * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
- */
-struct iwl_compressed_ba_resp {
-	__le32 sta_addr_lo32;
-	__le16 sta_addr_hi16;
-	__le16 reserved;
-	u8 sta_id;
-	u8 tid;
-	__le16 ba_seq_ctl;
-	__le32 ba_bitmap0;
-	__le32 ba_bitmap1;
-	__le16 scd_flow;
-	__le16 scd_ssn;
-} __attribute__ ((packed));
-
-/*
- * REPLY_TX_PWR_TABLE_CMD = 0x97 (command, has simple generic response)
- */
-struct iwl_txpowertable_cmd {
-	u8 band;		/* 0: 5 GHz, 1: 2.4 GHz */
-	u8 reserved;
-	__le16 channel;
-#if IWL == 3945
-	struct iwl_power_per_rate power[IWL_MAX_RATES];
-#elif IWL == 4965
-	struct iwl_tx_power_db tx_power;
-#endif
-} __attribute__ ((packed));
-
-#if IWL == 3945
-struct iwl_rate_scaling_info {
-	__le16 rate_n_flags;
-	u8 try_cnt;
-	u8 next_rate_index;
-} __attribute__ ((packed));
-
-/**
- * struct iwl_rate_scaling_cmd - Rate Scaling Command & Response
- *
- * REPLY_RATE_SCALE = 0x47 (command, has simple generic response)
- *
- * NOTE: The table of rates passed to the uCode via the
- * RATE_SCALE command sets up the corresponding order of
- * rates used for all related commands, including rate
- * masks, etc.
- *
- * For example, if you set 9MB (PLCP 0x0f) as the first
- * rate in the rate table, the bit mask for that rate
- * when passed through ofdm_basic_rates on the REPLY_RXON
- * command would be bit 0 (1<<0)
- */
-struct iwl_rate_scaling_cmd {
-	u8 table_id;
-	u8 reserved[3];
-	struct iwl_rate_scaling_info table[IWL_MAX_RATES];
-} __attribute__ ((packed));
-
-#elif IWL == 4965
-
-/*RS_NEW_API: only TLC_RTS remains and moved to bit 0 */
-#define  LINK_QUAL_FLAGS_SET_STA_TLC_RTS_MSK	(1<<0)
-
-#define  LINK_QUAL_AC_NUM AC_NUM
-#define  LINK_QUAL_MAX_RETRY_NUM 16
-
-#define  LINK_QUAL_ANT_A_MSK (1<<0)
-#define  LINK_QUAL_ANT_B_MSK (1<<1)
-#define  LINK_QUAL_ANT_MSK   (LINK_QUAL_ANT_A_MSK|LINK_QUAL_ANT_B_MSK)
-
-struct iwl_link_qual_general_params {
-	u8 flags;
-	u8 mimo_delimiter;
-	u8 single_stream_ant_msk;
-	u8 dual_stream_ant_msk;
-	u8 start_rate_index[LINK_QUAL_AC_NUM];
-} __attribute__ ((packed));
-
-struct iwl_link_qual_agg_params {
-	__le16 agg_time_limit;
-	u8 agg_dis_start_th;
-	u8 agg_frame_cnt_limit;
-	__le32 reserved;
-} __attribute__ ((packed));
-
-/*
- * REPLY_TX_LINK_QUALITY_CMD = 0x4e (command, has simple generic response)
- */
-struct iwl_link_quality_cmd {
-	u8 sta_id;
-	u8 reserved1;
-	__le16 control;
-	struct iwl_link_qual_general_params general_params;
-	struct iwl_link_qual_agg_params agg_params;
-	struct {
-		__le32 rate_n_flags;
-	} rs_table[LINK_QUAL_MAX_RETRY_NUM];
-	__le32 reserved2;
-} __attribute__ ((packed));
-#endif
-
-/*
- * REPLY_BT_CONFIG = 0x9b (command, has simple generic response)
- */
-struct iwl_bt_cmd {
-	u8 flags;
-	u8 lead_time;
-	u8 max_kill;
-	u8 reserved;
-	__le32 kill_ack_mask;
-	__le32 kill_cts_mask;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (6)
- * Spectrum Management (802.11h) Commands, Responses, Notifications:
- *
- *****************************************************************************/
-
-/*
- * Spectrum Management
- */
-#define MEASUREMENT_FILTER_FLAG (RXON_FILTER_PROMISC_MSK         | \
-				 RXON_FILTER_CTL2HOST_MSK        | \
-				 RXON_FILTER_ACCEPT_GRP_MSK      | \
-				 RXON_FILTER_DIS_DECRYPT_MSK     | \
-				 RXON_FILTER_DIS_GRP_DECRYPT_MSK | \
-				 RXON_FILTER_ASSOC_MSK           | \
-				 RXON_FILTER_BCON_AWARE_MSK)
-
-struct iwl_measure_channel {
-	__le32 duration;	/* measurement duration in extended beacon
-				 * format */
-	u8 channel;		/* channel to measure */
-	u8 type;		/* see enum iwl_measure_type */
-	__le16 reserved;
-} __attribute__ ((packed));
-
-/*
- * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (command)
- */
-struct iwl_spectrum_cmd {
-	__le16 len;		/* number of bytes starting from token */
-	u8 token;		/* token id */
-	u8 id;			/* measurement id -- 0 or 1 */
-	u8 origin;		/* 0 = TGh, 1 = other, 2 = TGk */
-	u8 periodic;		/* 1 = periodic */
-	__le16 path_loss_timeout;
-	__le32 start_time;	/* start time in extended beacon format */
-	__le32 reserved2;
-	__le32 flags;		/* rxon flags */
-	__le32 filter_flags;	/* rxon filter flags */
-	__le16 channel_count;	/* minimum 1, maximum 10 */
-	__le16 reserved3;
-	struct iwl_measure_channel channels[10];
-} __attribute__ ((packed));
-
-/*
- * REPLY_SPECTRUM_MEASUREMENT_CMD = 0x74 (response)
- */
-struct iwl_spectrum_resp {
-	u8 token;
-	u8 id;			/* id of the prior command replaced, or 0xff */
-	__le16 status;		/* 0 - command will be handled
-				 * 1 - cannot handle (conflicts with another
-				 *     measurement) */
-} __attribute__ ((packed));
-
-enum iwl_measurement_state {
-	IWL_MEASUREMENT_START = 0,
-	IWL_MEASUREMENT_STOP = 1,
-};
-
-enum iwl_measurement_status {
-	IWL_MEASUREMENT_OK = 0,
-	IWL_MEASUREMENT_CONCURRENT = 1,
-	IWL_MEASUREMENT_CSA_CONFLICT = 2,
-	IWL_MEASUREMENT_TGH_CONFLICT = 3,
-	/* 4-5 reserved */
-	IWL_MEASUREMENT_STOPPED = 6,
-	IWL_MEASUREMENT_TIMEOUT = 7,
-	IWL_MEASUREMENT_PERIODIC_FAILED = 8,
-};
-
-#define NUM_ELEMENTS_IN_HISTOGRAM 8
-
-struct iwl_measurement_histogram {
-	__le32 ofdm[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 0.8usec counts */
-	__le32 cck[NUM_ELEMENTS_IN_HISTOGRAM];	/* in 1usec counts */
-} __attribute__ ((packed));
-
-/* clear channel availability counters */
-struct iwl_measurement_cca_counters {
-	__le32 ofdm;
-	__le32 cck;
-} __attribute__ ((packed));
-
-enum iwl_measure_type {
-	IWL_MEASURE_BASIC = (1 << 0),
-	IWL_MEASURE_CHANNEL_LOAD = (1 << 1),
-	IWL_MEASURE_HISTOGRAM_RPI = (1 << 2),
-	IWL_MEASURE_HISTOGRAM_NOISE = (1 << 3),
-	IWL_MEASURE_FRAME = (1 << 4),
-	/* bits 5:6 are reserved */
-	IWL_MEASURE_IDLE = (1 << 7),
-};
-
-/*
- * SPECTRUM_MEASURE_NOTIFICATION = 0x75 (notification only, not a command)
- */
-struct iwl_spectrum_notification {
-	u8 id;			/* measurement id -- 0 or 1 */
-	u8 token;
-	u8 channel_index;	/* index in measurement channel list */
-	u8 state;		/* 0 - start, 1 - stop */
-	__le32 start_time;	/* lower 32-bits of TSF */
-	u8 band;		/* 0 - 5.2GHz, 1 - 2.4GHz */
-	u8 channel;
-	u8 type;		/* see enum iwl_measurement_type */
-	u8 reserved1;
-	/* NOTE:  cca_ofdm, cca_cck, basic_type, and histogram are only only
-	 * valid if applicable for measurement type requested. */
-	__le32 cca_ofdm;	/* cca fraction time in 40Mhz clock periods */
-	__le32 cca_cck;		/* cca fraction time in 44Mhz clock periods */
-	__le32 cca_time;	/* channel load time in usecs */
-	u8 basic_type;		/* 0 - bss, 1 - ofdm preamble, 2 -
-				 * unidentified */
-	u8 reserved2[3];
-	struct iwl_measurement_histogram histogram;
-	__le32 stop_time;	/* lower 32-bits of TSF */
-	__le32 status;		/* see iwl_measurement_status */
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (7)
- * Power Management Commands, Responses, Notifications:
- *
- *****************************************************************************/
-
-/**
- * struct iwl_powertable_cmd - Power Table Command
- * @flags: See below:
- *
- * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
- *
- * PM allow:
- *   bit 0 - '0' Driver not allow power management
- *           '1' Driver allow PM (use rest of parameters)
- * uCode send sleep notifications:
- *   bit 1 - '0' Don't send sleep notification
- *           '1' send sleep notification (SEND_PM_NOTIFICATION)
- * Sleep over DTIM
- *   bit 2 - '0' PM have to walk up every DTIM
- *           '1' PM could sleep over DTIM till listen Interval.
- * PCI power managed
- *   bit 3 - '0' (PCI_LINK_CTRL & 0x1)
- *           '1' !(PCI_LINK_CTRL & 0x1)
- * Force sleep Modes
- *   bit 31/30- '00' use both mac/xtal sleeps
- *              '01' force Mac sleep
- *              '10' force xtal sleep
- *              '11' Illegal set
- *
- * NOTE: if sleep_interval[SLEEP_INTRVL_TABLE_SIZE-1] > DTIM period then
- * ucode assume sleep over DTIM is allowed and we don't need to wakeup
- * for every DTIM.
- */
-#define IWL_POWER_VEC_SIZE 5
-
-
-#if IWL == 3945
-
-#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le32(1<<0)
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le32(1<<2)
-#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le32(1<<3)
-struct iwl_powertable_cmd {
-	__le32 flags;
-	__le32 rx_data_timeout;
-	__le32 tx_data_timeout;
-	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
-} __attribute__((packed));
-
-#elif IWL == 4965
-
-#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le16(1<<0)
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le16(1<<2)
-#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le16(1<<3)
-
-struct iwl_powertable_cmd {
-	__le16 flags;
-	u8 keep_alive_seconds;
-	u8 debug_flags;
-	__le32 rx_data_timeout;
-	__le32 tx_data_timeout;
-	__le32 sleep_interval[IWL_POWER_VEC_SIZE];
-	__le32 keep_alive_beacons;
-} __attribute__ ((packed));
-#endif
-
-/*
- * PM_SLEEP_NOTIFICATION = 0x7A (notification only, not a command)
- * 3945 and 4965 identical.
- */
-struct iwl_sleep_notification {
-	u8 pm_sleep_mode;
-	u8 pm_wakeup_src;
-	__le16 reserved;
-	__le32 sleep_time;
-	__le32 tsf_low;
-	__le32 bcon_timer;
-} __attribute__ ((packed));
-
-/* Sleep states.  3945 and 4965 identical. */
-enum {
-	IWL_PM_NO_SLEEP = 0,
-	IWL_PM_SLP_MAC = 1,
-	IWL_PM_SLP_FULL_MAC_UNASSOCIATE = 2,
-	IWL_PM_SLP_FULL_MAC_CARD_STATE = 3,
-	IWL_PM_SLP_PHY = 4,
-	IWL_PM_SLP_REPENT = 5,
-	IWL_PM_WAKEUP_BY_TIMER = 6,
-	IWL_PM_WAKEUP_BY_DRIVER = 7,
-	IWL_PM_WAKEUP_BY_RFKILL = 8,
-	/* 3 reserved */
-	IWL_PM_NUM_OF_MODES = 12,
-};
-
-/*
- * REPLY_CARD_STATE_CMD = 0xa0 (command, has simple generic response)
- */
-#define CARD_STATE_CMD_DISABLE 0x00	/* Put card to sleep */
-#define CARD_STATE_CMD_ENABLE  0x01	/* Wake up card */
-#define CARD_STATE_CMD_HALT    0x02	/* Power down permanently */
-struct iwl_card_state_cmd {
-	__le32 status;		/* CARD_STATE_CMD_* request new power state */
-} __attribute__ ((packed));
-
-/*
- * CARD_STATE_NOTIFICATION = 0xa1 (notification only, not a command)
- */
-struct iwl_card_state_notif {
-	__le32 flags;
-} __attribute__ ((packed));
-
-#define HW_CARD_DISABLED   0x01
-#define SW_CARD_DISABLED   0x02
-#define RF_CARD_DISABLED   0x04
-#define RXON_CARD_DISABLED 0x10
-
-struct iwl_ct_kill_config {
-	__le32   reserved;
-	__le32   critical_temperature_M;
-	__le32   critical_temperature_R;
-}  __attribute__ ((packed));
-
-/******************************************************************************
- * (8)
- * Scan Commands, Responses, Notifications:
- *
- *****************************************************************************/
-
-struct iwl_scan_channel {
-	/* type is defined as:
-	 * 0:0 active (0 - passive)
-	 * 1:4 SSID direct
-	 *     If 1 is set then corresponding SSID IE is transmitted in probe
-	 * 5:7 reserved
-	 */
-	u8 type;
-	u8 channel;
-	struct iwl_tx_power tpc;
-	__le16 active_dwell;
-	__le16 passive_dwell;
-} __attribute__ ((packed));
-
-struct iwl_ssid_ie {
-	u8 id;
-	u8 len;
-	u8 ssid[32];
-} __attribute__ ((packed));
-
-#define PROBE_OPTION_MAX        0x4
-#define TX_CMD_LIFE_TIME_INFINITE	__constant_cpu_to_le32(0xFFFFFFFF)
-#define IWL_GOOD_CRC_TH		__constant_cpu_to_le16(1)
-#define IWL_MAX_SCAN_SIZE 1024
-
-/*
- * REPLY_SCAN_CMD = 0x80 (command)
- */
-struct iwl_scan_cmd {
-	__le16 len;
-	u8 reserved0;
-	u8 channel_count;
-	__le16 quiet_time;     /* dwell only this long on quiet chnl
-				* (active scan) */
-	__le16 quiet_plcp_th;  /* quiet chnl is < this # pkts (typ. 1) */
-	__le16 good_CRC_th;    /* passive -> active promotion threshold */
-#if IWL == 3945
-	__le16 reserved1;
-#elif IWL == 4965
-	__le16 rx_chain;
-#endif
-	__le32 max_out_time;   /* max usec to be out of associated (service)
-				* chnl */
-	__le32 suspend_time;   /* pause scan this long when returning to svc
-				* chnl.
-				* 3945 -- 31:24 # beacons, 19:0 additional usec,
-				* 4965 -- 31:22 # beacons, 21:0 additional usec.
-				*/
-	__le32 flags;
-	__le32 filter_flags;
-
-	struct iwl_tx_cmd tx_cmd;
-	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX];
-
-	u8 data[0];
-	/*
-	 * The channels start after the probe request payload and are of type:
-	 *
-	 * struct iwl_scan_channel channels[0];
-	 *
-	 * NOTE:  Only one band of channels can be scanned per pass.  You
-	 * can not mix 2.4GHz channels and 5.2GHz channels and must
-	 * request a scan multiple times (not concurrently)
-	 *
-	 */
-} __attribute__ ((packed));
-
-/* Can abort will notify by complete notification with abort status. */
-#define CAN_ABORT_STATUS	__constant_cpu_to_le32(0x1)
-/* complete notification statuses */
-#define ABORT_STATUS            0x2
-
-/*
- * REPLY_SCAN_CMD = 0x80 (response)
- */
-struct iwl_scanreq_notification {
-	__le32 status;		/* 1: okay, 2: cannot fulfill request */
-} __attribute__ ((packed));
-
-/*
- * SCAN_START_NOTIFICATION = 0x82 (notification only, not a command)
- */
-struct iwl_scanstart_notification {
-	__le32 tsf_low;
-	__le32 tsf_high;
-	__le32 beacon_timer;
-	u8 channel;
-	u8 band;
-	u8 reserved[2];
-	__le32 status;
-} __attribute__ ((packed));
-
-#define  SCAN_OWNER_STATUS 0x1;
-#define  MEASURE_OWNER_STATUS 0x2;
-
-#define NUMBER_OF_STATISTICS 1	/* first __le32 is good CRC */
-/*
- * SCAN_RESULTS_NOTIFICATION = 0x83 (notification only, not a command)
- */
-struct iwl_scanresults_notification {
-	u8 channel;
-	u8 band;
-	u8 reserved[2];
-	__le32 tsf_low;
-	__le32 tsf_high;
-	__le32 statistics[NUMBER_OF_STATISTICS];
-} __attribute__ ((packed));
-
-/*
- * SCAN_COMPLETE_NOTIFICATION = 0x84 (notification only, not a command)
- */
-struct iwl_scancomplete_notification {
-	u8 scanned_channels;
-	u8 status;
-	u8 reserved;
-	u8 last_channel;
-	__le32 tsf_low;
-	__le32 tsf_high;
-} __attribute__ ((packed));
-
-
-/******************************************************************************
- * (9)
- * IBSS/AP Commands and Notifications:
- *
- *****************************************************************************/
-
-/*
- * BEACON_NOTIFICATION = 0x90 (notification only, not a command)
- */
-struct iwl_beacon_notif {
-	struct iwl_tx_resp beacon_notify_hdr;
-	__le32 low_tsf;
-	__le32 high_tsf;
-	__le32 ibss_mgr_status;
-} __attribute__ ((packed));
-
-/*
- * REPLY_TX_BEACON = 0x91 (command, has simple generic response)
- */
-struct iwl_tx_beacon_cmd {
-	struct iwl_tx_cmd tx;
-	__le16 tim_idx;
-	u8 tim_size;
-	u8 reserved1;
-	struct ieee80211_hdr frame[0];	/* beacon frame */
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (10)
- * Statistics Commands and Notifications:
- *
- *****************************************************************************/
-
-#define IWL_TEMP_CONVERT 260
-
-#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
-#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
-#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
-
-/* Used for passing to driver number of successes and failures per rate */
-struct rate_histogram {
-	union {
-		__le32 a[SUP_RATE_11A_MAX_NUM_CHANNELS];
-		__le32 b[SUP_RATE_11B_MAX_NUM_CHANNELS];
-		__le32 g[SUP_RATE_11G_MAX_NUM_CHANNELS];
-	} success;
-	union {
-		__le32 a[SUP_RATE_11A_MAX_NUM_CHANNELS];
-		__le32 b[SUP_RATE_11B_MAX_NUM_CHANNELS];
-		__le32 g[SUP_RATE_11G_MAX_NUM_CHANNELS];
-	} failed;
-} __attribute__ ((packed));
-
-/* statistics command response */
-
-struct statistics_rx_phy {
-	__le32 ina_cnt;
-	__le32 fina_cnt;
-	__le32 plcp_err;
-	__le32 crc32_err;
-	__le32 overrun_err;
-	__le32 early_overrun_err;
-	__le32 crc32_good;
-	__le32 false_alarm_cnt;
-	__le32 fina_sync_err_cnt;
-	__le32 sfd_timeout;
-	__le32 fina_timeout;
-	__le32 unresponded_rts;
-	__le32 rxe_frame_limit_overrun;
-	__le32 sent_ack_cnt;
-	__le32 sent_cts_cnt;
-#if IWL == 4965
-	__le32 sent_ba_rsp_cnt;
-	__le32 dsp_self_kill;
-	__le32 mh_format_err;
-	__le32 re_acq_main_rssi_sum;
-	__le32 reserved3;
-#endif
-} __attribute__ ((packed));
-
-#if IWL == 4965
-struct statistics_rx_ht_phy {
-	__le32 plcp_err;
-	__le32 overrun_err;
-	__le32 early_overrun_err;
-	__le32 crc32_good;
-	__le32 crc32_err;
-	__le32 mh_format_err;
-	__le32 agg_crc32_good;
-	__le32 agg_mpdu_cnt;
-	__le32 agg_cnt;
-	__le32 reserved2;
-} __attribute__ ((packed));
-#endif
-
-struct statistics_rx_non_phy {
-	__le32 bogus_cts;	/* CTS received when not expecting CTS */
-	__le32 bogus_ack;	/* ACK received when not expecting ACK */
-	__le32 non_bssid_frames;	/* number of frames with BSSID that
-					 * doesn't belong to the STA BSSID */
-	__le32 filtered_frames;	/* count frames that were dumped in the
-				 * filtering process */
-	__le32 non_channel_beacons;	/* beacons with our bss id but not on
-					 * our serving channel */
-#if IWL == 4965
-	__le32 channel_beacons;	/* beacons with our bss id and in our
-				 * serving channel */
-	__le32 num_missed_bcon;	/* number of missed beacons */
-	__le32 adc_rx_saturation_time;	/* count in 0.8us units the time the
-					 * ADC was in saturation */
-	__le32 ina_detection_search_time;/* total time (in 0.8us) searched
-					  * for INA */
-	__le32 beacon_silence_rssi_a;	/* RSSI silence after beacon frame */
-	__le32 beacon_silence_rssi_b;	/* RSSI silence after beacon frame */
-	__le32 beacon_silence_rssi_c;	/* RSSI silence after beacon frame */
-	__le32 interference_data_flag;	/* flag for interference data
-					 * availability. 1 when data is
-					 * available. */
-	__le32 channel_load;	/* counts RX Enable time */
-	__le32 dsp_false_alarms;	/* DSP false alarm (both OFDM
-					 * and CCK) counter */
-	__le32 beacon_rssi_a;
-	__le32 beacon_rssi_b;
-	__le32 beacon_rssi_c;
-	__le32 beacon_energy_a;
-	__le32 beacon_energy_b;
-	__le32 beacon_energy_c;
-#endif
-} __attribute__ ((packed));
-
-struct statistics_rx {
-	struct statistics_rx_phy ofdm;
-	struct statistics_rx_phy cck;
-	struct statistics_rx_non_phy general;
-#if IWL == 4965
-	struct statistics_rx_ht_phy ofdm_ht;
-#endif
-} __attribute__ ((packed));
-
-#if IWL == 4965
-struct statistics_tx_non_phy_agg {
-	__le32 ba_timeout;
-	__le32 ba_reschedule_frames;
-	__le32 scd_query_agg_frame_cnt;
-	__le32 scd_query_no_agg;
-	__le32 scd_query_agg;
-	__le32 scd_query_mismatch;
-	__le32 frame_not_ready;
-	__le32 underrun;
-	__le32 bt_prio_kill;
-	__le32 rx_ba_rsp_cnt;
-	__le32 reserved2;
-	__le32 reserved3;
-} __attribute__ ((packed));
-#endif
-
-struct statistics_tx {
-	__le32 preamble_cnt;
-	__le32 rx_detected_cnt;
-	__le32 bt_prio_defer_cnt;
-	__le32 bt_prio_kill_cnt;
-	__le32 few_bytes_cnt;
-	__le32 cts_timeout;
-	__le32 ack_timeout;
-	__le32 expected_ack_cnt;
-	__le32 actual_ack_cnt;
-#if IWL == 4965
-	__le32 dump_msdu_cnt;
-	__le32 burst_abort_next_frame_mismatch_cnt;
-	__le32 burst_abort_missing_next_frame_cnt;
-	__le32 cts_timeout_collision;
-	__le32 ack_or_ba_timeout_collision;
-	struct statistics_tx_non_phy_agg agg;
-#endif
-} __attribute__ ((packed));
-
-struct statistics_dbg {
-	__le32 burst_check;
-	__le32 burst_count;
-	__le32 reserved[4];
-} __attribute__ ((packed));
-
-struct statistics_div {
-	__le32 tx_on_a;
-	__le32 tx_on_b;
-	__le32 exec_time;
-	__le32 probe_time;
-#if IWL == 4965
-	__le32 reserved1;
-	__le32 reserved2;
-#endif
-} __attribute__ ((packed));
-
-struct statistics_general {
-	__le32 temperature;
-#if IWL == 4965
-	__le32 temperature_m;
-#endif
-	struct statistics_dbg dbg;
-	__le32 sleep_time;
-	__le32 slots_out;
-	__le32 slots_idle;
-	__le32 ttl_timestamp;
-	struct statistics_div div;
-#if IWL == 4965
-	__le32 rx_enable_counter;
-	__le32 reserved1;
-	__le32 reserved2;
-	__le32 reserved3;
-#endif
-} __attribute__ ((packed));
-
-/*
- * REPLY_STATISTICS_CMD = 0x9c,
- * 3945 and 4965 identical.
- *
- * This command triggers an immediate response containing uCode statistics.
- * The response is in the same format as STATISTICS_NOTIFICATION 0x9d, below.
- *
- * If the CLEAR_STATS configuration flag is set, uCode will clear its
- * internal copy of the statistics (counters) after issuing the response.
- * This flag does not affect STATISTICS_NOTIFICATIONs after beacons (see below).
- *
- * If the DISABLE_NOTIF configuration flag is set, uCode will not issue
- * STATISTICS_NOTIFICATIONs after received beacons (see below).  This flag
- * does not affect the response to the REPLY_STATISTICS_CMD 0x9c itself.
- */
-#define IWL_STATS_CONF_CLEAR_STATS __constant_cpu_to_le32(0x1)	/* see above */
-#define IWL_STATS_CONF_DISABLE_NOTIF __constant_cpu_to_le32(0x2)/* see above */
-struct iwl_statistics_cmd {
-	__le32 configuration_flags;	/* IWL_STATS_CONF_* */
-} __attribute__ ((packed));
-
-/*
- * STATISTICS_NOTIFICATION = 0x9d (notification only, not a command)
- *
- * By default, uCode issues this notification after receiving a beacon
- * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
- * REPLY_STATISTICS_CMD 0x9c, above.
- *
- * Statistics counters continue to increment beacon after beacon, but are
- * cleared when changing channels or when driver issues REPLY_STATISTICS_CMD
- * 0x9c with CLEAR_STATS bit set (see above).
- *
- * uCode also issues this notification during scans.  uCode clears statistics
- * appropriately so that each notification contains statistics for only the
- * one channel that has just been scanned.
- */
-#define STATISTICS_REPLY_FLG_BAND_24G_MSK         __constant_cpu_to_le32(0x2)
-#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         __constant_cpu_to_le32(0x8)
-struct iwl_notif_statistics {
-	__le32 flag;
-	struct statistics_rx rx;
-	struct statistics_tx tx;
-	struct statistics_general general;
-} __attribute__ ((packed));
-
-
-/*
- * MISSED_BEACONS_NOTIFICATION = 0xa2 (notification only, not a command)
- */
-/* if ucode missed CONSECUTIVE_MISSED_BCONS_TH beacons in a row,
- * then this notification will be sent. */
-#define CONSECUTIVE_MISSED_BCONS_TH 20
-
-struct iwl_missed_beacon_notif {
-	__le32 consequtive_missed_beacons;
-	__le32 total_missed_becons;
-	__le32 num_expected_beacons;
-	__le32 num_recvd_beacons;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (11)
- * Rx Calibration Commands:
- *
- *****************************************************************************/
-
-#define PHY_CALIBRATE_DIFF_GAIN_CMD (7)
-#define HD_TABLE_SIZE  (11)
-
-struct iwl_sensitivity_cmd {
-	__le16 control;
-	__le16 table[HD_TABLE_SIZE];
-} __attribute__ ((packed));
-
-struct iwl_calibration_cmd {
-	u8 opCode;
-	u8 flags;
-	__le16 reserved;
-	s8 diff_gain_a;
-	s8 diff_gain_b;
-	s8 diff_gain_c;
-	u8 reserved1;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (12)
- * Miscellaneous Commands:
- *
- *****************************************************************************/
-
-/*
- * LEDs Command & Response
- * REPLY_LEDS_CMD = 0x48 (command, has simple generic response)
- *
- * For each of 3 possible LEDs (Activity/Link/Tech, selected by "id" field),
- * this command turns it on or off, or sets up a periodic blinking cycle.
- */
-struct iwl_led_cmd {
-	__le32 interval;	/* "interval" in uSec */
-	u8 id;			/* 1: Activity, 2: Link, 3: Tech */
-	u8 off;			/* # intervals off while blinking;
-				 * "0", with >0 "on" value, turns LED on */
-	u8 on;			/* # intervals on while blinking;
-				 * "0", regardless of "off", turns LED off */
-	u8 reserved;
-} __attribute__ ((packed));
-
-/******************************************************************************
- * (13)
- * Union of all expected notifications/responses:
- *
- *****************************************************************************/
-
-struct iwl_rx_packet {
-	__le32 len;
-	struct iwl_cmd_header hdr;
-	union {
-		struct iwl_alive_resp alive_frame;
-		struct iwl_rx_frame rx_frame;
-		struct iwl_tx_resp tx_resp;
-		struct iwl_spectrum_notification spectrum_notif;
-		struct iwl_csa_notification csa_notif;
-		struct iwl_error_resp err_resp;
-		struct iwl_card_state_notif card_state_notif;
-		struct iwl_beacon_notif beacon_status;
-		struct iwl_add_sta_resp add_sta;
-		struct iwl_sleep_notification sleep_notif;
-		struct iwl_spectrum_resp spectrum;
-		struct iwl_notif_statistics stats;
-#if IWL == 4965
-		struct iwl_compressed_ba_resp compressed_ba;
-		struct iwl_missed_beacon_notif missed_beacon;
-#endif
-		__le32 status;
-		u8 raw[0];
-	} u;
-} __attribute__ ((packed));
-
-#define IWL_RX_FRAME_SIZE        (4 + sizeof(struct iwl_rx_frame))
-
-#endif				/* __iwl_commands_h__ */
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-debug.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-debug.h	2007-10-12 11:45:57.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,152 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2007 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __iwl_debug_h__
-#define __iwl_debug_h__
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-extern u32 iwl_debug_level;
-#define IWL_DEBUG(level, fmt, args...) \
-do { if (iwl_debug_level & (level)) \
-  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
-
-#define IWL_DEBUG_LIMIT(level, fmt, args...) \
-do { if ((iwl_debug_level & (level)) && net_ratelimit()) \
-  printk(KERN_ERR DRV_NAME": %c %s " fmt, \
-	 in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
-#else
-static inline void IWL_DEBUG(int level, const char *fmt, ...)
-{
-}
-static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
-{
-}
-#endif				/* CONFIG_IWLWIFI_DEBUG */
-
-/*
- * To use the debug system;
- *
- * If you are defining a new debug classification, simply add it to the #define
- * list here in the form of:
- *
- * #define IWL_DL_xxxx VALUE
- *
- * shifting value to the left one bit from the previous entry.  xxxx should be
- * the name of the classification (for example, WEP)
- *
- * You then need to either add a IWL_xxxx_DEBUG() macro definition for your
- * classification, or use IWL_DEBUG(IWL_DL_xxxx, ...) whenever you want
- * to send output to that classification.
- *
- * To add your debug level to the list of levels seen when you perform
- *
- * % cat /proc/net/iwl/debug_level
- *
- * you simply need to add your entry to the iwl_debug_levels array.
- *
- * If you do not see debug_level in /proc/net/iwl then you do not have
- * CONFIG_IWLWIFI_DEBUG defined in your kernel configuration
- *
- */
-
-#define IWL_DL_INFO          (1<<0)
-#define IWL_DL_MAC80211      (1<<1)
-#define IWL_DL_HOST_COMMAND  (1<<2)
-#define IWL_DL_STATE         (1<<3)
-
-#define IWL_DL_RADIO         (1<<7)
-#define IWL_DL_POWER         (1<<8)
-#define IWL_DL_TEMP          (1<<9)
-
-#define IWL_DL_NOTIF         (1<<10)
-#define IWL_DL_SCAN          (1<<11)
-#define IWL_DL_ASSOC         (1<<12)
-#define IWL_DL_DROP          (1<<13)
-
-#define IWL_DL_TXPOWER       (1<<14)
-
-#define IWL_DL_AP            (1<<15)
-
-#define IWL_DL_FW            (1<<16)
-#define IWL_DL_RF_KILL       (1<<17)
-#define IWL_DL_FW_ERRORS     (1<<18)
-
-#define IWL_DL_LED           (1<<19)
-
-#define IWL_DL_RATE          (1<<20)
-
-#define IWL_DL_CALIB         (1<<21)
-#define IWL_DL_WEP           (1<<22)
-#define IWL_DL_TX            (1<<23)
-#define IWL_DL_RX            (1<<24)
-#define IWL_DL_ISR           (1<<25)
-#define IWL_DL_HT            (1<<26)
-#define IWL_DL_IO            (1<<27)
-#define IWL_DL_11H           (1<<28)
-
-#define IWL_DL_STATS         (1<<29)
-#define IWL_DL_TX_REPLY      (1<<30)
-#define IWL_DL_QOS           (1<<31)
-
-#define IWL_ERROR(f, a...) printk(KERN_ERR DRV_NAME ": " f, ## a)
-#define IWL_WARNING(f, a...) printk(KERN_WARNING DRV_NAME ": " f, ## a)
-#define IWL_DEBUG_INFO(f, a...)    IWL_DEBUG(IWL_DL_INFO, f, ## a)
-
-#define IWL_DEBUG_MAC80211(f, a...)     IWL_DEBUG(IWL_DL_MAC80211, f, ## a)
-#define IWL_DEBUG_TEMP(f, a...)   IWL_DEBUG(IWL_DL_TEMP, f, ## a)
-#define IWL_DEBUG_SCAN(f, a...)   IWL_DEBUG(IWL_DL_SCAN, f, ## a)
-#define IWL_DEBUG_RX(f, a...)     IWL_DEBUG(IWL_DL_RX, f, ## a)
-#define IWL_DEBUG_TX(f, a...)     IWL_DEBUG(IWL_DL_TX, f, ## a)
-#define IWL_DEBUG_ISR(f, a...)    IWL_DEBUG(IWL_DL_ISR, f, ## a)
-#define IWL_DEBUG_LED(f, a...) IWL_DEBUG(IWL_DL_LED, f, ## a)
-#define IWL_DEBUG_WEP(f, a...)    IWL_DEBUG(IWL_DL_WEP, f, ## a)
-#define IWL_DEBUG_HC(f, a...) IWL_DEBUG(IWL_DL_HOST_COMMAND, f, ## a)
-#define IWL_DEBUG_CALIB(f, a...) IWL_DEBUG(IWL_DL_CALIB, f, ## a)
-#define IWL_DEBUG_FW(f, a...) IWL_DEBUG(IWL_DL_FW, f, ## a)
-#define IWL_DEBUG_RF_KILL(f, a...) IWL_DEBUG(IWL_DL_RF_KILL, f, ## a)
-#define IWL_DEBUG_DROP(f, a...) IWL_DEBUG(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_DROP_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_DROP, f, ## a)
-#define IWL_DEBUG_AP(f, a...) IWL_DEBUG(IWL_DL_AP, f, ## a)
-#define IWL_DEBUG_TXPOWER(f, a...) IWL_DEBUG(IWL_DL_TXPOWER, f, ## a)
-#define IWL_DEBUG_IO(f, a...) IWL_DEBUG(IWL_DL_IO, f, ## a)
-#define IWL_DEBUG_RATE(f, a...) IWL_DEBUG(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_RATE_LIMIT(f, a...) IWL_DEBUG_LIMIT(IWL_DL_RATE, f, ## a)
-#define IWL_DEBUG_NOTIF(f, a...) IWL_DEBUG(IWL_DL_NOTIF, f, ## a)
-#define IWL_DEBUG_ASSOC(f, a...) IWL_DEBUG(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_ASSOC_LIMIT(f, a...) \
-	IWL_DEBUG_LIMIT(IWL_DL_ASSOC | IWL_DL_INFO, f, ## a)
-#define IWL_DEBUG_HT(f, a...) IWL_DEBUG(IWL_DL_HT, f, ## a)
-#define IWL_DEBUG_STATS(f, a...) IWL_DEBUG(IWL_DL_STATS, f, ## a)
-#define IWL_DEBUG_TX_REPLY(f, a...) IWL_DEBUG(IWL_DL_TX_REPLY, f, ## a)
-#define IWL_DEBUG_QOS(f, a...)   IWL_DEBUG(IWL_DL_QOS, f, ## a)
-#define IWL_DEBUG_RADIO(f, a...)  IWL_DEBUG(IWL_DL_RADIO, f, ## a)
-#define IWL_DEBUG_POWER(f, a...)  IWL_DEBUG(IWL_DL_POWER, f, ## a)
-#define IWL_DEBUG_11H(f, a...)  IWL_DEBUG(IWL_DL_11H, f, ## a)
-
-#endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-eeprom.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-eeprom.h	2007-10-12 11:36:25.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,336 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *****************************************************************************/
-
-#ifndef __iwl_eeprom_h__
-#define __iwl_eeprom_h__
-
-/*
- * This file defines EEPROM related constants, enums, and inline functions.
- *
- */
-
-#define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
-#define IWL_EEPROM_ACCESS_DELAY		10   /* uSec */
-/* EEPROM field values */
-#define ANTENNA_SWITCH_NORMAL     0
-#define ANTENNA_SWITCH_INVERSE    1
-
-enum {
-	EEPROM_CHANNEL_VALID = (1 << 0),	/* usable for this SKU/geo */
-	EEPROM_CHANNEL_IBSS = (1 << 1),	/* usable as an IBSS channel */
-	/* Bit 2 Reserved */
-	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
-	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
-	EEPROM_CHANNEL_WIDE = (1 << 5),
-	EEPROM_CHANNEL_NARROW = (1 << 6),
-	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
-};
-
-/* EEPROM field lengths */
-#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
-
-/* EEPROM field lengths */
-#define EEPROM_BOARD_PBA_NUMBER_LENGTH                  11
-#define EEPROM_REGULATORY_SKU_ID_LENGTH                 4
-#define EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH         14
-#define EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH         13
-#define EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH         12
-#define EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH         11
-#define EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH         6
-
-#if IWL == 3945
-#define EEPROM_REGULATORY_CHANNELS_LENGTH ( \
-	EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH)
-#elif IWL == 4965
-#define EEPROM_REGULATORY_BAND_24_FAT_CHANNELS_LENGTH 7
-#define EEPROM_REGULATORY_BAND_52_FAT_CHANNELS_LENGTH 11
-#define EEPROM_REGULATORY_CHANNELS_LENGTH ( \
-	EEPROM_REGULATORY_BAND1_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND2_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND3_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND4_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND5_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND_24_FAT_CHANNELS_LENGTH + \
-	EEPROM_REGULATORY_BAND_52_FAT_CHANNELS_LENGTH)
-#endif
-
-#define EEPROM_REGULATORY_NUMBER_OF_BANDS               5
-
-/* SKU Capabilities */
-#define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
-#define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
-#define EEPROM_SKU_CAP_OP_MODE_MRC                      (1 << 7)
-
-/* *regulatory* channel data from eeprom, one for each channel */
-struct iwl_eeprom_channel {
-	u8 flags;		/* flags copied from EEPROM */
-	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
-} __attribute__ ((packed));
-
-/*
- * Mapping of a Tx power level, at factory calibration temperature,
- *   to a radio/DSP gain table index.
- * One for each of 5 "sample" power levels in each band.
- * v_det is measured at the factory, using the 3945's built-in power amplifier
- *   (PA) output voltage detector.  This same detector is used during Tx of
- *   long packets in normal operation to provide feedback as to proper output
- *   level.
- * Data copied from EEPROM.
- */
-struct iwl_eeprom_txpower_sample {
-	u8 gain_index;		/* index into power (gain) setup table ... */
-	s8 power;		/* ... for this pwr level for this chnl group */
-	u16 v_det;		/* PA output voltage */
-} __attribute__ ((packed));
-
-/*
- * Mappings of Tx power levels -> nominal radio/DSP gain table indexes.
- * One for each channel group (a.k.a. "band") (1 for BG, 4 for A).
- * Tx power setup code interpolates between the 5 "sample" power levels
- *    to determine the nominal setup for a requested power level.
- * Data copied from EEPROM.
- * DO NOT ALTER THIS STRUCTURE!!!
- */
-struct iwl_eeprom_txpower_group {
-	struct iwl_eeprom_txpower_sample samples[5];	/* 5 power levels */
-	s32 a, b, c, d, e;	/* coefficients for voltage->power
-				 * formula (signed) */
-	s32 Fa, Fb, Fc, Fd, Fe;	/* these modify coeffs based on
-					 * frequency (signed) */
-	s8 saturation_power;	/* highest power possible by h/w in this
-				 * band */
-	u8 group_channel;	/* "representative" channel # in this band */
-	s16 temperature;	/* h/w temperature at factory calib this band
-				 * (signed) */
-} __attribute__ ((packed));
-
-/*
- * Temperature-based Tx-power compensation data, not band-specific.
- * These coefficients are use to modify a/b/c/d/e coeffs based on
- *   difference between current temperature and factory calib temperature.
- * Data copied from EEPROM.
- */
-struct iwl_eeprom_temperature_corr {
-	u32 Ta;
-	u32 Tb;
-	u32 Tc;
-	u32 Td;
-	u32 Te;
-} __attribute__ ((packed));
-
-#if IWL == 4965
-#define EEPROM_TX_POWER_TX_CHAINS      (2)
-#define EEPROM_TX_POWER_BANDS          (8)
-#define EEPROM_TX_POWER_MEASUREMENTS   (3)
-#define EEPROM_TX_POWER_VERSION        (2)
-#define EEPROM_TX_POWER_VERSION_NEW    (5)
-
-struct iwl_eeprom_calib_measure {
-	u8 temperature;
-	u8 gain_idx;
-	u8 actual_pow;
-	s8 pa_det;
-} __attribute__ ((packed));
-
-struct iwl_eeprom_calib_ch_info {
-	u8 ch_num;
-	struct iwl_eeprom_calib_measure measurements[EEPROM_TX_POWER_TX_CHAINS]
-		[EEPROM_TX_POWER_MEASUREMENTS];
-} __attribute__ ((packed));
-
-struct iwl_eeprom_calib_subband_info {
-	u8 ch_from;
-	u8 ch_to;
-	struct iwl_eeprom_calib_ch_info ch1;
-	struct iwl_eeprom_calib_ch_info ch2;
-} __attribute__ ((packed));
-
-struct iwl_eeprom_calib_info {
-	u8 saturation_power24;
-	u8 saturation_power52;
-	s16 voltage;		/* signed */
-	struct iwl_eeprom_calib_subband_info band_info[EEPROM_TX_POWER_BANDS];
-} __attribute__ ((packed));
-
-#endif
-
-struct iwl_eeprom {
-	u8 reserved0[16];
-#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
-	u16 device_id;	/* abs.ofs: 16 */
-	u8 reserved1[2];
-#define EEPROM_PMC                          (2*0x0A)	/* 2 bytes */
-	u16 pmc;		/* abs.ofs: 20 */
-	u8 reserved2[20];
-#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
-	u8 mac_address[6];	/* abs.ofs: 42 */
-	u8 reserved3[58];
-#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
-	u16 board_revision;	/* abs.ofs: 106 */
-	u8 reserved4[11];
-#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
-	u8 board_pba_number[9];	/* abs.ofs: 119 */
-	u8 reserved5[8];
-#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
-	u16 version;		/* abs.ofs: 136 */
-#define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
-	u8 sku_cap;		/* abs.ofs: 138 */
-#define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
-	u8 leds_mode;		/* abs.ofs: 139 */
-#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
-	u16 oem_mode;
-#define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
-	u16 wowlan_mode;	/* abs.ofs: 142 */
-#define EEPROM_LEDS_TIME_INTERVAL           (2*0x48)	/* 2  bytes */
-	u16 leds_time_interval;	/* abs.ofs: 144 */
-#define EEPROM_LEDS_OFF_TIME                (2*0x49)	/* 1  bytes */
-	u8 leds_off_time;	/* abs.ofs: 146 */
-#define EEPROM_LEDS_ON_TIME                 (2*0x49+1)	/* 1  bytes */
-	u8 leds_on_time;	/* abs.ofs: 147 */
-#define EEPROM_ALMGOR_M_VERSION             (2*0x4A)	/* 1  bytes */
-	u8 almgor_m_version;	/* abs.ofs: 148 */
-#define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
-	u8 antenna_switch_type;	/* abs.ofs: 149 */
-#if IWL == 3945
-	u8 reserved6[42];
-#else
-	u8 reserved6[8];
-#define EEPROM_4965_BOARD_REVISION          (2*0x4F)	/* 2 bytes */
-	u16 board_revision_4965;	/* abs.ofs: 158 */
-	u8 reserved7[13];
-#define EEPROM_4965_BOARD_PBA               (2*0x56+1)	/* 9 bytes */
-	u8 board_pba_number_4965[9];	/* abs.ofs: 173 */
-	u8 reserved8[10];
-#endif
-#define EEPROM_REGULATORY_SKU_ID            (2*0x60)	/* 4  bytes */
-	u8 sku_id[4];		/* abs.ofs: 192 */
-#define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
-	u16 band_1_count;	/* abs.ofs: 196 */
-#define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
-	struct iwl_eeprom_channel band_1_channels[14];	/* abs.ofs: 196 */
-#define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
-	u16 band_2_count;	/* abs.ofs: 226 */
-#define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
-	struct iwl_eeprom_channel band_2_channels[13];	/* abs.ofs: 228 */
-#define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
-	u16 band_3_count;	/* abs.ofs: 254 */
-#define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
-	struct iwl_eeprom_channel band_3_channels[12];	/* abs.ofs: 256 */
-#define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
-	u16 band_4_count;	/* abs.ofs: 280 */
-#define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
-	struct iwl_eeprom_channel band_4_channels[11];	/* abs.ofs: 282 */
-#define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
-	u16 band_5_count;	/* abs.ofs: 304 */
-#define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
-	struct iwl_eeprom_channel band_5_channels[6];	/* abs.ofs: 306 */
-
-/* From here on out the EEPROM diverges between the 4965 and the 3945 */
-#if IWL == 3945
-
-	u8 reserved9[194];
-
-#define EEPROM_TXPOWER_CALIB_GROUP0 0x200
-#define EEPROM_TXPOWER_CALIB_GROUP1 0x240
-#define EEPROM_TXPOWER_CALIB_GROUP2 0x280
-#define EEPROM_TXPOWER_CALIB_GROUP3 0x2c0
-#define EEPROM_TXPOWER_CALIB_GROUP4 0x300
-#define IWL_NUM_TX_CALIB_GROUPS 5
-	struct iwl_eeprom_txpower_group groups[IWL_NUM_TX_CALIB_GROUPS];
-/* abs.ofs: 512 */
-#define EEPROM_CALIB_TEMPERATURE_CORRECT 0x340
-	struct iwl_eeprom_temperature_corr corrections;	/* abs.ofs: 832 */
-	u8 reserved16[172];	/* fill out to full 1024 byte block */
-
-/* 4965AGN adds fat channel support */
-#elif IWL == 4965
-
-	u8 reserved10[2];
-#define EEPROM_REGULATORY_BAND_24_FAT_CHANNELS (2*0xA0)	/* 14 bytes */
-	struct iwl_eeprom_channel band_24_channels[7];	/* abs.ofs: 320 */
-	u8 reserved11[2];
-#define EEPROM_REGULATORY_BAND_52_FAT_CHANNELS (2*0xA8)	/* 22 bytes */
-	struct iwl_eeprom_channel band_52_channels[11];	/* abs.ofs: 336 */
-	u8 reserved12[6];
-#define EEPROM_CALIB_VERSION_OFFSET            (2*0xB6)	/* 2 bytes */
-	u16 calib_version;	/* abs.ofs: 364 */
-	u8 reserved13[2];
-#define EEPROM_SATURATION_POWER_OFFSET         (2*0xB8)	/* 2 bytes */
-	u16 satruation_power;	/* abs.ofs: 368 */
-	u8 reserved14[94];
-#define EEPROM_IWL_CALIB_TXPOWER_OFFSET        (2*0xE8)	/* 48  bytes */
-	struct iwl_eeprom_calib_info calib_info;	/* abs.ofs: 464 */
-
-	u8 reserved16[140];	/* fill out to full 1024 byte block */
-
-#endif
-
-} __attribute__ ((packed));
-
-#define IWL_EEPROM_IMAGE_SIZE 1024
-
-#endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-hw.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-hw.h	2007-10-12 11:24:17.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,537 +0,0 @@
-/******************************************************************************
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU Geeral Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
- *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
- *
- * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2007 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *****************************************************************************/
-
-#ifndef	__iwlwifi_hw_h__
-#define __iwlwifi_hw_h__
-
-/*
- * This file defines hardware constants common to 3945 and 4965.
- *
- * Device-specific constants are defined in iwl-3945-hw.h and iwl-4965-hw.h,
- * although this file contains a few definitions for which the .c
- * implementation is the same for 3945 and 4965, except for the value of
- * a constant.
- *
- * uCode API constants are defined in iwl-commands.h.
- *
- * NOTE:  DO NOT PUT OS IMPLEMENTATION-SPECIFIC DECLARATIONS HERE
- *
- * The iwl-*hw.h (and files they include) files should remain OS/driver
- * implementation independent, declaring only the hardware interface.
- */
-
-/* uCode queue management definitions */
-#define IWL_CMD_QUEUE_NUM       4
-#define IWL_CMD_FIFO_NUM        4
-#define IWL_BACK_QUEUE_FIRST_ID 7
-
-/* Tx rates */
-#define IWL_CCK_RATES 4
-#define IWL_OFDM_RATES 8
-
-#if IWL == 3945
-#define IWL_HT_RATES 0
-#elif IWL == 4965
-#define IWL_HT_RATES 16
-#endif
-
-#define IWL_MAX_RATES  (IWL_CCK_RATES+IWL_OFDM_RATES+IWL_HT_RATES)
-
-/* Time constants */
-#define SHORT_SLOT_TIME 9
-#define LONG_SLOT_TIME 20
-
-/* RSSI to dBm */
-#if IWL == 3945
-#define IWL_RSSI_OFFSET	95
-#elif IWL == 4965
-#define IWL_RSSI_OFFSET	44
-#endif
-
-#include "iwl-eeprom.h"
-#include "iwl-commands.h"
-
-#define PCI_LINK_CTRL      0x0F0
-#define PCI_POWER_SOURCE   0x0C8
-#define PCI_REG_WUM8       0x0E8
-#define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
-
-/*=== CSR (control and status registers) ===*/
-#define CSR_BASE    (0x000)
-
-#define CSR_SW_VER              (CSR_BASE+0x000)
-#define CSR_HW_IF_CONFIG_REG    (CSR_BASE+0x000) /* hardware interface config */
-#define CSR_INT_COALESCING      (CSR_BASE+0x004) /* accum ints, 32-usec units */
-#define CSR_INT                 (CSR_BASE+0x008) /* host interrupt status/ack */
-#define CSR_INT_MASK            (CSR_BASE+0x00c) /* host interrupt enable */
-#define CSR_FH_INT_STATUS       (CSR_BASE+0x010) /* busmaster int status/ack*/
-#define CSR_GPIO_IN             (CSR_BASE+0x018) /* read external chip pins */
-#define CSR_RESET               (CSR_BASE+0x020) /* busmaster enable, NMI, etc*/
-#define CSR_GP_CNTRL            (CSR_BASE+0x024)
-#define CSR_HW_REV              (CSR_BASE+0x028)
-#define CSR_EEPROM_REG          (CSR_BASE+0x02c)
-#define CSR_EEPROM_GP           (CSR_BASE+0x030)
-#define CSR_GP_UCODE		(CSR_BASE+0x044)
-#define CSR_UCODE_DRV_GP1       (CSR_BASE+0x054)
-#define CSR_UCODE_DRV_GP1_SET   (CSR_BASE+0x058)
-#define CSR_UCODE_DRV_GP1_CLR   (CSR_BASE+0x05c)
-#define CSR_UCODE_DRV_GP2       (CSR_BASE+0x060)
-#define CSR_LED_REG		(CSR_BASE+0x094)
-#define CSR_DRAM_INT_TBL_CTL	(CSR_BASE+0x0A0)
-#define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
-#define CSR_ANA_PLL_CFG         (CSR_BASE+0x20c)
-#define CSR_HW_REV_WA_REG	(CSR_BASE+0x22C)
-
-/* HW I/F configuration */
-#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MB         (0x00000100)
-#define CSR_HW_IF_CONFIG_REG_BIT_ALMAGOR_MM         (0x00000200)
-#define CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC            (0x00000400)
-#define CSR_HW_IF_CONFIG_REG_BIT_BOARD_TYPE         (0x00000800)
-#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_A    (0x00000000)
-#define CSR_HW_IF_CONFIG_REG_BITS_SILICON_TYPE_B    (0x00001000)
-#define CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM     (0x00200000)
-
-/* interrupt flags in INTA, set by uCode or hardware (e.g. dma),
- * acknowledged (reset) by host writing "1" to flagged bits. */
-#define CSR_INT_BIT_FH_RX        (1<<31) /* Rx DMA, cmd responses, FH_INT[17:16] */
-#define CSR_INT_BIT_HW_ERR       (1<<29) /* DMA hardware error FH_INT[31] */
-#define CSR_INT_BIT_DNLD         (1<<28) /* uCode Download */
-#define CSR_INT_BIT_FH_TX        (1<<27) /* Tx DMA FH_INT[1:0] */
-#define CSR_INT_BIT_MAC_CLK_ACTV (1<<26) /* NIC controller's clock toggled on/off */
-#define CSR_INT_BIT_SW_ERR       (1<<25) /* uCode error */
-#define CSR_INT_BIT_RF_KILL      (1<<7)  /* HW RFKILL switch GP_CNTRL[27] toggled */
-#define CSR_INT_BIT_CT_KILL      (1<<6)  /* Critical temp (chip too hot) rfkill */
-#define CSR_INT_BIT_SW_RX        (1<<3)  /* Rx, command responses, 3945 */
-#define CSR_INT_BIT_WAKEUP       (1<<1)  /* NIC controller waking up (pwr mgmt) */
-#define CSR_INT_BIT_ALIVE        (1<<0)  /* uCode interrupts once it initializes */
-
-#define CSR_INI_SET_MASK	(CSR_INT_BIT_FH_RX   | \
-				 CSR_INT_BIT_HW_ERR  | \
-				 CSR_INT_BIT_FH_TX   | \
-				 CSR_INT_BIT_SW_ERR  | \
-				 CSR_INT_BIT_RF_KILL | \
-				 CSR_INT_BIT_SW_RX   | \
-				 CSR_INT_BIT_WAKEUP  | \
-				 CSR_INT_BIT_ALIVE)
-
-/* interrupt flags in FH (flow handler) (PCI busmaster DMA) */
-#define CSR_FH_INT_BIT_ERR       (1<<31) /* Error */
-#define CSR_FH_INT_BIT_HI_PRIOR  (1<<30) /* High priority Rx, bypass coalescing */
-#define CSR_FH_INT_BIT_RX_CHNL2  (1<<18) /* Rx channel 2 (3945 only) */
-#define CSR_FH_INT_BIT_RX_CHNL1  (1<<17) /* Rx channel 1 */
-#define CSR_FH_INT_BIT_RX_CHNL0  (1<<16) /* Rx channel 0 */
-#define CSR_FH_INT_BIT_TX_CHNL6  (1<<6)  /* Tx channel 6 (3945 only) */
-#define CSR_FH_INT_BIT_TX_CHNL1  (1<<1)  /* Tx channel 1 */
-#define CSR_FH_INT_BIT_TX_CHNL0  (1<<0)  /* Tx channel 0 */
-
-#define CSR_FH_INT_RX_MASK	(CSR_FH_INT_BIT_HI_PRIOR | \
-				 CSR_FH_INT_BIT_RX_CHNL2 | \
-				 CSR_FH_INT_BIT_RX_CHNL1 | \
-				 CSR_FH_INT_BIT_RX_CHNL0)
-
-#define CSR_FH_INT_TX_MASK	(CSR_FH_INT_BIT_TX_CHNL6 | \
-				 CSR_FH_INT_BIT_TX_CHNL1 | \
-				 CSR_FH_INT_BIT_TX_CHNL0 )
-
-
-/* RESET */
-#define CSR_RESET_REG_FLAG_NEVO_RESET                (0x00000001)
-#define CSR_RESET_REG_FLAG_FORCE_NMI                 (0x00000002)
-#define CSR_RESET_REG_FLAG_SW_RESET                  (0x00000080)
-#define CSR_RESET_REG_FLAG_MASTER_DISABLED           (0x00000100)
-#define CSR_RESET_REG_FLAG_STOP_MASTER               (0x00000200)
-
-/* GP (general purpose) CONTROL */
-#define CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY        (0x00000001)
-#define CSR_GP_CNTRL_REG_FLAG_INIT_DONE              (0x00000004)
-#define CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ         (0x00000008)
-#define CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP         (0x00000010)
-
-#define CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN           (0x00000001)
-
-#define CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE         (0x07000000)
-#define CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE         (0x04000000)
-#define CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW          (0x08000000)
-
-
-/* EEPROM REG */
-#define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
-#define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
-
-/* EEPROM GP */
-#define CSR_EEPROM_GP_VALID_MSK		(0x00000006)
-#define CSR_EEPROM_GP_BAD_SIGNATURE	(0x00000000)
-#define CSR_EEPROM_GP_IF_OWNER_MSK	(0x00000180)
-
-/* UCODE DRV GP */
-#define CSR_UCODE_DRV_GP1_BIT_MAC_SLEEP             (0x00000001)
-#define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
-#define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
-#define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
-
-/* GPIO */
-#define CSR_GPIO_IN_BIT_AUX_POWER                   (0x00000200)
-#define CSR_GPIO_IN_VAL_VAUX_PWR_SRC                (0x00000000)
-#define CSR_GPIO_IN_VAL_VMAIN_PWR_SRC		CSR_GPIO_IN_BIT_AUX_POWER
-
-/* GI Chicken Bits */
-#define CSR_GIO_CHICKEN_BITS_REG_BIT_L1A_NO_L0S_RX  (0x00800000)
-#define CSR_GIO_CHICKEN_BITS_REG_BIT_DIS_L0S_EXIT_TIMER  (0x20000000)
-
-/* CSR_ANA_PLL_CFG */
-#define CSR_ANA_PLL_CFG_SH		(0x00880300)
-
-#define CSR_LED_REG_TRUN_ON		(0x00000078)
-#define CSR_LED_REG_TRUN_OFF		(0x00000038)
-#define CSR_LED_BSM_CTRL_MSK		(0xFFFFFFDF)
-
-/* DRAM_INT_TBL_CTRL */
-#define CSR_DRAM_INT_TBL_CTRL_EN	(1<<31)
-#define CSR_DRAM_INT_TBL_CTRL_WRAP_CHK	(1<<27)
-
-/*=== HBUS (Host-side Bus) ===*/
-#define HBUS_BASE	(0x400)
-
-#define HBUS_TARG_MEM_RADDR     (HBUS_BASE+0x00c)
-#define HBUS_TARG_MEM_WADDR     (HBUS_BASE+0x010)
-#define HBUS_TARG_MEM_WDAT      (HBUS_BASE+0x018)
-#define HBUS_TARG_MEM_RDAT      (HBUS_BASE+0x01c)
-#define HBUS_TARG_PRPH_WADDR    (HBUS_BASE+0x044)
-#define HBUS_TARG_PRPH_RADDR    (HBUS_BASE+0x048)
-#define HBUS_TARG_PRPH_WDAT     (HBUS_BASE+0x04c)
-#define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
-#define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
-
-#define HBUS_TARG_MBX_C         (HBUS_BASE+0x030)
-
-
-/* SCD (Scheduler) */
-#define SCD_BASE                        (CSR_BASE + 0x2E00)
-
-#define SCD_MODE_REG                    (SCD_BASE + 0x000)
-#define SCD_ARASTAT_REG                 (SCD_BASE + 0x004)
-#define SCD_TXFACT_REG                  (SCD_BASE + 0x010)
-#define SCD_TXF4MF_REG                  (SCD_BASE + 0x014)
-#define SCD_TXF5MF_REG                  (SCD_BASE + 0x020)
-#define SCD_SBYP_MODE_1_REG             (SCD_BASE + 0x02C)
-#define SCD_SBYP_MODE_2_REG             (SCD_BASE + 0x030)
-
-/*=== FH (data Flow Handler) ===*/
-#define FH_BASE     (0x800)
-
-#define FH_CBCC_TABLE           (FH_BASE+0x140)
-#define FH_TFDB_TABLE           (FH_BASE+0x180)
-#define FH_RCSR_TABLE           (FH_BASE+0x400)
-#define FH_RSSR_TABLE           (FH_BASE+0x4c0)
-#define FH_TCSR_TABLE           (FH_BASE+0x500)
-#define FH_TSSR_TABLE           (FH_BASE+0x680)
-
-/* TFDB (Transmit Frame Buffer Descriptor) */
-#define FH_TFDB(_channel, buf) \
-	(FH_TFDB_TABLE+((_channel)*2+(buf))*0x28)
-#define ALM_FH_TFDB_CHNL_BUF_CTRL_REG(_channel) \
-	(FH_TFDB_TABLE + 0x50 * _channel)
-/* CBCC _channel is [0,2] */
-#define FH_CBCC(_channel)           (FH_CBCC_TABLE+(_channel)*0x8)
-#define FH_CBCC_CTRL(_channel)      (FH_CBCC(_channel)+0x00)
-#define FH_CBCC_BASE(_channel)      (FH_CBCC(_channel)+0x04)
-
-/* RCSR _channel is [0,2] */
-#define FH_RCSR(_channel)           (FH_RCSR_TABLE+(_channel)*0x40)
-#define FH_RCSR_CONFIG(_channel)    (FH_RCSR(_channel)+0x00)
-#define FH_RCSR_RBD_BASE(_channel)  (FH_RCSR(_channel)+0x04)
-#define FH_RCSR_WPTR(_channel)      (FH_RCSR(_channel)+0x20)
-#define FH_RCSR_RPTR_ADDR(_channel) (FH_RCSR(_channel)+0x24)
-
-#if IWL == 3945
-#define FH_RSCSR_CHNL0_WPTR        (FH_RCSR_WPTR(0))
-#elif IWL == 4965
-#define FH_RSCSR_CHNL0_WPTR        (FH_RSCSR_CHNL0_RBDCB_WPTR_REG)
-#endif
-
-/* RSSR */
-#define FH_RSSR_CTRL            (FH_RSSR_TABLE+0x000)
-#define FH_RSSR_STATUS          (FH_RSSR_TABLE+0x004)
-/* TCSR */
-#define FH_TCSR(_channel)           (FH_TCSR_TABLE+(_channel)*0x20)
-#define FH_TCSR_CONFIG(_channel)    (FH_TCSR(_channel)+0x00)
-#define FH_TCSR_CREDIT(_channel)    (FH_TCSR(_channel)+0x04)
-#define FH_TCSR_BUFF_STTS(_channel) (FH_TCSR(_channel)+0x08)
-/* TSSR */
-#define FH_TSSR_CBB_BASE        (FH_TSSR_TABLE+0x000)
-#define FH_TSSR_MSG_CONFIG      (FH_TSSR_TABLE+0x008)
-#define FH_TSSR_TX_STATUS       (FH_TSSR_TABLE+0x010)
-/* 18 - reserved */
-
-/* card static random access memory (SRAM) for processor data and instructs */
-#define RTC_INST_LOWER_BOUND			(0x000000)
-#define RTC_DATA_LOWER_BOUND			(0x800000)
-
-
-/* DBM */
-
-#define ALM_FH_SRVC_CHNL                            (6)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE     (20)
-#define ALM_FH_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH      (4)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN    (0x08000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE        (0x80000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE           (0x20000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128         (0x01000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST         (0x00001000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH               (0x00000000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF              (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRIVER           (0x00000001)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL    (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD           (0x00200000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT            (0x00000000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE            (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
-
-#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID          (0x00004000)
-
-#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_BIT_TFDB_WPTR           (0x00000001)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON      (0xFF000000)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON      (0x00FF0000)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B    (0x00000400)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON       (0x00000100)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON       (0x00000080)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH     (0x00000020)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH           (0x00000005)
-
-#define ALM_TB_MAX_BYTES_COUNT      (0xFFF0)
-
-#define ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) \
-	((1LU << _channel) << 24)
-#define ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel) \
-	((1LU << _channel) << 16)
-
-#define ALM_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_channel) \
-	(ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) | \
-	 ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel))
-#define PCI_CFG_REV_ID_BIT_BASIC_SKU                (0x40)	/* bit 6    */
-#define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
-
-#define HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED         (0x00000004)
-
-#define TFD_QUEUE_MIN           0
-#define TFD_QUEUE_MAX           6
-#define TFD_QUEUE_SIZE_MAX      (256)
-
-/* spectrum and channel data structures */
-#define IWL_NUM_SCAN_RATES         (2)
-
-#define IWL_SCAN_FLAG_24GHZ  (1<<0)
-#define IWL_SCAN_FLAG_52GHZ  (1<<1)
-#define IWL_SCAN_FLAG_ACTIVE (1<<2)
-#define IWL_SCAN_FLAG_DIRECT (1<<3)
-
-#define IWL_MAX_CMD_SIZE 1024
-
-#define IWL_DEFAULT_TX_RETRY  15
-#define IWL_MAX_TX_RETRY      16
-
-/*********************************************/
-
-#define RFD_SIZE                              4
-#define NUM_TFD_CHUNKS                        4
-
-#define RX_QUEUE_SIZE                         256
-#define RX_QUEUE_MASK                         255
-#define RX_QUEUE_SIZE_LOG                     8
-
-/* QoS  definitions */
-
-#define CW_MIN_OFDM          15
-#define CW_MAX_OFDM          1023
-#define CW_MIN_CCK           31
-#define CW_MAX_CCK           1023
-
-#define QOS_TX0_CW_MIN_OFDM      CW_MIN_OFDM
-#define QOS_TX1_CW_MIN_OFDM      CW_MIN_OFDM
-#define QOS_TX2_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
-#define QOS_TX3_CW_MIN_OFDM      ((CW_MIN_OFDM + 1) / 4 - 1)
-
-#define QOS_TX0_CW_MIN_CCK       CW_MIN_CCK
-#define QOS_TX1_CW_MIN_CCK       CW_MIN_CCK
-#define QOS_TX2_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
-#define QOS_TX3_CW_MIN_CCK       ((CW_MIN_CCK + 1) / 4 - 1)
-
-#define QOS_TX0_CW_MAX_OFDM      CW_MAX_OFDM
-#define QOS_TX1_CW_MAX_OFDM      CW_MAX_OFDM
-#define QOS_TX2_CW_MAX_OFDM      CW_MIN_OFDM
-#define QOS_TX3_CW_MAX_OFDM      ((CW_MIN_OFDM + 1) / 2 - 1)
-
-#define QOS_TX0_CW_MAX_CCK       CW_MAX_CCK
-#define QOS_TX1_CW_MAX_CCK       CW_MAX_CCK
-#define QOS_TX2_CW_MAX_CCK       CW_MIN_CCK
-#define QOS_TX3_CW_MAX_CCK       ((CW_MIN_CCK + 1) / 2 - 1)
-
-#define QOS_TX0_AIFS            3
-#define QOS_TX1_AIFS            7
-#define QOS_TX2_AIFS            2
-#define QOS_TX3_AIFS            2
-
-#define QOS_TX0_ACM             0
-#define QOS_TX1_ACM             0
-#define QOS_TX2_ACM             0
-#define QOS_TX3_ACM             0
-
-#define QOS_TX0_TXOP_LIMIT_CCK          0
-#define QOS_TX1_TXOP_LIMIT_CCK          0
-#define QOS_TX2_TXOP_LIMIT_CCK          6016
-#define QOS_TX3_TXOP_LIMIT_CCK          3264
-
-#define QOS_TX0_TXOP_LIMIT_OFDM      0
-#define QOS_TX1_TXOP_LIMIT_OFDM      0
-#define QOS_TX2_TXOP_LIMIT_OFDM      3008
-#define QOS_TX3_TXOP_LIMIT_OFDM      1504
-
-#define DEF_TX0_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX1_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX2_CW_MIN_OFDM      CW_MIN_OFDM
-#define DEF_TX3_CW_MIN_OFDM      CW_MIN_OFDM
-
-#define DEF_TX0_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX1_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX2_CW_MIN_CCK       CW_MIN_CCK
-#define DEF_TX3_CW_MIN_CCK       CW_MIN_CCK
-
-#define DEF_TX0_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX1_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX2_CW_MAX_OFDM      CW_MAX_OFDM
-#define DEF_TX3_CW_MAX_OFDM      CW_MAX_OFDM
-
-#define DEF_TX0_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX1_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX2_CW_MAX_CCK       CW_MAX_CCK
-#define DEF_TX3_CW_MAX_CCK       CW_MAX_CCK
-
-#define DEF_TX0_AIFS            (2)
-#define DEF_TX1_AIFS            (2)
-#define DEF_TX2_AIFS            (2)
-#define DEF_TX3_AIFS            (2)
-
-#define DEF_TX0_ACM             0
-#define DEF_TX1_ACM             0
-#define DEF_TX2_ACM             0
-#define DEF_TX3_ACM             0
-
-#define DEF_TX0_TXOP_LIMIT_CCK        0
-#define DEF_TX1_TXOP_LIMIT_CCK        0
-#define DEF_TX2_TXOP_LIMIT_CCK        0
-#define DEF_TX3_TXOP_LIMIT_CCK        0
-
-#define DEF_TX0_TXOP_LIMIT_OFDM       0
-#define DEF_TX1_TXOP_LIMIT_OFDM       0
-#define DEF_TX2_TXOP_LIMIT_OFDM       0
-#define DEF_TX3_TXOP_LIMIT_OFDM       0
-
-#define QOS_QOS_SETS                  3
-#define QOS_PARAM_SET_ACTIVE          0
-#define QOS_PARAM_SET_DEF_CCK         1
-#define QOS_PARAM_SET_DEF_OFDM        2
-
-#define CTRL_QOS_NO_ACK               (0x0020)
-#define DCT_FLAG_EXT_QOS_ENABLED      (0x10)
-
-#define U32_PAD(n)		((4-(n))&0x3)
-
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues
- */
-#define TFD_CTL_COUNT_SET(n)       (n<<24)
-#define TFD_CTL_COUNT_GET(ctl)     ((ctl>>24) & 7)
-#define TFD_CTL_PAD_SET(n)         (n<<28)
-#define TFD_CTL_PAD_GET(ctl)       (ctl>>28)
-
-#define TFD_TX_CMD_SLOTS 256
-#define TFD_CMD_SLOTS 32
-
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
-			      sizeof(struct iwl_cmd_meta))
-
-/*
- * RX related structures and functions
- */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
-
-#endif				/* __iwlwifi_hw_h__ */
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-io.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-io.h	2007-10-12 11:43:06.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,470 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2007 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __iwl_io_h__
-#define __iwl_io_h__
-
-#include <linux/io.h>
-
-#include "iwl-debug.h"
-
-/*
- * IO, register, and NIC memory access functions
- *
- * NOTE on naming convention and macro usage for these
- *
- * A single _ prefix before a an access function means that no state
- * check or debug information is printed when that function is called.
- *
- * A double __ prefix before an access function means that state is checked
- * (in the case of *restricted calls) and the current line number is printed
- * in addition to any other debug output.
- *
- * The non-prefixed name is the #define that maps the caller into a
- * #define that provides the caller's __LINE__ to the double prefix version.
- *
- * If you wish to call the function without any debug or state checking,
- * you should use the single _ prefix version (as is used by dependent IO
- * routines, for example _iwl_read_restricted calls the non-check version of
- * _iwl_read32.)
- *
- * These declarations are *extremely* useful in quickly isolating code deltas
- * which result in misconfiguring of the hardware I/O.  In combination with
- * git-bisect and the IO debug level you can quickly determine the specific
- * commit which breaks the IO sequence to the hardware.
- *
- */
-
-#define _iwl_write32(iwl, ofs, val) writel((val), (iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_write32(const char *f, u32 l, struct iwl_priv *iwl,
-				 u32 ofs, u32 val)
-{
-	IWL_DEBUG_IO("write_direct32(0x%08X, 0x%08X) - %s %d\n",
-		     (u32) (ofs), (u32) (val), f, l);
-	_iwl_write32(iwl, ofs, val);
-}
-#define iwl_write32(iwl, ofs, val) \
-	__iwl_write32(__FILE__, __LINE__, iwl, ofs, val)
-#else
-#define iwl_write32(iwl, ofs, val) _iwl_write32(iwl, ofs, val)
-#endif
-
-#define _iwl_read32(iwl, ofs) readl((iwl)->hw_base + (ofs))
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *iwl, u32 ofs)
-{
-	IWL_DEBUG_IO("read_direct32(0x%08X) - %s %d\n", ofs, f, l);
-	return _iwl_read32(iwl, ofs);
-}
-#define iwl_read32(iwl, ofs) __iwl_read32(__FILE__, __LINE__, iwl, ofs)
-#else
-#define iwl_read32(p, o) _iwl_read32(p, o)
-#endif
-
-static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
-				u32 bits, u32 mask, int timeout)
-{
-	int i = 0;
-
-	do {
-		if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
-			return i;
-		mdelay(10);
-		i += 10;
-	} while (i < timeout);
-
-	return -ETIMEDOUT;
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl_poll_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 addr,
-				 u32 bits, u32 mask, int timeout)
-{
-	int rc = _iwl_poll_bit(priv, addr, bits, mask, timeout);
-	if (unlikely(rc == -ETIMEDOUT))
-		IWL_DEBUG_IO
-		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) - timedout - %s %d\n",
-		     addr, bits, mask, f, l);
-	else
-		IWL_DEBUG_IO
-		    ("poll_bit(0x%08X, 0x%08X, 0x%08X) = 0x%08X - %s %d\n",
-		     addr, bits, mask, rc, f, l);
-	return rc;
-}
-#define iwl_poll_bit(iwl, addr, bits, mask, timeout) \
-	__iwl_poll_bit(__FILE__, __LINE__, iwl, addr, bits, mask, timeout)
-#else
-#define iwl_poll_bit(p, a, b, m, t) _iwl_poll_bit(p, a, b, m, t)
-#endif
-
-static inline void _iwl_set_bit(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	_iwl_write32(priv, reg, _iwl_read32(priv, reg) | mask);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bit(const char *f, u32 l,
-				 struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl_read32(priv, reg) | mask;
-	IWL_DEBUG_IO("set_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl_write32(priv, reg, val);
-}
-#define iwl_set_bit(p, r, m) __iwl_set_bit(__FILE__, __LINE__, p, r, m)
-#else
-#define iwl_set_bit(p, r, m) _iwl_set_bit(p, r, m)
-#endif
-
-static inline void _iwl_clear_bit(struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	_iwl_write32(priv, reg, _iwl_read32(priv, reg) & ~mask);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_clear_bit(const char *f, u32 l,
-				   struct iwl_priv *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl_read32(priv, reg) & ~mask;
-	IWL_DEBUG_IO("clear_bit(0x%08X, 0x%08X) = 0x%08X\n", reg, mask, val);
-	_iwl_write32(priv, reg, val);
-}
-#define iwl_clear_bit(p, r, m) __iwl_clear_bit(__FILE__, __LINE__, p, r, m)
-#else
-#define iwl_clear_bit(p, r, m) _iwl_clear_bit(p, r, m)
-#endif
-
-static inline int _iwl_grab_restricted_access(struct iwl_priv *priv)
-{
-	int rc;
-	u32 gp_ctl;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (atomic_read(&priv->restrict_refcnt))
-		return 0;
-#endif
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-	    test_bit(STATUS_RF_KILL_SW, &priv->status)) {
-		IWL_WARNING("WARNING: Requesting MAC access during RFKILL "
-			"wakes up NIC\n");
-
-		/* 10 msec allows time for NIC to complete its data save */
-		gp_ctl = _iwl_read32(priv, CSR_GP_CNTRL);
-		if (gp_ctl & CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY) {
-			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
-				"gpctl = 0x%08x\n", gp_ctl);
-			mdelay(10);
-		} else
-			IWL_DEBUG_RF_KILL("power-down complete, "
-					  "gpctl = 0x%08x\n", gp_ctl);
-	}
-
-	/* this bit wakes up the NIC */
-	_iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-	rc = _iwl_poll_bit(priv, CSR_GP_CNTRL,
-			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 50);
-	if (rc < 0) {
-		IWL_ERROR("MAC is in deep sleep!\n");
-		return -EIO;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	atomic_inc(&priv->restrict_refcnt);
-#endif
-	return 0;
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl_grab_restricted_access(const char *f, u32 l,
-					       struct iwl_priv *priv)
-{
-	if (atomic_read(&priv->restrict_refcnt))
-		IWL_DEBUG_INFO("Grabbing access while already held at "
-			       "line %d.\n", l);
-
-	IWL_DEBUG_IO("grabbing restricted access - %s %d\n", f, l);
-
-	return _iwl_grab_restricted_access(priv);
-}
-#define iwl_grab_restricted_access(priv) \
-	__iwl_grab_restricted_access(__FILE__, __LINE__, priv)
-#else
-#define iwl_grab_restricted_access(priv) \
-	_iwl_grab_restricted_access(priv)
-#endif
-
-static inline void _iwl_release_restricted_access(struct iwl_priv *priv)
-{
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (atomic_dec_and_test(&priv->restrict_refcnt))
-#endif
-		_iwl_clear_bit(priv, CSR_GP_CNTRL,
-			       CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_release_restricted_access(const char *f, u32 l,
-						   struct iwl_priv *priv)
-{
-	if (atomic_read(&priv->restrict_refcnt) <= 0)
-		IWL_ERROR("Release unheld restricted access at line %d.\n", l);
-
-	IWL_DEBUG_IO("releasing restricted access - %s %d\n", f, l);
-	_iwl_release_restricted_access(priv);
-}
-#define iwl_release_restricted_access(priv) \
-	__iwl_release_restricted_access(__FILE__, __LINE__, priv)
-#else
-#define iwl_release_restricted_access(priv) \
-	_iwl_release_restricted_access(priv)
-#endif
-
-static inline u32 _iwl_read_restricted(struct iwl_priv *priv, u32 reg)
-{
-	return _iwl_read32(priv, reg);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read_restricted(const char *f, u32 l,
-					struct iwl_priv *priv, u32 reg)
-{
-	u32 value = _iwl_read_restricted(priv, reg);
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from %s %d\n", f, l);
-	IWL_DEBUG_IO("read_restricted(0x%4X) = 0x%08x - %s %d \n", reg, value,
-		     f, l);
-	return value;
-}
-#define iwl_read_restricted(priv, reg) \
-	__iwl_read_restricted(__FILE__, __LINE__, priv, reg)
-#else
-#define iwl_read_restricted _iwl_read_restricted
-#endif
-
-static inline void _iwl_write_restricted(struct iwl_priv *priv,
-					 u32 reg, u32 value)
-{
-	_iwl_write32(priv, reg, value);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static void __iwl_write_restricted(u32 line,
-				   struct iwl_priv *priv, u32 reg, u32 value)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_write_restricted(priv, reg, value);
-}
-#define iwl_write_restricted(priv, reg, value) \
-	__iwl_write_restricted(__LINE__, priv, reg, value)
-#else
-#define iwl_write_restricted _iwl_write_restricted
-#endif
-
-static inline void iwl_write_buffer_restricted(struct iwl_priv *priv,
-					       u32 reg, u32 len, u32 *values)
-{
-	u32 count = sizeof(u32);
-
-	if ((priv != NULL) && (values != NULL)) {
-		for (; 0 < len; len -= count, reg += count, values++)
-			_iwl_write_restricted(priv, reg, *values);
-	}
-}
-
-static inline int _iwl_poll_restricted_bit(struct iwl_priv *priv,
-					   u32 addr, u32 mask, int timeout)
-{
-	int i = 0;
-
-	do {
-		if ((_iwl_read_restricted(priv, addr) & mask) == mask)
-			return i;
-		mdelay(10);
-		i += 10;
-	} while (i < timeout);
-
-	return -ETIMEDOUT;
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
-					    struct iwl_priv *priv,
-					    u32 addr, u32 mask, int timeout)
-{
-	int rc = _iwl_poll_restricted_bit(priv, addr, mask, timeout);
-
-	if (unlikely(rc == -ETIMEDOUT))
-		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) - "
-			     "timedout - %s %d\n", addr, mask, f, l);
-	else
-		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) = 0x%08X "
-			     "- %s %d\n", addr, mask, rc, f, l);
-	return rc;
-}
-#define iwl_poll_restricted_bit(iwl, addr, mask, timeout) \
-	__iwl_poll_restricted_bit(__FILE__, __LINE__, iwl, addr, mask, timeout)
-#else
-#define iwl_poll_restricted_bit _iwl_poll_restricted_bit
-#endif
-
-static inline u32 _iwl_read_restricted_reg(struct iwl_priv *priv, u32 reg)
-{
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	return _iwl_read_restricted(priv, HBUS_TARG_PRPH_RDAT);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline u32 __iwl_read_restricted_reg(u32 line,
-					    struct iwl_priv *priv, u32 reg)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
-	return _iwl_read_restricted_reg(priv, reg);
-}
-
-#define iwl_read_restricted_reg(priv, reg) \
-	__iwl_read_restricted_reg(__LINE__, priv, reg)
-#else
-#define iwl_read_restricted_reg _iwl_read_restricted_reg
-#endif
-
-static inline void _iwl_write_restricted_reg(struct iwl_priv *priv,
-					     u32 addr, u32 val)
-{
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WADDR,
-			      ((addr & 0x0000FFFF) | (3 << 24)));
-	_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT, val);
-}
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_write_restricted_reg(u32 line,
-					      struct iwl_priv *priv,
-					      u32 addr, u32 val)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_write_restricted_reg(priv, addr, val);
-}
-
-#define iwl_write_restricted_reg(priv, addr, val) \
-	__iwl_write_restricted_reg(__LINE__, priv, addr, val);
-#else
-#define iwl_write_restricted_reg _iwl_write_restricted_reg
-#endif
-
-#define _iwl_set_bits_restricted_reg(priv, reg, mask) \
-	_iwl_write_restricted_reg(priv, reg, \
-				  (_iwl_read_restricted_reg(priv, reg) | mask))
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bits_restricted_reg(u32 line, struct iwl_priv
-						 *priv, u32 reg, u32 mask)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_set_bits_restricted_reg(priv, reg, mask);
-}
-#define iwl_set_bits_restricted_reg(priv, reg, mask) \
-	__iwl_set_bits_restricted_reg(__LINE__, priv, reg, mask)
-#else
-#define iwl_set_bits_restricted_reg _iwl_set_bits_restricted_reg
-#endif
-
-#define _iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
-	_iwl_write_restricted_reg( \
-	    priv, reg, ((_iwl_read_restricted_reg(priv, reg) & mask) | bits))
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void __iwl_set_bits_mask_restricted_reg(u32 line,
-		struct iwl_priv *priv, u32 reg, u32 bits, u32 mask)
-{
-	if (!atomic_read(&priv->restrict_refcnt))
-		IWL_ERROR("Unrestricted access from line %d\n", line);
-	_iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask);
-}
-
-#define iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
-	__iwl_set_bits_mask_restricted_reg(__LINE__, priv, reg, bits, mask)
-#else
-#define iwl_set_bits_mask_restricted_reg _iwl_set_bits_mask_restricted_reg
-#endif
-
-static inline void iwl_clear_bits_restricted_reg(struct iwl_priv
-						 *priv, u32 reg, u32 mask)
-{
-	u32 val = _iwl_read_restricted_reg(priv, reg);
-	_iwl_write_restricted_reg(priv, reg, (val & ~mask));
-}
-
-static inline u32 iwl_read_restricted_mem(struct iwl_priv *priv, u32 addr)
-{
-	iwl_write_restricted(priv, HBUS_TARG_MEM_RADDR, addr);
-	return iwl_read_restricted(priv, HBUS_TARG_MEM_RDAT);
-}
-
-static inline void iwl_write_restricted_mem(struct iwl_priv *priv, u32 addr,
-					    u32 val)
-{
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, val);
-}
-
-static inline void iwl_write_restricted_mems(struct iwl_priv *priv, u32 addr,
-					     u32 len, u32 *values)
-{
-	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
-	for (; 0 < len; len -= sizeof(u32), values++)
-		iwl_write_restricted(priv, HBUS_TARG_MEM_WDAT, *values);
-}
-
-static inline void iwl_write_restricted_regs(struct iwl_priv *priv, u32 reg,
-					     u32 len, u8 *values)
-{
-	u32 reg_offset = reg;
-	u32 aligment = reg & 0x3;
-
-	/* write any non-dword-aligned stuff at the beginning */
-	if (len < sizeof(u32)) {
-		if ((aligment + len) <= sizeof(u32)) {
-			u8 size;
-			u32 value = 0;
-			size = len - 1;
-			memcpy(&value, values, len);
-			reg_offset = (reg_offset & 0x0000FFFF);
-
-			_iwl_write_restricted(priv,
-					      HBUS_TARG_PRPH_WADDR,
-					      (reg_offset | (size << 24)));
-			_iwl_write_restricted(priv, HBUS_TARG_PRPH_WDAT,
-					      value);
-		}
-
-		return;
-	}
-
-	/* now write all the dword-aligned stuff */
-	for (; reg_offset < (reg + len);
-	     reg_offset += sizeof(u32), values += sizeof(u32))
-		_iwl_write_restricted_reg(priv, reg_offset, *((u32 *) values));
-}
-
-#endif
Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-priv.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-priv.h	2007-10-12 11:20:28.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,308 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2007 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * James P. Ketrenos <ipw2100-admin@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __iwl_priv_h__
-#define __iwl_priv_h__
-
-#include <linux/workqueue.h>
-
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
-
-enum {
-	MEASUREMENT_READY = (1 << 0),
-	MEASUREMENT_ACTIVE = (1 << 1),
-};
-
-#endif
-
-struct iwl_priv {
-
-	/* ieee device used by generic ieee processing code */
-	struct ieee80211_hw *hw;
-	struct ieee80211_channel *ieee_channels;
-	struct ieee80211_rate *ieee_rates;
-
-	/* temporary frame storage list */
-	struct list_head free_frames;
-	int frames_count;
-
-	u8 phymode;
-	int alloc_rxb_skb;
-
-	void (*rx_handlers[REPLY_MAX])(struct iwl_priv *priv,
-				       struct iwl_rx_mem_buffer *rxb);
-
-	const struct ieee80211_hw_mode *modes;
-
-#ifdef CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT
-	/* spectrum measurement report caching */
-	struct iwl_spectrum_notification measure_report;
-	u8 measurement_status;
-#endif
-	/* ucode beacon time */
-	u32 ucode_beacon_time;
-
-	/* we allocate array of iwl_channel_info for NIC's valid channels.
-	 *    Access via channel # using indirect index array */
-	struct iwl_channel_info *channel_info;	/* channel info array */
-	u8 channel_count;	/* # of channels */
-
-	/* each calibration channel group in the EEPROM has a derived
-	 * clip setting for each rate. */
-	const struct iwl_clip_group clip_groups[5];
-
-	/* thermal calibration */
-	s32 temperature;	/* degrees Kelvin */
-	s32 last_temperature;
-
-	/* Scan related variables */
-	unsigned long last_scan_jiffies;
-	unsigned long scan_start;
-	unsigned long scan_pass_start;
-	unsigned long scan_start_tsf;
-	int scan_bands;
-	int one_direct_scan;
-	u8 direct_ssid_len;
-	u8 direct_ssid[IW_ESSID_MAX_SIZE];
-	struct iwl_scan_cmd *scan;
-	u8 only_active_channel;
-
-	/* spinlock */
-	spinlock_t lock;	/* protect general shared data */
-	spinlock_t hcmd_lock;	/* protect hcmd */
-	struct mutex mutex;
-
-	/* basic pci-network driver stuff */
-	struct pci_dev *pci_dev;
-
-	/* pci hardware address support */
-	void __iomem *hw_base;
-
-	/* uCode images, save to reload in case of failure */
-	struct fw_image_desc ucode_code;	/* runtime inst */
-	struct fw_image_desc ucode_data;	/* runtime data original */
-	struct fw_image_desc ucode_data_backup;	/* runtime data save/restore */
-	struct fw_image_desc ucode_init;	/* initialization inst */
-	struct fw_image_desc ucode_init_data;	/* initialization data */
-	struct fw_image_desc ucode_boot;	/* bootstrap inst */
-
-
-	struct iwl_rxon_time_cmd rxon_timing;
-
-	/* We declare this const so it can only be
-	 * changed via explicit cast within the
-	 * routines that actually update the physical
-	 * hardware */
-	const struct iwl_rxon_cmd active_rxon;
-	struct iwl_rxon_cmd staging_rxon;
-
-	int error_recovering;
-	struct iwl_rxon_cmd recovery_rxon;
-
-	/* 1st responses from initialize and runtime uCode images.
-	 * 4965's initialize alive response contains some calibration data. */
-	struct iwl_init_alive_resp card_alive_init;
-	struct iwl_alive_resp card_alive;
-
-#ifdef LED
-	/* LED related variables */
-	struct iwl_activity_blink activity;
-	unsigned long led_packets;
-	int led_state;
-#endif
-
-	u16 active_rate;
-	u16 active_rate_basic;
-
-	u8 call_post_assoc_from_beacon;
-	u8 assoc_station_added;
-#if IWL == 4965
-	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
-	/* HT variables */
-	u8 is_dup;
-	u8 is_ht_enabled;
-	u8 channel_width;	/* 0=20MHZ, 1=40MHZ */
-	u8 current_channel_width;
-	u8 valid_antenna;	/* Bit mask of antennas actually connected */
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
-	struct iwl_sensitivity_data sensitivity_data;
-	struct iwl_chain_noise_data chain_noise_data;
-	u8 start_calib;
-	__le16 sensitivity_tbl[HD_TABLE_SIZE];
-#endif /*CONFIG_IWLWIFI_SENSITIVITY*/
-
-#ifdef CONFIG_IWLWIFI_HT
-	struct sta_ht_info current_assoc_ht;
-#endif
-	u8 active_rate_ht[2];
-	u8 last_phy_res[100];
-
-	/* Rate scaling data */
-	struct iwl_lq_mngr lq_mngr;
-#endif
-
-	/* Rate scaling data */
-	s8 data_retry_limit;
-	u8 retry_rate;
-
-	wait_queue_head_t wait_command_queue;
-
-	int activity_timer_active;
-
-	/* Rx and Tx DMA processing queues */
-	struct iwl_rx_queue rxq;
-	struct iwl_tx_queue txq[IWL_MAX_NUM_QUEUES];
-#if IWL == 4965
-	unsigned long txq_ctx_active_msk;
-	struct iwl_kw kw;	/* keep warm address */
-	u32 scd_base_addr;	/* scheduler sram base address */
-#endif
-
-	unsigned long status;
-	u32 config;
-
-	int last_rx_rssi;	/* From Rx packet statisitics */
-	int last_rx_noise;	/* From beacon statistics */
-
-	struct iwl_power_mgr power_data;
-
-	struct iwl_notif_statistics statistics;
-	unsigned long last_statistics_time;
-
-	/* context information */
-	u8 essid[IW_ESSID_MAX_SIZE];
-	u8 essid_len;
-	u16 rates_mask;
-
-	u32 power_mode;
-	u32 antenna;
-	u8 bssid[ETH_ALEN];
-	u16 rts_threshold;
-	u8 mac_addr[ETH_ALEN];
-
-	/*station table variables */
-	spinlock_t sta_lock;
-	int num_stations;
-	struct iwl_station_entry stations[IWL_STATION_COUNT];
-
-	/* Indication if ieee80211_ops->open has been called */
-	int is_open;
-
-	u8 mac80211_registered;
-	int is_abg;
-
-	u32 notif_missed_beacons;
-
-	/* Rx'd packet timing information */
-	u32 last_beacon_time;
-	u64 last_tsf;
-
-	/* Duplicate packet detection */
-	u16 last_seq_num;
-	u16 last_frag_num;
-	unsigned long last_packet_time;
-	struct list_head ibss_mac_hash[IWL_IBSS_MAC_HASH_SIZE];
-
-	/* eeprom */
-	struct iwl_eeprom eeprom;
-
-	int iw_mode;
-
-	struct sk_buff *ibss_beacon;
-
-	/* Last Rx'd beacon timestamp */
-	u32 timestamp0;
-	u32 timestamp1;
-	u16 beacon_int;
-	struct iwl_driver_hw_info hw_setting;
-	int interface_id;
-
-	/* Current association information needed to configure the
-	 * hardware */
-	u16 assoc_id;
-	u16 assoc_capability;
-	u8 ps_mode;
-
-#ifdef CONFIG_IWLWIFI_QOS
-	struct iwl_qos_info qos_data;
-#endif /*CONFIG_IWLWIFI_QOS */
-
-	struct workqueue_struct *workqueue;
-
-	struct work_struct up;
-	struct work_struct restart;
-	struct work_struct calibrated_work;
-	struct work_struct scan_completed;
-	struct work_struct rx_replenish;
-	struct work_struct rf_kill;
-	struct work_struct abort_scan;
-	struct work_struct update_link_led;
-	struct work_struct auth_work;
-	struct work_struct report_work;
-	struct work_struct request_scan;
-	struct work_struct beacon_update;
-
-	struct tasklet_struct irq_tasklet;
-
-	struct delayed_work init_alive_start;
-	struct delayed_work alive_start;
-	struct delayed_work activity_timer;
-	struct delayed_work thermal_periodic;
-	struct delayed_work gather_stats;
-	struct delayed_work scan_check;
-	struct delayed_work post_associate;
-
-#define IWL_DEFAULT_TX_POWER 0x0F
-	s8 user_txpower_limit;
-	s8 max_channel_txpower_limit;
-	u32 cck_power_index_compensation;
-
-#ifdef CONFIG_PM
-	u32 pm_state[16];
-#endif
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	/* debugging info */
-	u32 framecnt_to_us;
-	atomic_t restrict_refcnt;
-#endif
-
-#if IWL == 4965
-	struct work_struct txpower_work;
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
-	struct work_struct sensitivity_work;
-#endif
-	struct work_struct statistics_work;
-	struct timer_list statistics_periodic;
-
-#ifdef CONFIG_IWLWIFI_HT_AGG
-	struct work_struct agg_work;
-#endif
-
-#endif /* 4965 */
-};				/*iwl_priv */
-
-#endif /* __iwl_priv_h__ */
