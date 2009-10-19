Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZJSHFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZJSHFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZJSHE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:04:59 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:50387 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZJSHE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:04:59 -0400
Subject: Re: nfs mount fail
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091019065433.GA29550@elte.hu>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com>
	 <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com>
	 <20091019114339.4b67d947@infradead.org>
	 <1255921080.839.2.camel@penberg-laptop>
	 <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com>
	 <1255933848.11116.2.camel@heimdal.trondhjem.org>
	 <20091019065433.GA29550@elte.hu>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 16:04:48 +0900
Message-Id: <1255935888.11116.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 9 sum msgs/h 1 total rcpts 1687 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 717BD060470F2B934548142D4F2E1802CBACC4CE
X-UiO-SPAM-Test: remote_host: 220.106.13.183 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 1 max/h 1 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 08:54 +0200, Ingo Molnar wrote:
> * Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > > yes. something miss merged again...
> > > 
> > > need change some lines.
> > 
> > This doesn't match mainline either. To do so, the above kfree() has to 
> > be at the end of the "Opt_xprt_rdma:" case...
> 
> it's from a test patch in tip:out-of-tree:
> 
>   d40bc6b: <not-for-merge> nfs: fix nfs_parse_mount_options() double kfree()
> 
> (attached below)
> 
> that fix is wrong apparently - is there a correct fix upstream perhaps?
<snip>
> This commit:
> 
>   a67d18f: NFS: load the rpc/rdma transport module automatically
> 
> Moved a kfree() of the options strings in nfs_parse_mount_options()
> inadvertently and introduced a double kfree(). Fix it.
> 
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Analyzed-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  fs/nfs/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/super.c b/fs/nfs/super.c
> index a2c18ac..482a2c3 100644
> --- a/fs/nfs/super.c
> +++ b/fs/nfs/super.c
> @@ -1231,6 +1231,7 @@ static int nfs_parse_mount_options(char *raw,
>  				goto out_nomem;
>  			token = match_token(string,
>  					    nfs_xprt_protocol_tokens, args);
> +			kfree(string);
>  
>  			switch (token) {
>  			case Opt_xprt_udp:
> @@ -1262,7 +1263,6 @@ static int nfs_parse_mount_options(char *raw,
>  				goto out_nomem;
>  			token = match_token(string,
>  					    nfs_xprt_protocol_tokens, args);
> -			kfree(string);
>  
>  			switch (token) {
>  			case Opt_xprt_udp:

This patch appears to be reverting the correct fix from commit d508afb
in mainline
        http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=d508afb437daee7cf07da085b635c44a4ebf9b38

Cheers
  Trond

