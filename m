Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbZC3PWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbZC3PWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZC3PWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:22:43 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:46582 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZC3PWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vFHRlbvc4ix0dcK7AdbyoEEuWwnLAyyq+83+JEMJjjF0h9HAjqL4Yc3s4VoKbgagdn
         VK7aKqrK2bv0kMA0JU/+/uo00SyWu89mvQtvllPjIaK+tEvj3B/K71jaAZ2f0OENv44L
         jYmlUSa91jV7V8p8T8/1guUU0uMlu+KTStHrw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Fernando Luis =?windows-1252?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
Date: Mon, 30 Mar 2009 17:07:41 +0200
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
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp>
In-Reply-To: <49D0B687.1030407@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301707.46212.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
> This patch adds a helper function that should be used by filesystems that need
> to flush the underlying block device on fsync()/fdatasync().
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.29-orig/fs/buffer.c linux-2.6.29/fs/buffer.c
> --- linux-2.6.29-orig/fs/buffer.c	2009-03-24 08:12:14.000000000 +0900
> +++ linux-2.6.29/fs/buffer.c	2009-03-30 15:27:04.000000000 +0900
> @@ -165,6 +165,17 @@ void end_buffer_write_sync(struct buffer
>   	put_bh(bh);
>   }
> 
> +/* Issue flush of write caches on the block device */
> +int block_flush_device(struct block_device *bdev)

I don't consider this an improvement over using blkdev_issue_flush().

> +{
> +	int ret = 0;
> +
> +	ret = blkdev_issue_flush(bdev, NULL);

The problem lies in using NULL for error_sector argument which shows
a subtle deficiency of the current implementation/usage of barriers
based on a write cache flushing.

I intend to document the issue with adding the FIXME to the current
users of blkdev_issue_flush() so the problem is at least known and not
forgotten (fixing it would require some work from both block and fs
sides and unfortunately there wasn't even a willingness to discuss
possible solutions few years back when the original code was added).

Thanks,
Bart
