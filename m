Return-Path: <linux-kernel-owner+w=401wt.eu-S1765013AbXETKv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765013AbXETKv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbXETKvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:51:17 -0400
Received: from barclay.balt.net ([195.14.162.78]:21503 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757093AbXETKvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:51:16 -0400
Date: Sun, 20 May 2007 13:37:13 +0300 (EEST)
From: zilvinas@wilibox.com
X-X-Sender: zilvinas@barclay.balt.net
Reply-To: zilvinas@wilibox.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Zilvinas Valinskas <zilvinas@wilibox.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1
 + CFS v12)
In-Reply-To: <20070518202805.GA298@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0705201326410.8634@barclay.balt.net>
References: <1179338441.4265.13.camel@zv.wilibox.com>
 <20070516121538.7b108c10.akpm@linux-foundation.org> <20070516225543.GA337@tv-sign.ru>
 <1179390065.4760.5.camel@zv.wilibox.com> <20070517184556.GA81@tv-sign.ru>
 <1179485230.3800.20.camel@zv.wilibox.com> <20070518202805.GA298@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

I've done some more tests and quite frankly I think this is really related 
to the dreaded ''fglrx.ko'' module. It seems to me that it is much easier 
to reproduce the problem if that damn module is loaded. It does uses 
workqueue. Then there is another driver ipw3945 loaded and it is required 
to run binary only ''ipw3945d'' daemon just to start using wireless driver 
...

In either way both these kernel modules are workqueue users.

Btw, I had also tested kernel (compiled from the same source) but on 
different laptop (EVO N800v), single core, Pentium M 2GHz. Kernel is not 
freezing on shutdown, even loop nfs kernel stop/start - does not cause any 
kernel panic as on nx9420 (Dual Core) laptop. And that with or without any 
patch applied from Oleg. :((

I think this time it is really needed to stop here, kernel was tainted for 
a reason. :(((

Thank you both, Oleg and Andrew.

Zilvinas "Lucky ATI fglrx owner" Valinskas

On Sat, 19 May 2007, Oleg Nesterov wrote:

> On 05/18, Zilvinas Valinskas wrote:
>>
>> On Thu, 2007-05-17 at 22:45 +0400, Oleg Nesterov wrote:
>>>
>>> However, I can't understand why cleanup_workqueue_thread() hangs anyway.
>>> It shouldn't. Looks like rpciod/1 was preempted, and can't get CPU. According
>>> to kernel-nfs-freeze.log it is TASK_RUNNING. Strange.
>>>
>>> It is very sad, because this code was supposed to be cleanuped anyway,
>>> but if it is really buggy, it would be great to know why.
>>
>> Can this be related to :
>>
>> CONFIG_PREEMPT=y
>
> Yes, but this preemption should be very unlikely, but it happens every time
> for you, strange. lockd in turn spins with preemption enabled, but somehow
> rpciod/1 can't make progress. system_state == SYSTEM_HALT, but this shouldn't
> affect preempt_schedule_irq(). So I think there is something else.
>
>> workqueue.objdump - without any patch.
>
> So it hangs waiting for cwq->thread == NULL, as expected.
>
> OK. I still can't see how this code could be wrong, but it is bad anyway and
> should be changed. The 2nd patch was done more than a month ago, but was
> delayed for some stupid reasons. I'll send it today.
>
> Still, it is not clear to me what happens, and you have other crashes with
> nfs stop/start
>
> 	http://marc.info/?l=linux-kernel&m=117939027602591
> 	http://marc.info/?l=linux-kernel&m=117939257630947
>
> which probaly need some attention.
>
> Thanks!
>
> Oleg.
>
>
