Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYBLC03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYBLC03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 21:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbYBLC0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 21:26:13 -0500
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:45623 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759117AbYBLC0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:26:11 -0500
X-YMail-OSG: 36ARoAcVM1lw11WFT8p_uPr6lk0VoyJJJAGDVFLUI_PD7GvFKW0ao4drwN0Eok5y.t245lbxUkSbi24suCTLJ7RA7AIwoxDYrfwK.iRJznPTzA_BoK0-
X-RocketYMMF: rancidfat
Date: Mon, 11 Feb 2008 18:26:10 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH - BUGFIX] Smack: Check for 'struct socket' with NULL sk
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Joerg Platte <jplatte@naasa.net>
Cc: linux-kernel@vger.kernel.org, casey@schaufler-ca.com
In-Reply-To: <20080211232347.GA3635@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <655444.35935.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> On Mon, Feb 11, 2008 at 07:26:02PM +0100, Joerg Platte wrote:
> > Hi,
> > 
> > when booting linux 2.6.25-rc1 I get the following error:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 00000138
> > IP: [<c01aa59e>] smack_netlabel+0x13/0xc8
> > *pde = 00000000
> > Oops: 0000 [#1] PREEMPT
> > Modules linked in: nfsd 
> [...]
> > Call Trace:
> >  [<c01aacf8>] ? new_inode_smack+0x39/0x3f
> >  [<c01aad52>] ? smack_inode_alloc_security+0x16/0x27
> >  [<c01a7510>] ? security_inode_alloc+0x19/0x1b
> >  [<c01aa665>] ? smack_socket_post_create+0x12/0x18
> >  [<c01a7a06>] ? security_socket_post_create+0x16/0x1b
> >  [<c02116ce>] ? sock_create_lite+0x44/0x64
> >  [<c0211712>] ? kernel_accept+0x24/0x5f
> 
> Hi Joerg,
> 
> There's a small problem with smack and NFS. A similar report was also
> sent here: http://lkml.org/lkml/2007/10/27/85
> 
> Could you please check below patch ? I think it should fix your problem.
> 
> I've also added similar checks in inode_{get/set}security(). Cheating
> from SELinux post_create_socket(), it does the same. Casey, Thoughts ?

If it's only NFS being uncooperative, as opposed to Smack not
measuring up on socket handling in general, this might be the
way to go about dealing with this problem until Smack NFS support
proper goes in (no dates promised there!). I will have a better
look once I get my posting-email working again.


> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 1c11e42..eb04278 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -701,7 +701,7 @@ static int smack_inode_getsecurity(const struct inode
> *inode,
>  		return -EOPNOTSUPP;
>  
>  	sock = SOCKET_I(ip);
> -	if (sock == NULL)
> +	if (sock == NULL || sock->sk == NULL)
>  		return -EOPNOTSUPP;
>  
>  	ssp = sock->sk->sk_security;
> @@ -1280,10 +1280,12 @@ static void smack_to_secattr(char *smack, struct
> netlbl_lsm_secattr *nlsp)
>   */
>  static int smack_netlabel(struct sock *sk)
>  {
> -	struct socket_smack *ssp = sk->sk_security;
> +	struct socket_smack *ssp;
>  	struct netlbl_lsm_secattr secattr;
>  	int rc = 0;
>  
> +	BUG_ON(sk == NULL);
> +	ssp = sk->sk_security;
>  	netlbl_secattr_init(&secattr);
>  	smack_to_secattr(ssp->smk_out, &secattr);
>  	if (secattr.flags != NETLBL_SECATTR_NONE)
> @@ -1331,7 +1333,7 @@ static int smack_inode_setsecurity(struct inode *inode,
> const char *name,
>  		return -EOPNOTSUPP;
>  
>  	sock = SOCKET_I(inode);
> -	if (sock == NULL)
> +	if (sock == NULL || sock->sk == NULL)
>  		return -EOPNOTSUPP;
>  
>  	ssp = sock->sk->sk_security;
> @@ -1362,7 +1364,7 @@ static int smack_inode_setsecurity(struct inode *inode,
> const char *name,
>  static int smack_socket_post_create(struct socket *sock, int family,
>  				    int type, int protocol, int kern)
>  {
> -	if (family != PF_INET)
> +	if (family != PF_INET || sock->sk == NULL)
>  		return 0;
>  	/*
>  	 * Set the outbound netlbl.
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
