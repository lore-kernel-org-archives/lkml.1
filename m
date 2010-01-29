Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706Ab0A2Ezy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0A2Ezy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 23:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683Ab0A2Ezx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 23:55:53 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53978 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab0A2Ezw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 23:55:52 -0500
Date: Fri, 29 Jan 2010 10:25:46 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Tom Tromey <tromey@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100129045546.GA16920@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain> <m3636oh2rt.fsf@fleche.redhat.com> <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain> <1264575134.4283.1983.camel@laptop> <20100127085442.GA28422@elte.hu> <1264643539.5068.62.camel@localhost.localdomain> <20100128085502.GA7713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128085502.GA7713@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 09:55:02AM +0100, Ingo Molnar wrote:

...

> Lets compare the two cases via a drawing. Your current uprobes submission 
> does:
> 
>  [kernel]      do probe thing     single-step trap
>                ^            |     ^              |
>                |            v     |              v
>  [user]     INT3            XOL-ins              next ins-stream
> 
>  ( add the need for serialization to make sure the whole single-step thing 
>    does not get out of sync with reality. )
> 
> And emulator approach would do:
> 
>  [kernel]      emul-demux-fastpath, do probe thing
>                ^                                 |
>                |                                 v
>  [user]     INT3                                 next ins-stream
> 
> far simpler conceptually, and faster as well, because it's one kernel entry.

Ingo,

Yes, conceptually, emulation is simpler. In fact, it may even be the
right thing to do from a housekeeping POV if gdb were enabled to use
breakpoint assistance in the kernel. However... emulation is not
easy. Just quoting Peter Anvin:

> On the more general rule of interpretation: I'm really concerned about
> having a bunch of partially-capable x86 interpreters all over the
> kernel.  x86 is *hard* to emulate, and it will only get harder as the
> architecture evolves.
>
>       -hpa

Yes, I know you suggested we start with a small subset.

We already have an implementation of instruction emulation in kernel for
x86 and powerpc, but its too KVM centric. If there is a generic
emulation layer, we would use it.

There are conflicting opinions for either case; complicated as it is,
the XOL scheme works and, to a large extent, it is easily extendable to
other architectures compared to the emulation approach. Uprobes can be
made to use emulation when possible/available, but I don't think this
should be gating decision for the initial implementation of the feature.

Ananth
