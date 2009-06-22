Return-Path: <linux-kernel-owner+w=401wt.eu-S1753061AbZFVD2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbZFVD2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 23:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZFVD2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 23:28:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:35350 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbZFVD2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 23:28:37 -0400
Message-ID: <4A3EF5B3.8050001@windriver.com>
Date: Mon, 22 Jun 2009 11:08:35 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: don't increment @pos in g_start()
References: <4A3B347B.8090904@cn.fujitsu.com> <1245401968-25235-1-git-send-email-liming.wang@windriver.com> <4A3B5E40.8040607@cn.fujitsu.com> <4A3ED40E.6030303@cn.fujitsu.com> <4A3EEF9E.2020301@windriver.com> <4A3EF769.1090609@cn.fujitsu.com>
In-Reply-To: <4A3EF769.1090609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 03:28:30.0943 (UTC) FILETIME=[83CEA6F0:01C9F2E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Wang Liming wrote:
>> Li Zefan wrote:
>>> Li Zefan wrote:
>>>> Liming Wang wrote:
>>>>> how about this one?
>>>>>
>>>> Yeah, this should work, and cleaner than my version.
>>>>
>>> Hmmm, the patch is cleaner in diffstat but the resulted code
>>> isn't..
>>>
>>> After yours:
>>>    text    data     bss     dec     hex filename
>>>   14879    5480    4240   24599    6017 kernel/trace/ftrace.o
>>>
>>> After mine:
>>>    text    data     bss     dec     hex filename
>>>   14873    5480    4240   24593    6011 kernel/trace/ftrace.o
>> Hmmm, if you prefer to smaller target size, I don't care.
>> But in my system, I got the same size:
>>
>>   text    data     bss     dec     hex filename
>>   14330    5019     104   19453    4bfd kernel/trace/ftrace.o
>>
>> I use objdump to compute the actual size of all modified functions:
>>
>> After mine:
>> func    size
>> g_start 0x50
>> g_next  0x70
>>
>> After yours:
>> func     size
>> __g_next 0x70
>> g_next   0x20
>> g_start  0x30
>>
>> I used Steve git tree and commit e482f8395f215e0ad6557b2722cd9b9b308035c4.
>> My gcc version is :
>> gcc version 4.2.4
>>
>> I don't know where the difference.
>>
> 
> Maybe because of different gcc versions:
> 
> # gcc --version
> gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)
Maybe.

> 
> The point is, I don't see how the patch you posted is better than
> mine. And it's fine for me to pick up yours if it's indeed better.
OK, it's fine to me to pick up yours. Nothing different.
Back to your patch:

 > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
 > index ec18bb4..2c1c761 100644
 > --- a/kernel/trace/ftrace.c
 > +++ b/kernel/trace/ftrace.c
 > @@ -2492,32 +2492,30 @@ int ftrace_graph_count;
 >  unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 >
 >  static void *
 > -g_next(struct seq_file *m, void *v, loff_t *pos)
 > +__g_next(struct seq_file *m, loff_t *pos)
 >  {
 >  	unsigned long *array = m->private;
 > -	int index = *pos;
 >
 > -	(*pos)++;
 > +	/* Nothing, tell g_show to print all functions are enabled */
 > +	if (!ftrace_graph_count && !*pos)
 > +		return (void *)1;
I think this checking should be put back to g_start, because it's only necessary 
for g_start.

Liming Wang

> 

