Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbXJXC2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbXJXC2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXJXC2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:28:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXJXC2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:28:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VGpUWUEBCr4rhV7hH4p//egaWZWBtrgsE2OlzhtfEy0YNM0lh6gNVr1m5MjlKzE8j
	O0i4R/FoABRtK61Kfs6DA==
Message-ID: <6599ad830710231928n65a80021w582a07b5993377f8@mail.gmail.com>
Date: Tue, 23 Oct 2007 19:28:22 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071023173837.GG4667@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4523.4040509@google.com>
	 <20071023164704.GE4667@linux.vnet.ibm.com>
	 <6599ad830710230941y5d175688ob3a4d9ac42ba8c8f@mail.gmail.com>
	 <20071023173837.GG4667@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> > Suppose you have two cgroups that would each want to use, say, 55% of
> > a CPU - technically they should each be regarded as having 45% idle
> > time, but if they run on a the same CPU the chances are that they will
> > both always have some processes on their runqueue due to contention
> > with the other group. So how would you measure the difference between
> > this and a cgroup that really is trying to use 100%?
>
> Good point. I think we need to subtract out the time it was waiting on runqueue
> when calculating idle time.
>
>         |------- . . . . . . ---------zzzzzzzzzzzz.......-----------|
>         t0     t1            t2       t3         t4     t5          t6
>
>
>         ----    -> Running time
>         ....    -> Waiting time (to get on the cpu)
>         zzzz    -> Sleeping time (when it didnt want to run because of
>                    lack of tasks)
>
> So, in this case,
>
>         idle time = (t4 - t3) / [ (t6 - t1) - (t2-t1) - (t5-t4)
>

Do you mean (t6 - t0) where you have (t6 - t1)?

> ?
>
> This idle time will be a per-cpu stat for every cgroup and needs to be
> consolidated across cpus into a single idle-stat number, just like how
> top does it.

This would be an idle fraction, not an idle time. (seconds divided by seconds)

It doesn't seem quite right to me that a cgroup's idle time metric be
affected by the activity of other cgroups on the machine, but it's
hard to come up with a way of measuring it that doesn't have this
behaviour - which is why, in the absence of hard CPU partitioning,
it's not clear to me how much use this would be.

What would people be planning to use it for?

Paul
