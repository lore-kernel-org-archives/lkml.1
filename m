Return-Path: <linux-kernel-owner+w=401wt.eu-S966043AbXDHDmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966043AbXDHDmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 23:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933663AbXDHDmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 23:42:10 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:53841 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933660AbXDHDmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 23:42:07 -0400
Date: Sat, 7 Apr 2007 23:42:00 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: aeb@cwi.nl
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] partitions: Rewrite check_partition to remove necessity
 of check_part
In-Reply-To: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
Message-ID: <alpine.DEB.0.83.0704072340550.27057@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704072235180.27057@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Removes the entire check_part array and uses the presence of new stub 
functions in header files in fs/partitions to call them directly in a list 
and let the compiler optimize away any that aren't compiled in. Also fixes 
a bug where " unable to read partition table" would never be printed.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

I did this because it seems to be much easier to understand. And even 
though the memory used by the array was only sizeof(void*)*n+1 for the 
number of partitions configured to be included, that's still unnecessary 
usage.

This code also has two warn_unused_result problems, but I don't feel up to 
the task of fixing those yet.

Within the old loop, if res < 0, res = 0, and immediately after the loop, 
the function returns if res > 0. Therefore, it must be that res == 0 after 
the loop. if (!err) is true only if err == 0 so again, res == 0, so if 
(!res) is true, and the else condition can never be reached. I 
re-interpreted the intent to be "log a message if the partition format is 
unrecognized, and log a message if the partition cannot be read but only 
if the warning is requested". Judging by the "This is ugly" comment, the 
warning is not intended to account for actual I/O errors when reading the 
partition-table block, but rather to detect when the partitions are 
checked for a device with a medium that has been removed.

--- linux-2.6.20.6-orig/fs/partitions/check.c	2007-04-06 16:02:48.000000000 -0400
+++ linux-2.6.20.6-mod/fs/partitions/check.c	2007-04-07 21:50:22.000000000 -0400
@@ -41,73 +41,6 @@ extern void md_autodetect_dev(dev_t dev)
 
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
-static int (*check_part[])(struct parsed_partitions *, struct block_device *) = {
-	/*
-	 * Probe partition formats with tables at disk address 0
-	 * that also have an ADFS boot block at 0xdc0.
-	 */
-#ifdef CONFIG_ACORN_PARTITION_ICS
-	adfspart_check_ICS,
-#endif
-#ifdef CONFIG_ACORN_PARTITION_POWERTEC
-	adfspart_check_POWERTEC,
-#endif
-#ifdef CONFIG_ACORN_PARTITION_EESOX
-	adfspart_check_EESOX,
-#endif
-
-	/*
-	 * Now move on to formats that only have partition info at
-	 * disk address 0xdc0.  Since these may also have stale
-	 * PC/BIOS partition tables, they need to come before
-	 * the msdos entry.
-	 */
-#ifdef CONFIG_ACORN_PARTITION_CUMANA
-	adfspart_check_CUMANA,
-#endif
-#ifdef CONFIG_ACORN_PARTITION_ADFS
-	adfspart_check_ADFS,
-#endif
-
-#ifdef CONFIG_EFI_PARTITION
-	efi_partition,		/* this must come before msdos */
-#endif
-#ifdef CONFIG_SGI_PARTITION
-	sgi_partition,
-#endif
-#ifdef CONFIG_LDM_PARTITION
-	ldm_partition,		/* this must come before msdos */
-#endif
-#ifdef CONFIG_MSDOS_PARTITION
-	msdos_partition,
-#endif
-#ifdef CONFIG_OSF_PARTITION
-	osf_partition,
-#endif
-#ifdef CONFIG_SUN_PARTITION
-	sun_partition,
-#endif
-#ifdef CONFIG_AMIGA_PARTITION
-	amiga_partition,
-#endif
-#ifdef CONFIG_ATARI_PARTITION
-	atari_partition,
-#endif
-#ifdef CONFIG_MAC_PARTITION
-	mac_partition,
-#endif
-#ifdef CONFIG_ULTRIX_PARTITION
-	ultrix_partition,
-#endif
-#ifdef CONFIG_IBM_PARTITION
-	ibm_partition,
-#endif
-#ifdef CONFIG_KARMA_PARTITION
-	karma_partition,
-#endif
-	NULL
-};
- 
 /*
  * disk_name() is used by partition check code and the genhd driver.
  * It formats the devicename of the indicated disk into
@@ -149,11 +82,125 @@ const char *__bdevname(dev_t dev, char *
 
 EXPORT_SYMBOL(__bdevname);
 
+static int
+check_succeeded(int res, struct parsed_partitions *state, int *err)
+{
+	if (res < 0) {
+		/* We have hit an I/O error which we don't report now.
+		 * But record it, and let the others do their job.
+		 */
+		*err = res;
+		res = 0;
+	}
+
+	if (!res) {
+		memset(state->parts, 0, sizeof(state->parts));
+	}
+
+	return res;
+}
+
+static struct parsed_partitions *
+do_check_list(struct parsed_partitions *state, struct block_device *bdev)
+{
+	int err;
+
+	err = 0;
+
+        /*
+	 * Probe partition formats with tables at disk address 0
+	 * that also have an ADFS boot block at 0xdc0.
+	 */
+	if (check_succeeded(adfspart_check_ICS(state, bdev), state, &err)) {
+		return state;
+	}
+	if (check_succeeded(adfspart_check_POWERTEC(state, bdev), state, &err)) {
+		return state;
+	}
+	if (check_succeeded(adfspart_check_EESOX(state, bdev), state, &err)) {
+		return state;
+	}
+
+        /*
+	 * Now move on to formats that only have partition info at
+	 * disk address 0xdc0.  Since these may also have stale
+	 * PC/BIOS partition tables, they need to come before
+	 * the msdos entry.
+	 */
+	if (check_succeeded(adfspart_check_CUMANA(state, bdev), state, &err)) {
+		return state;
+	}
+	if (check_succeeded(adfspart_check_ADFS(state, bdev), state, &err)) {
+		return state;
+	}
+
+	/* this must come before msdos */
+	if (check_succeeded(efi_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(sgi_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	/* this must come before msdos */
+	if (check_succeeded(ldm_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(msdos_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(osf_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(sun_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(amiga_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(atari_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(mac_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(ultrix_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(ibm_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	if (check_succeeded(karma_partition(state, bdev), state, &err)) {
+		return state;
+	}
+
+	kfree(state);
+
+	if (err) {
+		if (warn_no_part) {
+			printk(" unable to read partition table\n");
+		}
+	} else {
+		printk(" unknown partition table\n");
+	}
+
+	return ERR_PTR(err);
+}
+
 static struct parsed_partitions *
 check_partition(struct gendisk *hd, struct block_device *bdev)
 {
 	struct parsed_partitions *state;
-	int i, res, err;
 
 	state = kmalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
 	if (!state)
@@ -165,30 +212,8 @@ check_partition(struct gendisk *hd, stru
 		sprintf(state->name, "p");
 
 	state->limit = hd->minors;
-	i = res = err = 0;
-	while (!res && check_part[i]) {
-		memset(&state->parts, 0, sizeof(state->parts));
-		res = check_part[i++](state, bdev);
-		if (res < 0) {
-			/* We have hit an I/O error which we don't report now.
-		 	* But record it, and let the others do their job.
-		 	*/
-			err = res;
-			res = 0;
-		}
 
-	}
-	if (res > 0)
-		return state;
-	if (!err)
-	/* The partition is unrecognized. So report I/O errors if there were any */
-		res = err;
-	if (!res)
-		printk(" unknown partition table\n");
-	else if (warn_no_part)
-		printk(" unable to read partition table\n");
-	kfree(state);
-	return ERR_PTR(res);
+	return do_check_list(state, bdev);
 }
 
 /*
