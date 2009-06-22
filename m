Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbZFVAna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbZFVAna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 20:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbZFVAnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 20:43:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56375 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbZFVAnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 20:43:22 -0400
Message-ID: <4A3ED40E.6030303@cn.fujitsu.com>
Date: Mon, 22 Jun 2009 08:45:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Liming Wang <liming.wang@windriver.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: don't increment @pos in g_start()
References: <4A3B347B.8090904@cn.fujitsu.com> <1245401968-25235-1-git-send-email-liming.wang@windriver.com> <4A3B5E40.8040607@cn.fujitsu.com>
In-Reply-To: <4A3B5E40.8040607@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Liming Wang wrote:
>> how about this one?
>>
> 
> Yeah, this should work, and cleaner than my version.
> 

Hmmm, the patch is cleaner in diffstat but the resulted code
isn't..

After yours:
   text    data     bss     dec     hex filename
  14879    5480    4240   24599    6017 kernel/trace/ftrace.o

After mine:
   text    data     bss     dec     hex filename
  14873    5480    4240   24593    6011 kernel/trace/ftrace.o


>> It's wrong to increment @pos in g_start(). It causes some entries
>> lost when reading set_graph_function, if the output of the file
>> is large than PAGE_SIZE.
>>
>> [ Impact: fix missing entries when reading set_graph_function ]
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> Signed-off-by: Liming Wang <liming.wang@windriver.com>
>> ---
>>  kernel/trace/ftrace.c |   14 +++++---------
>>  1 files changed, 5 insertions(+), 9 deletions(-)
>>
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 134e580..1beaac6 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -2495,29 +2495,25 @@ static void *
>>  g_next(struct seq_file *m, void *v, loff_t *pos)
>>  {
>>  	unsigned long *array = m->private;
>> -	int index = *pos;
>>  
>> -	(*pos)++;
>> +	if (v)
>> +		(*pos)++;
>>  
>> -	if (index >= ftrace_graph_count)
>> +	if (*pos >= ftrace_graph_count)
>>  		return NULL;
>>  
>> -	return &array[index];
>> +	return &array[*pos];
>>  }
>>  
>>  static void *g_start(struct seq_file *m, loff_t *pos)
>>  {
>> -	void *p = NULL;
>> -
>>  	mutex_lock(&graph_lock);
>>  
>>  	/* Nothing, tell g_show to print all functions are enabled */
>>  	if (!ftrace_graph_count && !*pos)
>>  		return (void *)1;
>>  
>> -	p = g_next(m, p, pos);
>> -
>> -	return p;
>> +	return g_next(m, NULL, pos);
>>  }
>>  
>>  static void g_stop(struct seq_file *m, void *p)
