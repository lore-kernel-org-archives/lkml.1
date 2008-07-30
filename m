Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbYG3Xgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbYG3Xgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760515AbYG3XgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:36:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:35687 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760860AbYG3XgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:36:06 -0400
Date: Wed, 30 Jul 2008 16:27:06 -0700
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
       alan@lxorguk.ukuu.org.uk, Michael Buesch <mb@bu3sch.de>,
       Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: [patch 11/29] ide-cd: fix oops when using growisofs
Message-ID: <20080730232706.GL30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ide-cd-fix-oops-when-using-growisofs.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Jens Axboe <jens.axboe@oracle.com>

commit e8e7b9eb11c34ee18bde8b7011af41938d1ad667 upstream

cdrom_read_capacity() will blindly return the capacity from the device
without sanity-checking it.  This later causes code in fs/buffer.c to
oops.

Fix this by checking that the device is telling us sensible things.

From: Jens Axboe <jens.axboe@oracle.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[bart: print device name instead of driver name]
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
[harvey: blocklen is a big-endian value]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-cd.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1421,13 +1421,30 @@ static int cdrom_read_capacity(ide_drive
 	req.cmd_flags |= REQ_QUIET;
 
 	stat = ide_cd_queue_pc(drive, &req);
-	if (stat == 0) {
-		*capacity = 1 + be32_to_cpu(capbuf.lba);
-		*sectors_per_frame =
-			be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	if (stat)
+		return stat;
+
+	/*
+	 * Sanity check the given block size
+	 */
+	switch (capbuf.blocklen) {
+	case __constant_cpu_to_be32(512):
+	case __constant_cpu_to_be32(1024):
+	case __constant_cpu_to_be32(2048):
+	case __constant_cpu_to_be32(4096):
+		break;
+	default:
+		printk(KERN_ERR "%s: weird block size %u\n",
+			drive->name, capbuf.blocklen);
+		printk(KERN_ERR "%s: default to 2kb block size\n",
+			drive->name);
+		capbuf.blocklen = __constant_cpu_to_be32(2048);
+		break;
 	}
 
-	return stat;
+	*capacity = 1 + be32_to_cpu(capbuf.lba);
+	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	return 0;
 }
 
 static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,

-- 
