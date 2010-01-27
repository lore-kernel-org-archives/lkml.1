Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007Ab0A0Kzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0A0Kzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806Ab0A0Kzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:55:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:47956 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0A0Kzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:55:51 -0500
Subject: Re: linux-next: add utrace tree
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tom Tromey <tromey@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, JimKeniston <jkenisto@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au>
	 <20100122005147.GD22003@redhat.com>
	 <20100121170541.7425ff10.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	 <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com>
	 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	 <20100122221348.GA4263@redhat.com>
	 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	 <m33a1tnbd9.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	 <m3636oh2rt.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
	 <1264575134.4283.1983.camel@laptop>
	 <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 11:55:16 +0100
Message-ID: <1264589716.4283.2006.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 02:43 -0800, Linus Torvalds wrote:
> 
> On Wed, 27 Jan 2010, Peter Zijlstra wrote:
> > 
> > Right, so you're going to love uprobes, which does exactly that. The
> > current proposal is overwriting the target instruction with an INT3 and
> > injecting an extra vma into the target process's address space
> > containing the original instruction(s) and possible jumps back to the
> > old code stream.
> 
> Just out of interest, how does it handle the threading issue?
> 
> Last I saw, at least some CPU people were _very_ nervous about overwriting 
> instructions if another CPU might be just about to execute them.
> 
> Even the "overwrite only the first byte with 'int3'" made them go "umm, I 
> need to talk to some core CPU people to see if that's ok". They mumble 
> about possible CPU errata, I$ coherency, instruction retry etc.
> 
> I realize kprobes does this very thing, but kprobes is esoteric stuff and 
> doesn't have much choice. In user space, you _could_ do the modification 
> on a different physical page and then just switch the page table entry 
> instead, and not get into the whole D$/I$ coherency thing at all.

Right, so there's two aspects:

 1) concurrency when inserting the probe
 2) concurrency when hitting the probe

1) used to be dealt with by using utrace to stop all threads in the
process and then writing the instruction. I suggested to CoW the page,
modify the instruction, set the pagetable and flush tlbs at full speed
-- the very thing you suggest here.

2) so traditionally (and the intel arch manual describes this) is to
replace the instruction, single step it, and write the probe back. This
is racy for multi-threading. The current uprobes stuff solves this by
doing single-step-out-of-line (XOL).

XOL injects a new vma into the target process and puts the old
instruction there, then it single steps on the new location, leaving the
original site with INT3.

This doesn't work for things like RIP relative instructions, so uprobes
considers them un-probable.

Also, I myself really object to inserting a vma in a running process,
its like a land-lord, sure he has the key but he won't come in an poke
through your things.

The alternative is to place the instruction in TLS or stack space, since
each thread can only have a single trap at a time, you only need space
for 1 instruction (plus a possible jump out to the original site). There
is the 'problem' of marking the TLS/stack executable when being probed.

Then there is the whole emulation angle, the uprobes people basically
say its too much effort to write a x86 emulator.

