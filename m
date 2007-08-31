Return-Path: <linux-kernel-owner+w=401wt.eu-S965714AbXHaPlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbXHaPlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932540AbXHaPlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:41:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45789 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbXHaPlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:41:23 -0400
Date: Fri, 31 Aug 2007 21:24:21 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Robert Hancock <hancockr@shaw.ca>, Rusty Russell <rusty@rustcorp.com.au>,
       bugme-daemon@bugzilla.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mattilinnanvuori@yahoo.com
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
 should not be reachable by the outside of the module until module_init
 finishes
In-Reply-To: <20070829191043.91616ca7.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0708312057470.9261@enigma.security.iitk.ac.in>
References: <fa.fGbKfAxvHbZD1OUm5bpknraMlkQ@ifi.uio.no>
 <fa.+esfGGdgETnuZiuGXcL9U8IpoNM@ifi.uio.no> <46D61E7C.20304@shaw.ca>
 <20070829191043.91616ca7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,


On Wed, 29 Aug 2007, Andrew Morton wrote:

> On Wed, 29 Aug 2007 19:33:48 -0600 Robert Hancock <hancockr@shaw.ca> wrote:
> 
> > Andrew Morton wrote:
> > > On Wed, 29 Aug 2007 11:33:06 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> > > 
> > >> http://bugzilla.kernel.org/show_bug.cgi?id=8957
> > >>
> > >>            Summary: Exported functions and variables should not be reachable
> > >>                     by the outside of the module until module_init finishes
> > >>            Product: Other
> > >>            Version: 2.5
> > >>      KernelVersion: 2.6.23-rc4
> > >>           Platform: All
> > >>         OS/Version: Linux
> > >>               Tree: Mainline
> > >>             Status: NEW
> > >>           Severity: normal
> > >>           Priority: P1
> > >>          Component: Modules
> > >>         AssignedTo: other_modules@kernel-bugs.osdl.org
> > >>         ReportedBy: mattilinnanvuori@yahoo.com
> > >>
> > >>
> > >> Problem Description: a module's exported functions can be called before before
> > >> they are properly initialized by the module_init function.
> > >>
> > >> Steps to reproduce: write a module that exports functions that require
> > >> initialization by the module_init function to work correctly.
> > >>
> > >> E.g. spin lock variables are no longer allowed to be initialized by C
> > >> initializers of the module but only by spin_lock_init that can be called by the
> > >> module_init function. If an exported function calls spin_lock before it is
> > >> initialized, it deadlocks.
> > > 
> > > ooh, nice bug ;)
> > 
> > Under what circumstances is this actually happening? What are these 
> > functions that are being called?
> > 
> > Normally things are set up such that this isn't a problem, i.e. if 
> > module A depends on module B, module A can't load until module B is 
> > finished loading.
> 
> Good point.
> 
> This thus-far-undescribed module could make its internals externally
> visible via one of the kernel's many register_foo() interfaces,

What you're saying is a plausible problem, but note that it is quite a
completely different issue to what Matti Linnanvuori suggested in the
original bug report.

The report was about module B (which depends on module A, because it
references symbol exported by module A) being able to call a function
(or access data) /exported/ by module A _without_ the module_init()
function of module A having finished completely (and hence the possibility
of accessing uninitialized data etc). But this is not possible -- see the
last reply to Matti.

You're referring to is a module implementing an (possibly un-exported)
function that refers to module-local data, and registering that function
(say through a notifier_block) _before_ initializing_ the data used by
that function. But ...


> but it
> would be a buggy module if it was doing register_foo(my_foo) before
> my_foo() was ready to be called.

... exactly. That module is the buggy culprit here, nothing wrong with
the kernel's core module code.


[ BTW I suspect there /are/ modules out there that get this register_foo()
  ordering wrong in their module_init functions.

  Even more widespread (as I have noticed) is the sad habit of modules
  to not unregister_foo() their stuff (in the module_exit function) in
  the exact reverse order of the register_foo() calls made during
  module_init. This can clearly lead to oopsen, but the only reason why
  we don't see them frequently is because the module_init and module_exit
  codepaths are rarely ever executed at runtime, and even more rarely
  concurrently with other stuff that's using the module. ]


Satyam
