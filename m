Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYBEPcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYBEPcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYBEPcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:32:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:58200 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751732AbYBEPcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:32:14 -0500
Date: Tue, 5 Feb 2008 16:32:12 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] udf: create function for conversion from timestamp
	to timespec
Message-ID: <20080205153212.GG25464@duck.suse.cz>
References: <1202063771-18172-1-git-send-email-marcin.slusarz@gmail.com> <1202063771-18172-3-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202063771-18172-3-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 03-02-08 19:36:07, marcin.slusarz@gmail.com wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/inode.c |   79 ++++++++++++++++---------------------------------------
>  1 files changed, 23 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 531443d..2578677 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1151,12 +1151,24 @@ static void __udf_read_inode(struct inode *inode)
>  	brelse(bh);
>  }
>  
> +static void udf_fill_inode_time(struct timespec *tspec,
> +				const timestamp *tstamp,
> +				struct udf_sb_info *sbi)
> +{
> +	time_t convtime;
> +	long convtime_usec;
> +	if (udf_stamp_to_time(&convtime, &convtime_usec,
> +				lets_to_cpu(*tstamp))) {
> +		tspec->tv_sec = convtime;
> +		tspec->tv_nsec = convtime_usec * 1000;
> +	} else
> +		*tspec = sbi->s_record_time;
> +}
> +
>  static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  {
>  	struct fileEntry *fe;
>  	struct extendedFileEntry *efe;
> -	time_t convtime;
> -	long convtime_usec;
>  	int offset;
>  	struct udf_sb_info *sbi = UDF_SB(inode->i_sb);
>  	struct udf_inode_info *iinfo = UDF_I(inode);
> @@ -1244,29 +1256,10 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
>  			(inode->i_sb->s_blocksize_bits - 9);
>  
> -		if (udf_stamp_to_time(&convtime, &convtime_usec,
> -				      lets_to_cpu(fe->accessTime))) {
> -			inode->i_atime.tv_sec = convtime;
> -			inode->i_atime.tv_nsec = convtime_usec * 1000;
> -		} else {
> -			inode->i_atime = sbi->s_record_time;
> -		}
> -
> -		if (udf_stamp_to_time(&convtime, &convtime_usec,
> -				      lets_to_cpu(fe->modificationTime))) {
> -			inode->i_mtime.tv_sec = convtime;
> -			inode->i_mtime.tv_nsec = convtime_usec * 1000;
> -		} else {
> -			inode->i_mtime = sbi->s_record_time;
> -		}
> -
> -		if (udf_stamp_to_time(&convtime, &convtime_usec,
> -				      lets_to_cpu(fe->attrTime))) {
> -			inode->i_ctime.tv_sec = convtime;
> -			inode->i_ctime.tv_nsec = convtime_usec * 1000;
> -		} else {
> -			inode->i_ctime = sbi->s_record_time;
> -		}
> +		udf_fill_inode_time(&inode->i_atime, &fe->accessTime, sbi);
> +		udf_fill_inode_time(&inode->i_mtime, &fe->modificationTime,
> +				    sbi);
> +		udf_fill_inode_time(&inode->i_ctime, &fe->attrTime, sbi);
>  
>  		iinfo->i_unique = le64_to_cpu(fe->uniqueID);
>  		iinfo->i_lenEAttr = le32_to_cpu(fe->lengthExtendedAttr);
> @@ -1276,37 +1269,11 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  		inode->i_blocks = le64_to_cpu(efe->logicalBlocksRecorded) <<
>  		    (inode->i_sb->s_blocksize_bits - 9);
>  
> -		if (udf_stamp_to_time(&convtime, &convtime_usec,
> -				      lets_to_cpu(efe->accessTime))) {
> -			inode->i_atime.tv_sec = convtime;
> -			inode->i_atime.tv_nsec = convtime_usec * 1000;
> -		} else {
> -			inode->i_atime = sbi->s_record_time;
> -		}
> -
> -		if (udf_stamp_to_time(&convtime, &convtime_usec,
> -				      lets_to_cpu(efe->modificationTime))) {
> -			inode->i_mtime.tv_sec = convtime;
> -			inode->i_mtime.tv_nsec = convtime_usec * 1000;
> -		} else {
> -			inode->i_mtime = sbi->s_record_time;
> -		}
> -
> -		if (udf_stamp_to_time(&convtime, &convtime_usec,
> -				      lets_to_cpu(efe->createTime))) {
> -			iinfo->i_crtime.tv_sec = convtime;
> -			iinfo->i_crtime.tv_nsec = convtime_usec * 1000;
> -		} else {
> -			iinfo->i_crtime = sbi->s_record_time;
> -		}
> -
> -		if (udf_stamp_to_time(&convtime, &convtime_usec,
> -				      lets_to_cpu(efe->attrTime))) {
> -			inode->i_ctime.tv_sec = convtime;
> -			inode->i_ctime.tv_nsec = convtime_usec * 1000;
> -		} else {
> -			inode->i_ctime = sbi->s_record_time;
> -		}
> +		udf_fill_inode_time(&inode->i_atime, &efe->accessTime, sbi);
> +		udf_fill_inode_time(&inode->i_mtime, &efe->modificationTime,
> +				    sbi);
> +		udf_fill_inode_time(&iinfo->i_crtime, &efe->createTime, sbi);
> +		udf_fill_inode_time(&inode->i_ctime, &efe->attrTime, sbi);
>  
>  		iinfo->i_unique = le64_to_cpu(efe->uniqueID);
>  		iinfo->i_lenEAttr = le32_to_cpu(efe->lengthExtendedAttr);
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
