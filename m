Return-Path: <linux-kernel-owner+w=401wt.eu-S1761740AbYEAPO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740AbYEAPO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760007AbYEAPOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:14:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:52748 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486AbYEAPOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a1S9ERScbRTSRtfE3sfxEEboBYvXBQ6YMdKnZmDhX1jTglEMefsLHTSIMvb94LwwDKrMQM8X4q2oeEEzSOtJFSPQDIHuYj/rnx1Y9MiXmEDhCWfaaLWA6NeqgWeYSNcUGVSH3hiaEIEUFKq0djDx3nHURpkpMnnklhqUJYVfViY=
Message-ID: <6101e8c40805010814rf64d402l1a9da0c3e22b9668@mail.gmail.com>
Date: Thu, 1 May 2008 17:14:17 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Subject: Re: [OP] v2.6.22.22-op1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <x49fxt2axns.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <db9953cd52eb63e471f5fcdcb83b299b@zipernowsky.hu>
	 <x49fxt2axns.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/08, Jeff Moyer <jmoyer@redhat.com> wrote:
> <oliver@zipernowsky.hu> writes:
>
> > I announced the v2.6.22.22-op1 "stable" kernel.
>
> >  fs/aio.c                    |   23 ++++++++++++-----------
>
> > Jeff Moyer (1):
> >       aio: account I/O wait time properly
>
> This version of the patch introduced a regression for UML.  It was
> seeing 100% iowait time when it wasn't waiting on any I/O.  There was a
> follow-up patch which did the io_schedule conditionally, see commit id:
>
>   e00ba3dae077f54cfd2af42e939a618caa7a3bca
>
> Cheers,
>
> Jeff
>
> > diff --git a/fs/aio.c b/fs/aio.c
> > index dbe699e..b3419c5 100644
> > --- a/fs/aio.c
> > +++ b/fs/aio.c
> > @@ -1170,7 +1171,7 @@ retry:
> >  			ret = 0;
> >  			if (to.timed_out)	/* Only check after read evt */
> >  				break;
> > -			schedule();
> > +			io_schedule();
> >  			if (signal_pending(tsk)) {
> >  				ret = -EINTR;
> >  				break;
>


hmm, this is the relevant code in 2.6.22:
----8<-------------->8-----
                        if (min_nr <= i)
                                break;
                        ret = 0;
                        if (to.timed_out)       /* Only check after read evt */
                                break;
                        schedule(); <-----------
                        if (signal_pending(tsk)) {
                                ret = -EINTR;
                                break;
                        }
                        /*ret = aio_read_evt(ctx, &ent);*/
----8<-------------->8-----

-- 
Thanks,
Oliver
