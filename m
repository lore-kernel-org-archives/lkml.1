Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab0AOVuH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319Ab0AOVuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:50:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:37099 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab0AOVuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:50:05 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Peter Zijlstra <peterz@infradead.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        utrace-devel <utrace-devel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1263589634.5007.34.camel@localhost.localdomain>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122529.22050.32596.sendpatchset@srikar.in.ibm.com>
	 <1263467289.4244.288.camel@laptop>
	 <1263498366.4875.25.camel@localhost.localdomain>
	 <1263546175.4244.342.camel@laptop>
	 <1263589634.5007.34.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 22:49:52 +0100
Message-ID: <1263592192.4244.488.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 13:07 -0800, Jim Keniston wrote:
> On Fri, 2010-01-15 at 10:02 +0100, Peter Zijlstra wrote:
> > On Thu, 2010-01-14 at 11:46 -0800, Jim Keniston wrote:
> > > 
> > > +Instruction copies to be single-stepped are stored in a per-process
> > > +"single-step out of line (XOL) area," which is a little VM area
> > > +created by Uprobes in each probed process's address space.
> > 
> > I think tinkering with the probed process's address space is a no-no.
> > Have you ran this by the linux mm folks?
> 
> Sort of.
> 
> Back in 2007 (!), we were getting ready to post uprobes (which was then
> essentially uprobes+xol+upb) to LKML, pondering XOL alternatives and
> waiting for utrace to get pulled back into the -mm tree.  (It turned out
> to be a long wait.)  I emailed Andrew Morton, inquiring about the
> prospects for utrace and giving him a preview of utrace-based uprobes.
> He expressed openness to the idea of allocating a piece of the user
> address space for the XOL area, a la the vdso page.
> 
> With advice and review from Dave Hansen, we implemented an XOL page, set
> up for every process (probed or not) along the same lines as the vdso
> page.
> 
> About that time, Roland McGrath suggested using do_mmap_pgoff() to
> create a separate vma on demand.  This was the seed of the current
> implementation.  It had the advantages of being
> architecture-independent, affecting only probed processes, and allowing
> the allocation of more XOL slots.  (Uprobes can make do with a fixed
> number of XOL slots -- allowing one probepoint to steal another's slot
> -- but it isn't pretty.)
> 
> As I recall, Dave preferred the other idea (1 XOL page for every
> process, probed or not) -- mostly because he didn't like the idea of a
> new vma popping into existence when the process gets probed -- but was
> OK with us going ahead with Roland's idea.

Well, I think its all very gross, I would really like people to try and
'emulate' or plain execute those original instructions from kernel
space.

As to the privileged instructions, I think qemu/kvm like projects should
have pretty much all of that covered.

Nor do I think we need utrace at all to make user space probes useful.
Even stronger, I think the focus on utrace made you get some
fundamentals wrong. Its not mainly about task state, but like said, its
about text mappings, which is something utrace knows nothing about.

That is not to say you cannot build a useful interface from uprobes and
utrace, but its not at all required or natural.

