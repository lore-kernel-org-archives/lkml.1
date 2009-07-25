Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZGYPi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZGYPi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 11:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZGYPi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 11:38:57 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:51144 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbZGYPi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 11:38:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAJvBakpMQWXi/2dsb2JhbACBUc5DhAwF
Date: Sat, 25 Jul 2009 11:38:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20090725153848.GA749@Krystal>
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-2-git-send-email-fweisbec@gmail.com> <20090720172748.GA27660@Krystal> <20090725023723.GB5100@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090725023723.GB5100@nowhere>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:30:09 up 147 days, 11:56,  3 users,  load average: 0.20, 0.34,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker (fweisbec@gmail.com) wrote:
> On Mon, Jul 20, 2009 at 01:27:48PM -0400, Mathieu Desnoyers wrote:
[...]
> 
> > Maybe we should think of a more flexible breakpoint type mapping too,
> > e.g.:
> > 
> >  monitor _strictly_ execute operation on address 0x...
> >    -> would fail if the architecture does not support execution access
> >       monitoring
> >  monitor (at least) execute operations on address 0x...
> >    -> would be allowed to use a more general monitor (e.g. RWX) if the
> >       architecture does not support "execute only" monitor.
> > 
> > (same for read and write)
> > 
> > Mathieu
> 
> 
> Well, I'm not sure the problem mostly resides in the hardware implementation
> of strict exec breakpoint types. But I guess your point is not limiting to
> that. Yeah for example, x86 doesn't support read-only breakpoints.

Exactly. I used "execute" only as an example, but in the end, we could
end up with a list looking like:

HW_WATCH_R	(1 << 0)
HW_WATCH_NOT_R	(1 << 0)
HW_WATCH_W	(1 << 1)
HW_WATCH_NOT_W	(1 << 1)
HW_WATCH_X	(1 << 2)
HW_WATCH_NOT_X	(1 << 2)

So for instance, flags :

HW_WATCH_R|HW_WATCH_NOT_W|HW_WATCH_NOT_X

would specify that the architecture has to support a "read" watchpoint
which does not trigger on write nor execute.

HW_WATCH_R

would specify that the architecture _must_ support "read" watchpoint,
and we don't care about W or X.

HW_WATCH_R|HW_WATCH_W|HW_WATCH_X

Would ask for watching rwx on an address. The architecture would have to
support all those three.

Some combinations would be invalid (e.g. HW_WATCH_R|HW_WATCH_NOT_R).

There might be better ways to express this, but at this it should show
my point a bit more clearly.

Mathieu


> But I guess that can be simulated using software artifacts, for example using
> READ-WRITE breakpoints + the x86 decoder API, recently submitted by Masami,
> to find the nature of the current instruction.
> 
> Anyway, your point is indeed important: return common error values for unsupported
> breakpoint operations.
> 
> Thanks.
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
