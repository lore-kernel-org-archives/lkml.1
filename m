Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999Ab0ATP6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0ATP6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497Ab0ATP6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:58:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59216 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0ATP6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:58:06 -0500
Date: Wed, 20 Jan 2010 15:57:53 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100120155753.GF5154@csn.ul.ie>
References: <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com> <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com> <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com> <1263816857.4283.381.camel@laptop> <4B5455FF.7010409@redhat.com> <1263820551.4283.499.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1263820551.4283.499.camel@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 02:15:51PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 14:37 +0200, Avi Kivity wrote:
> > On 01/18/2010 02:14 PM, Peter Zijlstra wrote:
> > >
> > >> Well, the alternatives are very unappealing.  Emulation and
> > >> single-stepping are going to be very slow compared to a couple of jumps.
> > >>      
> > > With CPL2 or RPL on user segments the protection issue seems to be
> > > manageable for running the instructions from kernel space.
> > >    
> > 
> > CPL2 gives unrestricted access to the kernel address space; and RPL does 
> > not affect page level protection.  Segment limits don't work on x86-64.  
> > But perhaps I missed something - these things are tricky.
> 
> So setting RPL to 3 on the user segments allows access to kernel pages
> just fine? How useful.. :/
> 
> > It should be possible to translate the instruction into an address space 
> > check, followed by the action, but that's still slower due to privilege 
> > level switches.
> 
> Well, if you manage to do the address validation you don't need the priv
> level switch anymore, right?
> 

It also starts becoming very x86-centric though, doesn't it? It might
kick other ports later.

What is there at the moment is storing the copied instructions in a VMA.
The most unpalatable part of that to me is that it's visible to
userspace, probably via /proc/ and I didn't check, but I hope an
munmap() from userspace cannot delete it.

What the VMA has going for it is that it *appears* to be easier to port to
other architectures than the alternatives, certainly easier to handle than
instruction emulation.

> Are the ins encodings sane enough to recognize mem parameters without
> needing to know the actual ins?
> 
> How about using a hw-breakpoint to close the gap for the inline single
> step? You could even re-insert the int3 lazily when you need the
> hw-breakpoint again. It would consume one hw-breakpoint register for
> each task/cpu that has probes though..
> 

This feels very racy. Along with that, making these sort of changes
was considered a risky venture on x86 and needed strong verification from
elsewhere (http://lkml.org/lkml/2010/1/12/300). There are probably similar
concerns on other architectures that would make a reliable port difficult.

Right now the approach is with VMAs. The alternatives are

  1. reserved XOL page (similar disadvantages to the VMA)
  2. emulated instructions
	This is an emulation bug waiting to happen in my opinion and makes
	porting uprobes a significantly more difficult undertaking than
	either the XOL-VMA or XOL-page approach
  3. XOL page in kernel space available at a different CPL
	This assumes all target architectures have a usable privilege
	ring which may be the case. However, I would guess that it
	is going to perform worse than the current approach because
	of the change in privilege level. No idea what the cost of
	a privilege level change is, but I doubt it's free
  4. Boosted probes (arch-specific, apparently only x86 does this for
	kprobes)

As unpalatable as the VMA is, I am failing to see why it's not a
reasonable starting point with an understanding that 2 or 3 would be
implemented in the future after the other architecture ports are in
place and the reliability of the options as well as the performance can
be measured.

There would appear to be two classes of application that might suffer
from the VMA. The first which need absolutly every single ounce of address
space. The second which introspects itself via /proc/self/maps and makes
decisions based on that. The first is unfortunate but should be a limited
number of use cases. The second could be fudged by simply not exporting the
information via /proc.

I'm of the opinion it would be reasonable to let the VMA go ahead, look
at the ports for the other architectures and revisit options 2 and 3 above
to see if the VMA can really be removed with performance or reliability
penalty.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
