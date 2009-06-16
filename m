Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbZFPWkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbZFPWkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbZFPWkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:40:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44306 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbZFPWkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:40:45 -0400
Message-ID: <4A381F8A.8020105@redhat.com>
Date: Tue, 16 Jun 2009 18:41:14 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [RFC][ PATCH -tip 0/6] kprobes: Kprobes jump optimization support
References: <20090612224925.17825.49637.stgit@localhost.localdomain> <alpine.DEB.1.10.0906131031570.29895@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0906131031570.29895@vinegar-pot.mit.edu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Thank you for your comment!

Tim Abbott wrote:
> On Fri, 12 Jun 2009, Masami Hiramatsu wrote:
> 
>>  - Safety check
> [...]
>>   Next, Kprobes decodes whole body of probed function and checks there is
>>  NO indirect jump, and near jump which jumps into the optimized region (except
>>  the 1st byte of jump), because if some jump instruction jumps into the middle
>>  of another instruction, it causes unexpected results too.
> 
> Hi Masami,
> 
> I think your safety check algorithm is wrong.
> 
> There are several ways in which the kernel might jump into the optimized 
> region that cannot be detected by examining just the probed function:
> 
> (1) The compiler is allowed to do cross-function optimization within a 
> compilation unit where code in one function jumps into the middle of 
> another function.

Hmm, right. This is a real problem. I think I have 2 options for this
issue. I counted the cross-function jumps on my kernel roughly, and
I found there were about 856 jumps jump into 158 functions (it might be
incorrect, I just used 'objdump -d', and it also disassembles data
section...)

- Making a blacklist of target functions or addresses which cross-function
  jumps jump into. This will be done by disassembling kernel when starting up
  kernel and loading modules.(or, at build-time)

- Just disables cross-function optimization by adding --param
  min-crossjump-insns=XXXX where XXXX is enough big number, when
  CONFIG_OPTPROBES=y


> (2) If you have a switch statement that looks like:
> 
> 	switch (foo) {
> 	case 1:
> 		printk("a1");
> 		break;
> 	case 2:
> 		printk("a2");
> 		break;
> 	case 3:
> 		printk("a3");
> 		break;
> 	case 4:
> 		printk("a4");
> 		break;
> 	case 5:
> 		printk("a5");
> 		break;
> 	}
> 
> (i.e. a large number of cases indexed by a small range of integers; 
> depending on your compiler you may need more cases), gcc will implement it 
> using a jump table in the .rodata section.  On x86_32, the generated 
> assembly for the switch will read from the jump table at an offset of 
> 4 * (foo - 1) and then jump to that address to reach the code for the 
> appropriate case.  These jump tables can result in jumps from within the 
> probed function into the optimized region in a way that your algorithm 
> would not detect.

These jumps are uses indirect jumps. As I wrote in the document,
Kprobes doesn't optimize a probe which probes the function including
indirect jump instructions.

> (3) If the code that you're overwriting can throw an exception, it might 
> be that that there is a jump from the .fixup section back into the probed 
> function that overlaps the optimized region.

Sorry, I forgot to describe this case on the document. When the addresses
of optimized instructions are listed on .fixup section, kprobes also
doesn't optimize it.


> The other comment I have about this approach is that it seems you've 
> written a completely new x86 disassembler in order to do binary code 
> analysis in the kernel.
> 
> Ksplice has been using the udis86 disassembler for this purpose: 
> <http://udis86.sourceforge.net/>.  udis86 is intended for binary code 
> analysis and is designed to be embedded into kernels and other 
> applications.

I know, when I asked about udis86, I heard that ksplice just uses it
for supporting old kernels and new kernel implementation doesn't need it.
So, I made a new decoder.

> udis86 generates all its instruction table data from an XML opcode file, 
> which is I think what H. Peter Anvin was suggesting you should do in this 
> previous thread on your instruction decoder: 
> <http://lkml.indiana.edu/hypermail/linux/kernel/0904.0/01929.html> 
> Compared to e.g. libopcodes it is still quite small -- there's a total of 
> about 3000 lines of C, plus some instruction tables that are automatically 
> generated from an XML description of the instructions.

I'm not so sure about udis86. Can I use it in exception path (and kprobes)?
Is that XML things enough easy to be maintained?

If so, and the maintainer of udis86 is eager to push it in the
kernel and he will maintain his code etc., it might be acceptable,
aah, after rewriting it according to linux c style:)

> 
> The upstream developer has merged patches from Anders Kaseorg and myself 
> that make it build as part of the core Linux kernel without any changes 
> other than adding a kernel Makefile.  I think if we're going to putting an 
> x86 disassembler into the kernel, it might be better to use something like 
> udis86 that provides a little more information about the instructions 
> being disassembled and is more data-driven.


Thank you,

> 
> 	-Tim Abbott

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

