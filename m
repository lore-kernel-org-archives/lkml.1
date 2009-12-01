Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZLAENk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZLAENk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZLAENj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:13:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1200 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZLAENf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:13:35 -0500
Subject: [PATCH] drivers/block/floppy.c: stylistic cleanups
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091130092837.4998f961@nehalam>
References: <1259001504.16503.79.camel@Joe-Laptop.home>
	 <20091123.104130.117837098.davem@davemloft.net>
	 <1259528449.29779.194.camel@Joe-Laptop.home>
	 <20091129.165557.84377714.davem@davemloft.net>
	 <20091130092837.4998f961@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 20:13:40 -0800
Message-ID: <1259640820.13592.37.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 09:28 -0800, Stephen Hemminger wrote:
> Rather than playing with the dangling operator format which seems to be a coding
> style that only David cares about. Why not go through and fix the really ugly old
> drivers that need it. For a good horror experience, go look at the floppy driver.

Just for you Stephen, here's a cleaned up version.
Now to see if it gets applied, which I rather doubt.

Changes:

Removed macro definitions and uses of
	IN, OUT, LAST_OUT, CLEARSTRUCT, and CHECK_RESET
Used C99 initializers
Removed assigns from if statements
Converted printks without KERN_ levels to pr_info and pr_cont
Removed unnecessary braces
Used print_hex_dump
Moved leading logical tests to end of previous line
Surrounded still ugly CALL and ECALL macro with do {} while (0)

Checkpatch complaints before:
total: 393 errors, 132 warnings, 4647 lines checked

after:
total: 1 errors, 11 warnings, 5352 lines checked

Compile tested only, x86 allyesconfig

Signed-off-by: Joe Perches <joe@perches.com>

 drivers/block/floppy.c | 1853 +++++++++++++++++++++++++++++++++---------------
 1 files changed, 1279 insertions(+), 574 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5c01f74..4521582 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -150,7 +150,7 @@
 #define REALLY_SLOW_IO
 
 #define DEBUGT 2
-#define DCL_DEBUG	/* debug disk change line */
+#define DCL_DEBUG		/* debug disk change line */
 
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
@@ -180,6 +180,8 @@ static int print_unex = 1;
 #include <linux/mod_devicetable.h>
 #include <linux/buffer_head.h>	/* for invalidate_buffers() */
 #include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 /*
  * PS/2 floppies have much slower step rates than regular floppies.
@@ -191,8 +193,6 @@ static int slow_floppy;
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/system.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
 
 static int FLOPPY_IRQ = 6;
 static int FLOPPY_DMA = 2;
@@ -250,7 +250,7 @@ static int irqdma_allocated;
 
 static struct request *current_req;
 static struct request_queue *floppy_queue;
-static void do_fd_request(struct request_queue * q);
+static void do_fd_request(struct request_queue *q);
 
 #ifndef fd_get_dma_residue
 #define fd_get_dma_residue() get_dma_residue(FLOPPY_DMA)
@@ -263,7 +263,7 @@ static void do_fd_request(struct request_queue * q);
 #endif
 
 #ifndef fd_dma_mem_alloc
-#define fd_dma_mem_alloc(size) __get_dma_pages(GFP_KERNEL,get_order(size))
+#define fd_dma_mem_alloc(size) __get_dma_pages(GFP_KERNEL, get_order(size))
 #endif
 
 static inline void fallback_on_nodma_alloc(char **addr, size_t l)
@@ -273,7 +273,7 @@ static inline void fallback_on_nodma_alloc(char **addr, size_t l)
 		return;		/* we have the memory */
 	if (can_use_virtual_dma != 2)
 		return;		/* no fallback allowed */
-	printk("DMA memory shortage. Temporarily falling back on virtual DMA\n");
+	pr_info("DMA memory shortage. Temporarily falling back on virtual DMA\n");
 	*addr = (char *)nodma_mem_alloc(l);
 #else
 	return;
@@ -285,57 +285,57 @@ static inline void fallback_on_nodma_alloc(char **addr, size_t l)
 static unsigned long fake_change;
 static int initialising = 1;
 
-#define ITYPE(x) (((x)>>2) & 0x1f)
+#define ITYPE(x) (((x) >> 2) & 0x1f)
 #define TOMINOR(x) ((x & 3) | ((x & 4) << 5))
 #define UNIT(x) ((x) & 0x03)	/* drive on fdc */
 #define FDC(x) (((x) & 0x04) >> 2)	/* fdc of drive */
 	/* reverse mapping from unit and fdc to drive */
 #define REVDRIVE(fdc, unit) ((unit) + ((fdc) << 2))
-#define DP (&drive_params[current_drive])
-#define DRS (&drive_state[current_drive])
-#define DRWE (&write_errors[current_drive])
-#define FDCS (&fdc_state[fdc])
-#define CLEARF(x) clear_bit(x##_BIT, &DRS->flags)
-#define SETF(x) set_bit(x##_BIT, &DRS->flags)
-#define TESTF(x) test_bit(x##_BIT, &DRS->flags)
-
-#define UDP (&drive_params[drive])
-#define UDRS (&drive_state[drive])
-#define UDRWE (&write_errors[drive])
-#define UFDCS (&fdc_state[FDC(drive)])
-#define UCLEARF(x) clear_bit(x##_BIT, &UDRS->flags)
-#define USETF(x) set_bit(x##_BIT, &UDRS->flags)
-#define UTESTF(x) test_bit(x##_BIT, &UDRS->flags)
-
-#define DPRINT(format, args...) printk(DEVICE_NAME "%d: " format, current_drive , ## args)
-
-#define PH_HEAD(floppy,head) (((((floppy)->stretch & 2) >>1) ^ head) << 2)
-#define STRETCH(floppy) ((floppy)->stretch & FD_STRETCH)
 
-#define CLEARSTRUCT(x) memset((x), 0, sizeof(*(x)))
+#define DP	(&drive_params[current_drive])
+#define DRS	(&drive_state[current_drive])
+#define DRWE	(&write_errors[current_drive])
+#define FDCS	(&fdc_state[fdc])
+#define CLEARF(x)	clear_bit(x##_BIT, &DRS->flags)
+#define SETF(x)		set_bit(x##_BIT, &DRS->flags)
+#define TESTF(x)	test_bit(x##_BIT, &DRS->flags)
+
+#define UDP	(&drive_params[drive])
+#define UDRS	(&drive_state[drive])
+#define UDRWE	(&write_errors[drive])
+#define UFDCS	(&fdc_state[FDC(drive)])
+#define UCLEARF(x)	clear_bit(x##_BIT, &UDRS->flags)
+#define USETF(x)	set_bit(x##_BIT, &UDRS->flags)
+#define UTESTF(x)	test_bit(x##_BIT, &UDRS->flags)
+
+#define DPRINT(format, args...) \
+	pr_info(DEVICE_NAME "%d: " format, current_drive, ##args)
+
+#define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
+#define STRETCH(floppy) ((floppy)->stretch & FD_STRETCH)
 
 /* read/write */
-#define COMMAND raw_cmd->cmd[0]
-#define DR_SELECT raw_cmd->cmd[1]
-#define TRACK raw_cmd->cmd[2]
-#define HEAD raw_cmd->cmd[3]
-#define SECTOR raw_cmd->cmd[4]
-#define SIZECODE raw_cmd->cmd[5]
-#define SECT_PER_TRACK raw_cmd->cmd[6]
-#define GAP raw_cmd->cmd[7]
-#define SIZECODE2 raw_cmd->cmd[8]
+#define COMMAND		(raw_cmd->cmd[0])
+#define DR_SELECT	(raw_cmd->cmd[1])
+#define TRACK		(raw_cmd->cmd[2])
+#define HEAD		(raw_cmd->cmd[3])
+#define SECTOR		(raw_cmd->cmd[4])
+#define SIZECODE	(raw_cmd->cmd[5])
+#define SECT_PER_TRACK	(raw_cmd->cmd[6])
+#define GAP		(raw_cmd->cmd[7])
+#define SIZECODE2	(raw_cmd->cmd[8])
 #define NR_RW 9
 
 /* format */
-#define F_SIZECODE raw_cmd->cmd[2]
-#define F_SECT_PER_TRACK raw_cmd->cmd[3]
-#define F_GAP raw_cmd->cmd[4]
-#define F_FILL raw_cmd->cmd[5]
+#define F_SIZECODE	(raw_cmd->cmd[2])
+#define F_SECT_PER_TRACK (raw_cmd->cmd[3])
+#define F_GAP		(raw_cmd->cmd[4])
+#define F_FILL		(raw_cmd->cmd[5])
 #define NR_F 6
 
 /*
- * Maximum disk size (in kilobytes). This default is used whenever the
- * current disk size is unknown.
+ * Maximum disk size (in kilobytes).
+ * This default is used whenever the current disk size is unknown.
  * [Now it is rather a minimum]
  */
 #define MAX_DISK_SIZE 4		/* 3984 */
@@ -345,63 +345,244 @@ static int initialising = 1;
  */
 #define MAX_REPLIES 16
 static unsigned char reply_buffer[MAX_REPLIES];
-static int inr;			/* size of reply buffer, when called from interrupt */
-#define ST0 (reply_buffer[0])
-#define ST1 (reply_buffer[1])
-#define ST2 (reply_buffer[2])
-#define ST3 (reply_buffer[0])	/* result of GETSTATUS */
-#define R_TRACK (reply_buffer[3])
-#define R_HEAD (reply_buffer[4])
-#define R_SECTOR (reply_buffer[5])
-#define R_SIZECODE (reply_buffer[6])
-#define SEL_DLY (2*HZ/100)
+static int inr;		/* size of reply buffer, when called from interrupt */
+
+#define ST0		(reply_buffer[0])
+#define ST1		(reply_buffer[1])
+#define ST2		(reply_buffer[2])
+#define ST3		(reply_buffer[0])	/* result of GETSTATUS */
+#define R_TRACK		(reply_buffer[3])
+#define R_HEAD		(reply_buffer[4])
+#define R_SECTOR	(reply_buffer[5])
+#define R_SIZECODE	(reply_buffer[6])
+#define SEL_DLY		(2 * HZ / 100)
 
 /*
  * this struct defines the different floppy drive types.
  */
-static struct {
+struct drive_params {
 	struct floppy_drive_params params;
 	const char *name;	/* name printed while booting */
-} default_drive_params[] = {
-/* NOTE: the time values in jiffies should be in msec!
- CMOS drive type
-  |     Maximum data rate supported by drive type
-  |     |   Head load time, msec
-  |     |   |   Head unload time, msec (not used)
-  |     |   |   |     Step rate interval, usec
-  |     |   |   |     |       Time needed for spinup time (jiffies)
-  |     |   |   |     |       |      Timeout for spinning down (jiffies)
-  |     |   |   |     |       |      |   Spindown offset (where disk stops)
-  |     |   |   |     |       |      |   |     Select delay
-  |     |   |   |     |       |      |   |     |     RPS
-  |     |   |   |     |       |      |   |     |     |    Max number of tracks
-  |     |   |   |     |       |      |   |     |     |    |     Interrupt timeout
-  |     |   |   |     |       |      |   |     |     |    |     |   Max nonintlv. sectors
-  |     |   |   |     |       |      |   |     |     |    |     |   | -Max Errors- flags */
-{{0,  500, 16, 16, 8000,    1*HZ, 3*HZ,  0, SEL_DLY, 5,  80, 3*HZ, 20, {3,1,2,0,2}, 0,
-      0, { 7, 4, 8, 2, 1, 5, 3,10}, 3*HZ/2, 0 }, "unknown" },
-
-{{1,  300, 16, 16, 8000,    1*HZ, 3*HZ,  0, SEL_DLY, 5,  40, 3*HZ, 17, {3,1,2,0,2}, 0,
-      0, { 1, 0, 0, 0, 0, 0, 0, 0}, 3*HZ/2, 1 }, "360K PC" }, /*5 1/4 360 KB PC*/
-
-{{2,  500, 16, 16, 6000, 4*HZ/10, 3*HZ, 14, SEL_DLY, 6,  83, 3*HZ, 17, {3,1,2,0,2}, 0,
-      0, { 2, 5, 6,23,10,20,12, 0}, 3*HZ/2, 2 }, "1.2M" }, /*5 1/4 HD AT*/
-
-{{3,  250, 16, 16, 3000,    1*HZ, 3*HZ,  0, SEL_DLY, 5,  83, 3*HZ, 20, {3,1,2,0,2}, 0,
-      0, { 4,22,21,30, 3, 0, 0, 0}, 3*HZ/2, 4 }, "720k" }, /*3 1/2 DD*/
-
-{{4,  500, 16, 16, 4000, 4*HZ/10, 3*HZ, 10, SEL_DLY, 5,  83, 3*HZ, 20, {3,1,2,0,2}, 0,
-      0, { 7, 4,25,22,31,21,29,11}, 3*HZ/2, 7 }, "1.44M" }, /*3 1/2 HD*/
-
-{{5, 1000, 15,  8, 3000, 4*HZ/10, 3*HZ, 10, SEL_DLY, 5,  83, 3*HZ, 40, {3,1,2,0,2}, 0,
-      0, { 7, 8, 4,25,28,22,31,21}, 3*HZ/2, 8 }, "2.88M AMI BIOS" }, /*3 1/2 ED*/
-
-{{6, 1000, 15,  8, 3000, 4*HZ/10, 3*HZ, 10, SEL_DLY, 5,  83, 3*HZ, 40, {3,1,2,0,2}, 0,
-      0, { 7, 8, 4,25,28,22,31,21}, 3*HZ/2, 8 }, "2.88M" } /*3 1/2 ED*/
-/*    |  --autodetected formats---    |      |      |
- *    read_track                      |      |    Name printed when booting
- *				      |     Native format
- *	            Frequency of disk change checks */
+};
+
+static struct drive_params default_drive_params[] = {
+/* NOTE: the time values in jiffies should be in msec! */
+	{
+		.params = {
+			.cmos = 0,
+			.max_dtr = 500,
+			.hlt = 16,
+			.hut = 16,
+			.srt = 8000,
+			.spinup = 1 * HZ,
+			.spindown = 3 * HZ,
+			.spindown_offset = 0,
+			.select_delay = SEL_DLY,
+			.rps = 5,
+			.tracks = 80,
+			.timeout = 3 * HZ,
+			.interleave_sect = 20,
+			.max_errors = {
+				.abort = 3,
+				.read_track = 1,
+				.reset = 2,
+				.recal = 0,
+				.reporting = 2
+			},
+			.flags = 0,
+			.read_track = 0,
+			.autodetect = {7, 4, 8, 2, 1, 5, 3, 10},
+			.checkfreq = 3 * HZ / 2,
+			.native_format = 0
+		},
+		.name = "unknown"
+	},
+
+	{				/*5 1/4 360 KB PC */
+		.params = {
+			.cmos = 1,
+			.max_dtr = 300,
+			.hlt = 16,
+			.hut = 16,
+			.srt = 8000,
+			.spinup = 1 * HZ,
+			.spindown = 3 * HZ,
+			.spindown_offset = 0,
+			.select_delay = SEL_DLY,
+			.rps = 5,
+			.tracks = 40,
+			.timeout = 3 * HZ,
+			.interleave_sect = 17,
+			.max_errors = {
+				.abort = 3,
+				.read_track = 1,
+				.reset = 2,
+				.recal = 0,
+				.reporting = 2
+			},
+			.flags = 0,
+			.read_track = 0,
+			.autodetect = {1, 0, 0, 0, 0, 0, 0, 0},
+			.checkfreq = 3 * HZ / 2,
+			.native_format = 1
+		},
+		.name = "360K PC"
+	},
+
+	{				/*5 1/4 HD AT */
+		.params = {
+			.cmos = 2,
+			.max_dtr = 500,
+			.hlt = 16,
+			.hut = 16,
+			.srt = 6000,
+			.spinup = 4 * HZ / 10,
+			.spindown = 3 * HZ,
+			.spindown_offset = 14,
+			.select_delay = SEL_DLY,
+			.rps = 6,
+			.tracks = 83,
+			.timeout = 3 * HZ,
+			.interleave_sect = 17,
+			.max_errors = {
+				.abort = 3,
+				.read_track = 1,
+				.reset = 2,
+				.recal = 0,
+				.reporting = 2
+			},
+			.flags = 0,
+			.read_track = 0,
+			.autodetect = {2, 5, 6, 23, 10, 20, 12, 0},
+			.checkfreq = 3 * HZ / 2,
+			.native_format = 2
+		},
+		.name = "1.2M"
+	},
+
+	{				/*3 1/2 DD */
+		.params = {
+			.cmos = 3,
+			.max_dtr = 250,
+			.hlt = 16,
+			.hut = 16,
+			.srt = 3000,
+			.spinup = 1 * HZ,
+			.spindown = 3 * HZ,
+			.spindown_offset = 0,
+			.select_delay = SEL_DLY,
+			.rps = 5,
+			.tracks = 83,
+			.timeout = 3 * HZ,
+			.interleave_sect = 20,
+			.max_errors = {
+				.abort = 3,
+				.read_track = 1,
+				.reset = 2,
+				.recal = 0,
+				.reporting = 2
+			},
+			.flags = 0,
+			.read_track = 0,
+			.autodetect = {4, 22, 21, 30, 3, 0, 0, 0},
+			.checkfreq = 3 * HZ / 2,
+			.native_format = 4
+		},
+		.name = "720k"
+	},
+
+	{				/*3 1/2 HD */
+		.params = {
+			.cmos = 4,
+			.max_dtr = 500,
+			.hlt = 16,
+			.hut = 16,
+			.srt = 4000,
+			.spinup = 4 * HZ / 10,
+			.spindown = 3 * HZ,
+			.spindown_offset = 10,
+			.select_delay = SEL_DLY,
+			.rps = 5,
+			.tracks = 83,
+			.timeout = 3 * HZ,
+			.interleave_sect = 20,
+			.max_errors = {
+				.abort = 3,
+				.read_track = 1,
+				.reset = 2,
+				.recal = 0,
+				.reporting = 2
+			},
+			.flags = 0,
+			.read_track = 0,
+			.autodetect = {7, 4, 25, 22, 31, 21, 29, 11},
+			.checkfreq = 3 * HZ / 2,
+			.native_format = 7
+		},
+		.name = "1.44M"
+	},
+
+	{				/*3 1/2 ED */
+		.params = {
+			.cmos = 5,
+			.max_dtr = 1000,
+			.hlt = 15,
+			.hut = 8,
+			.srt = 3000,
+			.spinup = 4 * HZ / 10,
+			.spindown = 3 * HZ,
+			.spindown_offset = 10,
+			.select_delay = SEL_DLY,
+			.rps = 5,
+			.tracks = 83,
+			.timeout = 3 * HZ,
+			.interleave_sect = 40,
+			.max_errors = {
+				.abort = 3,
+				.read_track = 1,
+				.reset = 2,
+				.recal = 0,
+				.reporting = 2
+			},
+			.flags = 0,
+			.read_track = 0,
+			.autodetect = {7, 8, 4, 25, 28, 22, 31, 21},
+			.checkfreq = 3 * HZ / 2,
+			.native_format = 8
+		},
+		.name = "2.88M AMI BIOS"
+	},
+
+	{				/*3 1/2 ED */
+		.params = {
+			.cmos = 6,
+			.max_dtr = 1000,
+			.hlt = 15,
+			.hut = 8,
+			.srt = 3000,
+			.spinup = 4 * HZ / 10,
+			.spindown = 3 * HZ,
+			.spindown_offset = 10,
+			.select_delay = SEL_DLY,
+			.rps = 5,
+			.tracks = 83,
+			.timeout = 3 * HZ,
+			.interleave_sect = 40,
+			.max_errors = {
+				.abort = 3,
+				.read_track = 1,
+				.reset = 2,
+				.recal = 0,
+				.reporting = 2
+			},
+			.flags = 0,
+			.read_track = 0,
+			.autodetect = {7, 8, 4, 25, 28, 22, 31, 21},
+			.checkfreq = 3 * HZ / 2,
+			.native_format = 8
+		},
+		.name = "2.88M"
+	}
 };
 
 static struct floppy_drive_params drive_params[N_DRIVE];
@@ -434,52 +615,391 @@ static struct floppy_raw_cmd *raw_cmd, default_raw_cmd;
  *
  * Other parameters should be self-explanatory (see also setfdprm(8)).
  */
-/*
-	    Size
-	     |  Sectors per track
-	     |  | Head
-	     |  | |  Tracks
-	     |  | |  | Stretch
-	     |  | |  | |  Gap 1 size
-	     |  | |  | |    |  Data rate, | 0x40 for perp
-	     |  | |  | |    |    |  Spec1 (stepping rate, head unload
-	     |  | |  | |    |    |    |    /fmt gap (gap2) */
-static struct floppy_struct floppy_type[32] = {
-	{    0, 0,0, 0,0,0x00,0x00,0x00,0x00,NULL    },	/*  0 no testing    */
-	{  720, 9,2,40,0,0x2A,0x02,0xDF,0x50,"d360"  }, /*  1 360KB PC      */
-	{ 2400,15,2,80,0,0x1B,0x00,0xDF,0x54,"h1200" },	/*  2 1.2MB AT      */
-	{  720, 9,1,80,0,0x2A,0x02,0xDF,0x50,"D360"  },	/*  3 360KB SS 3.5" */
-	{ 1440, 9,2,80,0,0x2A,0x02,0xDF,0x50,"D720"  },	/*  4 720KB 3.5"    */
-	{  720, 9,2,40,1,0x23,0x01,0xDF,0x50,"h360"  },	/*  5 360KB AT      */
-	{ 1440, 9,2,80,0,0x23,0x01,0xDF,0x50,"h720"  },	/*  6 720KB AT      */
-	{ 2880,18,2,80,0,0x1B,0x00,0xCF,0x6C,"H1440" },	/*  7 1.44MB 3.5"   */
-	{ 5760,36,2,80,0,0x1B,0x43,0xAF,0x54,"E2880" },	/*  8 2.88MB 3.5"   */
-	{ 6240,39,2,80,0,0x1B,0x43,0xAF,0x28,"E3120" },	/*  9 3.12MB 3.5"   */
-
-	{ 2880,18,2,80,0,0x25,0x00,0xDF,0x02,"h1440" }, /* 10 1.44MB 5.25"  */
-	{ 3360,21,2,80,0,0x1C,0x00,0xCF,0x0C,"H1680" }, /* 11 1.68MB 3.5"   */
-	{  820,10,2,41,1,0x25,0x01,0xDF,0x2E,"h410"  },	/* 12 410KB 5.25"   */
-	{ 1640,10,2,82,0,0x25,0x02,0xDF,0x2E,"H820"  },	/* 13 820KB 3.5"    */
-	{ 2952,18,2,82,0,0x25,0x00,0xDF,0x02,"h1476" },	/* 14 1.48MB 5.25"  */
-	{ 3444,21,2,82,0,0x25,0x00,0xDF,0x0C,"H1722" },	/* 15 1.72MB 3.5"   */
-	{  840,10,2,42,1,0x25,0x01,0xDF,0x2E,"h420"  },	/* 16 420KB 5.25"   */
-	{ 1660,10,2,83,0,0x25,0x02,0xDF,0x2E,"H830"  },	/* 17 830KB 3.5"    */
-	{ 2988,18,2,83,0,0x25,0x00,0xDF,0x02,"h1494" },	/* 18 1.49MB 5.25"  */
-	{ 3486,21,2,83,0,0x25,0x00,0xDF,0x0C,"H1743" }, /* 19 1.74 MB 3.5"  */
-
-	{ 1760,11,2,80,0,0x1C,0x09,0xCF,0x00,"h880"  }, /* 20 880KB 5.25"   */
-	{ 2080,13,2,80,0,0x1C,0x01,0xCF,0x00,"D1040" }, /* 21 1.04MB 3.5"   */
-	{ 2240,14,2,80,0,0x1C,0x19,0xCF,0x00,"D1120" }, /* 22 1.12MB 3.5"   */
-	{ 3200,20,2,80,0,0x1C,0x20,0xCF,0x2C,"h1600" }, /* 23 1.6MB 5.25"   */
-	{ 3520,22,2,80,0,0x1C,0x08,0xCF,0x2e,"H1760" }, /* 24 1.76MB 3.5"   */
-	{ 3840,24,2,80,0,0x1C,0x20,0xCF,0x00,"H1920" }, /* 25 1.92MB 3.5"   */
-	{ 6400,40,2,80,0,0x25,0x5B,0xCF,0x00,"E3200" }, /* 26 3.20MB 3.5"   */
-	{ 7040,44,2,80,0,0x25,0x5B,0xCF,0x00,"E3520" }, /* 27 3.52MB 3.5"   */
-	{ 7680,48,2,80,0,0x25,0x63,0xCF,0x00,"E3840" }, /* 28 3.84MB 3.5"   */
-	{ 3680,23,2,80,0,0x1C,0x10,0xCF,0x00,"H1840" }, /* 29 1.84MB 3.5"   */
-
-	{ 1600,10,2,80,0,0x25,0x02,0xDF,0x2E,"D800"  },	/* 30 800KB 3.5"    */
-	{ 3200,20,2,80,0,0x1C,0x00,0xCF,0x2C,"H1600" }, /* 31 1.6MB 3.5"    */
+ static struct floppy_struct floppy_type[32] = {
+	 {
+		 .size = 0,
+		 .sect = 0,
+		 .head = 0,
+		 .track = 0,
+		 .stretch = 0,
+		 .gap = 0x00,
+		 .rate = 0x00,
+		 .spec1 = 0x00,
+		 .fmt_gap = 0x00,
+		 .name = NULL
+	 },	/*  0 no testing    */
+	 {
+		 .size = 720,
+		 .sect = 9,
+		 .head = 2,
+		 .track = 40,
+		 .stretch = 0,
+		 .gap = 0x2A,
+		 .rate = 0x02,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x50,
+		 .name = "d360"
+	 },	/*  1 360KB PC      */
+	 {
+		 .size = 2400,
+		 .sect = 15,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x1B,
+		 .rate = 0x00,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x54,
+		 .name = "h1200"
+	 },	/*  2 1.2MB AT      */
+	 {
+		 .size = 720,
+		 .sect = 9,
+		 .head = 1,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x2A,
+		 .rate = 0x02,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x50,
+		 .name = "D360"
+	 },	/*  3 360KB SS 3.5" */
+	 {
+		 .size = 1440,
+		 .sect = 9,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x2A,
+		 .rate = 0x02,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x50,
+		 .name = "D720"
+	 },	/*  4 720KB 3.5"    */
+	 {
+		 .size = 720,
+		 .sect = 9,
+		 .head = 2,
+		 .track = 40,
+		 .stretch = 1,
+		 .gap = 0x23,
+		 .rate = 0x01,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x50,
+		 .name = "h360"
+	 },	/*  5 360KB AT      */
+	 {
+		 .size = 1440,
+		 .sect = 9,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x23,
+		 .rate = 0x01,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x50,
+		 .name = "h720"
+	 },	/*  6 720KB AT      */
+	 {
+		 .size = 2880,
+		 .sect = 18,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x1B,
+		 .rate = 0x00,
+		 .spec1 = 0xCF,
+		 .fmt_gap = 0x6C,
+		 .name = "H1440"
+	 },	/*  7 1.44MB 3.5"   */
+	 {
+		 .size = 5760,
+		 .sect = 36,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x1B,
+		 .rate = 0x43,
+		 .spec1 = 0xAF,
+		 .fmt_gap = 0x54,
+		 .name = "E2880"
+	 },	/*  8 2.88MB 3.5"   */
+	 {
+		 .size = 6240,
+		 .sect = 39,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x1B,
+		 .rate = 0x43,
+		 .spec1 = 0xAF,
+		 .fmt_gap = 0x28,
+		 .name = "E3120"
+	 },	/*  9 3.12MB 3.5"   */
+	 {
+		 .size = 2880,
+		 .sect = 18,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x25,
+		 .rate = 0x00,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x02,
+		 .name = "h1440"
+	 },	/* 10 1.44MB 5.25"  */
+	 {
+		 .size = 3360,
+		 .sect = 21,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x1C,
+		 .rate = 0x00,
+		 .spec1 = 0xCF,
+		 .fmt_gap = 0x0C,
+		 .name = "H1680"
+	 },	/* 11 1.68MB 3.5"   */
+	 {
+		 .size = 820,
+		 .sect = 10,
+		 .head = 2,
+		 .track = 41,
+		 .stretch = 1,
+		 .gap = 0x25,
+		 .rate = 0x01,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x2E,
+		 .name = "h410"
+	 },	/* 12 410KB 5.25"   */
+	 {
+		 .size = 1640,
+		 .sect = 10,
+		 .head = 2,
+		 .track = 82,
+		 .stretch = 0,
+		 .gap = 0x25,
+		 .rate = 0x02,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x2E,
+		 .name = "H820"
+	 },	/* 13 820KB 3.5"    */
+	 {
+		 .size = 2952,
+		 .sect = 18,
+		 .head = 2,
+		 .track = 82,
+		 .stretch = 0,
+		 .gap = 0x25,
+		 .rate = 0x00,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x02,
+		 .name = "h1476"
+	 },	/* 14 1.48MB 5.25"  */
+	 {
+		 .size = 3444,
+		 .sect = 21,
+		 .head = 2,
+		 .track = 82,
+		 .stretch = 0,
+		 .gap = 0x25,
+		 .rate = 0x00,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x0C,
+		 .name = "H1722"
+	 },	/* 15 1.72MB 3.5"   */
+	 {
+		 .size = 840,
+		 .sect = 10,
+		 .head = 2,
+		 .track = 42,
+		 .stretch = 1,
+		 .gap = 0x25,
+		 .rate = 0x01,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x2E,
+		 .name = "h420"
+	 },	/* 16 420KB 5.25"   */
+	 {
+		 .size = 1660,
+		 .sect = 10,
+		 .head = 2,
+		 .track = 83,
+		 .stretch = 0,
+		 .gap = 0x25,
+		 .rate = 0x02,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x2E,
+		 .name = "H830"
+	 },	/* 17 830KB 3.5"    */
+	 {
+		 .size = 2988,
+		 .sect = 18,
+		 .head = 2,
+		 .track = 83,
+		 .stretch = 0,
+		 .gap = 0x25,
+		 .rate = 0x00,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x02,
+		 .name = "h1494"
+	 },	/* 18 1.49MB 5.25"  */
+	 {
+		 .size = 3486,
+		 .sect = 21,
+		 .head = 2,
+		 .track = 83,
+		 .stretch = 0,
+		 .gap = 0x25,
+		 .rate = 0x00,
+		 .spec1 = 0xDF,
+		 .fmt_gap = 0x0C,
+		 .name = "H1743"
+	 },	/* 19 1.74 MB 3.5"  */
+	 {
+		 .size = 1760,
+		 .sect = 11,
+		 .head = 2,
+		 .track = 80,
+		 .stretch = 0,
+		 .gap = 0x1C,
+		 .rate = 0x09,
+		 .spec1 = 0xCF,
+		 .fmt_gap = 0x00,
+		 .name = "h880"
+	},	/* 20 880KB 5.25"   */
+	{
+		.size = 2080,
+		.sect = 13,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x1C,
+		.rate = 0x01,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x00,
+		.name = "D1040"
+	},	/* 21 1.04MB 3.5"   */
+	{
+		.size = 2240,
+		.sect = 14,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x1C,
+		.rate = 0x19,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x00,
+		.name = "D1120"
+	},	/* 22 1.12MB 3.5"   */
+	{
+		.size = 3200,
+		.sect = 20,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x1C,
+		.rate = 0x20,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x2C,
+		.name = "h1600"
+	},	/* 23 1.6MB 5.25"   */
+	{
+		.size = 3520,
+		.sect = 22,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x1C,
+		.rate = 0x08,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x2e,
+		.name = "H1760"
+	},	/* 24 1.76MB 3.5"   */
+	{
+		.size = 3840,
+		.sect = 24,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x1C,
+		.rate = 0x20,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x00,
+		.name = "H1920"
+	},	/* 25 1.92MB 3.5"   */
+	{
+		.size = 6400,
+		.sect = 40,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x25,
+		.rate = 0x5B,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x00,
+		.name = "E3200"
+	},	/* 26 3.20MB 3.5"   */
+	{
+		.size = 7040,
+		.sect = 44,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x25,
+		.rate = 0x5B,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x00,
+		.name = "E3520"
+	},	/* 27 3.52MB 3.5"   */
+	{
+		.size = 7680,
+		.sect = 48,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x25,
+		.rate = 0x63,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x00,
+		.name = "E3840"
+	},	/* 28 3.84MB 3.5"   */
+	{
+		.size = 3680,
+		.sect = 23,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x1C,
+		.rate = 0x10,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x00,
+		.name = "H1840"
+	},	/* 29 1.84MB 3.5"   */
+	{
+		.size = 1600,
+		.sect = 10,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x25,
+		.rate = 0x02,
+		.spec1 = 0xDF,
+		.fmt_gap = 0x2E,
+		.name = "D800"
+	},	/* 30 800KB 3.5"    */
+	{
+		.size = 3200,
+		.sect = 20,
+		.head = 2,
+		.track = 80,
+		.stretch = 0,
+		.gap = 0x1C,
+		.rate = 0x00,
+		.spec1 = 0xCF,
+		.fmt_gap = 0x2C,
+		.name = "H1600"
+	},	/* 31 1.6MB 3.5"    */
 };
 
 #define SECTSIZE (_FD_SECTSIZE(*floppy))
@@ -505,9 +1025,9 @@ static char floppy_device_name[] = "floppy";
 static int probing;
 
 /* Synchronization of FDC access. */
-#define FD_COMMAND_NONE -1
-#define FD_COMMAND_ERROR 2
-#define FD_COMMAND_OKAY 3
+#define FD_COMMAND_NONE		-1
+#define FD_COMMAND_ERROR	2
+#define FD_COMMAND_OKAY		3
 
 static volatile int command_status = FD_COMMAND_NONE;
 static unsigned long fdc_busy;
@@ -515,11 +1035,12 @@ static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
-#define CALL(x) if ((x) == -EINTR) return -EINTR
-#define ECALL(x) if ((ret = (x))) return ret;
-#define _WAIT(x,i) CALL(ret=wait_til_done((x),i))
-#define WAIT(x) _WAIT((x),interruptible)
-#define IWAIT(x) _WAIT((x),1)
+
+#define CALL(x)		do { if ((x) == -EINTR) return -EINTR; } while (0)
+#define ECALL(x)	do { if ((ret = (x))) return ret; } while (0)
+#define _WAIT(x, i)	CALL(ret = wait_til_done((x), i))
+#define WAIT(x)		_WAIT((x), interruptible)
+#define IWAIT(x)	_WAIT((x), 1)
 
 /* Errors during formatting are counted here. */
 static int format_errors;
@@ -545,8 +1066,9 @@ static int max_buffer_sectors;
 static int *errors;
 typedef void (*done_f)(int);
 static struct cont_t {
-	void (*interrupt)(void);	/* this is called after the interrupt of the
-					 * main command */
+	void (*interrupt)(void);
+				/* this is called after the interrupt of the
+				 * main command */
 	void (*redo)(void);	/* this is called to retry the operation */
 	void (*error)(void);	/* this is called to tally an error */
 	done_f done;		/* this is called to say if the operation has
@@ -571,7 +1093,6 @@ static void floppy_release_irq_and_dma(void);
  * reset doesn't need to be tested before sending commands, because
  * output_byte is automatically disabled when reset is set.
  */
-#define CHECK_RESET { if (FDCS->reset){ reset_fdc(); return; } }
 static void reset_fdc(void);
 
 /*
@@ -624,14 +1145,19 @@ static inline void set_debugt(void)
 static inline void debugt(const char *message)
 {
 	if (DP->flags & DEBUGT)
-		printk("%s dtime=%lu\n", message, jiffies - debugtimer);
+		pr_info("%s dtime=%lu\n", message, jiffies - debugtimer);
 }
 #else
-static inline void set_debugt(void) { }
-static inline void debugt(const char *message) { }
+static inline void set_debugt(void)
+{
+}
+
+static inline void debugt(const char *message)
+{
+}
 #endif /* DEBUGT */
 
-typedef void (*timeout_fn) (unsigned long);
+typedef void (*timeout_fn)(unsigned long);
 static DEFINE_TIMER(fd_timeout, floppy_shutdown, 0, 0);
 
 static const char *timeout_message;
@@ -647,13 +1173,13 @@ static void is_alive(const char *message)
 }
 #endif
 
-static void (*do_floppy) (void) = NULL;
+static void (*do_floppy)(void) = NULL;
 
 #ifdef FLOPPY_SANITY_CHECK
 
 #define OLOGSIZE 20
 
-static void (*lasthandler) (void);
+static void (*lasthandler)(void);
 static unsigned long interruptjiffies;
 static unsigned long resultjiffies;
 static int resultsize;
@@ -683,9 +1209,7 @@ static void __reschedule_timeout(int drive, const char *message, int marg)
 		fd_timeout.expires = jiffies + UDP->timeout;
 	add_timer(&fd_timeout);
 	if (UDP->flags & FD_DEBUG) {
-		DPRINT("reschedule timeout ");
-		printk(message, marg);
-		printk("\n");
+		DPRINT("reschedule timeout %s %d\n", message, marg);
 	}
 	timeout_message = message;
 }
@@ -699,8 +1223,8 @@ static void reschedule_timeout(int drive, const char *message, int marg)
 	spin_unlock_irqrestore(&floppy_lock, flags);
 }
 
-#define INFBOUND(a,b) (a)=max_t(int, a, b)
-#define SUPBOUND(a,b) (a)=min_t(int, a, b)
+#define INFBOUND(a, b) (a) = max_t(int, a, b)
+#define SUPBOUND(a, b) (a) = min_t(int, a, b)
 
 /*
  * Bottom half floppy driver.
@@ -807,9 +1331,8 @@ static int set_dor(int fdc, char mask, char data)
 		if (is_selected(olddor, unit) && !is_selected(newdor, unit)) {
 			drive = REVDRIVE(fdc, unit);
 #ifdef DCL_DEBUG
-			if (UDP->flags & FD_DEBUG) {
+			if (UDP->flags & FD_DEBUG)
 				DPRINT("calling disk change from set_dor\n");
-			}
 #endif
 			disk_change(drive);
 		}
@@ -857,7 +1380,7 @@ static void set_fdc(int drive)
 		current_drive = drive;
 	}
 	if (fdc != 1 && fdc != 0) {
-		printk("bad fdc value\n");
+		pr_info("bad fdc value\n");
 		return;
 	}
 	set_dor(fdc, ~0, 8);
@@ -874,8 +1397,7 @@ static void set_fdc(int drive)
 static int _lock_fdc(int drive, int interruptible, int line)
 {
 	if (!usage_count) {
-		printk(KERN_ERR
-		       "Trying to lock fdc while usage count=0 at line %d\n",
+		pr_err("Trying to lock fdc while usage count=0 at line %d\n",
 		       line);
 		return -1;
 	}
@@ -909,10 +1431,12 @@ static int _lock_fdc(int drive, int interruptible, int line)
 	return 0;
 }
 
-#define lock_fdc(drive,interruptible) _lock_fdc(drive,interruptible, __LINE__)
+#define lock_fdc(drive, interruptible)			\
+	_lock_fdc(drive, interruptible, __LINE__)
 
-#define LOCK_FDC(drive,interruptible) \
-if (lock_fdc(drive,interruptible)) return -EINTR;
+#define LOCK_FDC(drive, interruptible)	    \
+	if (lock_fdc(drive, interruptible)) \
+		return -EINTR;
 
 /* unlocks the driver */
 static inline void unlock_fdc(void)
@@ -1003,7 +1527,7 @@ static void empty(void)
 
 static DECLARE_WORK(floppy_work, NULL);
 
-static void schedule_bh(void (*handler) (void))
+static void schedule_bh(void (*handler)(void))
 {
 	PREPARE_WORK(&floppy_work, (work_func_t)handler);
 	schedule_work(&floppy_work);
@@ -1027,9 +1551,8 @@ static void cancel_activity(void)
 static void fd_watchdog(void)
 {
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from watchdog\n");
-	}
 #endif
 
 	if (disk_change(current_drive)) {
@@ -1039,7 +1562,7 @@ static void fd_watchdog(void)
 		reset_fdc();
 	} else {
 		del_timer(&fd_timer);
-		fd_timer.function = (timeout_fn) fd_watchdog;
+		fd_timer.function = (timeout_fn)fd_watchdog;
 		fd_timer.expires = jiffies + HZ / 10;
 		add_timer(&fd_timer);
 	}
@@ -1109,16 +1632,16 @@ static void setup_DMA(void)
 	if (raw_cmd->length == 0) {
 		int i;
 
-		printk("zero dma transfer size:");
+		pr_info("zero dma transfer size:");
 		for (i = 0; i < raw_cmd->cmd_count; i++)
-			printk("%x,", raw_cmd->cmd[i]);
-		printk("\n");
+			pr_cont("%x,", raw_cmd->cmd[i]);
+		pr_cont("\n");
 		cont->done(0);
 		FDCS->reset = 1;
 		return;
 	}
 	if (((unsigned long)raw_cmd->kernel_data) % 512) {
-		printk("non aligned address: %p\n", raw_cmd->kernel_data);
+		pr_info("non aligned address: %p\n", raw_cmd->kernel_data);
 		cont->done(0);
 		FDCS->reset = 1;
 		return;
@@ -1176,10 +1699,11 @@ static int wait_til_ready(void)
 /* sends a command byte to the fdc */
 static int output_byte(char byte)
 {
-	int status;
+	int status = wait_til_ready();
 
-	if ((status = wait_til_ready()) < 0)
+	if (status < 0)
 		return -1;
+
 	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY) {
 		fd_outb(byte, FD_DATA);
 #ifdef FLOPPY_SANITY_CHECK
@@ -1199,16 +1723,15 @@ static int output_byte(char byte)
 	return -1;
 }
 
-#define LAST_OUT(x) if (output_byte(x)<0){ reset_fdc();return;}
-
 /* gets the response from the fdc */
 static int result(void)
 {
 	int i;
-	int status = 0;
+	int status;
 
 	for (i = 0; i < MAX_REPLIES; i++) {
-		if ((status = wait_til_ready()) < 0)
+		status = wait_til_ready();
+		if (status < 0)
 			break;
 		status &= STATUS_DIR | STATUS_READY | STATUS_BUSY | STATUS_DMA;
 		if ((status & ~STATUS_BUSY) == STATUS_READY) {
@@ -1234,12 +1757,13 @@ static int result(void)
 }
 
 #define MORE_OUTPUT -2
+
 /* does the fdc need more output? */
 static int need_more_output(void)
 {
-	int status;
+	int status = wait_til_ready();
 
-	if ((status = wait_til_ready()) < 0)
+	if (status < 0)
 		return -1;
 	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY)
 		return MORE_OUTPUT;
@@ -1264,9 +1788,12 @@ static inline void perpendicular_mode(void)
 		default:
 			DPRINT("Invalid data rate for perpendicular mode!\n");
 			cont->done(0);
-			FDCS->reset = 1;	/* convenient way to return to
-						 * redo without to much hassle (deep
-						 * stack et al. */
+			FDCS->reset = 1;
+					/*
+					 * convenient way to return to
+					 * redo without too much hassle
+					 * (deep stack et al.)
+					 */
 			return;
 		}
 	} else
@@ -1366,9 +1893,9 @@ static void fdc_specify(void)
 
 	/* Convert step rate from microseconds to milliseconds and 4 bits */
 	srt = 16 - DIV_ROUND_UP(DP->srt * scale_dtr / 1000, NOMINAL_DTR);
-	if (slow_floppy) {
+	if (slow_floppy)
 		srt = srt / 4;
-	}
+
 	SUPBOUND(srt, 0xf);
 	INFBOUND(srt, 0);
 
@@ -1415,20 +1942,50 @@ static int fdc_dtr(void)
 	 * Pause 5 msec to avoid trouble. (Needs to be 2 jiffies)
 	 */
 	FDCS->dtr = raw_cmd->rate & 3;
-	return (fd_wait_for_completion(jiffies + 2UL * HZ / 100,
-				       (timeout_fn) floppy_ready));
+	return fd_wait_for_completion(jiffies + 2UL * HZ / 100,
+				      (timeout_fn)floppy_ready);
 }				/* fdc_dtr */
 
 static void tell_sector(void)
 {
-	printk(": track %d, head %d, sector %d, size %d",
-	       R_TRACK, R_HEAD, R_SECTOR, R_SIZECODE);
+	pr_cont(": track %d, head %d, sector %d, size %d",
+		R_TRACK, R_HEAD, R_SECTOR, R_SIZECODE);
 }				/* tell_sector */
 
+static void print_errors(void)
+{
+	DPRINT("");
+	if (ST0 & ST0_ECE) {
+		pr_cont("Recalibrate failed!");
+	} else if (ST2 & ST2_CRC) {
+		pr_cont("data CRC error");
+		tell_sector();
+	} else if (ST1 & ST1_CRC) {
+		pr_cont("CRC error");
+		tell_sector();
+	} else if ((ST1 & (ST1_MAM | ST1_ND)) ||
+		   (ST2 & ST2_MAM)) {
+		if (!probing) {
+			pr_cont("sector not found");
+			tell_sector();
+		} else
+			pr_cont("probe failed...");
+	} else if (ST2 & ST2_WC) {	/* seek error */
+		pr_cont("wrong cylinder");
+	} else if (ST2 & ST2_BC) {	/* cylinder marked as bad */
+		pr_cont("bad cylinder");
+	} else {
+		pr_cont("unknown error. ST[0..2] are: 0x%x 0x%x 0x%x",
+			ST0, ST1, ST2);
+		tell_sector();
+	}
+	pr_cont("\n");
+}
+
 /*
  * OK, this error interpreting routine is called after a
- * DMA read/write has succeeded
- * or failed, so we check the results, and copy any buffers.
+ * DMA read/write has succeeded or failed, so we check the results,
+ * and copy any buffers.
  * hhb: Added better error reporting.
  * ak: Made this into a separate routine.
  */
@@ -1460,33 +2017,7 @@ static int interpret_errors(void)
 				DPRINT("Over/Underrun - retrying\n");
 			bad = 0;
 		} else if (*errors >= DP->max_errors.reporting) {
-			DPRINT("");
-			if (ST0 & ST0_ECE) {
-				printk("Recalibrate failed!");
-			} else if (ST2 & ST2_CRC) {
-				printk("data CRC error");
-				tell_sector();
-			} else if (ST1 & ST1_CRC) {
-				printk("CRC error");
-				tell_sector();
-			} else if ((ST1 & (ST1_MAM | ST1_ND))
-				   || (ST2 & ST2_MAM)) {
-				if (!probing) {
-					printk("sector not found");
-					tell_sector();
-				} else
-					printk("probe failed...");
-			} else if (ST2 & ST2_WC) {	/* seek error */
-				printk("wrong cylinder");
-			} else if (ST2 & ST2_BC) {	/* cylinder marked as bad */
-				printk("bad cylinder");
-			} else {
-				printk
-				    ("unknown error. ST[0..2] are: 0x%x 0x%x 0x%x",
-				     ST0, ST1, ST2);
-				tell_sector();
-			}
-			printk("\n");
+			print_errors();
 		}
 		if (ST2 & ST2_WC || ST2 & ST2_BC)
 			/* wrong cylinder => recal */
@@ -1531,9 +2062,9 @@ static void setup_rw_floppy(void)
 		 */
 		if (time_after(ready_date, jiffies + DP->select_delay)) {
 			ready_date -= DP->select_delay;
-			function = (timeout_fn) floppy_start;
+			function = (timeout_fn)floppy_start;
 		} else
-			function = (timeout_fn) setup_rw_floppy;
+			function = (timeout_fn)setup_rw_floppy;
 
 		/* wait until the floppy is spinning fast enough */
 		if (fd_wait_for_completion(ready_date, function))
@@ -1585,8 +2116,7 @@ static void seek_interrupt(void)
 	if (DRS->track >= 0 && DRS->track != ST1 && !blind_seek) {
 #ifdef DCL_DEBUG
 		if (DP->flags & FD_DEBUG) {
-			DPRINT
-			    ("clearing NEWCHANGE flag because of effective seek\n");
+			DPRINT("clearing NEWCHANGE flag because of effective seek\n");
 			DPRINT("jiffies=%lu\n", jiffies);
 		}
 #endif
@@ -1629,9 +2159,8 @@ static void seek_floppy(void)
 	blind_seek = 0;
 
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from seek\n");
-	}
 #endif
 
 	if (!TESTF(FD_DISK_NEWCHANGE) &&
@@ -1677,7 +2206,10 @@ static void seek_floppy(void)
 	do_floppy = seek_interrupt;
 	output_byte(FD_SEEK);
 	output_byte(UNIT(current_drive));
-	LAST_OUT(track);
+	if (output_byte(track) < 0) {
+		reset_fdc();
+		return;
+	}
 	debugt("seek command:");
 }
 
@@ -1706,10 +2238,8 @@ static void recal_interrupt(void)
 			 * be already at track 0.) Clear the
 			 * new change flag */
 #ifdef DCL_DEBUG
-			if (DP->flags & FD_DEBUG) {
-				DPRINT
-				    ("clearing NEWCHANGE flag because of second recalibrate\n");
-			}
+			if (DP->flags & FD_DEBUG)
+				DPRINT("clearing NEWCHANGE flag because of second recalibrate\n");
 #endif
 
 			CLEARF(FD_DISK_NEWCHANGE);
@@ -1738,8 +2268,8 @@ static void print_result(char *message, int inr)
 	DPRINT("%s ", message);
 	if (inr >= 0)
 		for (i = 0; i < inr; i++)
-			printk("repl[%d]=%x ", i, reply_buffer[i]);
-	printk("\n");
+			pr_cont("repl[%d]=%x ", i, reply_buffer[i]);
+	pr_cont("\n");
 }
 
 /* interrupt handler. Note that this can be called externally on the Sparc */
@@ -1760,9 +2290,9 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	do_floppy = NULL;
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
-		printk("DOR0=%x\n", fdc_state[0].dor);
-		printk("floppy interrupt on bizarre fdc %d\n", fdc);
-		printk("handler=%p\n", handler);
+		pr_info("DOR0=%x\n", fdc_state[0].dor);
+		pr_info("floppy interrupt on bizarre fdc %d\n", fdc);
+		pr_info("handler=%p\n", handler);
 		is_alive("bizarre fdc");
 		return IRQ_NONE;
 	}
@@ -1809,7 +2339,10 @@ static void recalibrate_floppy(void)
 	debugt("recalibrate floppy:");
 	do_floppy = recal_interrupt;
 	output_byte(FD_RECALIBRATE);
-	LAST_OUT(UNIT(current_drive));
+	if (UNIT(current_drive) < 0) {
+		reset_fdc();
+		return;
+	}
 }
 
 /*
@@ -1820,7 +2353,7 @@ static void reset_interrupt(void)
 	debugt("reset interrupt:");
 	result();		/* get the status ready for set_fdc */
 	if (FDCS->reset) {
-		printk("reset set in interrupt, calling %p\n", cont->error);
+		pr_info("reset set in interrupt, calling %p\n", cont->error);
 		cont->error();	/* a reset just after a reset. BAD! */
 	}
 	cont->redo();
@@ -1858,46 +2391,44 @@ static void show_floppy(void)
 {
 	int i;
 
-	printk("\n");
-	printk("floppy driver state\n");
-	printk("-------------------\n");
-	printk("now=%lu last interrupt=%lu diff=%lu last called handler=%p\n",
-	       jiffies, interruptjiffies, jiffies - interruptjiffies,
-	       lasthandler);
+	pr_info("\n");
+	pr_info("floppy driver state\n");
+	pr_info("-------------------\n");
+	pr_info("now=%lu last interrupt=%lu diff=%lu last called handler=%p\n",
+		jiffies, interruptjiffies, jiffies - interruptjiffies,
+		lasthandler);
 
 #ifdef FLOPPY_SANITY_CHECK
-	printk("timeout_message=%s\n", timeout_message);
-	printk("last output bytes:\n");
+	pr_info("timeout_message=%s\n", timeout_message);
+	pr_info("last output bytes:\n");
 	for (i = 0; i < OLOGSIZE; i++)
-		printk("%2x %2x %lu\n",
-		       output_log[(i + output_log_pos) % OLOGSIZE].data,
-		       output_log[(i + output_log_pos) % OLOGSIZE].status,
-		       output_log[(i + output_log_pos) % OLOGSIZE].jiffies);
-	printk("last result at %lu\n", resultjiffies);
-	printk("last redo_fd_request at %lu\n", lastredo);
-	for (i = 0; i < resultsize; i++) {
-		printk("%2x ", reply_buffer[i]);
-	}
-	printk("\n");
+		pr_info("%2x %2x %lu\n",
+			output_log[(i + output_log_pos) % OLOGSIZE].data,
+			output_log[(i + output_log_pos) % OLOGSIZE].status,
+			output_log[(i + output_log_pos) % OLOGSIZE].jiffies);
+	pr_info("last result at %lu\n", resultjiffies);
+	pr_info("last redo_fd_request at %lu\n", lastredo);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1,
+		       reply_buffer, resultsize, true);
 #endif
 
-	printk("status=%x\n", fd_inb(FD_STATUS));
-	printk("fdc_busy=%lu\n", fdc_busy);
+	pr_info("status=%x\n", fd_inb(FD_STATUS));
+	pr_info("fdc_busy=%lu\n", fdc_busy);
 	if (do_floppy)
-		printk("do_floppy=%p\n", do_floppy);
+		pr_info("do_floppy=%p\n", do_floppy);
 	if (work_pending(&floppy_work))
-		printk("floppy_work.func=%p\n", floppy_work.func);
+		pr_info("floppy_work.func=%p\n", floppy_work.func);
 	if (timer_pending(&fd_timer))
-		printk("fd_timer.function=%p\n", fd_timer.function);
+		pr_info("fd_timer.function=%p\n", fd_timer.function);
 	if (timer_pending(&fd_timeout)) {
-		printk("timer_function=%p\n", fd_timeout.function);
-		printk("expires=%lu\n", fd_timeout.expires - jiffies);
-		printk("now=%lu\n", jiffies);
-	}
-	printk("cont=%p\n", cont);
-	printk("current_req=%p\n", current_req);
-	printk("command_status=%d\n", command_status);
-	printk("\n");
+		pr_info("timer_function=%p\n", fd_timeout.function);
+		pr_info("expires=%lu\n", fd_timeout.expires - jiffies);
+		pr_info("now=%lu\n", jiffies);
+	}
+	pr_info("cont=%p\n", cont);
+	pr_info("current_req=%p\n", current_req);
+	pr_info("command_status=%d\n", command_status);
+	pr_info("\n");
 }
 
 static void floppy_shutdown(unsigned long data)
@@ -1923,7 +2454,7 @@ static void floppy_shutdown(unsigned long data)
 		cont->done(0);
 		cont->redo();	/* this will recall reset when needed */
 	} else {
-		printk("no cont in shutdown!\n");
+		pr_info("no cont in shutdown!\n");
 		process_fd_request();
 	}
 	is_alive("floppy shutdown");
@@ -1954,27 +2485,29 @@ static int start_motor(void (*function)(void))
 	set_dor(fdc, mask, data);
 
 	/* wait_for_completion also schedules reset if needed. */
-	return (fd_wait_for_completion(DRS->select_date + DP->select_delay,
-				       (timeout_fn) function));
+	return fd_wait_for_completion(DRS->select_date + DP->select_delay,
+				      (timeout_fn)function);
 }
 
 static void floppy_ready(void)
 {
-	CHECK_RESET;
+	if (FDCS->reset) {
+		reset_fdc();
+		return;
+	}
 	if (start_motor(floppy_ready))
 		return;
 	if (fdc_dtr())
 		return;
 
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from floppy_ready\n");
-	}
 #endif
 	if (!(raw_cmd->flags & FD_RAW_NO_MOTOR) &&
 	    disk_change(current_drive) && !DP->select_delay)
-		twaddle();	/* this clears the dcl on certain drive/controller
-				 * combinations */
+		twaddle();	/* this clears the dcl on certain
+				 * drive/controller combinations */
 
 #ifdef fd_chose_dma_mode
 	if ((raw_cmd->flags & FD_RAW_READ) || (raw_cmd->flags & FD_RAW_WRITE)) {
@@ -2002,9 +2535,8 @@ static void floppy_start(void)
 
 	scandrives();
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("setting NEWCHANGE in floppy_start\n");
-	}
 #endif
 	SETF(FD_DISK_NEWCHANGE);
 	floppy_ready();
@@ -2181,8 +2713,9 @@ static void format_interrupt(void)
 }
 
 #define CODE2SIZE (ssize = ((1 << SIZECODE) + 3) >> 2)
-#define FM_MODE(x,y) ((y) & ~(((x)->rate & 0x80) >>1))
+#define FM_MODE(x, y) ((y) & ~(((x)->rate & 0x80) >> 1))
 #define CT(x) ((x) | 0xc0)
+
 static void setup_format_params(int track)
 {
 	int n;
@@ -2197,8 +2730,8 @@ static void setup_format_params(int track)
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->track = track;
 
-	raw_cmd->flags = FD_RAW_WRITE | FD_RAW_INTR | FD_RAW_SPIN |
-	    FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK;
+	raw_cmd->flags = (FD_RAW_WRITE | FD_RAW_INTR | FD_RAW_SPIN |
+			  FD_RAW_NEED_DISK | FD_RAW_NEED_SEEK);
 	raw_cmd->rate = _floppy->rate & 0x43;
 	raw_cmd->cmd_count = NR_F;
 	COMMAND = FM_MODE(_floppy, FD_FORMAT);
@@ -2325,7 +2858,7 @@ static void request_done(int uptodate)
 	reschedule_timeout(MAXTIMEOUT, "request done %d", uptodate);
 
 	if (!req) {
-		printk("floppy.c: no request in request_done\n");
+		pr_info("floppy.c: no request in request_done\n");
 		return;
 	}
 
@@ -2398,13 +2931,13 @@ static void rw_interrupt(void)
 	    DIV_ROUND_UP(in_sector_offset + current_count_sectors, ssize)) {
 		DPRINT("long rw: %x instead of %lx\n",
 		       nr_sectors, current_count_sectors);
-		printk("rs=%d s=%d\n", R_SECTOR, SECTOR);
-		printk("rh=%d h=%d\n", R_HEAD, HEAD);
-		printk("rt=%d t=%d\n", R_TRACK, TRACK);
-		printk("heads=%d eoc=%d\n", heads, eoc);
-		printk("spt=%d st=%d ss=%d\n", SECT_PER_TRACK,
-		       fsector_t, ssize);
-		printk("in_sector_offset=%d\n", in_sector_offset);
+		pr_info("rs=%d s=%d\n", R_SECTOR, SECTOR);
+		pr_info("rh=%d h=%d\n", R_HEAD, HEAD);
+		pr_info("rt=%d t=%d\n", R_TRACK, TRACK);
+		pr_info("heads=%d eoc=%d\n", heads, eoc);
+		pr_info("spt=%d st=%d ss=%d\n",
+			SECT_PER_TRACK, fsector_t, ssize);
+		pr_info("in_sector_offset=%d\n", in_sector_offset);
 	}
 #endif
 
@@ -2514,14 +3047,14 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 #ifdef FLOPPY_SANITY_CHECK
 	if (remaining > blk_rq_bytes(current_req) && CT(COMMAND) == FD_WRITE) {
 		DPRINT("in copy buffer\n");
-		printk("current_count_sectors=%ld\n", current_count_sectors);
-		printk("remaining=%d\n", remaining >> 9);
-		printk("current_req->nr_sectors=%u\n",
-		       blk_rq_sectors(current_req));
-		printk("current_req->current_nr_sectors=%u\n",
-		       blk_rq_cur_sectors(current_req));
-		printk("max_sector=%d\n", max_sector);
-		printk("ssize=%d\n", ssize);
+		pr_info("current_count_sectors=%ld\n", current_count_sectors);
+		pr_info("remaining=%d\n", remaining >> 9);
+		pr_info("current_req->nr_sectors=%u\n",
+			blk_rq_sectors(current_req));
+		pr_info("current_req->current_nr_sectors=%u\n",
+			blk_rq_cur_sectors(current_req));
+		pr_info("max_sector=%d\n", max_sector);
+		pr_info("ssize=%d\n", ssize);
 	}
 #endif
 
@@ -2544,16 +3077,15 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 		    floppy_track_buffer + (max_buffer_sectors << 10) ||
 		    dma_buffer < floppy_track_buffer) {
 			DPRINT("buffer overrun in copy buffer %d\n",
-			       (int)((floppy_track_buffer -
-				      dma_buffer) >> 9));
-			printk("fsector_t=%d buffer_min=%d\n",
-			       fsector_t, buffer_min);
-			printk("current_count_sectors=%ld\n",
-			       current_count_sectors);
+			       (int)((floppy_track_buffer - dma_buffer) >> 9));
+			pr_info("fsector_t=%d buffer_min=%d\n",
+				fsector_t, buffer_min);
+			pr_info("current_count_sectors=%ld\n",
+				current_count_sectors);
 			if (CT(COMMAND) == FD_READ)
-				printk("read\n");
+				pr_info("read\n");
 			if (CT(COMMAND) == FD_WRITE)
-				printk("write\n");
+				pr_info("write\n");
 			break;
 		}
 		if (((unsigned long)buffer) % 512)
@@ -2595,13 +3127,14 @@ static void virtualdmabug_workaround(void)
 		end_sector = SECTOR + hard_sectors - 1;
 #ifdef FLOPPY_SANITY_CHECK
 		if (end_sector > SECT_PER_TRACK) {
-			printk("too many sectors %d > %d\n",
-			       end_sector, SECT_PER_TRACK);
+			pr_info("too many sectors %d > %d\n",
+				end_sector, SECT_PER_TRACK);
 			return;
 		}
 #endif
-		SECT_PER_TRACK = end_sector;	/* make sure SECT_PER_TRACK points
-						 * to end of transfer */
+		SECT_PER_TRACK = end_sector;
+					/* make sure SECT_PER_TRACK
+					 * points to end of transfer */
 	}
 }
 
@@ -2624,7 +3157,7 @@ static int make_raw_rw_request(void)
 	int ssize;
 
 	if (max_buffer_sectors == 0) {
-		printk("VFS: Block I/O scheduled on unopened device\n");
+		pr_info("VFS: Block I/O scheduled on unopened device\n");
 		return 0;
 	}
 
@@ -2731,7 +3264,8 @@ static int make_raw_rw_request(void)
 	} else if (in_sector_offset || blk_rq_sectors(current_req) < ssize) {
 		if (CT(COMMAND) == FD_WRITE) {
 			if (fsector_t + blk_rq_sectors(current_req) > ssize &&
-			    fsector_t + blk_rq_sectors(current_req) < ssize + ssize)
+			    fsector_t + blk_rq_sectors(current_req) <
+			    ssize + ssize)
 				max_size = ssize + ssize;
 			else
 				max_size = ssize;
@@ -2755,9 +3289,8 @@ static int make_raw_rw_request(void)
 		dma_limit =
 		    (MAX_DMA_ADDRESS -
 		     ((unsigned long)current_req->buffer)) >> 9;
-		if ((unsigned long)max_size > dma_limit) {
+		if ((unsigned long)max_size > dma_limit)
 			max_size = dma_limit;
-		}
 		/* 64 kb boundaries */
 		if (CROSS_64KB(current_req->buffer, max_size << 9))
 			max_size = (K_64 -
@@ -2773,15 +3306,15 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < DP->max_errors.read_track && ((!probing
-		       || (DP->read_track & (1 << DRS->probed_format)))))) {
+		     *errors < DP->max_errors.read_track &&
+		     ((!probing ||
+		       (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = blk_rq_sectors(current_req);
 		} else {
 			raw_cmd->kernel_data = current_req->buffer;
 			raw_cmd->length = current_count_sectors << 9;
 			if (raw_cmd->length == 0) {
-				DPRINT
-				    ("zero dma transfer attempted from make_raw_request\n");
+				DPRINT("zero dma transfer attempted from make_raw_request\n");
 				DPRINT("indirect=%d direct=%d fsector_t=%d",
 				       indirect, direct, fsector_t);
 				return 0;
@@ -2802,15 +3335,14 @@ static int make_raw_rw_request(void)
 	    ((CT(COMMAND) == FD_READ ||
 	      (!in_sector_offset && blk_rq_sectors(current_req) >= ssize)) &&
 	     max_sector > 2 * max_buffer_sectors + buffer_min &&
-	     max_size + fsector_t > 2 * max_buffer_sectors + buffer_min)
-	    /* not enough space */
-	    ) {
+	     max_size + fsector_t > 2 * max_buffer_sectors + buffer_min)) {
+		/* not enough space */
 		buffer_track = -1;
 		buffer_drive = current_drive;
 		buffer_max = buffer_min = aligned_sector_t;
 	}
 	raw_cmd->kernel_data = floppy_track_buffer +
-	    ((aligned_sector_t - buffer_min) << 9);
+		((aligned_sector_t - buffer_min) << 9);
 
 	if (CT(COMMAND) == FD_WRITE) {
 		/* copy write buffer to track buffer.
@@ -2845,19 +3377,19 @@ static int make_raw_rw_request(void)
 		DPRINT("fractionary current count b=%lx s=%lx\n",
 		       raw_cmd->length, current_count_sectors);
 		if (raw_cmd->kernel_data != current_req->buffer)
-			printk("addr=%d, length=%ld\n",
-			       (int)((raw_cmd->kernel_data -
-				      floppy_track_buffer) >> 9),
-			       current_count_sectors);
-		printk("st=%d ast=%d mse=%d msi=%d\n",
-		       fsector_t, aligned_sector_t, max_sector, max_size);
-		printk("ssize=%x SIZECODE=%d\n", ssize, SIZECODE);
-		printk("command=%x SECTOR=%d HEAD=%d, TRACK=%d\n",
-		       COMMAND, SECTOR, HEAD, TRACK);
-		printk("buffer drive=%d\n", buffer_drive);
-		printk("buffer track=%d\n", buffer_track);
-		printk("buffer_min=%d\n", buffer_min);
-		printk("buffer_max=%d\n", buffer_max);
+			pr_info("addr=%d, length=%ld\n",
+				(int)((raw_cmd->kernel_data -
+				       floppy_track_buffer) >> 9),
+				current_count_sectors);
+		pr_info("st=%d ast=%d mse=%d msi=%d\n",
+			fsector_t, aligned_sector_t, max_sector, max_size);
+		pr_info("ssize=%x SIZECODE=%d\n", ssize, SIZECODE);
+		pr_info("command=%x SECTOR=%d HEAD=%d, TRACK=%d\n",
+			COMMAND, SECTOR, HEAD, TRACK);
+		pr_info("buffer drive=%d\n", buffer_drive);
+		pr_info("buffer track=%d\n", buffer_track);
+		pr_info("buffer_min=%d\n", buffer_min);
+		pr_info("buffer_max=%d\n", buffer_max);
 		return 0;
 	}
 
@@ -2868,14 +3400,14 @@ static int make_raw_rw_request(void)
 		    raw_cmd->kernel_data + raw_cmd->length >
 		    floppy_track_buffer + (max_buffer_sectors << 10)) {
 			DPRINT("buffer overrun in schedule dma\n");
-			printk("fsector_t=%d buffer_min=%d current_count=%ld\n",
-			       fsector_t, buffer_min, raw_cmd->length >> 9);
-			printk("current_count_sectors=%ld\n",
-			       current_count_sectors);
+			pr_info("fsector_t=%d buffer_min=%d current_count=%ld\n",
+				fsector_t, buffer_min, raw_cmd->length >> 9);
+			pr_info("current_count_sectors=%ld\n",
+				current_count_sectors);
 			if (CT(COMMAND) == FD_READ)
-				printk("read\n");
+				pr_info("read\n");
 			if (CT(COMMAND) == FD_WRITE)
-				printk("write\n");
+				pr_info("write\n");
 			return 0;
 		}
 	} else if (raw_cmd->length > blk_rq_bytes(current_req) ||
@@ -2884,8 +3416,8 @@ static int make_raw_rw_request(void)
 		return 0;
 	} else if (raw_cmd->length < current_count_sectors << 9) {
 		DPRINT("more sectors than bytes\n");
-		printk("bytes=%ld\n", raw_cmd->length >> 9);
-		printk("sectors=%ld\n", current_count_sectors);
+		pr_info("bytes=%ld\n", raw_cmd->length >> 9);
+		pr_info("sectors=%ld\n", current_count_sectors);
 	}
 	if (raw_cmd->length == 0) {
 		DPRINT("zero dma transfer attempted from make_raw_request\n");
@@ -2979,19 +3511,19 @@ static void process_fd_request(void)
 	schedule_bh(redo_fd_request);
 }
 
-static void do_fd_request(struct request_queue * q)
+static void do_fd_request(struct request_queue *q)
 {
 	if (max_buffer_sectors == 0) {
-		printk("VFS: do_fd_request called on non-open device\n");
+		pr_info("VFS: do_fd_request called on non-open device\n");
 		return;
 	}
 
 	if (usage_count == 0) {
-		printk("warning: usage count=0, current_req=%p exiting\n",
-		       current_req);
-		printk("sect=%ld type=%x flags=%x\n",
-		       (long)blk_rq_pos(current_req), current_req->cmd_type,
-		       current_req->cmd_flags);
+		pr_info("warning: usage count=0, current_req=%p exiting\n",
+			current_req);
+		pr_info("sect=%ld type=%x flags=%x\n",
+			(long)blk_rq_pos(current_req), current_req->cmd_type,
+			current_req->cmd_flags);
 		return;
 	}
 	if (test_bit(0, &fdc_busy)) {
@@ -3023,9 +3555,8 @@ static int poll_drive(int interruptible, int flag)
 	raw_cmd->cmd_count = 0;
 	cont = &poll_cont;
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("setting NEWCHANGE in poll_drive\n");
-	}
 #endif
 	SETF(FD_DISK_NEWCHANGE);
 	WAIT(floppy_ready);
@@ -3039,7 +3570,7 @@ static int poll_drive(int interruptible, int flag)
 
 static void reset_intr(void)
 {
-	printk("weird, reset interrupt called\n");
+	pr_info("weird, reset interrupt called\n");
 }
 
 static struct cont_t reset_cont = {
@@ -3075,16 +3606,19 @@ static inline int fd_copyout(void __user *param, const void *address,
 	return copy_to_user(param, address, size) ? -EFAULT : 0;
 }
 
-static inline int fd_copyin(void __user *param, void *address, unsigned long size)
+static inline int fd_copyin(void __user *param, void *address,
+			    unsigned long size)
 {
 	return copy_from_user(address, param, size) ? -EFAULT : 0;
 }
 
-#define _COPYOUT(x) (copy_to_user((void __user *)param, &(x), sizeof(x)) ? -EFAULT : 0)
-#define _COPYIN(x) (copy_from_user(&(x), (void __user *)param, sizeof(x)) ? -EFAULT : 0)
+#define _COPYOUT(x)	(copy_to_user((void __user *)param, &(x), sizeof(x)) \
+			 ? -EFAULT : 0)
+#define _COPYIN(x)	(copy_from_user(&(x), (void __user *)param, sizeof(x)) \
+			 ? -EFAULT : 0)
 
-#define COPYOUT(x) ECALL(_COPYOUT(x))
-#define COPYIN(x) ECALL(_COPYIN(x))
+#define COPYOUT(x)	ECALL(_COPYOUT(x))
+#define COPYIN(x)	ECALL(_COPYIN(x))
 
 static inline const char *drive_name(int type, int drive)
 {
@@ -3165,11 +3699,12 @@ static inline int raw_cmd_copyout(int cmd, char __user *param,
 		COPYOUT(*ptr);
 		param += sizeof(struct floppy_raw_cmd);
 		if ((ptr->flags & FD_RAW_READ) && ptr->buffer_length) {
-			if (ptr->length >= 0
-			    && ptr->length <= ptr->buffer_length)
-				ECALL(fd_copyout
-				      (ptr->data, ptr->kernel_data,
-				       ptr->buffer_length - ptr->length));
+			if (ptr->length >= 0 &&
+			    ptr->length <= ptr->buffer_length) {
+				long length = ptr->buffer_length - ptr->length;
+				ECALL(fd_copyout(ptr->data, ptr->kernel_data,
+						 length));
+			}
 		}
 		ptr = ptr->next;
 	}
@@ -3204,8 +3739,7 @@ static inline int raw_cmd_copyin(int cmd, char __user *param,
 
 	*rcmd = NULL;
 	while (1) {
-		ptr = (struct floppy_raw_cmd *)
-		    kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
+		ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
 		if (!ptr)
 			return -ENOMEM;
 		*rcmd = ptr;
@@ -3285,9 +3819,8 @@ static int raw_cmd_ioctl(int cmd, void __user *param)
 	cont = &raw_cmd_cont;
 	ret = wait_til_done(floppy_start, 1);
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from raw_cmd ioctl\n");
-	}
 #endif
 
 	if (ret != -EINTR && FDCS->reset)
@@ -3415,7 +3948,7 @@ static inline int normalize_ioctl(int *cmd, int *size)
 			*size = _IOC_SIZE(*cmd);
 			*cmd = ioctl_table[i];
 			if (*size > _IOC_SIZE(*cmd)) {
-				printk("ioctl not yet supported\n");
+				pr_info("ioctl not yet supported\n");
 				return -EFAULT;
 			}
 			return 0;
@@ -3459,9 +3992,7 @@ static int fd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		    unsigned long param)
 {
-#define FD_IOCTL_ALLOWED (mode & (FMODE_WRITE|FMODE_WRITE_IOCTL))
-#define OUT(c,x) case c: outparam = (const char *) (x); break
-#define IN(c,x,tag) case c: *(x) = inparam. tag ; return 0
+#define FD_IOCTL_ALLOWED (mode & (FMODE_WRITE | FMODE_WRITE_IOCTL))
 
 	int drive = (long)bdev->bd_disk->private_data;
 	int type = ITYPE(UDRS->fd_device);
@@ -3479,143 +4010,163 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	/* convert compatibility eject ioctls into floppy eject ioctl.
 	 * We do this in order to provide a means to eject floppy disks before
 	 * installing the new fdutils package */
-	if (cmd == CDROMEJECT ||	/* CD-ROM eject */
-	    cmd == 0x6470 /* SunOS floppy eject */ ) {
+	if (cmd == CDROMEJECT || cmd == 0x6470) {
 		DPRINT("obsolete eject ioctl\n");
 		DPRINT("please use floppycontrol --eject\n");
 		cmd = FDEJECT;
 	}
 
-	/* convert the old style command into a new style command */
-	if ((cmd & 0xff00) == 0x0200) {
-		ECALL(normalize_ioctl(&cmd, &size));
-	} else
+	if ((cmd & 0xff00) != 0x0200)
 		return -EINVAL;
 
+	/* convert the old style command into a new style command */
+	ECALL(normalize_ioctl(&cmd, &size));
+
 	/* permission checks */
 	if (((cmd & 0x40) && !FD_IOCTL_ALLOWED) ||
 	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
 		return -EPERM;
 
 	/* copyin */
-	CLEARSTRUCT(&inparam);
+	memset(&inparam, 0, sizeof(inparam));
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
-	    ECALL(fd_copyin((void __user *)param, &inparam, size))
+		ECALL(fd_copyin((void __user *)param, &inparam, size));
 
-		switch (cmd) {
-		case FDEJECT:
-			if (UDRS->fd_ref != 1)
-				/* somebody else has this drive open */
-				return -EBUSY;
-			LOCK_FDC(drive, 1);
+	switch (cmd) {
+	case FDEJECT:
+		if (UDRS->fd_ref != 1)
+			/* somebody else has this drive open */
+			return -EBUSY;
+		LOCK_FDC(drive, 1);
 
-			/* do the actual eject. Fails on
-			 * non-Sparc architectures */
-			ret = fd_eject(UNIT(drive));
+		/* do the actual eject. Fails on
+		 * non-Sparc architectures */
+		ret = fd_eject(UNIT(drive));
 
-			USETF(FD_DISK_CHANGED);
-			USETF(FD_VERIFY);
-			process_fd_request();
-			return ret;
-		case FDCLRPRM:
-			LOCK_FDC(drive, 1);
-			current_type[drive] = NULL;
-			floppy_sizes[drive] = MAX_DISK_SIZE << 1;
-			UDRS->keep_data = 0;
-			return invalidate_drive(bdev);
-		case FDSETPRM:
-		case FDDEFPRM:
-			return set_geometry(cmd, &inparam.g,
-					    drive, type, bdev);
-		case FDGETPRM:
-			ECALL(get_floppy_geometry(drive, type,
-						  (struct floppy_struct **)
-						  &outparam));
-			break;
+		USETF(FD_DISK_CHANGED);
+		USETF(FD_VERIFY);
+		process_fd_request();
+		return ret;
 
-		case FDMSGON:
-			UDP->flags |= FTD_MSG;
-			return 0;
-		case FDMSGOFF:
-			UDP->flags &= ~FTD_MSG;
-			return 0;
+	case FDCLRPRM:
+		LOCK_FDC(drive, 1);
+		current_type[drive] = NULL;
+		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
+		UDRS->keep_data = 0;
+		return invalidate_drive(bdev);
+
+	case FDSETPRM:
+	case FDDEFPRM:
+		return set_geometry(cmd, &inparam.g, drive, type, bdev);
+
+	case FDGETPRM:
+		ECALL(get_floppy_geometry(drive, type,
+					  (struct floppy_struct **)
+					  &outparam));
+		break;
 
-		case FDFMTBEG:
-			LOCK_FDC(drive, 1);
-			CALL(poll_drive(1, FD_RAW_NEED_DISK));
-			ret = UDRS->flags;
-			process_fd_request();
-			if (ret & FD_VERIFY)
-				return -ENODEV;
-			if (!(ret & FD_DISK_WRITABLE))
-				return -EROFS;
-			return 0;
-		case FDFMTTRK:
-			if (UDRS->fd_ref != 1)
-				return -EBUSY;
-			return do_format(drive, &inparam.f);
-		case FDFMTEND:
-		case FDFLUSH:
-			LOCK_FDC(drive, 1);
-			return invalidate_drive(bdev);
-
-		case FDSETEMSGTRESH:
-			UDP->max_errors.reporting =
-			    (unsigned short)(param & 0x0f);
-			return 0;
-			OUT(FDGETMAXERRS, &UDP->max_errors);
-			IN(FDSETMAXERRS, &UDP->max_errors, max_errors);
+	case FDMSGON:
+		UDP->flags |= FTD_MSG;
+		return 0;
 
-		case FDGETDRVTYP:
-			outparam = drive_name(type, drive);
-			SUPBOUND(size, strlen(outparam) + 1);
-			break;
+	case FDMSGOFF:
+		UDP->flags &= ~FTD_MSG;
+		return 0;
 
-			IN(FDSETDRVPRM, UDP, dp);
-			OUT(FDGETDRVPRM, UDP);
+	case FDFMTBEG:
+		LOCK_FDC(drive, 1);
+		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		ret = UDRS->flags;
+		process_fd_request();
+		if (ret & FD_VERIFY)
+			return -ENODEV;
+		if (!(ret & FD_DISK_WRITABLE))
+			return -EROFS;
+		return 0;
 
-		case FDPOLLDRVSTAT:
-			LOCK_FDC(drive, 1);
-			CALL(poll_drive(1, FD_RAW_NEED_DISK));
-			process_fd_request();
-			/* fall through */
-			OUT(FDGETDRVSTAT, UDRS);
+	case FDFMTTRK:
+		if (UDRS->fd_ref != 1)
+			return -EBUSY;
+		return do_format(drive, &inparam.f);
 
-		case FDRESET:
-			return user_reset_fdc(drive, (int)param, 1);
+	case FDFMTEND:
+	case FDFLUSH:
+		LOCK_FDC(drive, 1);
+		return invalidate_drive(bdev);
 
-			OUT(FDGETFDCSTAT, UFDCS);
+	case FDSETEMSGTRESH:
+		UDP->max_errors.reporting = (unsigned short)(param & 0x0f);
+		return 0;
 
-		case FDWERRORCLR:
-			CLEARSTRUCT(UDRWE);
-			return 0;
-			OUT(FDWERRORGET, UDRWE);
+	case FDGETMAXERRS:
+		outparam = (const char *)&UDP->max_errors;
+		break;
 
-		case FDRAWCMD:
-			if (type)
-				return -EINVAL;
-			LOCK_FDC(drive, 1);
-			set_floppy(drive);
-			CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
-			process_fd_request();
-			return i;
+	case FDSETMAXERRS:
+		UDP->max_errors = inparam.max_errors;
+		return 0;
 
-		case FDTWADDLE:
-			LOCK_FDC(drive, 1);
-			twaddle();
-			process_fd_request();
-			return 0;
+	case FDGETDRVTYP:
+		outparam = drive_name(type, drive);
+		SUPBOUND(size, strlen(outparam) + 1);
+		break;
 
-		default:
+	case FDSETDRVPRM:
+		*UDP = inparam.dp;
+		return 0;
+
+	case FDGETDRVPRM:
+		outparam = (const char *)UDP;
+		break;
+
+	case FDPOLLDRVSTAT:
+		LOCK_FDC(drive, 1);
+		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		process_fd_request();
+		/* fall through */
+
+	case FDGETDRVSTAT:
+		outparam = (const char *)UDRS;
+		break;
+
+	case FDRESET:
+		return user_reset_fdc(drive, (int)param, 1);
+
+	case FDGETFDCSTAT:
+		outparam = (const char *)UFDCS;
+		break;
+
+	case FDWERRORCLR:
+		memset(UDRWE, 0, sizeof(*UDRWE));
+		return 0;
+
+	case FDWERRORGET:
+		outparam = (const char *)UDRWE;
+		break;
+
+	case FDRAWCMD:
+		if (type)
 			return -EINVAL;
-		}
+		LOCK_FDC(drive, 1);
+		set_floppy(drive);
+		CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
+		process_fd_request();
+		return i;
+
+	case FDTWADDLE:
+		LOCK_FDC(drive, 1);
+		twaddle();
+		process_fd_request();
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
 
 	if (_IOC_DIR(cmd) & _IOC_READ)
 		return fd_copyout((void __user *)param, outparam, size);
 	else
 		return 0;
-#undef OUT
-#undef IN
 }
 
 static void __init config_types(void)
@@ -3654,15 +4205,16 @@ static void __init config_types(void)
 		if (name) {
 			const char *prepend = ",";
 			if (first) {
-				prepend = KERN_INFO "Floppy drive(s):";
+				pr_info("Floppy drive(s):");
+				prepend = "";
 				first = 0;
 			}
-			printk("%s fd%d is %s", prepend, drive, name);
+			pr_cont("%s fd%d is %s", prepend, drive, name);
 		}
 		*UDP = *params;
 	}
 	if (!first)
-		printk("\n");
+		pr_cont("\n");
 }
 
 static int floppy_release(struct gendisk *disk, fmode_t mode)
@@ -3732,9 +4284,8 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 			INFBOUND(try, 16);
 			tmp = (char *)fd_dma_mem_alloc(1024 * try);
 		}
-		if (!tmp && !floppy_track_buffer) {
+		if (!tmp && !floppy_track_buffer)
 			fallback_on_nodma_alloc(&tmp, 2048 * try);
-		}
 		if (!tmp && !floppy_track_buffer) {
 			DPRINT("Unable to allocate DMA memory\n");
 			goto out;
@@ -3761,7 +4312,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		UFDCS->rawcmd = 2;
 
 	if (!(mode & FMODE_NDELAY)) {
-		if (mode & (FMODE_READ|FMODE_WRITE)) {
+		if (mode & (FMODE_READ | FMODE_WRITE)) {
 			UDRS->last_checked = 0;
 			check_disk_change(bdev);
 			if (UTESTF(FD_DISK_CHANGED))
@@ -3815,8 +4366,7 @@ static int check_floppy_change(struct gendisk *disk)
  * a disk in the drive, and whether that disk is writable.
  */
 
-static void floppy_rb0_complete(struct bio *bio,
-			       int err)
+static void floppy_rb0_complete(struct bio *bio, int err)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -3877,13 +4427,14 @@ static int floppy_revalidate(struct gendisk *disk)
 	if (UTESTF(FD_DISK_CHANGED) ||
 	    UTESTF(FD_VERIFY) || test_bit(drive, &fake_change) || NO_GEOM) {
 		if (usage_count == 0) {
-			printk("VFS: revalidate called on non-open device.\n");
+			pr_info("VFS: revalidate called on non-open device.\n");
 			return -EFAULT;
 		}
 		lock_fdc(drive, 0);
 		cf = UTESTF(FD_DISK_CHANGED) || UTESTF(FD_VERIFY);
 		if (!(cf || test_bit(drive, &fake_change) || NO_GEOM)) {
-			process_fd_request();	/*already done by another thread */
+			process_fd_request();
+					/*already done by another thread */
 			return 0;
 		}
 		UDRS->maxblock = 0;
@@ -3908,13 +4459,13 @@ static int floppy_revalidate(struct gendisk *disk)
 }
 
 static const struct block_device_operations floppy_fops = {
-	.owner			= THIS_MODULE,
-	.open			= floppy_open,
-	.release		= floppy_release,
-	.locked_ioctl		= fd_ioctl,
-	.getgeo			= fd_getgeo,
-	.media_changed		= check_floppy_change,
-	.revalidate_disk	= floppy_revalidate,
+	.owner = THIS_MODULE,
+	.open = floppy_open,
+	.release = floppy_release,
+	.locked_ioctl = fd_ioctl,
+	.getgeo = fd_getgeo,
+	.media_changed = check_floppy_change,
+	.revalidate_disk = floppy_revalidate,
 };
 
 /*
@@ -3931,21 +4482,21 @@ static char __init get_fdc_version(void)
 	output_byte(FD_DUMPREGS);	/* 82072 and better know DUMPREGS */
 	if (FDCS->reset)
 		return FDC_NONE;
-	if ((r = result()) <= 0x00)
+	r = result();
+	if (r <= 0x00)
 		return FDC_NONE;	/* No FDC present ??? */
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
-		printk(KERN_INFO "FDC %d is an 8272A\n", fdc);
+		pr_info("FDC %d is an 8272A\n", fdc);
 		return FDC_8272A;	/* 8272a/765 don't know DUMPREGS */
 	}
 	if (r != 10) {
-		printk
-		    ("FDC %d init: DUMPREGS: unexpected return of %d bytes.\n",
-		     fdc, r);
+		pr_info("FDC %d init: DUMPREGS: unexpected return of %d bytes.\n",
+			fdc, r);
 		return FDC_UNKNOWN;
 	}
 
 	if (!fdc_configure()) {
-		printk(KERN_INFO "FDC %d is an 82072\n", fdc);
+		pr_info("FDC %d is an 82072\n", fdc);
 		return FDC_82072;	/* 82072 doesn't know CONFIGURE */
 	}
 
@@ -3953,52 +4504,51 @@ static char __init get_fdc_version(void)
 	if (need_more_output() == MORE_OUTPUT) {
 		output_byte(0);
 	} else {
-		printk(KERN_INFO "FDC %d is an 82072A\n", fdc);
+		pr_info("FDC %d is an 82072A\n", fdc);
 		return FDC_82072A;	/* 82072A as found on Sparcs. */
 	}
 
 	output_byte(FD_UNLOCK);
 	r = result();
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
-		printk(KERN_INFO "FDC %d is a pre-1991 82077\n", fdc);
-		return FDC_82077_ORIG;	/* Pre-1991 82077, doesn't know 
-					 * LOCK/UNLOCK */
+		pr_info("FDC %d is a pre-1991 82077\n", fdc);
+		return FDC_82077_ORIG;	/* Pre-1991 82077,
+					   doesn't know LOCK/UNLOCK */
 	}
 	if ((r != 1) || (reply_buffer[0] != 0x00)) {
-		printk("FDC %d init: UNLOCK: unexpected return of %d bytes.\n",
-		       fdc, r);
+		pr_info("FDC %d init: UNLOCK: unexpected return of %d bytes.\n",
+			fdc, r);
 		return FDC_UNKNOWN;
 	}
 	output_byte(FD_PARTID);
 	r = result();
 	if (r != 1) {
-		printk("FDC %d init: PARTID: unexpected return of %d bytes.\n",
-		       fdc, r);
+		pr_info("FDC %d init: PARTID: unexpected return of %d bytes.\n",
+			fdc, r);
 		return FDC_UNKNOWN;
 	}
 	if (reply_buffer[0] == 0x80) {
-		printk(KERN_INFO "FDC %d is a post-1991 82077\n", fdc);
-		return FDC_82077;	/* Revised 82077AA passes all the tests */
+		pr_info("FDC %d is a post-1991 82077\n", fdc);
+		return FDC_82077;
+				/* Revised 82077AA passes all the tests */
 	}
 	switch (reply_buffer[0] >> 5) {
 	case 0x0:
 		/* Either a 82078-1 or a 82078SL running at 5Volt */
-		printk(KERN_INFO "FDC %d is an 82078.\n", fdc);
+		pr_info("FDC %d is an 82078.\n", fdc);
 		return FDC_82078;
 	case 0x1:
-		printk(KERN_INFO "FDC %d is a 44pin 82078\n", fdc);
+		pr_info("FDC %d is a 44pin 82078\n", fdc);
 		return FDC_82078;
 	case 0x2:
-		printk(KERN_INFO "FDC %d is a S82078B\n", fdc);
+		pr_info("FDC %d is a S82078B\n", fdc);
 		return FDC_S82078B;
 	case 0x3:
-		printk(KERN_INFO "FDC %d is a National Semiconductor PC87306\n",
-		       fdc);
+		pr_info("FDC %d is a National Semiconductor PC87306\n", fdc);
 		return FDC_87306;
 	default:
-		printk(KERN_INFO
-		       "FDC %d init: 82078 variant with unknown PARTID=%d.\n",
-		       fdc, reply_buffer[0] >> 5);
+		pr_info("FDC %d init: 82078 variant with unknown PARTID=%d.\n",
+			fdc, reply_buffer[0] >> 5);
 		return FDC_82078_UNKN;
 	}
 }				/* get_fdc_version */
@@ -4060,37 +4610,181 @@ static void __init set_cmos(int *ints, int dummy, int dummy2)
 
 static struct param_table {
 	const char *name;
-	void (*fn) (int *ints, int param, int param2);
+	void (*fn)(int *ints, int param, int param2);
 	int *var;
 	int def_param;
 	int param2;
 } config_params[] __initdata = {
-	{"allowed_drive_mask", NULL, &allowed_drive_mask, 0xff, 0}, /* obsolete */
-	{"all_drives", NULL, &allowed_drive_mask, 0xff, 0},	/* obsolete */
-	{"asus_pci", NULL, &allowed_drive_mask, 0x33, 0},
-	{"irq", NULL, &FLOPPY_IRQ, 6, 0},
-	{"dma", NULL, &FLOPPY_DMA, 2, 0},
-	{"daring", daring, NULL, 1, 0},
+	{
+		.name = "allowed_drive_mask",
+		.fn = NULL,
+		.var = &allowed_drive_mask,
+		.def_param = 0xff,
+		.param2 = 0,
+	},	/* obsolete */
+	{
+		.name = "all_drives",
+		.fn = NULL,
+		.var = &allowed_drive_mask,
+		.def_param = 0xff,
+		.param2 = 0,
+	},	/* obsolete */
+	{
+		.name = "asus_pci",
+		.fn = NULL,
+		.var = &allowed_drive_mask,
+		.def_param = 0x33,
+		.param2 = 0,
+	},
+	{
+		.name = "irq",
+		.fn = NULL,
+		.var = &FLOPPY_IRQ,
+		.def_param = 6,
+		.param2 = 0,
+	},
+	{
+		.name = "dma",
+		.fn = NULL,
+		.var = &FLOPPY_DMA,
+		.def_param = 2,
+		.param2 = 0,
+	},
+	{
+		.name = "daring",
+		.fn = daring,
+		.var = NULL,
+		.def_param = 1,
+		.param2 = 0,
+	},
 #if N_FDC > 1
-	{"two_fdc", NULL, &FDC2, 0x370, 0},
-	{"one_fdc", NULL, &FDC2, 0, 0},
+	{
+		.name = "two_fdc",
+		.fn = NULL,
+		.var = &FDC2,
+		.def_param = 0x370,
+		.param2 = 0,
+	},
+	{
+		.name = "one_fdc",
+		.fn = NULL,
+		.var = &FDC2,
+		.def_param = 0,
+		.param2 = 0,
+	},
 #endif
-	{"thinkpad", floppy_set_flags, NULL, 1, FD_INVERTED_DCL},
-	{"broken_dcl", floppy_set_flags, NULL, 1, FD_BROKEN_DCL},
-	{"messages", floppy_set_flags, NULL, 1, FTD_MSG},
-	{"silent_dcl_clear", floppy_set_flags, NULL, 1, FD_SILENT_DCL_CLEAR},
-	{"debug", floppy_set_flags, NULL, 1, FD_DEBUG},
-	{"nodma", NULL, &can_use_virtual_dma, 1, 0},
-	{"omnibook", NULL, &can_use_virtual_dma, 1, 0},
-	{"yesdma", NULL, &can_use_virtual_dma, 0, 0},
-	{"fifo_depth", NULL, &fifo_depth, 0xa, 0},
-	{"nofifo", NULL, &no_fifo, 0x20, 0},
-	{"usefifo", NULL, &no_fifo, 0, 0},
-	{"cmos", set_cmos, NULL, 0, 0},
-	{"slow", NULL, &slow_floppy, 1, 0},
-	{"unexpected_interrupts", NULL, &print_unex, 1, 0},
-	{"no_unexpected_interrupts", NULL, &print_unex, 0, 0},
-	{"L40SX", NULL, &print_unex, 0, 0}
+	{
+		.name = "thinkpad",
+		.fn = floppy_set_flags,
+		.var = NULL,
+		.def_param = 1,
+		.param2 = FD_INVERTED_DCL
+	},
+	{
+		.name = "broken_dcl",
+		.fn = floppy_set_flags,
+		.var = NULL,
+		.def_param = 1,
+		.param2 = FD_BROKEN_DCL
+	},
+	{
+		.name = "messages",
+		.fn = floppy_set_flags,
+		.var = NULL,
+		.def_param = 1,
+		.param2 = FTD_MSG
+	},
+	{
+		.name = "silent_dcl_clear",
+		.fn = floppy_set_flags,
+		.var = NULL,
+		.def_param = 1,
+		.param2 = FD_SILENT_DCL_CLEAR
+	},
+	{
+		.name = "debug",
+		.fn = floppy_set_flags,
+		.var = NULL,
+		.def_param = 1,
+		.param2 = FD_DEBUG
+	},
+	{
+		.name = "nodma",
+		.fn = NULL,
+		.var = &can_use_virtual_dma,
+		.def_param = 1,
+		.param2 = 0,
+	},
+	{
+		.name = "omnibook",
+		.fn = NULL,
+		.var = &can_use_virtual_dma,
+		.def_param = 1,
+		.param2 = 0,
+	},
+	{
+		.name = "yesdma",
+		.fn = NULL,
+		.var = &can_use_virtual_dma,
+		.def_param = 0,
+		.param2 = 0,
+	},
+	{
+		.name = "fifo_depth",
+		.fn = NULL,
+		.var = &fifo_depth,
+		.def_param = 0xa,
+		.param2 = 0,
+	},
+	{
+		.name = "nofifo",
+		.fn = NULL,
+		.var = &no_fifo,
+		.def_param = 0x20,
+		.param2 = 0,
+	},
+	{
+		.name = "usefifo",
+		.fn = NULL,
+		.var = &no_fifo,
+		.def_param = 0,
+		.param2 = 0,
+	},
+	{
+		.name = "cmos",
+		.fn = set_cmos,
+		.var = NULL,
+		.def_param = 0,
+		.param2 = 0,
+	},
+	{
+		.name = "slow",
+		.fn = NULL,
+		.var = &slow_floppy,
+		.def_param = 1,
+		.param2 = 0,
+	},
+	{
+		.name = "unexpected_interrupts",
+		.fn = NULL,
+		.var = &print_unex,
+		.def_param = 1,
+		.param2 = 0,
+	},
+	{
+		.name = "no_unexpected_interrupts",
+		.fn = NULL,
+		.var = &print_unex,
+		.def_param = 0,
+		.param2 = 0,
+	},
+	{
+		.name = "L40SX",
+		.fn = NULL,
+		.var = &print_unex,
+		.def_param = 0,
+		.param2 = 0,
+	}
 
 	EXTRA_FLOPPY_PARAMS
 };
@@ -4110,9 +4804,9 @@ static int __init floppy_setup(char *str)
 				else
 					param = config_params[i].def_param;
 				if (config_params[i].fn)
-					config_params[i].
-					    fn(ints, param,
-					       config_params[i].param2);
+					config_params[i].fn(ints, param,
+							    config_params[i].
+							    param2);
 				if (config_params[i].var) {
 					DPRINT("%s=%d\n", str, param);
 					*config_params[i].var = param;
@@ -4126,8 +4820,8 @@ static int __init floppy_setup(char *str)
 
 		DPRINT("allowed options are:");
 		for (i = 0; i < ARRAY_SIZE(config_params); i++)
-			printk(" %s", config_params[i].name);
-		printk("\n");
+			pr_cont(" %s", config_params[i].name);
+		pr_cont("\n");
 	} else
 		DPRINT("botched floppy option\n");
 	DPRINT("Read Documentation/blockdev/floppy.txt\n");
@@ -4145,7 +4839,8 @@ static ssize_t floppy_cmos_show(struct device *dev,
 	drive = p->id;
 	return sprintf(buf, "%X\n", UDP->cmos);
 }
-DEVICE_ATTR(cmos,S_IRUGO,floppy_cmos_show,NULL);
+
+DEVICE_ATTR(cmos, S_IRUGO, floppy_cmos_show, NULL);
 
 static void floppy_device_release(struct device *dev)
 {
@@ -4169,9 +4864,9 @@ static struct dev_pm_ops floppy_pm_ops = {
 
 static struct platform_driver floppy_driver = {
 	.driver = {
-		.name = "floppy",
-		.pm = &floppy_pm_ops,
-	},
+		   .name = "floppy",
+		   .pm = &floppy_pm_ops,
+		   },
 };
 
 static struct platform_device floppy_device[N_DRIVE];
@@ -4247,11 +4942,11 @@ static int __init floppy_init(void)
 
 	for (i = 0; i < N_FDC; i++) {
 		fdc = i;
-		CLEARSTRUCT(FDCS);
+		memset(FDCS, 0, sizeof(*FDCS));
 		FDCS->dtr = -1;
 		FDCS->dor = 0x4;
 #if defined(__sparc__) || defined(__mc68000__)
-		/*sparcs/sun3x don't have a DOR reset which we can fall back on to */
+	/*sparcs/sun3x don't have a DOR reset which we can fall back on to */
 #ifdef __mc68000__
 		if (MACH_IS_SUN3X)
 #endif
@@ -4280,8 +4975,8 @@ static int __init floppy_init(void)
 
 	/* initialise drive state */
 	for (drive = 0; drive < N_DRIVE; drive++) {
-		CLEARSTRUCT(UDRS);
-		CLEARSTRUCT(UDRWE);
+		memset(UDRS, 0, sizeof(*UDRS));
+		memset(UDRWE, 0, sizeof(*UDRWE));
 		USETF(FD_DISK_NEWCHANGE);
 		USETF(FD_DISK_CHANGED);
 		USETF(FD_VERIFY);
@@ -4353,7 +5048,9 @@ static int __init floppy_init(void)
 		if (err)
 			goto out_flush_work;
 
-		err = device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		err =
+		    device_create_file(&floppy_device[drive].dev,
+				       &dev_attr_cmos);
 		if (err)
 			goto out_unreg_platform_dev;
 
@@ -4394,12 +5091,12 @@ static const struct io_region {
 	int offset;
 	int size;
 } io_regions[] = {
-	{ 2, 1 },
-	/* address + 3 is sometimes reserved by pnp bios for motherboard */
-	{ 4, 2 },
-	/* address + 6 is reserved, and may be taken by IDE.
-	 * Unfortunately, Adaptec doesn't know this :-(, */
-	{ 7, 1 },
+	{ .offset = 2, .size = 1},
+	    /* address + 3 is sometimes reserved by pnp bios for motherboard */
+	{ .offset = 4, .size = 2},
+	    /* address + 6 is reserved, and may be taken by IDE.
+	     * Unfortunately, Adaptec doesn't know this :-(, */
+	{ .offset = 7, .size = 1},
 };
 
 static void floppy_release_allocated_regions(int fdc, const struct io_region *p)
@@ -4417,8 +5114,10 @@ static int floppy_request_regions(int fdc)
 	const struct io_region *p;
 
 	for (p = io_regions; p < ARRAY_END(io_regions); p++) {
-		if (!request_region(FDCS->address + p->offset, p->size, "floppy")) {
-			DPRINT("Floppy io-port 0x%04lx in use\n", FDCS->address + p->offset);
+		if (!request_region
+		    (FDCS->address + p->offset, p->size, "floppy")) {
+			DPRINT("Floppy io-port 0x%04lx in use\n",
+			       FDCS->address + p->offset);
 			floppy_release_allocated_regions(fdc, p);
 			return -EBUSY;
 		}
@@ -4548,15 +5247,15 @@ static void floppy_release_irq_and_dma(void)
 #ifndef __sparc__
 	for (drive = 0; drive < N_FDC * 4; drive++)
 		if (timer_pending(motor_off_timer + drive))
-			printk("motor off timer %d still active\n", drive);
+			pr_info("motor off timer %d still active\n", drive);
 #endif
 
 	if (timer_pending(&fd_timeout))
-		printk("floppy timer still active:%s\n", timeout_message);
+		pr_info("floppy timer still active:%s\n", timeout_message);
 	if (timer_pending(&fd_timer))
-		printk("auxiliary floppy timer still active\n");
+		pr_info("auxiliary floppy timer still active\n");
 	if (work_pending(&floppy_work))
-		printk("work still pending\n");
+		pr_info("work still pending\n");
 #endif
 	old_fdc = fdc;
 	for (fdc = 0; fdc < N_FDC; fdc++)
@@ -4574,7 +5273,9 @@ static void __init parse_floppy_cfg_string(char *cfg)
 	char *ptr;
 
 	while (*cfg) {
-		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++) ;
+		ptr = cfg;
+		while (*cfg && *cfg != ' ' && *cfg != '\t')
+			cfg++;
 		if (*cfg) {
 			*cfg = '\0';
 			cfg++;
@@ -4590,6 +5291,7 @@ static int __init floppy_module_init(void)
 		parse_floppy_cfg_string(floppy);
 	return floppy_init();
 }
+
 module_init(floppy_module_init);
 
 static void __exit floppy_module_exit(void)
@@ -4606,7 +5308,8 @@ static void __exit floppy_module_exit(void)
 		if ((allowed_drive_mask & (1 << drive)) &&
 		    fdc_state[FDC(drive)].version != FDC_NONE) {
 			del_gendisk(disks[drive]);
-			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
+			device_remove_file(&floppy_device[drive].dev,
+					   &dev_attr_cmos);
 			platform_device_unregister(&floppy_device[drive]);
 		}
 		put_disk(disks[drive]);
@@ -4622,6 +5325,7 @@ static void __exit floppy_module_exit(void)
 	/* eject disk, if any */
 	fd_eject(0);
 }
+
 module_exit(floppy_module_exit);
 
 module_param(floppy, charp, 0);
@@ -4633,9 +5337,10 @@ MODULE_LICENSE("GPL");
 
 /* This doesn't actually get used other than for module information */
 static const struct pnp_device_id floppy_pnpids[] = {
-	{ "PNP0700", 0 },
-	{ }
+	{"PNP0700", 0},
+	{}
 };
+
 MODULE_DEVICE_TABLE(pnp, floppy_pnpids);
 
 #else


