Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZINVS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZINVS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZINVS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:18:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:58672 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZINVSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:18:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ud/TA8bHEtbCWsIaLRn9y+3LdwKnl/yOECx8fnLx+zpStaUmnGOthscBwyR/0xCqym
         2o+UpcDjJD+GwBWI4IHqbAr9R7ceNHA3s5zI6Gm8rYCXnFPhm0NexFMu1zSAng3Jg7CJ
         cxKIJEF8+RAjdcZ0FVteKCopbkeJ/goGQxu0E=
Date: Mon, 14 Sep 2009 23:18:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/5] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf counters
Message-ID: <20090914211822.GJ6045@nowhere>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com> <1252571367-25876-4-git-send-email-fweisbec@gmail.com> <20090910142540.GA3512@in.ibm.com> <20090910185304.GD6421@nowhere> <1252617481.7205.106.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252617481.7205.106.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 11:18:01PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-09-10 at 20:53 +0200, Frederic Weisbecker wrote:
> > On Thu, Sep 10, 2009 at 07:55:40PM +0530, K.Prasad wrote:
> > > On Thu, Sep 10, 2009 at 10:29:25AM +0200, Frederic Weisbecker wrote:
> > > > This patch rebase the implementation of the breakpoints API on top of
> > > > perf counters instances.
> > > > 
> > > > The core breakpoint API has changed a bit:
> > > > 
> > > > - register_kernel_hw_breakpoint() now takes a cpu as a parameter. For
> > > >   now it doesn't support all cpu wide breakpoints but this may be
> > > >   implemented soon.
> > > 
> > > Is there a reason why perf doesn't support counters effective on all
> > > CPUs (and all processes)?
> > > Atleast, it is vital for debugging aspects of hw-breakpoints...say to
> > > answer "Who all did a 'write' on the kernel variable that turned corrupt", etc.
> > > 
> > > The implementation to iteratively register a breakpoint on all CPUs would
> > > (as in trace_ksym.c) result in unclean semantics for the end user, when, a
> > > register_kernel_<> request fails on a given CPU and all previously
> > > registered breakpoints have to be reverted (but the user might have
> > > received a few breakpoint triggers by then as a result of the successful
> > > ones...i.e. register request fails, but still received 'some' output).
> > 
> > 
> > (Please shrink the end of the message if you don't answer in further parts.
> > I'm especially a bad example of what not to do :-)


Oh I was meaning "a good example"...



> > 
> > Yeah it would be very convenient to have that. Is it possible considering
> > the current internal design of perf?
> 
> Create the counters disabled? Maybe even group them to allow 'atomic'
> enable/disable.


I don't see why we need that.
The problem is that we need "all-cpu" counters.

May be we could pass a per cpu ptr to a
register_hardware_breakpoint_wide() that could do the trick by itself?

But that sounds too much workarounds while we would like only one
handler.
May be could we multiplex several per cpu counter into a single one?

