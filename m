Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbXBNNAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbXBNNAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 08:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932269AbXBNNAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 08:00:21 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:62474 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbXBNNAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 08:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KTgZauotffEbu8KMNNL24DWhm5Zu6ie7ynsWTubKayHydEHp86xCYO4AiLjI5Vfr+GMVFXg3bw8saLx7/pq7VxwFVtnVycFDDFuygYVAk5VRKU/X6037gStTJ3jwQZp6yLeAnTmrH1YK9fGJE3NRgijxU4kASDW/ljfL/eZ2GiM=
Subject: Re: [NFS] [PATCH 001 of 9] knfsd: nfsd4: fix non-terminated string
From: Ming Zhang <blackmagic02881@gmail.com>
Reply-To: blackmagic02881@gmail.com
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1070212234402.29224@suse.de>
References: <20070213103941.28958.patches@notabene>
	 <1070212234402.29224@suse.de>
Content-Type: text/plain
Date: Wed, 14 Feb 2007 08:00:18 -0500
Message-Id: <1171458018.2638.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 10:44 +1100, NeilBrown wrote:
> From: J. Bruce Fields <bfields@citi.umich.edu>
> The server name is expected to be a null-terminated string, so we can't
> pass in the raw client identifier.
> 
> What's more, the client identifier is just a binary, not necessarily
> printable, blob.  Let's just use the ip address instead.  The server
> name appears to exist just to help debugging by making some printk's
> more informative.
> 
> Note that the string is copies into the rpc client structure, so
> the pointer to the local variable does not outlive the function call.
> 
> Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./fs/nfsd/nfs4callback.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff .prev/fs/nfsd/nfs4callback.c ./fs/nfsd/nfs4callback.c
> --- .prev/fs/nfsd/nfs4callback.c	2007-02-13 09:50:26.000000000 +1100
> +++ ./fs/nfsd/nfs4callback.c	2007-02-13 10:00:59.000000000 +1100
> @@ -387,7 +387,6 @@ nfsd4_probe_callback(struct nfs4_client 
>  		.address	= (struct sockaddr *)&addr,
>  		.addrsize	= sizeof(addr),
>  		.timeout	= &timeparms,
> -		.servername	= clp->cl_name.data,
>  		.program	= program,
>  		.version	= nfs_cb_version[1]->number,
>  		.authflavor	= RPC_AUTH_UNIX,	/* XXX: need AUTH_GSS... */
> @@ -397,6 +396,7 @@ nfsd4_probe_callback(struct nfs4_client 
>  		.rpc_proc       = &nfs4_cb_procedures[NFSPROC4_CLNT_CB_NULL],
>  		.rpc_argp       = clp,
>  	};
> +	char clientname[16];
>  	int status;
>  
>  	if (atomic_read(&cb->cb_set))
> @@ -419,6 +419,11 @@ nfsd4_probe_callback(struct nfs4_client 
>  	memset(program->stats, 0, sizeof(cb->cb_stat));
>  	program->stats->program = program;
>  
> +	/* Just here to make some printk's more useful: */
> +	snprintf(clientname, sizeof(clientname),
> +		"%u.%u.%u.%u", NIPQUAD(addr.sin_addr));

can use NIPQUAD_FMT here instead of "%u.%u.%u.%u".

btw, will the ip address here possibly be an ipv6 address?

> +	args.servername = clientname;
> +
>  	/* Create RPC client */
>  	cb->cb_client = rpc_create(&args);
>  	if (IS_ERR(cb->cb_client)) {
> 
> -------------------------------------------------------------------------
> Using Tomcat but need to do more? Need to support web services, security?
> Get stuff done quickly with pre-integrated technology to make your job easier.
> Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
> http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
> _______________________________________________
> NFS maillist  -  NFS@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/nfs
-- 
http://blackmagic02881.wordpress.com/

