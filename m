Return-Path: <linux-kernel-owner+w=401wt.eu-S1764338AbYBMCsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764338AbYBMCsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbYBMCsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:48:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743AbYBMCsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:48:35 -0500
Date: Tue, 12 Feb 2008 18:46:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, Robert Reif <reif@earthlink.net>
Subject: Re: [patch] sparc: fix build
Message-Id: <20080212184654.85d5ae20.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.0802101529310.17892@chino.kir.corp.google.com>
References: <20080207231230.GE7198@cs181133002.pp.htv.fi>
	<alpine.DEB.1.00.0802071538440.15050@chino.kir.corp.google.com>
	<20080210153355.GA6737@palantir8>
	<alpine.DEB.1.00.0802101117510.5043@chino.kir.corp.google.com>
	<47AF7048.3060200@earthlink.net>
	<alpine.DEB.1.00.0802101529310.17892@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 15:30:51 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> Fix build failures on sparc:
> 
> 	In file included from include/linux/mm.h:39,
> 	                from include/linux/memcontrol.h:24,
> 	                from include/linux/swap.h:8,
> 	                from include/linux/suspend.h:7,
> 	                from init/do_mounts.c:6:
> 	include/asm/pgtable.h:344: warning: parameter names (without
> 		types) in function declaration
> 	include/asm/pgtable.h:345: warning: parameter names (without
> 		types) in function declaration
> 	include/asm/pgtable.h:346: error: expected '=', ',', ';', 'asm' or
> 		'__attribute__' before '___f___swp_entry'
> 
> and
> 
> 	arch/sparc/kernel/led.c: In function 'led_blink':
> 	arch/sparc/kernel/led.c:35: error: invalid use of undefined type
> 		'struct timer_list'
> 	arch/sparc/kernel/led.c:35: error: 'jiffies' undeclared (first use
> 		in this function)
> 	arch/sparc/kernel/led.c:35: error: (Each undeclared identifier is
> 		reported only once
> 	arch/sparc/kernel/led.c:35: error: for each function it appears
> 		in.)
> 	arch/sparc/kernel/led.c:36: error: 'avenrun' undeclared (first use
> 		in this function)
> 	arch/sparc/kernel/led.c:36: error: 'FSHIFT' undeclared (first use
> 		in this function)
> 	arch/sparc/kernel/led.c:36: error: 'HZ' undeclared (first use in
> 		this function)
> 	arch/sparc/kernel/led.c:37: error: invalid use of undefined type
> 		'struct timer_list'
> 	arch/sparc/kernel/led.c:39: error: invalid use of undefined type
> 		'struct timer_list'
> 	arch/sparc/kernel/led.c:40: error: invalid use of undefined type
> 		'struct timer_list'
> 	arch/sparc/kernel/led.c:42: error: implicit declaration of
> 		function 'add_timer'
> 	arch/sparc/kernel/led.c: In function 'led_write_proc':
> 	arch/sparc/kernel/led.c:70: error: implicit declaration of
> 		function 'copy_from_user'
> 	arch/sparc/kernel/led.c:84: error: implicit declaration of
> 		function 'del_timer_sync'
> 	arch/sparc/kernel/led.c: In function 'led_init':
> 	arch/sparc/kernel/led.c:109: error: implicit declaration of
> 		function 'init_timer'
> 	arch/sparc/kernel/led.c:110: error: invalid use of undefined type
> 		'struct timer_list'
> 
> ...
>
> diff --git a/arch/sparc/kernel/led.c b/arch/sparc/kernel/led.c
> --- a/arch/sparc/kernel/led.c
> +++ b/arch/sparc/kernel/led.c
> @@ -1,8 +1,9 @@
> -#include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/proc_fs.h>
>  #include <linux/string.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
>  
>  #include <asm/auxio.h>

OK, that'll fix one error.
  
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -20,9 +20,6 @@
>  #ifndef _LINUX_MEMCONTROL_H
>  #define _LINUX_MEMCONTROL_H
>  
> -#include <linux/rcupdate.h>
> -#include <linux/mm.h>
> -
>  struct mem_cgroup;
>  struct page_cgroup;
>  struct page;

This really should have been in a separate patch and extensively tested.

Have we checked that every file which directly or indirectly includes
memcontrol.h does not have an requirement for rcupdate.h and mm.h, where
that requirement was satisfied only via this nested inclusion?  For all
architectures and for all config selections?  Think not.

Sadly, removal of nested includes is a *big* deal, and it takes quite a lot
of time to get it all shaken down.

If we can confirm that all files (.c and .h) which include memcontrol.h
also directly include rcupdate.h and mm.h then we're _probably_ ok (modulo
ordering issues).

Otherwise we should perhaps be taking a second look at how to fix the sparc
problem.

