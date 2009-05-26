Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZEZBIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZEZBIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 21:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZEZBID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 21:08:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60809 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZEZBIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 21:08:02 -0400
Message-ID: <4A1B4144.9060201@cn.fujitsu.com>
Date: Tue, 26 May 2009 09:09:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/stat: sort in ascending order
References: <4A1A5AD1.3070804@cn.fujitsu.com> <20090525154229.GA7121@nowhere>
In-Reply-To: <20090525154229.GA7121@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, May 25, 2009 at 04:46:09PM +0800, Li Zefan wrote:
>> Currently the output of trace_stat/workqueues is totally reversed:
>>
>>  # cat /debug/tracing/trace_stat/workqueues
>>     ...
>>     1       17       17      210       37   `-blk_unplug_work+0x0/0x57
>>     1     3779     3779      181       11   |-cfq_kick_queue+0x0/0x2f
>>     1     3796     3796                     kblockd/1:120
>>     ...
>>
>> The correct output should be:
>>
>>     1     3796     3796                     kblockd/1:120
>>     1     3779     3779      181       11   |-cfq_kick_queue+0x0/0x2f
>>     1       17       17      210       37   `-blk_unplug_work+0x0/0x57
>>
>> It's caused by "tracing/stat: replace linked list by an rbtree for sorting"
>> (53059c9b67a62a3dc8c80204d3da42b9267ea5a0).
>>
>> Though we can simply change dummy_cmp() to return -1 instead of 1, IMO
>> it's better to always do ascending sorting in trace_stat.c, and leave each
>> stat tracer to decide whether to sort in descending or ascending order.
>>
>> [ Impact: fix the output of trace_stat/workqueue ]
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> 
> For now in stat tracing, the ascendent sorting is the most relevant.
> Especially because we always want to see the highest problems first.
> 

Yeah, I saw this.

> -1 (or < 0) usually means lower and 1 ( > 0) is higher.
> 
> I wonder what would most confuse the developers of stat tracers:
> 
> - to reverse these common sort values (-1 turn into "higher")
> - keep the default ascendent sorting, which is not natural because the default
>   is often descendent.
> 
> I don't know. 
> 
> Anyone else. Do you have a preference?
> 

When I looked into this bug, I was confused why it's descending sorting, though
then I found out the answer.

Imagine a new stat tracer wants to sort in ascending order, but it has to define
a cmp which compares in reverse order. This seems to be odd and confusing.

But to be honest, I'm also not sure which is better, And it doesn't seem to be
a big issue. So I think I'll make concessions.


