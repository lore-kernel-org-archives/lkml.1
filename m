Return-Path: <linux-kernel-owner+w=401wt.eu-S933508AbZLOUPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbZLOUPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933456AbZLOUPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:15:36 -0500
Received: from 216-239-44-51.google.com ([216.239.44.51]:24661 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbZLOUPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:15:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nyu7mbmrxMWM13gJ5+UX1IJPG2LzD4k6PEcep9GE5SQS/D1exawLao+i3qiUwaH6C
	EDLQ1tcR+gpHriuRuNKCA==
MIME-Version: 1.0
In-Reply-To: <20091214170616.59fc163f@infradead.org>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	 <20091214161922.6f252492@infradead.org>
	 <4352991a0912141636t35a96c14o5fd4b9e152e6e681@mail.gmail.com>
	 <20091214170616.59fc163f@infradead.org>
Date: Tue, 15 Dec 2009 12:15:30 -0800
Message-ID: <4352991a0912151215o33524766p830e7fcbf9f1fc87@mail.gmail.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the 
	Linux Kernel
From: Salman Qazi <sqazi@google.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 5:06 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 14 Dec 2009 16:36:20 -0800
> Salman Qazi <sqazi@google.com> wrote:
>
>> On Mon, Dec 14, 2009 at 4:19 PM, Arjan van de Ven
>> <arjan@infradead.org> wrote:
>> > On Mon, 14 Dec 2009 15:11:47 -0800
>> > Salman Qazi <sqazi@google.com> wrote:
>> >
>> >
>> > I like the general idea, I have one request (that I didn't see
>> > quite in your explanation): Please make sure that all cpus in the
>> > system do their idle injection at the same time, so that memory can
>> > go into power saving mode as well during this time etc etc...
>> >
>>
>> With the current interface, the forced idle percentages on the CPUs
>> are controlled independently.  There's a trade-off here.  If we inject
>
> I'm fine with that... just want to ask that even if we inject different
> percentages, that we inject them for maximum overlap
> (having the memory power in a machine suddenly be half or less is a
> huge step in power, for something, the alignment itself, that does not
> cost much if any extra performance over randomly distributed idle
> insertions)

I think there is a difference in goals here.  Our goal is to free up
power from one machine, so that it can be used elsewhere.  This means
that any power that we save has to be predictably saved.  We have
models that map between CPU time and power usage, that have to account
for the worst case.  So, if we can save some extra power by
opportunistic means, unfortunately we have no way of using that power
elsewhere.

Having said that, energy savings is a worthy goal by itself.  But, we
have to make sure to balance it with performance.

>
>> idle cycles on all the CPU at the same time, our machine
>> responsiveness also degrades: essentially every CPU becomes equally
>> bad for an interactive task to run on.  Our aim at the moment is to
>> try to concentrate the idle cycles on a small set of CPUs, to strive
>> to leave some CPUs where interactive tasks can run unhindered.  But,
>> given a different workload and goals the correct policy may be
>> different.
>
> as long as the tentative portion of the idle time gets injected at the
> same time.. I suspect there can be a decent balance here where most of
> the time we get the full CPU *and* memory savings, while we degrade
> gracefully for the case where we get increasingly more interactive
> activity.

Let me rephrase what you just said to verify that I understand you
correctly:  we should align the enforcement intervals across CPUs and
thereby eagerly inject over the same time period across multiple CPUs.
 If there is no interactive workload then we would get maximal CPU and
memory savings.  If there are interactive tasks, then we just let them
run like we would in the eager injection in original design.

If I understand correctly, then I like your idea.

>
>
>> Simultaneously idling multiple "cores" becomes necessary in the SMT
>> case: as there is no point in idling a single thread, while the other
>> thread is running full tilt.
>
> I can argue the same for package level btw ;)
>
>
>> I think the best approach may be to provide a way to specify the
>> policy from the user space.  Basically let the user decide at what
>> level of CPU hierarchy the forced idle percentages are specified.
>> Then, in the levels below, we simply inject at the same time.
>
> it's not so much about the specification part; per logical cpu is a nice
> place to specify things... as long as we, in the execution part, align
> things up smart.
>
>
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
