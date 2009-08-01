Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbZHAHWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbZHAHWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZHAHWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:22:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZHAHWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:22:49 -0400
Date: Sat, 1 Aug 2009 09:22:38 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Guenther <rguenther@suse.de>
Subject: Re: [PATCH] information leak in sigaltstack
Message-ID: <20090801072238.GV4462@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com> <alpine.LFD.2.01.0907311407040.24841@localhost.localdomain> <alpine.LFD.2.01.0907311428370.3304@localhost.localdomain> <4A73641C.7070404@redhat.com> <alpine.LFD.2.01.0907311716220.3304@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907311716220.3304@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 05:28:40PM -0700, Linus Torvalds wrote:
> 
> [ Cc'ing jakub, since that code generation looks crappy, and I think he 
>   has worked on gcc memset(). I wonder if it's because we use -Os, and gcc 
>   tries to avoid one REX prefix on the 'stosq'.

Assuming we are talking about:
typedef __SIZE_TYPE__ size_t;
typedef struct sigaltstack { void *ss_sp; int ss_flags; size_t ss_size; }
stack_t;
void foo (stack_t *oss, void *sp)
{
  __builtin_memset (oss, 0, sizeof (*oss));
  oss->ss_sp = sp;
  oss->ss_flags = 6;
  oss->ss_size = 2; 
}

yes, it is because of -Os, rep stosq is longer than rep stosl.  For -O2 it
generates:
        movq    $0, 8(%rdi)
        movq    %rsi, (%rdi)
        movl    $6, 8(%rdi)
        movq    $2, 16(%rdi)
which still isn't perfect, but is much better.  GCC 4.4 newly has RTL DCE
improvements, so that at least the memcpy is optimized away if the structure
is filled completely after the memset, or is able to optimize away NULL/0
assignments after a memset to 0.  At -O2 when GCC decides to do the memset
piecewise it is easier to kill dead stores from the memset (the -O2 code
perhaps could be improved by the http://gcc.gnu.org/PR22141 patch which
hasn't been committed because it didn't show visible improvements and on
power6 even degraded performance).  At -Os when GCC decides during the
expand to use arch specific pattern for the memset it would be much harder
to handle it at the RTL level.  So the above should be ideally optimized
already at the tree level.

> diff --git a/kernel/signal.c b/kernel/signal.c
> index ccf1cee..b990dc8 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2455,6 +2455,9 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
>  	int error;
>  
>  	if (uoss) {
> +		/* Fill cracks around 'ss_flags' */
> +		if (__alignof__(oss.ss_flags) != __alignof__(oss))
> +			memset(&oss, 0, sizeof(oss));
>  		oss.ss_sp = (void __user *) current->sas_ss_sp;
>  		oss.ss_size = current->sas_ss_size;
>  		oss.ss_flags = sas_ss_flags(sp);

I'd say the test you want to do is
if (sizeof (oss.ss_sp) + sizeof (oss.ss_size) + sizeof (oss.ss_flags)
    != sizeof oss)
  memset (&oss, 0, sizeof oss);
(i.e. check whether the struct has any padding in it or not).

	Jakub
