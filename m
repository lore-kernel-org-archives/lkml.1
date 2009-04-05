Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZDET4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZDET4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZDET4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:56:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbZDET4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:56:14 -0400
Date: Sun, 5 Apr 2009 12:51:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: John Levon <levon@movementarian.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix BUG: using smp_processor_id() in preemptible
 [00000000] code: oprofiled/3319
In-Reply-To: <1238958725.3522.1.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0904051243310.4023@localhost.localdomain>
References: <1238958725.3522.1.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Jaswinder Singh Rajput wrote:
>
> Fixed this bug on P4 HT machine:

I don't think this really is correct.

Anything that does that "get_stagger()" thing should already either be 
tied to a specific CPU (because it's going to actually touch the variables 
for "that CPU"), or it should likely set up the data structures for _all_ 
cases.

Just as an example, look at something like "p4_setup_ctrs()": it will use 
that stagger to determine what MSR to read. But if we are preemptable, the 
CPU we actually do the MSR read on may be a _different_ CPU than the CPU 
that we did the "get_stagger()" on!

So I really think that protecting against preemption inside of 
"get_stagger()" is fundamentally buggy. Because if you need it, then by 
the time you return the value from the function, the value has now lost 
all meaning because you might have preempted to another CPU after doing 
the put_cpu().

So I think the "get_cpu()/put_cpu()" should be done around the whole 
sequence (ie from before "get_stagger()" to after the stagger has been 
used to initialize some data structures or do wrmsr/rdmsr calls.

Of course, this is all ancient code, so whatever. But I really think this 
patch is actively bad - it just hides the issue rather than fixing 
anything.

		Linus
