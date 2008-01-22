Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYAVWOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYAVWOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYAVWNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:13:51 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25628 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYAVWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:13:50 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Casey Schaufler <cschaufler@mvista.com>
Subject: Re: [PATCH] (2.6.24-rc8-mm1)  -mm v2 Smack socket label setting fix
Date: Tue, 22 Jan 2008 17:13:45 -0500
User-Agent: KMail/1.9.7
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <47928214.60800@mvista.com>
In-Reply-To: <47928214.60800@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221713.45620.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 6:04:52 pm Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
>
> Correct the checks in smack_inode_setxattr to include the
> socket labeling attributes. Simplify and correct
> smack_sock_graft, while the values it was setting were
> safe they were not correct and the job was not being
> done efficiently. smack_inode_setsecurity wasn't
> invoking the required netlabel function in the case
> where smk_ipout was set. It does now, but that change
> required the hook to be moved in the file. This
> movement accounts for the bulk of the patch.
>
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

...

> +/**
>   * smack_socket_post_create - finish socket setup
>   * @sock: the socket
>   * @family: protocol family
> @@ -2192,33 +2199,20 @@ static int smack_socket_getpeersec_dgram
>  static void smack_sock_graft(struct sock *sk, struct socket *parent)
>  {
>  	struct socket_smack *ssp;
> -	struct netlbl_lsm_secattr secattr;
> -	char smack[SMK_LABELLEN];
>  	int rc;

I don't think you need 'rc'.

> -	if (sk == NULL || parent == NULL || parent->sk == NULL)
> +	if (sk == NULL)
>  		return;

I'm pretty sure you don't need to check 'sk' to ensure it is non-NULL; 
SELinux assumes 'sk' is non-NULL and it hasn't caused any problems.

>  	if (sk->sk_family != PF_INET && sk->sk_family != PF_INET6)
>  		return;
>
> -	ssp = parent->sk->sk_security;
> -
> -	memset(smack, '\0', SMK_LABELLEN);
> -	netlbl_secattr_init(&secattr);
> -	rc = netlbl_sock_getattr(sk, &secattr);
> -	if (rc == 0)
> -		smack_from_secattr(&secattr, smack);
> -	else
> -		strncpy(smack, smack_known_huh.smk_known, SMK_MAXLEN);
> -	netlbl_secattr_destroy(&secattr);
> -
> -	netlbl_secattr_init(&secattr);
> +	ssp = sk->sk_security;
> +	ssp->smk_in = current->security;
> +	ssp->smk_out = current->security;
> +	ssp->smk_packet[0] = '\0';
>
> -	smack_to_secattr(smack, &secattr);
> -	if (secattr.flags != NETLBL_SECATTR_NONE)
> -		rc = netlbl_sock_setattr(parent->sk, &secattr);
> -	netlbl_secattr_destroy(&secattr);
> +	rc = smack_netlabel(sk);

I haven't checked the latest SMACK bits, but I'm pretty sure you don't 
need to assign the return value of 'smack_netlabel()' to anything here 
since the function doesn't return a value.

>  }
>
>  /**



-- 
paul moore
linux security @ hp
