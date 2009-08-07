Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbZHGWMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbZHGWMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZHGWMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:12:32 -0400
Received: from cmpxchg.org ([85.214.51.133]:59026 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZHGWMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:12:32 -0400
Date: Sat, 8 Aug 2009 00:12:52 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/4] vfs: explicitly cast s_maxbytes in fiemap_check_ranges
Message-ID: <20090807221252.GA28019@cmpxchg.org>
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com> <1249671461-9071-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249671461-9071-3-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 02:57:39PM -0400, Jeff Layton wrote:
> If fiemap_check_ranges is passed a large enough value, then it's
> possible that the value would be cast to a signed value for comparison
> against s_maxbytes when we change it to loff_t. Make sure that doesn't
> happen by explicitly casting s_maxbytes to an unsigned value for the
> purposes of comparison.

I think this is unneeded, C garuantees that in this case the signed
value will get promoted to an unsigned value, not the other way round.

	Hannes

> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/ioctl.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 5612880..7b17a14 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -162,20 +162,21 @@ EXPORT_SYMBOL(fiemap_check_flags);
>  static int fiemap_check_ranges(struct super_block *sb,
>  			       u64 start, u64 len, u64 *new_len)
>  {
> +	u64 maxbytes = (u64) sb->s_maxbytes;
> +
>  	*new_len = len;
>  
>  	if (len == 0)
>  		return -EINVAL;
>  
> -	if (start > sb->s_maxbytes)
> +	if (start > maxbytes)
>  		return -EFBIG;
>  
>  	/*
>  	 * Shrink request scope to what the fs can actually handle.
>  	 */
> -	if ((len > sb->s_maxbytes) ||
> -	    (sb->s_maxbytes - len) < start)
> -		*new_len = sb->s_maxbytes - start;
> +	if (len > maxbytes || (maxbytes - len) < start)
> +		*new_len = maxbytes - start;
>  
>  	return 0;
>  }
> -- 
> 1.6.0.6
> 
