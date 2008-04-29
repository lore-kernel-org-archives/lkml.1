Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYD2Bqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYD2Bqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYD2Bq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:46:28 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:55543 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbYD2Bq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:46:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEAHoaFkhMROPA/2dsb2JhbACBU6os
Date: Mon, 28 Apr 2008 21:46:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080429014623.GA6284@Krystal>
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48165866.5060403@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:30:53 up 59 days, 20:41,  4 users,  load average: 0.72, 0.87,
	0.89
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Ingo Molnar wrote:
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>> What I'm proposing is:
>>>
>>>>   [ .... fastpath head ......     ]
>>>>   [ ....   5-byte CALL .......... ]  ---> NOP-ed out
>>>>   [ .... fastpath tail .......... ]
>>>>   [ ............................. ]
>>> The call site is created with an asm() statement as opposed to a gcc 
>>> function call; it is up to the logging function to take the state and 
>>> mangle it into whatever format it wants to; the debugging information 
>>> (e.g. DWARF) should tell it all it needs to know about how the 
>>> register/memory state maps onto the C state.  This mapping can either be 
>>> done online, with a small piece of dynamic code, or offline (although 
>>> offline makes it tricky to know what memory tems to gather.)
>> that would be rather impractical as we'd force DEBUG_INFO builds on anyone 
>> (it's HUGE) just to do some trivial tracing. Look at the ftrace plugin 
>> usage model - it wants to be widely available and easy to use.
>
> Otherwise you're forcing everyone to take the cost of additional cache 
> footprint, plus optimizer interference, just because they might want to 
> possibly do some trivial tracing.  DEBUG_INFO is The Right Thing for this, 
> as it carries all the information you may want in a well-defined format.  
> You don't necessarily have to keep all this information around, of course; 
> you can distill out the information for the trace sites at compile time and 
> keep a tracer information file, after which you can strip the information.
>
> There is actually yet another alternative, though, which is to build the 
> tracer at compile time.  The tricky part of this is that it almost requires 
> inserting a preprocessor before the assembler, and use really ugly asm() 
> macros to extract the very information that the debug format is designed 
> explicitly to extract!
>
> Personally, I think requiring DEBUG_INFO is a helluva lot less ugly than 
> these branch hacks.
>
> 	-hpa

Peter, do you have something like the following code in mind ?

I think the main differences between the code snippet down here and the
markers is that markers rely on the compiler to generate the stack
setup, and have this code a little bit closer to the function than what
I propose here, where I put the stack setup code in a "farfaraway"
section.  Moreover, markers are much simpler than what I show here.
And actually, markers can be deployed portably, with
architecture-specific optimizations refined later. This has to be
implemented all up front for any traced architecture. In addition,
dealing with weird types like unsigned long long can become a pain.
Also, due to fact that we are asking the compiler to put keep some
variables live in registers, I would be tempted to embed this in a block
controlled by an if() statement (conditional branch, like I use for the
markers) so we don't have to pay the penality of populating the
registers when not required if there are not live at the marker site.

Here is the toy program :

#include <stdio.h>

#define SAVE_REGS   \
	"pushl %%eax\n\t" \
	"pushl %%ebp\n\t" \
	"pushl %%edi\n\t" \
	"pushl %%esi\n\t" \
	"pushl %%edx\n\t" \
	"pushl %%ecx\n\t" \
	"pushl %%ebx\n\t"

#define RESTORE_REGS \
	"popl %%ebx\n\t"	\
	"popl %%ecx\n\t"	\
	"popl %%edx\n\t"	\
	"popl %%esi\n\t"	\
	"popl %%edi\n\t"	\
	"popl %%ebp\n\t"	\
	"popl %%eax\n\t"

#define asmlinkage __attribute__((regparm(0)))
#define _ASM_PTR ".long "

struct marker_info {
	const char *name;
	const char *fields;
	unsigned char nr_args;
	unsigned char type_sizes[];
};

#define trace_mark3(name, fields, arg1, arg2, arg3)			\
	do {								\
		static struct marker_info info = {			\
			#name,						\
			fields,						\
			3, { sizeof(arg1), sizeof(arg2), sizeof(arg3) } }; \
		asm (".section __marker_info, \"a\",@progbits\n\t"	\
			_ASM_PTR "%c0, 1f, 2f\n\t"			\
			".previous\n\t"					\
			".section __farfarawaycode,\"ax\",@progbits\n\t"\
			"1:\n\t"					\
			SAVE_REGS	/* Save caller-saved registers */\
			"pushl %3\n\t"					\
			"pushl %2\n\t"					\
			"pushl %1\n\t"					\
			"pushl %0\n\t"					\
			"call do_kernel_trace\n\t"			\
			"addl $(4*(1+3)), %%esp\n\t"			\
			RESTORE_REGS					\
			"ret\n\t"					\
			".previous\n\t"					\
			"2:\n\t"					\
			"call 1b\n\t"	/* TEST */			\
			".byte 0xe9\n\t"/* jmp near 0x0 (5-bytes 1 insn nop) */\
			".int 0x0\n\t"	/* patched to "call ...\n\t" */	\
			: : "i" (&info),				\
			"g" (arg1), "g" (arg2), "g" (arg3));		\
	} while (0)

/*
 * Patching address "2f" with a call 1f. All the information required is in 
 * the __marker_info section/table.
 */

asmlinkage void do_kernel_trace(const struct marker_info *info,
	 unsigned long arg1, unsigned long arg2, unsigned long arg3)
{
	unsigned long *args = &arg1;
	int i;
	printf("%s \n", info->name);
	for (i = 0; i < info->nr_args; i++) {
		switch (info->type_sizes[i]) {
		case 1:
			printf("%hu ", (unsigned char)args[i]);
			break;
		case 2:
			printf("%hu ", (unsigned short)args[i]);
			break;
		case 4:
			printf("%u ", (unsigned int)args[i]);
			break;
		case 8:
			printf("%llu ", (unsigned long long)args[i]);
			break;
		}
	}
	printf("\n");
}

unsigned long long gg = -1ULL;  /* this guy does not work. No warning
                                   generated. */

void f(void)
{
	char y = 4;
	trace_mark3(test_event, "name1 name2 name3", y, gg, 6);
}

void main()
{
	f();
}


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
