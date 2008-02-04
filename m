Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbYBDTPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbYBDTPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbYBDTPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:15:06 -0500
Received: from styx.suse.cz ([82.119.242.94]:49745 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754892AbYBDTPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:15:05 -0500
Date: Mon, 4 Feb 2008 20:15:03 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] udf: constify udf_bitmap_lookup array
Message-ID: <20080204191503.GM3426@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-11-git-send-email-marcin.slusarz@gmail.com> <20080131165244.GJ1461@duck.suse.cz> <20080202213659.GA8495@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202213659.GA8495@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 02-02-08 22:37:07, Marcin Slusarz wrote:
> On Thu, Jan 31, 2008 at 05:52:44PM +0100, Jan Kara wrote:
> > On Wed 30-01-08 22:04:00, marcin.slusarz@gmail.com wrote:
> > > udf_bitmap_lookup never changes, so constify it
> > > 
> > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > > Cc: Jan Kara <jack@suse.cz>
> >   Hmm, rather than doing this, could you change the function to use
> > standard functions for counting set bits? I guess bitmap_weight() in
> > include/linux/bitmap.h should be what we need... Thanks.
> 
> ---
> udf: convert udf_count_free_bitmap to use bitmap_weight
> 
> replace handwritten bits counting with bitmap_weight
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/udf/super.c |   17 +++++------------
>  1 files changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 3afe764..0dcee12 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -53,6 +53,7 @@
>  #include <linux/vfs.h>
>  #include <linux/vmalloc.h>
>  #include <linux/errno.h>
> +#include <linux/bitmap.h>
>  #include <asm/byteorder.h>
>  
>  #include <linux/udf_fs.h>
> @@ -1969,10 +1970,6 @@ static int udf_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	return 0;
>  }
>  
> -static unsigned char udf_bitmap_lookup[16] = {
> -	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
> -};
> -
>  static unsigned int udf_count_free_bitmap(struct super_block *sb,
>  					  struct udf_bitmap *bitmap)
>  {
> @@ -1982,7 +1979,6 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
>  	int block = 0, newblock;
>  	kernel_lb_addr loc;
>  	uint32_t bytes;
> -	uint8_t value;
>  	uint8_t *ptr;
>  	uint16_t ident;
>  	struct spaceBitmapDesc *bm;
> @@ -2008,13 +2004,10 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
>  	ptr = (uint8_t *)bh->b_data;
>  
>  	while (bytes > 0) {
> -		while ((bytes > 0) && (index < sb->s_blocksize)) {
> -			value = ptr[index];
> -			accum += udf_bitmap_lookup[value & 0x0f];
> -			accum += udf_bitmap_lookup[value >> 4];
> -			index++;
> -			bytes--;
> -		}
> +		u32 cur_bytes = min_t(u32, bytes, sb->s_blocksize - index);
> +		accum += bitmap_weight((const unsigned long *)(ptr + index),
> +					cur_bytes * 8);
> +		bytes -= cur_bytes;
>  		if (bytes) {
>  			brelse(bh);
>  			newblock = udf_get_lb_pblock(sb, loc, ++block);
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
