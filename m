Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbZJ2GAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbZJ2GAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 02:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZJ2GAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 02:00:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756361AbZJ2GAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 02:00:53 -0400
Date: Wed, 28 Oct 2009 23:00:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Hommey <mh@glandium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@sgi.com>,
       Josef Bacik <jbacik@redhat.com>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH] Fix generic_block_fiemap for files bigger than 4GB
Message-Id: <20091028230022.e15b1e9c.akpm@linux-foundation.org>
In-Reply-To: <1256577868-30484-1-git-send-email-mh@glandium.org>
References: <1256577868-30484-1-git-send-email-mh@glandium.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 18:24:28 +0100 Mike Hommey <mh@glandium.org> wrote:

> Because of an integer overflow on start_blk, various kind of wrong results
> would be returned by the generic_block_fiemap handler, such as no extents
> when there is a 4GB+ hole at the beginning of the file, or wrong fe_logical
> when an extent starts after the first 4GB.
> 
> Signed-off-by: Mike Hommey <mh@glandium.org>
> ---
>  fs/ioctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 7b17a14..6c75110 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -254,7 +254,7 @@ int __generic_block_fiemap(struct inode *inode,
>  			   u64 len, get_block_t *get_block)
>  {
>  	struct buffer_head tmp;
> -	unsigned int start_blk;
> +	unsigned long long start_blk;
>  	long long length = 0, map_len = 0;
>  	u64 logical = 0, phys = 0, size = 0;
>  	u32 flags = FIEMAP_EXTENT_MERGED;

Well.  Should it be unsigned long long, or u64 or sector_t?  Or even loff_t.

The code's a bit confused about types in there.  And it's made much
more confusing by the moronic and wholly unnecessary use of macros for
blk_to_logical() and logical_to_blk().

It's also unhelpful that the `u64 start' argument forgot to get itself
documented in the kerneldoc comment.  Sigh.

Ah, generic_block_fiemap() has it:

 * @start: The initial block to map

I guess u64 was logical there as it comes in from userspace.  But at
some boundary we should start talking kernel types so I suspect the
correct thing to do here is to use sector_t?

