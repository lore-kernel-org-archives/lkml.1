Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYGELbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYGELbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbYGELbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:31:07 -0400
Received: from saeurebad.de ([85.214.36.134]:47181 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYGELbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:31:06 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/20] lib: generic show_mem()
References: <20080704160737.750988999@saeurebad.de>
	<20080704161452.730548249@saeurebad.de>
	<20080705083445.GA5454@osiris.boeblingen.de.ibm.com>
Date: Sat, 05 Jul 2008 11:29:29 +0000
In-Reply-To: <20080705083445.GA5454@osiris.boeblingen.de.ibm.com> (Heiko
	Carstens's message of "Sat, 5 Jul 2008 10:34:45 +0200")
Message-ID: <87hcb44lie.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Heiko Carstens <heiko.carstens@de.ibm.com> writes:

> On Fri, Jul 04, 2008 at 06:07:39PM +0200, Johannes Weiner wrote:
>> This implements a platform-independent version of show_mem().
>> 
>> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>> ---
>>  lib/Makefile   |    2 -
>>  lib/show_mem.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 64 insertions(+), 1 deletion(-)
>> 
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -6,7 +6,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
>>  	 rbtree.o radix-tree.o dump_stack.o \
>>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
>> -	 proportions.o prio_heap.o ratelimit.o
>> +	 proportions.o prio_heap.o ratelimit.o show_mem.o
>> 
>>  ifdef CONFIG_FTRACE
>>  # Do not profile string.o, since it may be used in early boot or vdso
>> --- /dev/null
>> +++ b/lib/show_mem.c
>> @@ -0,0 +1,63 @@
>> +/*
>> + * Generic show_mem() implementation
>> + *
>> + * Copyright (C) 2008 Johannes Weiner <hannes@saeurebad.de>
>> + * All code subject to the GPL version 2.
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <linux/nmi.h>
>> +#include <linux/quicklist.h>
>> +
>> +void show_mem(void)
>> +{
>
> Umh.. I think your 4th patch set was the way to go. This set is not
> bisectable anymore and those architectures which you didn't convert
> to the generic implementation won't build anymore. show_mem is present
> twice there...

hannes@skyscraper:/tmp/test$ gcc -o prog prog.c lib1.a lib2.a && ./prog
lib1
hannes@skyscraper:/tmp/test$ gcc -o prog prog.c lib2.a lib1.a && ./prog
lib2

Both lib1 and lib2 define foo() which prog calls.

I tested this with x86 and it built before and after removal of the
x86-specific show_mem() (and it did the right thing as the arch code has
higher priority than lib code).

But why is it no more bisectable?  You have one point where your kernel
uses the arch-specific show_mem() and in the next commit, you use the
generic version.  If something breaks, you can compare the old arch
version with the generic version.

> You might solve this by adding an __attribute__((weak)) but I'm sure
> people will complain again, because it produces dead code for all
> architectures which got converted.

Yeah, lib/show_mem.c is built in any case, which sucks a bit.

What do others think?  Would you prefer conditional code generation
about linking magic here?

	Hannes
