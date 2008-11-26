Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYKZSES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYKZSES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 13:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbYKZSEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 13:04:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbYKZSEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 13:04:05 -0500
Date: Wed, 26 Nov 2008 10:02:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/5] ftrace: use code patching for ftrace graph tracer
Message-Id: <20081126100255.d53f9347.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0811261144360.26743@gandalf.stny.rr.com>
References: <20081126051622.134970943@goodmis.org>
	<20081126051709.774546196@goodmis.org>
	<20081125213546.ff4eddf4.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0811261144360.26743@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 11:46:58 -0500 (EST) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Tue, 25 Nov 2008, Andrew Morton wrote:
> 
> > On Wed, 26 Nov 2008 00:16:24 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: Steven Rostedt <rostedt@goodmis.org>
> > > 
> > > Impact: more efficient code for ftrace graph tracer
> > > 
> > > This patch uses the dynamic patching, when available, to patch
> > > the function graph code into the kernel.
> > > 
> > > This patch will ease the way for letting both function tracing
> > > and function graph tracing run together.
> > > 
> > > ...
> > >
> > > +static int ftrace_mod_jmp(unsigned long ip,
> > > +			  int old_offset, int new_offset)
> > > +{
> > > +	unsigned char code[MCOUNT_INSN_SIZE];
> > > +
> > > +	if (probe_kernel_read(code, (void *)ip, MCOUNT_INSN_SIZE))
> > > +		return -EFAULT;
> > > +
> > > +	if (code[0] != 0xe9 || old_offset != *(int *)(&code[1]))
> > 
> > erk.  I suspect that there's a nicer way of doing this amongst our
> > forest of get_unaligned_foo() interfaces.  Harvey will know.
> 
> Hmm, I may be able to make a struct out of code.
> 
>   struct {
> 	unsigned char op;
> 	unsigned int  offset;
>   } code __attribute__((packed));
> 
> Would that look better?

nah, let's do something more generic for this.

> > 
> > > +		return -EINVAL;
> > > +
> > > +	*(int *)(&code[1]) = new_offset;
> > 
> > Might be able to use put_unaligned_foo() here.
> > 
> > The problem is that these functions use sizeof(*ptr) to work out what
> > to do, so a cast is still needed.  A get_unaligned32(ptr) would be
> > nice.  One which takes a void* and assumes CPU ordering.
> 
> Is there a correctness concern here? This is arch specific code, so I'm
> not worried about other archs.

No, the code is OK as-is.

It's just that "read a word from an [maybe-]unaligned address" is such
a common operation that there should be a nice clean simple function to
do it, rather than doing open-coded (and different) weird C tricks at each
and\ every site.

