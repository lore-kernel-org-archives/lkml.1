Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZAaKah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZAaKah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 05:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZAaKa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 05:30:28 -0500
Received: from gw.goop.org ([64.81.55.164]:48542 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZAaKa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 05:30:27 -0500
Message-ID: <49842841.1090902@goop.org>
Date: Sat, 31 Jan 2009 02:30:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu>
In-Reply-To: <20090114093834.GA19799@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Tejun, could you please also add the patch below to your lineup too?
>
> It is an optimization and a cleanup, and adds the following new generic 
> percpu methods:
>
>   percpu_read()
>   percpu_write()
>   percpu_add()
>   percpu_sub()
>   percpu_or() 
>   percpu_xor()
>
> and implements support for them on x86. (other architectures will fall 
> back to a default implementation)
>
> The advantage is that for example to read a local percpu variable, instead 
> of this sequence:
>
>  return __get_cpu_var(var);
>
>  ffffffff8102ca2b:	48 8b 14 fd 80 09 74 	mov    -0x7e8bf680(,%rdi,8),%rdx
>  ffffffff8102ca32:	81 
>  ffffffff8102ca33:	48 c7 c0 d8 59 00 00 	mov    $0x59d8,%rax
>  ffffffff8102ca3a:	48 8b 04 10          	mov    (%rax,%rdx,1),%rax
>
> We can get a single instruction by using the optimized variants:
>
>  return percpu_read(var);
>
>  ffffffff8102ca3f:	65 48 8b 05 91 8f fd 	mov    %gs:0x7efd8f91(%rip),%rax
>
> I also cleaned up the x86-specific APIs and made the x86 code use these 
> new generic percpu primitives.
>
> It looks quite hard to convince the compiler to generate the optimized 
> single-instruction sequence for us out of __get_cpu_var(var) - or can you 
> perhaps see a way to do it?
>
> The patch is against your latest zero-based percpu / pda unification tree. 
> Untested.

I have no objection to this patch overall, or the use of non-arch 
specific names.

But there is one subtle thing you're overlooking here.  The x86_*_percpu 
operations are guaranteed to be atomic with respect to preemption, so 
you can use them when preemption is enabled.  When they compile down to 
one instruction then that happens naturally, otherwise they have to be 
wrapped with preempt_disable/enable.

Otherwise, being able to access a percpu with one instruction is nice, 
but it isn't all that efficient.  If you're going to access a variable 
more than once or twice, its more efficient to take the address and 
access it via that.

So, upshot, I think the default versions should be wrapped in 
preempt_disable/enable to preserve this interface invariant.

    J
