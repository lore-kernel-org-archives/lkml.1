Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbZDNI1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbZDNI1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZDNI0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:26:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51002 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZDNI0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:26:50 -0400
Message-ID: <49E448F6.5010506@cn.fujitsu.com>
Date: Tue, 14 Apr 2009 16:27:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, Shawn Du <duyuyang@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-btrace@vger.kernel.org
Subject: Re: PATCH 1/3] blktrace: support per-partition tracing
References: <49E42620.4050701@cn.fujitsu.com> <20090414080919.GB27003@elte.hu>
In-Reply-To: <20090414080919.GB27003@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> From: Shawn Du <duyuyang@gmail.com>
>>
>> Though one can specify '-d /dev/sda1' when using blktrace, it 
>> still traces the whole sda.
>>
>> To support per-partition tracing, when we start tracing, we 
>> initialize bt->start_lba and bt->end_lba to the start and end 
>> sector of that partition.
>>
>> Note some actions are per device, thus we don't filter 0-sector 
>> events.
>>
>> The original patch and discussion can be found here:
>> 	http://marc.info/?l=linux-btrace&m=122949374214540&w=2
>>
>> Signed-off-by: Shawn Du <duyuyang@gmail.com>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks - beyond the small detail i mailed about a few minutes ago 
> the series looks good: i'll queue this up in tracing/blktrace unless 
> Jens has second thoughts.
> 
> Lets note that this approach still has the (long existing) 
> limitation that only one device can be block-traced at a time.
> 

No, both userspace blktrace and ftrace-plugin trace can trace
more than one device at a time.

 # btrace /dev/sda /dev/dm-0

or

 # echo 1 > /sys/block/sda/trace/enable
 # echo 1 > /sys/block/dm-0/trace/enable

> Furthermore, various other aspects of act_log_check() itself could 
> be expressed in terms of per tracepoint filters as well: the PID 
> filter field for example - which is supported in the ioctl ABI but 
> currently not exposed in the user-space blktrace utility. Same goes 
> for the action mask which is frequently used.
> 

Actually action mask can be specified by 'blktrace -a/-A mask/mask_name'

But yes the pid filter is not exposed in user-space blktrace.

> But before we can lift all these limitations and can have equivalent 
> functionality in the generic event tracer we still need more filter 
> engine infrastructure work (range operators and dev_t field 
> support). Plus TRACE_EVENT() based blk tracepoints.
> 
> Once we have that, the conversion will be straightforward: all 
> existing filter functionality of blktrace is static, so it will map 
> directly to new-style filter expressions. That will give us block 
> tracing for an arbitrary number of block devices (including the 
> basic mode of 'trace all block IO in the system') and a much wider 
> range of filtering capabilities.
> 
> Thanks,
> 
> 	Ingo
> 
> 
