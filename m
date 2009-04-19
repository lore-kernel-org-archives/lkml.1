Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbZDSSsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbZDSSsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 14:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZDSSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 14:48:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:38200 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZDSSsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 14:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kxggNdZDJPzZL/XJMHX23wDdgq9DfqwoHRibtKpveW8vG9jJf8ffdR5lIqQ7YRQksF
         CD4FJdu+yvnzKnVUHUN7naHg7RJPH6uANMcxHqTkhvB8XT2Q0TYMYMBkU1XdyAc2ofMV
         lesER0A1H/VOmktSRaD7/we89PhX7sujHq/wI=
MIME-Version: 1.0
In-Reply-To: <20090419184551.GA6120@elte.hu>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com>
	 <49EAC15E.7080702@cn.fujitsu.com> <20090419123430.GA5967@nowhere>
	 <20090419134927.GA6262@nowhere> <20090419140154.GB28919@elte.hu>
	 <20090419142201.GB6262@nowhere> <20090419184551.GA6120@elte.hu>
Date: Sun, 19 Apr 2009 20:48:18 +0200
Message-ID: <c62985530904191148m16e1f1b6gaebea1a0b10a30ef@mail.gmail.com>
Subject: Re: [PATCH] tracing/core: Add current context on tracing recursion 
	warning
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/19 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> On Sun, Apr 19, 2009 at 04:01:54PM +0200, Ingo Molnar wrote:
>> > It would be nice to have this ... but there's no need to do that
>> > atomic thing - just use printk_once() please. (if we race with
>> > another instance and get two messages that's not a problem)
>> >
>> >     Ingo
>>
>>
>> Ah, indeed I forgot about printk_once()
>> I've updated the repo with the following v2 on:
>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing tracing/recursion
>>
>> ---
>> >From e894732989e345ea012de146c37d71dd7ed3575d Mon Sep 17 00:00:00 2001
>> From: Frederic Weisbecker <fweisbec@gmail.com>
>> Date: Sun, 19 Apr 2009 16:18:16 +0200
>> Subject: [PATCH v2] tracing/core: Add current context on tracing recursion warning
>
>>
>> In case of tracing recursion detection, we only get the stacktrace.
>> But the current context may be very useful to debug the issue.
>>
>> This patch adds the softirq/hardirq/nmi context with the warning
>> using lockdep context display to have a familiar output.
>>
>> v2: Use printk_once()
>>
>> [ Impact: more information in tracing recursion ]
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  kernel/trace/ring_buffer.c |   10 ++++++++++
>>  1 files changed, 10 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index b421b0e..e315178 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -1495,6 +1495,16 @@ static int trace_recursive_lock(void)
>>       if (unlikely(current->trace_recursion & (1 << level))) {
>>               /* Disable all tracing before we do anything else */
>>               tracing_off_permanent();
>> +
>> +             printk_once(KERN_WARNING "Tracing recursion: "
>> +                         "[HC%u[%lu]:SC%u[%lu]:NMI[%lu]:HE%u:SE%u]\n",
>> +                         current->hardirq_context,
>> +                         hardirq_count() >> HARDIRQ_SHIFT,
>> +                         current->softirq_context,
>> +                         softirq_count() >> SOFTIRQ_SHIFT,
>> +                         in_nmi(), current->hardirqs_enabled,
>> +                         current->softirqs_enabled);
>> +
>>               WARN_ON_ONCE(1);
>
> Pulled, thanks Frederic!
>
> btw., we might have done it via:
>
>        if (WARN_ON_ONCE(1)) {
>                printk(...);
>        }
>
> as well ... but i have not checked how WARN_ON_ONCE() return value
> behaves after the first warning - does it return true or false?



I've checked it because I wanted to do that first :-)
It returns always 1 if the condition is true, not only once.

Btw, I've found the origin of the warning.
We drop the recursion protection on commit but not on discard.

Preparing a patch.


>        Ingo
>
