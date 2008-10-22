Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYJVMHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYJVMHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYJVMHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:07:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbYJVMHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:07:20 -0400
Date: Wed, 22 Oct 2008 08:07:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: make dynamic ftrace more robust
In-Reply-To: <20081022114753.GC8095@elte.hu>
Message-ID: <alpine.DEB.1.10.0810220805530.31133@gandalf.stny.rr.com>
References: <20081021164018.889518687@goodmis.org> <20081021164302.399002797@goodmis.org> <20081022065346.GD17485@elte.hu> <alpine.DEB.1.10.0810220658380.21358@gandalf.stny.rr.com> <20081022114753.GC8095@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Oct 2008, Ingo Molnar wrote:
> 
> > > >  /* Used for MEMORY_HOTPLUG */
> > > > -#define __meminit        __section(.meminit.text) __cold
> > > > +#define __meminit        __section(.meminit.text) __cold notrace
> > > >  #define __meminitdata    __section(.meminit.data)
> > > >  #define __meminitconst   __section(.meminit.rodata)
> > > >  #define __memexit        __section(.memexit.text) __exitused __cold
> > > 
> > > there's no justification given for this in the changelog and the change 
> > > looks fishy.
> > 
> > Sorry, I missed writing this. I had it in other patches, but forgot to 
> > add the change log here. These are areas, just like the __init section 
> > that I have no way ok finding out in an arch independent way, what to 
> > remove from the ftrace records. So by not adding these notraces, we 
> > are guaranteed to hit the warnings above!
> 
> this is utterly fragile and might miss places that insert symbols into 
> some of these sections manually.
> 
> the robust approach is to make sure these things are never in an ftrace 
> record to begin with. scripts/recordmcount.pl should be taught to only 
> record places that it is _100% sure of is traceable_. Not "everything 
> and we'll sort out the stuff that we think is not okay".
> 
> if that needs arch dependent smarts then so be it - ftrace has to be 
> enabled per arch anyway.

In that case, the only reasonable patch, until we do the above is this.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-compile.git/kernel/trace/Kconfig
===================================================================
--- linux-compile.git.orig/kernel/trace/Kconfig	2008-10-21 17:07:47.000000000 -0400
+++ linux-compile.git/kernel/trace/Kconfig	2008-10-22 08:05:40.000000000 -0400
@@ -159,10 +159,11 @@ config STACK_TRACER
 	  Say N if unsure.
 
 config DYNAMIC_FTRACE
-	bool "enable/disable ftrace tracepoints dynamically"
+	bool "enable/disable ftrace tracepoints dynamically (BROKEN)"
 	depends on FTRACE
 	depends on HAVE_DYNAMIC_FTRACE
 	depends on DEBUG_KERNEL
+	depends on BROKEN
 	default y
 	help
          This option will modify all the calls to ftrace dynamically
