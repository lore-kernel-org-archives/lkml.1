Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZAZRgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZAZRgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZAZRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:36:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:51709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZAZRgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:36:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=n9uN51Kg7gjazI1YQWHkzd9U2exLXGJ59+v/QCrFy6SUe/fsSrUR5lAuJmA8Hj6ze
	/4LsfqVNqd4cn+ek+ITag==
MIME-Version: 1.0
In-Reply-To: <c62985530901260804o4022e0c0t5acba3f7c32c48ac@mail.gmail.com>
References: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
	 <1232977715.4863.81.camel@laptop>
	 <c62985530901260725s2f36c6d8u1572775d790e7888@mail.gmail.com>
	 <1232984248.4863.106.camel@laptop>
	 <c62985530901260804o4022e0c0t5acba3f7c32c48ac@mail.gmail.com>
Date: Mon, 26 Jan 2009 09:36:04 -0800
Message-ID: <1fe6c7900901260936g63ea73a4naf1b90190352d057@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] add a counter for writers spinning on a rwlock
From: Mandeep Baines <msb@google.com>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-GMailtapped-By: 172.28.16.75
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frédéric,

Unfortunately, this can't be done for hung_task. It writes to the
task_struct here:

static void check_hung_task(struct task_struct *t, unsigned long now,
                            unsigned long timeout)
{
        unsigned long switch_count = t->nvcsw + t->nivcsw;

        if (t->flags & PF_FROZEN)
                return;

        if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
                t->last_switch_count = switch_count;
                t->last_switch_timestamp = now;
                return;
        }

It is able to get away with using only a read_lock because no one else
reads or writes to these fields.

Regards,
Mandeep

On Mon, Jan 26, 2009 at 8:04 AM, Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 2009/1/26 Peter Zijlstra <peterz@infradead.org>:
>> On Mon, 2009-01-26 at 16:25 +0100, Frédéric Weisbecker wrote:
>>> 2009/1/26 Peter Zijlstra <peterz@infradead.org>:
>>> > On Sun, 2009-01-25 at 12:50 -0800, Frederic Weisbecker wrote:
>>> >> This patch adds a counter for writers that enter a rwlock slow path.
>>> >> For example it can be useful for slow background tasks which perform some jobs
>>> >> on the tasklist, such as the hung_task detector (kernel/hung_task.c).
>>> >>
>>> >> It adds a inc/dec pair on the slow path and 4 bytes for each rwlocks, so the overhead
>>> >> is not null.
>>> >>
>>> >> Only x86 is supported for now, writers_spinning_lock() will return 0 on other archs (which
>>> >> is perhaps not a good idea).
>>> >>
>>> >> Comments?
>>> >
>>> > _why_ ?
>>>
>>> The hung task detector runs a periodic loop through the task_list, and
>>> currently it doesn't run
>>> over an arbitrary threshold of tasks to not hold the task_list lock
>>> for too long.
>>>
>>> So we thought about a way to detect if there are some writers waiting
>>> for the lock, anf if so, release
>>> the lock, schedule and retry.
>>
>> Ah, if it can do that, then it can also use RCU, no? Only users who
>> really have to hold off new tasks need the read-task_lock. The rest can
>> use RCU.
>
>
> Really?
> That sounds a good news. Mandeep, what do you think?
>
