Return-Path: <linux-kernel-owner+w=401wt.eu-S935191AbYEVBAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191AbYEVBAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbYEVA7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:59:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58582 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758937AbYEVA7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:59:48 -0400
Message-ID: <4834C54D.90800@cn.fujitsu.com>
Date: Thu, 22 May 2008 08:58:53 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, morgan@kernel.org,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org
Subject: Re: [PATCH] capabilities: fix sys_prctl() returned uninitialized
 value
References: <4833ED6D.8030606@cn.fujitsu.com> <20080521123802.GB7715@sergelap.austin.ibm.com>
In-Reply-To: <20080521123802.GB7715@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Shi Weihua (shiwh@cn.fujitsu.com):
>> When we test kernel by the latest LTP(20080430) on ia64,
>> the following failure occured:
>> -------------------------------------
>> prctl01     1  PASS  :  Test Passed
>> prctl01     0  WARN  :  prctl() returned 2048 errno = 0 : Success
>> prctl01     1  PASS  :  Test Passed
>> prctl01     2  FAIL  :  Test Failed
>> -------------------------------------
>>
>> We found commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c
>> causes this failure by git-bisect.
>> And, we found *rc_p has not been initialized if switch-default 
>> of the function cap_task_prctl()(security/commoncap.c). When *rc_p
>> uninitialized, sys_prctl() will return a wrong value.
>>
>> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com> 
>> ---
>> diff --git a/security/commoncap.c b/security/commoncap.c
>> index 5edabc7..a4b28c8 100644
>> --- a/security/commoncap.c
>> +++ b/security/commoncap.c
>> @@ -649,6 +649,7 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>>
>>  	default:
>>  		/* No functionality available - continue with default */
>> +		*rc_p = 0;
>>  		return 0;
>>  	}
> 
> No, this case here means that the capability module is not taking
> responsibility for this call.  So it should not be setting rc_p.

Ok, we noticed the comment as following in include/linux/security.h.
+ *      @rc_p contains a pointer to communicate back the forced return code
+ *     Return 0 if permission is granted, and non-zero if the security module
+ *      has taken responsibility (setting *rc_p) for the prctl call.

> 
> So you'll want to find another path in kernel/sys.c:sys_prctl()
> where error doesn't get set.  Do you know what 'i' was in prctl01
> at the time of failure?

'i' was 1 (PR_SET_PDEATHSIG).

I will create a new patch ASAP.

Thanks.

> 
> For instance, I notice that PR_SET_DUMPABLE doesn't set the value
> of error if arg2 is valid.  Also PR_SET_NAME and PR_GET_NAME
> don't set error.
> 
> -serge
> 
> 
> 

