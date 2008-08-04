Return-Path: <linux-kernel-owner+w=401wt.eu-S1763969AbYHDU0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763969AbYHDU0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763858AbYHDU0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:26:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:48933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763844AbYHDU0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:26:32 -0400
Date: Mon, 4 Aug 2008 13:15:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Frank Seidel <fseidel@suse.de>,
       Andreas Dilger <adilger@sun.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [patch 17/33] fat: detect media without partition table correctly
Message-ID: <20080804201551.GR1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fat-detect-media-without-partition-table-correctly.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Frank Seidel <fseidel@suse.de>

commit 0607fd02587a6b4b086dc746d63123c1f284db68 upstream

I received a complaint that some FAT formated medias (e.g.  sd memory cards)
trigger a "unknown partition table" message even though there is no partition
table and they work correctly, while in general (when e.g.  formated with
mkdosfs or even Windows Vista) this message is not shown.

Currently this seems only to happen when the medias get formatted with Windows
XP (and possibly Win 2000).  Then the boot indicator byte contains garbage
(part of text message) and so do the other parts checked by msdos_paritition
which then later triggers this message.

References: novell bug #364365

Most fat formatted media without partition table contains zeros in the boot
indication and the other tested bytes and so falls through the checks in
msdos_partition, leading it to return with 1 (all is fine).

But some (e.g.  WinXP formatted) fat fomated medias don't use boot_ind and so
the check fails and causes a "unkown partition table" warning eventhough there
is none and everything would be fine.

This additional check directly verifies if there is a fat formatted medium
without a partition table.

Signed-off-by: Frank Seidel <fseidel@suse.de>
Cc: Andreas Dilger <adilger@sun.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/msdos.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -18,7 +18,7 @@
  *
  *  Re-organised Feb 1998 Russell King
  */
-
+#include <linux/msdos_fs.h>
 
 #include "check.h"
 #include "msdos.h"
@@ -419,6 +419,7 @@ int msdos_partition(struct parsed_partit
 	Sector sect;
 	unsigned char *data;
 	struct partition *p;
+	struct fat_boot_sector *fb;
 	int slot;
 
 	data = read_dev_sector(bdev, 0, &sect);
@@ -444,8 +445,21 @@ int msdos_partition(struct parsed_partit
 	p = (struct partition *) (data + 0x1be);
 	for (slot = 1; slot <= 4; slot++, p++) {
 		if (p->boot_ind != 0 && p->boot_ind != 0x80) {
-			put_dev_sector(sect);
-			return 0;
+			/*
+			 * Even without a valid boot inidicator value
+			 * its still possible this is valid FAT filesystem
+			 * without a partition table.
+			 */
+			fb = (struct fat_boot_sector *) data;
+			if (slot == 1 && fb->reserved && fb->fats
+				&& fat_valid_media(fb->media)) {
+				printk("\n");
+				put_dev_sector(sect);
+				return 1;
+			} else {
+				put_dev_sector(sect);
+				return 0;
+			}
 		}
 	}
 

-- 
