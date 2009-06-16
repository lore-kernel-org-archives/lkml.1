Return-Path: <linux-kernel-owner+w=401wt.eu-S1761701AbZFPTvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761701AbZFPTvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZFPTvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:51:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48398 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbZFPTvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:51:42 -0400
Date: Tue, 16 Jun 2009 15:50:52 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [RFC][ PATCH -tip 0/6] kprobes: Kprobes jump optimization
 support
In-Reply-To: <20090612224925.17825.49637.stgit@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0906131031570.29895@vinegar-pot.mit.edu>
References: <20090612224925.17825.49637.stgit@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Masami Hiramatsu wrote:

>  - Safety check
[...]
>   Next, Kprobes decodes whole body of probed function and checks there is
>  NO indirect jump, and near jump which jumps into the optimized region (except
>  the 1st byte of jump), because if some jump instruction jumps into the middle
>  of another instruction, it causes unexpected results too.

Hi Masami,

I think your safety check algorithm is wrong.

There are several ways in which the kernel might jump into the optimized 
region that cannot be detected by examining just the probed function:

(1) The compiler is allowed to do cross-function optimization within a 
compilation unit where code in one function jumps into the middle of 
another function.

(2) If you have a switch statement that looks like:

	switch (foo) {
	case 1:
		printk("a1");
		break;
	case 2:
		printk("a2");
		break;
	case 3:
		printk("a3");
		break;
	case 4:
		printk("a4");
		break;
	case 5:
		printk("a5");
		break;
	}

(i.e. a large number of cases indexed by a small range of integers; 
depending on your compiler you may need more cases), gcc will implement it 
using a jump table in the .rodata section.  On x86_32, the generated 
assembly for the switch will read from the jump table at an offset of 
4 * (foo - 1) and then jump to that address to reach the code for the 
appropriate case.  These jump tables can result in jumps from within the 
probed function into the optimized region in a way that your algorithm 
would not detect.

(3) If the code that you're overwriting can throw an exception, it might 
be that that there is a jump from the .fixup section back into the probed 
function that overlaps the optimized region.


The other comment I have about this approach is that it seems you've 
written a completely new x86 disassembler in order to do binary code 
analysis in the kernel.

Ksplice has been using the udis86 disassembler for this purpose: 
<http://udis86.sourceforge.net/>.  udis86 is intended for binary code 
analysis and is designed to be embedded into kernels and other 
applications.

udis86 generates all its instruction table data from an XML opcode file, 
which is I think what H. Peter Anvin was suggesting you should do in this 
previous thread on your instruction decoder: 
<http://lkml.indiana.edu/hypermail/linux/kernel/0904.0/01929.html> 
Compared to e.g. libopcodes it is still quite small -- there's a total of 
about 3000 lines of C, plus some instruction tables that are automatically 
generated from an XML description of the instructions.

The upstream developer has merged patches from Anders Kaseorg and myself 
that make it build as part of the core Linux kernel without any changes 
other than adding a kernel Makefile.  I think if we're going to putting an 
x86 disassembler into the kernel, it might be better to use something like 
udis86 that provides a little more information about the instructions 
being disassembled and is more data-driven.

	-Tim Abbott
