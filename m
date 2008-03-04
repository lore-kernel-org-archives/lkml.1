Return-Path: <linux-kernel-owner+w=401wt.eu-S1765458AbYCDQdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765458AbYCDQdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764992AbYCDQal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:41 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48606 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765444AbYCDQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:38 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 01/11] memstick: introduce correct definitions in the header
Date: Wed,  5 Mar 2008 03:02:18 +1100
Message-Id: <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Thanks to some input from kind people at JMicron it is now possible
to have more correct definitions of protocol structures and bit field
semantics.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/memstick.c    |    4 +-
 drivers/memstick/core/mspro_block.c |   16 ++--
 drivers/memstick/host/tifm_ms.c     |   19 +++---
 include/linux/memstick.h            |  130 +++++++++++++++++++++++------------
 4 files changed, 105 insertions(+), 64 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index bba467f..5e0e960 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -271,7 +271,7 @@ void memstick_init_req_sg(struct memstick_request *mrq, unsigned char tpc,
 		mrq->data_dir = READ;
 
 	mrq->sg = *sg;
-	mrq->io_type = MEMSTICK_IO_SG;
+	mrq->long_data = 1;
 
 	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
 		mrq->need_card_int = 1;
@@ -306,7 +306,7 @@ void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
 	if (mrq->data_dir == WRITE)
 		memcpy(mrq->data, buf, mrq->data_len);
 
-	mrq->io_type = MEMSTICK_IO_VAL;
+	mrq->long_data = 0;
 
 	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
 		mrq->need_card_int = 1;
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 423ad8c..214211c 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -629,7 +629,7 @@ static void mspro_block_process_request(struct memstick_dev *card,
 			param.system = msb->system;
 			param.data_count = cpu_to_be16(page_count);
 			param.data_address = cpu_to_be32((uint32_t)t_sec);
-			param.cmd_param = 0;
+			param.tpc_param = 0;
 
 			msb->data_dir = rq_data_dir(req);
 			msb->transfer_cmd = msb->data_dir == READ
@@ -761,7 +761,7 @@ static int mspro_block_switch_to_parallel(struct memstick_dev *card)
 		.system = 0,
 		.data_count = 0,
 		.data_address = 0,
-		.cmd_param = 0
+		.tpc_param = 0
 	};
 
 	card->next_request = h_mspro_block_req_init;
@@ -773,8 +773,8 @@ static int mspro_block_switch_to_parallel(struct memstick_dev *card)
 	if (card->current_mrq.error)
 		return card->current_mrq.error;
 
-	msb->system = 0;
-	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PARALLEL);
+	msb->system = MEMSTICK_SYS_PAR4;
+	host->set_param(host, MEMSTICK_INTERFACE, MEMSTICK_PAR4);
 
 	card->next_request = h_mspro_block_req_init;
 	msb->mrq_handler = h_mspro_block_default;
@@ -802,7 +802,7 @@ static int mspro_block_read_attributes(struct memstick_dev *card)
 		.system = msb->system,
 		.data_count = cpu_to_be16(1),
 		.data_address = 0,
-		.cmd_param = 0
+		.tpc_param = 0
 	};
 	struct mspro_attribute *attr = NULL;
 	struct mspro_sys_attr *s_attr = NULL;
@@ -922,7 +922,7 @@ static int mspro_block_read_attributes(struct memstick_dev *card)
 		param.system = msb->system;
 		param.data_count = cpu_to_be16((rc / msb->page_size) + 1);
 		param.data_address = cpu_to_be32(addr / msb->page_size);
-		param.cmd_param = 0;
+		param.tpc_param = 0;
 
 		sg_init_one(&msb->req_sg[0], buffer,
 			    be16_to_cpu(param.data_count) * msb->page_size);
@@ -964,7 +964,7 @@ static int mspro_block_init_card(struct memstick_dev *card)
 	struct memstick_host *host = card->host;
 	int rc = 0;
 
-	msb->system = 0x80;
+	msb->system = MEMSTICK_SYS_SERIAL;
 	card->reg_addr.r_offset = offsetof(struct mspro_register, status);
 	card->reg_addr.r_length = sizeof(struct ms_status_register);
 	card->reg_addr.w_offset = offsetof(struct mspro_register, param);
@@ -973,7 +973,7 @@ static int mspro_block_init_card(struct memstick_dev *card)
 	if (memstick_set_rw_addr(card))
 		return -EIO;
 
-	if (host->caps & MEMSTICK_CAP_PARALLEL) {
+	if (host->caps & MEMSTICK_CAP_PAR4) {
 		if (mspro_block_switch_to_parallel(card))
 			printk(KERN_WARNING "%s: could not switch to "
 			       "parallel interface\n", card->dev.bus_id);
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index 4fb2421..5b5bd61 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -209,7 +209,7 @@ static int tifm_ms_issue_cmd(struct tifm_ms *host)
 
 	host->cmd_flags = 0;
 
-	if (host->req->io_type == MEMSTICK_IO_SG) {
+	if (host->req->long_data) {
 		if (!host->no_dma) {
 			if (1 != tifm_map_sg(sock, &host->req->sg, 1,
 					     host->req->data_dir == READ
@@ -248,7 +248,7 @@ static int tifm_ms_issue_cmd(struct tifm_ms *host)
 		cmd_mask = readl(sock->addr + SOCK_MS_SYSTEM);
 		cmd_mask |= TIFM_MS_SYS_DATA | TIFM_MS_SYS_NOT_RDY;
 		writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
-	} else if (host->req->io_type == MEMSTICK_IO_VAL) {
+	} else {
 		data = host->req->data;
 		data_len = host->req->data_len;
 
@@ -294,8 +294,7 @@ static int tifm_ms_issue_cmd(struct tifm_ms *host)
 		cmd_mask |= TIFM_MS_SYS_NOT_RDY;
 		dev_dbg(&sock->dev, "mask %x\n", cmd_mask);
 		writel(cmd_mask, sock->addr + SOCK_MS_SYSTEM);
-	} else
-		BUG();
+	}
 
 	mod_timer(&host->timer, jiffies + host->timeout_jiffies);
 	writel(TIFM_CTRL_LED | readl(sock->addr + SOCK_CONTROL),
@@ -319,13 +318,13 @@ static void tifm_ms_complete_cmd(struct tifm_ms *host)
 	int rc;
 
 	del_timer(&host->timer);
-	if (host->req->io_type == MEMSTICK_IO_SG) {
+	if (host->req->long_data) {
 		if (!host->no_dma)
 			tifm_unmap_sg(sock, &host->req->sg, 1,
 				      host->req->data_dir == READ
 				      ? PCI_DMA_FROMDEVICE
 				      : PCI_DMA_TODEVICE);
-	} else if (host->req->io_type == MEMSTICK_IO_VAL) {
+	} else {
 		writel(~TIFM_MS_SYS_DATA & readl(sock->addr + SOCK_MS_SYSTEM),
 		       sock->addr + SOCK_MS_SYSTEM);
 
@@ -365,7 +364,7 @@ static int tifm_ms_check_status(struct tifm_ms *host)
 	if (!host->req->error) {
 		if (!(host->cmd_flags & CMD_READY))
 			return 1;
-		if ((host->req->io_type == MEMSTICK_IO_SG)
+		if (host->req->long_data
 		    && !(host->cmd_flags & FIFO_READY))
 			return 1;
 		if (host->req->need_card_int
@@ -505,7 +504,7 @@ static void tifm_ms_set_param(struct memstick_host *msh,
 			writel((~TIFM_CTRL_FAST_CLK)
 			       & readl(sock->addr + SOCK_CONTROL),
 			       sock->addr + SOCK_CONTROL);
-		} else if (value == MEMSTICK_PARALLEL) {
+		} else if (value == MEMSTICK_PAR4) {
 			host->mode_mask = 0;
 			writel(TIFM_CTRL_FAST_CLK
 			       | readl(sock->addr + SOCK_CONTROL),
@@ -542,7 +541,7 @@ static int tifm_ms_initialize_host(struct tifm_ms *host)
 	writel(0x0200 | TIFM_MS_SYS_NOT_RDY, sock->addr + SOCK_MS_SYSTEM);
 	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
 	if (tifm_has_ms_pif(sock))
-		msh->caps |= MEMSTICK_CAP_PARALLEL;
+		msh->caps |= MEMSTICK_CAP_PAR4;
 
 	return 0;
 }
@@ -601,7 +600,7 @@ static void tifm_ms_remove(struct tifm_dev *sock)
 		writel(TIFM_FIFO_INT_SETALL,
 		       sock->addr + SOCK_DMA_FIFO_INT_ENABLE_CLEAR);
 		writel(TIFM_DMA_RESET, sock->addr + SOCK_DMA_CONTROL);
-		if ((host->req->io_type == MEMSTICK_IO_SG) && !host->no_dma)
+		if (host->req->long_data && !host->no_dma)
 			tifm_unmap_sg(sock, &host->req->sg, 1,
 				      host->req->data_dir == READ
 				      ? PCI_DMA_TODEVICE
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 334d059..c104e72 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -22,6 +22,8 @@ struct ms_status_register {
 	unsigned char reserved;
 	unsigned char interrupt;
 #define MEMSTICK_INT_CMDNAK             0x0001
+#define MEMSTICK_INT_IOREQ              0x0008
+#define MEMSTICK_INT_IOBREQ             0x0010
 #define MEMSTICK_INT_BREQ               0x0020
 #define MEMSTICK_INT_ERR                0x0040
 #define MEMSTICK_INT_CED                0x0080
@@ -47,13 +49,17 @@ struct ms_status_register {
 
 struct ms_id_register {
 	unsigned char type;
-	unsigned char reserved;
+	unsigned char if_mode;
 	unsigned char category;
 	unsigned char class;
 } __attribute__((packed));
 
 struct ms_param_register {
 	unsigned char system;
+#define MEMSTICK_SYS_ATEN 0xc0
+#define MEMSTICK_SYS_BAMD 0x80
+#define MEMSTICK_SYS_PAM  0x08
+
 	unsigned char block_address_msb;
 	unsigned short block_address;
 	unsigned char cp;
@@ -90,16 +96,48 @@ struct ms_register {
 
 struct mspro_param_register {
 	unsigned char  system;
+#define MEMSTICK_SYS_SERIAL 0x80
+#define MEMSTICK_SYS_PAR4   0x00
+#define MEMSTICK_SYS_PAR8   0x40
+
+	unsigned short data_count;
+	unsigned int   data_address;
+	unsigned char  tpc_param;
+} __attribute__((packed));
+
+struct mspro_io_info_register {
+	unsigned char version;
+	unsigned char io_category;
+	unsigned char current_req;
+	unsigned char card_opt_info;
+	unsigned char rdy_wait_time;
+} __attribute__((packed));
+
+struct mspro_io_func_register {
+	unsigned char func_enable;
+	unsigned char func_select;
+	unsigned char func_intmask;
+	unsigned char transfer_mode;
+} __attribute__((packed));
+
+struct mspro_io_cmd_register {
+	unsigned short tpc_param;
 	unsigned short data_count;
 	unsigned int   data_address;
-	unsigned char  cmd_param;
 } __attribute__((packed));
 
 struct mspro_register {
-	struct ms_status_register    status;
-	struct ms_id_register        id;
-	unsigned char                reserved[8];
-	struct mspro_param_register  param;
+	struct ms_status_register     status;
+	struct ms_id_register         id;
+	unsigned char                 reserved0[8];
+	struct mspro_param_register   param;
+	unsigned char                 reserved1[8];
+	struct mspro_io_info_register io_info;
+	struct mspro_io_func_register io_func;
+	unsigned char                 reserved2[7];
+	struct mspro_io_cmd_register  io_cmd;
+	unsigned char                 io_int;
+	unsigned char                 io_int_func;
 } __attribute__((packed));
 
 struct ms_register_addr {
@@ -110,49 +148,55 @@ struct ms_register_addr {
 } __attribute__((packed));
 
 enum {
+	MS_TPC_READ_MG_STATUS   = 0x01,
 	MS_TPC_READ_LONG_DATA   = 0x02,
 	MS_TPC_READ_SHORT_DATA  = 0x03,
+	MS_TPC_READ_MG_DATA     = 0x03,
 	MS_TPC_READ_REG         = 0x04,
-	MS_TPC_READ_IO_DATA     = 0x05, /* unverified */
+	MS_TPC_READ_QUAD_DATA   = 0x05,
+	MS_TPC_READ_IO_DATA     = 0x05,
 	MS_TPC_GET_INT          = 0x07,
 	MS_TPC_SET_RW_REG_ADRS  = 0x08,
 	MS_TPC_EX_SET_CMD       = 0x09,
-	MS_TPC_WRITE_IO_DATA    = 0x0a, /* unverified */
+	MS_TPC_WRITE_QUAD_DATA  = 0x0a,
+	MS_TPC_WRITE_IO_DATA    = 0x0a,
 	MS_TPC_WRITE_REG        = 0x0b,
 	MS_TPC_WRITE_SHORT_DATA = 0x0c,
+	MS_TPC_WRITE_MG_DATA    = 0x0c,
 	MS_TPC_WRITE_LONG_DATA  = 0x0d,
 	MS_TPC_SET_CMD          = 0x0e
 };
 
 enum {
-	MS_CMD_BLOCK_END     = 0x33,
-	MS_CMD_RESET         = 0x3c,
-	MS_CMD_BLOCK_WRITE   = 0x55,
-	MS_CMD_SLEEP         = 0x5a,
-	MS_CMD_BLOCK_ERASE   = 0x99,
-	MS_CMD_BLOCK_READ    = 0xaa,
-	MS_CMD_CLEAR_BUF     = 0xc3,
-	MS_CMD_FLASH_STOP    = 0xcc,
-	MSPRO_CMD_FORMAT     = 0x10,
-	MSPRO_CMD_SLEEP      = 0x11,
-	MSPRO_CMD_READ_DATA  = 0x20,
-	MSPRO_CMD_WRITE_DATA = 0x21,
-	MSPRO_CMD_READ_ATRB  = 0x24,
-	MSPRO_CMD_STOP       = 0x25,
-	MSPRO_CMD_ERASE      = 0x26,
-	MSPRO_CMD_SET_IBA    = 0x46,
-	MSPRO_CMD_SET_IBD    = 0x47
-/*
-	MSPRO_CMD_RESET
-	MSPRO_CMD_WAKEUP
-	MSPRO_CMD_IN_IO_DATA
-	MSPRO_CMD_OUT_IO_DATA
-	MSPRO_CMD_READ_IO_ATRB
-	MSPRO_CMD_IN_IO_FIFO
-	MSPRO_CMD_OUT_IO_FIFO
-	MSPRO_CMD_IN_IOM
-	MSPRO_CMD_OUT_IOM
-*/
+	MS_CMD_BLOCK_END       = 0x33,
+	MS_CMD_RESET           = 0x3c,
+	MS_CMD_BLOCK_WRITE     = 0x55,
+	MS_CMD_SLEEP           = 0x5a,
+	MS_CMD_BLOCK_ERASE     = 0x99,
+	MS_CMD_BLOCK_READ      = 0xaa,
+	MS_CMD_CLEAR_BUF       = 0xc3,
+	MS_CMD_FLASH_STOP      = 0xcc,
+	MS_CMD_LOAD_ID         = 0x60,
+	MS_CMD_CMP_ICV         = 0x7f,
+	MSPRO_CMD_FORMAT       = 0x10,
+	MSPRO_CMD_SLEEP        = 0x11,
+	MSPRO_CMD_WAKEUP       = 0x12,
+	MSPRO_CMD_READ_DATA    = 0x20,
+	MSPRO_CMD_WRITE_DATA   = 0x21,
+	MSPRO_CMD_READ_ATRB    = 0x24,
+	MSPRO_CMD_STOP         = 0x25,
+	MSPRO_CMD_ERASE        = 0x26,
+	MSPRO_CMD_READ_QUAD    = 0x27,
+	MSPRO_CMD_WRITE_QUAD   = 0x28,
+	MSPRO_CMD_SET_IBD      = 0x46,
+	MSPRO_CMD_GET_IBD      = 0x47,
+	MSPRO_CMD_IN_IO_DATA   = 0xb0,
+	MSPRO_CMD_OUT_IO_DATA  = 0xb1,
+	MSPRO_CMD_READ_IO_ATRB = 0xb2,
+	MSPRO_CMD_IN_IO_FIFO   = 0xb3,
+	MSPRO_CMD_OUT_IO_FIFO  = 0xb4,
+	MSPRO_CMD_IN_IOM       = 0xb5,
+	MSPRO_CMD_OUT_IOM      = 0xb6,
 };
 
 /*** Driver structures and functions ***/
@@ -165,7 +209,8 @@ enum memstick_param { MEMSTICK_POWER = 1, MEMSTICK_INTERFACE };
 #define MEMSTICK_POWER_ON  1
 
 #define MEMSTICK_SERIAL   0
-#define MEMSTICK_PARALLEL 1
+#define MEMSTICK_PAR4     1
+#define MEMSTICK_PAR8     2
 
 struct memstick_host;
 struct memstick_driver;
@@ -195,11 +240,7 @@ struct memstick_request {
 	unsigned char data_dir:1,
 		      need_card_int:1,
 		      get_int_reg:1,
-		      io_type:2;
-#define               MEMSTICK_IO_NONE 0
-#define               MEMSTICK_IO_VAL  1
-#define               MEMSTICK_IO_SG   2
-
+		      long_data:1;
 	unsigned char int_reg;
 	int           error;
 	union {
@@ -231,8 +272,9 @@ struct memstick_host {
 	struct mutex        lock;
 	unsigned int        id;
 	unsigned int        caps;
-#define MEMSTICK_CAP_PARALLEL      1
-#define MEMSTICK_CAP_AUTO_GET_INT  2
+#define MEMSTICK_CAP_AUTO_GET_INT  1
+#define MEMSTICK_CAP_PAR4          2
+#define MEMSTICK_CAP_PAR8          4
 
 	struct work_struct  media_checker;
 	struct class_device cdev;
-- 
1.5.3.6

