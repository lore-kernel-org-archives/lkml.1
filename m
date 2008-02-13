Return-Path: <linux-kernel-owner+w=401wt.eu-S1763758AbYBMJYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763758AbYBMJYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYBMJYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:24:22 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:41953 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752508AbYBMJYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:24:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=m8zJpFF7f7/B7BQ1LHw+JVpxMxId3tzRnY2v9BLPLhmXQGzZCdH8LGRKuRmNoN3P+w7XW4tL7IQRjZPaFGyG4W9emmjk/Ugvpr/VW7l+7XUVG3SqN7FOrLhqAolkuKp65oJwFk+wFzWp7b+dWS+3fIDvcLeO5bAa7IgLLQr+tX4=  ;
X-YMail-OSG: WbqzYwwVM1kEYno0tpjX_NAjZluK4K_l6VFnCMpYGhENFevePjhfEIS.y36f89a4Jk6diHnYgw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel BUG at fs/mpage.c:489
Date: Wed, 13 Feb 2008 20:24:03 +1100
User-Agent: KMail/1.9.5
Cc: Bart Dopheide <dopheide@fmf.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Bartlomiej Zolnierkiewicz <mzolnier@gmail.com>
References: <20080212194546.GA2174@fmf.nl> <20080213072627.GB2174@fmf.nl> <20080213010145.76ee9714.akpm@linux-foundation.org>
In-Reply-To: <20080213010145.76ee9714.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132024.03687.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 20:01, Andrew Morton wrote:
> On Wed, 13 Feb 2008 08:26:27 +0100 Bart Dopheide <dopheide@fmf.nl> wrote:
> > On Wed, Feb 13, 2008 at 12:05:45PM +1100, Nick Piggin wrote:
> > :)On Wednesday 13 February 2008 08:50, Alan Cox wrote:
> > :)> Almost certainly a hardware fail of some sort.
> > :)
> > :)Right, but the kernel shouldn't go bug...
> >
> > Indeed, that's why I'm reporting.
> >
> > :)I don't have a copy of your exact source code... which condition in
> > :)__mpage_writepage went BUG?
> >
> > BUG_ON(buffer_locked(bh));
> >
> > In a bit of context:
> > 482:    if (page_has_buffers(page)) {
> > 483:            struct buffer_head *head = page_buffers(page);
> > 484:            struct buffer_head *bh = head;
> > 485:
> > 486:            /* If they're all mapped and dirty, do it */
> > 487:            page_block = 0;
> > 488:            do {
> > 489:                    BUG_ON(buffer_locked(bh));
> > 490:                    if (!buffer_mapped(bh)) {
> > 491:                            /*
> > 492:                             * unmapped dirty buffers are created by
> > 493:                             * __set_page_dirty_buffers -> mmapped
> > data 494:                             */
> > 495:                            if (buffer_dirty(bh))
> > 496:                                    goto confused;
> > 497:                            if (first_unmapped == blocks_per_page)
> > 498:                                    first_unmapped = page_block;
> > 499:                            continue;
> > 500:                    }
>
> Probably means that either fat, IDE, block or fs/buffer.c failed to unlock
> a buffer_head when the IO error happened.  It's unlikely to be fat.

Yes that looks like it would be the problem. I can't really
see anything in buffer.c that would do it... 

BTW is it really true that the buffer can never be locked by
anything else at this point? What about fsync_buffers_list?
