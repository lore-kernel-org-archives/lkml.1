Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYFRL6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYFRL6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYFRL6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:58:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:13664 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYFRL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:58:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DfRZWXlzFPoeWajZfnF6VZQP3sel2uA4W5amyiRX6PCK1fSiKeuzViFfDshBY/5zQW
         AqCAeAcp02hCyFkWvIwqS8h4f705/MZWBAKmlMnsbXtvuUdWAEnedntz0MqzGpl33pNQ
         9NrLdS31YhOhbaT6LlXL7mQJVpPOaO47EhG+s=
Message-ID: <b647ffbd0806180458o6603adabgb80c88954981d47a@mail.gmail.com>
Date: Wed, 18 Jun 2008 13:58:30 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratabletasks over migratable ones"
Cc: "Gregory Haskins" <ghaskins@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080618103919.GH15255@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213138710.26530.51.camel@earth> <1213174382.31518.69.camel@twins>
	 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
	 <48563FDB.BA47.005A.0@novell.com>
	 <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
	 <1213643862.16944.142.camel@twins> <48568CCC.BA47.005A.0@novell.com>
	 <20080618103919.GH15255@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/18 Ingo Molnar <mingo@elte.hu>:
>
> * Gregory Haskins <ghaskins@novell.com> wrote:
>
>> >>> On Mon, Jun 16, 2008 at  3:17 PM, in message
>> <1213643862.16944.142.camel@twins>, Peter Zijlstra <a.p.zijlstra@chello.nl>
>> wrote:
>> > On Mon, 2008-06-16 at 19:59 +0200, Dmitry Adamushko wrote:
>> >
>> >> One way or another, we have different aritifacts (and mine have likely
>> >> more) but conceptually, both "violates" POSIX if a strict round-robin
>> >> scheduling is required.
>> >
>> > http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#t
>> > ag_02_08_04_01
>> >
>> > Is quite strict on what FIFO should do, and I know of two points where
>> > we deviate and should work to match.
>>
>> Thanks for the link, Peter.  When you read that, its pretty clear that
>> this whole concept violates the standard.  Its probably best to just
>> revert the patch and be done with it.
>
> no, there's no spec violation here - the spec is silent on SMP issues.
>
> the spec should not be read to force a global runqueue for RT tasks.
> That would be silly beyond imagination.

I don't think it would actually make sense to specify behavior in
terms of per-cpu queues. This is an implementation detail. So the
_global_ (system-wise) queue makes more sense  (at least to me :-) if
one wants to define user-visible scheduling behavior.

e.g. as follows:
(http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#tag_02_08_04_01)

[quote]
"Threads scheduled under this policy are chosen from a thread list
that is ordered by the time its threads have been on the list without
being executed;"
[/quote]

>From the POV of users, I think only the "global" queue would make
sense. Otherwise, the sentence is rather useless.


[quote]
"generally, the head of the list is the thread that has been on the
list the longest time, and the tail is the thread that has been on the
list the shortest time."
[/quote]

OTOH, some differences can be justified by this "generally" word :-)

so it might be understood as something like this:

task_N can get a CPU only if all other pending runnable tasks that
have been enqueued earlier than task_N (of the same class and prio)
can _not_ start running on this CPU (e.g. due to their affinity).

Note, that our case is somewhat more subtle. We preempt a currently
running task in the hope that it can start running on another CPU
immediately, but we can't guarantee it.

Anyway, we are likely to win wrt cpu time distribution, but this fact
of 'preemption' is a new 'artifact' indeed.

if POSIX can be understood as : a SCHED_FIFO/RR task can be preempted
_only_ by a task with a higher prio and has to consume cpu-time as
long as it wants (FIFO) or till its timeslice expires (RR) , then we
violate it with this new behavior.


>
>        Ingo
>

-- 
Best regards,
Dmitry Adamushko
