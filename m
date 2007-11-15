Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXKOHLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXKOHLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765372AbXKOGxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:53:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33534 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888AbXKOGxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:53:17 -0500
Date: Wed, 14 Nov 2007 22:52:34 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, Bodo Eggert <7eggert@gmx.de>
Subject: [patch 1/3] minixfs: limit minixfs printks on corrupted dir i_size
	(CVE-2006-6058)
Message-ID: <20071115065234.GB20690@kroah.com>
References: <20071115065014.785638308@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="minixfs-limit-minixfs-printks-on-corrupted-dir-i_size.patch"
In-Reply-To: <20071115065220.GA20690@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

patch f44ec6f3f89889a469773b1fd894f8fcc07c29cf upstream.

This attempts to address CVE-2006-6058
http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2006-6058

first reported at http://projects.info-pull.com/mokb/MOKB-17-11-2006.html

Essentially a corrupted minix dir inode reporting a very large
i_size will loop for a very long time in minix_readdir, minix_find_entry,
etc, because on EIO they just move on to try the next page.  This is
under the BKL, printk-storming as well.  This can lock up the machine
for a very long time.  Simply ratelimiting the printks gets things back
under control.  Make the message a bit more informative while we're here.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Bodo Eggert <7eggert@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/minix/itree_v1.c |    9 +++++++--
 fs/minix/itree_v2.c |    9 +++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -23,11 +23,16 @@ static inline block_t *i_data(struct ino
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
+	char b[BDEVNAME_SIZE];
 
 	if (block < 0) {
-		printk("minix_bmap: block<0\n");
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
+			block, bdevname(inode->i_sb->s_bdev, b));
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("MINIX-fs: block_to_path: "
+			       "block %ld too big on dev %s\n",
+				block, bdevname(inode->i_sb->s_bdev, b));
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 512) {
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -23,12 +23,17 @@ static inline block_t *i_data(struct ino
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 {
 	int n = 0;
+	char b[BDEVNAME_SIZE];
 	struct super_block *sb = inode->i_sb;
 
 	if (block < 0) {
-		printk("minix_bmap: block<0\n");
+		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
+			block, bdevname(sb->s_bdev, b));
 	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksize)) {
-		printk("minix_bmap: block>big\n");
+		if (printk_ratelimit())
+			printk("MINIX-fs: block_to_path: "
+			       "block %ld too big on dev %s\n",
+				block, bdevname(sb->s_bdev, b));
 	} else if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 256) {

-- 
