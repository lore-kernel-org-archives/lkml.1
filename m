Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYGSWHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYGSWHK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 18:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYGSWG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 18:06:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:38721 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYGSWG6 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 18:06:58 -0400
Date: Sat, 19 Jul 2008 15:05:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "V.Radhakrishnan" <rk@atr-labs.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <Linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: Patch [1/1] minor bugfix in 2.6.26/arch/x86/mm/pat.c - caused
 problems in mmap() of /dev/mem character file
Message-ID: <20080719150546.15a0e773@infradead.org>
In-Reply-To: <1216346657.2170.11.camel@atlas>
References: <1216315516.2324.10.camel@atlas>
	<alpine.LFD.1.10.0807171025110.2959@woody.linux-foundation.org>
	<20080717223940.GA8206@elte.hu>
	<1216346657.2170.11.camel@atlas>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 07:34:17 +0530
"V.Radhakrishnan" <rk@atr-labs.com> wrote:
> > But this duplication is ugly and confusing - we should have just a 
> > single check function, defined once and unconditionally, and
> > utilized by both places (with the devmem check being optional).
> > 
> > Venki, Arjan, agreed?
> 
> In fact, I spent some time thinking that the bug was actually at the
> higher level API instead of in the arch specific layer, and I was
> amazed that in spite of the config level option being turned off, it
> was NOT being reflected in the code !!

Hi,

it's great to see new people contribute to the kernel, however your
patch is not correct. In the PAT case, we really cannot allow /dev/mem
mmap access of kernel-used memory. It would create an incorrect cache
alias... which can have really bad effects, including tripple faulting
the cpu (which is an instant reboot) or data corruption, depending on
which model/vendor CPU you have.

What your patch does is to remove the code that prevents this situation
from happening... and that makes it not a very good idea.

Now, /dev/mem mmap access of address space that is not used by the
kernel is still allowed by the code (for example the PCI mmio region)...

Can you describe what you were trying to achieve by mmaping
of /dev/mem ? It sounds like you have a bug, since it's certainly
curious that you would want to deal with kernel memory this way.
(for example until recently, you wouldn't be able to do this at all)

Greetings,
   Arjan van de Ven


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
