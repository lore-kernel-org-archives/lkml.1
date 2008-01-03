Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYACRWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYACRWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYACRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:22:42 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:41523 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbYACRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:22:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAupfEdMROHU/2dsb2JhbACBV6hg
Date: Thu, 3 Jan 2008 12:22:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [RFC PATCH 00/11] mcount tracing utility
Message-ID: <20080103172238.GD27651@Krystal>
References: <20080103071609.478486470@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080103071609.478486470@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:06:33 up 60 days, 22:11,  6 users,  load average: 0.19, 0.42,
	0.29
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Great work!

(added Tim Bird, author of KFT/KFI to the CC list)

* Steven Rostedt (rostedt@goodmis.org) wrote:
>
...
> 
> Future:
> -------
> The way the mcount hook is done here, other utilities can easily add their
> own functions. Just care needs to be made not to call anything that is not
> marked with notrace, or you will crash the box with recursion. But
> even the simple tracer adds a "disabled" feature so in case it happens
> to call something that is not marked with notrace, it is a safety net
> not to kill the box.
> 
> I was originally going to use the relay system to record the data, but
> that had a chance of calling functions not marked with notrace. But, if
> for example LTTng wanted to use this, it could disable tracing on a CPU
> when doing the calls, and this will protect from recusion.
> 

Yes, I'd love to add this information source to LTTng. It simply boils
down to adding a "notrace" flag to LTTng tracing functions. Since I
don't use relay code _at all_ in the tracing path, there is no problem
with this (I only disable preemption and do "local" atomic operations on
per-cpu variables). Then I would have to do the glue code that registers
the LTTng handler to your mcount mechanism.

One interesting aspect of LTTng is that is would be very lightweight.
You seem to use interrupt disabling with your simple tracer and do a
_lot_ of cacheline bouncing (trace_idx[NR_CPUS] is a very good exemple).

LTTng would write the information to a per-cpu memory buffer in binary
format. I see that it would be especially useful in flight recorder
mode, where we overwrite the buffers without writing them to disk : when
a problematic condition is reached, (a kernel oops would be a good one),
then we just stop tracing and dump the last buffers to disk. In this
case, we would have the last function calls that led to an OOPS.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
