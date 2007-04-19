Return-Path: <linux-kernel-owner+w=401wt.eu-S1766777AbXDSPQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766777AbXDSPQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766811AbXDSPQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:16:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16600 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766777AbXDSPQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:16:38 -0400
Message-ID: <462786C9.7090405@oracle.com>
Date: Thu, 19 Apr 2007 11:12:09 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Florin Iucha <florin@iucha.net>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
References: <1176868485.6796.42.camel@heimdal.trondhjem.org>	 <20070418040730.GC24044@iucha.net>	 <20070417211350.ebba1493.akpm@linux-foundation.org>	 <20070418043040.GD24044@iucha.net>	 <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org>	 <20070417223738.8f49a39f.akpm@linux-foundation.org>	 <20070418123842.GF24044@iucha.net>	 <1176902131.6796.62.camel@heimdal.trondhjem.org>	 <20070418134225.GG24044@iucha.net>	 <1176905506.6796.84.camel@heimdal.trondhjem.org>	 <20070419015232.GO24044@iucha.net> <1176950713.6422.95.camel@heimdal.trondhjem.org>
In-Reply-To: <1176950713.6422.95.camel@heimdal.trondhjem.org>
Content-Type: multipart/mixed;
 boundary="------------000703050809000605000802"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000703050809000605000802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Trond Myklebust wrote:
> On Wed, 2007-04-18 at 20:52 -0500, Florin Iucha wrote:
>> On Wed, Apr 18, 2007 at 10:11:46AM -0400, Trond Myklebust wrote:
>>> Do you have a copy of wireshark or ethereal on hand? If so, could you
>>> take a look at whether or not any NFS traffic is going between the
>>> client and server once the hang happens?
>> I used the following command 
>>
>>    tcpdump -w nfs-traffic -i eth0 -vv -tt dst port nfs
>>
>> to capture
>>
>>    http://iucha.net/nfs/21-rc7-nfs4/nfs-traffic.bz2
>>
>> I started the capture before starting the copy and left it to run for
>> a few minutes after the traffic slowed to a crawl.
>>
>> The iostat and vmstat are at:
>>
>>    http://iucha.net/nfs/21-rc7-nfs4/iostat
>>    http://iucha.net/nfs/21-rc7-nfs4/vmstat
>>    
>> It seems that my original problem report had a big mistake!  There is
>> no hang, but at some point the write slows down to a trickle (from
>> 40,000 blocks/s to 22 blocks/s) as can be seen from the iostat log.
> 
> Yeah. You only captured the outgoing traffic to the server, but already
> it looks as if there were 'interesting' things going on. In frames 29346
> to 29350, the traffic stops altogether for 5 seconds (I only see
> keepalives) then it starts up again. Ditto for frames 40477-40482
> (another 5 seconds). ...
> Then at around frame 92072, the client starts to send a bunch of RSTs.
> Aha.... I'll bet that reverting the appended patch fixes the problem.
> 
> The assumption Chuck makes is that if _no_ request bytes have been sent,
> yet the request is on the 'receive list' then it must be a resend is
> patently false in the case where the send queue just happens to be full.

There are other places in the RPC client where "zero bytes sent" implies 
that the request has been sent.  The real problem here is that zeroing 
the "bytes sent" field is overloaded.

Perhaps instead of looking at the number of bytes sent, the logic in the 
last hunk of this patch should check which queue the request is sitting on.


> -------------------------------------------
> commit 43d78ef2ba5bec26d0315859e8324bfc0be23766
> Author: Chuck Lever <chuck.lever@oracle.com>
> Date:   Tue Feb 6 18:26:11 2007 -0500
> 
>     NFS: disconnect before retrying NFSv4 requests over TCP
>     
>     RFC3530 section 3.1.1 states an NFSv4 client MUST NOT send a request
>     twice on the same connection unless it is the NULL procedure.  Section
>     3.1.1 suggests that the client should disconnect and reconnect if it
>     wants to retry a request.
>     
>     Implement this by adding an rpc_clnt flag that an ULP can use to
>     specify that the underlying transport should be disconnected on a
>     major timeout.  The NFSv4 client asserts this new flag, and requests
>     no retries after a minor retransmit timeout.
>     
>     Note that disconnecting on a retransmit is in general not safe to do
>     if the RPC client does not reuse the TCP port number when reconnecting.
>     
>     See http://bugzilla.linux-nfs.org/show_bug.cgi?id=6
>     
>     Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index a3191f0..c46e94f 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -394,7 +394,8 @@ static void nfs_init_timeout_values(struct rpc_timeout *to, int proto,
>  static int nfs_create_rpc_client(struct nfs_client *clp, int proto,
>  						unsigned int timeo,
>  						unsigned int retrans,
> -						rpc_authflavor_t flavor)
> +						rpc_authflavor_t flavor,
> +						int flags)
>  {
>  	struct rpc_timeout	timeparms;
>  	struct rpc_clnt		*clnt = NULL;
> @@ -407,6 +408,7 @@ static int nfs_create_rpc_client(struct nfs_client *clp, int proto,
>  		.program	= &nfs_program,
>  		.version	= clp->rpc_ops->version,
>  		.authflavor	= flavor,
> +		.flags		= flags,
>  	};
>  
>  	if (!IS_ERR(clp->cl_rpcclient))
> @@ -548,7 +550,7 @@ static int nfs_init_client(struct nfs_client *clp, const struct nfs_mount_data *
>  	 * - RFC 2623, sec 2.3.2
>  	 */
>  	error = nfs_create_rpc_client(clp, proto, data->timeo, data->retrans,
> -			RPC_AUTH_UNIX);
> +					RPC_AUTH_UNIX, 0);
>  	if (error < 0)
>  		goto error;
>  	nfs_mark_client_ready(clp, NFS_CS_READY);
> @@ -868,7 +870,8 @@ static int nfs4_init_client(struct nfs_client *clp,
>  	/* Check NFS protocol revision and initialize RPC op vector */
>  	clp->rpc_ops = &nfs_v4_clientops;
>  
> -	error = nfs_create_rpc_client(clp, proto, timeo, retrans, authflavour);
> +	error = nfs_create_rpc_client(clp, proto, timeo, retrans, authflavour,
> +					RPC_CLNT_CREATE_DISCRTRY);
>  	if (error < 0)
>  		goto error;
>  	memcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
> diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
> index a1be89d..c7a78ee 100644
> --- a/include/linux/sunrpc/clnt.h
> +++ b/include/linux/sunrpc/clnt.h
> @@ -40,6 +40,7 @@ struct rpc_clnt {
>  
>  	unsigned int		cl_softrtry : 1,/* soft timeouts */
>  				cl_intr     : 1,/* interruptible */
> +				cl_discrtry : 1,/* disconnect before retry */
>  				cl_autobind : 1,/* use getport() */
>  				cl_oneshot  : 1,/* dispose after use */
>  				cl_dead     : 1;/* abandoned */
> @@ -111,6 +112,7 @@ struct rpc_create_args {
>  #define RPC_CLNT_CREATE_ONESHOT		(1UL << 3)
>  #define RPC_CLNT_CREATE_NONPRIVPORT	(1UL << 4)
>  #define RPC_CLNT_CREATE_NOPING		(1UL << 5)
> +#define RPC_CLNT_CREATE_DISCRTRY	(1UL << 6)
>  
>  struct rpc_clnt *rpc_create(struct rpc_create_args *args);
>  struct rpc_clnt	*rpc_bind_new_program(struct rpc_clnt *,
> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> index 393e70a..c21aa0a 100644
> --- a/net/sunrpc/clnt.c
> +++ b/net/sunrpc/clnt.c
> @@ -249,6 +249,8 @@ struct rpc_clnt *rpc_create(struct rpc_create_args *args)
>  		clnt->cl_autobind = 1;
>  	if (args->flags & RPC_CLNT_CREATE_ONESHOT)
>  		clnt->cl_oneshot = 1;
> +	if (args->flags & RPC_CLNT_CREATE_DISCRTRY)
> +		clnt->cl_discrtry = 1;
>  
>  	return clnt;
>  }
> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
> index cf59f7d..1975139 100644
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -735,6 +735,16 @@ void xprt_transmit(struct rpc_task *task)
>  			xprt_reset_majortimeo(req);
>  			/* Turn off autodisconnect */
>  			del_singleshot_timer_sync(&xprt->timer);
> +		} else {
> +			/* If all request bytes have been sent,
> +			 * then we must be retransmitting this one */
> +			if (!req->rq_bytes_sent) {
> +				if (task->tk_client->cl_discrtry) {
> +					xprt_disconnect(xprt);
> +					task->tk_status = -ENOTCONN;
> +					return;
> +				}
> +			}
>  		}
>  	} else if (!req->rq_bytes_sent)
>  		return;


--------------000703050809000605000802
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
email;internet:chuck dot lever at nospam oracle dot com
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------000703050809000605000802--
