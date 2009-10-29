Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZJ2Q4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZJ2Q4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbZJ2Q4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbZJ2Q4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:56:36 -0400
Message-ID: <4AE9C919.4070003@redhat.com>
Date: Thu, 29 Oct 2009 12:55:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9r?= =?ISO-8859-1?Q?ic_Weisbecker?= 
	<fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu>
In-Reply-To: <20091029085348.GD26970@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>
> * Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>
>> Hi Ingo,
>>
>> Here are bugfixes and some enhances of x86-insn decoder and perf-probe.
>>   - x86 insn decoder supports AVX and FMA.
>>   - perf-probe syntax change.
>>   - perf-probe supports function-relative line number.
>>   - minor bugfixes.
>>
>> New perf-probe syntax is below:
>>
>>    perf probe 'PROBE'
>>
>>   or
>>
>>    perf probe --add 'PROBE'
>>
>>   where, PROBE is
>>
>>    <source>:<line-number>
>>
>>   or
>>
>>    <function>[:<rel-lineno>|+<byte-offset>|%return][@<source>]
>>
>>   e.g.
>>
>>    perf probe 'schedule:10@kernel/sched.c'
>>
>>    puts a probe at 10th line from entry line of schedule() function
>>    in kernel/sched.c." and
>>
>>    perf probe 'vmalloc%return'
>>
>>    puts a return probe at the returning of vmalloc.
>>
>> TODO:
>>   - Support --line option to show which lines user can probe.
>>   - Support lazy string matching.
>
> Ok, i like these fixes and improvements - thanks Masami!

Thanks!

> One detail i noticed is that we are still not very smart about finding
> our vmlinux file. I booted the kernel on a box and it gave:
>
>   aldebaran:~/linux/linux>  perf probe schedule
>     Fatal: vmlinux/module file open
>   aldebaran:~/linux/linux>  ls -l vmlinux
>   -rwxrwxr-x 1 mingo mingo 21589717 2009-10-29 09:04 vmlinux
>
> Firstly, it should print something more meaningful, such as:
>
>   aldebaran:~/linux/linux>  perf probe schedule
>     Fatal: Could not open vmlinux/module file

Oops, yes, it should be. since previously I used perror() for error message,
all die() messages in perf probe should be changed to show actual error message.

> Secondly, we should look beyond these places:
>
> 25806 open("/lib/modules/2.6.32-rc5-tip-01760-g2c4b5e0-dirty/build/vmlinux", O_RDONLY) = -1 ENOENT (No such file or directory)
> 25806 open("/usr/lib/debug/lib/modules/2.6.32-rc5-tip-01760-g2c4b5e0-dirty/vmlinux", O_RDONLY) = -1 ENOENT (No such file or directory)
> 25806 open("/boot/vmlinux-debug-2.6.32-rc5-tip-01760-g2c4b5e0-dirty", O_RDONLY) = -1 ENOENT (No such file or directory)
> 25806 write(2, "  Fatal: vmlinux/module file open"..., 34) = 34
> 25806 exit_group(128)                   = ?
>
> and look into the current directory as well.

I think that perf-probe has -k option for that purpose, doesn't it? :-)
Did you move your vmlinux from build dir to current dir?
I assume people usually just installs kernel and runs perf tools,
and they might not tend to copy vmlinux to current dir, just IMHO.
But anyway, if other perf commands already search vmlinux in current
dir, I'm OK for adding it on the list.

> Thirdly, i think we should expose the build-id of the kernel and the
> path to the vmlinux (and modules) via /proc/build-id or so. That way
> tooling can find the vmlinux file and can validate that it matches the
> kernel's signature. (maybe include a file date as well - that's a faster
> check than a full build-id checksum, especially for large kernels)

That's a good idea!
I think we can expose build-id via /sys/modules/*/build-id.


> Another problem i noticed is that a vmlinux without DEBUG_INFO will fail
> in this way:
>
>   aldebaran:~/linux/linux>  perf probe schedule
>     Fatal: Failed to call dwarf_init(). Maybe, not a dwarf file.

Ah, really? I think I broke need_dwarf logic somehow...

> this is not meaningful to a user. A more usable message would be:
>
>   aldebaran:~/linux/linux>  perf probe schedule
>     Fatal: Have not found dwarf info in the vmlinux - please rebuild with CONFIG_DEBUG_INFO

Sure.

>
> but ... we should really not force DEBUG_INFO for a simple probe that is
> based on an ELF symbol. We already parse ELF symbols so 'perf probe
> schedule' should be able to figure out where to put the probe point.

Agreed, I'll figure out how perf-probe can use ELF symbols too.

> Not forcing debuginfo for simple usecases is extremely important for
> usability.

Yeah, it should not.

>
> And once i had these fixed, i got:
>
>   aldebaran:~/linux/linux>  perf probe schedule
>     Fatal: kprobe_events open
>
> Which is not a meaningful error message either. This error occured due
> to CONFIG_KPROBE_TRACER not being enabled.
>
> What we want here is two fold:
>
>   - enable kprobes event support when perf events is enabled and kprobes
>     is enabled. We dont want another config option for it.

Sure, at least that combination should enable kprobe-tracer forcibly.

>   - and we need to improve error messages so that users can figure out
>     what is the problem.

Sure.

> Once i had this third roadblock out of the way i noticed that the _real_
> reason for the error was that i was not root and had no privilege to
> insert a kprobe.
>
> Once root, the probe worked well:
>
>   # perf probe schedule
>   Adding new event: p:perfprobe/schedule_0 schedule+0
>
> And it seems to be precise:
>
> aldebaran:/home/mingo>  perf stat -e perfprobe:__switch_to_0 -e cs -a ./hackbench 1
> Time: 0.018
>
>   Performance counter stats for './hackbench 1':
>
>             7358  perfprobe:__switch_to_0  #      0.000 M/sec
>             7364  context-switches         #      0.000 M/sec
>
>      0.119152919  seconds time elapsed
>
> (The difference of 6 context-switches should be investigated i suspect.)

Maybe, because of enabling/disabling timings difference.

> Btw., very small nit, it would be better to put that sentence into past
> tense:
>
>   # perf probe schedule
>   Added new event: p:perfprobe/schedule_0 schedule+0
>
> To make sure the user knows that the action has been pursued already.

OK.

> I'd expect the typical user give up much sooner than i did so we really
> need to address these usability details - emit useful error messages and
> be more successful in getting the user what he wants.
>
> But the basic UI is already pretty promising!
>
> A few further (and very small) UI tweaks i'd suggest:
>
> Firstly, could we please make the first probe inserted named plain after
> the symbol it specifies, with no _0 postfix? I.e. instead of:
>
>             7358  perfprobe:__switch_to_0  #      0.000 M/sec
>
> we'd get:
>
>             7358  perfprobe:__switch_to    #      0.000 M/sec
>
> Subsequent probes for the same symbol can be named _1, _2 - but the
> first symbol should not have this needless post-fix.

Ah, this prefix means the offset from the symbol. Of course we can
remove it if the offset == 0. Or, would you think make the postfix
sequence number of probes on the same symbol?


> Secondly, i think we should remove the 'perf' bit from the probe name.
> I.e. instead of:
>
>             7358  perfprobe:__switch_to    #      0.000 M/sec
>
> we should do:
>
>             7358  probe:__switch_to        #      0.000 M/sec
>
> as that's really what the user cares about. The user already knows that
> we are in perf - no need to repeat that in every event specification.

Yeah, that's fine to me.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

