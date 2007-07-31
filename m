Return-Path: <linux-kernel-owner+w=401wt.eu-S1764473AbXGaO4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764473AbXGaO4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761188AbXGaOz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:55:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50382 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760972AbXGaOzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:55:54 -0400
Subject: Re: [PATCH respin, was PATCH for review] During VM oom condition,
	kill all threads in process group
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20070731093132.GA5778@elf.ucw.cz>
References: <20070719348.540885000@suse.de>
	 <20070719134840.47B5114E6E@wotan.suse.de>
	 <20070719140411.GD16279@infradead.org>
	 <Pine.LNX.4.64.0707191614180.7377@anakin>
	 <1185214185.22237.30.camel@farscape.rchland.ibm.com>
	 <20070731093132.GA5778@elf.ucw.cz>
Content-Type: text/plain
Organization: IBM
Date: Tue, 31 Jul 2007 09:55:51 -0500
Message-Id: <1185893751.22717.36.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 11:31 +0200, Pavel Machek wrote:
> Hi!
> 
> > 
> > During VM oom condition, kill all threads in process group.
> > 
> > We have had complaints where a threaded application is left in a bad
> > state after one of it's threads is killed when we hit a VM: out_of_memory
> > condition.
> > Killing just one of the process threads can leave the application in a
> > bad state, whereas killing the entire process group would allow for
> > the application to restart, or be otherwise handled, and makes it very
> > obvious that something has gone wrong.
> > 
> > This change allows the entire process group to be taken down, rather
> > than just the one thread.
> > 
> > Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>
> 
> > diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
> > index 17123e9..13fdfa3 100644
> > --- a/arch/sparc64/mm/fault.c
> > +++ b/arch/sparc64/mm/fault.c
> > @@ -466,7 +466,7 @@ out_of_memory:
> >  	up_read(&mm->mmap_sem);
> >  	printk("VM: killing process %s\n", current->comm);
> >  	if (!(regs->tstate & TSTATE_PRIV))
> > -		do_exit(SIGKILL);
> > +		do_group_exit(SIGKILL);
> >  	goto handle_kernel_fault;
> >  
> >  intr_or_no_mm:
> 
> is the printk still accurate (does it kill more than one process now)?

I was going to double-check this morning.. but don't see where
current->comm is copied into a new task_struct.  I thought that all
processes within the group had the same current->comm value, so figure
this is OK.  

> Why does it print when it will not really kill the process?
no idea..  

> I see similar code across all the archs... would it make sense to
> create common helper... or is the helper too trivial?

The checks blocking flow into do_group_exit, like (regs->tstate &
TSTATE_PRIV) for sparc64, or (user_mode(regs)) for powerpc, do vary
across the arch's.    The code could be rearranged to have a helper
containing just the printk and the do_group_exit() call; but I'm not
sure that would be an improvement. 

maybe a    do_group_sigkill_if(condition); helper    :-)


-Will 

> 									Pavel

