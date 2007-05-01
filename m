Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXEAOhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXEAOhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXEAOhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:37:33 -0400
Received: from pat.uio.no ([129.240.10.15]:56273 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXEAOh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:37:29 -0400
Subject: Re: [NFS] [PATCH] NFS: supress warnings about NFS4ERR_OLD_STATEID
	in	nfs4_handle_exception
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org, ffilz@us.ibm.com
In-Reply-To: <20070426191336.GB31081@dantu.rdu.redhat.com>
References: <20070426191336.GB31081@dantu.rdu.redhat.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 07:42:29 -0700
Message-Id: <1178030549.5444.11.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: A0227E44889C8DA9E32826500584A2EB557FBBB6
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 294 total 1435162 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 15:13 -0400, Jeff Layton wrote:
> I recently posted this patch to the nfs mailing list, but got no comment.
> Reposting with an actual "[PATCH]" subject...
> 
> In certain situations, a NFSv4 client can end up with a set of racing calls
> that cause the server to return a NFS4ERR_OLD_STATEID error. When this occurs,
> the only real recourse that the client has is to retry the call. In the
> current code, when this occurs, it triggers a useless printk (in
> nfs4_map_errors):
> 
>     nfs4_map_errors could not handle NFSv4 error 10024
> 
> Trond recently mentioned that we really don't need to worry users with that
> info. The following patch is based on a suggestion by Frank Filz and supresses
> this error. Changing the return code here to 0 should be safe since all callers
> of nfs4_handle_exception are expected to retry the call in this situation
> anyway.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Signed-off-by: Frank Filz <ffilz@us.ibm.com>
> 
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index f52cf5c..b456783 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -2774,6 +2774,7 @@ int nfs4_handle_exception(const struct nfs_server *server, int errorcode, struct
>  				break;
>  		case -NFS4ERR_OLD_STATEID:
>  			exception->retry = 1;
> +			ret = 0;
>  	}
>  	/* We failed to handle the error */
>  	return nfs4_map_errors(ret);

Surely "return 0;" is more efficient.

...and a minor nit about the comment: it doesn't trigger a printk(). It
rather triggers a dprintk(), (which should be turned off by default
unless you happen to be debugging the code).

The other nit is that I'm not sure the dprintk() is totally useless. It
is always nice to know _why_ the thing looped when you are debugging.
That said, we should perhaps rather put the dprintk() for that in
nfs4_handle_exception instead...

Trond


