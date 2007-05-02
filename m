Return-Path: <linux-kernel-owner+w=401wt.eu-S2992813AbXEBHwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992813AbXEBHwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992855AbXEBHwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:52:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992813AbXEBHwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:52:03 -0400
Date: Wed, 2 May 2007 00:51:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dan Kruchinin" <dubalom@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andi Kleen <ak@suse.de>, William Irwin <bill.irwin@oracle.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC BUG?] dereference PAGE_OFFSET address (rc7-mm2)
Message-Id: <20070502005140.b94500ff.akpm@linux-foundation.org>
In-Reply-To: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com>
References: <a8f16e2b0705012026u6078f90dsbe55f854d8638795@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 07:26:13 +0400 "Dan Kruchinin" <dubalom@gmail.com> wrote:

> Hi.
> 
> I don't know why, but when I'm dereferencing PAGE_OFFSET(0xC0000000 on
> x86) address from user space on rc7-mm2 I don't receive SIGSEGV signal
> and there is no any core dump.
> btw: on poor rc-7 all is ok.
> 
> test_code:
> ---
> #include <stdio.h>
> #include <stdlib.h>
> #include <errno.h>
> #include <unistd.h>
> #include <sys/wait.h>
> #include <sys/time.h>
> #include <sys/resource.h>
> #include <sys/types.h>
> 
> #define PAGE_OFFSET 0xC0000000
> 
> static void _error(const char *msg)
> {
>   int errcode = errno;
> 
>   fprintf(stderr, "ERROR:\n--> %s [%s]\n", msg, strerror(errcode));
>   exit(EXIT_FAILURE);
> }
> 
> int main(void)
> {
>   int pid;
>   struct rlimit rl;
>   int status;
> 
>   printf("Trying to cause ELF core dump...\n");
> 
>   rl.rlim_cur = rl.rlim_max = 0x10000000;
> 
>   if(setrlimit(RLIMIT_CORE, &rl) < 0)
> 	_error("setrlim error!");
>   if((pid = fork()) < 0)
> 	_error("fork error!");
>   else if(pid == 0) {
> 	*((long*) PAGE_OFFSET ) = 0; /* trying to dereference kernel start address */
> 	_exit(EXIT_SUCCESS);
>   }
> 
>   if(waitpid(pid, &status, 0) < 0)
> 	_error("waitpid error!");
>   if(WCOREDUMP(status))
> 	printf("All is ok. We receive SIGSEGV and core dump has occured.\n");
>   else
> 	printf("All is bad. We don't receive SIGSEGV and core dump hasn't
> occured. (WHY?!)\n"); /* here I just get SIGCHLD, this means that
> child process have made it's work success... */
> 
>   exit(EXIT_SUCCESS);
> }
> ---
> 
> [asgard@midgard]$ uname -a
> Linux midgard 2.6.21-rc7-mm2 #5 SMP Wed May 2 04:15:09 MSD 2007 i686 GNU/Linux
> 
> [asgard@midgard]$ ./a.out
> Trying to cause ELF core dump...
> All is bad. We don't receive SIGSEGV and core dump hasn't occured. (WHY?!)
> 
> ---
> 
> [asgard@midgard]$ uname -a
> Linux midgard 2.6.21-rc7 #5 SMP Wed May 2 02:11:50 MSD 2007 i686 GNU/Linux
> 
> [asgard@midgard]$ ./a.out
> Trying to cause ELF core dump...
> All is ok. We receive SIGSEGV and core dump has occured.
> 

Thanks for the report.  I can reproduce it.

Bisection shows that x86_64-mm-paravirt-initial-pagetable.patch caused
this.

I didn't check whether the patch actually permits us to read kernel
memory.  Probably it does.  Probably we'd prefer that it didn't ;)




