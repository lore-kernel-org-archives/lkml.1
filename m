Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0CDSS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:18:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32974 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0CDSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:18:56 -0500
Subject: Re: [RFC][PATCH 08/11] perf, x86: Implement simple LBR support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com
In-Reply-To: <bd4cb8901003040954n5b05e139wa24f8e50789421ac@mail.gmail.com>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.451251096@chello.nl>
	 <bd4cb8901003031357x9c13c96h3899ab0459a34b0e@mail.gmail.com>
	 <1267693107.25158.149.camel@laptop>
	 <bd4cb8901003040954n5b05e139wa24f8e50789421ac@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 19:18:53 +0100
Message-ID: <1267726733.25158.219.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 09:54 -0800, Stephane Eranian wrote:
> On Thu, Mar 4, 2010 at 12:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-03-03 at 22:57 +0100, Stephane Eranian wrote:
> >> I don't understand how LBR state is migrated when a per-thread event is moved
> >> from one CPU to another. It seems LBR is managed per-cpu.
> >>
> >> Can you explain this to me?
> >
> > It is not, its basically impossible to do given that the TOS doesn't
> > count more bits than is strictly needed.
> >
> I don't get that about the TOS.
> 
> So you are saying that one context switch out, you drop the current
> content of LBR. When you are scheduled back in on an another CPU,
> you grab whatever is there?

What is currently implemented is that we loose history at the point a
new task schedules in an LBR using event.

If we had a wider TOS we could try and stitch partial stacks together
because we could detect overflow.

We could also preserve the LBR because we would be able to know where a
task got scheduled in and not release information of the previous task
while still allowing a cpu-wide user to see everything.

> > Or we should stop supporting cpu and task users at the same time.
> >
> Or you should consider LBR as an event which has a constraint that
> it can only run on one pseudo counter (similar to what you do with
> BTS). Scheduling would take care of the mutual exclusion. Multiplexing
> would provide the work-around.

Yes, that an even more limited case than not sharing it between task and
cpu context, which is basically the strongest you need.

If you do that you can store the LBR stack on unschedule and put it back
on schedule (on whichever cpu that may be).

But since we do not support LBR-config that'll be of very limited use
since there are enough branches between the point where we schedule the
counter to hitting userspace to cycle the LBR several times.



