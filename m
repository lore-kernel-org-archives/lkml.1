Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbYBLIuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbYBLIuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbYBLIuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:50:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:49290 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbYBLIuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RgACLzriMDV3lPXPfaWa8NdnphlEzhq21hpvQZJT0x307zLvsFx4vSRajNuzQiucnXVHMceAuPwzc54ZiqgPh9NLol7U+D02bn23NUs1Nex+sCkyw3jugu3X1cUHAg5bUo4atp9r1Vyj9OgowdISQcxhWGUqEPM/2Lb7aaieFj4=
Date: Tue, 12 Feb 2008 08:57:14 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, paulmck@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fib_trie: rcu_assign_pointer warning fix
Message-ID: <20080212085714.GB2582@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211.171645.74019568.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-02-2008 02:16, David Miller wrote:
> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Mon, 11 Feb 2008 16:59:54 -0800
> 
> linux-kernel added to CC:, any change to generic kernel infrastructure
> should be posted there
> 
>> Eliminate warnings when rcu_assign_pointer is used with unsigned long.
>> It is reasonable to use RCU with non-pointer values so allow it for general
>> use.  Add a comment to explain the if test.
>>
>> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>> ---
>>  include/linux/rcupdate.h |   13 +++++++------
>>  1 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
>> index 37a642c..c44ac87 100644
>> --- a/include/linux/rcupdate.h
>> +++ b/include/linux/rcupdate.h
>> @@ -172,14 +172,15 @@ struct rcu_head {
>>   * structure after the pointer assignment.  More importantly, this
>>   * call documents which pointers will be dereferenced by RCU read-side
>>   * code.
>> + *
>> + * If value is the NULL (constant 0), then no barrier is needed.
>>   */
>>  
>> -#define rcu_assign_pointer(p, v) \
>> -	({ \
>> -		if (!__builtin_constant_p(v) || \
>> -		    ((v) != NULL)) \
>> -			smp_wmb(); \
>> -		(p) = (v); \
>> +#define rcu_assign_pointer(p, v)			\
>> +	({						\
>> +		if (!(__builtin_constant_p(v) && v))	\

...But, "If value is the NULL (constant 0)" we have:

if (!(1 && NULL != 0)) ==> if (!(0)) and the barrier is used?!

>> +			smp_wmb();			\
>> +		(p) = (v);				\
>>  	})
>>  
>>  /**


Regards,
Jarek P.
