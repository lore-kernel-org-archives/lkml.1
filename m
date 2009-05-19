Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbZESGDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbZESGDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbZESGDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:03:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57961 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbZESGDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:03:31 -0400
Message-ID: <4A124BF6.6020201@cn.fujitsu.com>
Date: Tue, 19 May 2009 14:04:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
References: <4A0BB813.9080807@cn.fujitsu.com> <20090518083539.GC10687@elte.hu>
In-Reply-To: <20090518083539.GC10687@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> TRACE_EVENT is a more generic way to define tracepoints. Doing so adds
>> these new capabilities to this tracepoint:
>>
>>   - zero-copy and per-cpu splice() tracing
>>   - binary tracing without printf overhead
>>   - structured logging records exposed under /debug/tracing/events
>>   - trace events embedded in function tracer output and other plugins
>>   - user-defined, per tracepoint filter expressions
>>   ...
> 
> Nice!
> 
>> Cons and problems:
>>
>>   - no dev_t info for the output of plug, unplug_timer and unplug_io events.
>>     no dev_t info for getrq and sleeprq events if bio == NULL.
>>     no dev_t info for rq_abort,...,rq_requeue events if rq->rq_disk == NULL.
> 
> Cannot we output the numeric major:minor pairs?
> 

No, we can't.

Take plug tracepoint for example, the only argument is a struct request_queue,
but we can't map from a queue to a device, since there is no 1:1 mapping.

That's why blktrace adds dev_t info in struct blk_trace, which is associated
to a queue.

>>   - for large packet commands, only 16 bytes of the command will be output.
>>     Because TRACE_EVENT doesn't support dynamic-sized arrays, though it
>>     supports dynamic-sized strings.
>>
>>   - a packet command is converted to a string in TP_assign, not TP_print.
>>     While blktrace do the convertion just before output.
> 
> Couldnt we do a memcpy instead of the snprintf() in __dump_pdu()? We 
> dont actually interpret the bytes there. We could extend the 
> in-kernel printk format with a 'dump raw memory in hex' type of 
> format specifier.
> 

Sure, it's do-able. The disavantage is then we can't do filtering
on __entry->cmd, because now it's unsigned char[], not a string.

> OTOH, packet requests are rather rare, right? So going to ASCII 
> there results in a simpler interface. In the !blk_pc_request(rq) 
> common case we just return early without any snprintf overhead.
> 

Right. :)

>>   - in blktrace, an event can have 2 different print formats, but 
>>     a TRACE_EVENT has a unique format. (see the output of getrq 
>>     and rq_insert)
> 
> Is this a problem?
> 

One of the defect is, we have __entry->cmd[] even it's not used
if !blk_pc_request(rq).

This can be avoided though, by using __string() (needs small modification)
instead of __array().

> I think a good way forward would be to benchmark the ioctl versus 
> the splice based TRACE_EVENT tracing (via some artificially high 
> rate event, to push things), and see where we are right now in terms 
> of overhead.
> 

I'll try.

