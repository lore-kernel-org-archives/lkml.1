Return-Path: <linux-kernel-owner+w=401wt.eu-S1764708AbXGJXec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764708AbXGJXec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762670AbXGJXb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:31:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763310AbXGJXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:31:26 -0400
Date: Tue, 10 Jul 2007 16:31:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 3/5] i_version:ext4 inode version read/store
Message-Id: <20070710163117.d14fce90.akpm@linux-foundation.org>
In-Reply-To: <1183275456.4010.129.camel@localhost.localdomain>
References: <1183275456.4010.129.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:37:36 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> This patch adds 64-bit inode version support to ext4. The lower 32 bits
> are stored in the osd1.linux1.l_i_version field while the high 32 bits
> are stored in the i_version_hi field newly created in the ext4_inode.

So reading the code here does serve to answer the question I raised against
the earlier patch.  A bit.

I'd have thought that this patch and the one which adds i_version_hi should
be folded into a single diff?

> 
> Index: linux-2.6.21/fs/ext4/inode.c
> ===================================================================
> --- linux-2.6.21.orig/fs/ext4/inode.c
> +++ linux-2.6.21/fs/ext4/inode.c
> @@ -2709,6 +2709,13 @@ void ext4_read_inode(struct inode * inod
>  	EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
>  	EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
> 
> +	inode->i_version = le32_to_cpu(raw_inode->i_disk_version);
> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
> +		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
> +			inode->i_version |=
> +			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;

<checks the precedence of "(type)" versus "<<">

<OK>

> +	}

I don't quite see how the above two tests are sufficient to unambiguously
determine that the i_version_hi field is present on-disk.

I guess we're implicitly assuming that if the on-disk inode is big enough
then it _must_ have i_version_hi in there?  If so, why is the comparison
with EXT4_GOOD_OLD_INODE_SIZE needed?

Some description of the overall approach to inode version identification
would be helpful here.

>  	if (S_ISREG(inode->i_mode)) {
>  		inode->i_op = &ext4_file_inode_operations;
>  		inode->i_fop = &ext4_file_operations;
> @@ -2852,8 +2859,14 @@ static int ext4_do_update_inode(handle_t
>  	} else for (block = 0; block < EXT4_N_BLOCKS; block++)
>  		raw_inode->i_block[block] = ei->i_data[block];
> 
> -	if (ei->i_extra_isize)
> +	raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
> +	if (ei->i_extra_isize) {
> +		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi)) {

There's no comparison with EXT4_GOOD_OLD_INODE_SIZE here...

> +			raw_inode->i_version_hi =
> +				cpu_to_le32(inode->i_version >> 32);
> +		}
>  		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
> +	}
> 

