Return-Path: <linux-kernel-owner+w=401wt.eu-S1756327AbXGaJce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbXGaJce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbXGaJc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:32:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33714 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752531AbXGaJcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:32:25 -0400
Date: Tue, 31 Jul 2007 11:31:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH respin, was PATCH for review] During VM oom condition, kill all threads in process group
Message-ID: <20070731093132.GA5778@elf.ucw.cz>
References: <20070719348.540885000@suse.de> <20070719134840.47B5114E6E@wotan.suse.de> <20070719140411.GD16279@infradead.org> <Pine.LNX.4.64.0707191614180.7377@anakin> <1185214185.22237.30.camel@farscape.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185214185.22237.30.camel@farscape.rchland.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 
> During VM oom condition, kill all threads in process group.
> 
> We have had complaints where a threaded application is left in a bad
> state after one of it's threads is killed when we hit a VM: out_of_memory
> condition.
> Killing just one of the process threads can leave the application in a
> bad state, whereas killing the entire process group would allow for
> the application to restart, or be otherwise handled, and makes it very
> obvious that something has gone wrong.
> 
> This change allows the entire process group to be taken down, rather
> than just the one thread.
> 
> Signed-off-by: Will Schmidt <will_schmidt@vnet.ibm.com>

> diff --git a/arch/sparc64/mm/fault.c b/arch/sparc64/mm/fault.c
> index 17123e9..13fdfa3 100644
> --- a/arch/sparc64/mm/fault.c
> +++ b/arch/sparc64/mm/fault.c
> @@ -466,7 +466,7 @@ out_of_memory:
>  	up_read(&mm->mmap_sem);
>  	printk("VM: killing process %s\n", current->comm);
>  	if (!(regs->tstate & TSTATE_PRIV))
> -		do_exit(SIGKILL);
> +		do_group_exit(SIGKILL);
>  	goto handle_kernel_fault;
>  
>  intr_or_no_mm:

is the printk still accurate (does it kill more than one process now)?
Why does it print when it will not really kill the process?

I see similar code across all the archs... would it make sense to
create common helper... or is the helper too trivial?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
