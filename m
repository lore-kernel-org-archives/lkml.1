Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYHVHqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYHVHqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbYHVHqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:46:01 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:36401 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYHVHqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:46:00 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Milan Broz <mbroz@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "MASON\,CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: Mount ext3 with barrier=1 doesn't send real barrier bio?
References: <48A5F5C6.2090204@redhat.com> <48ACAADD.2010104@sandeen.net>
	<874p5eqa6h.fsf@devron.myhome.or.jp>
	<20080822063823.GR20055@kernel.dk>
Date: Fri, 22 Aug 2008 16:45:54 +0900
In-Reply-To: <20080822063823.GR20055@kernel.dk> (Jens Axboe's message of "Fri,
	22 Aug 2008 08:38:24 +0200")
Message-ID: <87pro1xzkd.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> This should be ((rw & RW_MASK) == WRITE) too?  Anyway, this seems change
>> behavior of submit_bh(WRITE_BARRIER) (maybe reiserfs only), it wouldn't
>> be your intent...
>
> Yes, I believe the simpler and more correct fix is:
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 38653e3..16b2263 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2926,14 +2926,13 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	BUG_ON(!buffer_mapped(bh));
>  	BUG_ON(!bh->b_end_io);
>  
> -	if (buffer_ordered(bh) && (rw == WRITE))
> +	if (buffer_ordered(bh) && (rw & WRITE))
>  		rw = WRITE_BARRIER;

I see. But, umm..., this means WRITE_SYNC with barrier was deprecated?
Or typo?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
