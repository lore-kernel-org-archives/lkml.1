Return-Path: <linux-kernel-owner+w=401wt.eu-S1763445AbZAOK1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763445AbZAOK1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbZAOK1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:27:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:34173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757561AbZAOK1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:27:20 -0500
Message-ID: <496F0F50.6070200@kernel.org>
Date: Thu, 15 Jan 2009 19:26:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org> <496C717F.70204@kernel.org> <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com> <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com> <20090114093834.GA19799@elte.hu>
In-Reply-To: <20090114093834.GA19799@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 10:26:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

Ingo Molnar wrote:
> Tejun, could you please also add the patch below to your lineup too?

Sure thing.

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

Yeah, I thought about that too but couldn't think of a way to persuade
the compiler because the compiler doesn't know how to access the
address.  I'll play with it a bit more but the clumsy percpu_*()
accessors probably might be the only way.  :-(

Thanks.

-- 
tejun
