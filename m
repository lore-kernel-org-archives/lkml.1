Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYG2Jum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYG2Jum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbYG2JuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:50:07 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56558 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbYG2JuE (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:50:04 -0400
Date: Tue, 29 Jul 2008 19:50:02 +1000
From: Simon Horman <horms@verge.net.au>
To: Linux-kernel <Linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Mike Travis <travis@sgi.com>
Subject: Re: Regression on ia64 with cpu masks: optimize and clean up
	cpumask_of_cpu()
Message-ID: <20080729095001.GA509@verge.net.au>
References: <20080729034459.GA11699@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729034459.GA11699@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 01:45:01PM +1000, Simon Horman wrote:
> Hi,
> 
> I haven't had a time to look into this closeley yet,
> but "cpu masks: optimize and clean up cpumask_of_cpu()"
> aka e56b3bc7942982ac2589c942fb345e38bc7a341a causes
> a build failure for me on ia64.
> 
> # ia64-unknown-linux-gnu-gcc --version
> ia64-unknown-linux-gnu-gcc (GCC) 3.4.5
> Copyright (C) 2004 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> # make
> make[1]: `include/asm-ia64/nr-irqs.h' is up to date.
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      drivers/acpi/processor_throttling.o
> drivers/acpi/processor_throttling.c: In function `acpi_processor_get_throttling':
> drivers/acpi/processor_throttling.c:841: error: invalid lvalue in unary `&'
> drivers/acpi/processor_throttling.c: In function `acpi_processor_set_throttling':
> drivers/acpi/processor_throttling.c:1028: error: invalid lvalue in unary `&'
> drivers/acpi/processor_throttling.c:1059: error: invalid lvalue in unary `&'
> make[2]: *** [drivers/acpi/processor_throttling.o] Error 1
> make[1]: *** [drivers/acpi] Error 2
> make: *** [drivers] Error 2

I'm pretty sure that I am missing something subtle here,
but something that is working for me is:

Index: linux-2.6/include/linux/cpumask.h
===================================================================
--- linux-2.6.orig/include/linux/cpumask.h	2008-07-29 19:03:06.000000000 +1000
+++ linux-2.6/include/linux/cpumask.h	2008-07-29 19:03:16.000000000 +1000
@@ -287,7 +287,7 @@ static inline const cpumask_t *get_cpu_m
  * gcc optimizes it out (it's a constant) and there's no huge stack
  * variable created:
  */
-#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })
+#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
 
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)

