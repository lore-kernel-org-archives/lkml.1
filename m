Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbZEMM4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbZEMM4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbZEMM4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:56:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:4578 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbZEMM4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X0Kki637RoUdFwHrQlwCjWUrPp8RKJRk2PPegdngBkeewvSPCLJE3/Dsab783gjmwx
         2kcQuIHBC+IVT9wKGy/GTx9ej8Fg3v8EDV/E4tvXjOpYxjcAn9lZXO5rUAH6TctNT1BB
         LF2NFZc0iBz84OjUJKMC1dZRoRhGMTqqimX24=
MIME-Version: 1.0
In-Reply-To: <20090513130233.082eeee5@gondolin>
References: <1242174829-4694-1-git-send-email-tom.leiming@gmail.com>
	 <20090513130233.082eeee5@gondolin>
Date: Wed, 13 May 2009 20:56:40 +0800
Message-ID: <d82e647a0905130556y50620617i8c5ac597b6207406@mail.gmail.com>
Subject: Re: [PATCH] kernel:async function call:introduce async_run
From: Ming Lei <tom.leiming@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/13 Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Wed, 13 May 2009 08:33:49 +0800,
> tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> In fact, some async function call does not need to check, async_run
>> is right for this kind of function call. Also, async_run is very
>> suitable to used to start a thread in atomic context to do somthing,
>> for now there is no such kind of kernel api, eg. kthread_run
>> can not be started in atomic context.
>
> Could you rework your explanation a bit? If I understand correctly, you
> want to introduce a way to queue an async thread for those callers that
> don't want to synchronize on cookies.
>
>>
>> This patch is againt my another patch:
>>    kernel/async.c:introduce async_schedule*_atomic
>> please review.
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  include/linux/async.h |    1 +
>>  kernel/async.c        |   24 +++++++++++++++++++++++-
>>  2 files changed, 24 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/async.h b/include/linux/async.h
>> index ede9849..5390572 100644
>> --- a/include/linux/async.h
>> +++ b/include/linux/async.h
>> @@ -16,6 +16,7 @@
>>  typedef u64 async_cookie_t;
>>  typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
>>
>> +extern void async_run(async_func_ptr *ptr, void *data);
>>  extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
>>  extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
>>                                           struct list_head *list);
>> diff --git a/kernel/async.c b/kernel/async.c
>> index 6bf565b..9cc4670 100644
>> --- a/kernel/async.c
>> +++ b/kernel/async.c
>> @@ -60,6 +60,7 @@ asynchronous and synchronous parts of the kernel.
>>
>>  static async_cookie_t next_cookie = 1;
>>
>> +#define MAX_COOKIE   (~0)
>>  #define MAX_THREADS  256
>>  #define MAX_WORK     32768
>>
>> @@ -207,7 +208,10 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, \
>>       entry->running = running;
>>
>>       spin_lock_irqsave(&async_lock, flags);
>> -     newcookie = entry->cookie = next_cookie++;
>> +     if (atomic == 1)
>> +             newcookie = entry->cookie = next_cookie++;
>> +     else
>> +             newcookie = entry->cookie = MAX_COOKIE;
>
> This confuses me. Why do you change the behaviour for atomic == 0?

Yes, it needs to be fixed.

>
>>       list_add_tail(&entry->list, &async_pending);
>>       atomic_inc(&entry_count);
>>       spin_unlock_irqrestore(&async_lock, flags);
>> @@ -216,6 +220,24 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, \
>>  }
>>
>>  /**
>> + * async_run - schedule a function for asynchronous execution
>> + * @ptr: function to execute asynchronously
>> + * @data: data pointer to pass to the function
>> + *
>> + * Note:we do not allocate a cookie for this kind of aysnchronous
>> + * function to decrease the wait time of async_synchronize_full().
>
> But async_synchronize_full() still waits for list_empty(&async_running)
> - so what does this buy us?

I mean it can decrease the wait time for other async function.
async_schedule() still can be used to do such thing, but may lead to a
slower boot.  It is the main
purpose of the patch.

>
>> + * In fact, some function does not need to check, async_run is right
>> + * for this kind of function call. Also, async_run is very suitable to
>> + * start a thread to do somthing in atomic context,for now there is no such
>> + * kind of kernel api, eg. kthread_run can not be run in atomic context.
>
> Hm...
> "The purpose of this function is to offer a simple way to schedule an
> asynchronous thread, especially from an atomic context."
> Would that describe async_run() better?

Yes, very good, please forgive my poor english.

Thanks!

-- 
Lei Ming
