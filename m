Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbYHZT4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbYHZT4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYHZTz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:55:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60183 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbYHZTzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:55:55 -0400
Message-ID: <48B45FA2.8040603@garzik.org>
Date: Tue, 26 Aug 2008 15:55:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The downsides of inlining are big enough from both a debugging and a real 
> code generation angle (eg stack usage like this), that the upsides 
> (_somesimes_ smaller kernel, possibly slightly faster code) simply aren't 
> relevant.
> 
> So the "noinline" was random, yes, but this is a real issue. Looking at 
> checkstack output for a saner config (NR_CPUS=16), the top entries for me 
> are things like
> 
> 	ide_generic_init [vmlinux]:             1384
> 	idefloppy_ioctl [vmlinux]:              1208
> 	e1000_check_options [vmlinux]:  	1152
> 	...
> 
> which are "leaf" functions. They are broken as hell (the e1000 is 
> apparently because it builds structs on the stack that should all be 
> "static const", for example), but they are different from something like 
> the module init sequence in that they are not going to affect anything 
> else.


e1000_check_options builds a struct (singular) on the stack, really... 
struct e1000_option is reasonably small.

The problem, which has also shown itself in large ioctl-style switch{} 
statements, is that gcc will generate code such that the stack usage 
from independent code branches

	if {cond1} {
		char buster1[1000];
		foo(buster1);
	} else if (cond2) {
		char buster2[1000];
		foo(buster2);
	}

are added together, not noticed as mutually exclusive.

Of course, adding 'static const' as you noted is a reasonable 
workaround, but gcc is really annoying WRT stack allocation in this manner.

I had problems in the past, before struct ethtool_ops, with like ethtool 
ioctl switch statements using gobs of stack.  In fact, that was a big 
motivation for struct ethtool_ops.

	Jeff


