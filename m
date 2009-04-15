Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZDOQ3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZDOQ3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZDOQ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:29:15 -0400
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:26995 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751314AbZDOQ3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:29:15 -0400
X-YMail-OSG: jbpRz_0VM1mDw.9c5GrR_cIMMQxOGyN8nldM3Bn3EWXPoXByGNr16UZlYL1DAC1S8oQfl32n5.Z1bItrcmyIrw12lGsqXzOaVsWXYUlh5CdnBrGIqb6bL1RFtiptKGeDwxgki3nHcfTTi0u8Lv3EUFmubJn7HX4B_gmurPUeBYvZfRp__otwHTiOceLf6dF3HGbJoNA7u1vyVgBsJFWRDbq908O70fslbc80OpTFS6JBfRYaaRRABJjIvV5r_fuIxLhGaXaeHSEPNmJjQwWX4HZDLQ5s4R5IwfyFa.hfO3ejl4FuGMRngJvuWsItGmDZjuxL.EmiL8QBVEeCmeQ5LKI-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49E60B2D.5080508@schaufler-ca.com>
Date: Wed, 15 Apr 2009 09:28:29 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Etienne Basset <etienne.basset@numericable.fr>
CC: LSM <linux-security-module@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: check for SMACK xattr max size in  smack_inode_setxattr
References: <49E4D5B6.80202@numericable.fr> <49E561C8.90306@schaufler-ca.com> <49E57DFF.9030207@numericable.fr>
In-Reply-To: <49E57DFF.9030207@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Basset wrote:
> Casey Schaufler wrote:
>   
>> Etienne Basset wrote:
>>     
>>> the following patch move the check for SMACK xattr size >= SMK_LABELLEN
>>> from  smack_inode_post_setxattr (which cannot return an error to the user)
>>> to smack_inode_setxattr (which can return an error).
>>>
>>> without patch a SMACK setxattr with size >= SMK_LABELLEN returns success although it doesn't 
>>>   
>>>       
>> How about an early call to smk_import() to determine if the
>> label if legitimate, rather than checking the length? That
>> could save grief for other "invalid label" issues.
>>     
>
> Hi,
>
> both are needed. And we'll need one call in setxattr to check the validity and one in
> postsetxattr/ inode_setsecurity (to set the security blob)
> (which make me think we should split smk_import in 2,  smk_check/smk_import_nocheck or whatever)
>
> The harder issue is that smk_import can change the value/size of the xattr
> and smk_import can fail for 2 reasons : ENOMEM or EINVAL (not sure this is an issue though)
> (we should really split)
>
> root@etienne-desktop:/tmp# attr -S -s SMACK64 -V '123////' toto
> Attribute "SMACK64" set to a 7 byte value for toto:
> 123////
> root@etienne-desktop:/tmp# attr -S -g SMACK64 toto
> Attribute "SMACK64" had a 4 byte value for toto:
> 123
>
> maybe it would be nicer to fail than change the label under the foot of the-user-who-hasnt-read-the-doc?
>   

Clumsy attribute setting (trailing spaces, NULLs, etc) is just too easy.
I like the existing behavior.

> Etienne
>   
>>> Signed-off-by: Etienne Basset <etienne.basset@numericable.fr>
>>> ---
>>> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
>>> index 9215149..da6954d 100644
>>> --- a/security/smack/smack_lsm.c
>>> +++ b/security/smack/smack_lsm.c
>>> @@ -610,7 +610,8 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
>>>  		if (!capable(CAP_MAC_ADMIN))
>>>  			rc = -EPERM;
>>>  		/* a label cannot be void and cannot begin with '-' */
>>> -		if (size == 0 || (size > 0 && ((char *)value)[0] == '-'))
>>> +		if (size == 0 || size >= SMK_LABELLEN ||
>>> +		   (size > 0 && ((char *)value)[0] == '-'))
>>>  			rc = -EINVAL;
>>>  	} else
>>>  		rc = cap_inode_setxattr(dentry, name, value, size, flags);
>>> @@ -644,9 +645,6 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
>>>  	if (strcmp(name, XATTR_NAME_SMACK))
>>>  		return;
>>>  
>>> -	if (size >= SMK_LABELLEN)
>>> -		return;
>>> -
>>>  	isp = dentry->d_inode->i_security;
>>>  
>>>  	/*
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>   
>>>       
>>     
>
>
>   

