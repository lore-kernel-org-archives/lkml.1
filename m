Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbZGPQ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbZGPQ3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 12:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932720AbZGPQ3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 12:29:52 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56247 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbZGPQ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 12:29:51 -0400
Date: Thu, 16 Jul 2009 18:29:47 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andi Kleen <ak@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip -v12 02/11] x86: x86 instruction decoder
	build-time selftest
Message-ID: <20090716162947.GA5804@merkur.ravnborg.org>
Mail-Followup-To: Masami Hiramatsu <mhiramat@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	lkml <linux-kernel@vger.kernel.org>,
	systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
	DLE <dle-develop@lists.sourceforge.net>,
	Jim Keniston <jkenisto@us.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Avi Kivity <avi@redhat.com>,
	Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>
References: <20090716155652.6266.39970.stgit@localhost.localdomain> <20090716155706.6266.79022.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716155706.6266.79022.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 11:57:06AM -0400, Masami Hiramatsu wrote:
> Add a user-space selftest of x86 instruction decoder at kernel build time.
> When CONFIG_X86_DECODER_SELFTEST=y, Kbuild builds a test harness of x86
> instruction decoder and performs it after building vmlinux.
> The test compares the results of objdump and x86 instruction decoder
> code and check there are no differences.

Long overdue review from my side...

>  arch/x86/scripts/Makefile       |   19 +++++++
>  arch/x86/scripts/distill.awk    |   42 +++++++++++++++++
>  arch/x86/scripts/test_get_len.c |   99 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/scripts/user_include.h |   49 +++++++++++++++++++

Hmmm, we have two architectures that uses scripts/ and three that
uses tools/.
I prefer the latter name as what we have ere is beyound what
I generally recognize as a script.

we have scripts/ in top-level and we do not rename this
as we have this hardcoded too many places - but no reason to
use the wrong name here.

> diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
> index 01e079a..9090665 100644
> --- a/arch/x86/include/asm/inat.h
> +++ b/arch/x86/include/asm/inat.h
> @@ -20,7 +20,9 @@
>   * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
>   *
>   */
> +#ifdef __KERNEL__
>  #include <linux/types.h>
> +#endif
>  
>  /* Instruction attributes */
>  typedef u32 insn_attr_t;

Why this?
If you need this to use this file from userspace then could we do some
other trick to make this OK?

I see it repeated several times below.
[If this has already been discussed I have missed it - sorry].


> diff --git a/arch/x86/scripts/Makefile b/arch/x86/scripts/Makefile
> new file mode 100644
> index 0000000..f08859e
> --- /dev/null
> +++ b/arch/x86/scripts/Makefile
> @@ -0,0 +1,19 @@
> +PHONY += posttest
> +quiet_cmd_posttest = TEST    $@
> +      cmd_posttest = objdump -d $(objtree)/vmlinux | awk -f $(srctree)/arch/x86/scripts/distill.awk | $(obj)/test_get_len
> +

You are using the native objdump here.
But I assume this fails miserably when you build x86 on a powerpc host.
In other words - you broke an allyesconfig build for -next...
We have $(OBJDUMP) for this.

> +posttest: $(obj)/test_get_len vmlinux
> +	$(call cmd,posttest)
> +
> +test_get_len_SRC = $(srctree)/arch/x86/scripts/test_get_len.c $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c
> +test_get_len_INC = $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
> +
> +quiet_cmd_test_get_len = CC      $@
> +      cmd_test_get_len = $(CC) -Wall $(test_get_len_SRC) -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include -include $(srctree)/arch/x86/scripts/user_include.h -o $@

Is there a specific reason why you cannot use the standard hostprogs-y for this?
It will take care of dependency tracking etc.
What you have above is a hopeless incomplete list of dependencies.

You need to use HOST_EXTRACFLAGS to set additional -I options and the -include.

> +
> +static void usage()
> +{
> +	fprintf(stderr, "usage: %s < distilled_disassembly\n", prog);
> +	exit(1);
> +}

It would be nice to tell the user what the program is supposed to do.
I know this is a bit unusual but no reason to copy bad practice.

> index 0000000..3bdcc55
> --- /dev/null
> +++ b/arch/x86/scripts/user_include.h
> @@ -0,0 +1,49 @@
> +#ifndef __USER_TYPES_H
> +#define __USER_TYPES_H
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2009
> + */
> +
> +#include <string.h>
> +
> +#ifdef __x86_64__
> +#define CONFIG_X86_64
> +#else
> +#define CONFIG_X86_32
> +#endif
> +typedef unsigned char u8;
> +typedef unsigned short u16;
> +typedef unsigned int u32;
> +typedef unsigned long long u64;
> +
> +typedef signed char s8;
> +typedef short s16;
> +typedef int s32;
> +typedef long long s64;
> +
> +typedef enum bool { false = 0, true } bool;
> +
> +/* any harmless file-scope decl */
> +#define NOP_DECL struct __nop
> +#define EXPORT_SYMBOL_GPL(symbol) NOP_DECL
> +#define MODULE_LICENSE(gpl) NOP_DECL
> +
> +#define WARN_ON(cond) do { } while (0)
> +#define unlikely(cond) (cond)
> +

So this is a file that alows you to include the other files without dragging in
a massive amount a stuff.
Would be nice if you wrote so in the file so it is explicit.


I tried to look at inat.h to see why all this was needed but tht
file is not present in my tree - neither in -tip?

	Sam
