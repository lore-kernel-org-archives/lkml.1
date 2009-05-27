Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbZE0WSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbZE0WSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761094AbZE0WRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:17:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:38422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbZE0WRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LJXu+Yv5VEMirLvZnpz7wARkIL3zdnpVSluYBlpKxOmCVztO6Z3Jfqs+gfoMWLX69l
         I2YpF12azvYgwhqb/wNxUyb1uL3bf69JoCiC6+UG9ccxp/SlISAfcJTCreZCJe+eFLjW
         x73iqiFRNdL7gQDk0h8TEJbWfBSdkKVqSVAlc=
Date: Thu, 28 May 2009 02:17:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090527221753.GB8321@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com> <20090526193503.GB11909@x200.localdomain> <4A1DA8FB.3000306@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1DA8FB.3000306@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 04:56:27PM -0400, Oren Laadan wrote:
> Alexey Dobriyan wrote:
> > On Tue, May 26, 2009 at 08:16:44AM -0500, Serge E. Hallyn wrote:
> >> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> >>> Introduction
> >>> ------------
> >>> Checkpoint/restart (C/R from now) allows to dump group of processes to disk
> >>> for various reasons like saving process state in case of box failure or
> >>> restoration of group of processes on another or same machine later.
> >>>
> >>> Unlike, let's say, hypervisor C/R style which only needs to freeze guest kernel
> >>> and dump more or less raw pages, proposed C/R doesn't require hypervisor.
> >>> For that C/R code needs to know about all little and big intimate kernel details.
> >>>
> >>> The good thing is that not all details needs to be serialized and saved
> >>> like, say, readahead state. The bad things is still quite a few things
> >>> need to be.
> >> Hi Alexey,
> >>
> >> the last time you posted this, I went through and tried to discern the
> >> meaningful differences between yours and Oren's patchsets.  Then I sent some
> >> patches to Oren to make his set configurable to act more like yours.  And Oren
> >> took them!  But now you resend this patchset with no real changelog, no
> >> acknowledgment that Oren's set even exists
> > 
> > Is this a requirement? Everybody following topic already knows about
> > Oren's patchset.
> 
> Some people do ack other people's work. See for example patches #1
> and #24 in my recent post. You're welcome.
> 
> > 
> >> - or is much farther along and pretty widely reviewed and tested (which is
> >> only because he started earlier and, when we asked for your counterpatches
> >> at an earlier stage, you would never reply) - or, most importantly, what
> >> it is that you think your patchset does that his does not and cannot.
> > 
> > There are differences. And they're not small like you're trying to describe
> > but pretty big compared the scale of the problem.
> 
> I've asked before, and I repeat now: can you enumerate these "big"
> scary differences that make it such a "big" problem ?
> 
> So far, we identified two main "design" issues -

Why in "? Yes, they are high-level design issues.

> 1) Whether or not allow c/r of sub-container (partial hierarchy)
> 
> 2) Creation of restarting process hierarchy in kernel or in userspace
> 
> As for #1, you are the _only_ one who advocates restricting c/r to
> a full container only. I guess you have your reasons, but I'm unsure
> what they may be.

The reason is that checkpointing half-frozen, half-live container is
essentially equivalent to live container which adds much complexity
to code fundamentally preventing kernel from taking coherent snapshot.

In such situations kernel will do its job badly.

Manpage will be filled with strings like "if $FOO is shared then $BAR is
not guaranteed".

What to do if user simply doesn't know if container is bounded?
Checkpoint and to hell with consequences?

If two tasks share mm_struct you can't even detect that pages you dump
aren't filled with garbage meanwhile from second task.

If two tasks share mm_struct, other task can issue AIO indefinitely
preventing from taking even coherent filesystem snapshot.

That's why I raise this issue again to hear from people what they think
and these people shouldn't be containers and C/R people, because the
latter already made up their minds.

This is super-important issue to get right from the beginning.

> On the other hand, there has been a handful of use-cases and opinions
> in favor of allowing both capabilities to co-exist. Not the mention
> that nearly no additional code is necessary, on the contrary.
> 
> As for #2, you didn't even bother to reply to the discussion that I
> had started about it. This decision is important to allow future
> flexibility of the mechanism, and to address the needs of several
> potential users, as seen in that discussion and others. Here, too,
> you are the _only_ one that advocates that direction.

Are you going to fork to-become-zombies, make them call restart(2) and
zombify?

> And the funniest thing -- *both* decisions can be *easily* overturned
> in my patchset. In fact, regarding #2 - either way can be easily done
> in it.
> 
> So I wonder, what are the "big" issues that bother you so much ?
> "if there is a will, there is a way".

Oren, don't you really understand?

Users want millions of things, but every thing has price.

Some think hardlinking of directories should be implemented. You can ask
VFS guys how hard would it be and how hard would it be to do reliably
without races/deadlocks et al.
