Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbZGMIIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbZGMIIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 04:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZGMIIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 04:08:19 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:61288 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZGMIIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 04:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kq05IXP+HKL1ee74ruOf0XAP7hqFLTzGeOSLRrOTjjKLlUJJTn8ZrA0P4TuLPzQXHg
         y952+MpQgzDSTFX73w7KWTUA3S+gTooL7p1/nwi0u8M1kPAG/AtwUD5hTvgJxDR5Mx8G
         ZauhIQwgBPxnFIzUIJYwJcTbjPRAo+0nZ2+mc=
MIME-Version: 1.0
In-Reply-To: <20090713080205.GA2187@darkstar>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
	 <1246201486-7308-5-git-send-email-tom.leiming@gmail.com>
	 <20090713080205.GA2187@darkstar>
Date: Mon, 13 Jul 2009 16:08:16 +0800
Message-ID: <a8e1da0907130108y18e56346paaa87e0779ddf743@mail.gmail.com>
Subject: Re: [RESEND PATCH 04/11] kernel:lockdep:implement check_noncircular() 
	by BFS
From: Dave Young <hidave.darkstar@gmail.com>
To: tom.leiming@gmail.com
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 4:02 PM, Dave Young<hidave.darkstar@gmail.com> wrote:
> On Sun, Jun 28, 2009 at 11:04:39PM +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> This patch uses BFS to implement check_noncircular() and
>> prints the generated shortest circle if exists.
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  kernel/lockdep.c |   89 ++++++++++++++++++++++-------------------------------
>>  1 files changed, 37 insertions(+), 52 deletions(-)
>>
>> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
>> index ce6d09e..f740088 100644
>> --- a/kernel/lockdep.c
>> +++ b/kernel/lockdep.c
>> @@ -985,12 +985,7 @@ static inline int __bfs_backward(struct lock_list *src_entry,
>>   * Recursive, forwards-direction lock-dependency checking, used for
>>   * both noncyclic checking and for hardirq-unsafe/softirq-unsafe
>>   * checking.
>> - *
>> - * (to keep the stackframe of the recursive functions small we
>> - *  use these global variables, and we also mark various helper
>> - *  functions as noinline.)
>>   */
>> -static struct held_lock *check_source, *check_target;
>>
>>  /*
>>   * Print a dependency chain entry (this is only done when a deadlock
>> @@ -1014,7 +1009,9 @@ print_circular_bug_entry(struct lock_list *target, unsigned int depth)
>>   * header first:
>>   */
>>  static noinline int
>> -print_circular_bug_header(struct lock_list *entry, unsigned int depth)
>> +print_circular_bug_header(struct lock_list *entry, unsigned int depth,
>> +                     struct held_lock *check_src,
>> +                     struct held_lock *check_tgt)
>>  {
>>       struct task_struct *curr = current;
>>
>> @@ -1027,9 +1024,9 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth)
>>       printk(  "-------------------------------------------------------\n");
>>       printk("%s/%d is trying to acquire lock:\n",
>>               curr->comm, task_pid_nr(curr));
>> -     print_lock(check_source);
>> +     print_lock(check_src);
>>       printk("\nbut task is already holding lock:\n");
>> -     print_lock(check_target);
>> +     print_lock(check_tgt);
>>       printk("\nwhich lock already depends on the new lock.\n\n");
>>       printk("\nthe existing dependency chain (in reverse order) is:\n");
>>
>> @@ -1043,36 +1040,24 @@ static inline int class_equal(struct lock_list *entry, void *data)
>>       return entry->class == data;
>>  }
>>
>> -static noinline int print_circular_bug(void)
>> +static noinline int print_circular_bug(struct lock_list *this,
>
> Shouldn't be 'static noinline int' here? Same question to following ones.
>

Sorry for pointing to wrong place. please grep to find them:

161:+static int noinline print_bfs_bug(int ret)
173: static int noinline print_infinite_recursion_bug(void)

-- 
Regards
dave
