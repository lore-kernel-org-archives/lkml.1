Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968750Ab0B1RAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 12:00:44 -0500
Received: from www84.your-server.de ([213.133.104.84]:33433 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964812Ab0B1RAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 12:00:41 -0500
Subject: [Patch] fix MTD CFI/LPDDR flash driver huge latency bug
From: Stefani Seibold <stefani@seibold.net>
To: linux-mtd@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: "Kreuzer, Michael (NSN - DE/Ulm)" <michael.kreuzer@nsn.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 28 Feb 2010 18:00:51 +0100
Message-ID: <1267376451.17227.10.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a huge latency problem in the MTD CFI and LPDDR flash
drivers.

The use of a memcpy() during a spinlock operation will cause very long
thread context switch delays if the flash chip bandwidth is low and the
data to be copied large, because a spinlock will disable preemption.

For example: A flash with 6,5 MB/s bandwidth will cause under ubifs,
which request sometimes 128 KB (the flash erase size), a preemption
delay of 20 milliseconds. High priority threads will not be served
during this time, regardless whether this threads access the flash or
not. This behavior breaks real time.

The patch change all the use of spin_lock operations for xxxx->mutex
into mutex operations, which is exact what the name says and means. 

There is no performance regression since the mutex is normally not
acquired.

The patch is against kernel 2.6.33. Please merge it.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |  131 +++++++++++++++++-----------------
 drivers/mtd/chips/cfi_cmdset_0002.c |  127 +++++++++++++++++----------------
 drivers/mtd/chips/cfi_cmdset_0020.c |  136 ++++++++++++++++++------------------
 drivers/mtd/chips/gen_probe.c       |    3 
 drivers/mtd/lpddr/lpddr_cmds.c      |   79 ++++++++++----------
 include/linux/mtd/flashchip.h       |    4 -
 6 files changed, 240 insertions(+), 240 deletions(-)

diff -u -N -r -p linux-2.6.33.orig//drivers/mtd/chips/cfi_cmdset_0001.c linux-2.6.33/drivers/mtd/chips/cfi_cmdset_0001.c
--- linux-2.6.33.orig//drivers/mtd/chips/cfi_cmdset_0001.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/mtd/chips/cfi_cmdset_0001.c	2010-02-28 11:19:49.845138972 +0100
@@ -727,8 +727,7 @@ static int cfi_intelext_partition_fixup(
 				/* those should be reset too since
 				   they create memory references. */
 				init_waitqueue_head(&chip->wq);
-				spin_lock_init(&chip->_spinlock);
-				chip->mutex = &chip->_spinlock;
+				mutex_init(&chip->mutex);
 				chip++;
 			}
 		}
@@ -774,9 +773,9 @@ static int chip_ready (struct map_info *
 			if (chip->priv && map_word_andequal(map, status, status_PWS, status_PWS))
 				break;
 
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			cfi_udelay(1);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			/* Someone else might have been playing with it. */
 			return -EAGAIN;
 		}
@@ -823,9 +822,9 @@ static int chip_ready (struct map_info *
 				return -EIO;
 			}
 
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			cfi_udelay(1);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			/* Nobody will touch it while it's in state FL_ERASE_SUSPENDING.
 			   So we can just loop here. */
 		}
@@ -852,10 +851,10 @@ static int chip_ready (struct map_info *
 	sleep:
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 		return -EAGAIN;
 	}
 }
@@ -901,20 +900,20 @@ static int get_chip(struct map_info *map
 			 * it'll happily send us to sleep.  In any case, when
 			 * get_chip returns success we're clear to go ahead.
 			 */
-			ret = spin_trylock(contender->mutex);
+			ret = mutex_trylock(contender->mutex);
 			spin_unlock(&shared->lock);
 			if (!ret)
 				goto retry;
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			ret = chip_ready(map, contender, contender->start, mode);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 
 			if (ret == -EAGAIN) {
-				spin_unlock(contender->mutex);
+				mutex_unlock(contender->mutex);
 				goto retry;
 			}
 			if (ret) {
-				spin_unlock(contender->mutex);
+				mutex_unlock(contender->mutex);
 				return ret;
 			}
 			spin_lock(&shared->lock);
@@ -923,10 +922,10 @@ static int get_chip(struct map_info *map
 			 * in FL_SYNCING state. Put contender and retry. */
 			if (chip->state == FL_SYNCING) {
 				put_chip(map, contender, contender->start);
-				spin_unlock(contender->mutex);
+				mutex_unlock(contender->mutex);
 				goto retry;
 			}
-			spin_unlock(contender->mutex);
+			mutex_unlock(contender->mutex);
 		}
 
 		/* Check if we already have suspended erase
@@ -936,10 +935,10 @@ static int get_chip(struct map_info *map
 			spin_unlock(&shared->lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			goto retry;
 		}
 
@@ -969,12 +968,12 @@ static void put_chip(struct map_info *ma
 			if (shared->writing && shared->writing != chip) {
 				/* give back ownership to who we loaned it from */
 				struct flchip *loaner = shared->writing;
-				spin_lock(loaner->mutex);
+				mutex_lock(loaner->mutex);
 				spin_unlock(&shared->lock);
-				spin_unlock(chip->mutex);
+				mutex_unlock(chip->mutex);
 				put_chip(map, loaner, loaner->start);
-				spin_lock(chip->mutex);
-				spin_unlock(loaner->mutex);
+				mutex_lock(chip->mutex);
+				mutex_unlock(loaner->mutex);
 				wake_up(&chip->wq);
 				return;
 			}
@@ -1144,7 +1143,7 @@ static int __xipram xip_wait_for_operati
 			(void) map_read(map, adr);
 			xip_iprefetch();
 			local_irq_enable();
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			xip_iprefetch();
 			cond_resched();
 
@@ -1154,15 +1153,15 @@ static int __xipram xip_wait_for_operati
 			 * a suspended erase state.  If so let's wait
 			 * until it's done.
 			 */
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			while (chip->state != newstate) {
 				DECLARE_WAITQUEUE(wait, current);
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				add_wait_queue(&chip->wq, &wait);
-				spin_unlock(chip->mutex);
+				mutex_unlock(chip->mutex);
 				schedule();
 				remove_wait_queue(&chip->wq, &wait);
-				spin_lock(chip->mutex);
+				mutex_lock(chip->mutex);
 			}
 			/* Disallow XIP again */
 			local_irq_disable();
@@ -1218,10 +1217,10 @@ static int inval_cache_and_wait_for_oper
 	int chip_state = chip->state;
 	unsigned int timeo, sleep_time, reset_timeo;
 
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	if (inval_len)
 		INVALIDATE_CACHED_RANGE(map, inval_adr, inval_len);
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	timeo = chip_op_time_max;
 	if (!timeo)
@@ -1241,7 +1240,7 @@ static int inval_cache_and_wait_for_oper
 		}
 
 		/* OK Still waiting. Drop the lock, wait a while and retry. */
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		if (sleep_time >= 1000000/HZ) {
 			/*
 			 * Half of the normal delay still remaining
@@ -1256,17 +1255,17 @@ static int inval_cache_and_wait_for_oper
 			cond_resched();
 			timeo--;
 		}
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		while (chip->state != chip_state) {
 			/* Someone's suspended the operation: sleep */
 			DECLARE_WAITQUEUE(wait, current);
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 		}
 		if (chip->erase_suspended && chip_state == FL_ERASING)  {
 			/* Erase suspend occured while sleep: reset timeout */
@@ -1302,7 +1301,7 @@ static int do_point_onechip (struct map_
 	/* Ensure cmd read/writes are aligned. */
 	cmd_addr = adr & ~(map_bankwidth(map)-1);
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	ret = get_chip(map, chip, cmd_addr, FL_POINT);
 
@@ -1313,7 +1312,7 @@ static int do_point_onechip (struct map_
 		chip->state = FL_POINT;
 		chip->ref_point_counter++;
 	}
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 
 	return ret;
 }
@@ -1398,7 +1397,7 @@ static void cfi_intelext_unpoint(struct
 		else
 			thislen = len;
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 		if (chip->state == FL_POINT) {
 			chip->ref_point_counter--;
 			if(chip->ref_point_counter == 0)
@@ -1407,7 +1406,7 @@ static void cfi_intelext_unpoint(struct
 			printk(KERN_ERR "%s: Warning: unpoint called on non pointed region\n", map->name); /* Should this give an error? */
 
 		put_chip(map, chip, chip->start);
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 
 		len -= thislen;
 		ofs = 0;
@@ -1426,10 +1425,10 @@ static inline int do_read_onechip(struct
 	/* Ensure cmd read/writes are aligned. */
 	cmd_addr = adr & ~(map_bankwidth(map)-1);
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, cmd_addr, FL_READY);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -1443,7 +1442,7 @@ static inline int do_read_onechip(struct
 
 	put_chip(map, chip, cmd_addr);
 
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return 0;
 }
 
@@ -1506,10 +1505,10 @@ static int __xipram do_write_oneword(str
 		return -EINVAL;
 	}
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr, mode);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -1555,7 +1554,7 @@ static int __xipram do_write_oneword(str
 
 	xip_enable(map, chip, adr);
  out:	put_chip(map, chip, adr);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -1664,10 +1663,10 @@ static int __xipram do_write_buffer(stru
 	/* Let's determine this according to the interleave only once */
 	write_cmd = (cfi->cfiq->P_ID != 0x0200) ? CMD(0xe8) : CMD(0xe9);
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, cmd_adr, FL_WRITING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -1798,7 +1797,7 @@ static int __xipram do_write_buffer(stru
 
 	xip_enable(map, chip, cmd_adr);
  out:	put_chip(map, chip, cmd_adr);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -1877,10 +1876,10 @@ static int __xipram do_erase_oneblock(st
 	adr += chip->start;
 
  retry:
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr, FL_ERASING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -1936,7 +1935,7 @@ static int __xipram do_erase_oneblock(st
 		} else if (chipstatus & 0x20 && retries--) {
 			printk(KERN_DEBUG "block erase failed at 0x%08lx: status 0x%lx. Retrying...\n", adr, chipstatus);
 			put_chip(map, chip, adr);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			goto retry;
 		} else {
 			printk(KERN_ERR "%s: block erase failed at 0x%08lx (status 0x%lx)\n", map->name, adr, chipstatus);
@@ -1948,7 +1947,7 @@ static int __xipram do_erase_oneblock(st
 
 	xip_enable(map, chip, adr);
  out:	put_chip(map, chip, adr);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -1981,7 +1980,7 @@ static void cfi_intelext_sync (struct mt
 	for (i=0; !ret && i<cfi->numchips; i++) {
 		chip = &cfi->chips[i];
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 		ret = get_chip(map, chip, chip->start, FL_SYNCING);
 
 		if (!ret) {
@@ -1992,7 +1991,7 @@ static void cfi_intelext_sync (struct mt
 			 * with the chip now anyway.
 			 */
 		}
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 
 	/* Unlock the chips again */
@@ -2000,14 +1999,14 @@ static void cfi_intelext_sync (struct mt
 	for (i--; i >=0; i--) {
 		chip = &cfi->chips[i];
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		if (chip->state == FL_SYNCING) {
 			chip->state = chip->oldstate;
 			chip->oldstate = FL_READY;
 			wake_up(&chip->wq);
 		}
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 }
 
@@ -2053,10 +2052,10 @@ static int __xipram do_xxlock_oneblock(s
 
 	adr += chip->start;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr, FL_LOCKING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -2090,7 +2089,7 @@ static int __xipram do_xxlock_oneblock(s
 
 	xip_enable(map, chip, adr);
 out:	put_chip(map, chip, adr);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -2155,10 +2154,10 @@ do_otp_read(struct map_info *map, struct
 	struct cfi_private *cfi = map->fldrv_priv;
 	int ret;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, chip->start, FL_JEDEC_QUERY);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -2177,7 +2176,7 @@ do_otp_read(struct map_info *map, struct
 	INVALIDATE_CACHED_RANGE(map, chip->start + offset, size);
 
 	put_chip(map, chip, chip->start);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return 0;
 }
 
@@ -2452,7 +2451,7 @@ static int cfi_intelext_suspend(struct m
 	for (i=0; !ret && i<cfi->numchips; i++) {
 		chip = &cfi->chips[i];
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		switch (chip->state) {
 		case FL_READY:
@@ -2484,7 +2483,7 @@ static int cfi_intelext_suspend(struct m
 		case FL_PM_SUSPENDED:
 			break;
 		}
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 
 	/* Unlock the chips again */
@@ -2493,7 +2492,7 @@ static int cfi_intelext_suspend(struct m
 		for (i--; i >=0; i--) {
 			chip = &cfi->chips[i];
 
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 
 			if (chip->state == FL_PM_SUSPENDED) {
 				/* No need to force it into a known state here,
@@ -2503,7 +2502,7 @@ static int cfi_intelext_suspend(struct m
 				chip->oldstate = FL_READY;
 				wake_up(&chip->wq);
 			}
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 		}
 	}
 
@@ -2544,7 +2543,7 @@ static void cfi_intelext_resume(struct m
 
 		chip = &cfi->chips[i];
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		/* Go to known state. Chip may have been power cycled */
 		if (chip->state == FL_PM_SUSPENDED) {
@@ -2553,7 +2552,7 @@ static void cfi_intelext_resume(struct m
 			wake_up(&chip->wq);
 		}
 
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 
 	if ((mtd->flags & MTD_POWERUP_LOCK)
@@ -2573,14 +2572,14 @@ static int cfi_intelext_reset(struct mtd
 		/* force the completion of any ongoing operation
 		   and switch to array mode so any bootloader in
 		   flash is accessible for soft reboot. */
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 		ret = get_chip(map, chip, chip->start, FL_SHUTDOWN);
 		if (!ret) {
 			map_write(map, CMD(0xff), chip->start);
 			chip->state = FL_SHUTDOWN;
 			put_chip(map, chip, chip->start);
 		}
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 
 	return 0;
diff -u -N -r -p linux-2.6.33.orig//drivers/mtd/chips/cfi_cmdset_0002.c linux-2.6.33/drivers/mtd/chips/cfi_cmdset_0002.c
--- linux-2.6.33.orig//drivers/mtd/chips/cfi_cmdset_0002.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/mtd/chips/cfi_cmdset_0002.c	2010-02-28 11:20:32.618545872 +0100
@@ -20,6 +20,7 @@
  * This code is GPL
  */
 
+#include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -571,9 +572,9 @@ static int get_chip(struct map_info *map
 				printk(KERN_ERR "Waiting for chip to be ready timed out.\n");
 				return -EIO;
 			}
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			cfi_udelay(1);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			/* Someone else might have been playing with it. */
 			goto retry;
 		}
@@ -617,9 +618,9 @@ static int get_chip(struct map_info *map
 				return -EIO;
 			}
 
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			cfi_udelay(1);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			/* Nobody will touch it while it's in state FL_ERASE_SUSPENDING.
 			   So we can just loop here. */
 		}
@@ -643,10 +644,10 @@ static int get_chip(struct map_info *map
 	sleep:
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 		goto resettime;
 	}
 }
@@ -778,7 +779,7 @@ static void __xipram xip_udelay(struct m
 			(void) map_read(map, adr);
 			xip_iprefetch();
 			local_irq_enable();
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			xip_iprefetch();
 			cond_resched();
 
@@ -788,15 +789,15 @@ static void __xipram xip_udelay(struct m
 			 * a suspended erase state.  If so let's wait
 			 * until it's done.
 			 */
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			while (chip->state != FL_XIP_WHILE_ERASING) {
 				DECLARE_WAITQUEUE(wait, current);
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				add_wait_queue(&chip->wq, &wait);
-				spin_unlock(chip->mutex);
+				mutex_unlock(chip->mutex);
 				schedule();
 				remove_wait_queue(&chip->wq, &wait);
-				spin_lock(chip->mutex);
+				mutex_lock(chip->mutex);
 			}
 			/* Disallow XIP again */
 			local_irq_disable();
@@ -858,21 +859,24 @@ static void __xipram xip_udelay(struct m
 
 #define UDELAY(map, chip, adr, usec)  \
 do {  \
-	spin_unlock(chip->mutex);  \
+	mutex_unlock(chip->mutex);  \
 	cfi_udelay(usec);  \
-	spin_lock(chip->mutex);  \
+	mutex_lock(chip->mutex);  \
 } while (0)
 
 #define INVALIDATE_CACHE_UDELAY(map, chip, adr, len, usec)  \
 do {  \
-	spin_unlock(chip->mutex);  \
+	mutex_unlock(chip->mutex);  \
 	INVALIDATE_CACHED_RANGE(map, adr, len);  \
 	cfi_udelay(usec);  \
-	spin_lock(chip->mutex);  \
+	mutex_lock(chip->mutex);  \
 } while (0)
 
 #endif
 
+#include <asm/div64.h>
+#include <asm/time.h>
+
 static inline int do_read_onechip(struct map_info *map, struct flchip *chip, loff_t adr, size_t len, u_char *buf)
 {
 	unsigned long cmd_addr;
@@ -884,10 +888,10 @@ static inline int do_read_onechip(struct
 	/* Ensure cmd read/writes are aligned. */
 	cmd_addr = adr & ~(map_bankwidth(map)-1);
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, cmd_addr, FL_READY);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -900,11 +904,10 @@ static inline int do_read_onechip(struct
 
 	put_chip(map, chip, cmd_addr);
 
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return 0;
 }
 
-
 static int cfi_amdstd_read (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf)
 {
 	struct map_info *map = mtd->priv;
@@ -954,7 +957,7 @@ static inline int do_read_secsi_onechip(
 	struct cfi_private *cfi = map->fldrv_priv;
 
  retry:
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	if (chip->state != FL_READY){
 #if 0
@@ -963,7 +966,7 @@ static inline int do_read_secsi_onechip(
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
 
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
@@ -992,7 +995,7 @@ static inline int do_read_secsi_onechip(
 	cfi_send_gen_cmd(0x00, cfi->addr_unlock1, chip->start, map, cfi, cfi->device_type, NULL);
 
 	wake_up(&chip->wq);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 
 	return 0;
 }
@@ -1061,10 +1064,10 @@ static int __xipram do_write_oneword(str
 
 	adr += chip->start;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr, FL_WRITING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -1107,11 +1110,11 @@ static int __xipram do_write_oneword(str
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
 			timeo = jiffies + (HZ / 2); /* FIXME */
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			continue;
 		}
 
@@ -1143,7 +1146,7 @@ static int __xipram do_write_oneword(str
  op_done:
 	chip->state = FL_READY;
 	put_chip(map, chip, adr);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 
 	return ret;
 }
@@ -1175,7 +1178,7 @@ static int cfi_amdstd_write_words(struct
 		map_word tmp_buf;
 
  retry:
-		spin_lock(cfi->chips[chipnum].mutex);
+		mutex_lock(cfi->chips[chipnum].mutex);
 
 		if (cfi->chips[chipnum].state != FL_READY) {
 #if 0
@@ -1184,7 +1187,7 @@ static int cfi_amdstd_write_words(struct
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&cfi->chips[chipnum].wq, &wait);
 
-			spin_unlock(cfi->chips[chipnum].mutex);
+			mutex_unlock(cfi->chips[chipnum].mutex);
 
 			schedule();
 			remove_wait_queue(&cfi->chips[chipnum].wq, &wait);
@@ -1198,7 +1201,7 @@ static int cfi_amdstd_write_words(struct
 		/* Load 'tmp_buf' with old contents of flash */
 		tmp_buf = map_read(map, bus_ofs+chipstart);
 
-		spin_unlock(cfi->chips[chipnum].mutex);
+		mutex_unlock(cfi->chips[chipnum].mutex);
 
 		/* Number of bytes to copy from buffer */
 		n = min_t(int, len, map_bankwidth(map)-i);
@@ -1253,7 +1256,7 @@ static int cfi_amdstd_write_words(struct
 		map_word tmp_buf;
 
  retry1:
-		spin_lock(cfi->chips[chipnum].mutex);
+		mutex_lock(cfi->chips[chipnum].mutex);
 
 		if (cfi->chips[chipnum].state != FL_READY) {
 #if 0
@@ -1262,7 +1265,7 @@ static int cfi_amdstd_write_words(struct
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&cfi->chips[chipnum].wq, &wait);
 
-			spin_unlock(cfi->chips[chipnum].mutex);
+			mutex_unlock(cfi->chips[chipnum].mutex);
 
 			schedule();
 			remove_wait_queue(&cfi->chips[chipnum].wq, &wait);
@@ -1275,7 +1278,7 @@ static int cfi_amdstd_write_words(struct
 
 		tmp_buf = map_read(map, ofs + chipstart);
 
-		spin_unlock(cfi->chips[chipnum].mutex);
+		mutex_unlock(cfi->chips[chipnum].mutex);
 
 		tmp_buf = map_word_load_partial(map, tmp_buf, buf, 0, len);
 
@@ -1310,10 +1313,10 @@ static int __xipram do_write_buffer(stru
 	adr += chip->start;
 	cmd_adr = adr;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr, FL_WRITING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -1368,11 +1371,11 @@ static int __xipram do_write_buffer(stru
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
 			timeo = jiffies + (HZ / 2); /* FIXME */
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			continue;
 		}
 
@@ -1400,7 +1403,7 @@ static int __xipram do_write_buffer(stru
  op_done:
 	chip->state = FL_READY;
 	put_chip(map, chip, adr);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 
 	return ret;
 }
@@ -1500,10 +1503,10 @@ static int __xipram do_erase_chip(struct
 
 	adr = cfi->addr_unlock1;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr, FL_WRITING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -1536,10 +1539,10 @@ static int __xipram do_erase_chip(struct
 			/* Someone's suspended the erase. Sleep */
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			continue;
 		}
 		if (chip->erase_suspended) {
@@ -1573,7 +1576,7 @@ static int __xipram do_erase_chip(struct
 	chip->state = FL_READY;
 	xip_enable(map, chip, adr);
 	put_chip(map, chip, adr);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 
 	return ret;
 }
@@ -1588,10 +1591,10 @@ static int __xipram do_erase_oneblock(st
 
 	adr += chip->start;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr, FL_ERASING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -1624,10 +1627,10 @@ static int __xipram do_erase_oneblock(st
 			/* Someone's suspended the erase. Sleep */
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			continue;
 		}
 		if (chip->erase_suspended) {
@@ -1663,7 +1666,7 @@ static int __xipram do_erase_oneblock(st
 
 	chip->state = FL_READY;
 	put_chip(map, chip, adr);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -1715,7 +1718,7 @@ static int do_atmel_lock(struct map_info
 	struct cfi_private *cfi = map->fldrv_priv;
 	int ret;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr + chip->start, FL_LOCKING);
 	if (ret)
 		goto out_unlock;
@@ -1741,7 +1744,7 @@ static int do_atmel_lock(struct map_info
 	ret = 0;
 
 out_unlock:
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -1751,7 +1754,7 @@ static int do_atmel_unlock(struct map_in
 	struct cfi_private *cfi = map->fldrv_priv;
 	int ret;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, adr + chip->start, FL_UNLOCKING);
 	if (ret)
 		goto out_unlock;
@@ -1769,7 +1772,7 @@ static int do_atmel_unlock(struct map_in
 	ret = 0;
 
 out_unlock:
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -1797,7 +1800,7 @@ static void cfi_amdstd_sync (struct mtd_
 		chip = &cfi->chips[i];
 
 	retry:
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		switch(chip->state) {
 		case FL_READY:
@@ -1811,7 +1814,7 @@ static void cfi_amdstd_sync (struct mtd_
 			 * with the chip now anyway.
 			 */
 		case FL_SYNCING:
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			break;
 
 		default:
@@ -1819,7 +1822,7 @@ static void cfi_amdstd_sync (struct mtd_
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 
 			schedule();
 
@@ -1834,13 +1837,13 @@ static void cfi_amdstd_sync (struct mtd_
 	for (i--; i >=0; i--) {
 		chip = &cfi->chips[i];
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		if (chip->state == FL_SYNCING) {
 			chip->state = chip->oldstate;
 			wake_up(&chip->wq);
 		}
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 }
 
@@ -1856,7 +1859,7 @@ static int cfi_amdstd_suspend(struct mtd
 	for (i=0; !ret && i<cfi->numchips; i++) {
 		chip = &cfi->chips[i];
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		switch(chip->state) {
 		case FL_READY:
@@ -1876,7 +1879,7 @@ static int cfi_amdstd_suspend(struct mtd
 			ret = -EAGAIN;
 			break;
 		}
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 
 	/* Unlock the chips again */
@@ -1885,13 +1888,13 @@ static int cfi_amdstd_suspend(struct mtd
 		for (i--; i >=0; i--) {
 			chip = &cfi->chips[i];
 
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 
 			if (chip->state == FL_PM_SUSPENDED) {
 				chip->state = chip->oldstate;
 				wake_up(&chip->wq);
 			}
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 		}
 	}
 
@@ -1910,7 +1913,7 @@ static void cfi_amdstd_resume(struct mtd
 
 		chip = &cfi->chips[i];
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		if (chip->state == FL_PM_SUSPENDED) {
 			chip->state = FL_READY;
@@ -1920,7 +1923,7 @@ static void cfi_amdstd_resume(struct mtd
 		else
 			printk(KERN_ERR "Argh. Chip not in PM_SUSPENDED state upon resume()\n");
 
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 }
 
diff -u -N -r -p linux-2.6.33.orig//drivers/mtd/chips/cfi_cmdset_0020.c linux-2.6.33/drivers/mtd/chips/cfi_cmdset_0020.c
--- linux-2.6.33.orig//drivers/mtd/chips/cfi_cmdset_0020.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/mtd/chips/cfi_cmdset_0020.c	2010-02-28 11:18:10.268139668 +0100
@@ -265,7 +265,7 @@ static inline int do_read_onechip(struct
 
 	timeo = jiffies + HZ;
  retry:
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	/* Check that the chip's ready to talk to us.
 	 * If it's in FL_ERASING state, suspend it and make it talk now.
@@ -296,15 +296,15 @@ static inline int do_read_onechip(struct
 				/* make sure we're in 'read status' mode */
 				map_write(map, CMD(0x70), cmd_addr);
 				chip->state = FL_ERASING;
-				spin_unlock_bh(chip->mutex);
+				mutex_unlock(chip->mutex);
 				printk(KERN_ERR "Chip not ready after erase "
 				       "suspended: status = 0x%lx\n", status.x[0]);
 				return -EIO;
 			}
 
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			cfi_udelay(1);
-			spin_lock_bh(chip->mutex);
+			mutex_lock(chip->mutex);
 		}
 
 		suspended = 1;
@@ -335,13 +335,13 @@ static inline int do_read_onechip(struct
 
 		/* Urgh. Chip not yet ready to talk to us. */
 		if (time_after(jiffies, timeo)) {
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			printk(KERN_ERR "waiting for chip to be ready timed out in read. WSM status = %lx\n", status.x[0]);
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
 		goto retry;
 
@@ -351,7 +351,7 @@ static inline int do_read_onechip(struct
 		   someone changes the status */
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
 		timeo = jiffies + HZ;
@@ -376,7 +376,7 @@ static inline int do_read_onechip(struct
 	}
 
 	wake_up(&chip->wq);
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return 0;
 }
 
@@ -445,7 +445,7 @@ static inline int do_write_buffer(struct
 #ifdef DEBUG_CFI_FEATURES
        printk("%s: chip->state[%d]\n", __func__, chip->state);
 #endif
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	/* Check that the chip's ready to talk to us.
 	 * Later, we can actually think about interrupting it
@@ -470,14 +470,14 @@ static inline int do_write_buffer(struct
 			break;
 		/* Urgh. Chip not yet ready to talk to us. */
 		if (time_after(jiffies, timeo)) {
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
                         printk(KERN_ERR "waiting for chip to be ready timed out in buffer write Xstatus = %lx, status = %lx\n",
                                status.x[0], map_read(map, cmd_adr).x[0]);
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
 		goto retry;
 
@@ -486,7 +486,7 @@ static inline int do_write_buffer(struct
 		   someone changes the status */
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
 		timeo = jiffies + HZ;
@@ -503,16 +503,16 @@ static inline int do_write_buffer(struct
 		if (map_word_andequal(map, status, status_OK, status_OK))
 			break;
 
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		if (++z > 100) {
 			/* Argh. Not ready for write to buffer */
 			DISABLE_VPP(map);
                         map_write(map, CMD(0x70), cmd_adr);
 			chip->state = FL_STATUS;
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			printk(KERN_ERR "Chip not ready for buffer write. Xstatus = %lx\n", status.x[0]);
 			return -EIO;
 		}
@@ -532,9 +532,9 @@ static inline int do_write_buffer(struct
 	map_write(map, CMD(0xd0), cmd_adr);
 	chip->state = FL_WRITING;
 
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 	cfi_udelay(chip->buffer_write_time);
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	timeo = jiffies + (HZ/2);
 	z = 0;
@@ -543,11 +543,11 @@ static inline int do_write_buffer(struct
 			/* Someone's suspended the write. Sleep */
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
 			timeo = jiffies + (HZ / 2); /* FIXME */
-			spin_lock_bh(chip->mutex);
+			mutex_lock(chip->mutex);
 			continue;
 		}
 
@@ -563,16 +563,16 @@ static inline int do_write_buffer(struct
                         map_write(map, CMD(0x70), adr);
 			chip->state = FL_STATUS;
 			DISABLE_VPP(map);
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			printk(KERN_ERR "waiting for chip to be ready timed out in bufwrite\n");
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
 		z++;
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 	}
 	if (!z) {
 		chip->buffer_write_time--;
@@ -596,11 +596,11 @@ static inline int do_write_buffer(struct
 		/* put back into read status register mode */
 		map_write(map, CMD(0x70), adr);
 		wake_up(&chip->wq);
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return map_word_bitsset(map, status, CMD(0x02)) ? -EROFS : -EIO;
 	}
 	wake_up(&chip->wq);
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 
         return 0;
 }
@@ -749,7 +749,7 @@ static inline int do_erase_oneblock(stru
 
 	timeo = jiffies + HZ;
 retry:
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	/* Check that the chip's ready to talk to us. */
 	switch (chip->state) {
@@ -766,13 +766,13 @@ retry:
 
 		/* Urgh. Chip not yet ready to talk to us. */
 		if (time_after(jiffies, timeo)) {
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			printk(KERN_ERR "waiting for chip to be ready timed out in erase\n");
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
 		goto retry;
 
@@ -781,7 +781,7 @@ retry:
 		   someone changes the status */
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
 		timeo = jiffies + HZ;
@@ -797,9 +797,9 @@ retry:
 	map_write(map, CMD(0xD0), adr);
 	chip->state = FL_ERASING;
 
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 	msleep(1000);
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	/* FIXME. Use a timer to check this, and return immediately. */
 	/* Once the state machine's known to be working I'll do that */
@@ -810,11 +810,11 @@ retry:
 			/* Someone's suspended the erase. Sleep */
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
 			timeo = jiffies + (HZ*20); /* FIXME */
-			spin_lock_bh(chip->mutex);
+			mutex_lock(chip->mutex);
 			continue;
 		}
 
@@ -828,14 +828,14 @@ retry:
 			chip->state = FL_STATUS;
 			printk(KERN_ERR "waiting for erase to complete timed out. Xstatus = %lx, status = %lx.\n", status.x[0], map_read(map, adr).x[0]);
 			DISABLE_VPP(map);
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 	}
 
 	DISABLE_VPP(map);
@@ -878,7 +878,7 @@ retry:
 				printk(KERN_DEBUG "Chip erase failed at 0x%08lx: status 0x%x. Retrying...\n", adr, chipstatus);
 				timeo = jiffies + HZ;
 				chip->state = FL_STATUS;
-				spin_unlock_bh(chip->mutex);
+				mutex_unlock(chip->mutex);
 				goto retry;
 			}
 			printk(KERN_DEBUG "Chip erase failed at 0x%08lx: status 0x%x\n", adr, chipstatus);
@@ -887,7 +887,7 @@ retry:
 	}
 
 	wake_up(&chip->wq);
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -995,7 +995,7 @@ static void cfi_staa_sync (struct mtd_in
 		chip = &cfi->chips[i];
 
 	retry:
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		switch(chip->state) {
 		case FL_READY:
@@ -1009,7 +1009,7 @@ static void cfi_staa_sync (struct mtd_in
 			 * with the chip now anyway.
 			 */
 		case FL_SYNCING:
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			break;
 
 		default:
@@ -1017,7 +1017,7 @@ static void cfi_staa_sync (struct mtd_in
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
 
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 		        remove_wait_queue(&chip->wq, &wait);
 
@@ -1030,13 +1030,13 @@ static void cfi_staa_sync (struct mtd_in
 	for (i--; i >=0; i--) {
 		chip = &cfi->chips[i];
 
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		if (chip->state == FL_SYNCING) {
 			chip->state = chip->oldstate;
 			wake_up(&chip->wq);
 		}
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 }
 
@@ -1054,7 +1054,7 @@ static inline int do_lock_oneblock(struc
 
 	timeo = jiffies + HZ;
 retry:
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	/* Check that the chip's ready to talk to us. */
 	switch (chip->state) {
@@ -1071,13 +1071,13 @@ retry:
 
 		/* Urgh. Chip not yet ready to talk to us. */
 		if (time_after(jiffies, timeo)) {
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			printk(KERN_ERR "waiting for chip to be ready timed out in lock\n");
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
 		goto retry;
 
@@ -1086,7 +1086,7 @@ retry:
 		   someone changes the status */
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
 		timeo = jiffies + HZ;
@@ -1098,9 +1098,9 @@ retry:
 	map_write(map, CMD(0x01), adr);
 	chip->state = FL_LOCKING;
 
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 	msleep(1000);
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	/* FIXME. Use a timer to check this, and return immediately. */
 	/* Once the state machine's known to be working I'll do that */
@@ -1118,21 +1118,21 @@ retry:
 			chip->state = FL_STATUS;
 			printk(KERN_ERR "waiting for lock to complete timed out. Xstatus = %lx, status = %lx.\n", status.x[0], map_read(map, adr).x[0]);
 			DISABLE_VPP(map);
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 	}
 
 	/* Done and happy. */
 	chip->state = FL_STATUS;
 	DISABLE_VPP(map);
 	wake_up(&chip->wq);
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return 0;
 }
 static int cfi_staa_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
@@ -1203,7 +1203,7 @@ static inline int do_unlock_oneblock(str
 
 	timeo = jiffies + HZ;
 retry:
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	/* Check that the chip's ready to talk to us. */
 	switch (chip->state) {
@@ -1220,13 +1220,13 @@ retry:
 
 		/* Urgh. Chip not yet ready to talk to us. */
 		if (time_after(jiffies, timeo)) {
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			printk(KERN_ERR "waiting for chip to be ready timed out in unlock\n");
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the lock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
 		goto retry;
 
@@ -1235,7 +1235,7 @@ retry:
 		   someone changes the status */
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
 		timeo = jiffies + HZ;
@@ -1247,9 +1247,9 @@ retry:
 	map_write(map, CMD(0xD0), adr);
 	chip->state = FL_UNLOCKING;
 
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 	msleep(1000);
-	spin_lock_bh(chip->mutex);
+	mutex_lock(chip->mutex);
 
 	/* FIXME. Use a timer to check this, and return immediately. */
 	/* Once the state machine's known to be working I'll do that */
@@ -1267,21 +1267,21 @@ retry:
 			chip->state = FL_STATUS;
 			printk(KERN_ERR "waiting for unlock to complete timed out. Xstatus = %lx, status = %lx.\n", status.x[0], map_read(map, adr).x[0]);
 			DISABLE_VPP(map);
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 			return -EIO;
 		}
 
 		/* Latency issues. Drop the unlock, wait a while and retry */
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 		cfi_udelay(1);
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 	}
 
 	/* Done and happy. */
 	chip->state = FL_STATUS;
 	DISABLE_VPP(map);
 	wake_up(&chip->wq);
-	spin_unlock_bh(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return 0;
 }
 static int cfi_staa_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
@@ -1334,7 +1334,7 @@ static int cfi_staa_suspend(struct mtd_i
 	for (i=0; !ret && i<cfi->numchips; i++) {
 		chip = &cfi->chips[i];
 
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		switch(chip->state) {
 		case FL_READY:
@@ -1354,7 +1354,7 @@ static int cfi_staa_suspend(struct mtd_i
 			ret = -EAGAIN;
 			break;
 		}
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 
 	/* Unlock the chips again */
@@ -1363,7 +1363,7 @@ static int cfi_staa_suspend(struct mtd_i
 		for (i--; i >=0; i--) {
 			chip = &cfi->chips[i];
 
-			spin_lock_bh(chip->mutex);
+			mutex_lock(chip->mutex);
 
 			if (chip->state == FL_PM_SUSPENDED) {
 				/* No need to force it into a known state here,
@@ -1372,7 +1372,7 @@ static int cfi_staa_suspend(struct mtd_i
 				chip->state = chip->oldstate;
 				wake_up(&chip->wq);
 			}
-			spin_unlock_bh(chip->mutex);
+			mutex_unlock(chip->mutex);
 		}
 	}
 
@@ -1390,7 +1390,7 @@ static void cfi_staa_resume(struct mtd_i
 
 		chip = &cfi->chips[i];
 
-		spin_lock_bh(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		/* Go to known state. Chip may have been power cycled */
 		if (chip->state == FL_PM_SUSPENDED) {
@@ -1399,7 +1399,7 @@ static void cfi_staa_resume(struct mtd_i
 			wake_up(&chip->wq);
 		}
 
-		spin_unlock_bh(chip->mutex);
+		mutex_unlock(chip->mutex);
 	}
 }
 
diff -u -N -r -p linux-2.6.33.orig//drivers/mtd/chips/gen_probe.c linux-2.6.33/drivers/mtd/chips/gen_probe.c
--- linux-2.6.33.orig//drivers/mtd/chips/gen_probe.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/mtd/chips/gen_probe.c	2010-02-28 11:18:10.269139581 +0100
@@ -155,8 +155,7 @@ static struct cfi_private *genprobe_iden
 			pchip->start = (i << cfi.chipshift);
 			pchip->state = FL_READY;
 			init_waitqueue_head(&pchip->wq);
-			spin_lock_init(&pchip->_spinlock);
-			pchip->mutex = &pchip->_spinlock;
+			mutex_init(pchip->mutex);
 		}
 	}
 
diff -u -N -r -p linux-2.6.33.orig//drivers/mtd/lpddr/lpddr_cmds.c linux-2.6.33/drivers/mtd/lpddr/lpddr_cmds.c
--- linux-2.6.33.orig//drivers/mtd/lpddr/lpddr_cmds.c	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/drivers/mtd/lpddr/lpddr_cmds.c	2010-02-28 11:18:10.269139581 +0100
@@ -106,8 +106,7 @@ struct mtd_info *lpddr_cmdset(struct map
 			/* those should be reset too since
 			   they create memory references. */
 			init_waitqueue_head(&chip->wq);
-			spin_lock_init(&chip->_spinlock);
-			chip->mutex = &chip->_spinlock;
+			mutex_init(&chip->mutex);
 			chip++;
 		}
 	}
@@ -143,7 +142,7 @@ static int wait_for_ready(struct map_inf
 		}
 
 		/* OK Still waiting. Drop the lock, wait a while and retry. */
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		if (sleep_time >= 1000000/HZ) {
 			/*
 			 * Half of the normal delay still remaining
@@ -158,17 +157,17 @@ static int wait_for_ready(struct map_inf
 			cond_resched();
 			timeo--;
 		}
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 
 		while (chip->state != chip_state) {
 			/* Someone's suspended the operation: sleep */
 			DECLARE_WAITQUEUE(wait, current);
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 		}
 		if (chip->erase_suspended || chip->write_suspended)  {
 			/* Suspend has occured while sleep: reset timeout */
@@ -229,20 +228,20 @@ static int get_chip(struct map_info *map
 			 * it'll happily send us to sleep.  In any case, when
 			 * get_chip returns success we're clear to go ahead.
 			 */
-			ret = spin_trylock(contender->mutex);
+			ret = mutex_trylock(contender->mutex);
 			spin_unlock(&shared->lock);
 			if (!ret)
 				goto retry;
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			ret = chip_ready(map, contender, mode);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 
 			if (ret == -EAGAIN) {
-				spin_unlock(contender->mutex);
+				mutex_unlock(contender->mutex);
 				goto retry;
 			}
 			if (ret) {
-				spin_unlock(contender->mutex);
+				mutex_unlock(contender->mutex);
 				return ret;
 			}
 			spin_lock(&shared->lock);
@@ -251,10 +250,10 @@ static int get_chip(struct map_info *map
 			 * state. Put contender and retry. */
 			if (chip->state == FL_SYNCING) {
 				put_chip(map, contender);
-				spin_unlock(contender->mutex);
+				mutex_unlock(contender->mutex);
 				goto retry;
 			}
-			spin_unlock(contender->mutex);
+			mutex_unlock(contender->mutex);
 		}
 
 		/* Check if we have suspended erase on this chip.
@@ -264,10 +263,10 @@ static int get_chip(struct map_info *map
 			spin_unlock(&shared->lock);
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			add_wait_queue(&chip->wq, &wait);
-			spin_unlock(chip->mutex);
+			mutex_unlock(chip->mutex);
 			schedule();
 			remove_wait_queue(&chip->wq, &wait);
-			spin_lock(chip->mutex);
+			mutex_lock(chip->mutex);
 			goto retry;
 		}
 
@@ -336,10 +335,10 @@ static int chip_ready(struct map_info *m
 sleep:
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&chip->wq, &wait);
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		schedule();
 		remove_wait_queue(&chip->wq, &wait);
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 		return -EAGAIN;
 	}
 }
@@ -355,12 +354,12 @@ static void put_chip(struct map_info *ma
 			if (shared->writing && shared->writing != chip) {
 				/* give back the ownership */
 				struct flchip *loaner = shared->writing;
-				spin_lock(loaner->mutex);
+				mutex_lock(loaner->mutex);
 				spin_unlock(&shared->lock);
-				spin_unlock(chip->mutex);
+				mutex_unlock(chip->mutex);
 				put_chip(map, loaner);
-				spin_lock(chip->mutex);
-				spin_unlock(loaner->mutex);
+				mutex_lock(chip->mutex);
+				mutex_unlock(loaner->mutex);
 				wake_up(&chip->wq);
 				return;
 			}
@@ -413,10 +412,10 @@ int do_write_buffer(struct map_info *map
 
 	wbufsize = 1 << lpddr->qinfo->BufSizeShift;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, FL_WRITING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 	/* Figure out the number of words to write */
@@ -477,7 +476,7 @@ int do_write_buffer(struct map_info *map
 	}
 
  out:	put_chip(map, chip);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -489,10 +488,10 @@ int do_erase_oneblock(struct mtd_info *m
 	struct flchip *chip = &lpddr->chips[chipnum];
 	int ret;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, FL_ERASING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 	send_pfow_command(map, LPDDR_BLOCK_ERASE, adr, 0, NULL);
@@ -504,7 +503,7 @@ int do_erase_oneblock(struct mtd_info *m
 		goto out;
 	}
  out:	put_chip(map, chip);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -517,10 +516,10 @@ static int lpddr_read(struct mtd_info *m
 	struct flchip *chip = &lpddr->chips[chipnum];
 	int ret = 0;
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, FL_READY);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -528,7 +527,7 @@ static int lpddr_read(struct mtd_info *m
 	*retlen = len;
 
 	put_chip(map, chip);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -568,9 +567,9 @@ static int lpddr_point(struct mtd_info *
 		else
 			thislen = len;
 		/* get the chip */
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 		ret = get_chip(map, chip, FL_POINT);
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		if (ret)
 			break;
 
@@ -610,7 +609,7 @@ static void lpddr_unpoint (struct mtd_in
 		else
 			thislen = len;
 
-		spin_lock(chip->mutex);
+		mutex_lock(chip->mutex);
 		if (chip->state == FL_POINT) {
 			chip->ref_point_counter--;
 			if (chip->ref_point_counter == 0)
@@ -620,7 +619,7 @@ static void lpddr_unpoint (struct mtd_in
 					"pointed region\n", map->name);
 
 		put_chip(map, chip);
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 
 		len -= thislen;
 		ofs = 0;
@@ -726,10 +725,10 @@ int do_xxlock(struct mtd_info *mtd, loff
 	int chipnum = adr >> lpddr->chipshift;
 	struct flchip *chip = &lpddr->chips[chipnum];
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, FL_LOCKING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -749,7 +748,7 @@ int do_xxlock(struct mtd_info *mtd, loff
 		goto out;
 	}
 out:	put_chip(map, chip);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
@@ -770,10 +769,10 @@ int word_program(struct map_info *map, l
 	int chipnum = adr >> lpddr->chipshift;
 	struct flchip *chip = &lpddr->chips[chipnum];
 
-	spin_lock(chip->mutex);
+	mutex_lock(chip->mutex);
 	ret = get_chip(map, chip, FL_WRITING);
 	if (ret) {
-		spin_unlock(chip->mutex);
+		mutex_unlock(chip->mutex);
 		return ret;
 	}
 
@@ -787,7 +786,7 @@ int word_program(struct map_info *map, l
 	}
 
 out:	put_chip(map, chip);
-	spin_unlock(chip->mutex);
+	mutex_unlock(chip->mutex);
 	return ret;
 }
 
diff -u -N -r -p linux-2.6.33.orig//include/linux/mtd/flashchip.h linux-2.6.33/include/linux/mtd/flashchip.h
--- linux-2.6.33.orig//include/linux/mtd/flashchip.h	2010-02-24 19:52:17.000000000 +0100
+++ linux-2.6.33/include/linux/mtd/flashchip.h	2010-02-28 11:18:10.270139550 +0100
@@ -15,6 +15,7 @@
  * has asm/spinlock.h, or 2.4, which has linux/spinlock.h
  */
 #include <linux/sched.h>
+#include <linux/mutex.h>
 
 typedef enum {
 	FL_READY,
@@ -74,8 +75,7 @@ struct flchip {
 	unsigned int erase_suspended:1;
 	unsigned long in_progress_block_addr;
 
-	spinlock_t *mutex;
-	spinlock_t _spinlock; /* We do it like this because sometimes they'll be shared. */
+	struct mutex mutex[1];
 	wait_queue_head_t wq; /* Wait on here when we're waiting for the chip
 			     to be ready */
 	int word_write_time;


