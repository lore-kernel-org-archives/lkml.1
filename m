Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZJSHxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZJSHxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZJSHxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:53:05 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:60400 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZJSHxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:53:04 -0400
Subject: Re: nfs mount fail
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440910190031m33e116d3o90869de5212bb2e@mail.gmail.com>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com>
	 <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com>
	 <20091019114339.4b67d947@infradead.org>
	 <1255921080.839.2.camel@penberg-laptop>
	 <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com>
	 <1255933848.11116.2.camel@heimdal.trondhjem.org>
	 <20091019065433.GA29550@elte.hu> <1255935518.18914.0.camel@penberg-laptop>
	 <20091019070825.GA16493@elte.hu>
	 <86802c440910190031m33e116d3o90869de5212bb2e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 16:52:54 +0900
Message-Id: <1255938774.11116.35.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 12 msgs/h 2 sum rcpts/h 15 sum msgs/h 2 total rcpts 1693 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 4CA2FE8A65E6D396370A5C609BFA1927684ABAED
X-UiO-SPAM-Test: remote_host: 220.106.13.183 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 2 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 00:31 -0700, Yinghai Lu wrote:
> On Mon, Oct 19, 2009 at 12:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> >
> >> Hi Ingo,
> >>
> >> On Mon, 2009-10-19 at 08:54 +0200, Ingo Molnar wrote:
> >> > * Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> >> >
> >> > > > yes. something miss merged again...
> >> > > >
> >> > > > need change some lines.
> >> > >
> >> > > This doesn't match mainline either. To do so, the above kfree() has to
> >> > > be at the end of the "Opt_xprt_rdma:" case...
> >> >
> >> > it's from a test patch in tip:out-of-tree:
> >> >
> >> >   d40bc6b: <not-for-merge> nfs: fix nfs_parse_mount_options() double kfree()
> >> >
> >> > (attached below)
> >> >
> >> > that fix is wrong apparently - is there a correct fix upstream perhaps?
> >>
> >> AFAICT, yes. See commit d508afb437daee7cf07da085b635c44a4ebf9b38 ("NFS:
> >> Fix a double free in nfs_parse_mount_options()") from Trond.
> >
> > sigh. That was written 3 days after your and Yinghai's patch was sent -
> > there's no Reported-by credit, there was no Cc: back to the original
> > thread - plus there was a memory leak was left in there as well. Trond?

Not sure what happened there, but I do know that evolution-2.26 manages
to lose my exchange based email every now and again. It is possible that
was why I lost track of the original patch...

> sth like this to fix possible mem leaking...
> 
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index a2c18ac..90be551 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -1253,6 +1253,7 @@ static int nfs_parse_mount_options(char *raw,
>  			default:
>  				dfprintk(MOUNT, "NFS:   unrecognized "
>  						"transport protocol\n");
> +				kfree(string);
>  				return 0;
>  			}
>  			break;

There is a possible clean up there too. We can move the other kfree()
calls out of the inner switch statement, and coalesce them all into a
single call.

Trond

