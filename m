Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYL3TgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYL3TgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 14:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYL3Tfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 14:35:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbYL3Tfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 14:35:52 -0500
Date: Tue, 30 Dec 2008 11:35:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: kmannth@us.ibm.com, linux-kernel@vger.kernel.org, sekharan@us.ibm.com
Subject: Re: [Patch][RFC] Supress Buffer I/O errors when SCSI REQ_QUIET flag
 set
Message-Id: <20081230113514.fe09d495.akpm@linux-foundation.org>
In-Reply-To: <20081125091917.GU26308@kernel.dk>
References: <1227561983.6487.32.camel@keith-laptop>
	<20081125091917.GU26308@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 10:19:18 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Nov 24 2008, Keith Mannthey wrote:
> > Allow the scsi request REQ_QUIET flag to be propagated to the buffer
> > file system layer. The basic ideas is to pass the flag from the scsi
> > request to the bio (block IO) and then to the buffer layer.  The buffer
> > layer can then suppress needless printks. 
> > 
> > This patch declutters the kernel log by removed the 40-50 (per lun)
> > buffer io error messages seen during a boot in my multipath setup . It
> > is a good chance any real errors will be missed in the "noise" it the
> > logs without this patch. 
> > 
> > During boot I see blocks of messages like 
> > "
> > __ratelimit: 211 callbacks suppressed
> > Buffer I/O error on device sdm, logical block 5242879
> > Buffer I/O error on device sdm, logical block 5242879
> > Buffer I/O error on device sdm, logical block 5242847
> > Buffer I/O error on device sdm, logical block 1
> > Buffer I/O error on device sdm, logical block 5242878
> > Buffer I/O error on device sdm, logical block 5242879
> > Buffer I/O error on device sdm, logical block 5242879
> > Buffer I/O error on device sdm, logical block 5242879
> > Buffer I/O error on device sdm, logical block 5242879
> > Buffer I/O error on device sdm, logical block 5242872
> > "
> > in my logs. 
> > 
> > My disk environment is multipath fiber channel using the SCSI_DH_RDAC
> > code and multipathd.  This topology includes an "active" and "ghost"
> > path for each lun. IO's to the "ghost" path will never complete and the
> > SCSI layer, via the scsi device handler rdac code, quick returns the IOs
> > to theses paths and sets the REQ_QUIET scsi flag to suppress the scsi
> > layer messages. 
> > 
> >  I am wanting to extend the QUIET behavior to include the buffer file
> > system layer to deal with these errors as well. I have been running this
> > patch for a while now on several boxes without issue.  A few runs of
> > bonnie++ show no noticeable difference in performance in my setup. 
> > 
> > Thanks for John Stultz for the quiet_error finalization. 
> 
> Looks good to me. I'll merge it up for 2.6.29.

So a month later this turns up in linux-next.  During the merge
window, giving a nice pile of rejects to keep me amused.

Can we do better than this, please?  A lot?

> +static int quiet_error(struct buffer_head *bh)
> +{
> +       if (!test_bit(BH_Quiet, &bh->b_state) && printk_ratelimit())
> +               return 0;
> +       return 1;
> +}
> 

For better of for worse, we have a convention of using cpp-generated
helper functions for the buffer_head flags.  There's no reason why this
new code needs to diverge from that.  The above should use buffer_quiet().

The functions in fs/buffer.c have been nicely commented.

This function is poorly named.  What does "quiet_error" *mean*?

<tries to work it out>

Every caller of this function does `if (!quiet_error(bh))'.  Would it
not make more sense to invert the sense of its return value?

static int permit_bh_errors(struct buffer_head *bh)
{
	if (buffer_quiet(bh))
		return 0;	/* IO layer suppressed error messages */
	return printk_ratelimit();
}

Did I translate that right?  If so, then the addition of the
printk_ratelimit() to the non-buffer_quiet() buffers is an
unchangelogged and unrelated alteration.

The use of printk_ratelimit() needs some thought.  It shares
ratelimiting state with all other printk_ratelimit() callsites.  Was
that desirable?  Would it have been better to create a private
ratelimit_state for buffer_heads?  Per physical device?  Per
something-else?


> +       if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
> +               set_bit(BH_Quiet, &bh->b_state);

And the above (which has coding-style errors and has apparently not been
checkpatched) should use set_buffer_quiet().


> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -35,6 +35,7 @@ enum bh_state_bits {
>         BH_Ordered,     /* ordered write */
>         BH_Eopnotsupp,  /* operation not supported (barrier) */
>         BH_Unwritten,   /* Buffer is allocated on disk but not written */
> +       BH_Quiet,       /* Buffer Error Prinks to be quiet */
>  
>         BH_PrivateStart,/* not a state bit, but the first bit available
>                          * for private allocation by other entities

Add

+ BUFFER_FNS(Quiet, quiet)

around line 123 to generate the helper functions.

