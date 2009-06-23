Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZFWHf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZFWHf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZFWHfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:35:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:55981 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbZFWHfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:35:20 -0400
Message-ID: <4A408212.2060308@windriver.com>
Date: Tue, 23 Jun 2009 15:19:46 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] tracing: reset iterator in t_start()
References: <4A3B3372.4040608@cn.fujitsu.com> <4A3B34A9.30602@cn.fujitsu.com> <4A407AB0.3000703@windriver.com> <4A408210.5000208@cn.fujitsu.com>
In-Reply-To: <4A408210.5000208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2009 07:35:07.0630 (UTC) FILETIME=[21BBA8E0:01C9F3D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> Another version:
>> Since we have saved current (struct tracer *) in m->private in .next, in
>> .start, we don't need to call .next to find the one that should be
>> printed in 2nd or nth time.
>>
> 
> I don't like this for 2 reasons.
> 
> 1. It's strange that @pos is not incremented in next().
Yes, it's strang, but we know that @pos sometimes is not necessary, such in this 
position.

> 
> 2. 
>    t_stop()
>      mutex_unlock()
>                           unregister_tracer(t)
>    t_start()
>      mutex_lock()
>        t = m->private
>        ...
>        t = t-next.
> 
>   We access t->next though @t was unregistered. This is not
>   good, though it does no harm here.
OK, it's a realy race problem if we call unregister_tracer.
btw: who realy calls this function? :)

Liming Wang
> 
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index cae34c6..02cdccc 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -2055,8 +2055,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>>  {
>>         struct tracer *t = m->private;
>>
>> -       (*pos)++;
>> -
>>         if (t)
>>                 t = t->next;
>>
>> @@ -2068,11 +2066,8 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>>  static void *t_start(struct seq_file *m, loff_t *pos)
>>  {
>>         struct tracer *t = m->private;
>> -       loff_t l = 0;
>>
>>         mutex_lock(&trace_types_lock);
>> -       for (; t && l < *pos; t = t_next(m, t, &l))
>> -               ;
>>
>>         return t;
>>  }
>>
>>
> 

