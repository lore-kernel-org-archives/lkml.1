Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbZELP6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbZELP6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758663AbZELP5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:57:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:58935 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786AbZELP5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LwQ3OBq+TjhtSsKXwX0YEo7YriHIhMDJ4BRhk8cynmBrFWtoa9Sn13IAI+dKwjJ4y3
         AvQ7Txj25isXYwlh2GQdV5eqWFoNkllQKaHzMD473+KU683b6kqWluMLx4zuR87TamPB
         gsPVXP3nteFSqIdgSZjRipBz8c/yMjDwODg6E=
Date: Tue, 12 May 2009 23:58:42 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: tom.leiming@gmail.com, arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
Message-ID: <20090512155842.GE30014@hack>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com> <20090512154456.GC6255@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512154456.GC6255@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 05:44:58PM +0200, Frederic Weisbecker wrote:
>On Tue, May 12, 2009 at 11:13:42PM +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>> 
>> The async_schedule* may not be called in atomic contexts if out of
>> memory or if there's too much work pending already, because the
>> async function to be called may sleep.
>> 
>> This patch fixes the comment of async_schedule*, and introduces
>> async_schedules*_atomic to allow them called from atomic contexts
>> safely.
>
>
>
>Aah, great. Such helper could easily replace some workqueues
>which receive (in atomic) rare jobs but still need to exist because
>they execute jobs which take too much time to be enqueued in kevents.
>
>A good candidate: kpsmoused!
>
>
> 
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  include/linux/async.h |    3 ++
>>  kernel/async.c        |   56 ++++++++++++++++++++++++++++++++++++++++++------
>>  2 files changed, 52 insertions(+), 7 deletions(-)
>> 
>> diff --git a/include/linux/async.h b/include/linux/async.h
>> index 68a9530..ede9849 100644
>> --- a/include/linux/async.h
>> +++ b/include/linux/async.h
>> @@ -19,6 +19,9 @@ typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
>>  extern async_cookie_t async_schedule(async_func_ptr *ptr, void *data);
>>  extern async_cookie_t async_schedule_domain(async_func_ptr *ptr, void *data,
>>  					    struct list_head *list);
>> +extern async_cookie_t async_schedule_atomic(async_func_ptr *ptr, void *data);
>> +extern async_cookie_t async_schedule_domain_atomic(async_func_ptr *ptr, \
>
>
>trailing backslash?
>
>
>> +					void *data, struct list_head *list);
>>  extern void async_synchronize_full(void);
>>  extern void async_synchronize_full_domain(struct list_head *list);
>>  extern void async_synchronize_cookie(async_cookie_t cookie);
>> diff --git a/kernel/async.c b/kernel/async.c
>> index 968ef94..6bf565b 100644
>> --- a/kernel/async.c
>> +++ b/kernel/async.c
>> @@ -172,12 +172,13 @@ out:
>>  }
>>  
>>  
>> -static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct list_head *running)
>> +static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, \
>
>
>another one.
>
>
>> +				struct list_head *running, int atomic)
>>  {
>>  	struct async_entry *entry;
>>  	unsigned long flags;
>>  	async_cookie_t newcookie;
>> -	
>> +	int  sync_run = 0;
>>  
>>  	/* allow irq-off callers */
>>  	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
>> @@ -186,7 +187,9 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct l
>>  	 * If we're out of memory or if there's too much work
>>  	 * pending already, we execute synchronously.
>>  	 */
>> -	if (!async_enabled || !entry || atomic_read(&entry_count) > MAX_WORK) {
>> +	sync_run = !async_enabled || !entry || \
>> +			atomic_read(&entry_count) > MAX_WORK;


And also this one...

Hey, Ming, none of these are macros... You don't need to add backslash to
join two lines, C compilers can recognize.

-- 
Live like a child, think like the god.
 
