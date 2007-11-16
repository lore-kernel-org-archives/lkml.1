Return-Path: <linux-kernel-owner+w=401wt.eu-S934743AbXKPOav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743AbXKPOav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934402AbXKPO2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:28:22 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:35588 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934397AbXKPO2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:28:19 -0500
Message-ID: <473DA25B.2000702@linux.vnet.ibm.com>
Date: Fri, 16 Nov 2007 19:29:55 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Reply-To: ciju@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: aglitke <agl@us.ibm.com>
CC: linux-kernel@vger.kernel.org, wli@holomorphy.com
Subject: Re: [RFC] [PATCH] hugetlbfs :shmget with SHM_HUGETLB only works as
 root
References: <473B0317.6010603@linux.vnet.ibm.com> <1195054301.18047.20.camel@localhost.localdomain>
In-Reply-To: <1195054301.18047.20.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Adam,
 If this condition check is not included, the root user have to use the 
function
 setrlimit() to set the lock_limit of a normal user to RLIM_INFINITY.  I 
think
 the /proc interface 'hugetlb_shm_group' is introduced to avoid these 
difficulties.
 Please correct me, if I am wrong.

 Regarding the problem with the 'if' condition, I feel that even in the 
case of
 user's lock_limit is set to unlimited, he could use unlimited hugepages and
 normal page shm segments. So what is the advantage in this scenario.

 I tried to avoid the #ifdef statements. But the variable 
sysctl_hugetlb_shm_group is defined
 in fs/hugetlbfs/inode.c, this segment is enabled only when the config 
parameter
 CONFIG_HUGETLBFS is set to yes. If the hugetlbfs is  not selected while 
configuring,
 there would be a compilation error.

 Is there any better way so that the root user can configure the gid in 
'hugetlb_shm_group'
 and the user is able to access the huge pages using shmget().

Thanks
Ciju

aglitke wrote:
> Hi Ciju:
>
> I am still not exactly sure why this patch is needed.  As I read
> user_shm_lock():
>
>   
>> lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
>> if (lock_limit == RLIM_INFINITY)
>> 	allowed = 1;
>> lock_limit >>= PAGE_SHIFT;
>> spin_lock(&shmlock_user_lock);
>> if (!allowed &&
>>     locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
>> 	goto out;
>>     
>
> ... if the user's locked limit (ulimit -l) is set to unlimited, allowed
> (above) is set to 1.  In that case, the second part of that if() is
> bypassed, and the function grants permission.  Therefore, the easy
> solution is to make sure your user's lock_limit is RLIM_INFINITY.
>
> On Wed, 2007-11-14 at 19:45 +0530, Ciju Rajan K wrote:
> <snip>
>   
>> @@ -248,8 +249,14 @@ int user_shm_lock(size_t size, struct us
>>          allowed = 1;
>>      lock_limit >>= PAGE_SHIFT;
>>      spin_lock(&shmlock_user_lock);
>> +#ifdef CONFIG_HUGETLB_PAGE
>> +    if (!allowed &&
>> +        locked + user->locked_shm > lock_limit &&
>> +        (!(capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group))))
>>     
>
> This will allow any user in hugetlb_shm_group to make unlimited use of
> huge page shm segments _and_ normal page shm segments.  Definitely not
> what you want.
>
>   
>> +#else
>>      if (!allowed &&
>>          locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
>> +#endif
>>          goto out;
>>      get_uid(user);
>>      user->locked_shm += locked;
>>
>>     
>
> Please don't add new #ifdefs into .c files, headers only.
>
>   

