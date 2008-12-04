Return-Path: <linux-kernel-owner+w=401wt.eu-S1758930AbYLDS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930AbYLDS22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbYLDS2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:28:16 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:62174 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbYLDS2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:28:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QXJg+58m3jqobB0Ay6aMDIYWer1HoenCFd8gQP4Ka2xKBGkkn8C7mOiN+bN46on0EX
         koIV0AFCtopV10vBqy/RmyuSg/YXgfrhKu/2+BzWQV+X9JgQtEnREh+CfGj6zEIQ4TFo
         Aq6Xn7KA4MH5ocu3BFB0F6PT2XvclTtjoq1xA=
Message-ID: <c62985530812041028u3d276f6g8e6599c44c9cc76@mail.gmail.com>
Date: Thu, 4 Dec 2008 19:28:12 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-graph-tracer: handle ftrace_printk entries
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Tim Bird" <tim.bird@am.sony.com>, "Pekka Paalanen" <pq@iki.fi>
In-Reply-To: <alpine.DEB.1.10.0812032113260.28153@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49370BF7.6040108@gmail.com>
	 <alpine.DEB.1.10.0812032113260.28153@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/4 Steven Rostedt <rostedt@goodmis.org>:
>
> On Wed, 3 Dec 2008, Frederic Weisbecker wrote:
>
>> Handle the TRACE_PRINT entries from the function grapg tracer
>> and output them as a C comment just below the function that called
>> it, as if it was a comment inside this function.
>
> Cool, thanks!
>
>>
>> Example with an ftrace_printk inside might_sleep() function:
>>
>> void __might_sleep(char *file, int line)
>> {
>>       static unsigned long prev_jiffy;        /* ratelimiting */
>>
>>       ftrace_printk("Hi I'm a comment in might_sleep() :-)");
>>
>> A chunk of a resulting trace:
>>
>>  0)               |                                _reiserfs_free_block() {
>>  0)               |                                  reiserfs_read_bitmap_block() {
>>  0)               |                                    __bread() {
>>  0)               |                                      __getblk() {
>>  0)               |                                        __find_get_block() {
>>  0)   0.698 us    |                                          mark_page_accessed();
>>  0)   2.267 us    |                                        }
>>  0)               |                                        __might_sleep() {
>>  0)               |                                          /* Hi I'm a comment in might_sleep() :-) */
>>  0)   1.321 us    |                                        }
>>  0)   5.872 us    |                                      }
>>  0)   7.313 us    |                                    }
>>  0)   8.718 us    |                                  }
>>
>> And this patch bring two minor fixes:
>>
>> _ The newline after a switch-out task has disappeared
>> _ The "|" sign just before the cpu number on task-switch has been deleted.
>>
>>  0)   0.616 us    |                pick_next_task_rt();
>>  0)   1.457 us    |                _spin_trylock();
>>  0)   0.653 us    |                _spin_unlock();
>>  0)   0.728 us    |                _spin_trylock();
>>  0)   0.631 us    |                _spin_unlock();
>>  0)   0.729 us    |                native_load_sp0();
>>  0)   0.593 us    |                native_load_tls();
>>  ------------------------------------------
>>  0)    cat-2834    =>   migrati-3
>>  ------------------------------------------
>>
>>  0)               |    finish_task_switch() {
>>  0)   0.841 us    |      _spin_unlock_irq();
>>  0)   0.616 us    |      post_schedule_rt();
>>  0)   3.882 us    |    }
>>
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Pekka Paalanen <pq@iki.fi>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  kernel/trace/trace.c                 |   28 ++++++++++---
>>  kernel/trace/trace.h                 |    4 +-
>>  kernel/trace/trace_functions_graph.c |   72 +++++++++++++++++++++++++++++++++-
>>  kernel/trace/trace_mmiotrace.c       |    2 +-
>>  4 files changed, 97 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 8b6409a..1ca74c0 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -3335,7 +3335,7 @@ static int mark_printk(const char *fmt, ...)
>>       int ret;
>>       va_list args;
>>       va_start(args, fmt);
>> -     ret = trace_vprintk(0, fmt, args);
>> +     ret = trace_vprintk(0, -1, fmt, args);
>>       va_end(args);
>>       return ret;
>>  }
>> @@ -3564,9 +3564,16 @@ static __init int tracer_init_debugfs(void)
>>       return 0;
>>  }
>>
>> -int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
>> +int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>>  {
>> -     static DEFINE_SPINLOCK(trace_buf_lock);
>> +     /*
>> +      * Raw Spinlock because a normal spinlock would be traced here
>> +      * and append an irrelevant couple spin_lock_irqsave/
>> +      * spin_unlock_irqrestore traced by ftrace around this
>> +      * TRACE_PRINTK trace.
>> +      */
>> +     static raw_spinlock_t trace_buf_lock =
>> +                             (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
>>       static char trace_buf[TRACE_BUF_SIZE];
>>
>>       struct ring_buffer_event *event;
>> @@ -3587,7 +3594,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
>>       if (unlikely(atomic_read(&data->disabled)))
>>               goto out;
>>
>> -     spin_lock_irqsave(&trace_buf_lock, flags);
>> +     local_irq_save(flags);
>> +     __raw_spin_lock(&trace_buf_lock);
>>       len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
>
> I wonder if we should add a new flag called "NOTRACE" to the new
> current->trace flags. When set, tracing is stopped for the task. Then we
> can still use spinlock here. We only want to use raw if the tracing will
> cause lockdep to fail, not just to prevent traces.
>
> We could do something like:
>
>  pause_trace(current); /* sets the "notrace" flag */
>
>  unpause_trace(current); /* clears the "notrace" flag */
>


pause_trace seems to me too much generic. Would you want to use it for
normal ftrace too?
I guess I could name it (un)pause_ftrace.
