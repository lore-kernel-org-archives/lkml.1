Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbZBLSLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbZBLSLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbZBLSLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:11:35 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48201 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614AbZBLSLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:11:34 -0500
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, orenl@cs.columbia.edu,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com,
       tglx@linutronix.de
In-Reply-To: <20090212091721.GB1888@elte.hu>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1234285547.30155.6.camel@nimitz>
	 <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <20090212091721.GB1888@elte.hu>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 10:11:23 -0800
Message-Id: <1234462283.30155.173.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 10:17 +0100, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 10 Feb 2009 09:05:47 -0800
> > Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > 
> > > On Tue, 2009-01-27 at 12:07 -0500, Oren Laadan wrote:
> > > > Checkpoint-restart (c/r): a couple of fixes in preparation for 64bit
> > > > architectures, and a couple of fixes for bugss (comments from Serge
> > > > Hallyn, Sudakvev Bhattiprolu and Nathan Lynch). Updated and tested
> > > > against v2.6.28.
> > > > 
> > > > Aiming for -mm.
> > > 
> > > Is there anything that we're waiting on before these can go into -mm?  I
> > > think the discussion on the first few patches has died down to almost
> > > nothing.  They're pretty reviewed-out.  Do they need a run in -mm?  I
> > > don't think linux-next is quite appropriate since they're not _quite_
> > > aimed at mainline yet.
> > > 
> > 
> > I raised an issue a few months ago and got inconclusively waffled at. 
> > Let us revisit.
> > 
> > I am concerned that this implementation is a bit of a toy, and that we
> > don't know what a sufficiently complete implementation will look like. 
> > There is a risk that if we merge the toy we either:
> > 
> > a) end up having to merge unacceptably-expensive-to-maintain code to
> >    make it a non-toy or
> > 
> > b) decide not to merge the unacceptably-expensive-to-maintain code,
> >    leaving us with a toy or
> > 
> > c) simply cannot work out how to implement the missing functionality.
> > 
> > 
> > So perhaps we can proceed by getting you guys to fill out the following
> > paperwork:
> > 
> > - In bullet-point form, what features are present?
> 
> It would be nice to get an honest, critical-thinking answer on this.
> 
> What is it good for right now, and what are the known weaknesses and
> quirks you can think of. Declaring them upfront is a bonus - not talking
> about them and us discovering them later at the patch integration stage
> is a sure receipe for upstream grumpiness.

That's a fair enough point, and I do agree with you on it.

Right now, it is good for very little.  An app has to basically be
either specifically designed to work, or be pretty puny in its
capabilities.  Any fds that are open can only be restored if a simple
open();lseek(); would have been sufficient to get it back into a good
state.  The process must be single-threaded.  Shared memory, hugetlbfs,
VM_NONLINEAR are not supported.  

> For example, one of the critical corner points: can an app programmatically 
> determine whether it can support checkpoint/restart safely? Are there 
> warnings/signals/helpers in place that make it a well-defined space, and
> make the implementation of missing features directly actionable?
> 
> ( instead of: 'silent breakage' and a wishy-washy boundary between the
>   working and non-working space. Without clear boundaries there's no
>   clear dynamics that extends the 'working' space beyond the demo stage. )

Patch 12/14 is supposed to address this *concept*.  But, it hasn't been
carried through so that it currently works.  My expectation was that we
would go through and add things over time.  I'll go make sure I push it
to the point that it actually works for at least the simple test
programs that we have.

What I will probably do is something BKL-style.  Basically put a "this
can't be checkpointed" marker over most everything I can think of and
selectively remove it as we add features.  

-- Dave

