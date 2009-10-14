Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZJNRl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZJNRl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZJNRl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:41:26 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35156 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZJNRlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:41:25 -0400
Message-ID: <4AD60CD1.4000804@s5r6.in-berlin.de>
Date: Wed, 14 Oct 2009 19:39:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: "Leonidas ." <leonidas137@gmail.com>
CC: Gleb Natapov <gleb@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to check whether executing in atomic context?
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>	 <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>	 <20091014101336.GA25108@redhat.com> <f22d86810910140324l7b78ed57v7e7c774d5f8a1bd3@mail.gmail.com>
In-Reply-To: <f22d86810910140324l7b78ed57v7e7c774d5f8a1bd3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 12:24 PM, Leonidas . wrote:
> On Wed, Oct 14, 2009 at 3:13 AM, Gleb Natapov <gleb@redhat.com> wrote:
>> On Wed, Oct 14, 2009 at 02:21:22AM -0700, Leonidas . wrote:
>>> On Tue, Oct 13, 2009 at 11:36 PM, Leonidas . <leonidas137@gmail.com> wrote:
>>> > Hi List,
>>> >
>>> > I am working on a profiler kind of module, the exported apis of my module can be
>>> > called from process context and interrupt context as well. Depending on the
>>> > context I am called in, I need to call sleepable/nonsleepable variants
>>> > of my internal bookkeeping functions.
>>> >
>>> > I am aware of in_interrupt() call which can be used to check current
>>> > context and take action accordingly.
>>> >
>>> > Is there any api which can help figure out whether we are executing while hold a spinlock? I.e
>>> > an api which can help figure out sleepable/nonsleepable context? If it is not there, what can
>>> > be done for writing the same? Any pointers will be helpful.
[...]
>>>   While searching through the sources, I found this,
>>>
>>>   97/*
>>>   98 * Are we running in atomic context?  WARNING: this macro cannot
>>>   99 * always detect atomic context; in particular, it cannot know about
>>>  100 * held spinlocks in non-preemptible kernels.  Thus it should not be
>>>  101 * used in the general case to determine whether sleeping is possible.
>>>  102 * Do not use in_atomic() in driver code.
>>>  103 */
>>>  104#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
>>>  105
>>>
>>> this just complicates the matter, right? This does not work in general case but I think this
>>> will always work if the kernel is preemptible.
>>>
>>> Is there no way to write a generic macro?
[...]
>> Attached patch make in_atomic() to work for non-preemptable kernels too.
>> Doesn't look to big or scary.
>>
>> Disclaimer: tested only inside kvm guest 64bit, haven't measured overhead.
[...]
> Unbelievable! I was just thinking about the logic to achieve the same, and
> someone has already done this. Thanks for the patch.

I don't know whether Gleb's patch works or doesn't work as you require
it.  But my opinion is that the recommendation "do not use in_atomic()
in driver code" is valid nevertheless.

Very often the better course of action is to change your API from

void my_routine()
{
	if (in_atomic())
		this;
	else
		that;
}

to either

void my_routine(bool can_sleep)
{
	if (!can_sleep)
		this;
	else
		that;
}

or to

void my_routine_atomic()
{
	this;
}

void my_routine()
{
	that;
}

In other words, let the caller of your routine tell it whether it's
atomic context or not.

Instead of a "bool can_sleep" argument, a "gfp_t flags" argument is
often used.

Or provide only the my_routine_atomic() variant if the difference to the
sleeping variant isn't huge.
-- 
Stefan Richter
-=====-==--= =-=- -===-
http://arcgraph.de/sr/
