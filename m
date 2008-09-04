Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYIDXIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYIDXIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYIDXId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:08:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbYIDXIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:08:32 -0400
Date: Thu, 4 Sep 2008 16:08:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <sasin@solomon-systech.com>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: mmc/card/block.c : mmc_blk_open readonly mount bug?
Message-Id: <20080904160808.a23a2197.akpm@linux-foundation.org>
In-Reply-To: <6334E09627481B4AA5C8DE1E69E19D3B09D1F13A@SSLEXCHANGE.solomonsystech.com>
References: <6334E09627481B4AA5C8DE1E69E19D3B09D1F13A@SSLEXCHANGE.solomonsystech.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 17:17:15 +0800
<sasin@solomon-systech.com> wrote:

> mmc_block_open increments md->usage although it returns with -EROFS when
> default mounting a MMC/SD card with write protect switch on.  This
> reference counting bug prevents /dev/mmcblkX from being released on card
> removal, and situation worsen with reinsertion until the minor number
> range runs out.
> 
> "return -EROFS;"
> 
> should be replaced by
> 
> "
> {
> ret = -EROFS;
> mmc_blk_put(md);
> }
> "

It's unknown what kernel version you're looking at.  The code in 2.6.25
and 2.6.26 and 2.6.27 has changed since then, but the bug appears to
still be there.

From: Andrew Morton <akpm@linux-foundation.org>

mmc_block_open() increments md->usage although it returns with -EROFS when
default mounting a MMC/SD card with write protect switch on.  This
reference counting bug prevents /dev/mmcblkX from being released on card
removal, and situation worsen with reinsertion until the minor number
range runs out.

Reported-by: <sasin@solomon-systech.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/block.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/card/block.c~drivers-mmc-card-blockc-fix-refcount-leak-in-mmc_block_open drivers/mmc/card/block.c
--- a/drivers/mmc/card/block.c~drivers-mmc-card-blockc-fix-refcount-leak-in-mmc_block_open
+++ a/drivers/mmc/card/block.c
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
_

