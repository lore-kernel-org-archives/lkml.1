Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZBIN4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZBIN4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZBIN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:56:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbZBIN4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:56:14 -0500
Date: Mon, 9 Feb 2009 14:55:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCHSET x86/master] add stack protector support for x86_32
Message-ID: <20090209135557.GB14785@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> This patchset adds stack protector support for x86_32.  The basics are
> the same with x86_64 but there are some noticeable differences.
> 
> * x86_32 uses %fs for percpu base.  %gs is unused by the kernel and
>   managed lazily.  %gs is used for userland TLS and loading %gs with
>   different value on kernel entry is known to cost quite a bit on some
>   chips.
> 
>   Lazy %gs handling is made optional and disabled if stack protector
>   is enabled.  To do this, entry for %gs is added to pt_regs.  This
>   adds one "pushl $0" to SAVE_ALL in entry_32.S when lazy %gs is on.
>   However, no overhead is added to common exit path and error_code
>   entry path shed a few instructions.  I don't think there will be
>   noticeable overhead but then again it does add an instruction to a
>   very hot path.  Would this be okay?

Yeah, looks good.

> * x86_32 doesn't support direct access to shadow part of %gs and
>   there's no swapgs, so GDT entry should be built for stack canary.
> 
>   GDT entry 28 is used for this.  The boot cpu one is setup from
>   head_32.S.  Others while setting up percpu areas.

Yeah.

> * math_emu register access was completely broken.  Fixed.

=> i'll queue this up for mainline too as this breakage is independent
   of stackprotector.

> * x86_32 exception handlers take register frame verbatim as struct
>   pt_regs.  With -fstack-protector, gcc copies pt_regs into the
>   callee's stack frame to put it after the stack canary.  Of course it
>   doesn't copy back (as the callee owns the argument) and any change
>   made to pt_regs is lost on return.  This is currently worked around
>   by adding -fno-stack-protector to any file containing such
>   functions.  We really need to teach gcc about the calling
>   convention.

Or we could just push in struct pt_regs * ? Even if it's one more
instruction that will avoid trouble not just with the canary but also
with over-eager tail-call optimizations, etc.

> This patchset contains the following eleven patches.

Note, i sorted out the dependencies (it depended on x86/uaccess) and have
put the commits into tip:core/percpu. I might not get around testing it
today and pushing it out into tip:master, but i pushed out the core/percpu
bits, should you queue up further changes.

	Ingo
