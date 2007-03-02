Return-Path: <linux-kernel-owner+w=401wt.eu-S1422888AbXCBErB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422888AbXCBErB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422889AbXCBErB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:47:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422888AbXCBErA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:47:00 -0500
Message-Id: <200703020446.l224kldo001976@pasta.boston.redhat.com>
To: Zachary Amsden <zach@vmware.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bug in on_each_cpu?
In-Reply-To: Your message of "Thu, 01 Mar 2007 07:22:25 PST."
             <20070301072225.9f00c36c.akpm@linux-foundation.org>
Date: Thu, 01 Mar 2007 23:46:47 -0500
From: Ernie Petrides <petrides@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1-Mar-2007 at 7:22 PST, Andrew Morton wrote:

> On Thu, 01 Mar 2007 03:47:39 -0800 Zachary Amsden <zach@vmware.com> wrote:
> 
> > Rusty Russell wrote:
> > > On Thu, 2007-03-01 at 03:34 -0800, Zachary Amsden wrote:
> > >   
> > >> What would be really, really nice would be to statically check all 
> > >> callsites that issue irq disables actually keep irqs disabled.  
> > >> Presumably, there was a reason they disabled irqs, and re-enabling them 
> > >> underneath their noses, even if it is to avoid a race, breaks the logic 
> > >> behind that reason.
> > >>     
> > >
> > > For the moment, how about a BUG_ON() in on_each_cpu()?
> > >   
> > 
> > Sounds quite decent.  But why does on_each_cpu need to disable 
> > interrupts at all?  It just calls func(), then re-enables interrupts.  
> > So whatever was going to happen during func() that might not be 
> > interrupt safe could just be done in the callee, avoiding the rather 
> > expensive mess of disabling and re-enabling interrupts for those cases 
> > where it doesn't matter.
> 
> The handler for smp_call_function() is called with local interrupts
> disabled (from the IPI handler).
> 
> So to provide a consistent call environment for that handler, on_each_cpu()
> will also disable local interrupts when making the direct call on this CPU.

And further, this "consistent call environment" is *required* for correct
operation of certain callers, e.g. invalidate_bh_lrus(), whose callback
function is invalidate_bh_lru().  If invalidate_bh_lru() is called without
IRQs blocked, it might be interrupted by an IPI that causes nested execution
of that same function on behalf of another cpu's call to on_each_cpu(), and
this can lead to duplicate brelse() calls on a buf head (and ultimately to
ext3 journaling crashes due to invalid concurrent use of that buf head).

Cheers.  -ernie
