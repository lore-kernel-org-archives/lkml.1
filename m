Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbZDQReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbZDQReK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbZDQRd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:33:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763AbZDQRdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:33:55 -0400
Date: Fri, 17 Apr 2009 13:33:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: mathieu.desnoyers@polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/4] x86/pvops: target CREATE_TRACE_POINTS to particular
 subsystems
In-Reply-To: <49E8B907.9000109@goop.org>
Message-ID: <alpine.DEB.2.00.0904171330190.14919@gandalf.stny.rr.com>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-3-git-send-email-jeremy@goop.org> <alpine.DEB.2.00.0904171149100.14919@gandalf.stny.rr.com> <49E8AAC8.5080004@goop.org> <alpine.DEB.2.00.0904171231270.14919@gandalf.stny.rr.com>
 <49E8B2EB.8030108@goop.org> <alpine.DEB.2.00.0904171251490.14919@gandalf.stny.rr.com> <49E8B907.9000109@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > On Fri, 17 Apr 2009, Jeremy Fitzhardinge wrote:
> > 
> >   
> > > Steven Rostedt wrote:
> > >     
> > > > Ah yes! It needs to be:
> > > > 
> > > > #ifdef CONFIG_IRQ_TRACE_POINTS
> > > > #undef CONFIG_IRQ_TRACE_POINTS
> > > > #include <trace/define_trace.h>
> > > > #endif
> > > > 
> > > > Otherwise we get into the recursion again.
> > > >         
> > > We should probably also move the #define TRACE_SYS in there as well
> > > (without
> > > the #undef), as it should only have one definition at a time...
> > >     
> > 
> > Actually, I'm kind of against that. Just because as it stands, the
> > TRACE_SYSTEM macro is up at the top, and it is easy to see.
> >   
> 
> Yes, but it means that if you're in the middle of CREATE_FOO_TRACE_POINTS and
> foo.h happens to include bar.h, suddenly TRACE_SUBSYSTEM becomes bar...

How so?

> 
> > Actually, we could do (from the top of the file)
> > 
> > #ifdef CONFIG_IRQ_TRACE_POINTS
> > #undef CONFIG_IRQ_TRACE_POINTS

The first thing the file does is undef CONFIG_FOO_TRACE_POINTS, anything 
else that gets incuded, will not take this path.

> > 
> > #define TRACE_SYSTEM irq
> > 
> > #include <trace/define_trace.h>
> > 
> > #elif !defined(_TRACE_IRQ_H) || defined(TRACE_HEADER_MULTI_READ)
> > #define _TRACE_IRQ_H
> > 
> > #include <linux/tracepoint.h>
> > #include <linux/interrupt.h>
> > 
> > 
> > [...]
> > 
> > #endif
> >   
> 
> That's slightly different from what we have now.  At the moment its
> 
>    #if !defined(_TRACE_IRQ_H)...
>    ...
>    #endif
> 
>    #ifdef CREATE_IRQ_TRACE_POINTS
>    ...
>    #endif
> 
> So we get both the main part of the file and the CREATE_X_TRACE_POINTS parts.
> Your suggestion makes them exclusive:
> 
>    #ifdef CREATE_IRQ_TRACE_POINTS
>    ...
>    #elif !defined(_TRACE_IRQ_H)...
>    ...
>    #endif
>      
> Does that make a difference?

Hmm, I was about to disagree, but I think we need it separate. Because, we 
still need it to do the tracepoint conversion, and we also need to call 
tracepoint.h and TRACE_EVENT before calling define_trace.h.

OK, scrap that idea ;-)

-- Steve

