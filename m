Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbXH2Fwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbXH2Fwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXH2Fwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:52:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:46804 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXH2Fw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FfBCiVYMe6S7Lm4hefyQQG7z0j2+KAgYFqON/7Cwd1aiDzDI6K8AOGPnlfaM3iKRaEY8moWP6S9ZaW0VGDj9d7vZgf4FSPlK3JerrUZu/zvnRdCUR93RZEWMAJkEvWD2Wc0OJkNJc0h4bVsL6IA4ybrUuIcgVoPtfRUZFUzHKS8=
Message-ID: <dda83e780708282252s759a0b85o6562393bd9fca54f@mail.gmail.com>
Date: Tue, 28 Aug 2007 22:52:27 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: NFS woes again
Cc: "Florin Iucha" <florin@iucha.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <1188307723.6701.138.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz>
	 <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz>
	 <20070822132200.GO10422@iucha.net> <20070823125210.GQ10422@iucha.net>
	 <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com>
	 <20070823173637.GS10422@iucha.net>
	 <1188220651.6701.32.camel@heimdal.trondhjem.org>
	 <dda83e780708271819x247ac49dx981c49a80ed6a999@mail.gmail.com>
	 <20070828013541.GA10422@iucha.net>
	 <1188307723.6701.138.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> On Mon, 2007-08-27 at 20:35 -0500, Florin Iucha wrote:
> > On Mon, Aug 27, 2007 at 06:19:29PM -0700, Bret Towe wrote:
> > > On 8/27/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > > > > this sounds alot like the post i did yesterday titled 'nfs4 hang regression'
> > > > > > i tracked it down to commit 3d39c691ff486142dd9aaeac12f553f4476b7a6
> > > > >
> > > > > Yes, it certainly does -- all the symptoms match!
> > > >
> > > > Could you and Bret please check if the attached patch fixes the hang?
> > >
> > > no good for me still hangs after ~30minutes
> >
> > I just booted into the new kernel
> > (3d39c691ff486142dd9aaeac12f553f4476b7a6 + Trond's patch) and it hangs
> > in 10-15 minutes.
> >
> > Process traces available at http://iucha.net/nfs/23-rc2-nfs-fix-1/kernel.log.gz
> >
> > Regards,
> > florin
>
> Doh! I see the problem: cancel_delayed_work_sync() shouldn't ever be
> called recursively.
>
> The following patch should be correct. Please just discard the previous
> one...
>
> Trond
>

uptime of 3 hours and keyboard is still working fine
I'll hopefully get to test this on the mini tomorrow for at least 3 hours also

>
> ---------- Forwarded message ----------
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> To:
> Date: Mon, 27 Aug 2007 09:14:56 -0400
> Subject: No Subject
> Doh! We can't use cancel_delayed_work_sync because we may have been called
> from an unmount that was being performed by nfs_automount_task.
>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>
>  fs/nfs/namespace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
> index aea76d0..acfc56f 100644
> --- a/fs/nfs/namespace.c
> +++ b/fs/nfs/namespace.c
> @@ -176,7 +176,7 @@ static void nfs_expire_automounts(struct work_struct *work)
>  void nfs_release_automount_timer(void)
>  {
>         if (list_empty(&nfs_automount_list))
> -               cancel_delayed_work_sync(&nfs_automount_task);
> +               cancel_delayed_work(&nfs_automount_task);
>  }
>
>  /*
>
>
