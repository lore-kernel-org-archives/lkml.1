Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbZKLQWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbZKLQWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZKLQWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:22:10 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:44323 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753298AbZKLQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:22:09 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: cUqKlhoVM1nWsLH8l5RkuEmGEMCZLcYC6gnbXZ9.czEnEvxlBq0FJrB7Q3xBYtpIRN1IMmhREa4CD0WpeuKRwlxYU6sRxQkGbsD_umoSfiIFThtN_83G26kh6aZXI3CHOM3dpaG1XXKB0hhQTos1M1aKawZCf9pYLTcK6j3z2gxoUgW46_q3Ia_C7uhlJixAEMtqhaQeOfUOMokVQhrTRHIawvcr_JkdHzCAzBgOg0a0NEVKpwIE_gnh6GRX1E2gx0GsiU58JRY9oyovaUZYvrtQADDI1gHjy0g_6adpXbNxcPGQonE.AqEMdDwmzZo5bzZwrcj5IetmxubUOZWY
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AFC3620.2020809@schaufler-ca.com>
Date: Thu, 12 Nov 2009 08:21:52 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com> <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> On Thu, 12 Nov 2009, Serge E. Hallyn wrote:
>
>   
>> Quoting James Morris (jmorris@namei.org):
>>     
>>> On Thu, 12 Nov 2009, Julia Lawall wrote:
>>>
>>>       
>>>> From: Julia Lawall <julia@diku.dk>
>>>>
>>>> As observed by Joe Perches, sizeof of a constant string includes the
>>>> trailing 0.  If what is wanted is to check the initial characters of
>>>> another string, this trailing 0 should not be taken into account.  If an
>>>> exact match is wanted, strcmp should be used instead.
>>>>         
>>>> --- a/security/selinux/hooks.c
>>>> +++ b/security/selinux/hooks.c
>>>> @@ -448,7 +448,7 @@ static int sb_finish_set_opts(struct sup
>>>>  		sbsec->flags &= ~SE_SBLABELSUPP;
>>>>  
>>>>  	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
>>>> -	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
>>>> +	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs") - 1) == 0)
>>>>  		sbsec->flags |= SE_SBLABELSUPP;
>>>>         
>>> Shouldn't this be a simple strcmp() ?
>>>       
>> Yes I think so.
>>
>> Julia seems to be arguing that if a module introduces a new fs with
>> name 'sysfs_foo' then this check should match that fs too (since
>> for sysfs, sb->s_type->name = "sysfs" which also has a trailing \0,
>> so for the regular sysfs her patch makes no practical difference).
>>     
>
> If strcmp is what is wanted, I can make a patch for that.
>   

I strongly suggest that this is not what is wanted.
    strcmp(x,y)
and
    strncmp(x,y,sizeof(y))

are functionally equivalent and strcmp has a bad reputation in
the security community because it is associated with potential
buffer overrun issues.

    strncmp(x,y,sizeof(y)-1)

is not the same and is more cluttered as well. This code
does not need to be changed. It does what it is intended
to do in a strait-forward manner.
> julia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   

