Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYJGAmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYJGAmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYJGAlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:41:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087AbYJGAlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:41:13 -0400
Date: Mon, 6 Oct 2008 17:37:36 -0700
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
       alan@lxorguk.ukuu.org.uk, Pierre Ossman <drzeus-list@drzeus.cx>
Subject: [patch 05/71] drivers/mmc/card/block.c: fix refcount leak in
	mmc_block_open()
Message-ID: <20081007003736.GF3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drivers-mmc-card-block.c-fix-refcount-leak-in-mmc_block_open.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

commit 70bb08962ea9bd50797ae9f16b2493f5f7c65053 upstream

mmc_block_open() increments md->usage although it returns with -EROFS when
default mounting a MMC/SD card with write protect switch on.  This
reference counting bug prevents /dev/mmcblkX from being released on card
removal, and situation worsen with reinsertion until the minor number
range runs out.

Reported-by: <sasin@solomon-systech.com>
Acked-by: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/card/block.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -103,8 +103,10 @@ static int mmc_blk_open(struct inode *in
 			check_disk_change(inode->i_bdev);
 		ret = 0;
 
-		if ((filp->f_mode & FMODE_WRITE) && md->read_only)
+		if ((filp->f_mode & FMODE_WRITE) && md->read_only) {
+			mmc_blk_put(md);
 			ret = -EROFS;
+		}
 	}
 
 	return ret;

-- 
