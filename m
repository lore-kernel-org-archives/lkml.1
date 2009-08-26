Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbZHZGry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbZHZGry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbZHZGry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:47:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:35708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbZHZGrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:47:53 -0400
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <4A94D3A8.1090902@cn.fujitsu.com>
References: <20090824092455.GA25267@elte.hu>
	 <1251106058.7538.149.camel@twins> <4A937505.5000209@cn.fujitsu.com>
	 <1251181266.7538.1016.camel@twins> <4A9385AA.508@cn.fujitsu.com>
	 <1251182405.7538.1050.camel@twins> <20090825090558.GC14003@elte.hu>
	 <1251191546.7538.1118.camel@twins> <20090825102215.GC26801@elte.hu>
	 <1251196359.7538.1133.camel@twins>  <20090825103907.GB28287@elte.hu>
	 <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins>
	 <4A94D3A8.1090902@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 08:46:47 +0200
Message-Id: <1251269207.7538.1217.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 14:18 +0800, Li Zefan wrote:
> CC: Mathieu
> 
> Peter Zijlstra wrote:
> > On Tue, 2009-08-25 at 12:47 +0200, Peter Zijlstra wrote:
> >> On Tue, 2009-08-25 at 12:39 +0200, Ingo Molnar wrote:
> >>
> >>>> Do you really wish to burden every tracepoint user with the extra 
> >>>> logic needed to deal with modules?
> >>> Not necessarily - i'm just outlining why i think that the 'dont 
> >>> allow subsystems to utilize tracepoint callbacks' is a restriction 
> >>> we should not live with voluntarily.
> >> Well, unless someone has a bright idea that's what it comes down to. 
> > 
> > OK, I still think modules probing their own tracepoints its stupid [*],
> > but what you could do is iterate the tracepoint's callback list and see
> > if it has a callback outside of the module code section and then fail
> > the unload.
> > 
> 
> I don't think this can work, what if a new callback is registered after
> this check? Seems there's no syncronization to guarantee the result of
> the check can remain valid during module unload.

If that race can be solved using refcounts it can be solved another way
too.

> And the other proposal that bumping module refcnt in register_tracepoint_xxx(),
> I found it hard to do so, because register() won't know where the
> tracepoint is. For example:
> 
>    register_tracepoint_foo() is in module bar, while
>    DEFINE_TRACE(foo) and trace_foo() is in module foo.

You have that call->mod pointer, right? Once you're in the register bit
you should have access to the owning module, which can tell you if the
to be registered callback is part of that same module.

> Note, you're allowed to load bar without foo.
> 
> The simplest fix is the patch I sent, which you don't like. Maybe
> Mathieu, the auther of tracepoint, or some one else has some idea?

Yes, I think forcing every tracepoint consumer to know about modules is
insane.

Aahh, I see the bug, its only ftrace that knows about the module, not
tracepoints themselves, _that_ needs fixing.
