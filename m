Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZJGAPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZJGAPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 20:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933124AbZJGAP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 20:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747AbZJGAP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 20:15:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Richard Henderson <rth@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, ak@suse.de, mhiramat@redhat.com
Subject: Re: [PATCH 0/4] jump label patches
In-Reply-To: Richard Henderson's message of  Tuesday, 6 October 2009 16:24:47 -0700 <4ACBD1BF.30201@redhat.com>
References: <cover.1253831945.git.jbaron@redhat.com>
	<20091006053915.D9D0928@magilla.sf.frob.com>
	<4ACBD1BF.30201@redhat.com>
Emacs: if SIGINT doesn't work, try a tranquilizer.
Message-Id: <20091007001436.B5FE9A8C@magilla.sf.frob.com>
Date: Tue,  6 Oct 2009 17:14:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At present, the asm goto extension gives no prediction weights to any 
> path.  I had hoped that the -freorder-blocks pass (enabled with -O2) 
> would automatically place the relevant fallthrough blocks immediately 
> after the asm goto.  It did happen for small test cases, but a message 
> from Jason downthread indicates that it doesn't always happen.

Kernel builds usually use -Os.  Is there anything else we can do now (4.4)
to influence this placement (while keeping the unlikely target block inside
a scope, i.e. macro, with the asm goto)?

Also note that another usage pattern I'm considering for the general case
would (via fancy macros) look something like:

	if (({ __label__ yes; int maybe = 0;
	      asm goto ("jmp %l[yes]" ::: yes);
	      if (0) yes: maybe = 1;
	      maybe; }))
	  doit();
	else
	  dontit();

So please also advise on making something of that character come out optimal.

> > 	if (__builtin_expect(0,0)) do_trace: __attribute__((cold)) { ... }
> 
> An attribute cold on a label is something that I've suggested, but have 
> not yet implemented.  I think that might be the easiest way to add 
> prediction weights to an asm goto.

Ok.  That syntax is accepted already now (4.4.1 anyway) but always generates:
	warning: ?cold? attribute ignored
so it would be annoying to start using it now before compiler-version
conditionals for a version where it does at most nothing.

Btw, if you do make that work I think it would be nice (and seems like it
would be not much different internally) to make:
	label:  __attribute__ ((cold, section (".text.lukewarm")))
work too.  I can see this being used for a few different kinds of things,
where a specialized user like the kernel might want to segregate multiple
different kinds of text.  e.g., "really cold" for rare exception stuff,
"tracepoint warm" for stuff that's cold by default but actually hot if
lots of tracing is enabled, etc.


Thanks,
Roland
