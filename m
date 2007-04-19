Return-Path: <linux-kernel-owner+w=401wt.eu-S1031114AbXDSEiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031114AbXDSEiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 00:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031122AbXDSEiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 00:38:23 -0400
Received: from iucha.net ([209.98.146.184]:53709 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031114AbXDSEiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 00:38:23 -0400
Date: Wed, 18 Apr 2007 23:38:21 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "Mr. Charles Edward Lever" <Chuck.Lever@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Success! Was: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070419043821.GP24044@iucha.net>
References: <20070417211350.ebba1493.akpm@linux-foundation.org> <20070418043040.GD24044@iucha.net> <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org> <20070417223738.8f49a39f.akpm@linux-foundation.org> <20070418123842.GF24044@iucha.net> <1176902131.6796.62.camel@heimdal.trondhjem.org> <20070418134225.GG24044@iucha.net> <1176905506.6796.84.camel@heimdal.trondhjem.org> <20070419015232.GO24044@iucha.net> <1176950713.6422.95.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9g2r9e2kvGs7M7R"
Content-Disposition: inline
In-Reply-To: <1176950713.6422.95.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--v9g2r9e2kvGs7M7R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2007 at 10:45:13PM -0400, Trond Myklebust wrote:
> On Wed, 2007-04-18 at 20:52 -0500, Florin Iucha wrote:
> > It seems that my original problem report had a big mistake!  There is
> > no hang, but at some point the write slows down to a trickle (from
> > 40,000 blocks/s to 22 blocks/s) as can be seen from the iostat log.
>=20
> Yeah. You only captured the outgoing traffic to the server, but already
> it looks as if there were 'interesting' things going on. In frames 29346
> to 29350, the traffic stops altogether for 5 seconds (I only see
> keepalives) then it starts up again. Ditto for frames 40477-40482
> (another 5 seconds). ...
> Then at around frame 92072, the client starts to send a bunch of RSTs.
> Aha.... I'll bet that reverting the appended patch fixes the problem.

You win!

Reverting this patch (on top of your previous 5) allowed the big copy
to complete (70GB) as well as successful log-in to gnome!

Acked-By: Florin Iucha <florin@iucha.net>

Thanks so much for the patience with this elusive bug and stubborn
bugreporter!

Regards,
florin

> -------------------------------------------
> commit 43d78ef2ba5bec26d0315859e8324bfc0be23766
> Author: Chuck Lever <chuck.lever@oracle.com>
> Date:   Tue Feb 6 18:26:11 2007 -0500
>=20
>     NFS: disconnect before retrying NFSv4 requests over TCP
>    =20
>     RFC3530 section 3.1.1 states an NFSv4 client MUST NOT send a request
>     twice on the same connection unless it is the NULL procedure.  Section
>     3.1.1 suggests that the client should disconnect and reconnect if it
>     wants to retry a request.
>    =20
>     Implement this by adding an rpc_clnt flag that an ULP can use to
>     specify that the underlying transport should be disconnected on a
>     major timeout.  The NFSv4 client asserts this new flag, and requests
>     no retries after a minor retransmit timeout.
>    =20
>     Note that disconnecting on a retransmit is in general not safe to do
>     if the RPC client does not reuse the TCP port number when reconnectin=
g.
>    =20
>     See http://bugzilla.linux-nfs.org/show_bug.cgi?id=3D6
>    =20
>     Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>=20
> diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> index a3191f0..c46e94f 100644
> --- a/fs/nfs/client.c
> +++ b/fs/nfs/client.c
> @@ -394,7 +394,8 @@ static void nfs_init_timeout_values(struct rpc_timeou=
t *to, int proto,
>  static int nfs_create_rpc_client(struct nfs_client *clp, int proto,
>  						unsigned int timeo,
>  						unsigned int retrans,
> -						rpc_authflavor_t flavor)
> +						rpc_authflavor_t flavor,
> +						int flags)
>  {
>  	struct rpc_timeout	timeparms;
>  	struct rpc_clnt		*clnt =3D NULL;
> @@ -407,6 +408,7 @@ static int nfs_create_rpc_client(struct nfs_client *c=
lp, int proto,
>  		.program	=3D &nfs_program,
>  		.version	=3D clp->rpc_ops->version,
>  		.authflavor	=3D flavor,
> +		.flags		=3D flags,
>  	};
> =20
>  	if (!IS_ERR(clp->cl_rpcclient))
> @@ -548,7 +550,7 @@ static int nfs_init_client(struct nfs_client *clp, co=
nst struct nfs_mount_data *
>  	 * - RFC 2623, sec 2.3.2
>  	 */
>  	error =3D nfs_create_rpc_client(clp, proto, data->timeo, data->retrans,
> -			RPC_AUTH_UNIX);
> +					RPC_AUTH_UNIX, 0);
>  	if (error < 0)
>  		goto error;
>  	nfs_mark_client_ready(clp, NFS_CS_READY);
> @@ -868,7 +870,8 @@ static int nfs4_init_client(struct nfs_client *clp,
>  	/* Check NFS protocol revision and initialize RPC op vector */
>  	clp->rpc_ops =3D &nfs_v4_clientops;
> =20
> -	error =3D nfs_create_rpc_client(clp, proto, timeo, retrans, authflavour=
);
> +	error =3D nfs_create_rpc_client(clp, proto, timeo, retrans, authflavour,
> +					RPC_CLNT_CREATE_DISCRTRY);
>  	if (error < 0)
>  		goto error;
>  	memcpy(clp->cl_ipaddr, ip_addr, sizeof(clp->cl_ipaddr));
> diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
> index a1be89d..c7a78ee 100644
> --- a/include/linux/sunrpc/clnt.h
> +++ b/include/linux/sunrpc/clnt.h
> @@ -40,6 +40,7 @@ struct rpc_clnt {
> =20
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
> =20
>  struct rpc_clnt *rpc_create(struct rpc_create_args *args);
>  struct rpc_clnt	*rpc_bind_new_program(struct rpc_clnt *,
> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> index 393e70a..c21aa0a 100644
> --- a/net/sunrpc/clnt.c
> +++ b/net/sunrpc/clnt.c
> @@ -249,6 +249,8 @@ struct rpc_clnt *rpc_create(struct rpc_create_args *a=
rgs)
>  		clnt->cl_autobind =3D 1;
>  	if (args->flags & RPC_CLNT_CREATE_ONESHOT)
>  		clnt->cl_oneshot =3D 1;
> +	if (args->flags & RPC_CLNT_CREATE_DISCRTRY)
> +		clnt->cl_discrtry =3D 1;
> =20
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
> +					task->tk_status =3D -ENOTCONN;
> +					return;
> +				}
> +			}
>  		}
>  	} else if (!req->rq_bytes_sent)
>  		return;
>=20

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--v9g2r9e2kvGs7M7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJvI9ND0rFCN2b1sRAmlJAKCE950MoRn5edj/p9vdUR185iMFtgCfXSa3
Hfx+tkIRLiiV2UwW6d1nrpc=
=qcAT
-----END PGP SIGNATURE-----

--v9g2r9e2kvGs7M7R--
