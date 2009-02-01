Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbZBADC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbZBADC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 22:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZBADBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 22:01:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:60324 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbZBADBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 22:01:47 -0500
Message-ID: <49851054.10605@kernel.org>
Date: Sun, 01 Feb 2009 12:00:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: [PATCH 2/3] dmraid: add alt_size to dev_info
References: <1233456951-992-1-git-send-email-tj@kernel.org> <49851012.8070904@kernel.org>
In-Reply-To: <49851012.8070904@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 01 Feb 2009 03:00:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add alt_size to dev_info and set it during device scanning if
available.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/dmraid/metadata.h |    1 +
 lib/device/scan.c         |   51 ++++++++++++++++++++++++++++++++------------
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/include/dmraid/metadata.h b/include/dmraid/metadata.h
index 91bd221..538043e 100644
--- a/include/dmraid/metadata.h
+++ b/include/dmraid/metadata.h
@@ -120,6 +120,7 @@ struct dev_info {
 	char *path;		/* Actual device node path. */
 	char *serial;		/* ATA/SCSI serial number. */
 	uint64_t sectors;	/* Device size. */
+	uint64_t alt_sectors;	/* Alternative device size. (BIOS size) */
 };
 
 /* Metadata areas and size stored on a RAID device. */
diff --git a/lib/device/scan.c b/lib/device/scan.c
index e9618c2..3befb08 100644
--- a/lib/device/scan.c
+++ b/lib/device/scan.c
@@ -233,29 +233,52 @@ sysfs_get_size(struct lib_context *lc, struct dev_info *di,
 {
 	int ret = 0;
 	char buf[22], *sysfs_file;
-	const char *sysfs_size = "size";
+	const char *sysfs_size = "size", *sysfs_alt_size = "alt_size";
 	FILE *f;
 
 	if (!(sysfs_file = dbg_malloc(strlen(path) + strlen(name) +
-				      strlen(sysfs_size) + 3)))
+				      max(strlen(sysfs_size),
+					  strlen(sysfs_alt_size)) + 3)))
 		return log_alloc_err(lc, __func__);
 
+	/* read size */
 	sprintf(sysfs_file, "%s/%s/%s", path, name, sysfs_size);
-	if ((f = fopen(sysfs_file, "r"))) {
-		/* Use fread+sscanf for klibc compatibility. */
-		if (fread(buf, sizeof(char), sizeof buf - 1, f) &&
-		    (ret = sscanf(buf, "%" PRIu64, &di->sectors)) != 1) {
-			ret = 0;
-			log_err(lc, "reading disk size for %s from sysfs",
-				di->path);
-		}
-
-		fclose(f);
-	} else
+	if (!(f = fopen(sysfs_file, "r"))) {
 		log_err(lc, "opening %s", sysfs_file);
+		goto out;
+	}
 
-	dbg_free(sysfs_file);
+	/* Use fread+sscanf for klibc compatibility. */
+	if (!fread(buf, sizeof(char), sizeof buf - 1, f) ||
+	    sscanf(buf, "%" PRIu64, &di->sectors) != 1) {
+		log_err(lc, "reading disk size for %s from sysfs",
+			di->path);
+		goto out;
+	}
+	fclose(f);
+
+	/* read alt_size, missing alt_size isn't an error */
+	sprintf(sysfs_file, "%s/%s/%s", path, name, sysfs_alt_size);
+	if (!(f = fopen(sysfs_file, "r"))) {
+		if (errno == ENOENT)
+			ret = 1;
+		else
+			log_err(lc, "opening %s", sysfs_file);
+		goto out;
+	}
+
+	if (!fread(buf, sizeof(char), sizeof buf - 1, f) ||
+	    sscanf(buf, "%" PRIu64, &di->alt_sectors) != 1) {
+		log_err(lc, "reading disk alt size for %s from sysfs",
+			di->path);
+		goto out;
+	}
+	ret = 1;
 
+out:
+	if (f)
+		fclose(f);
+	dbg_free(sysfs_file);
 	return ret;
 }
 
-- 
1.6.0.2

