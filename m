Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZDOE0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZDOE0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 00:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbZDOE0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 00:26:31 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:42069 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750794AbZDOE0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 00:26:30 -0400
X-YMail-OSG: Uw9jBzMVM1mfu3pul50joI98mp938mOrHALc936Qjd_3HTgo21VG3K7PU8Jv7zq1Ye57yFmIop365jOwlfn8npVp9DDgzEvW3A.GoZlzAjGjMtxdr8ZXZh3URCMd42oJI2TKcIsJX11f55zGRkoa7QO8duqUyBww9h0.ZNXodQn26JKCF8K3uXnP8NyMfSagC3hNR6Hc2Latm7VH4vzG2GazKk3dOvalcC50R8e4Z0DlLTynmSmc_Xcck5DJYMJUpwsi2SFQ_Myz94GqkVHEIGEAfYgbQZoTjTEMqjszzktX.HhnuR2PUw8BuAdtyin7I92Em_DbXnUe2OeduNR8fGc-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49E561C8.90306@schaufler-ca.com>
Date: Tue, 14 Apr 2009 21:25:44 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Etienne Basset <etienne.basset@numericable.fr>
CC: LSM <linux-security-module@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: check for SMACK xattr max size in  smack_inode_setxattr
References: <49E4D5B6.80202@numericable.fr>
In-Reply-To: <49E4D5B6.80202@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Basset wrote:
> the following patch move the check for SMACK xattr size >= SMK_LABELLEN
> from  smack_inode_post_setxattr (which cannot return an error to the user)
> to smack_inode_setxattr (which can return an error).
>
> without patch a SMACK setxattr with size >= SMK_LABELLEN returns success although it doesn't 
>   

How about an early call to smk_import() to determine if the
label if legitimate, rather than checking the length? That
could save grief for other "invalid label" issues.

> Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
> ---
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 9215149..da6954d 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -610,7 +610,8 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
>  		if (!capable(CAP_MAC_ADMIN))
>  			rc = -EPERM;
>  		/* a label cannot be void and cannot begin with '-' */
> -		if (size == 0 || (size > 0 && ((char *)value)[0] == '-'))
> +		if (size == 0 || size >= SMK_LABELLEN ||
> +		   (size > 0 && ((char *)value)[0] == '-'))
>  			rc = -EINVAL;
>  	} else
>  		rc = cap_inode_setxattr(dentry, name, value, size, flags);
> @@ -644,9 +645,6 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

