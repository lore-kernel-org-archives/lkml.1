Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZFVDAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZFVDAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 23:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZFVDAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 23:00:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49540 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbZFVDAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 23:00:06 -0400
Message-ID: <4A3EF417.2090802@cn.fujitsu.com>
Date: Mon, 22 Jun 2009 11:01:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Wang Liming <liming.wang@windriver.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] tracing_bprintk: don't increment @pos in t_start()
References: <4A3B3372.4040608@cn.fujitsu.com> <4A3B3445.2050005@cn.fujitsu.com> <4A3B5CD7.3050601@windriver.com> <4A3ED2A1.40300@cn.fujitsu.com> <4A3EE791.5000507@windriver.com>
In-Reply-To: <4A3EE791.5000507@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Liming wrote:
> Li Zefan wrote:
>> Wang Liming wrote:
>>> Hi,
>>>
>>> Li Zefan wrote:
>>>> It's wrong to increment @pos in t_start(), otherwise we'll lose
>>>> some entries when reading printk_formats, if the output is large
>>>> than PAGE_SIZE.
>>>>
>>>> [ Impact: fix missing entries when reading printk_formats ]
>>>>
>>>> Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>>> ---
>>>>  kernel/trace/trace_printk.c |   26 ++++++--------------------
>>>>  1 files changed, 6 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
>>>> index 9bece96..7b62781 100644
>>>> --- a/kernel/trace/trace_printk.c
>>>> +++ b/kernel/trace/trace_printk.c
>>>> @@ -155,25 +155,19 @@ int __ftrace_vprintk(unsigned long ip, const
>>>> char *fmt, va_list ap)
>>>>  EXPORT_SYMBOL_GPL(__ftrace_vprintk);
>>>>  
>>>>  static void *
>>>> -t_next(struct seq_file *m, void *v, loff_t *pos)
>>>> +t_start(struct seq_file *m, loff_t *pos)
>>>>  {
>>>> -    const char **fmt = m->private;
>>>> -    const char **next = fmt;
>>>> -
>>>> -    (*pos)++;
>>>> +    const char **fmt = __start___trace_bprintk_fmt + *pos;
>>>>  
>>>>      if ((unsigned long)fmt >= (unsigned
>>>> long)__stop___trace_bprintk_fmt)
>>>>          return NULL;
>>>> -
>>>> -    next = fmt;
>>>> -    m->private = ++next;
>>>> -
>>>>      return fmt;
>>>>  }
>>>>  
>>>> -static void *t_start(struct seq_file *m, loff_t *pos)
>>>> +static void *t_next(struct seq_file *m, void * v, loff_t *pos)
>>>>  {
>>>> -    return t_next(m, NULL, pos);
>>>> +    (*pos)++;
>>>> +    return t_start(m, pos);
>>>>  }
>>>>  
>>> I prefer to .start to call .next, so I rewrite it to following:
>>>
>>
>> Thanks for the comment, but I don't think .next calls .start is bad,
>> and I'm not the only one doing this. Grep c_start() to see some of
>> them.
> Yes, you are not the only one, but it's the only one in the tracing
> code. :)
> I just think we should make the seq_* uniform so that we can understand
> them more clearly.
> 

I don't see how this make seq_* un-uniform..

And I don't want to add extra checking for this kind of uniform.

And if some next()s check (v == NULL) while others don't, do
you think it's uniform or not?
