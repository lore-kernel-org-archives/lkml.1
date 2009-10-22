Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZJVUhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZJVUhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 16:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZJVUhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 16:37:04 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6815 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZJVUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 16:37:03 -0400
From: Adam Nemet <anemet@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19168.49354.525249.654494@ropi.home>
Date: Thu, 22 Oct 2009 13:30:02 -0700
To: David Daney <ddaney@caviumnetworks.com>
Cc: wuzhangjin@gmail.com, Richard Sandiford <rdsandiford@googlemail.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH -v4 4/9] tracing: add static function tracer support for
 MIPS
In-Reply-To: <4AE0A5BE.8000601@caviumnetworks.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	<2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	<3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	<ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	<1256138686.18347.3039.camel@gandalf.stny.rr.com>
	<1256233679.23653.7.camel@falcon>
	<4AE0A5BE.8000601@caviumnetworks.com>
X-Mailer: VM 8.0.9 under Emacs 23.0.93.1 (x86_64-pc-linux-gnu)
X-OriginalArrivalTime: 22 Oct 2009 20:30:03.0293 (UTC) FILETIME=[6F4A8CD0:01CA5356]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney writes:
> Wu Zhangjin wrote:
> > On Wed, 2009-10-21 at 11:24 -0400, Steven Rostedt wrote:
> [...]
> >>> +
> >>> +NESTED(_mcount, PT_SIZE, ra)
> >>> +	RESTORE_SP_FOR_32BIT
> >>> +	PTR_LA	t0, ftrace_stub
> >>> +	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
> >> Is t0 and t1 safe for mcount to use? Remember, mcount does not follow
> >> the dynamics of C function ABI.
> > 
> > So, perhaps we can use the saved registers(a0,a1...) instead.
> > 
> 
> a0..a7 may not always be saved.
> 
> You can use at, v0, v1 and all the temporary registers.  Note that for 
> the 64-bit ABIs sometimes the names t0-t4 shadow a4-a7.  So for a 64-bit 
> kernel, you can use: $1, $2, $3, $12, $13, $14, $15, $24, $25, noting 
> that at == $1 and contains the callers ra.  For a 32-bit kernel you can 
> add $8, $9, $10, and $11
> 
> This whole thing seems a little fragile.

Maybe scanning the instructions should stop at the beginning of the function
based on the kernel's symbol table.  I am not sure if we can establish any
other stopping condition without affecting performance too much.

Speaking of performance, -pg also affects the instruction scheduling freedom
of the compiler in the prologue.  With profiling, we limit optimizations not
to move instructions in and out of the prologue.

Also note that for functions invoked via tail call you won't get an exit
event.  E.g. if bar is tail-called from foo:

  foo entered
  bar entered
  foo/bar exited

However, this is not MIPS-specific and you can always disable tail calls
with -fno-optimize-sibling-calls.

Adam
