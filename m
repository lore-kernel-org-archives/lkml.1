Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZG2JUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZG2JUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbZG2JUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:20:08 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:62474 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZG2JUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:20:06 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
 breakpoints
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: prasad@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <20090729063704.GA3297@in.ibm.com>
References: <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com>
	 <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere>
	 <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere>
	 <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com>
	 <1248684817.6987.1573.camel@twins> <20090728161218.GA3526@in.ibm.com>
	 <1248799286.6987.3026.camel@twins>  <20090729063704.GA3297@in.ibm.com>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 11:22:52 +0200
Message-Id: <1248859372.6987.3062.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 12:07 +0530, K.Prasad wrote:

> > That still doesn't provide per-cpu breakpoints.
> > 
> 
> Yes, it doesn't provide a per-cpu only implementation. One can obtain
> the per-cpu data from the system-wide breakpoints by filtering it for a
> given CPU (agreed, it will associated overhead).
> 
> A true per-cpu breakpoint implementation that co-exists with
> system-wide and per-task breakpoints will be difficult. It might require
> the re-introduction of some old features and a few new ones (like switching
> between kernel and user-space breakpoints at syscall time) that were
> rejected earlier by the community.

I'm not clear on why you'd need to switch breakpoints on syscall entry.
You can simply leave the kernel address breakpoint around in userspace,
they're not able to poke at that address space anyway.

> Also, the reason for a per-cpu only breakpoint (user and kernel-space)
> isn't very obvious. While kernel variables can be read/written
> throughout the system and user-space variables are per-task, the need
> for obtaining per-cpu information isn't clear.

Well, suppose you're monitoring a per-cpu variable, or interested in the
effects of a workload confined to 1 cpu or node, there is no reason to
have this breakpoint on all cpus.

> 
> This is a little confusing. I'm trying to understand which of the
> questions below does perf-counter try to answer. i) and ii) is what I
> thought would be, and asking iii) doesn't make much sense. What do you
> think?
> 
> i) Tell me how many times kernel variable 'x' was updated when task 'a'
> was scheduled
> ii) Tell me how many times kernel variable 'x' was updated on the system
> since I registered for the breakpoint
> iii) Tell me how many times kernel variable 'x' was updated on CPU 'n'

It's 1 and 3. perf-counters doesn't deal with system wide for the
reasons given above.

If you want system wide, you can create a perf counter for each cpu.

But the larger the machine gets, the less likely it is that that is what
you're after. Being per-cpu allows you to do things on a
per-node/socket/etc.. basis which is impossible to do when you limit
yourself to per task or system wide.

