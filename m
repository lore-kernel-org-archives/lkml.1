Return-Path: <linux-kernel-owner+w=401wt.eu-S1751103AbXEXOfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbXEXOfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbXEXOfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:35:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:11668 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbXEXOfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=F2xvxO0/VfWupVesjBd+nQxEpuqHmprK2BPhopO12WiA+c5qqMub2azfNvYlJ93+RM4xtwC9ilc4JYT/h5sToBgDTxy/ulp1kDunvapXQcMgcJARV46KPyNBpQqJtT0YrmowgNGnuLWtbe4FMCdCYn6yAxydUwK/RazHvBfyt4s=
Date: Thu, 24 May 2007 18:34:35 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: UDF code style conversion to kernel style
Message-ID: <20070524143435.GA8488@cvg>
References: <20070523184436.GA14771@cvg> <20070524083714.GA27047@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524083714.GA27047@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Kara - Thu, May 24, 2007 at 10:37:14AM +0200]
| On Wed 23-05-07 22:44:36, Cyrill Gorcunov wrote:
| > This patch converts UDF system coding style to kernel coding style.
| > There is no error fixing - just code cleanup. I attempted to make
| > the minimum changes as possible but the patch was growing and growing.
| > So there is a lot of code to review and that could be painful and boring.
| > I've it reviewed several times to assure that the patch does not break
| > current UDF system... but I've only one pair of eyes.
| > 
| > Any comments, suggestions and swearing are welcome. But don't be
| > expected for fast reply - I'm not mature kernel developer ;)
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
|   Thanks for doing this tedious work... One general comment: Kernel is
| supposed to be viewable on a terminal 80 characters wide so you should
| avoid making longer lines whenever possible (I agree that there are
| cases where wrapped line looks worse that a long line but that's
| just my personal opinion ;).
| 

Jan, I think the problem is about long UDF structures names.
The only purpose for this patch is to set up braces and spaces
properly. I'll make lines shorter as soon as _this_ patch become
veryfied and included in main kernel. Moreover I also should
get rid of macroses and other stuff. Lets do work by small steps ;)
But you are absolutely right!

| >  static void udf_merge_extents(struct inode *inode,
| > -	 kernel_long_ad laarr[EXTENT_MERGE_SIZE], int *endnum)
| > +			      kernel_long_ad laarr[EXTENT_MERGE_SIZE],
| > +			      int *endnum)
| >  {
| >  	int i;
| >  
| > -	for (i=0; i<(*endnum-1); i++)
| > +	for (i = 0; i < (*endnum - 1); i++)
| >  	{
|   ^^^^^^^ the brace should be on the previous line

Thanks for note. I've it just missed.

| 
| > @@ -1283,86 +1201,74 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
| >  		offset = sizeof(struct extendedFileEntry) + UDF_I_LENEATTR(inode);
| >  	}
| >  
| > -	switch (fe->icbTag.fileType)
| > -	{
| > +	switch (fe->icbTag.fileType) {
| >  		case ICBTAG_FILE_TYPE_DIRECTORY:
| > -		{
| > -			inode->i_op = &udf_dir_inode_operations;
| > +			inode->i_op = (struct inode_operations *)&udf_dir_inode_operations;
|   ^^^ Why have you added explicit retyping?

This became from my local git branch. Thanks. Will be removed.

| 
| >  			inode->i_fop = &udf_dir_operations;
| >  			inode->i_mode |= S_IFDIR;
| >  			inc_nlink(inode);
| >  			break;
| > -		}
| >  		case ICBTAG_FILE_TYPE_REALTIME:
| >  		case ICBTAG_FILE_TYPE_REGULAR:
| >  		case ICBTAG_FILE_TYPE_UNDEF:
| > -		{
| >  			if (UDF_I_ALLOCTYPE(inode) == ICBTAG_FLAG_AD_IN_ICB)
| >  				inode->i_data.a_ops = &udf_adinicb_aops;
| >  			else
| >  				inode->i_data.a_ops = &udf_aops;
| > -			inode->i_op = &udf_file_inode_operations;
| > +			inode->i_op = (struct inode_operations *)&udf_file_inode_operations;
|   ^^^ And here again?
| 
| 
Arh!

| > -static mode_t
| > -udf_convert_permissions(struct fileEntry *fe)
| > +static int udf_alloc_i_data(struct inode *inode, size_t size)
| > +{
| > +	UDF_I_DATA(inode) = kmalloc(size, GFP_KERNEL);
| > +
| > +	if (!UDF_I_DATA(inode)) {
| > +		printk(KERN_ERR "udf:udf_alloc_i_data (ino %ld) no free memory\n",
| > +		       inode->i_ino);
| > +		return -ENOMEM;
| > +	}
| > +
| > +	return 0;
| > +}
| > +
|   It seems you've introduced a new function but never used it...

Jan I've messed up with this patch and my prev patches that already
in -mm tree. Actually udf_alloc_i_data was introduced by my prev patch.
I'll fix this mess.

| 
| 
| > @@ -1573,35 +1465,30 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
| >  	udf_find_anchor(sb);
| >  
| >  	/* Fill in the rest of the superblock */
| > -	sb->s_op = &udf_sb_ops;
| > +	sb->s_op = (struct super_operations *)&udf_sb_ops;
|   Again this explicit typing shouldn't be needed...
Damn, sorry.

| 
| 										Honza
| -- 
| Jan Kara <jack@suse.cz>
| SuSE CR Labs
| 

Andew please drop this patch. I'll make new one (over -mm tree ;)

		Cyrill

