Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678Ab0AYDhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab0AYDhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 22:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800Ab0AYDhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 22:37:41 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37532 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0AYDhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 22:37:41 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mark Seaborn <mrs@mythic-beasts.com>
Subject: Re: futex() on vdso makes process unkillable
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <20100124.000458.506212773266927716.mrs@deli>
References: <20100124.000458.506212773266927716.mrs@deli>
Message-Id: <20100125120459.4944.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 25 Jan 2010 12:37:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC to futex folks.

> I was experimenting with futexes and was a little surprised to
> discover that futex() works on read-only pages.  This creates quite a
> high bandwidth side channel that allows two processes to communicate
> if, for example, they share a library.  (Mind you, this is not much
> different from file locks, which also work on read-only file
> descriptors.)
> 
> I also found a couple of differences between 2.6.24 (from Ubuntu
> hardy) and 2.6.31 (from Ubuntu karmic).  The first is a definite bug
> in 2.6.31:
> 
> 
> 1) On 2.6.31 i686, using futex() on the vdso causes the process to get
> stuck, consuming CPU in an unkillable state.  Both FUTEX_WAIT and
> FUTEX_WAKE cause the problem.  The problem doesn't occur on 2.6.24.
> (BTW, I was testing to see whether futex() on the vdso allows any two
> processes to communicate.  This appears not to be the case on 2.6.24.)
> 
> A test program is below.
> 
> 
> 2) Suppose a file is mapped into two processes with MAP_PRIVATE.  Can
> the resulting mappings be used to communicate via futex()?  i.e. Does
> futex() consider the mappings to be the same?
> 
> On 2.6.24, the futex wakeup is not transferred; pages must be mapped
> with MAP_SHARED for futex to work.  On 2.6.31, the futex wakeup *is*
> transferred; futex works with either MAP_SHARED or MAP_PRIVATE.
> 
> 2.6.24's behaviour seems more correct, because the mappings are
> logically different, even if the underlying memory pages are the same
> before copy-on-write is triggered.  Is 2.6.31's behaviour a
> regression, or is the kernel's behaviour here supposed to be
> undefined?
> 
> Cheers,
> Mark
> 
> 
> /* Test futex() on the vdso, which the kernel maps on process startup. */
> 
> #include <stdio.h>
> #include <stdlib.h>
> 
> #include <elf.h>
> #include <linux/futex.h>
> #include <sys/syscall.h>
> #include <unistd.h>
> 
> 
> #if __WORDSIZE == 32
> #  define Elf(name) Elf32_##name
> #elif __WORDSIZE == 64
> #  define Elf(name) Elf64_##name
> #endif
> 
> void *find_vdso(char **argv)
> {
>   /* Find auxv. */
>   char **p = argv;
>   /* Skip past argv. */
>   while(*p)
>     p++;
>   p++;
>   /* Skip past env. */
>   while(*p)
>     p++;
>   p++;
>   Elf(auxv_t) *auxv = (void *) p;
>   for(; auxv->a_type; auxv++)
>     if(auxv->a_type == AT_SYSINFO_EHDR)
>       return (void *) auxv->a_un.a_val;
>   fprintf(stderr, "vdso not found\n");
>   exit(1);
> }
> 
> int main(int argc, char **argv)
> {
>   int *vdso = find_vdso(argv);
>   fprintf(stderr, "vdso found at %p\n", vdso);
>   if(syscall(__NR_futex, vdso, FUTEX_WAKE, 1) < 0)
>     perror("futex/WAKE");
>   if(syscall(__NR_futex, vdso, FUTEX_WAIT, *vdso, NULL) < 0)
>     perror("futex/WAIT");
>   return 0;
> }

This test with function tracer output following.

           a.out-11459 [000] 242281.165505: get_user_pages_fast <-get_futex_key
           a.out-11459 [000] 242281.165505: gup_pud_range <-get_user_pages_fast
           a.out-11459 [000] 242281.165506: gup_pte_range <-gup_pud_range
           a.out-11459 [000] 242281.165506: __might_sleep <-get_futex_key
           a.out-11459 [000] 242281.165507: unlock_page <-get_futex_key
           a.out-11459 [000] 242281.165507: page_waitqueue <-unlock_page
           a.out-11459 [000] 242281.165508: __wake_up_bit <-unlock_page
           a.out-11459 [000] 242281.165508: put_page <-get_futex_key
           a.out-11459 [000] 242281.165508: get_user_pages_fast <-get_futex_key
           a.out-11459 [000] 242281.165509: gup_pud_range <-get_user_pages_fast
           a.out-11459 [000] 242281.165509: gup_pte_range <-gup_pud_range
           a.out-11459 [000] 242281.165510: __might_sleep <-get_futex_key
           a.out-11459 [000] 242281.165511: unlock_page <-get_futex_key
           a.out-11459 [000] 242281.165511: page_waitqueue <-unlock_page
           a.out-11459 [000] 242281.165512: __wake_up_bit <-unlock_page
           a.out-11459 [000] 242281.165512: put_page <-get_futex_key
           a.out-11459 [000] 242281.165513: get_user_pages_fast <-get_futex_key
           a.out-11459 [000] 242281.165513: gup_pud_range <-get_user_pages_fast
           a.out-11459 [000] 242281.165514: gup_pte_range <-gup_pud_range
           a.out-11459 [000] 242281.165515: __might_sleep <-get_futex_key
           a.out-11459 [000] 242281.165515: unlock_page <-get_futex_key
           a.out-11459 [000] 242281.165516: page_waitqueue <-unlock_page
           a.out-11459 [000] 242281.165516: __wake_up_bit <-unlock_page
           a.out-11459 [000] 242281.165517: put_page <-get_futex_key

It mean the following code of get_futex_key() makes infinite loop.


	again:
	        err = get_user_pages_fast(address, 1, 1, &page);
	        if (err < 0)
	                return err;

	        page = compound_head(page);
	        lock_page(page);
	        if (!page->mapping) {
	                unlock_page(page);
	                put_page(page);
	                goto again;
	        }




