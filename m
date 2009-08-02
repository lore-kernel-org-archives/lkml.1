Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbZHBBHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbZHBBHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 21:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZHBBHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 21:07:30 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4290 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZHBBHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 21:07:24 -0400
Subject: [PATCH v2 2/2] treewide: Use DIV_ROUND_UP
From: Joe Perches <joe@perches.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <1249171857.6114.5.camel@desktop>
References: <Pine.LNX.4.64.0908012148100.25693@ask.diku.dk>
	 <1249170191.22466.14.camel@Joe-Laptop.home>
	 <1249171857.6114.5.camel@desktop>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 18:07:19 -0700
Message-Id: <1249175239.22466.113.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-01 at 17:10 -0700, Daniel Walker wrote:
> On Sat, 2009-08-01 at 16:43 -0700, Joe Perches wrote:
> > On Sat, 2009-08-01 at 21:48 +0200, Julia Lawall wrote:
> > > The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> > > but is perhaps more readable.
> > Similarly, DIV_ROUND_UP does ((n + d - 1) / d)
> Seems like there are a few more like this .. Could you either use
> roundup() or merge the two macros .. Or explain why your not using it..

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/sh/kernel/early_printk.c        |    2 +-
 arch/um/include/asm/pgtable-2level.h |    2 +-
 arch/um/include/asm/pgtable-3level.h |    2 +-
 drivers/md/raid1.c                   |    2 +-
 drivers/md/raid10.c                  |    2 +-
 drivers/net/s2io.c                   |    2 +-
 drivers/scsi/advansys.c              |    2 +-
 drivers/scsi/cxgb3i/cxgb3i.h         |    2 +-
 drivers/serial/sh-sci.c              |    2 +-
 drivers/staging/winbond/mds.c        |    2 +-
 drivers/xen/grant-table.c            |    3 +--
 kernel/posix-cpu-timers.c            |    2 +-
 lib/radix-tree.c                     |    2 +-
 sound/pci/ctxfi/ctresource.c         |    2 +-
 14 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/sh/kernel/early_printk.c b/arch/sh/kernel/early_printk.c
index a952dcf..9fda893 100644
--- a/arch/sh/kernel/early_printk.c
+++ b/arch/sh/kernel/early_printk.c
@@ -174,7 +174,7 @@ static void scif_sercon_init(char *s)
 	/* Set baud rate */
 	sci_out(port, SCBRR, (CONFIG_SH_PCLK_FREQ + 16 * baud) /
 		(32 * baud) - 1);
-	udelay((1000000+(baud-1)) / baud); /* Wait one bit interval */
+	udelay(DIV_ROUND_UP(1000000, baud)); /* Wait one bit interval */
 
 	sci_out(port, SCSPTR, 0);
 	sci_out(port, SCxSR, 0x60);
diff --git a/arch/um/include/asm/pgtable-2level.h b/arch/um/include/asm/pgtable-2level.h
index f534b73..7df789e 100644
--- a/arch/um/include/asm/pgtable-2level.h
+++ b/arch/um/include/asm/pgtable-2level.h
@@ -21,7 +21,7 @@
  * we don't really have any PMD directory physically.
  */
 #define PTRS_PER_PTE	1024
-#define USER_PTRS_PER_PGD ((TASK_SIZE + (PGDIR_SIZE - 1)) / PGDIR_SIZE)
+#define USER_PTRS_PER_PGD DIV_ROUND_UP(TASK_SIZE, PGDIR_SIZE)
 #define PTRS_PER_PGD	1024
 #define FIRST_USER_ADDRESS	0
 
diff --git a/arch/um/include/asm/pgtable-3level.h b/arch/um/include/asm/pgtable-3level.h
index 084de4a..c03a94a 100644
--- a/arch/um/include/asm/pgtable-3level.h
+++ b/arch/um/include/asm/pgtable-3level.h
@@ -40,7 +40,7 @@
 #define PTRS_PER_PGD 1024
 #endif
 
-#define USER_PTRS_PER_PGD ((TASK_SIZE + (PGDIR_SIZE - 1)) / PGDIR_SIZE)
+#define USER_PTRS_PER_PGD DIV_ROUND_UP(TASK_SIZE, PGDIR_SIZE)
 #define FIRST_USER_ADDRESS	0
 
 #define pte_ERROR(e) \
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0569efb..94f6e6b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -78,7 +78,7 @@ static void r1bio_pool_free(void *r1_bio, void *data)
 #define RESYNC_BLOCK_SIZE (64*1024)
 //#define RESYNC_BLOCK_SIZE PAGE_SIZE
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
-#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
+#define RESYNC_PAGES DIV_ROUND_UP(RESYNC_BLOCK_SIZE, PAGE_SIZE)
 #define RESYNC_WINDOW (2048*1024)
 
 static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7298a5e..574ee02 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -81,7 +81,7 @@ static void r10bio_pool_free(void *r10_bio, void *data)
 
 /* Maximum size of each resync request */
 #define RESYNC_BLOCK_SIZE (64*1024)
-#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
+#define RESYNC_PAGES DIV_ROUND_UP(RESYNC_BLOCK_SIZE, PAGE_SIZE)
 /* amount of memory to reserve for resync requests */
 #define RESYNC_WINDOW (1024*1024)
 /* maximum number of concurrent requests, memory permitting */
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 458daa0..23d1cf0 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -539,7 +539,7 @@ static struct pci_driver s2io_driver = {
 };
 
 /* A simplifier macro used both by init and free shared_mem Fns(). */
-#define TXD_MEM_PAGE_CNT(len, per_each) ((len+per_each - 1) / per_each)
+#define TXD_MEM_PAGE_CNT(len, per_each) DIV_ROUND_UP(len, per_each)
 
 /* netqueue manipulation helper functions */
 static inline void s2io_stop_all_tx_queue(struct s2io_nic *sp)
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index b756041..342ac83 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2168,7 +2168,7 @@ do { \
 
 #define ADV_SG_LIST_MAX_BYTE_SIZE \
          (sizeof(ADV_SG_BLOCK) * \
-          ((ADV_MAX_SG_LIST + (NO_OF_SG_PER_BLOCK - 1))/NO_OF_SG_PER_BLOCK))
+          DIV_ROUND_UP(ADV_MAX_SG_LIST, NO_OF_SG_PER_BLOCK))
 
 /* struct asc_board flags */
 #define ASC_IS_WIDE_BOARD       0x04	/* AdvanSys Wide Board */
diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index e3133b5..7fd630c 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -127,7 +127,7 @@ struct cxgb3i_endpoint {
  * @count:	max. possible pdu payload
  * @sgoffset:	offset to the first sg entry for a given offset
  */
-#define MAX_PDU_FRAGS	((ULP2_MAX_PDU_PAYLOAD + 512 - 1) / 512)
+#define MAX_PDU_FRAGS	DIV_ROUND_UP(ULP2_MAX_PDU_PAYLOAD, 512)
 struct cxgb3i_task_data {
 	unsigned short nr_frags;
 	skb_frag_t frags[MAX_PDU_FRAGS];
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index 8e2feb5..ee1dac2 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -967,7 +967,7 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
 			sci_out(port, SCSMR, sci_in(port, SCSMR) & ~3);
 
 		sci_out(port, SCBRR, t);
-		udelay((1000000+(baud-1)) / baud); /* Wait one bit interval */
+		udelay(DIV_ROUND_UP(1000000, baud)); /* Wait one bit interval */
 	}
 
 	sci_init_pins(port, termios->c_cflag);
diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 59d6d67..b4042fa 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -119,7 +119,7 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  PDESCRIPTOR pDes,  u8
 				else
 					Duration += SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
 
-				Duration += ( ((112 + Rate-1) / Rate) + DEFAULT_SIFSTIME );
+				Duration += ( DIV_ROUND_UP(112, Rate) + DEFAULT_SIFSTIME );
 			}
 		}
 
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 7d8f531..8529e0e 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -491,8 +491,7 @@ static int gnttab_expand(unsigned int req_entries)
 	unsigned int cur, extra;
 
 	cur = nr_grant_frames;
-	extra = ((req_entries + (GREFS_PER_GRANT_FRAME-1)) /
-		 GREFS_PER_GRANT_FRAME);
+	extra = DIV_ROUND_UP(req_entries, GREFS_PER_GRANT_FRAME);
 	if (cur + extra > max_nr_grant_frames())
 		return -ENOSPC;
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bece7c0..099d07b 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -181,7 +181,7 @@ int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 	int error = check_clock(which_clock);
 	if (!error) {
 		tp->tv_sec = 0;
-		tp->tv_nsec = ((NSEC_PER_SEC + HZ - 1) / HZ);
+		tp->tv_nsec = DIV_ROUND_UP(NSEC_PER_SEC, HZ);
 		if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
 			/*
 			 * If sched_clock is using a cycle counter, we
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 23abbd9..d42ec49 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -44,7 +44,7 @@
 #define RADIX_TREE_MAP_MASK	(RADIX_TREE_MAP_SIZE-1)
 
 #define RADIX_TREE_TAG_LONGS	\
-	((RADIX_TREE_MAP_SIZE + BITS_PER_LONG - 1) / BITS_PER_LONG)
+	DIV_ROUND_UP(RADIX_TREE_MAP_SIZE, BITS_PER_LONG)
 
 struct radix_tree_node {
 	unsigned int	height;		/* Height from the bottom */
diff --git a/sound/pci/ctxfi/ctresource.c b/sound/pci/ctxfi/ctresource.c
index 889c495..e430fad 100644
--- a/sound/pci/ctxfi/ctresource.c
+++ b/sound/pci/ctxfi/ctresource.c
@@ -215,7 +215,7 @@ int rsc_mgr_init(struct rsc_mgr *mgr, enum RSCTYP type,
 
 	mgr->type = NUM_RSCTYP;
 
-	mgr->rscs = kzalloc(((amount + 8 - 1) / 8), GFP_KERNEL);
+	mgr->rscs = kzalloc(DIV_ROUND_UP(amount, 8), GFP_KERNEL);
 	if (NULL == mgr->rscs)
 		return -ENOMEM;
 



