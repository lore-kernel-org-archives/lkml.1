Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZKIVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZKIVMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZKIVMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:12:51 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:38514 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbZKIVMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:12:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tLkCvQeHv8E5zVh7Xzy4MD+mCRv9I9lyQo+dBBSS3UtyzCy+mBAr3BPScYhFQzPCr/
         mBbcAs4ogV7FU54bvVQCYSrZ5o2fNp8F+t3ms3hFZX5nSvE91Wm/6QEDV1dkaCjmS8oe
         aoT2eBlgnT5r1zoCKJr6v9TV7ILyiWDr5WcPQ=
MIME-Version: 1.0
In-Reply-To: <4AF828C50200005A000585DB@sinclair.provo.novell.com>
References: <20091108121650.GB11372@elte.hu> <4AF828C50200005A000585DB@sinclair.provo.novell.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Mon, 9 Nov 2009 19:12:35 -0200
Message-ID: <193b0f820911091312y125209deufadd1040aff65cfd@mail.gmail.com>
Subject: Re: [lucas.de.marchi@gmail.com: Bug when changing cpus_allowed of RT 
	tasks?]
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 17:35, Gregory Haskins <ghaskins@novell.com> wrote:
> Hi Lucas,
>
> Ingo asked me to take a look at the problem you are reporting.  Is this a bug you are seeing in the
> wild, or was this found by code-inspection?  I took a look, and it looks to me that the original code
> is correct, but I will keep an open mind.

I found this "maybe"-bug in some changes I'm doing to balance of RT tasks. It
was not giving me the expected results so inspecting the code I supposed this
was the problem. Applying the patch it solved my problem, but I think it was a
problem with my code. Comments inlined.

>>       static int select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>>       {
>>               [...]
>>               if (unlikely(rt_task(rq->curr)) &&
>>                   (p->rt.nr_cpus_allowed > 1)) {
>>                       int cpu = find_lowest_rq(p);
>>
>>                       return (cpu == -1) ? task_cpu(p) : cpu;
>>               }
	/*
	 * Otherwise, just let it ride on the affined RQ and the
	 * post-schedule router will push the preempted task away
	 */
	return task_cpu(p);

>>       }
I completed the rest of function to emphasize it will return task_cpu(p)
afterwards.

>
> So the intent of this logic is to say "if the task is of type RT, and it can move, see if it can move
> elsewhere".  Otherwise, we do not try to move it at all.

I'd say "if _current_ is of type RT, and _p_ can move, see if _p_ can move
elsewhere". And this check is repeated for p inside find_lowest_rq, so it would
not be needed here. Just let it call find_lowest_rq and -1 will be returned.

>>       static int find_lowest_rq(struct task_struct *task)
>>       {
[...]
>>               if (task->rt.nr_cpus_allowed == 1)
>>                       return -1; /* No other targets possible */
>>               [...]
>>       }


>> What happens if rt.nr_cpus_allowed continues to be 1, but the allowed cpu is
>> not the one in which task is being woken up?
>
> The one case that I can think of that would fall into this category is during a sched_setaffinity()?
>
> If so, what happens is that we ultimately call set_cpus_allowed() -> set_cpus_allowed_ptr().  Inside
> this function, the new mask is validated independent of the nr_cpus_allowed value and we will
> migrate the task away if it is no longer on a valid core.

This was exactly the case I was falling into. But I was setting the affinity
inside the kernel, not passing through setaffinity syscall, and I was wrongly
calling set_cpus_allowed_rt directly instead of set_cpus_allowed, so task would
not migrate in that case.

>
> Until further evidence is presented, I have to respectfully NAK the patch, as I do not think its doing the right thing
> nor do I think the current code is actually broken.

I see now it's not doing the right thing. IMO only the double check of
rt.nr_cpus_allowed is superfluous, but not wrong.


Thanks for clarifications


Lucas De Marchi
