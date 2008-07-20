Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYGTPrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYGTPrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757288AbYGTPq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:46:59 -0400
Received: from smtp.net4india.com ([202.71.129.68]:36826 "EHLO
	smtp.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138AbYGTPq6 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:46:58 -0400
Subject: Re: Patch [1/1] minor bugfix in 2.6.26/arch/x86/mm/pat.c - caused
	problems in mmap() of /dev/mem character file
From: "V.Radhakrishnan" <rk@atr-labs.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <Linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <20080719150546.15a0e773@infradead.org>
References: <1216315516.2324.10.camel@atlas>
	 <alpine.LFD.1.10.0807171025110.2959@woody.linux-foundation.org>
	 <20080717223940.GA8206@elte.hu> <1216346657.2170.11.camel@atlas>
	 <20080719150546.15a0e773@infradead.org>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 21:20:46 +0530
Message-Id: <1216569046.2268.14.camel@atlas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks !

I was teaching a class of 17 students from HP, basics of kernel
debugging. I had already burnt CDs for them with 2.6.25, and I thought I
would try out the latest 2.6.26 ( announced just a day before the start
of the training program ) last week.

I wanted to cover basic concepts of memory management, and used
the /dev/mem purely as a means to show them what the physical memory
contains, how you can use this mechanism to view the contents of RAM
after a DMA to verify data patterns etc.

It so happened that all my 17 students had working code with 2.6.25 and
I, the instructor, had the kernel 2.6.26 crash in front of them !

So I started tracing the call and found the 'bug' and 'fixed it'.

I agree with you 100% that my patch does not solve the problem, but is a
quick fix approach to the next release. The PAT related access issue is
valid. However, I humbly submit that memory access is a policy issue and
perhaps should not be tinkered with thru code. 

If you provide the root, access to /dev/mem, I don't think it should be
a problem, since in any case, all others are denied access. Also,
theoretically, if you access RAM for Read Only, why should there be a
triple fault ? Again, if you access RAM, modify content, and mark those
pages as dirty ( as described in LDD ), isnt that supposed to take care
of cache issue ? Again, I re-iterate, I am NOT suggesting writing
directly to RAM !, But what about Read Access which which is what
several simple debuggers do ? The crash utility from RedHat also reads
memory (both user as well as kernel virtual addresses as input ). Is
reading RAM directly using a physical address deemed 'bad' ?

Thanks, anyway, and really happy that you have taken the time to answer
these issues.

regards

V. Radhakrishnan (alias 'RK')



On Sat, 2008-07-19 at 15:05 -0700, Arjan van de Ven wrote:
> On Fri, 18 Jul 2008 07:34:17 +0530
> "V.Radhakrishnan" <rk@atr-labs.com> wrote:
> > > But this duplication is ugly and confusing - we should have just a 
> > > single check function, defined once and unconditionally, and
> > > utilized by both places (with the devmem check being optional).
> > > 
> > > Venki, Arjan, agreed?
> > 
> > In fact, I spent some time thinking that the bug was actually at the
> > higher level API instead of in the arch specific layer, and I was
> > amazed that in spite of the config level option being turned off, it
> > was NOT being reflected in the code !!
> 
> Hi,
> 
> it's great to see new people contribute to the kernel, however your
> patch is not correct. In the PAT case, we really cannot allow /dev/mem
> mmap access of kernel-used memory. It would create an incorrect cache
> alias... which can have really bad effects, including tripple faulting
> the cpu (which is an instant reboot) or data corruption, depending on
> which model/vendor CPU you have.
> 
> What your patch does is to remove the code that prevents this situation
> from happening... and that makes it not a very good idea.
> 
> Now, /dev/mem mmap access of address space that is not used by the
> kernel is still allowed by the code (for example the PCI mmio region)...
> 
> Can you describe what you were trying to achieve by mmaping
> of /dev/mem ? It sounds like you have a bug, since it's certainly
> curious that you would want to deal with kernel memory this way.
> (for example until recently, you wouldn't be able to do this at all)
> 
> Greetings,
>    Arjan van de Ven
> 
> 

