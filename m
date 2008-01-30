Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbYA3H0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbYA3H0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbYA3H0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:26:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYA3H0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:26:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Markus T. Metzger" <markus.t.metzger@intel.com>
X-Fcc: ~/Mail/utrace
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptrace API extensions for BTS
In-Reply-To: Metzger, Markus T's message of  Friday, 7 December 2007 09:11:04 -0000 <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com>
References: <029E5BE7F699594398CA44E3DDF55444010F8D7C@swsmsx413.ger.corp.intel.com>
Emacs: it's all fun and games, until somebody tries to edit a file.
Message-Id: <20080130072557.EC73C26F9A7@magilla.localdomain>
Date: Tue, 29 Jan 2008 23:25:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I did not get more into this discussion earlier.  I still have not
read through all of the email threads.  But I have looked over the current
version of your code now in -mm.

I think this work has a great deal of overlap with the perfmon2 project.
There are two facets that overlap, which together are the whole BTS feature.

The same x86 "debug store" hardware is programmed for both the BTS and the
performance monitoring features.  The implementations clearly have to
cooperate on managing that hardware.  Your ds.c is a start in the right
direction, to abstract the hardware configuration from the BTS feature and
its interface.  I'm not familiar with the perfmon2 code, but it may have
something similar already.

The rest of the BTS feature is the buffer management and the interface.
It has to deal with the hardware buffer setup, context switching, and
overflow interrupts, and delivering data from the hardware buffers to the
interface in appropriate formats.  We'd also like it to be able to trace
kernel-mode as well as user-mode, and either deliver combined data or
segregate the data between the two for user-space and kernel-space users
who need not know about each other's tracing.  (On some of the hardware
you can program it to record only one or the other (X86_FEATURE_DSCPL).
On older hardware, or when separately tracing both, you can trace both
and then distinguish each sample by its from_ip.)  perfmon2 also wants to
address all of that.

I don't much like the way you've shoe-horned the context-switch timestamp
logging into the BTS feature.  It's a nice feature to have in some form,
and I sympathize with your seeing it as easy pickings once you had the
BTS buffer machinery handy.  But really it is not part of the BTS feature
and there is nothing arch-dependent about it.  Given some other general
thing providing the buffer management et al, that could just be done in
schedule(), i.e.:

		departs(prev);
		context_switch(rq, prev, next); /* unlocks the rq */
		arrives(prev);

If there is a general thing for event-reporting from perfmon2 or
whatever, then it might be natural to have the context-switch event
reports configurable to different record formats you might be using 
for other things.  For a BTS-style record, I would use:

     departs: { .from = task_pt_regs(prev)->ip, .to = jiffies, .flag = MAGIC1 }
     arrives: { .from = jiffies, .to = task_pt_regs(next)->ip, .flag = MAGIC2 }
     MAGIC1 = 0xffff0001
     MAGIC2 = 0xffff0002

or something like that, i.e. as if it were a "branch to block-time" and a
"branch from wake-time".  (Actually you might want MAGIC3 and MAGIC4 too,
for whether it was a voluntary or involuntary context switch.)  For
different use that is doing mostly other event sampling rather than BTS,
it might use a different format that gives more register into a la PEBS.

I'm no expert on perfmon2 and I understand there are many issues to be
resolved to get it into the kernel.  But if you are not desperate to have
the BTS feature in the kernel ASAP, it would ideal IMHO if you can work
with Stephane et al on putting this work together.  I'd like to see the
work go into the kernel in much smaller pieces even than your BTS patch
set that's in -mm.  The first thing is just the DS hardware management,
context switch and hardware-facing parts of the buffer management (one or
three or fourth small bisect-friendly patches just for that much).  If
you and Stephane can hash out a fresh patch that provides what you both
need for that, that would be a great start.  Personally, I'd prefer to
abandon the ptrace extensions altogether in favor of some generalized
event buffer interface that comes from merging perfmon2.  But if you
still want to do the ptrace interface, it can be built on the shared
DS-management code.  What do you think?


Thanks,
Roland
