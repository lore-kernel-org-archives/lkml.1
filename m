Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYC2TYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYC2TYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 15:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYC2TYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 15:24:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbYC2TYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 15:24:41 -0400
Date: Sat, 29 Mar 2008 15:24:24 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: have soft RPC tasks return -ETIMEDOUT instead
 of -EIO on major connect timeout
Message-ID: <20080329152424.6857ee86@tleilax.poochiereds.net>
In-Reply-To: <1206809051.8480.33.camel@heimdal.trondhjem.org>
References: <1206794957-17010-1-git-send-email-jlayton@redhat.com>
	<1206809051.8480.33.camel@heimdal.trondhjem.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008 12:44:11 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> 
> On Sat, 2008-03-29 at 08:49 -0400, Jeff Layton wrote:
> > NFSv4 background mounts do not currently work correctly. While we could
> > try to fix this in userspace, I think it's really a kernel problem...
> > 
> > When a soft RPC tasks experiences a major timeout during a connection
> > attempt, it does an rpc_exit with a return code of -EIO. For NFSv4
> > mounts, this makes the mount() syscall return -EIO. mount.nfs4 then
> > interprets that as a "permanent" error, and won't attempt a background
> > mount when bg is specified. Fix this by making call_timeout() do the
> > rpc_exit() with an error of -ETIMEDOUT.
> > 
> > This fixes the background mount issue, but does make other syscalls
> > on soft mounts return ETIMEDOUT instead of EIO in this situation.
> > 
> > Comments welcome.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  net/sunrpc/clnt.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> > index 8c6a7f1..b6d409e 100644
> > --- a/net/sunrpc/clnt.c
> > +++ b/net/sunrpc/clnt.c
> > @@ -1162,7 +1162,7 @@ call_timeout(struct rpc_task *task)
> >  	if (RPC_IS_SOFT(task)) {
> >  		printk(KERN_NOTICE "%s: server %s not responding, timed out\n",
> >  				clnt->cl_protname, clnt->cl_server);
> > -		rpc_exit(task, -EIO);
> > +		rpc_exit(task, -ETIMEDOUT);
> >  		return;
> >  	}
> 
> While that may be acceptable for the mount() syscall, I don't think
> POSIX applications are quite ready to deal with ETIMEDOUT as an error
> for stat() or chdir().
> 

Ugh. Good point.

> Userland has the clnt_geterr() function that returns more detailed 'RPC
> level' errors. While that 'error function call' approach doesn't work in
> a multi-threaded environment, we might still be able to add the
> equivalent of a pointer to an 'rpc_err' structure to the rpc_task, and
> then have functions like call_timeout() (and especially call_verify()!)
> fill in more detailed error info if that pointer is non-zero?
>

I'm not sure we really need this, do we?

Should it really be the business of the RPC layer to sanitize the
tk_status like this? It seems like the NFS layer ought to be
translating "illegal" errors from the RPC layer into more generic ones
where needed rather than relying on the RPC layer to do it, though
maybe I'm not thinking about the RPC layer in the right way here...

Thanks,
--
Jeff Layton <jlayton@redhat.com>
