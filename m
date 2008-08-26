Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbYHZRfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbYHZRfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYHZRf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:35:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757226AbYHZRf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:35:28 -0400
Date: Tue, 26 Aug 2008 10:35:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <200808261111.19205.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Rusty Russell wrote:
> 
> Your workaround is very random, and that scares me.  I think a huge number of 
> CPUs needs a real solution (an actual cpumask allocator, then do something 
> clever if we come across an actual fastpath).

The thing is, the inlining thing is a separate issue.

Yes, the cpumasks were what made stack pressure so critical to begin with, 
but no, a 400-byte stack frame in a deep callchain isn't acceptable 
_regardless_ of any cpumask_t issues.

Gcc inlining is a total and utter pile of shit. And _that_ is the problem. 
I seriously think we shouldn't allow gcc to inline anything at all unless 
we tell it to. That's how it used to work, and quite frankly, that's how 
it _should_ work.

The downsides of inlining are big enough from both a debugging and a real 
code generation angle (eg stack usage like this), that the upsides 
(_somesimes_ smaller kernel, possibly slightly faster code) simply aren't 
relevant.

So the "noinline" was random, yes, but this is a real issue. Looking at 
checkstack output for a saner config (NR_CPUS=16), the top entries for me 
are things like

	ide_generic_init [vmlinux]:             1384
	idefloppy_ioctl [vmlinux]:              1208
	e1000_check_options [vmlinux]:  	1152
	...

which are "leaf" functions. They are broken as hell (the e1000 is 
apparently because it builds structs on the stack that should all be 
"static const", for example), but they are different from something like 
the module init sequence in that they are not going to affect anything 
else.

It would be interesting to see what "-fno-default-inline" does to the 
kernel. It really would get rid of a _lot_ of gcc version issues too. 
Inlining behavior of gcc has long been a problem for us.

			Linus
