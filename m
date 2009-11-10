Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbZKJO3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbZKJO3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbZKJO3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:29:49 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56621 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756390AbZKJO3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:29:48 -0500
Subject: Re: [RFC] new -stable tag variant, Git workflow question
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20091110041452.GA25575@suse.de>
References: <20091110034831.GB26809@elte.hu>
	 <20091110041452.GA25575@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 09:29:48 -0500
Message-Id: <1257863388.4184.220.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 20:14 -0800, Greg KH wrote:
> On Tue, Nov 10, 2009 at 04:48:31AM +0100, Ingo Molnar wrote:
> > FYI, today i committed a scheduler performance fix that has a number of 
> > commit prerequisites for -stable integration. Those commits are not 
> > marked -stable.
> > 
> > Previously, in similar situations, i solved it by email-forwarding the 
> > prereq commits to stable@kernel.org. (or by waiting for your 'it does 
> > not apply to -stable' email and figuring out the prereqs then.)
> > 
> > But we can move this into the Git commit space too, and minimize the 
> > work for the -stable team, via a new -stable tag variant. So with this 
> > new commit i started using a new tagging scheme in the commit itself:
> > 
> >  Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for an idle shared cache
> >  Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
> >  Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
> >  Cc: <stable@kernel.org> # .32.x
> >  LKML-Reference: <1257821402.5648.17.camel@marge.simson.net>
> >  Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > The tag sequence has the meaning of:
> > 
> >   git cherry-pick a1f84a3
> >   git cherry-pick 1b9508f
> >   git cherry-pick fd21073
> >   git cherry-pick <this commit>
> > 
> > and i'm wondering whether this tagging scheme is fine with your -stable 
> > scripting, etc.
> 
> It would work just fine.
> 
> I only rely on one main script right now, one that runs from James's
> directory on kernel.org that picks out the "Cc: <stable@kernel.org>"
> lines and forwards the full commit message to stable@kernel.org.
> 
> Then I have a simple script that I just pass the git commit id and
> formats it properly for inclusion on the quilt tree for the stable
> queue.  If you list the other git commit ids that are needed as a
> prerequesite as you did above, that's trivial to also pick out.
> 
> So I think this is good for me and my workflow.

So I take this to mean that I don't alter my script and you pick out the
precursors with yours ...

> > A further question is, i can see using this tagging scheme in the future 
> > in merge commits log messages too - will your scripts notice that too?
> 
> Hm, I don't think we look at merges as there's nothing there to actually
> commit.
> 
> > For example if there's a few commits left in tip:*/urgent branches 
> > (tip:sched/urgent, tip:core/urgent, tip:x86/urgent, etc.) by the time 
> > v2.6.32 is released, i will then merge them into tip:sched/core, 
> > tip:core/core, tip:x86/core, etc. - and i could use the merge commit as 
> > a notification area to 'activate' them for -stable backporting via a 
> > merge commit.
> > 
> > This is how such merge commits would look like:
> > 
> >   Merge branch 'core/urgent' into core/rcu
> > 
> >   Merge reason: Pick up urgent fixes that did not make it into .32.0
> > 
> >   Cc: <stable@kernel.org> # .32.x: 83f5b01: rcu: Fix long-grace-period race
> >   Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > This is not so rare of a situation as it might seem - for the trees i 
> > maintain it happens in almost every release cycle - i typically skip 
> > urgent branch merges after -rc8/-rc9, unless they are very-very-urgent 
> > fixes - but they'd still be eligible for -stable.
> 
> Ok, that would be good and fine with me.
> 
> James, would your script pick this up, or does it need to also pay
> attention to merge commits?

No ... because merge commits should effectively be empty (and when
they're not you can't generate an applyable diff).  If I understand the
workflow, the desire is to have the whole branch sent to stable by
tagging the merge commit.  That's possible ... it's exactly the same
logic I use in the commit scripts for the SCSI tree, so it should be
possible to extract the logic.

By the looks of the above it's only a few commits, or is it the entire
branch?

> > I've attached the full commit below. The prereq commits are not uptream 
> > yet, and they dont carry a -stable backporting tag as the -stable 
> > relevance was not anticipated at that point yet. They will all be 
> > upstream in the next merge window when Linus merges the relevant tree - 
> > and then all these tags become visible to the -stable team's scripts.
> > 
> > What do you think about this new -stable tagging variant? To me it looks 
> > quite intuitive, less error-prone and it is more informative as well. 
> > Furthermore, it gives us some freedom to mark commits as backport 
> > candidates later on. I kept them oneliners for the purpose of making 
> > them all self-sufficient tags.
> 
> I agree.
> 
> > ( Sidenote: i wouldnt go as far as to generate null Git commits to mark
> >   backports after the fact - this scheme is for a series of commits that 
> >   get 'completed' - there's usually a final followup commit that can 
> >   embedd this information. )
> 
> That's fine, don't worry about this.

The question is, how important is this?

One of the assumptions behind the current setup is that I assume
backports are independent (so the order of transmission doesn't matter
that much).  This isn't always true, but the exceptions tend to get
handled manually.  Part of what the above is requesting is an
implementation that starts to care about ordering.

James


