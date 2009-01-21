Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbZAUNOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbZAUNOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbZAUNO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:14:26 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:33551 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbZAUNOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:14:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EEhqUqcNIDVQcJ4qehiKvhRILHLSSkHXQc18DRhyw4MWH1uIVWs2GnAuXxVQXrH5bR
         s6RGzPrTNwg1ocY1lQAWC49rsW36QozK0d10VHGzjXL+lykCoNUi0jWePY0Rr/t0tQYQ
         vMz+26x29fsLB9I/SlB/lq5lBSjBm8z8NdZxc=
MIME-Version: 1.0
In-Reply-To: <20090121111314.GA23469@elte.hu>
References: <20090121014615.GA21018@google.com>
	 <20090121111314.GA23469@elte.hu>
Date: Wed, 21 Jan 2009 14:14:23 +0100
Message-ID: <c62985530901210514o75a8ec67y1d48eedc996ee67b@mail.gmail.com>
Subject: Re: [PATCH] softlockup: remove hung_task_check_count
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@google.com>, linux-kernel@vger.kernel.org,
       rientjes@google.com, mbligh@google.com, thockin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/21 Ingo Molnar <mingo@elte.hu>:
>
> * Mandeep Singh Baines <msb@google.com> wrote:
>
>>       read_lock(&tasklist_lock);
>>       do_each_thread(g, t) {
>> -             if (!--max_count)
>> -                     goto unlock;
>> +             if (!--max_count) {
>> +                     /*
>> +                      * Drop the lock every once in a while and resched if
>> +                      * necessary. Don't want to hold the lock too long.
>> +                      */
>> +                     get_task_struct(t);
>> +                     read_unlock(&tasklist_lock);
>> +                     max_count = HUNG_TASK_CHECK_COUNT;
>> +                     if (need_resched())
>> +                             schedule();
>> +                     read_lock(&tasklist_lock);
>> +                     put_task_struct(t);
>> +                     /*
>> +                      * t was unlinked from tasklist. Can't continue in this
>> +                      * case. Exit and try again next time.
>> +                      */
>> +                     if (t->state == TASK_DEAD)
>> +                             goto unlock;
>> +             }
>
> firstly, this bit should move into a helper function. Also, why dont you
> do the need_resched() check first (it's very lighweight) - and thus only
> do the heavy ops (get-task-struct & tasklist_lock unlock) if that is set?
>
> But most importantly, isnt the logic above confused? --max_count will
> reach zero exactly once, and then we'll loop for a long time.
>
>        Ingo
>

Thanks Mandeep for this patch.

By reading Ingo's review, I notice that the checks done by
check_hung_task() are quite lightweight and then quick.
I guess your loop is able to go through a good number of tasks before
actually needing to be resched.
Perhaps the max_count can be dropped actually, since it is a kind of
arbitrary chosen constant.
So you would just need to check need_resched() at each iteration.

ie (should be split in helper functions):

bool retry = false;

do {
	read_lock(&tasklist_lock);
	do_each_thread(g, t) {
		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
		if (t->state == TASK_UNINTERRUPTIBLE)
			check_hung_task(t, now, timeout);
                if (need_resched()) {
                    get_task_struct(t);
                    read_unlock(&tasklist_lock);
                    schedule();
                    read_lock(&tasklist_lock);
                    put_task_struct(t);

                    if (t->state == TASK_DEAD) {
                        retry = true;
                        goto unlock;
                    }
                }

	} while_each_thread(g, t);
 unlock:
	read_unlock(&tasklist_lock);
} while(retry);


There are good chances that your "t" task hasn't died, but if so, you
can just retry the whole thing.
Perhaps that should require some tests to see if there is a good
average of t->stat == TASK_DEAD path not taken,
but of course, it depends on what the system is doing most.

What do you think?
