Return-Path: <linux-kernel-owner+w=401wt.eu-S967430AbXFHCfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967430AbXFHCfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967213AbXFHCeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:34:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967062AbXFHCen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:34:43 -0400
Date: Thu, 7 Jun 2007 19:34:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Masoud Asgharifard Sharbiani <masouds@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make i386 kernel show the segfaults in kernel dmesg,
 like x86_64.
Message-Id: <20070607193431.af9ab198.akpm@linux-foundation.org>
In-Reply-To: <4668B939.1070304@shaw.ca>
References: <fa.FB3wQKN6ltiEi81XcB14YVcLGgE@ifi.uio.no>
	<4668B939.1070304@shaw.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 20:04:41 -0600 Robert Hancock <hancockr@shaw.ca> wrote:

> Masoud Asgharifard Sharbiani wrote:
> > Hello,
> > This patch makes the i386 behave the same way that x86_64 does when a
> > segfault happens. A line gets printed to the kernel log so that tools
> > that need to check for failures can behave more uniformly between
> > different kernels. Like x86_64, it can be disabled by setting
> > debug.exception-trace sysctl variable to 0 (or by doing
> > echo 0 > /proc/sys/debug/exception-trace)
> > 
> > Same behaviour can be extended to other architectures, if needed.
> > cheers,
> > Masoud.
> > 
> > Signed-off-by: Masoud Sharbiani <masouds@google.com>
> > 
> > diff --git a/arch/i386/mm/fault.c b/arch/i386/mm/fault.c
> > index 29d7d61..6aa56db 100644
> > --- a/arch/i386/mm/fault.c
> > +++ b/arch/i386/mm/fault.c
> > @@ -283,6 +283,8 @@ static inline int vmalloc_fault(unsigned long address)
> >  	return 0;
> >  }
> >  
> > +int exception_trace = 1;
> > +
> >  /*
> >   * This routine handles page faults.  It determines the address,
> >   * and the problem, and then passes it off to one of the appropriate
> > @@ -464,7 +466,14 @@ bad_area_nosemaphore:
> >  		 */
> >  		if (is_prefetch(regs, address, error_code))
> >  			return;
> > -
> > +		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
> > +			printk(
> > +		       "%s%s[%d]: segfault at %08lx eip %08lx esp %08lx error %lx\n",
> > +					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
> > +					tsk->comm, tsk->pid, address, regs->eip,
> > +					regs->esp, error_code);
> 
> Shouldn't we use printk_ratelimit() here, to prevent some nasty person 
> from creating some rapidly-segfaulting process that floods the kernel 
> logs? (Same with the x86_64 version if it doesn't already..)

Yes.  In fact I thought that was in there, but I must have dreamed it.
