Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZEMAz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZEMAz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZEMAzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:55:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50190 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZEMAzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:55:12 -0400
Message-ID: <4A0A1AAD.3090606@cn.fujitsu.com>
Date: Wed, 13 May 2009 08:56:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ryo Tsuruta <ryov@valinux.co.jp>
CC: Alan.Brunelle@hp.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, mingo@elte.hu, rostedt@goodmis.org,
       fweisbec@gmail.com
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
References: <4A08F1B3.4060700@cn.fujitsu.com>	<20090512.151104.71103166.ryov@valinux.co.jp>	<4A092EE7.4070403@cn.fujitsu.com> <20090512.191206.226779551.ryov@valinux.co.jp>
In-Reply-To: <20090512.191206.226779551.ryov@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>> Thanks for your suggestion. I'll use TRACE_EVENT instead.
>>>>> blk_add_trace_msg() supports both blktrace and tracepoints. I can
>>>>> get messages from dm-ioband through debugfs. Could you expain why
>>>>> should we use TRACE_EVENT instead?
>>>>>
>>>> Actually blk_add_trace_msg() has nothing to do with tracepoints..
>>>>
>>>> If we use blk_add_trace_msg() is dm, we can use it in md, various block
>>>> drivers and even ext4. So the right thing is, if a subsystem wants to add
>>>> trace facility, it should use tracepoints/TRACE_EVENT.
>>>>
>>>> With TRACE_EVENT, you can get output through debugfs too, and it can be used
>>>> together with blktrace:
>>>>
>>>>  # echo 1 > /sys/block/dm/trace/enable
>>>>  # echo blk > /debugfs/tracing/current_tracer
>>>>  # echo dm-ioband-foo > /debugfs/tracing/tracing/set_event
>>>>  # cat /deubgfs/tracing/trace_pipe
>>>>  
>>>> And you can enable dm-ioband-foo while disabling dm-ioband-bar, and you can
>>>> use filter feature too.
>>> Thanks for explaining.
>>> The base kernel of current dm tree (2.6.30-rc4) has not supported
>>> dm-device tracing yet. I'll consider using TRACE_EVENT when the base
>>> kernel supports dm-device tracing.
>>>
>> I think we don't have any plan on dm-device tracing support, do we? And you
>> don't need that.
>>
>> I downloaded dm-ioband 1.10.4, and applied it to latest tip-tree, and made
>> a patch to convert those blktrace msgs to trace events.
>>
>>  # ls /debug/tracing/events/dm-ioband
>>  enable  ioband_endio     ioband_issue_list    ioband_urgent_bio
>>  filter  ioband_hold_bio  ioband_make_request
>>  # echo 1 /debug/tracing/events/dm-ioband/enable
>>  # echo blk /debug/tracing/current_tracer
>>  ...
> 
> Is the following line unnecessary in the latest tip-tree?
> 
>    # echo 1 > /sys/block/dm/trace/enable
> 

Yes, still needed. I was not giving a complete demonstration. ;)

> How to enable/disable tracing on each device?

echo 1 > /sys/block/dm-0/trace/enable
echo 1 > /sys/block/dm-1/trace/enable

Or use filter facility:

echo "dev == $(( (ma0 << 20) | mi0 ))" > /debug/tracing/events/dm-ioband/filter

This will filter out all events generated from dm-1, leaving those from dm-0.

