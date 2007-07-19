Return-Path: <linux-kernel-owner+w=401wt.eu-S934605AbXGSDSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605AbXGSDSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbXGSDS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:18:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659AbXGSDS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:18:27 -0400
Date: Wed, 18 Jul 2007 20:18:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andreas Dilger <adilger@clusterfs.com>,
       lkml <linux-kernel@vger.kernel.org>, ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext2 statfs improvement for block and inode free count
Message-Id: <20070718201808.ccc7bdf5.akpm@linux-foundation.org>
In-Reply-To: <1184377014.15968.14.camel@dyn9047017100.beaverton.ibm.com>
References: <1184377014.15968.14.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 18:36:54 -0700 Badari Pulavarty <pbadari@us.ibm.com> wrote:

> More statfs() improvements for ext2. ext2 already maintains
> percpu counters for free blocks and inodes. Derive free
> block count and inode count by summing up percpu counters,
> instead of counting up all the groups in the filesystem
> each time.
> 

hm, another speedup patch with no measurements which demonstrate its
benefit.

> 
> Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
> Acked-by: Andreas Dilger <adilger@clusterfs.com>
> 
>  fs/ext2/super.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22/fs/ext2/super.c
> ===================================================================
> --- linux-2.6.22.orig/fs/ext2/super.c	2007-07-13 20:06:38.000000000 -0700
> +++ linux-2.6.22/fs/ext2/super.c	2007-07-13 20:06:51.000000000 -0700
> @@ -1136,12 +1136,12 @@ static int ext2_statfs (struct dentry * 
>  	buf->f_type = EXT2_SUPER_MAGIC;
>  	buf->f_bsize = sb->s_blocksize;
>  	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead;
> -	buf->f_bfree = ext2_count_free_blocks(sb);
> + 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
>  	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
>  	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
>  		buf->f_bavail = 0;
>  	buf->f_files = le32_to_cpu(es->s_inodes_count);
> -	buf->f_ffree = ext2_count_free_inodes(sb);
> + 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
>  	buf->f_namelen = EXT2_NAME_LEN;
>  	fsid = le64_to_cpup((void *)es->s_uuid) ^
>  	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
> 

Well there's a tradeoff here.  At large CPU counts, percpu_counter_sum()
becomes quite expensive - it takes a global lock and then goes off fishing
in every CPU's percpu_alloced memory.

So there is some value of (num_online_cpus / sb->s_groups_count) at which
this change becomes a loss.  Where does that value lie?

Bear in mind that the global lock in percpu_counter_sum() will tilt the
scales quite a bit.

