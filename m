Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbXL3VfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbXL3VfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXL3VfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:35:06 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:33113 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbXL3VfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kUMcCc9+GXXTBNOUO8qb6xEMtZ6UTH8vPpSW1jnttZtshhOBYi274K1K0hR3pvfNyREtczEF0S8F2p610EBsmaGGEWRcrWvtbxv46TveU+1RkcDEbeQbDEq3oNDQ3ChVHJAVMpEgxwyGPkVm1bfRfWQW4QjGKUoKjJknXQSJNUY=
Message-ID: <64bb37e0712301335k3ae8c0car1fa9b34034f9df0e@mail.gmail.com>
Date: Sun, 30 Dec 2007 22:35:00 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.24-rc6-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Neil Brown" <neilb@suse.de>, netdev@vger.kernel.org,
       "Tom Tucker" <tom@opengridcomputing.com>
In-Reply-To: <20071230212443.GA23320@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	 <64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com>
	 <64bb37e0712281453y4aac82b7h7acc8ec314ca6e3e@mail.gmail.com>
	 <20071228150746.42b3bbc0.akpm@linux-foundation.org>
	 <20071230212443.GA23320@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 10:24 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
>
> On Fri, Dec 28, 2007 at 03:07:46PM -0800, Andrew Morton wrote:
> > On Fri, 28 Dec 2007 23:53:49 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> >
> > > On Dec 23, 2007 5:27 PM, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > > > On Dec 23, 2007 8:30 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > >
> > > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> > > > I have finally given up on using 2.6.24-rc3-mm2 with slub_debug=FZP to
> > > > get more information out of the random crashes I had seen with that
> > > > version. (Did not crash once with slub_debug, so no new information on
> > > > what the cause was)
> > >
> > > Murphy: Just after sending that mail the system crashed two times with
> > > slub_debug=FZP, but did not show any new informations.
> > > No debug output from slub, only this stacktrace: (Its the same I
> > > already reported in the 2.6.24-rc3-mm2 thread)
> > >
[snip]
> > > [ 7620.708561] Pid: 5698, comm: nfsv4-svc Not tainted 2.6.24-rc3-mm2 #2
[snip]
> >
> > That looks like a sunrpc bug.  git-nfsd has bene mucking around in there a
> > bit.
>
> Can you still reproduce this?  Tom thought there was a chance the
> following could fix it.

Please see also http://lkml.org/lkml/2007/12/29/76

Just wanted to say that slub_debug did not help to get more infos.

I will try to reproduce this with rc3-mm2 and the below patch tomorrow.
Without slub_debug this seemed to trigger rather reliable when trying
to update/upgrade packages on my system.

> From:   Tom Tucker <tom@opengridcomputing.com>
> Date:   Sun, 30 Dec 2007 10:07:17 -0600
>
> Bruce/Aime:
>
> Here is what I believe to be the fix for the crashes/svc_xprt BUG_ON
> that people are seeing. It would be great if those who have seen this
> problem could apply this patch and see if it resolves their problem.
>
> The common code calls svc_xprt_received on behalf of the transport.
> Since the provider was calling it as well, this resulted in clearing the
> busy bit/resetting xpt_pool when the BUSY bit wasn't held.
>
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 4628881..4d39db1 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -1272,7 +1272,6 @@ static struct svc_xprt *svc_create_socket(struct svc_serv *serv,
>
>         if ((svsk = svc_setup_socket(serv, sock, &error, flags)) != NULL) {
>                 svc_xprt_set_local(&svsk->sk_xprt, newsin, newlen);
> -               svc_xprt_received(&svsk->sk_xprt);
>                 return (struct svc_xprt *)svsk;
>         }

I will send a mail, when I'm done with testing this...

Thanks for the patch.

Torsten
