Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYB1McM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYB1McM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 07:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbYB1McE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 07:32:04 -0500
Received: from mx1.suse.de ([195.135.220.2]:41335 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630AbYB1McD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:32:03 -0500
Message-ID: <47C6A9C1.8000008@suse.de>
Date: Thu, 28 Feb 2008 13:32:01 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20071114)
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] fs/partitions/msdos: directly check if FAT boot sector
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i received a complaint that some FAT formated medias
(e.g. sd memory cards) trigger a "unknown partition table" message even though
there is no partition table and they work correctly, while in general
(when e.g. formated with mkdosfs or even Windows Vista) this message is not
shown.
Currently this seems only to happen when the medias get formatted with
Windows XP (and possibly Win 2000). Then the boot indicator byte contains
garbage (part of text message) and so do the other parts checked by
msdos_paritition which then later triggers this message.

Would the patch below be appropriate to solve this issue/calm those users?
It works ok here for the medias i could test.

Any feedback is very welcome. :-)

Thanks,
Frank
---
From: Frank Seidel <fseidel@suse.de>
Subject: detect fat media without partition table correctly
References: novell bug #364365

Most fat formatted media without partition table contains
zeros in the boot indication and the other tested bytes
and so falls through the checks in msdos_partition, leading
it to return with 1 (all is fine).
But some (e.g. WinXP formatted) fat fomated medias don't
use boot_ind and so the check fails and causes a
"unkown partition table" warning eventhough there is none
and everything would be fine.
This additional check directly verifies if there is a
fat formatted medium without a partition table.

Signed-off-by: Frank Seidel <fseidel@suse.de>
---
 fs/partitions/msdos.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

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
@@ -441,6 +442,12 @@ int msdos_partition(struct parsed_partit
 	 * partition table. Reject this in case the boot indicator
 	 * is not 0 or 0x80.
 	 */
+	fb = (struct fat_boot_sector *) data;
+	if (fb->reserved && fb->fats && FAT_VALID_MEDIA(fb->media)) {
+		printk("\n");
+		put_dev_sector(sect);
+		return 1;
+	}
 	p = (struct partition *) (data + 0x1be);
 	for (slot = 1; slot <= 4; slot++, p++) {
 		if (p->boot_ind != 0 && p->boot_ind != 0x80) {
