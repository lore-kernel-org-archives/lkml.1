Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbYHTXiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbYHTXiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbYHTXiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:38:10 -0400
Received: from sandeen.net ([209.173.210.139]:15553 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbYHTXiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:38:08 -0400
Message-ID: <48ACAADD.2010104@sandeen.net>
Date: Wed, 20 Aug 2008 18:38:05 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "MASON,CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: Mount ext3 with barrier=1 doesn't send real barrier bio?
References: <48A5F5C6.2090204@redhat.com>
In-Reply-To: <48A5F5C6.2090204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz wrote:
> Hi,
> 
> I run some barrier tests over device-mapper (which currently doesn't
> support barrier bio at all) and even if I set barrier=1 in ext3 mount,
> there is never any bio with barrier flag... (in 2.6.27-rc)
> 
> How is the barrier=1 flag supposed to work in ext3 (JBD) now?

Milan, you're right.  Ric saw this same strange behavior when doing some
benchmarking with and without barriers; Chris noticed the change in
submit_bh; I was about to write up a similar patch to what you've sent
already.  Jens, does Milan's fix look good to you?

Incidentally, I ran Ric's test on ext3 on a sata drive:

# fs_mark -d /mnt/test -n 1600 -t 1 -s 20480

cfq:
                        files/s
           2.6.25   2.6.26.2  2.6.26.2+patch
barrier=0    169      127       126
barrier=1     33      126        33

noop:
                        files/s
           2.6.25   2.6.26.2  2.6.26.2+patch
barrier=0    191      184       185
barrier=1     33      180        33

deadline:
                        files/s
           2.6.25   2.6.26.2  2.6.26.2+patch
barrier=0    181      182       185
barrier=1     33      185        33

anticipatory:
                        files/s
           2.6.25   2.6.26.2  2.6.26.2+patch
barrier=0    187      133       132
barrier=1     34      134        33

-Eric

> See:
> If you specify barrier=1, JFS_BARRIER flag is set in ext3_init_journal_params
> 	journal->j_flags |= JFS_BARRIER;
> 
> Now, journal_write_commit_record is called and this happens:
> 
> 	if (journal->j_flags & JFS_BARRIER) {
> 		set_buffer_ordered(bh);
> 		barrier_done = 1;
> 	}
> 	ret = sync_dirty_buffer(bh);
> 
> 	if (barrier_done)
> 		clear_buffer_ordered(bh);
> 
> 	if (ret == -EOPNOTSUPP && barrier_done) {
> 	...
> 
> From this code I expect that EOPNOTSUPP is returned if barrier is not
> supported (yes, that exactly does device-mapper now without barrier patches).
> 
> But it *never* happens because:
> 
> sync_dirty_buffer always calls 
> 	submit_bh(WRITE_SYNC, bh)
> 
> and in submit_bh is this test:
> 
> 	if (buffer_ordered(bh) && (rw == WRITE))
> 		rw = WRITE_BARRIER;
> 
> but there is rw == WRITE_SYNC, not WRITE !
> 
> So the barrier flag for bio is never set and normal sync write
> is performed.
> 
> Why it isn't done like in attached patch? Is it intentional or it is bug?
> 
> I think it was caused by change in this commit:
> 
> commit 18ce3751ccd488c78d3827e9f6bf54e6322676fb
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Tue Jul 1 09:07:34 2008 +0200
> 
>     Properly notify block layer of sync writes
> 
> Milan
> --
> 
> Set BIO_RW_BARRIER flag even for submit_bh sync write request.
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  fs/buffer.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2926,16 +2926,16 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	BUG_ON(!buffer_mapped(bh));
>  	BUG_ON(!bh->b_end_io);
>  
> -	if (buffer_ordered(bh) && (rw == WRITE))
> -		rw = WRITE_BARRIER;
> -
>  	/*
>  	 * Only clear out a write error when rewriting, should this
>  	 * include WRITE_SYNC as well?
>  	 */
> -	if (test_set_buffer_req(bh) && (rw == WRITE || rw == WRITE_BARRIER))
> +	if (test_set_buffer_req(bh) && rw == WRITE)
>  		clear_buffer_write_io_error(bh);
>  
> +	if (buffer_ordered(bh) && ((rw & RW_MASK) == WRITE))
> +		rw |= (1 << BIO_RW_BARRIER);
> +
>  	/*
>  	 * from here on down, it's all bio -- do the initial mapping,
>  	 * submit_bio -> generic_make_request may further map this bio around
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

