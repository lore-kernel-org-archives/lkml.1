Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbZFWI4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbZFWI4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZFWI4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:56:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZFWI4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:56:30 -0400
Date: Tue, 23 Jun 2009 10:55:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: ptrace debugreg checks rewrite
Message-ID: <20090623085550.GE14560@elte.hu>
References: <20090622210920.GB2331@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622210920.GB2331@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> This is a mess.
> 
> Pre unified-x86 code did check for breakpoint addr
> to be "< TASK_SIZE - 3 (or 7)". This was fine from security POV,
> but banned valid breakpoint usage when address is close to TASK_SIZE.
> E. g. 1-byte breakpoint at TASK_SIZE - 1 should be allowed, but it wasn't.
> 
> Then came commit 84929801e14d968caeb84795bfbb88f04283fbd9
> ("[PATCH] x86_64: TASK_SIZE fixes for compatibility mode processes")
> which for some reason touched ptrace as well and made effective
> TASK_SIZE of 32-bit process depending on IA32_PAGE_OFFSET
> which is not a constant!:
> 
> 	#define IA32_PAGE_OFFSET ((current->personality & ADDR_LIMIT_3GB) ? 0xc0000000 : 0xFFFFe000)
> 				   ^^^^^^^
> Maximum addr for breakpoint became dependent on personality of ptracer.
> 
> Commit also relaxed danger zone for 32-bit processes from 8 bytes to 4
> not taking into account that 8-byte wide breakpoints are possible even
> for 32-bit processes. This was fine, however, because 64-bit kernel
> addresses are too far from 32-bit ones.
> 
> Then came utrace with commit 2047b08be67b70875d8765fc81d34ce28041bec3
> ("x86: x86 ptrace getreg/putreg merge") which copy-pasted and ifdeffed 32-bit
> part of TASK_SIZE_OF() leaving 8-byte issue as-is.
> 
> So, what patch fixes?
> 1) Too strict logic near TASK_SIZE boundary -- as long as we don't cross
>    TASK_SIZE_MAX, we're fine.
> 2) Too smart logic of using breakpoints over non-existent kernel
>    boundary -- we should only protect against setting up after
>    TASK_SIZE_MAX, the rest is none of kernel business. This fixes
>    IA32_PAGE_OFFSET beartrap as well.
> 
> As a bonus, remove uberhack and big comment determining DR7 validness,
> rewrite with clear algorithm when it's obvious what's going on.
> 
> Make DR validness checker suitable for C/R. On restart DR registers
> must be checked the same way they are checked on PTRACE_POKEUSR.
> 
> Question 1: TIF_DEBUG can set even if none of breakpoints is turned on,
> should this be optimized?
> 
> Question 2: Breakpoints are allowed to be globally enabled, is this a
> security risk?
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Please base this on the latest x86 tree:

  http://people.redhat.com/mingo/tip.git/README

which has the hw-debug rework with debug register ops abstracted out 
already - making your patch not apply at all.

Thanks,

	Ingo
