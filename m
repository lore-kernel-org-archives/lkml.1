Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbZKTR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbZKTR7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZKTR7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:59:42 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59093 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbZKTR7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:59:32 -0500
X-Greylist: delayed 2212 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 12:58:46 EST
Date: Fri, 20 Nov 2009 17:23:27 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: rostedt@goodmis.org, Nicholas Mc Guire <der.herr@hofr.at>,
       zhangfx@lemote.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH v9 04/10] tracing: add dynamic function tracer support
	for MIPS
Message-ID: <20091120172327.GD6869@linux-mips.org>
References: <cover.1258719323.git.wuzhangjin@gmail.com> <6a25a6132d64830bbd7339fe8b3841a51d02ac6d.1258719323.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a25a6132d64830bbd7339fe8b3841a51d02ac6d.1258719323.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 08:34:32PM +0800, Wu Zhangjin wrote:

> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> With dynamic function tracer, by default, _mcount is defined as an
> "empty" function, it returns directly without any more action . When
> enabling it in user-space, it will jump to a real tracing
> function(ftrace_caller), and do the real job for us.
> 
> Differ from the static function tracer, dynamic function tracer provides
> two functions ftrace_make_call()/ftrace_make_nop() to enable/disable the
> tracing of some indicated kernel functions(set_ftrace_filter).
> 
> In the -v4 version, the implementation of this support is basically the same as
> X86 version does: _mcount is implemented as an empty function and ftrace_caller
> is implemented as a real tracing function respectively.
> 
> But in this version, to support module tracing with the help of
> -mlong-calls in arch/mips/Makefile:
> 
> MODFLAGS += -mlong-calls.
> 
> The stuff becomes a little more complex. We need to cope with two
> different type of calling to _mcount.
> 
> For the kernel part, the calling to _mcount(result of "objdump -hdr
> vmlinux"). is like this:
> 
> 	108:   03e0082d        move    at,ra
> 	10c:   0c000000        jal     0 <fpcsr_pending>
>                         10c: R_MIPS_26  _mcount
>                         10c: R_MIPS_NONE        *ABS*
>                         10c: R_MIPS_NONE        *ABS*
> 	110:   00020021        nop
> 
> For the module with -mlong-calls, it looks like this:
> 
> 	c:	3c030000 	lui	v1,0x0
> 			c: R_MIPS_HI16	_mcount
> 			c: R_MIPS_NONE	*ABS*
> 			c: R_MIPS_NONE	*ABS*
> 	10:	64630000 	daddiu	v1,v1,0
> 			10: R_MIPS_LO16	_mcount
> 			10: R_MIPS_NONE	*ABS*
> 			10: R_MIPS_NONE	*ABS*
> 	14:	03e0082d 	move	at,ra
> 	18:	0060f809 	jalr	v1
> 
> In the kernel version, there is only one "_mcount" string for every
> kernel function, so, we just need to match this one in mcount_regex of
> scripts/recordmcount.pl, but in the module version, we need to choose
> one of the two to match. Herein, I choose the first one with
> "R_MIPS_HI16 _mcount".
> 
> and In the kernel verion, without module tracing support, we just need
> to replace "jal _mcount" by "jal ftrace_caller" to do real tracing, and
> filter the tracing of some kernel functions via replacing it by a nop
> instruction.
> 
> but as we have described before, the instruction "jal ftrace_caller" only left
> 32bit length for the address of ftrace_caller, it will fail when calling from
> the module space. so, herein, we must replace something else.
> 
> the basic idea is loading the address of ftrace_caller to v1 via changing these
> two instructions:
> 
> 	lui	v1,0x0
> 	addiu	v1,v1,0
> 
> If we want to enable the tracing, we need to replace the above instructions to:
> 
> 	lui	v1, HI_16BIT_ftrace_caller
> 	addiu	v1, v1, LOW_16BIT_ftrace_caller
> 
> If we want to stop the tracing of the indicated kernel functions, we
> just need to replace the "jalr v1" to a nop instruction. but we need to
> replace two instructions and encode the above two instructions
> oursevles.
> 
> Is there a simpler solution? Yes! Here it is, in this version, we put _mcount
> and ftrace_caller together, which means the address of _mcount and
> ftrace_caller is the same:
> 
> _mcount:
> ftrace_caller:
> 	j	ftrace_stub
> 	 nop
> 
> 	...(do real tracing here)...
> 
> ftrace_stub:
> 	jr	ra
> 	 move	ra, at
> 
> By default, the kernel functions call _mcount, and then jump to ftrace_stub and
> return. and when we want to do real tracing, we just need to remove that "j
> ftrace_stub", and it will run through the two "nop" instructions and then do
> the real tracing job.
> 
> what about filtering job? we just need to do this:
> 
> 	 lui v1, hi_16bit_of_mcount        <--> b 1f (0x10000004)
> 	 addiu v1, v1, low_16bit_of_mcount
> 	 move at, ra
> 	 jalr v1
> 	 nop
> 	 				     1f: (rec->ip + 12)
> 
> In linux-mips64, there will be some local symbols, whose name are
> prefixed by $L, which need to be filtered. thanks goes to Steven for
> writing the mips64-specific function_regex.
> 
> In a conclusion, with RISC, things becomes easier with such a "stupid"
> trick, RISC is something like K.I.S.S, and also, there are lots of
> "simple" tricks in the whole ftrace support, thanks goes to Steven and
> the other folks for providing such a wonderful tracing framework!
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Queued for 2.6.33 but due to patch 3/3 I won't propagate this series
immediately to linux-next.

Thanks!

  Ralf
