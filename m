Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYHGSrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYHGSrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbYHGSrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:47:45 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:34170 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYHGSrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:47:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAP7cmkhMRKxB/2dsb2JhbACBWatc
Date: Thu, 7 Aug 2008 14:47:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Message-ID: <20080807184741.GB18164@Krystal>
References: <20080807182013.984175558@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080807182013.984175558@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:32:08 up 63 days, 23:13,  7 users,  load average: 5.65, 2.69,
	1.72
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> One of the things that bothered me about the latest ftrace code was
> this annoying daemon that would wake up once a second to see if it
> had work to do. If it did not, it would go to sleep, otherwise it would
> do its work and then go to sleep.
> 
> You see, the reason for this is that for ftrace to maintain performance
> when configured in but disabled, it would need to change all the
> locations that called "mcount" (enabled with the gcc -pg option) into
> nops.  The "-pg" option in gcc sets up a function profiler to call this
> function called "mcount". If you simply have "mcount" return, it will
> still add 15 to 18% overhead in performance. Changing all the calls to
> nops moved the overhead into noise.
> 
> To get rid of this, I had the mcount code record the location that called
> it. Later, the "ftraced" daemon would wake up and look to see if
> any new functions were recorded. If so, it would call kstop_machine
> and convert the calls to "nops". We needed kstop_machine because bad
> things happen on SMP if you modify code that happens to be in the
> instruction cache of another CPU.
> 
> This "ftraced" kernel thread would be a happy little worker, but it caused
> some pains. One, is that it woke up once a second, and Ted Tso got mad
> at me because it would show up on PowerTop. I could easily make the
> default 5 seconds, and even have it runtime configurable, with a trivial
> patch. I have not got around to doing that yet.
> 
> The other annoying thing, and this one bothers me the most, is that we
> can not have this enabled on a production -rt kernel.  The latency caused
> by the kstop_machine when doing work is lost in the noise on a non-rt
> kernel, but it can be up to 800 microseconds, and that would kill
> the -rt kernel.  The reason this bothered me the most, is that -rt is
> where it came from, and ftraced was not treating its motherland very well.
> 

Hi Steven,

If you really want to stop using stop_machine, I think you should have a
look at my immediate values infrastructure :

see:
http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=blob;f=arch/x86/kernel/immediate.c;h=0958c02b49eed3bbc00bdc5aceeee17a6d0c7ab4;hb=HEAD

particularly replace_instruction_safe(), which uses a temporary
breakpoint to safely replace an instruction on a live SMP system without
using stop_machine. Feel free to try it in ftrace. :)

You may need to tweak the imv_notifier(), which is responsible for
executing the breakpoint. The only special thing this handler has to
know is the non-relocatable instructions you might want to insert (it
only cares about the new instructions, not the old ones being replaced).
The current code deals with 5-bytes jumps. Note that the instruction is
executed in the breakpoint handler with preemption disabled, which might
not be well suited for a call instruction.

I would recommend to patch in a 5-bytes jmp with 0 offset
(e9 00 00 00 00) when disabled (this makes a single 5-bytes instruction
and thus makes sure no instruction pointer can iret in the middle).

When enabling the site, you could patch-in the original call, but you
should tweak the imv_notifier() so that it uses the jmp offset 0 in the
bypass instead of the function call, because preemption would otherwise
be disabled around the call when executed in the breakpoint bypass.

Therefore, simply statically forcing the bypass code to e9 00 00 00 00
in all the cases (a nop) would do the job for your needs.

Mathieu

> Along came Gregory Haskins, who was bickering about having ftrace enabled
> on a production -rt kernel. I told him the reasons that this would be bad
> and then he started thinking out loud, and suggesting wild ideas, like
> patching gcc!
> 
> Since I have recently seen "The Dark Knight", Gregory's comments put me
> into an "evil" mood.  I then thought of the idea about using the
> relocation entries of the mcount call sites, in a prelinked object file,
> and create a separate section with a list of these sites. On boot up,
> record them and change them into nops.
> 
> That's it! No kstop_machine for turning them into nops. We would only need
> stop_machine to enable or disable tracing, but a user not tracing will not have
> to deal with this annoying "ftraced" kernel thread waking up every second
> or ever running kstop_machine.
> 
> What's more, this means we can enable it on a production -rt kernel!
> 
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

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
