Return-Path: <linux-kernel-owner+w=401wt.eu-S935710AbYBHSLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935710AbYBHSLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934798AbYBHSKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:10:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43370 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935667AbYBHSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:10:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eHwDISDdxEBP7ZUhQ63er1nATPj4hNixRtVu+YOYyb+p8PdFI/aNNBpqrB+6lldbnDgSjmR20WDGssNI5gycCF0pvL941nrioAI7hWzef1CGJZ9mneY26ahoIvu96t5jkYX2USYe+hcsSFHeUVtl65MhIxmDYAuR7auGHnO9tas=
Message-ID: <6101e8c40802081010w64d1c7act8b98694a029a325@mail.gmail.com>
Date: Fri, 8 Feb 2008 19:10:12 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] splice: missing user pointer access verification (CVE-2008-0009/10)
Cc: torvalds@linux-foundation.org, "Jens Axboe" <jens.axboe@oracle.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, cliph@research.coseinc.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <6101e8c40802080948x9e425ar28842a78801e9a35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0802051044200.29525@mjc.redhat.com>
	 <20080205165301.1e0b8ad8.akpm@linux-foundation.org>
	 <20080206095510.GA15220@kernel.dk> <20080207223146.GI19310@kroah.com>
	 <20080208160203.GB23197@kernel.dk> <20080208164914.GB17072@kroah.com>
	 <6101e8c40802080948x9e425ar28842a78801e9a35@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmm, when I good see, this is not for .22, and it (vmsplice_to_user)
is came with .23

On 2/8/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> greg it's for .22 or the splice is changed between .22 and .23?
>
> On 2/8/08, Greg KH <greg@kroah.com> wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> >
> > vmsplice_to_user() must always check the user pointer and length
> > with access_ok() before copying. Likewise, for the slow path of
> > copy_from_user_mmap_sem() we need to check that we may read from
> > the user region.
> >
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > Cc: Wojciech Purczynski <cliph@research.coseinc.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >
> > Linus, this fixes a security hole in splice that is now public.  I have
> > it queued up for the .23 and .24 -stable releases as well.
> >
> >  fs/splice.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/splice.c b/fs/splice.c
> > index 4ee49e8..14e2262 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -1179,6 +1179,9 @@ static int copy_from_user_mmap_sem(void *dst, const
> > void __user *src, size_t n)
> >  {
> >  	int partial;
> >
> > +	if (!access_ok(VERIFY_READ, src, n))
> > +		return -EFAULT;
> > +
> >  	pagefault_disable();
> >  	partial = __copy_from_user_inatomic(dst, src, n);
> >  	pagefault_enable();
> > @@ -1387,6 +1390,11 @@ static long vmsplice_to_user(struct file *file,
> const
> > struct iovec __user *iov,
> >  			break;
> >  		}
> >
> > +		if (unlikely(!access_ok(VERIFY_WRITE, base, len))) {
> > +			error = -EFAULT;
> > +			break;
> > +		}
> > +
> >  		sd.len = 0;
> >  		sd.total_len = len;
> >  		sd.flags = flags;
> > --
> > 1.5.4.22.g7a20
> >
> >
> > --
> > Jens Axboe
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
