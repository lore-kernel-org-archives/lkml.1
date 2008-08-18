Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYHRSsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYHRSsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758458AbYHRSr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:47:57 -0400
Received: from mail.suse.de ([195.135.220.2]:41297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758432AbYHRSr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:47:56 -0400
Date: Mon, 18 Aug 2008 11:41:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Petr Tesarik <ptesarik@suse.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Jan Kara <jack@suse.cz>,
       Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 08/60] ide-cd: fix endianity for the error message in
	cdrom_read_capacity
Message-ID: <20080818184141.GI29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-cd-fix-endianity-for-the-error-message-in-cdrom_read_capacity.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Petr Tesarik <ptesarik@suse.cz>

commit 938bb03d188a1e688fb0bcae49788f540193e80a uptream

Aesthetic regards aside, commit e8e7b9eb11c34ee18bde8b7011af41938d1ad667
still leaves a bug in the error message, because it uses the unconverted
big-endian value for printk.

Fix this by using a local variable in machine byte order. The result is
correct, more readable, and also produces slightly shorter code on i386.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@kernel.org>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
[bart: __u32 -> u32]
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-cd.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1298,6 +1298,7 @@ static int cdrom_read_capacity(ide_drive
 
 	int stat;
 	struct request req;
+	u32 blocklen;
 
 	ide_cd_init_rq(drive, &req);
 
@@ -1314,23 +1315,24 @@ static int cdrom_read_capacity(ide_drive
 	/*
 	 * Sanity check the given block size
 	 */
-	switch (capbuf.blocklen) {
-	case __constant_cpu_to_be32(512):
-	case __constant_cpu_to_be32(1024):
-	case __constant_cpu_to_be32(2048):
-	case __constant_cpu_to_be32(4096):
+	blocklen = be32_to_cpu(capbuf.blocklen);
+	switch (blocklen) {
+	case 512:
+	case 1024:
+	case 2048:
+	case 4096:
 		break;
 	default:
 		printk(KERN_ERR "%s: weird block size %u\n",
-			drive->name, capbuf.blocklen);
+			drive->name, blocklen);
 		printk(KERN_ERR "%s: default to 2kb block size\n",
 			drive->name);
-		capbuf.blocklen = __constant_cpu_to_be32(2048);
+		blocklen = 2048;
 		break;
 	}
 
 	*capacity = 1 + be32_to_cpu(capbuf.lba);
-	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	*sectors_per_frame = blocklen >> SECTOR_BITS;
 	return 0;
 }
 

-- 
