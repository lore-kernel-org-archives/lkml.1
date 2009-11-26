Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZKZFrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZKZFrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 00:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZKZFrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 00:47:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41760 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZKZFrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 00:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uUx4cqyBFv+fapTIy7n2cnvd8vKksRkD/FVnO+6gEeqv8PGM6MIM+XlH094mz7Q+sj
         8VD+EurKxQnY1pjl+111nHrNCDoTHarnChSyGoNEdWGozg2k0tnKYsbJciUIpkDTnJsH
         K6UxzSWsy+1L8WHxFRX0wBc7ZJ7wkZRWPs3Tg=
Date: Thu, 26 Nov 2009 06:47:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [GIT PULL v6] hw-breakpoints: Rewrite on top of perf events v6
Message-ID: <20091126054735.GA5649@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <20091124094421.GA3468@in.ibm.com> <20091124101342.GB5570@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124101342.GB5570@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 11:13:42AM +0100, Ingo Molnar wrote:
> 
> * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> 
> > On Sun, Nov 08, 2009 at 04:28:54PM +0100, Frederic Weisbecker wrote:
> > > Ingo,
> > > 
> > > Please pull the tracing/hw-breakpoints branch that can be found at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > 	tracing/hw-breakpoints
> > >
> > 
> > Hi Frederic, Ingo,
> > 		Here are a few concerns (roughly in decreasing order of
> > priority) about the perf-events integrated hw-breakpoint feature.
> > 
> > - Freeze the breakpoint interfaces: Owing to the many 
> > current/potential users of hw-breakpoint feature it is important to 
> > provide a stable interface to the end-user. Changes underneath the 
> > interface can be done in due course in a manner that does not affect 
> > the end-user's behaviour or function signature. The present breakpoint 
> > interface requires parameters that are best embedded in a structure 
> > for extensibility.
> 
> Well we have PERF_TYPE_BREAKPOINT right now. I agree that it should be 
> finalized in some sort of extensible ABI real soon - we dont want (and 
> dont need to) add all features that might be possible in the future.


Concerning in-kernel users, it's not a worry. The in-kernel api
is not supposed to be stable and shouldn't, especially for such
a very young facility like generic breakpoints.

But you're right, I don't want it to be a pain to port in other
architectures and the current breakpoint api function signatures
are too tight to the x86 needs. I'm going to change the signature
of the register_* functions so that they actually take a perf_event_attr
struct (and this one must be generic for breakpoints across archs).

But the emergency is really in the struct perf_event_attr structure
interface.
We need to define a generic interface for it soon as it will be
exposed to userland and then fixed on the rock, although the current
existing fields seem to be mandatory and if this interface needs
to be changed, it should be about new fields to append, but still,
and we never know...

I would really appreciate any help in this regard as I don't
know the implementation of breakpoints in other architectures.
Obviously, I could parse the others $(ls arch/ | wc -l) archs
documentations about debug registers. But that won't just scale
as it is going to give me a global and erratic view of the whole
needs, and I believe the archs maintainers would point me out
the subtle things I'm going to miss, as Benjamin, Paul and you did lately
concerning shared address registers among hardware threads in a
single cpu, separate registers between watchpoints and exec-breakpoint...
in ppc.

First of all, I guess we should split out the address field into
start and end (both should be equal in the x86 version) so
that we can support breakpoints in address ranges.

There is also a "compare" thing in power-pc.

 
> > - Proposed migration of register allocation logic to arch-specific 
> > files from kernel/hw_breakpoint.c. This is best done early to help 
> > easy porting of code to other architectures (we have an active 
> > interest in bringing support for PPC64 and S390). If done later, it 
> > will entail additional effort in porting for each architecture.
> 
> I think the general direction should be towards librarized common 
> frameworks.
> 
> If an architecture wants to do something special it should either extend 
> the core code, or, if it's too weird to be added to the core, override 
> it via its own implementation.


The power pc implementation is really completely different from x86, to
the point that it would be hard to gather a common library of constraints
for both.

In ppc, address registers are shared among hardware threads in a same
cpu (which is seen as several cpus by the core), but can be enabled
in the hardware threads of our choice. Exec and Read/write
breakpoint registers are not the same, etc...

Well, perhaps we can do something generic by putting a part
of the constraints to the arch code.


> 
> > - Fix ptrace bugs that potentially alter the semantics of ptrace.
> 
> Is there a specific list of these bugs?


Prasad, I still have your reviews in mind :)
I will fix these soon.

Thanks.


> > - Bring either true system_wide support or atleast workaround the 
> > side-effects of iterative per-cpu registration using single atomic 
> > enablement of all per-cpu breakpoints. This can avoid stray exceptions 
> > which would get delivered to the end-user even for failed breakpoint 
> > requests.
> 
> That can certainly be done when users of such facilities emerge. Right 
> now we have perf and ptrace as the two users - are they affected by 
> these problems?

