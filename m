Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZDQDtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZDQDtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 23:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZDQDtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 23:49:13 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:35219 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752664AbZDQDtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 23:49:12 -0400
X-YMail-OSG: _xP1h7EVM1mCSE4ByTKVMxj3LI2_eNi4B.bRGBKQyM8nKViJ3qf73Mz6Pu3nk5WNGNBCcLxt4iGzqkiYFQ2wXpXNAgAbqYFlLTIveiX_AcWIveieQ1HMEwzzszqvRcU5Vzt0lBth9f8f7Jugp4bFaqdPJyt0navECK1wT8XGwNKk_m6UWTVJf0lUNguj8RkGGqoiVzJ38ElJlajTl64bkg8_NoCG7hvNBHRA1iYxJO0J79F.H.nj4PfKBUF972BoLVhl5h.V4rR4TaGVfV0z9Gjg0KXWECvUfc7HfcYMAyLs6k7tZ95qxud3SiCkAwvMsgNP5N6WxiuTbyOPFPGxIfo-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49E7FC03.20605@schaufler-ca.com>
Date: Thu, 16 Apr 2009 20:48:19 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Etienne Basset <etienne.basset@numericable.fr>
CC: LSM <linux-security-module@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: check for SMACK xattr validity in smack_inode_setxattr
References: <49E4D5B6.80202@numericable.fr> <49E561C8.90306@schaufler-ca.com> <49E57DFF.9030207@numericable.fr> <49E60B2D.5080508@schaufler-ca.com> <49E7AA12.2090406@numericable.fr>
In-Reply-To: <49E7AA12.2090406@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Basset wrote:
> the following patch moves checks for SMACK xattr validity
> from smack_inode_post_setxattr (which cannot return an error to the user)
> to smack_inode_setxattr (which can return an error).
>
> Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 9215149..98b3195 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -609,8 +609,12 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
>  	    strcmp(name, XATTR_NAME_SMACKIPOUT) == 0) {
>  		if (!capable(CAP_MAC_ADMIN))
>  			rc = -EPERM;
> -		/* a label cannot be void and cannot begin with '-' */
> -		if (size == 0 || (size > 0 && ((char *)value)[0] == '-'))
> +		/*
> +		 * check label validity here so import wont fail on
> +		 * post_setxattr
> +		 */
> +		if (size == 0 || size >= SMK_LABELLEN ||
> +		    smk_import(value, size) == NULL)
>  			rc = -EINVAL;
>  	} else
>  		rc = cap_inode_setxattr(dentry, name, value, size, flags);
> @@ -644,9 +648,6 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
>  	if (strcmp(name, XATTR_NAME_SMACK))
>  		return;
>  
> -	if (size >= SMK_LABELLEN)
> -		return;
> -
>  	isp = dentry->d_inode->i_security;
>  
>  	/*
>
>
>
>   

