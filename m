Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZFDLWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZFDLWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 07:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbZFDLWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 07:22:18 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:52074 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZFDLWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 07:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=MDZQi+g/RrK2pXA8Q6Hx+qBk1Og7EOvWgR8dUFDGC/t9JDyDHL9rezioLsaargo+M/
         m8Pjz3CtZf8AUk20/ztuRAoRwh55I2DSQ/Zrtjm8evWRg9j0PFacLdWnY+XVnuq5ioh2
         BpqDLTOOQAHVKr0SNNmguAJDBUU4HtZ//Acos=
Subject: Re: [PATCH v2 2/6] mips dynamic function tracer support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Wang Liming <liming.wang@windriver.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <alpine.DEB.2.00.0906030841040.14994@gandalf.stny.rr.com>
References: <cover.1243604390.git.wuzj@lemote.com>
	 <a00a91f6fc79b7d20b5b2193086e879dcafded46.1243604390.git.wuzj@lemote.com>
	 <4A22281B.7020908@windriver.com>
	 <b00321320906020915n7ba241eqb3cb0de877af514d@mail.gmail.com>
	 <4A26129E.1080008@windriver.com>
	 <alpine.DEB.2.00.0906030841040.14994@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Thu, 04 Jun 2009 19:20:34 +0800
Message-Id: <1244114434.31146.48.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Steven

> Note, PowerPC uses a trampoline from modules to kernel core. I think MIPS 
> just calls mcount differently. That is, it does a full 32bit address call
> (64 bit for 64 bit archs?). Something like:
> 
> 	lui	v1, _mcount
> 	addiu	v1, v1, _mcount
> 	jalr	v1
> 	addiu	sp, sp, -8
> 
> Then a nop would not do. Due to preemption, we can not modify more than 
> one line. But you could modify it to:
> 
> 	b	1f
> 	addiu	v1, v1, _mcount
> 	jalr	v1
> 	addiu	sp, sp, -8
> 1:
> 
> Clobbering v1 should not be an issue since it is already used to store 
> _mcount. That is, we still do the addiu v1,v1,_mcount with that branch. 
> But v1 should be ignored.
> 

sorry, I'm not clear what you said above, could you give more
explanation on it, thanks! 

I think "jal _mcount" itself will not work in static and dynamic ftrace.
something like what you described above should be used instead. perhaps
a PATCH can be sent to gcc or we use some tricks in kernel.

if we not use the method of modifying the kernel code in run time(avoid
preemption?), can we link something as following to the modules:

_mcount_trampoline:
	PTR_LA	t0, _mcount
	jalr	t0

and then we replace the original "jal _mcount" in every module to "jal
_mcount_trampoline" with a perl script.

this solution maybe work for static ftrace. does it?

but in dynamic ftrace, when ftrace is enabled and set_filter_function is
set, the place of filtered function will be substituted to "jal
ftrace_caller", this will not work since ftrace_caller is a function
like _mcount, which will not reached in modules. so, this ftrace_caller
should be substituted to something like this:

ftrace_caller_trampoline:
	PTR_LA	t0, ftrace_caller
	jalr	t0

and ftrace_caller_trampoline should be linked to modules too. or we
substituted it to the above _mcount_trampoline, but change "PTR_LA t0,
_mcount" to "PTR_LA t0, ftrace_caller".

does this work?

thanks!
Wu Zhangjin

