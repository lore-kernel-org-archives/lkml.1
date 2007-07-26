Return-Path: <linux-kernel-owner+w=401wt.eu-S1762735AbXGZDiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735AbXGZDiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbXGZDiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:38:15 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:2719 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971AbXGZDiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:38:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KPcGZS5p15S2DY5sTvtqPWvRE0Gm20Q6zmgz8BkxnuGsN5jMz4rbbh1/S99asUM9s/IBf4gwZgxSeuhNWlbQUTWK9vVz+QBzjTL8+ZANuX3DX/AUS2+oNHru3e6ifYBRC9XwIKpVkyQ1ILRxHQmFbquP/6ZjBP8opkB7UbNqxXM=
Message-ID: <8dd980de0707252038n5cd2a785j67622ccb93051288@mail.gmail.com>
Date: Thu, 26 Jul 2007 11:38:13 +0800
From: "Kevin Hao" <haokexin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH]MTD:Fix ctrl-alt-del cann't reboot for intel flash bug
Cc: dwmw2@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

  When we press ctrl-alt-del,kernel_restart_prepare will revoke
cfi_intelext_reboot which
will set flash to read array mode,but later when device_shutdown is
invoked which may
put current work queue to sleep and other process may be sheduled to
running and programming flash in not FL_READY mode again.So we cann't
boot up if this flash is used
for bootloader.This patch is against current Linus git tree.
   Sorry,my english is a little rusty.:-)
   Appreciated for any comment.

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c
b/drivers/mtd/chips/cfi_cmdset_0001.c
index 2f19fa7..a1009df 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -653,7 +653,7 @@ static int get_chip(struct map_info *map, struct
flchip *chip, unsigned long adr
  resettime:
        timeo = jiffies + HZ;
  retry:
-       if (chip->priv && (mode == FL_WRITING || mode == FL_ERASING ||
mode == FL_OTP_WRITE)) {
+       if (chip->priv && (mode == FL_WRITING || mode == FL_ERASING ||
mode == FL_OTP_WRITE || mode == FL_SHUTDOWN)) {
                /*
                 * OK. We have possibility for contension on the write/erase
                 * operations which are global to the real chip and not per
@@ -798,6 +798,9 @@ static int get_chip(struct map_info *map, struct
flchip *chip, unsigned long adr
                if (mode == FL_READY && chip->oldstate == FL_READY)
                        return 0;

+       case FL_SHUTDOWN:
+               /* The machine is rebooting now,so no one can get chip
anymore */
+               return -EIO;
        default:
        sleep:
                set_current_state(TASK_UNINTERRUPTIBLE);
@@ -2402,10 +2405,10 @@ static int cfi_intelext_reset(struct mtd_info *mtd)
                   and switch to array mode so any bootloader in
                   flash is accessible for soft reboot. */
                spin_lock(chip->mutex);
-               ret = get_chip(map, chip, chip->start, FL_SYNCING);
+               ret = get_chip(map, chip, chip->start, FL_SHUTDOWN);
                if (!ret) {
                        map_write(map, CMD(0xff), chip->start);
-                       chip->state = FL_READY;
+                       chip->state = FL_SHUTDOWN;
                }
                spin_unlock(chip->mutex);
        }
diff --git a/include/linux/mtd/flashchip.h b/include/linux/mtd/flashchip.h
index a293a3b..39e7d2a 100644
--- a/include/linux/mtd/flashchip.h
+++ b/include/linux/mtd/flashchip.h
@@ -40,6 +40,7 @@ typedef enum {
        FL_POINT,
        FL_XIP_WHILE_ERASING,
        FL_XIP_WHILE_WRITING,
+       FL_SHUTDOWN,
        FL_UNKNOWN
 } flstate_t;
