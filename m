Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZBLSbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZBLSbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZBLSbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:31:06 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:19572 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZBLSbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:31:05 -0500
Message-ID: <49946AAC.4070107@oracle.com>
Date: Thu, 12 Feb 2009 10:30:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Mimi Zohar <zohar@us.ibm.com>,
       akpm <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH -next] security/audit/ima: fix build error
References: <20090210194121.80256b72.sfr@canb.auug.org.au>	 <4991DBA0.1000008@oracle.com>	 <20090211094050.47c4828d.sfr@canb.auug.org.au>	 <OFF3345B15.9471295A-ON8525755A.00024CFE-8525755A.0002C8E8@us.ibm.com>	 <20090212095414.733dd248.randy.dunlap@oracle.com> <1234463058.3104.7.camel@localhost.localdomain>
In-Reply-To: <1234463058.3104.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49946A95.016D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar wrote:
> On Thu, 2009-02-12 at 09:54 -0800, Randy Dunlap wrote:
>> On Tue, 10 Feb 2009 19:30:24 -0500 Mimi Zohar wrote:
>>
>>> Stephen Rothwell <sfr@canb.auug.org.au> wrote on 02/10/2009 05:40:50 PM:
>>>
>>>> Hi Randy,
>>>>
>>>> On Tue, 10 Feb 2009 11:55:12 -0800 Randy Dunlap 
>>> <randy.dunlap@oracle.com> wrote:
>>>>> Stephen Rothwell wrote:
>>>>>> Dropped trees (temporarily):
>>>>>>    audit (difficult conflicts)
>>>>> Maybe this is fixed by the dropped audit tree?
>>>> The audit tree is Al Viro's (cc'd).  But I *think* everything in it has
>>>> been applied upstream.
>>>>
>>>>> linux-next-20090210/security/integrity/ima/ima_policy.c:111: error: 
>>> implicit
>>>> declaration of function 'security_audit_rule_match'
>>>>> linux-next-20090210/security/integrity/ima/ima_policy.c:230: error: 
>>> implicit
>>>> declaration of function 'security_audit_rule_init'
>>>>> when
>>>>> CONFIG_SECURITY=y
>>>>> CONFIG_AUDIT=n
>>>>> CONFIG_IMA=y
>>>>> CONFIG_IMA_AUDIT=y
>>>> This looks more like a security subsystem than audit to me?
>>> These are the IMA Kconfig rules:
>>> CONFIG_IMA=y
>>> CONFIG_IMA_MEASURE_PCR_IDX=10
>>> CONFIG_IMA_AUDIT=y
>>> CONFIG_IMA_LSM_RULES=y
>>>
>>> CONFIG_IMA_LSM_RULES requires the audit subsystem.  The default
>>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> measurement policy is not defined terms of the LSM extended
>>> attributes, and thus is not required.
>>
>> This config still fails to build in linux-next-20090212.  And the ^^^
>> statement above may be correct, but it's not enforced in Kconfig, so let's
>> do that, OK?
> 
> The patch looks good to me, but looking at the code,
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=blob_plain;f=mm/shmem.c;hb=168b70b72a78f289046823d810c29376e211a6de
> it doesn't look like the previous patch was applied.

Which previous patch?  The one for ima & SHMEM=n?
Yes, that build combination still fails also.

James...?


>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> IMA_LSM_RULES requires AUDIT.  This is automatic if SECURITY_SELINUX=y
>> but not when SECURITY_SMACK=y (and SECURITY_SELINUX=n), so make the
>> dependency explicit.  This fixes the following build error:
>>
>> security/integrity/ima/ima_policy.c:111:error: implicit declaration of function 'security_audit_rule_match'
>> security/integrity/ima/ima_policy.c:230:error: implicit declaration of function 'security_audit_rule_init'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Mimi Zohar <zohar@us.ibm.com>
> 
>> ---
>>  security/integrity/ima/Kconfig |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- linux-next-20090212.orig/security/integrity/ima/Kconfig
>> +++ linux-next-20090212/security/integrity/ima/Kconfig
>> @@ -49,7 +49,7 @@ config IMA_AUDIT
>>
>>  config IMA_LSM_RULES
>>  	bool
>> -	depends on IMA && (SECURITY_SELINUX || SECURITY_SMACK)
>> +	depends on IMA && AUDIT && (SECURITY_SELINUX || SECURITY_SMACK)
>>  	default y
>>  	help
>> -	  Disabling this option will disregard LSM based policy rules
>> +	  Disabling this option will disregard LSM based policy rules.


-- 
~Randy
