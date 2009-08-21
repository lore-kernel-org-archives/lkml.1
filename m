Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZHUBhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZHUBhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 21:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZHUBhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 21:37:32 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:47157 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZHUBhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 21:37:32 -0400
Date: Thu, 20 Aug 2009 18:36:17 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       ocfs2-devel@oss.oracle.com, mfasheh@suse.com
Subject: Re: [Ocfs2-devel] [PATCH 13/17] ocfs2: Update syncing after
 splicing to match generic version
Message-ID: <20090821013617.GI10558@mail.oracle.com>
Mail-Followup-To: Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
	ocfs2-devel@oss.oracle.com, mfasheh@suse.com
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
 <1250697884-22288-14-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250697884-22288-14-git-send-email-jack@suse.cz>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A8DFA51.0185:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 06:04:40PM +0200, Jan Kara wrote:
> Update ocfs2 specific splicing code to use generic syncing helper.
> 
> CC: Joel Becker <Joel.Becker@oracle.com>
> CC: ocfs2-devel@oss.oracle.com
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ocfs2/file.c |   27 ++++++---------------------
>  1 files changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 1c71f0a..bd7fdf8 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1990,31 +1990,16 @@ static ssize_t ocfs2_file_splice_write(struct pipe_inode_info *pipe,
>  
>  	if (ret > 0) {
>  		unsigned long nr_pages;
> +		int err;
>  
> -		*ppos += ret;
>  		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>  
> -		/*
> -		 * If file or inode is SYNC and we actually wrote some data,
> -		 * sync it.
> -		 */
> -		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
> -			int err;
> -
> -			mutex_lock(&inode->i_mutex);
> -			err = ocfs2_rw_lock(inode, 1);
> -			if (err < 0) {
> -				mlog_errno(err);
> -			} else {
> -				err = generic_osync_inode(inode, mapping,
> -						  OSYNC_METADATA|OSYNC_DATA);
> -				ocfs2_rw_unlock(inode, 1);
> -			}
> -			mutex_unlock(&inode->i_mutex);
> +		err = generic_write_sync(out, *ppos, ret);
> +		if (err)
> +			ret = err;
> +		else
> +			*ppos += ret;

	You've removed the rw_lock around the sync.  Any reason why?

Joel

-- 

"A narcissist is someone better looking than you are."  
         - Gore Vidal

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
