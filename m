Return-Path: <linux-kernel-owner+w=401wt.eu-S935257AbYBBVhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935257AbYBBVhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 16:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYBBVhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 16:37:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:58356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYBBVho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 16:37:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FU0P7iExHDenl0mO2FM6ljS6RO5MnnXJohOyWa+6mulmQelw0TZGz4OR47U7pml7ENYhicJ8St8X81QNva/iy0BIOBFRptEnRNeoUxsuE+3DOHcuSUVITKOvtMoBp0sZ2BPpcIY7LMmrOiwF2qls8kpxrtpS1XD/dUjYONPjt84=
Date: Sat, 2 Feb 2008 22:37:07 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] udf: constify udf_bitmap_lookup array
Message-ID: <20080202213659.GA8495@joi>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-11-git-send-email-marcin.slusarz@gmail.com> <20080131165244.GJ1461@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131165244.GJ1461@duck.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:52:44PM +0100, Jan Kara wrote:
> On Wed 30-01-08 22:04:00, marcin.slusarz@gmail.com wrote:
> > udf_bitmap_lookup never changes, so constify it
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Jan Kara <jack@suse.cz>
>   Hmm, rather than doing this, could you change the function to use
> standard functions for counting set bits? I guess bitmap_weight() in
> include/linux/bitmap.h should be what we need... Thanks.

---
udf: convert udf_count_free_bitmap to use bitmap_weight

replace handwritten bits counting with bitmap_weight

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 3afe764..0dcee12 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -53,6 +53,7 @@
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
 #include <linux/errno.h>
+#include <linux/bitmap.h>
 #include <asm/byteorder.h>
 
 #include <linux/udf_fs.h>
@@ -1969,10 +1970,6 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static unsigned char udf_bitmap_lookup[16] = {
-	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
-};
-
 static unsigned int udf_count_free_bitmap(struct super_block *sb,
 					  struct udf_bitmap *bitmap)
 {
@@ -1982,7 +1979,6 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	int block = 0, newblock;
 	kernel_lb_addr loc;
 	uint32_t bytes;
-	uint8_t value;
 	uint8_t *ptr;
 	uint16_t ident;
 	struct spaceBitmapDesc *bm;
@@ -2008,13 +2004,10 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	ptr = (uint8_t *)bh->b_data;
 
 	while (bytes > 0) {
-		while ((bytes > 0) && (index < sb->s_blocksize)) {
-			value = ptr[index];
-			accum += udf_bitmap_lookup[value & 0x0f];
-			accum += udf_bitmap_lookup[value >> 4];
-			index++;
-			bytes--;
-		}
+		u32 cur_bytes = min_t(u32, bytes, sb->s_blocksize - index);
+		accum += bitmap_weight((const unsigned long *)(ptr + index),
+					cur_bytes * 8);
+		bytes -= cur_bytes;
 		if (bytes) {
 			brelse(bh);
 			newblock = udf_get_lb_pblock(sb, loc, ++block);
-- 
1.5.3.7

