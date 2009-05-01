Return-Path: <linux-kernel-owner+w=401wt.eu-S1760998AbZEANzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760998AbZEANzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbZEANyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:54:50 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:55303 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbZEANys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:54:48 -0400
Date: Fri, 1 May 2009 09:44:55 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430211750.GA19933@Krystal>
Message-ID: <alpine.DEB.1.10.0905010939090.18324@qirst.com>
References: <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com>
 <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com> <20090430211750.GA19933@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Mathieu Desnoyers wrote:

> By ZVC update, you mean Zone ... Counter update ? (which code exactly ?)

The code that you were modifying in vmstat.c.

> Hrm, I must admit I'm not sure I follow how your reasoning applies to my
> code. I am using a percpu_add_return_irq() exactly for this reason : it
> only ever touches the percpu variable once and atomically. The test for
> overflow is done on the value returned by percpu_add_return_irq().

If the percpu differential goes over a certain boundary then the
differential would be updated twice.

> Therefore, an interrupt scenario that would be close to what I
> understand from your concerns would be :
>
> * Thread A
>
> inc_zone_page_state()
>   p_ret = percpu_add_return(p, 1); (let's suppose this increment
>                                     overflows the threshold, therefore
>                                     (p_ret & mask) == 0)
>
> ----> interrupt comes in, preempts the current thread, execution in a
>       different thread context (* Thread B) :
>
>      inc_zone_page_state()
>        p_ret = percpu_add_return(p, 1);  ((p_ret & mask) == 1)
>        if (!(p_ret & mask))
>          increment global zone count. (not executed)
>
> ----> interrupt comes in, preempts the current thread, execution back to
>       the original thread context (Thread A), on the same or on a
>       different CPU :
>
>   if (!(p_ret & mask))
>     increment global zone count.   -----> will therefore increment the
>                                           global zone count only after
>                                           scheduling back the original
>                                           thread.
>
> So I guess what you say here is that if Thread B is preempted for too
> long, we will have to wait until it gets scheduled back before the
> global count is incremented. Do we really need such degree of precision
> for those counters ?
>
> (I fear I'm not understanding your concern fully though)

Inc_zone_page_state modifies the differential which is u8 and can easily
overflow.

Hmmm. But if you check for overflow to zero this way it may work without
the need for cmpxchg. But if you rely on overflow then we only update the
global count after 256 counts on the percpu differential. The tuning of
the accuracy of the counter wont work anymore. The global counter could
become wildly inaccurate with a lot of processors.


