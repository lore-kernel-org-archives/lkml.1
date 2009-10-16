Return-Path: <linux-kernel-owner+w=401wt.eu-S964772AbZJPB0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772AbZJPB0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 21:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbZJPB0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 21:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758879AbZJPB0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 21:26:35 -0400
Message-ID: <4AD7CC49.1080802@redhat.com>
Date: Fri, 16 Oct 2009 09:28:41 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Ben Woodard <bwoodard@llnl.gov>,
       David Howells <dhowells@redhat.com>,
       Brian Behlendorf <behlendorf1@llnl.gov>
Subject: Re: [Patch v5] rwsem: fix rwsem_is_locked() bugs
References: <20091014095503.4235.63028.sendpatchset@localhost.localdomain> <20091015164602.ac75126f.akpm@linux-foundation.org>
In-Reply-To: <20091015164602.ac75126f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 14 Oct 2009 05:52:22 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> --- a/include/linux/rwsem-spinlock.h
>> +++ b/include/linux/rwsem-spinlock.h
>> @@ -68,11 +68,9 @@ extern int __down_write_trylock(struct rw_semaphore *sem);
>>  extern void __up_read(struct rw_semaphore *sem);
>>  extern void __up_write(struct rw_semaphore *sem);
>>  extern void __downgrade_write(struct rw_semaphore *sem);
>> +extern int __rwsem_is_locked(struct rw_semaphore *sem);
>>  
>> -static inline int rwsem_is_locked(struct rw_semaphore *sem)
>> -{
>> -	return (sem->activity != 0);
>> -}
>> +#define rwsem_is_locked(sem) __rwsem_is_locked(sem)
>>  
>>  #endif /* __KERNEL__ */
>>  #endif /* _LINUX_RWSEM_SPINLOCK_H */
>> diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
>> index 9df3ca5..7014306 100644
>> --- a/lib/rwsem-spinlock.c
>> +++ b/lib/rwsem-spinlock.c
>> @@ -17,6 +17,19 @@ struct rwsem_waiter {
>>  #define RWSEM_WAITING_FOR_WRITE	0x00000002
>>  };
>>  
>> +int __rwsem_is_locked(struct rw_semaphore *sem)
>> +{
>> +	int ret = 1;
>> +	unsigned long flags;
>> +
>> +	if (spin_trylock_irqsave(&sem->wait_lock, flags)) {
>> +		ret = (sem->activity != 0);
>> +		spin_unlock_irqrestore(&sem->wait_lock, flags);
>> +	}
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(__rwsem_is_locked);
> 
> Why the macro tricks?  Can we do


Yes, better.

Thanks for your patch!

> 
> --- a/include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs-fix
> +++ a/include/linux/rwsem-spinlock.h
> @@ -68,9 +68,7 @@ extern int __down_write_trylock(struct r
>  extern void __up_read(struct rw_semaphore *sem);
>  extern void __up_write(struct rw_semaphore *sem);
>  extern void __downgrade_write(struct rw_semaphore *sem);
> -extern int __rwsem_is_locked(struct rw_semaphore *sem);
> -
> -#define rwsem_is_locked(sem) __rwsem_is_locked(sem)
> +extern int rwsem_is_locked(struct rw_semaphore *sem);
>  
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_RWSEM_SPINLOCK_H */
> --- a/lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs-fix
> +++ a/lib/rwsem-spinlock.c
> @@ -17,7 +17,7 @@ struct rwsem_waiter {
>  #define RWSEM_WAITING_FOR_WRITE	0x00000002
>  };
>  
> -int __rwsem_is_locked(struct rw_semaphore *sem)
> +int rwsem_is_locked(struct rw_semaphore *sem)
>  {
>  	int ret = 1;
>  	unsigned long flags;
> @@ -28,7 +28,7 @@ int __rwsem_is_locked(struct rw_semaphor
>  	}
>  	return ret;
>  }
> -EXPORT_SYMBOL(__rwsem_is_locked);
> +EXPORT_SYMBOL(rwsem_is_locked);
>  
>  /*
>   * initialise the semaphore
> _
> 

