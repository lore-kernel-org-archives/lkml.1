Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbYHVGii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbYHVGii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbYHVGi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:38:28 -0400
Received: from [93.163.65.50] ([93.163.65.50]:7779 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbYHVGi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:38:27 -0400
Date: Fri, 22 Aug 2008 08:38:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Eric Sandeen <sandeen@sandeen.net>, Milan Broz <mbroz@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "MASON,CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: Mount ext3 with barrier=1 doesn't send real barrier bio?
Message-ID: <20080822063823.GR20055@kernel.dk>
References: <48A5F5C6.2090204@redhat.com> <48ACAADD.2010104@sandeen.net> <874p5eqa6h.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874p5eqa6h.fsf@devron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22 2008, OGAWA Hirofumi wrote:
> Eric Sandeen <sandeen@sandeen.net> writes:
> 
> >> --- a/fs/buffer.c
> >> +++ b/fs/buffer.c
> >> @@ -2926,16 +2926,16 @@ int submit_bh(int rw, struct buffer_head * bh)
> >>  	BUG_ON(!buffer_mapped(bh));
> >>  	BUG_ON(!bh->b_end_io);
> >>  
> >> -	if (buffer_ordered(bh) && (rw == WRITE))
> >> -		rw = WRITE_BARRIER;
> >> -
> >>  	/*
> >>  	 * Only clear out a write error when rewriting, should this
> >>  	 * include WRITE_SYNC as well?
> >>  	 */
> >> -	if (test_set_buffer_req(bh) && (rw == WRITE || rw == WRITE_BARRIER))
> >> +	if (test_set_buffer_req(bh) && rw == WRITE)
> >>  		clear_buffer_write_io_error(bh);
> 
> This should be ((rw & RW_MASK) == WRITE) too?  Anyway, this seems change
> behavior of submit_bh(WRITE_BARRIER) (maybe reiserfs only), it wouldn't
> be your intent...

Yes, I believe the simpler and more correct fix is:

diff --git a/fs/buffer.c b/fs/buffer.c
index 38653e3..16b2263 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2926,14 +2926,13 @@ int submit_bh(int rw, struct buffer_head * bh)
 	BUG_ON(!buffer_mapped(bh));
 	BUG_ON(!bh->b_end_io);
 
-	if (buffer_ordered(bh) && (rw == WRITE))
+	if (buffer_ordered(bh) && (rw & WRITE))
 		rw = WRITE_BARRIER;
 
 	/*
-	 * Only clear out a write error when rewriting, should this
-	 * include WRITE_SYNC as well?
+	 * Only clear out a write error when rewriting
 	 */
-	if (test_set_buffer_req(bh) && (rw == WRITE || rw == WRITE_BARRIER))
+	if (test_set_buffer_req(bh) && (rw & WRITE))
 		clear_buffer_write_io_error(bh);
 
 	/*

-- 
Jens Axboe

