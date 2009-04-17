Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbZDQF6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbZDQF6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 01:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZDQF56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 01:57:58 -0400
Received: from gw.goop.org ([64.81.55.164]:37823 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbZDQF55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 01:57:57 -0400
Message-ID: <49E81A63.7010700@goop.org>
Date: Thu, 16 Apr 2009 22:57:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com> <20090417014209.GA24956@Krystal>
In-Reply-To: <20090417014209.GA24956@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
>   
>> On Thu, 16 Apr 2009, Jeremy Fitzhardinge wrote:
>>
>>     
>>> I don't think this helps.  rcupdate_types.h uses preempt_disable/enable, but
>>> doesn't include linux/preempt.h for them - but someone's going to have to, so
>>> you've got an implicit dependency on the user to #include the right headers in
>>> advance.
>>>       
>> Would including linux/preempt.h in rcupdate_types.h be a problem?
>>
>> -- Steve
>>
>>     
>
> I did not include preempt.h in rcupdate_types.h because rcupdate.h did
> not include it, so I thought it had a special status such a kernel.h.
> However, I notice the rcupdate.h includes spinlock.h, which in turn
> includes preempt.h, so we would need to include preempt.h in
> rcupdate_types.h.
>
> But I think preempt.h is pretty much only type definitions. I don't
> think that would be a problem, but maybe Jeremy knows better.

No, preempt.h has fairly complex #include requirements:
#include <linux/thread_info.h>
#include <linux/linkage.h>
#include <linux/list.h>

which in turn include:
/* linux/thread_info */
#include <linux/bitops.h>
#include <asm/thread_info.h>

/* list.h */
#include <linux/stddef.h>
#include <linux/poison.h>
#include <linux/prefetch.h>
#include <asm/system.h>

And from there more complex still:
#include <asm/asm.h>
#include <asm/segment.h>
#include <asm/cpufeature.h>
#include <asm/cmpxchg.h>
#include <asm/nops.h>
#include <linux/kernel.h>
#include <linux/irqflags.h>
#include <asm/page.h>
#include <asm/processor.h>
#include <asm/ftrace.h>
#include <asm/atomic.h>
[...and much more...]

Given that paravirt.h is included in some of those headers, it 
eventually gets cyclic.

    J
