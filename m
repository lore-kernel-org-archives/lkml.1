Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYIDHeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYIDHeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbYIDHdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:33:55 -0400
Received: from aun.it.uu.se ([130.238.12.36]:64434 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYIDHdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:33:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18623.36692.859271.520627@harpo.it.uu.se>
Date: Thu, 4 Sep 2008 09:33:40 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: alin.jula@sap.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: sigaction with SA_SIGINFO does not pass the correct return context
In-Reply-To: <1220462811.3541.18.camel@linux-6ir4.site>
References: <1220462811.3541.18.camel@linux-6ir4.site>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alin Jula writes:
 > Summary: sigaction with SG_SIGINFO passes the incorrect context on
 > OpenSuse ﻿(kernels 2.6.16.21-0.8-smp and 2.6.25.11-0.1-default).
 > However, it passes the correct one on ﻿Ubuntu (kernel
 > 2.6.24-19-generic).
 > 
 > I'm trying to catch the SIGSEGV signal, do something, and then return
 > control back to the application. I use "sigaction" with the SA_SIGINFO
 > flag. This flags allows a handler to be called upon a signal, and it
 > should (POSIX defined) also provide the context of the thread when the
 > signal was issued. The problem is that the right context does _not_ work
 > on OpenSuse, but it works on Ubuntu.
 > 
 > So I was wondering if there is a specific action that one needs to take
 > on OpenSuse when dealing with this issue, or if there is a bug in the
 > kernel/opensuse ?
 > 
 > On Ubuntu (kernel 2.6.24-19-generic), sigaction correctly provides the
 > context of the thread that raised the signal. However, on two other
 > installations of OpenSuse (kernels 2.6.16.21-0.8-smp and
 > 2.6.25.11-0.1-default), sigaction provides a different context.
 > 
 > Below is the code example, with its summary. 4KB get allocated with
 > mmap, with "not to be accessed" protection. A write to this memory chunk
 > raises a SIGSEGV signal. This signal is then caught, and the memory
 > protection is changed to read+write. Then, the control is given back to
 > the instruction that raised this signal, and the application should
 > proceed from there. The code works on Ubuntu, but on the both OpenSuse
 > installations that I tried (see above for kernels), the context passed
 > by sigaction is the context of the handler instead of the instruction
 > that raised the signal.
 > 
 > Here is the code:
 >        #include <unistd.h>
 >        #include <signal.h>
 >        #include <stdio.h>
 >        #include <stdlib.h>
 >        #include <sys/mman.h>
 >        #include <ucontext.h>
 >        
 >        #define handle_error(msg) \
 >            do { perror(msg); exit(EXIT_FAILURE); } while (0)
 > 
 > 
 >        ucontext_t context_trigger, context_sig;
 >        struct sigaction sa_new, sa_old;     
 > 
 >        static void
 >        handler(int sig, siginfo_t *si, void *context)
 >        {
 >        if ((sig == SIGSEGV) || (sig == SIGBUS) )
 >        	{
 >            printf("\nGot SIGSEGV or SIGBUS at address: 0x%lx and context
 > =%lx\n",(long) si->si_addr, context);
 > 
 > 	   if (mprotect(si->si_addr, 4096 ,PROT_READ | PROT_WRITE) == -1)
 > 	   	handle_error("mprotect failed from the handler");
 > 	   else
 > 	   	printf("\nmprotect set the protection to RW\n");
 >  
 > #if 1
 > 	  // The intention here is to switch back to the context that signaled
 > the SIGSEGV. Unfortunately, it does not 
 > 	  // do that. Instead, it switches the context back to the handler
 > function, in a recursive call.
 >        	   swapcontext(&context_sig, (ucontext_t*)context);
 > #else
 > 	   // Manually set the context to the point previous to accessing the
 > memory. This works !
 >        	   swapcontext(&context_sig, &context_trigger);
 > #endif
 > 	}
 > 
 >        }
 > 
 >        int
 >        main(int argc, char *argv[])
 >        {
 > 	   /* Set the handler */
 >            sa_new.sa_flags = SA_SIGINFO;
 >            sigemptyset(&sa_new.sa_mask);
 >            sa_new.sa_sigaction = handler;
 >            if (sigaction(SIGSEGV, &sa_new, &sa_old) == -1)
 >                handle_error("sigaction");
 > 
 > 
 >            /* Allocate 4096 bytes with initial protection PROT_NONE */
 > 
 >            char* p = (char*)mmap(0,4096,PROT_NONE, MAP_ANONYMOUS |
 > MAP_PRIVATE, -1, 0);
 >            if (p ==  MAP_FAILED)
 >                handle_error("mmap");
 > 
 > 	   getcontext(&context_trigger);
 > 	   
 > 	   /* Access the protected memory, which will raise a SIGSEGV or SIGBUS
 > */
 >            *(p) = 'a';
 >                
 >            printf("\nSuccess\n");    
 >            exit(EXIT_SUCCESS);
 >        }
 > 
 > 
 > Any help/pointer would be greatly appreciated.

Your're doing this all wrong.

An SA_SIGINFO signal handler gets a pointer to the faulting context
in its third parameter. To modify it you assign fields in it, e.g.
the program counter. Then you return from the signal handler. Upon
return the kernel reloads this possibly modified context.

If you don't modify it the faulting instruction will usually be
rexecuted (though x87 fp exceptions are delayed so the original
faulting instruction will be skipped). In your simple example all
you need to do is to mprotect the page and return without changing
the context.

Last time I checked getcontext/swapcontext weren't system calls,
so what they do is up to whetever libc your code is linked to.

For examples of FP signal handlers look in the runtime system of
the Erlang/OTP system, and I'm sure lots of garbage collectors and
distributed shared memory systems out there use sigsegv handlers.

Finally, a distro specific problem should be taken up with that
distro.

/Mikael
( mikpe at acumem dot com )
