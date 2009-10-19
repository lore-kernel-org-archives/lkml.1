Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZJSGbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZJSGbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 02:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZJSGbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 02:31:02 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:60818 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZJSGbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 02:31:01 -0400
Subject: Re: nfs mount fail
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com>
	 <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com>
	 <20091019114339.4b67d947@infradead.org>
	 <1255921080.839.2.camel@penberg-laptop>
	 <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 15:30:48 +0900
Message-Id: <1255933848.11116.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 7 sum msgs/h 1 total rcpts 1681 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 0ED132C325A4045BBFD3641029670806D500BBAE
X-UiO-SPAM-Test: remote_host: 220.106.13.183 spam_score: -49 maxlevel 80 minaction 2 bait 0 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-18 at 22:52 -0700, Yinghai Lu wrote:
> On Sun, Oct 18, 2009 at 7:58 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > On Mon, 2009-10-19 at 11:43 +0900, Arjan van de Ven wrote:
> >> On Mon, 19 Oct 2009 05:35:20 +0300
> >> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >>
> >> > >
> >> > > [  278.734149] ------------[ cut here ]------------
> >> > > [  278.739620] kernel BUG at mm/slub.c:2969!
> >> >
> >> > So this means that someone is passing a pointer to kfree() that did
> >> > not come from kmalloc(). Which tree are you testing?
> >>
> >> > > [  278.770030] Pid: 2594, comm: rpciod/0 Not tainted
> >> > > 2.6.32-rc5-tip-01483-ga166936-dirty #651
> >>
> >> some evil person decided to put the exact kernel tree/version in the
> >> oops output ;-)
> >
> > Oh, right. Ingo, Yinghai says Linus' tree is fine so any ideas why this
> > shows up in -tip? Also it seems we've had a similar bug before:
> >
> >  http://lkml.org/lkml/2009/4/2/698
> >
> > Hmmh?
> 
> yes. something miss merged again...
> 
> need change some lines.
> 
> ---
>  fs/nfs/super.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/nfs/super.c
> ===================================================================
> --- linux-2.6.orig/fs/nfs/super.c
> +++ linux-2.6/fs/nfs/super.c
> @@ -1231,7 +1231,6 @@ static int nfs_parse_mount_options(char
>  				goto out_nomem;
>  			token = match_token(string,
>  					    nfs_xprt_protocol_tokens, args);
> -			kfree(string);
> 
>  			switch (token) {
>  			case Opt_xprt_udp:
> @@ -1254,6 +1253,7 @@ static int nfs_parse_mount_options(char
>  			default:
>  				dfprintk(MOUNT, "NFS:   unrecognized "
>  						"transport protocol\n");
> +				kfree(string);

This doesn't match mainline either. To do so, the above kfree() has to
be at the end of the "Opt_xprt_rdma:" case...

>  				return 0;
>  			}
>  			break;
> @@ -1264,6 +1264,8 @@ static int nfs_parse_mount_options(char
>  			token = match_token(string,
>  					    nfs_xprt_protocol_tokens, args);
> 
> +			kfree(string);
> +
>  			switch (token) {
>  			case Opt_xprt_udp:
>  				mnt->mount_server.protocol = XPRT_TRANSPORT_UDP;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


