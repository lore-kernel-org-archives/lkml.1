Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0AOVHm (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479Ab0AOVHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:07:41 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:49521 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab0AOVHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:07:40 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263546175.4244.342.camel@laptop>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546175.4244.342.camel@laptop>
Content-Type: text/plain
Date: Fri, 15 Jan 2010 13:07:14 -0800
Message-Id: <1263589634.5007.34.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2010-01-15 at 10:02 +0100, Peter Zijlstra wrote:
> On Thu, 2010-01-14 at 11:46 -0800, Jim Keniston wrote:
> > 
> > +Instruction copies to be single-stepped are stored in a per-process
> > +"single-step out of line (XOL) area," which is a little VM area
> > +created by Uprobes in each probed process's address space.
> 
> I think tinkering with the probed process's address space is a no-no.
> Have you ran this by the linux mm folks?

Sort of.

Back in 2007 (!), we were getting ready to post uprobes (which was then
essentially uprobes+xol+upb) to LKML, pondering XOL alternatives and
waiting for utrace to get pulled back into the -mm tree.  (It turned out
to be a long wait.)  I emailed Andrew Morton, inquiring about the
prospects for utrace and giving him a preview of utrace-based uprobes.
He expressed openness to the idea of allocating a piece of the user
address space for the XOL area, a la the vdso page.

With advice and review from Dave Hansen, we implemented an XOL page, set
up for every process (probed or not) along the same lines as the vdso
page.

About that time, Roland McGrath suggested using do_mmap_pgoff() to
create a separate vma on demand.  This was the seed of the current
implementation.  It had the advantages of being
architecture-independent, affecting only probed processes, and allowing
the allocation of more XOL slots.  (Uprobes can make do with a fixed
number of XOL slots -- allowing one probepoint to steal another's slot
-- but it isn't pretty.)

As I recall, Dave preferred the other idea (1 XOL page for every
process, probed or not) -- mostly because he didn't like the idea of a
new vma popping into existence when the process gets probed -- but was
OK with us going ahead with Roland's idea.

(I'm not a VM guy; pardon any imprecision in my language.)

Jim

> I'd be inclined to NAK this
> straight out.
> 



