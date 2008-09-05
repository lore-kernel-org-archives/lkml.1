Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYIEFjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYIEFjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYIEFjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:39:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYIEFjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:39:09 -0400
Date: Thu, 4 Sep 2008 22:38:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, snakebyte@gmx.de
Subject: Re: __getblk infinite loop
Message-Id: <20080904223836.54fbabb1.akpm@linux-foundation.org>
In-Reply-To: <20080905032411.GB13208@hash.localnet>
References: <20080905032411.GB13208@hash.localnet>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 23:24:11 -0400 Bob Copeland <me@bobcopeland.com> wrote:

> Hi all,
> 
> Eric Sesterhenn and I were puzzling over a lockup found by his fsfuzzer.
> 
> sb_bread() calls __getblk, which says:
> 
> /*
>  * __getblk will locate (and, if necessary, create) the buffer_head
>  * which corresponds to the passed block_device, block and size. The
>  * returned buffer has its reference count incremented.
>  *
>  * __getblk() cannot fail - it just keeps trying.  If you pass it an
>  * illegal block number, __getblk() will happily return a buffer_head
>  * which represents the non-existent block.  Very weird.
>  *
>  * __getblk() will lock up the machine if grow_dev_page's try_to_free_buffers()
>  * attempt is failing.  FIXME, perhaps?
>  */
> 
> In fact the following will cause an infinite loop when mounting omfs 
> loopback (on 32 bit x86 at least):
> 
> diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
> index a95fe59..80eacc8 100644
> --- a/fs/omfs/inode.c
> +++ b/fs/omfs/inode.c
> @@ -413,6 +413,15 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
>  	sector_t start;
>  	int ret = -EINVAL;
>  
> +	if (1) {
> +		sector_t foo = 0x1d4000004ULL;
> +
> +		sb_set_blocksize(sb, 2048);
> +		bh = sb_bread(sb, foo);
> +		brelse(bh);
> +		goto end;
> +	}
> +
>  	save_mount_options(sb, (char *) data);
>  
>  	sbi = kzalloc(sizeof(struct omfs_sb_info), GFP_KERNEL);
> 
> What's supposed to happen here?  I would have thought that sb_bread
> would realize foo was outside the block dev and bail out, but instead
> it just gets stuck.  Do I need to bounds-check anything passed to
> sb_bread?

That loop does lock up on people occasionally - last time was in isofs,
because it had done an insane set_blocksize() earlier on.

Yes, it's always a case of garbage in, garbage out (or nothing out, as
the case may be).

No, it's not particularly programmer-friendly behaviour.

