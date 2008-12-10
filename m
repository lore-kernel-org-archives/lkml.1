Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbYLJBL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbYLJBL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYLJBLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:11:20 -0500
Received: from mx01.qsc.de ([213.148.129.14]:38172 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbYLJBLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:11:19 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 20:11:18 EST
Date: Wed, 10 Dec 2008 02:02:19 +0100
From: Andreas Bombe <aeb@debian.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] amiflop: get rid of sleep_on calls
Message-ID: <20081210010219.GB5073@infernal.debian.net>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1228755578-26069-1-git-send-email-aeb@debian.org> <Pine.LNX.4.64.0812090927580.29640@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812090927580.29640@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from sleep_on() calls that could be easily converted to
wait_event() and completion calls amiflop also used a flag in ms_delay()
and ms_isr() as a custom mutex for ms_delay() without a need for
explicit unlocking.  I converted that to a standard mutex.

The replacement for the unconditional sleep_on() in fd_motor_on() is a
complete_all() together with a INIT_COMPLETION() before the mod_timer()
call.  It appears to me that fd_motor_on() might be called concurrently
and fd_select() does not guarantee mutual exclusivity in the case the
same drive gets selected again.

Signed-off-by: Andreas Bombe <aeb@debian.org>
---

This version changes the struct semaphore used as mutex into a struct
mutex.  Still only compile tested.

I just tried out my Amiga and it appears to be in better shape than
expected.  So I might get to actually test it when I find the time.  My
Amiga has no Linux installation so I need to whip up a ramdisk or
something else sufficient to test it.

 drivers/block/amiflop.c |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 4b1d4ac..8df436f 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -156,7 +156,7 @@ static volatile int fdc_busy = -1;
 static volatile int fdc_nested;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
  
-static DECLARE_WAIT_QUEUE_HEAD(motor_wait);
+static DECLARE_COMPLETION(motor_on_completion);
 
 static volatile int selected = -1;	/* currently selected drive */
 
@@ -184,8 +184,7 @@ static unsigned char mfmencode[16]={
 static unsigned char mfmdecode[128];
 
 /* floppy internal millisecond timer stuff */
-static volatile int ms_busy = -1;
-static DECLARE_WAIT_QUEUE_HEAD(ms_wait);
+static DECLARE_COMPLETION(ms_wait_completion);
 #define MS_TICKS ((amiga_eclock+50)/1000)
 
 /*
@@ -211,8 +210,7 @@ static int fd_device[4] = { 0, 0, 0, 0 };
 
 static irqreturn_t ms_isr(int irq, void *dummy)
 {
-	ms_busy = -1;
-	wake_up(&ms_wait);
+	complete(&ms_wait_completion);
 	return IRQ_HANDLED;
 }
 
@@ -220,19 +218,17 @@ static irqreturn_t ms_isr(int irq, void *dummy)
    A more generic routine would do a schedule a la timer.device */
 static void ms_delay(int ms)
 {
-	unsigned long flags;
 	int ticks;
+	static DEFINE_MUTEX(mutex);
+
 	if (ms > 0) {
-		local_irq_save(flags);
-		while (ms_busy == 0)
-			sleep_on(&ms_wait);
-		ms_busy = 0;
-		local_irq_restore(flags);
+		mutex_lock(&mutex);
 		ticks = MS_TICKS*ms-1;
 		ciaa.tblo=ticks%256;
 		ciaa.tbhi=ticks/256;
 		ciaa.crb=0x19; /*count eclock, force load, one-shoot, start */
-		sleep_on(&ms_wait);
+		wait_for_completion(&ms_wait_completion);
+		mutex_unlock(&mutex);
 	}
 }
 
@@ -254,8 +250,7 @@ static void get_fdc(int drive)
 	printk("get_fdc: drive %d  fdc_busy %d  fdc_nested %d\n",drive,fdc_busy,fdc_nested);
 #endif
 	local_irq_save(flags);
-	while (!try_fdc(drive))
-		sleep_on(&fdc_wait);
+	wait_event(fdc_wait, try_fdc(drive));
 	fdc_busy = drive;
 	fdc_nested++;
 	local_irq_restore(flags);
@@ -330,7 +325,7 @@ static void fd_deselect (int drive)
 static void motor_on_callback(unsigned long nr)
 {
 	if (!(ciaa.pra & DSKRDY) || --on_attempts == 0) {
-		wake_up (&motor_wait);
+		complete_all(&motor_on_completion);
 	} else {
 		motor_on_timer.expires = jiffies + HZ/10;
 		add_timer(&motor_on_timer);
@@ -347,11 +342,12 @@ static int fd_motor_on(int nr)
 		unit[nr].motor = 1;
 		fd_select(nr);
 
+		INIT_COMPLETION(motor_on_completion);
 		motor_on_timer.data = nr;
 		mod_timer(&motor_on_timer, jiffies + HZ/2);
 
 		on_attempts = 10;
-		sleep_on (&motor_wait);
+		wait_for_completion(&motor_on_completion);
 		fd_deselect(nr);
 	}
 
@@ -582,8 +578,7 @@ static void raw_read(int drive)
 {
 	drive&=3;
 	get_fdc(drive);
-	while (block_flag)
-		sleep_on(&wait_fd_block);
+	wait_event(wait_fd_block, !block_flag);
 	fd_select(drive);
 	/* setup adkcon bits correctly */
 	custom.adkcon = ADK_MSBSYNC;
@@ -598,8 +593,7 @@ static void raw_read(int drive)
 
 	block_flag = 1;
 
-	while (block_flag)
-		sleep_on (&wait_fd_block);
+	wait_event(wait_fd_block, !block_flag);
 
 	custom.dsklen = 0;
 	fd_deselect(drive);
@@ -616,8 +610,7 @@ static int raw_write(int drive)
 		rel_fdc();
 		return 0;
 	}
-	while (block_flag)
-		sleep_on(&wait_fd_block);
+	wait_event(wait_fd_block, !block_flag);
 	fd_select(drive);
 	/* clear adkcon bits */
 	custom.adkcon = ADK_PRECOMP1|ADK_PRECOMP0|ADK_WORDSYNC|ADK_MSBSYNC;
@@ -1294,8 +1287,7 @@ static int non_int_flush_track (unsigned long nr)
 			writepending = 0;
 			return 0;
 		}
-		while (block_flag == 2)
-			sleep_on (&wait_fd_block);
+		wait_event(wait_fd_block, block_flag != 2);
 	}
 	else {
 		local_irq_restore(flags);
-- 
1.5.6.5

