Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYKZIH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYKZIH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYKZIHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:07:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbYKZIHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:07:19 -0500
Date: Wed, 26 Nov 2008 00:04:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] ftrace: use code patching for ftrace graph tracer
Message-Id: <20081126000430.5c19e189.akpm@linux-foundation.org>
In-Reply-To: <1227682349.5511.47.camel@brick>
References: <20081126051622.134970943@goodmis.org>
	<20081126051709.774546196@goodmis.org>
	<20081125213546.ff4eddf4.akpm@linux-foundation.org>
	<1227682349.5511.47.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 22:52:29 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Tue, 2008-11-25 at 21:35 -0800, Andrew Morton wrote:
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
> > 
> 
> if (code[0] != 0xe9 || old_offset != get_unaligned((int *)(&code[1])))

urgh, OK, that didn't really improve anything except to document
something which was already rather obvious.

> > > +		return -EINVAL;
> > > +
> > > +	*(int *)(&code[1]) = new_offset;
> > 
> > Might be able to use put_unaligned_foo() here.
> > 
> 
> 	put_unaligned(new_offset, (int *)(&code[1]));
> 
> > The problem is that these functions use sizeof(*ptr) to work out what
> > to do, so a cast is still needed.  A get_unaligned32(ptr) would be
> > nice.  One which takes a void* and assumes CPU ordering.
> 
> I've been thinking similarly, I could investigate something that
> goes in with the _noalign stuff?

If it's a commonly used pattern (you'd know better than I) then sure,
it would be clean to have

u32 just_gimme_the_u32_at(void *this_address);

> I'll finish the documentation patch for the _noalign stuff and then see
> about doing the host-order bits to fit in as well.
> 
> Harvey
