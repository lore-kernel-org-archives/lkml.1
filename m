Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbYBZR0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbYBZR0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYBZRZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:25:53 -0500
Received: from keil-draco.com ([216.193.185.50]:49250 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYBZRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:25:52 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
Date: Tue, 26 Feb 2008 12:25:41 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Nix <nix@esperi.org.uk>, Peter Osterlund <petero2@telia.com>,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       Jan Kara <jack@ucw.cz>
References: <87wsovkth5.fsf@hades.wkstn.nix> <20080225224807.GA15700@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802261225.41724.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 06:10:34 Jiri Kosina wrote:
> On Mon, 25 Feb 2008, Jan Kara wrote:
> >   Yes, exactly two of them. One is  non-trivial to get rid of - it's
> > used for encoding of filename before we write it,
>
> Why can't we do just
>
>
>
> UDF: Optimize stack usage
>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 112a5fb..706a2b5 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -336,7 +336,7 @@ static struct fileIdentDesc *udf_add_entry(struct inode
> *dir, {
>  	struct super_block *sb = dir->i_sb;
>  	struct fileIdentDesc *fi = NULL;
> -	char name[UDF_NAME_LEN], fname[UDF_NAME_LEN];
> +	char *name, *fname;
>  	int namelen;
>  	loff_t f_pos;
>  	int flen;
> @@ -352,6 +352,14 @@ static struct fileIdentDesc *udf_add_entry(struct
> inode *dir, struct extent_position epos = {};
>  	struct udf_inode_info *dinfo;
>
> +	name = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> +	fname = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> +
> +	if (!name || !fname) {
> +		*err = -ENOMEM;
> +		return NULL;
> +	}
> +

Wouldn't it be better to check each individually, so you do wind up leaking a 
buffer here if one gets allocated and the other doesn't ?

>  	if (dentry) {
>  		if (!dentry->d_name.len) {
>  			*err = -EINVAL;
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index f3ac4ab..42e3ba8 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1345,7 +1345,7 @@ static void udf_load_logicalvolint(struct super_block
> *sb, kernel_extent_ad loc) *	July 1, 1997 - Andrew E. Mileski
>   *	Written, tested, and released.
>   */
> -static int udf_process_sequence(struct super_block *sb, long block,
> +static int noinline udf_process_sequence(struct super_block *sb, long
> block, long lastblock, kernel_lb_addr *fileset)
>  {
>  	struct buffer_head *bh = NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
