Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYC1Nd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYC1Nd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYC1NdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:33:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58670 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbYC1NdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:33:18 -0400
Date: Fri, 28 Mar 2008 14:33:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080328133301.GA21660@elte.hu>
References: <20080327132057.449831367@polymtl.ca> <20080327154053.GA5890@elte.hu> <20080327203927.GA19968@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327203927.GA19968@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

>  6a5:   89 5c 24 14             mov    %ebx,0x14(%esp)
>  6a9:   8b 55 d0                mov    -0x30(%ebp),%edx
>  6ac:   89 54 24 10             mov    %edx,0x10(%esp)
>  6b0:   89 4c 24 0c             mov    %ecx,0xc(%esp)
>  6b4:   c7 44 24 08 f7 04 00    movl   $0x4f7,0x8(%esp)
>  6bb:   00 
>  6bc:   c7 44 24 04 00 00 00    movl   $0x0,0x4(%esp)
>  6c3:   00 
>  6c4:   c7 04 24 00 00 00 00    movl   $0x0,(%esp)
>  6cb:   ff 15 0c 00 00 00       call   *0xc
>  6d1:   e9 c3 fc ff ff          jmp    399 <schedule+0x130>
> 
> Which adds an extra 50 bytes.

you talk about 32-bit while i talk about 64-bit. All these costs go up 
on 64-bit and you should know that. I measured 44 bytes in the fastpath 
and 52 bytes in the slowpath, which gives 96 bytes. (with a distro 
.config and likely with a different gcc)

96 bytes _per marker_ sprinkled throughout the kernel. This blows up the 
cache footprint of the kernel quite substantially, because it's all 
fragmented - even if this is in the 'slowpath'.

so yes, that is the bloat i'm talking about.

dont just compare it to ftrace-sched-switch, compare it to dyn-ftrace 
which gives us more than 78,000 trace points in the kernel _here and 
today_ at no measurable runtime cost, with a 5 byte NOP per trace point 
and _zero_ instruction stream (register scheduling, etc.) intrusion. No 
slowpath cost.

and the basic API approach of markers is flawed a well - the coupling to 
the kernel is too strong. The correct and long-term maintainable 
coupling is via ASCII symbol names, not via any binding built into the 
kernel.

With dyn-ftrace (see sched-devel.git/latest) tracing filters can be 
installed trivially by users, via function _symbols_, via:

  /debugfs/tracing/available_filter_functions
  /debugfs/tracing/set_ftrace_filter

wildcards are recognized as well, so if you do:

  echo '*lock' > /debugfs/tracing/set_ftrace_filter

all functions that have 'lock' in their name will have their tracepoints 
activated transparently from that point on.

even multiple names can be passed in at once:

  echo 'schedule wake_up* *acpi*' > /debugfs/tracing/set_ftrace_filter

so it's trivial to use it, very powerful and we've only begun exposing 
it towards users. I see no good reason why we'd patch any marker into 
the kernel - it's a maintenance cost from that point on.

so yes, my argument is: tens of thousands of lightweight tracepoints in 
the kernel here and today, which are configurable via function names, 
each of which can be turned on and off individually, and none of which 
needs any source code level changes - is an obviously superior approach.

	Ingo
