Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZEAFsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZEAFsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZEAFrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:47:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54756 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZEAFru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:47:50 -0400
Date: Fri, 1 May 2009 07:47:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/6] kill-the-BKL/reiserfs: release the write lock
	inside reiserfs_read_bitmap_block()
Message-ID: <20090501054734.GE5983@elte.hu>
References: <1241145862-21700-1-git-send-email-fweisbec@gmail.com> <1241145862-21700-6-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241145862-21700-6-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> reiserfs_read_bitmap_block() uses sb_bread() to read the bitmap block. This
> helper might sleep.
> 
> Then, when the bkl was used, it was released at this point. We can then
> relax the write lock too here.
> 
> [ Impact: release the reiserfs write lock when it is not needed ]
> 
> Cc: Jeff Mahoney <jeffm@suse.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  fs/reiserfs/bitmap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
> index 1470334..6854957 100644
> --- a/fs/reiserfs/bitmap.c
> +++ b/fs/reiserfs/bitmap.c
> @@ -1249,7 +1249,9 @@ struct buffer_head *reiserfs_read_bitmap_block(struct super_block *sb,
>  	else if (bitmap == 0)
>  		block = (REISERFS_DISK_OFFSET_IN_BYTES >> sb->s_blocksize_bits) + 1;
>  
> +	reiserfs_write_unlock(sb);
>  	bh = sb_bread(sb, block);
> +	reiserfs_write_lock(sb);
>  	if (bh == NULL)
>  		reiserfs_warning(sb, "sh-2029: %s: bitmap block (#%u) "
>  		                 "reading failed", __func__, block);

Note, there's a side-effect here: the access to sb->b_blocksize is 
moved outside of the lock. Previously it was accessed via the BKL. 
On a mounted filesystem sb->b_blocksize is not supposed to change, 
so it's probably not an issue - but wanted to mention it.

	Ingo
