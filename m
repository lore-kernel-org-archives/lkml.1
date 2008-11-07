Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYKGQsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYKGQsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYKGQr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:47:57 -0500
Received: from relais.videotron.ca ([24.201.245.36]:38750 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYKGQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:47:56 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 07 Nov 2008 11:47:47 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-reply-to: <20081107075003.fa93ccf4.akpm@linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811071129440.13034@xanadu.home>
References: <20081107003816.9b0f947a.akpm@linux-foundation.org>
 <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca>
 <20081106220530.5b0e3a96.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
 <25363.1226056819@redhat.com>
 <alpine.LFD.2.00.0811070952150.13034@xanadu.home>
 <20081107075003.fa93ccf4.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008, Andrew Morton wrote:

> On Fri, 07 Nov 2008 10:01:01 -0500 (EST) Nicolas Pitre <nico@cam.org> wrote:
> 
> > On Fri, 7 Nov 2008, David Howells wrote:
> > 
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > As I said in the text which you deleted and ignored, this would be
> > > > better if it was implemented as a C function which requires that the
> > > > caller explicitly pass in a reference to the state storage.
> > 
> > The whole purpose of that thing is to be utterly fast and lightweight.  
> 
> Well I'm glad it wasn't designed to demonstrate tastefulness.

Fast tricks aren't always meant to be beautiful.  That,s why we have 
abstraction layers.

> btw, do you know how damned irritating and frustrating it is for a code
> reviewer to have his comments deliberately ignored and deleted in
> replies?

Do you know how irritating and frustrating it is when reviewers don't 
care reading the damn comments along with the code?  Maybe it wasn't the 
case, but you gave the impression of jumping to conclusion without even 
bothering about the associated explanation in the code until I directed 
you at it.

> > Having an out of line C call would trash the major advantage of this 
> > code.
> 
> Not really.

Your opinion.

> > > I imagine this would compile pretty much the same as the macro.
> > 
> > Depends.  As everybody has noticed now, the read ordering is important, 
> > and if gcc decides to not inline this 
> 
> If gcc did that then it would need to generate static instances of
> inlined functions within individual compilation units.  It would be a
> disaster for the kernel.  For a start, functions which are "inlined" in kernel
> modules wouldn't be able to access their static storage and modprobing
> them would fail.

That doesn't mean that access ordering is preserved within the function, 
unless the interface is pointer based, but that won't work if the 
counter is accessed through some special instruction rather than a 
memory location.

> > for whatever reason then the 
> > ordering is lost.
> 
> Uninlining won't affect any ordering I can see.

See above.

> >  This is why this was a macro to start with.
> > 
> > > I think it
> > > would make it more obvious about the independence of the storage.
> > 
> > I don't think having the associated storage be outside the macro make 
> > any sense either.  There is simply no valid reason for having it shared 
> > between multiple invokations of the macro, as well as making its 
> > interface more complex for no gain.
> 
> oh god.

Thank you.  ;-)

> > > Alternatively, perhaps Nicolas just needs to mention this in the comment more
> > > clearly.
> > 
> > I wrote that code so to me it is cristal clear already.  Any suggestions 
> > as to how this could be improved?
> > 
> 
> Does mn10300's get_cycles() really count backwards?  The first two
> callsites I looked at (crypto/tcrypt.c and fs/ext4/mballoc.c) assume
> that it is an upcounter.

I know nothing about mn10300.


Nicolas
