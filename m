Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbZDOJR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbZDOJR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZDOJRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:17:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53280 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbZDOJRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:17:18 -0400
Message-ID: <49E5A593.6090605@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 17:14:59 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ring_buffer: enlarge RB_MAX_SMALL_DATA
References: <49E2AAB3.9010801@cn.fujitsu.com> <1239633781.21121.25.camel@localhost.localdomain>
In-Reply-To: <1239633781.21121.25.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2009-04-13 at 11:00 +0800, Lai Jiangshan wrote:
>> When I am writing userspace tools for ftrace, I found
>> RB_MAX_SMALL_DATA is too small, some events waste an 'u32'
>> to save the actually length.
> 
> Although I like the idea, I want to look at something else.
> 
> 2^27 is: 134,217,728
> 2^26 is: 67,108,864
> 
> That is the count in nanoseconds. Thus we go from 134 millisecs to 67
> millisecs before we must add an extended counter.
> 
> I guess that is not an issue, since 67ms is still quite big. For sparse
> tracing, it could add more extended counters where none were needed. But
> this I doubt this is an issue.

67ms < 0.1sec, It sounds not very good.

> 
>> This fix will break previous userspace tools,
>> so complaints are also welcome.
> 
> Unfortunately, this changes the API to userspace. For those parsers that
> do this in binary. I think the answer is, before we add this, we export
> the format of the ring buffer headers just like we do for other formats.
> This way, a user tool can default to the old way if the format file does
> not exist, and can know the current format with the file.
> 
> I'll work on adding that format file sometime this week.
>

I think ftrace is still in develop-circle, changing its API to userspace
is sometimes OK. Will you agreed this fix after you add that format file?
It saves about 0%-12%(depends on tracer) memory.

How about this method:

{u32 type_len:5, time_delta:27;};

time_delta is still 27bits, but RB_MAX_SMALL_DATA is increased to 112,
it is larger than 60 in my patch.

type_len  actual type                actual len
0         RINGBUF_TYPE_DATA,         array[0]
1 ~ 28    RINGBUF_TYPE_DATA          4*1 ~ 4*28
29        RINGBUF_TYPE_TIME_STAMP    
30        RINGBUF_TYPE_TIME_EXTEND
31        RINGBUF_TYPE_PADDING       array[0] if it's not the last event
                                     in the buffer_page(discarded event)
If you like this method, I will implement it.

Lai.

