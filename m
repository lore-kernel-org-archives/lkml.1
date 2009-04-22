Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZDVVMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZDVVMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 17:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZDVVMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 17:12:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820AbZDVVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 17:12:22 -0400
Date: Wed, 22 Apr 2009 14:10:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: add roundup_to_blocksize and bytes_to_blocks helper
 functions
Message-Id: <20090422141035.efbb1540.akpm@linux-foundation.org>
In-Reply-To: <49EB7087.70302@gmail.com>
References: <49EB7087.70302@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Apr 2009 20:42:15 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> bytes_to_blocks is open coded in more than 30 places
> roundup_to_blocksize is open coded in more than 15 places
> 

It would be nice to document these a bit.  Kernel-wide helpers..

> ---
>  include/linux/fs.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e766be0..1b4e5b6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2451,5 +2451,17 @@ int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
>  
>  int get_filesystem_list(char * buf);
>  
> +static inline
> +unsigned long long roundup_to_blocksize(unsigned long long bytes, struct super_block *sb)
> +{
> +	return (bytes + sb->s_blocksize - 1) & ~(sb->s_blocksize - 1);

This is ALIGN(bytes, sb->s_blocksize).  Dunno if that's any clearer though.

> +}
> +
> +static inline
> +blkcnt_t bytes_to_blocks(unsigned long long bytes, struct super_block *sb)
> +{
> +	return (bytes + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> +}

I wonder whether `unsigned long long' was the best choice of type here.

Probably `bytes' should be loff_t.

roundup_to_blocksize() could/should return loff_t too, I think.

roundup_to_blocksize() isn't a terribly good name, IMO.  The name
conveys no sense of what the function returns.  It _sounds_ like it
returns a "block size".  But it doesn't - it returns a loff_t. 
round_up_file_offset_to_block_size() is a bit long though :(


