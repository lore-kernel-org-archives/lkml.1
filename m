Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYKUUHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYKUUHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYKUUHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:07:36 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:33054 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYKUUHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:07:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=h5JpeP3K4sr46wT+/DS/yU4XIHC1T8rV8Uytx6KErb2huWw/K/B2uRTOlNjh14upF6
         6Fn8TVlhzfuVqKNHMAhklvtDU73DTo58ZKPfm652J06BqJhCGISpCioWB9aEREalHsQi
         F1FHv6tgoDDFTqTT05pgqnCQUI6+c9ys2onCA=
Message-ID: <c62985530811211207s730d269ahdaadd6978bd4e6e5@mail.gmail.com>
Date: Fri, 21 Nov 2008 21:07:33 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun field
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081121194819.GA568@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081118145154.GC30358@elte.hu> <20081118151326.GH30358@elte.hu>
	 <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com>
	 <20081118155045.GJ30358@elte.hu>
	 <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
	 <20081118164019.GA18620@elte.hu>
	 <c62985530811180847w30f5724dvb6dff8fd7f4913de@mail.gmail.com>
	 <20081118210344.GC11490@elte.hu>
	 <c62985530811211139l78529b8y1a7881e8693c2728@mail.gmail.com>
	 <20081121194819.GA568@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/21 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> When the tracer will be launched, I will hold the tasklist_lock to
>> allocate/insert the dynamic arrays. So in this atomic context, I
>> will not be able to call kmalloc with GFP_KERNEL. And I fear that
>> using GFP_ATOMIC for possible hundreds of tasks would be clearly
>> unacceptable.
>>
>> What do you think of this way:
>>
>> _tracer activates
>> _a function enters the tracer entry-hooker. If the array is allocated
>> for the current task, that's well. If not I launch a kernel thread
>> that will later allocate an array for the current task (I will pass
>> the pid as a parameter). So the current task will be soon be traced.
>> _ when a process forks, I can allocate a dynamic array for the new
>> task without problem (I hope).
>>
>> So some tasks will not be traced at the early beggining of tracing
>> but they will soon all be traced.... There is perhaps a problem with
>> tasks that are sleeping for long times... There will be some losses
>> once they will be awaken...
>
> i'd suggest a different approach that is simpler:
>
> - step0: set flag that "all newly created tasks need the array
>  allocated from now on".
>
> - step1: allocate N arrays outside tasklist_lock
>
> - step2: take tasklist_lock, loop over all tasks that exist and pass
>  in the N arrays to all tasks that still need it.
>
>  If tasks were 'refilled', drop tasklist_lock and go back to step 1.
>
> - step3: free N (superfluously allocated) arrays
>
> Make N something like 32 to not get into a bad quadratic nr_tasks
> double loop in practice. (Possibly allocate arrays[32] dynamically as
> well at step0 and not have it on the kernel stack - so 32 can be
> changed to 128 or so.)
>
>        Ingo
>

Ok. I thought about this method but wondered about the fact that
kmalloc can schedule and then I could run in an infinite loop (or a
too long one).
I will try this. Thanks.
