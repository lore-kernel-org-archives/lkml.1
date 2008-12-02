Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYLBNiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYLBNiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYLBNiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:38:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:50332 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753284AbYLBNiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:38:06 -0500
Date: Tue, 2 Dec 2008 14:38:03 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] udf: fix default mode and dmode options handling
Message-ID: <20081202133803.GA24562@duck.suse.cz>
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au> <49332545.5020604@free.fr> <20081201001854.GA9881@joi> <49343AC2.3010808@free.fr> <20081201232227.GA7925@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201232227.GA7925@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02-12-08 00:22:31, Marcin Slusarz wrote:
> On Mon, Dec 01, 2008 at 08:28:02PM +0100, Laurent Riffard wrote:
> > >> With next-2008-11-28, I was unable to mount an UDF-formatted DVD-RW:
> > > Can you check whether attached patch fixes it?
> > Current kernel is next-20081128 + reiser4 patches + your patch: it seems to works well now.
> > (...)
> > Tested-by: Laurent Riffard <laurent.riffard@free.fr>
> 
> Thanks!
> 
> Jan, please apply this patch:
  OK, committed.

									Honza

> ---
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH] udf: fix default mode and dmode options handling
> 
> On x86 (and several other archs) mode_t is defined as "unsigned short"
> and comparing unsigned shorts to negative ints is broken (because short
> is promoted to int and then compared). Fix it.
> 
> Reported-and-tested-by: Laurent Riffard <laurent.riffard@free.fr>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> ---
>  fs/udf/inode.c  |    4 ++--
>  fs/udf/super.c  |    8 ++++----
>  fs/udf/udf_sb.h |    2 ++
>  3 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 6612a27..2d7e56a 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1222,10 +1222,10 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
>  	iinfo->i_lenExtents = inode->i_size;
>  
>  	if (fe->icbTag.fileType != ICBTAG_FILE_TYPE_DIRECTORY &&
> -			sbi->s_fmode != -1)
> +			sbi->s_fmode != UDF_INVALID_MODE)
>  		inode->i_mode = sbi->s_fmode;
>  	else if (fe->icbTag.fileType == ICBTAG_FILE_TYPE_DIRECTORY &&
> -			sbi->s_dmode != -1)
> +			sbi->s_dmode != UDF_INVALID_MODE)
>  		inode->i_mode = sbi->s_dmode;
>  	else
>  		inode->i_mode = udf_convert_permissions(fe);
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index e5d121d..8deaa61 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -284,9 +284,9 @@ static int udf_show_options(struct seq_file *seq, struct vfsmount *mnt)
>  		seq_printf(seq, ",gid=%u", sbi->s_gid);
>  	if (sbi->s_umask != 0)
>  		seq_printf(seq, ",umask=%o", sbi->s_umask);
> -	if (sbi->s_fmode != -1)
> +	if (sbi->s_fmode != UDF_INVALID_MODE)
>  		seq_printf(seq, ",mode=%o", sbi->s_fmode);
> -	if (sbi->s_dmode != -1)
> +	if (sbi->s_dmode != UDF_INVALID_MODE)
>  		seq_printf(seq, ",dmode=%o", sbi->s_dmode);
>  	if (UDF_QUERY_FLAG(sb, UDF_FLAG_SESSION_SET))
>  		seq_printf(seq, ",session=%u", sbi->s_session);
> @@ -1894,8 +1894,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
>  	uopt.uid = -1;
>  	uopt.gid = -1;
>  	uopt.umask = 0;
> -	uopt.fmode = -1;
> -	uopt.dmode = -1;
> +	uopt.fmode = UDF_INVALID_MODE;
> +	uopt.dmode = UDF_INVALID_MODE;
>  
>  	sbi = kzalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
>  	if (!sbi)
> diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
> index 5d32c60..158221e 100644
> --- a/fs/udf/udf_sb.h
> +++ b/fs/udf/udf_sb.h
> @@ -48,6 +48,8 @@
>  #define UDF_SPARABLE_MAP15		0x1522U
>  #define UDF_METADATA_MAP25		0x2511U
>  
> +#define UDF_INVALID_MODE		((mode_t)-1)
> +
>  #pragma pack(1) /* XXX(hch): Why?  This file just defines in-core structures */
>  
>  struct udf_meta_data {
> -- 
> 1.5.6.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
