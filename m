Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZC3PYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZC3PYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZC3PWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:22:50 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45287 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZC3PWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=snCoGiPkZs+6D0CYlOJQk31/lguj3C3SHwYJRmbz4Byp0ds2/qztlEutwUEwyqIUbl
         GVPxzQdtJPzDtQnXgiYTRVhMS1jmjQu0apxtP0grL465ITAbG+CVmuuzH1GSa3l50i5u
         iW5+vUYiQHWE72QrIR3d2BFcyBfzEVSXMH/0k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Fernando Luis =?iso-8859-1?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 7/7] reiserfs: propagate issue-flush error code
Date: Mon, 30 Mar 2009 17:25:51 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49D0B535.2010106@oss.ntt.co.jp> <49D0BCB2.30202@oss.ntt.co.jp>
In-Reply-To: <49D0BCB2.30202@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301725.55916.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
> blkdev_issue_flush() may fail (i.e. due to media error on FLUSH CACHE
> command execution) so its users should check for the return value.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.29-orig/fs/reiserfs/file.c linux-2.6.29/fs/reiserfs/file.c
> --- linux-2.6.29-orig/fs/reiserfs/file.c	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/fs/reiserfs/file.c	2009-03-30 16:19:19.000000000 +0900
> @@ -146,8 +146,9 @@ static int reiserfs_sync_file(struct fil
>   	reiserfs_write_lock(p_s_inode->i_sb);
>   	barrier_done = reiserfs_commit_for_inode(p_s_inode);
>   	reiserfs_write_unlock(p_s_inode->i_sb);
> -	if (barrier_done != 1 && reiserfs_barrier_flush(p_s_inode->i_sb))
> -		blkdev_issue_flush(p_s_inode->i_sb->s_bdev, NULL);
> +	if (!n_err && barrier_done != 1 &&
> +			reiserfs_barrier_flush(p_s_inode->i_sb))
> +		n_err = block_flush_device(p_s_inode->i_sb->s_bdev);

This is again different from my original patch
(the change in behavior should be documented).

Thanks,
Bart
