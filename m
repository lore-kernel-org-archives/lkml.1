Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZAZPZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZAZPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZAZPZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:25:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:25917 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZAZPZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:25:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r3+Y5OVZrrqaN+pvQM84UGIpd6BKIvexmjR0TncJaKKyIAfZ8LCKqsYU1NOltHltPu
         XKuIFX/Hfb/dqMeYDMjPW80N1NCWIPkKZkNXHWf7IR1tf0MrXgYaJNo2bFdLVpKJOGQa
         oKBD2f35ETbALf1VD6B25xtNAZQ//Th9JGfv4=
MIME-Version: 1.0
In-Reply-To: <1232977715.4863.81.camel@laptop>
References: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
	 <1232977715.4863.81.camel@laptop>
Date: Mon, 26 Jan 2009 16:25:47 +0100
Message-ID: <c62985530901260725s2f36c6d8u1572775d790e7888@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] add a counter for writers spinning on a rwlock
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mandeep Singh Baines <msb@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/26 Peter Zijlstra <peterz@infradead.org>:
> On Sun, 2009-01-25 at 12:50 -0800, Frederic Weisbecker wrote:
>> This patch adds a counter for writers that enter a rwlock slow path.
>> For example it can be useful for slow background tasks which perform some jobs
>> on the tasklist, such as the hung_task detector (kernel/hung_task.c).
>>
>> It adds a inc/dec pair on the slow path and 4 bytes for each rwlocks, so the overhead
>> is not null.
>>
>> Only x86 is supported for now, writers_spinning_lock() will return 0 on other archs (which
>> is perhaps not a good idea).
>>
>> Comments?
>
> _why_ ?

The hung task detector runs a periodic loop through the task_list, and
currently it doesn't run
over an arbitrary threshold of tasks to not hold the task_list lock
for too long.

So we thought about a way to detect if there are some writers waiting
for the lock, anf if so, release
the lock, schedule and retry.

I'm not sure this is something easy to measure, since this is more
about small latency gains (if there are).
