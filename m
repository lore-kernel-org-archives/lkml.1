Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbZKXCJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbZKXCJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 21:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbZKXCJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 21:09:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57390 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbZKXCJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 21:09:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R4WN3lFyLmkLP0C6r+AOeewWXt7EFrWJpiGt0bVTnXx7WO3hJ2wsQ2WDWKelWW5LzI
         j8MP+0I8Oqa5aMh8lz7VWnOzDcB729Q2YV7YeX9ZXaMnSb3sIKFgSjvyE/OFL9Onr+RH
         GHmwSeAXwVLiC7AJK3wD2pWux5xDLrblFoMIU=
Date: Tue, 24 Nov 2009 03:03:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v5 00/10] kprobes: Kprobes jump optimization
	support
Message-ID: <20091124020315.GA6221@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 06:21:16PM -0500, Masami Hiramatsu wrote:
> Hi,
> 
> Here are the patchset of the kprobes jump optimization v5
> (a.k.a. Djprobe). Since it is not ensured that the int3 bypassing
> cross modifying code is safe on any processors yet, I introduced
> stop_machine() version of XMC. Using stop_machine() will disable
> us to probe NMI codes, but anyway, kprobes itself can't probe
> those codes. So, it's not a problem. This version also includes
> get/put_online_cpus() around optimization for avoiding deadlock
> of text_mutex.
> 
> These patches can be applied on the latest -tip.
> 
> Changes in v5:
> - Use stop_machine() to replace a breakpoint with a jump.
> - get/put_online_cpus() around optimization.
> - Make generic jump patching interface RFC.
> 
> And kprobe stress test didn't found any regressions - from kprobes,
> under kvm/x86.
> 
> Jump Optimized Kprobes
> ======================
> o Concept
>  Kprobes uses the int3 breakpoint instruction on x86 for instrumenting
> probes into running kernel. Jump optimization allows kprobes to replace
> breakpoint with a jump instruction for reducing probing overhead drastically.
> 
> o Performance
>  An optimized kprobe 5 times faster than a kprobe.
> 
>  Optimizing probes gains its performance. Usually, a kprobe hit takes
> 0.5 to 1.0 microseconds to process. On the other hand, a jump optimized
> probe hit takes less than 0.1 microseconds (actual number depends on the
> processor). Here is a sample overheads.
> 
> Intel(R) Xeon(R) CPU E5410  @ 2.33GHz (without debugging options)
> 
>                      x86-32  x86-64
> kprobe:              0.68us  0.91us
> kprobe+booster:	     0.27us  0.40us
> kprobe+optimized:    0.06us  0.06us
> 
> kretprobe :          0.95us  1.21us
> kretprobe+booster:   0.53us  0.71us
> kretprobe+optimized: 0.30us  0.35us
> 
> (booster skips single-stepping)
> 
>  Note that jump optimization also consumes more memory, but not so much.
> It just uses ~200 bytes, so, even if you use ~10,000 probes, it just 
> consumes a few MB.


Nice results.

But I have troubles to figure out the difference between booster version and
optimized version.


> o Optimization
>   Before preparing optimization, Kprobes inserts original(user-defined)
>  kprobe on the specified address. So, even if the kprobe is not
>  possible to be optimized, it just uses a normal kprobe.
> 
>  - Safety check
>   First, Kprobes gets the address of probed function and checks whether the
>  optimized region, which will be replaced by a jump instruction, does NOT
>  straddle the function boundary, because if the optimized region reaches the
>  next function, its caller causes unexpected results.
>   Next, Kprobes decodes whole body of probed function and checks there is
>  NO indirect jump, NO instruction which will cause exception by checking
>  exception_tables (this will jump to fixup code and fixup code jumps into
>  same function body) and NO near jump which jumps into the optimized region
>  (except the 1st byte of jump), because if some jump instruction jumps
>  into the middle of another instruction, it causes unexpected results too.
>   Kprobes also measures the length of instructions which will be replaced
>  by a jump instruction, because a jump instruction is longer than 1 byte,
>  it may replaces multiple instructions, and it checks whether those
>  instructions can be executed out-of-line.
> 
>  - Preparing detour code
>   Then, Kprobes prepares "detour" buffer, which contains exception emulating
>  code (push/pop registers, call handler), copied instructions(Kprobes copies
>  instructions which will be replaced by a jump, to the detour buffer), and
>  a jump which jumps back to the original execution path.
> 
>  - Pre-optimization
>   After preparing detour code, Kprobes enqueues the kprobe to optimizing list
>  and kicks kprobe-optimizer workqueue to optimize it. To wait other optimized
>  probes, kprobe-optimizer will delay to work.


Hmm, so it waits for, actually, non-optimized probes to finish, right?
The site for which you have built up a detour buffer has an int3 in place
that could have kprobes in processing and your are waiting for them
to complete before patching with the jump?


>   When the optimized-kprobe is hit before optimization, its handler
>  changes IP(instruction pointer) to copied code and exits. So, the
>  instructions which were copied to detour buffer are executed on the detour
>  buffer.



Hm, why is it playing such hybrid game there?
If I understand well, we have executed int 3, executed the
handler and we jump back to the detour buffer?



>  - Optimization
>   Kprobe-optimizer doesn't start instruction-replacing soon, it waits
>  synchronize_sched for safety, because some processors are possible to be
>  interrupted on the instructions which will be replaced by a jump instruction.
>  As you know, synchronize_sched() can ensure that all interruptions which were
>  executed when synchronize_sched() was called are done, only if
>  CONFIG_PREEMPT=n. So, this version supports only the kernel with
>  CONFIG_PREEMPT=n.(*)
>   After that, kprobe-optimizer replaces the 4 bytes right after int3 breakpoint
>  with relative-jump destination, and synchronize caches on all processors. Next,
>  it replaces int3 with relative-jump opcode, and synchronize caches again.


You said you now use stop_machine() to patch the jumps, which looks the only
safe way to do that. May be the above explanation is out of date?


>  - Unoptimization
>   When unregistering, disabling kprobe or being blocked by other kprobe,
>  an optimized-kprobe will be unoptimized. Before kprobe-optimizer runs,
>  the kprobe just be dequeued from the optimized list. When the optimization
>  has been done, it replaces a jump with int3 breakpoint and original code.
>   First it puts int3 at the first byte of the jump, synchronize caches
>  on all processors, and replaces the 4 bytes right after int3 with the
>  original code.
> 
> (*)This optimization-safety checking may be replaced with stop-machine method
>  which ksplice is done for supporting CONFIG_PREEMPT=y kernel.


And now that you use get_cpu()/put_cpu(), I guess this config
option is not required anymore.

I don't understand why the int 3 is still required in the sequence.

- Registration: You first patch the site with int 3, then try the jump
  and use the int 3 as a gate to protect your patching.

- Unregistration: Same in reverse


You are doing a live patching while the code might be running concurrently
which requires a very tricky surgery, based on a int 3 gate and rcu as you
describe above.
But do we need to play such dangerous (and complicated) game.
I mean, it's like training to be a tightrope walker while we have a
bridge just beside :)
Why not running stop_machine(), first trying the jump directly, patching
it if it's considered safe, otherwise patching with int 3?

But you said you are using stop_machine() in the v5 changelog,
I should probably first look at the patches :)

Thanks.

