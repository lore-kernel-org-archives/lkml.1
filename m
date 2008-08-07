Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYHGVMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYHGVMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYHGVMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:12:09 -0400
Received: from gw.goop.org ([64.81.55.164]:53273 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbYHGVMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:12:08 -0400
Message-ID: <489B6511.7000208@goop.org>
Date: Thu, 07 Aug 2008 14:11:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
References: <20080807182013.984175558@goodmis.org>
In-Reply-To: <20080807182013.984175558@goodmis.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Now, this was no easy task. We needed to add a section to every object
> file with a list of pointers to the call sites to mcount. The idea I came
> up with was to make a tmp.s file for every object just after it is compiled.
> This tmp.s would then be compiled and relinked into the original object.
> The tmp.s file would have something like:
>
>   .section __mcount_loc,"a",@progbits
>   .quad location_of_mcount1
>   .quad location_of_mcount2
>   (etc)
>   

I have  a few concerns about this scheme:

One is that you assume that all text is in a .text section, and that the 
offsets you compute on a per-section basis are going to be valid in the 
final kernel image.  At the very least you should make each offset 
relative to its own function rather than inter-function.

But it seems pretty fragile overall.  Things like -ffunction-sections 
and section gc will invalidate the table you build up.

It seems to me that you can acheive the same effect by:

   1. link vmlinux with "ld -q", which will leave the relocation
      information intact in the final object
   2. use "readelf -r" to extract the relocation info, find the
      references to mcount and build a table
   3. link that table into the kernel image
   4. repeat to get a stable result

Note that steps 2-4 are identical to kallsyms, both in intent and 
detail.  The only difference is the precise table you build and the 
command you use to extract the info from the kernel.  From a quick peek 
at the way Makefile implements kallsyms, it looks to me like it would be 
fairly easy to generalize so that you can do the mcount reloc processing 
in the same relink passes as kallsyms with minimal overhead on the 
kernel build time.

It just seems incredibly fiddly to be doing all this per-object.

    J

> By running objdump on the object file we can find the offsets into the
> sections that the functions are called.
>
> For example, looking at hrtimer.o:
>
> Disassembly of section .text:
>
> 0000000000000000 <hrtimer_init_sleeper>:
>        0:       55                      push   %rbp
>        1:       48 89 e5                mov    %rsp,%rbp
>        4:       e8 00 00 00 00          callq  9 <hrtimer_init_sleeper+0x9>
>                         5: R_X86_64_PC32        mcount+0xfffffffffffffffc
> [...]
>
> the '5' in the '5: R_X86_64_PC32' is the offset that the mcount relocation
> is to be done for the call site. This offset is from the .text section,
> and not necessarily, from the function. If we look further we see:
>
> 000000000000001e <ktime_add_safe>:
>       1e:       55                      push   %rbp
>       1f:       48 89 e5                mov    %rsp,%rbp
>       22:       e8 00 00 00 00          callq  27 <ktime_add_safe+0x9>
>                         23: R_X86_64_PC32       mcount+0xfffffffffffffffc
>
>
> This mcount call site is 0x23 from the .text section, and obviously
> not from the ktime_add_safe.
>
> If we make a tmp.s that has the following:
>
>   .section __mcount_loc,"a",@progbits
>   .quad hrtimer_init_sleeper + 0x5
>   .quad hrtimer_init_sleeper + 0x23
>
> We have a section with the locations of these two call sites. After the final
> linking, they will point to the actual address used.
>
> All that would need to be done is:
>
> gcc -c tmp.s -o tmp.o
> ld -r tmp.o hrtimer.o -o tmp_hrtime.o
> mv tmp_hrtimer.o hrtimer.o
>
> Easy as that! Not quite.  What happens if that first function in the
> section is a static function? That is, the symbol for the function
> is local to the object. If for some reason hrtimer_init_sleeper is static,
> the tmp_hrtimer.o would have two symbols for hrtimer_init_sleeper.
> One local and one global.
>
> But we can be even more evil with this idea. We can do crazy things
> with objcopy to solve it for us.
>
>   objcopy --globalize-symbol hrtimer_init_sleeper hrtimer.o tmp_hrtimer.o
>
> Now the hrtimer_init_sleeper would be global for linking.
>
>   ld -r tmp_hrtimer.o tmp.o -o tmp2_hrtimer.o
>
> Now the tmp.o could use the same global hrtimer_init_sleeper symbol.
> But we have tmp2_hritmer.o that has the tmp.o and tmp_hrtimer.o symbols,
> but we cant just blindly convert local symbols to globals.
>
> The solution is simply put it back to local.
>
>   objcopy --localize-symbol hrtimer_init_sleeper tmp2_hrtimer.o hrtimer.o
>
> Now our hrtimer.o file has our __mcount_loc section and the
> reference to hrtimer_init_sleeper will be resolved.
>
> This is a bit complex to do in shell scripting and Makefiles, so I wrote
> a well documented recordmcount.pl perl script, that will do the above
> all in one place.
>
> With this new update, we can work to kill that kernel thread "ftraced"!
>
> This patch set ports to x86_64 and i386, the other archs will still use
> the daemon until they are converted over.
>
> I tested this on both x86_64 and i386 with and without CONFIG_RELOCATE
> set.
>
>   

