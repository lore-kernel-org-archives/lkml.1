Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296Ab0A0LGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0A0LGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 06:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173Ab0A0LGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 06:06:35 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:48555 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0A0LGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 06:06:34 -0500
Date: Wed, 27 Jan 2010 16:35:55 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Tom Tromey <tromey@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, avi@redhat.com
Subject: Re: linux-next: add utrace tree
Message-ID: <20100127110555.GB1842@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <alpine.LFD.2.00.1001270231520.24253@localhost.localdomain> <1264589716.4283.2006.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264589716.4283.2006.camel@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:55:16AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-27 at 02:43 -0800, Linus Torvalds wrote:
> > 
> > On Wed, 27 Jan 2010, Peter Zijlstra wrote:
> > > 
> > > Right, so you're going to love uprobes, which does exactly that. The
> > > current proposal is overwriting the target instruction with an INT3 and
> > > injecting an extra vma into the target process's address space
> > > containing the original instruction(s) and possible jumps back to the
> > > old code stream.
> > 
> > Just out of interest, how does it handle the threading issue?
> > 
> > Last I saw, at least some CPU people were _very_ nervous about overwriting 
> > instructions if another CPU might be just about to execute them.
> > 
> > Even the "overwrite only the first byte with 'int3'" made them go "umm, I 
> > need to talk to some core CPU people to see if that's ok". They mumble 
> > about possible CPU errata, I$ coherency, instruction retry etc.
> > 
> > I realize kprobes does this very thing, but kprobes is esoteric stuff and 
> > doesn't have much choice. In user space, you _could_ do the modification 
> > on a different physical page and then just switch the page table entry 
> > instead, and not get into the whole D$/I$ coherency thing at all.
> 
> Right, so there's two aspects:
> 
>  1) concurrency when inserting the probe
>  2) concurrency when hitting the probe
> 
> 1) used to be dealt with by using utrace to stop all threads in the
> process and then writing the instruction. I suggested to CoW the page,
> modify the instruction, set the pagetable and flush tlbs at full speed
> -- the very thing you suggest here.
> 
> 2) so traditionally (and the intel arch manual describes this) is to
> replace the instruction, single step it, and write the probe back. This
> is racy for multi-threading. The current uprobes stuff solves this by
> doing single-step-out-of-line (XOL).
> 
> XOL injects a new vma into the target process and puts the old
> instruction there, then it single steps on the new location, leaving the
> original site with INT3.
> 
> This doesn't work for things like RIP relative instructions, so uprobes
> considers them un-probable.

Probing RIP-relative instructions work just fine; there are fixups that
take care of it.

> Also, I myself really object to inserting a vma in a running process,
> its like a land-lord, sure he has the key but he won't come in an poke
> through your things.
> 
> The alternative is to place the instruction in TLS or stack space, since
> each thread can only have a single trap at a time, you only need space
> for 1 instruction (plus a possible jump out to the original site). There
> is the 'problem' of marking the TLS/stack executable when being probed.
> 
> Then there is the whole emulation angle, the uprobes people basically
> say its too much effort to write a x86 emulator.

We don't need to write one. I don't know how easy it is to make the kvm
emulator less kvm-centric (vcpus, kvm_context, etc). Avi?

Ananth 
