Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYJ3VMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYJ3VMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYJ3VMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:12:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbYJ3VL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:11:59 -0400
Date: Thu, 30 Oct 2008 14:10:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       peterz@infradead.org, torvalds@linux-foundation.org,
       srostedt@redhat.com
Subject: Re: [PATCH 1/2] ftrace: nmi safe code modification
Message-Id: <20081030141048.904c82e1.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com>
References: <20081030200831.467420488@goodmis.org>
	<20081030201127.820600693@goodmis.org>
	<20081030133228.824e3f69.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0810301645100.21031@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 16:58:55 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 30 Oct 2008, Andrew Morton wrote:
> > 
> > > +#ifndef __ASSEMBLY__
> > > +#define ftrace_nmi_enter()	do { } while (0)
> > > +#define ftrace_nmi_exit()	do { } while (0)
> > > +#endif
> > > ...
> > > +#ifndef __ASSEMBLY__
> > > +#define ftrace_nmi_enter()	do { } while (0)
> > > +#define ftrace_nmi_exit()	do { } while (0)
> > > +#endif
> > 
> > These could all be written in C.  If there's a reson to write them in
> > cpp then the `#ifndef __ASSEMBLY__' isn't really needed.
> 
> I could do the C macro, and you are right, I did not need the __ASSEMBLY__ 
> part. I guess that was me just being over-protective :-/
> 
> Which would you prefer?  Changing to C or removing the __ASSEMBLY__?

>From a general perspective, C is better.  Has typechecking, adds a ref
to the arguments which can prevent unused-var warnings, easier to read
and maintain, more likely to be commented, known about by debug info,
doesn't all get clumped into a single line in debug info, easier/safer
to uninline, blah, blah.

Also it seems a bit weird to do

#ifdef SOMETHING
#define foo(...) ...
#else
extern void foo(...);
#endif

Doing it in C has the downside that more things need to be visible at
the definition site, so more includes might be needed.  Often fixable
by uninlining.


I dunno.  People seem to instinctively reach for a macro without
thinking, because that's how grandpa did it or something.

