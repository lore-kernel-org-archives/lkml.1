Return-Path: <linux-kernel-owner+w=401wt.eu-S965661AbXBGH07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbXBGH07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 02:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965667AbXBGH07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 02:26:59 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:59080 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965661AbXBGH06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 02:26:58 -0500
Date: Wed, 7 Feb 2007 16:24:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3 take2] smaps: extract pte walker from smaps code
Message-ID: <20070207072455.GA12435@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Hugh Dickins <hugh@veritas.com>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com> <20070207062934.GA11967@linux-sh.org> <20070206224914.f1da7019.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206224914.f1da7019.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 10:49:14PM -0800, Andrew Morton wrote:
> On Wed, 7 Feb 2007 15:29:34 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
> > I like the general idea of this patch set, however..
> 
> David didn't really spell out the rationale.  Userspace people ask "how
> much memory is my application using".  For system planning and such.  We
> don't know, really.  So the approach taken here is to nuke all the
> referenced bits and to then monitor them coming back over time.
> 
> Obviously it doesn't work very well if the page scanner is doing things,
> but one hopes that when someone is instrumenting their application they'll
> ensure that sufficient memory is available to prevent this inaccuracy.
> 
This was the problem we kept running in to as well, people that wanted to
instrument their applications on the desktop where all of the required
infrastructure already brought the system to its knees long before
instrumentation could begin didn't really provide the most consistent
metrics, especially when the application depended heavily on overcommit.

This resulted in a lot of extra hacks on top of the smaps code trying to
balance out the numbers, this just ended up being a massive headache.
smaps seems to be an appealing target for piling additional semantics on,
unfortunately.

> I don't really have a sense for how much stuff we want to put into the kernel
> to support this sort of thing.  The proposed patches are, I think, minimal.
> Perhaps it needs more.  If so, opinions are solicited before we go and add
> (and hence be forced to maintain) this new interface.
> 
This sort of minimalist interface is not necessarily a bad approach if it
helps in a way that works for the people that really want it. The issue
with any of the smaps extensions is being able to provide people with a
"good enough" metric without falling in to interface hell. This really
depends on how one defines "good enough", though. It would be nice to
hear from application folks if this ends up being useful for them or not.

> > Perhaps this is something that needs to be looked at more closely and
> > made more generic? There are many ranged page table walkers that aren't
> > so performance critical that the function call cost would cause too much
> > pain. ioremap_page_range() comes to mind, and there's bound to be others.
> > This would also help people to get the pte map/unmap right, which seems
> > to pop up from time to time as well..
> 
> That's what Paul Davies' patches are aimed at:
> 
> http://marc.theaimsgroup.com/?l=linux-mm&m=115276500100695&w=2
> 
> I promised Paul that I'd take a serious look at those patches next time
> they pop up.   It would be good if others could help out in that.

It would be nice to see this smaps patchset rebased on something like
that rather than introducing another walker abstraction simply to have it
overhauled later. I realize this isn't really David's problem, but we
shouldn't be trying to solve the same problem multiple times.
