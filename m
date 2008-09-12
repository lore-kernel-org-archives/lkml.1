Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYILRkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYILRkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYILRjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:39:53 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:41156 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753407AbYILRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:39:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pTebyC0hpZOeEUTIaGMybK92TWqhFSF1fyZPKMUXdW9VRr7mdpPIPiBOfwRy3CXIvHGkPVOBcj/894F7Y5AB1rSXnF0Upcok7mkgT6bbdv4doyrNIBrmWhG5mb01A7Q5ANJYk91o7JyENTtbTgV+TfYq1Xv/dS3AoWGb8HDX6+Y=  ;
X-YMail-OSG: Vn28VHEVM1kEC6ASxqM0cQp.UIt841CFhZMCp4xzzXl58xcVw2jr_zmuyWIUzWqIvE4vXBAPbkkIgaHt9jeAqw3W4oACPLJfcWc8z2LwvAyZJN4y85KmtVk3uJcKTgc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.27 mmotm] rtc-cmos: export second NVRAM bank
Date: Fri, 12 Sep 2008 09:57:55 -0700
User-Agent: KMail/1.9.9
Cc: rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809120957.55562.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Teach rtc-cmos about the second bank of registers found on most
modern x86 systems, giving access to 128 bytes more NVRAM.

This version only sees that extra NVRAM when both register banks
are provided as part of *one* PNP resource.  Since BIOS on some
systems presents them using two IO resources, and nothing merges
them, this can't always show all the NVRAM.  (We're supposed to
be able to use PNP id PNP0b01 too, but BIOS tables doesn't often
seem to use that particular option.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
For 2.6.28; applies after other pending patches

 drivers/rtc/rtc-cmos.c |   70 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 7 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -153,6 +153,43 @@ static inline int hpet_unregister_irq_ha
 
 /*----------------------------------------------------------------*/
 
+#ifdef RTC_PORT
+
+/* Most newer x86 systems have two register banks, the first used
+ * for RTC and NVRAM and the second only for NVRAM.  Caller must
+ * own rtc_lock ... and we won't worry about access during NMI.
+ */
+#define can_bank2	true
+
+static inline unsigned char cmos_read_bank2(unsigned char addr)
+{
+	outb(addr, RTC_PORT(2));
+	return inb(RTC_PORT(3));
+}
+
+static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
+{
+	outb(addr, RTC_PORT(2));
+	outb(val, RTC_PORT(2));
+}
+
+#else
+
+#define can_bank2	false
+
+static inline unsigned char cmos_read_bank2(unsigned char addr)
+{
+	return 0;
+}
+
+static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
+{
+}
+
+#endif
+
+/*----------------------------------------------------------------*/
+
 static int cmos_read_time(struct device *dev, struct rtc_time *t)
 {
 	/* REVISIT:  if the clock has a "century" register, use
@@ -511,12 +548,21 @@ cmos_nvram_read(struct kobject *kobj, st
 
 	if (unlikely(off >= attr->size))
 		return 0;
+	if (unlikely(off < 0))
+		return -EINVAL;
 	if ((off + count) > attr->size)
 		count = attr->size - off;
 
+	off += NVRAM_OFFSET;
 	spin_lock_irq(&rtc_lock);
-	for (retval = 0, off += NVRAM_OFFSET; count--; retval++, off++)
-		*buf++ = CMOS_READ(off);
+	for (retval = 0; count; count--, off++, retval++) {
+		if (off < 128)
+			*buf++ = CMOS_READ(off);
+		else if (can_bank2)
+			*buf++ = cmos_read_bank2(off);
+		else
+			break;
+	}
 	spin_unlock_irq(&rtc_lock);
 
 	return retval;
@@ -532,6 +578,8 @@ cmos_nvram_write(struct kobject *kobj, s
 	cmos = dev_get_drvdata(container_of(kobj, struct device, kobj));
 	if (unlikely(off >= attr->size))
 		return -EFBIG;
+	if (unlikely(off < 0))
+		return -EINVAL;
 	if ((off + count) > attr->size)
 		count = attr->size - off;
 
@@ -540,15 +588,20 @@ cmos_nvram_write(struct kobject *kobj, s
 	 * here.  If userspace is smart enough to know what fields of
 	 * NVRAM to update, updating checksums is also part of its job.
 	 */
+	off += NVRAM_OFFSET;
 	spin_lock_irq(&rtc_lock);
-	for (retval = 0, off += NVRAM_OFFSET; count--; retval++, off++) {
+	for (retval = 0; count; count--, off++, retval++) {
 		/* don't trash RTC registers */
 		if (off == cmos->day_alrm
 				|| off == cmos->mon_alrm
 				|| off == cmos->century)
 			buf++;
-		else
+		else if (off < 128)
 			CMOS_WRITE(*buf++, off);
+		else if (can_bank2)
+			cmos_write_bank2(*buf++, off);
+		else
+			break;
 	}
 	spin_unlock_irq(&rtc_lock);
 
@@ -651,8 +704,8 @@ cmos_do_probe(struct device *dev, struct
 
 	/* Heuristic to deduce NVRAM size ... do what the legacy NVRAM
 	 * driver did, but don't reject unknown configs.   Old hardware
-	 * won't address 128 bytes, and for now we ignore the way newer
-	 * chips can address 256 bytes (using two more i/o ports).
+	 * won't address 128 bytes.  Newer chips have multiple banks,
+	 * though they may not be listed in one I/O resource.
 	 */
 #if	defined(CONFIG_ATARI)
 	address_space = 64;
@@ -662,6 +715,8 @@ cmos_do_probe(struct device *dev, struct
 #warning Assuming 128 bytes of RTC+NVRAM address space, not 64 bytes.
 	address_space = 128;
 #endif
+	if (can_bank2 && ports->end > (ports->start + 1))
+		address_space = 256;
 
 	/* For ACPI systems extension info comes from the FADT.  On others,
 	 * board specific setup provides it as appropriate.  Systems where
@@ -776,13 +831,14 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup2;
 	}
 
-	pr_info("%s: alarms up to one %s%s, %s irqs\n",
+	pr_info("%s: alarms up to one %s%s, %zd bytes nvram, %s irqs\n",
 			cmos_rtc.rtc->dev.bus_id,
 			cmos_rtc.mon_alrm
 				? "year"
 				: (cmos_rtc.day_alrm
 					? "month" : "day"),
 			cmos_rtc.century ? ", y3k" : "",
+			nvram.size,
 			cmos_rtc.set_filter
 				? IRQ_FILTER_TYPE
 				: (is_valid_irq(rtc_irq)
