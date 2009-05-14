Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZENEgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZENEgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 00:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZENEg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 00:36:27 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:55014 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZENEg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 00:36:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tjNbfwF2BkCVuwaCkqM6iEtLNZlC36AlPUDlorAuRIADSjbFeZzuvBn8duyw1jTh4p
         6NL3Yufi7vlV63wX2OW7qG1BKHHs/v6Nnic0ziFaDhPIPs5StcvoAwDNg9Kep8VZbbbe
         zfIpuCBSDIAEjAF5YOzDIcnSh76q5LYy/+2TM=
MIME-Version: 1.0
In-Reply-To: <20090513191144.6aae00d7@gondolin>
References: <1242229899-16761-1-git-send-email-tom.leiming@gmail.com>
	 <20090513191144.6aae00d7@gondolin>
Date: Thu, 14 May 2009 12:36:27 +0800
Message-ID: <d82e647a0905132136g355d6ad4y697e58af0a360c45@mail.gmail.com>
Subject: Re: [PATCH] kernel:async function call:introduce async_run_inatomic(v2)
From: Ming Lei <tom.leiming@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/14 Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Wed, 13 May 2009 23:51:39 +0800,
> tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> The purpose of this function is to offer a simple way to schedule an
>> asynchronous thread from an atomic context, because there are not any
>> functions which can create and start a kernel thread in atomic contexts
>> now. We use async_running_no_sync as running list to make callers that
>> don't want to synchronize on cookies, so can avoid some side effects for
>> async_synchronize_full().
>>
>> Part of note for async_run_inatomic and some guideline is from Cornelia Huck.
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>> ---
>>  include/linux/async.h |    2 ++
>>  kernel/async.c        |   23 +++++++++++++++++++++++
>>  2 files changed, 25 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/async.h b/include/linux/async.h
>> index 18ce92b..9ff62af 100644
>> --- a/include/linux/async.h
>> +++ b/include/linux/async.h
>> @@ -16,6 +16,8 @@
>>  typedef u64 async_cookie_t;
>>  typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
>>
>> +extern int async_run_inatomic(async_func_ptr *ptr, void *data);
>> +
>>  extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
>>  extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
>>                                           struct list_head *list);
>> diff --git a/kernel/async.c b/kernel/async.c
>> index 8663f5b..cb527b3 100644
>> --- a/kernel/async.c
>> +++ b/kernel/async.c
>> @@ -65,6 +65,7 @@ static async_cookie_t next_cookie = 1;
>>
>>  static LIST_HEAD(async_pending);
>>  static LIST_HEAD(async_running);
>> +static LIST_HEAD(async_running_no_sync);
>>  static DEFINE_SPINLOCK(async_lock);
>>
>>  static int async_enabled = 0;
>> @@ -222,6 +223,28 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data,
>>       return newcookie;
>>  }
>>
>> + /**
>> + * async_run_inatomic - in atomic contexts schedule a function for
>> + *                   asynchronous execution
>
> I'm not 100% sure whether kerneldoc likes split lines for the
> description.
>
> "async_run_inatomic - schedule a function for asynchronous execution from atomic context without checkpointing"
> - but that's really a bit long...
>
>> + *
>> + * @ptr: function to execute asynchronously
>> + * @data: data pointer to pass to the function
>> + *
>> + * Return zero if success, or else return others if failured
>
> Returns zero on success, !zero on failure
>
>> + * Note:
>
> I'd move the description of the function's purpose before Note:.
>
>> + * The purpose of this function is to offer a simple way to schedule an
>> + * asynchronous thread from an atomic context, because there are not any
>> + * functions which can create and start a kernel thread in atomic contexts
>> + * now.
>
> I don't think the second part of the sentence is needed, this should
> only be mentioned in the patch description. I'd rather add
>
> "Since it does not return a cookie for checkpointing, it is for callers
> that don't need later synchronization."
>
>> We use async_running_no_sync as running list to make callers that
>> + * don't want to synchronize on cookies, so can avoid some side effects for
>> + * async_synchronize_full().
>
> "async_run_inatomic() uses a distinct running list in order to avoid
> slowing down synchronization within the general domain."
>
> (The cookie will still be checked when __lowest_in_progress() returns
> the cookie for the async_pending list, but I think that is negligible -
> and it would be a general issue for special domains.)

Yes, it still needs some synchronization before the non-sync function
entry is moved
into async_running_no_sync, but it is negligible really.

>
>> + */
>> +int async_run_inatomic(async_func_ptr *ptr, void *data)
>> +{
>> +     return !__async_schedule(ptr, data, &async_running_no_sync, 1);
>> +}
>> +EXPORT_SYMBOL_GPL(async_run_inatomic);
>> +
>>  /**
>>   * async_schedule - schedule a function for asynchronous execution
>>   * @ptr: function to execute asynchronously
>
> Btw: Do you have any specific use cases for this function in mind?
>

For example request_firmware_nowait(), this function declares it can be
called in contexts where it is not possible to sleep, but really can
not be called
in irq contexts, because the function calls kthread_run to do firmware loading.

-- 
Lei Ming
