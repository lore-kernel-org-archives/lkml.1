Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbZAABKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbZAABKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 20:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZAABKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 20:10:06 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35979 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZAABKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 20:10:03 -0500
Subject: Re: [Patch][RFC] Supress Buffer I/O errors when SCSI REQ_QUIET
	flag set
From: Keith Mannthey <kmannth@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       sekharan@us.ibm.com
In-Reply-To: <20081230113514.fe09d495.akpm@linux-foundation.org>
References: <1227561983.6487.32.camel@keith-laptop>
	 <20081125091917.GU26308@kernel.dk>
	 <20081230113514.fe09d495.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 17:10:00 -0800
Message-Id: <1230772200.6558.23.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-30 at 11:35 -0800, Andrew Morton wrote:
> On Tue, 25 Nov 2008 10:19:18 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, Nov 24 2008, Keith Mannthey wrote:

<snip>

> > +static int quiet_error(struct buffer_head *bh)
> > +{
> > +       if (!test_bit(BH_Quiet, &bh->b_state) && printk_ratelimit())
> > +               return 0;
> > +       return 1;
> > +}
> > 
> 
> For better of for worse, we have a convention of using cpp-generated
> helper functions for the buffer_head flags.  There's no reason why this
> new code needs to diverge from that.  The above should use buffer_quiet().
> 
> The functions in fs/buffer.c have been nicely commented.
> 
> This function is poorly named.  What does "quiet_error" *mean*?

There were only theses handful or errors that I encounter in my setup.
"quite_error" in my mind was to meant to mean that the error message
could be suppressed by the new BH_Quiet flag.  

> <tries to work it out>
> 
> Every caller of this function does `if (!quiet_error(bh))'.  Would it
> not make more sense to invert the sense of its return value?
> 
> static int permit_bh_errors(struct buffer_head *bh)
> {
> 	if (buffer_quiet(bh))
> 		return 0;	/* IO layer suppressed error messages */
> 	return printk_ratelimit();
> }
> 
> Did I translate that right?  If so, then the addition of the
> printk_ratelimit() to the non-buffer_quiet() buffers is an
> unchangelogged and unrelated alteration.

I will remove the mucking with of the printk_ratelimit as to not disturb
its current implementation. 

> The use of printk_ratelimit() needs some thought.  It shares
> ratelimiting state with all other printk_ratelimit() callsites.  Was
> that desirable?  Would it have been better to create a private
> ratelimit_state for buffer_heads?  Per physical device?  Per
> something-else?

It is unclear to me so I will refrain from touching it. 

> 
> > +       if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
> > +               set_bit(BH_Quiet, &bh->b_state);
> 
> And the above (which has coding-style errors and has apparently not been
> checkpatched) should use set_buffer_quiet().
 
sorry about that :( 
 
> 
> > --- a/include/linux/buffer_head.h
> > +++ b/include/linux/buffer_head.h
> > @@ -35,6 +35,7 @@ enum bh_state_bits {
> >         BH_Ordered,     /* ordered write */
> >         BH_Eopnotsupp,  /* operation not supported (barrier) */
> >         BH_Unwritten,   /* Buffer is allocated on disk but not written */
> > +       BH_Quiet,       /* Buffer Error Prinks to be quiet */
> >  
> >         BH_PrivateStart,/* not a state bit, but the first bit available
> >                          * for private allocation by other entities
> 
> Add
> 
> + BUFFER_FNS(Quiet, quiet)
> 
> around line 123 to generate the helper functions.

Thanks for the review and information about the helper functions.  It
will be Monday before I will be able to retest/resend a new patch. 

Thanks,
  Keith Mannthey
  

