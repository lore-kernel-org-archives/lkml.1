Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZG1BfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZG1BfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZG1BfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:35:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:3308 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbZG1BfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GPhW1Ep+7oxs0PLLPnuo92oJ9nBcLQx0WIp3yVpCVnAsQFbC66LHW+z2dkyR03BchP
         TbdHd0VHbtFzcqNwpNVeL88Ev+hq8Qc4jjz+SXAabsw3ucWm7z1gF/fltIRNvCjqAb6z
         SvAuimxRvXHay+EHjAM6poWzgGO2pxUflu1Rw=
Date: Tue, 28 Jul 2009 03:35:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/5] hw-breakpoints: Make kernel breakpoints API
	truly generic
Message-ID: <20090728013500.GE5147@nowhere>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-2-git-send-email-fweisbec@gmail.com> <20090720172748.GA27660@Krystal> <20090725023723.GB5100@nowhere> <20090725153848.GA749@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090725153848.GA749@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 25, 2009 at 11:38:49AM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Mon, Jul 20, 2009 at 01:27:48PM -0400, Mathieu Desnoyers wrote:
> [...]
> > 
> > > Maybe we should think of a more flexible breakpoint type mapping too,
> > > e.g.:
> > > 
> > >  monitor _strictly_ execute operation on address 0x...
> > >    -> would fail if the architecture does not support execution access
> > >       monitoring
> > >  monitor (at least) execute operations on address 0x...
> > >    -> would be allowed to use a more general monitor (e.g. RWX) if the
> > >       architecture does not support "execute only" monitor.
> > > 
> > > (same for read and write)
> > > 
> > > Mathieu
> > 
> > 
> > Well, I'm not sure the problem mostly resides in the hardware implementation
> > of strict exec breakpoint types. But I guess your point is not limiting to
> > that. Yeah for example, x86 doesn't support read-only breakpoints.
> 
> Exactly. I used "execute" only as an example, but in the end, we could
> end up with a list looking like:
> 
> HW_WATCH_R	(1 << 0)
> HW_WATCH_NOT_R	(1 << 0)
> HW_WATCH_W	(1 << 1)
> HW_WATCH_NOT_W	(1 << 1)
> HW_WATCH_X	(1 << 2)
> HW_WATCH_NOT_X	(1 << 2)
> 
> So for instance, flags :
> 
> HW_WATCH_R|HW_WATCH_NOT_W|HW_WATCH_NOT_X
> 
> would specify that the architecture has to support a "read" watchpoint
> which does not trigger on write nor execute.
> 
> HW_WATCH_R
> 
> would specify that the architecture _must_ support "read" watchpoint,
> and we don't care about W or X.
> 
> HW_WATCH_R|HW_WATCH_W|HW_WATCH_X
> 
> Would ask for watching rwx on an address. The architecture would have to
> support all those three.
> 
> Some combinations would be invalid (e.g. HW_WATCH_R|HW_WATCH_NOT_R).
> 
> There might be better ways to express this, but at this it should show
> my point a bit more clearly.
> 
> Mathieu


Ok, I see your point.
Before making a choice to generically express the modes supported by an arch,
I need a good global view of what is supported by most archs,
thing that I lack and which I should look at quickly :)

Thanks.

 
> 
> > But I guess that can be simulated using software artifacts, for example using
> > READ-WRITE breakpoints + the x86 decoder API, recently submitted by Masami,
> > to find the nature of the current instruction.
> > 
> > Anyway, your point is indeed important: return common error values for unsupported
> > breakpoint operations.
> > 
> > Thanks.
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

