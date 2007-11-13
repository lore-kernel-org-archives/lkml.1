Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXKNE7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXKNE7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbXKNE64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:58:56 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:43655 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750759AbXKNE6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:58:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=P/PJ9s41LWZUmMiiCuJilrf4ghfnMYhPP/7S5iFQnBFiX6LWMpGdNE+No7MDHwLP6wMQ0UmqPspXVUlyZ4pGzmDuEcZcxZEYwP7vc9pV914j6mtfRw+4lWNIqRRfCXx+n3VC4rCsyVe4PNXuwHpRrbiYvHYOgFpjMPY/nepS4cQ=  ;
X-YMail-OSG: cJbD9FYVM1nCRZoq1eK6S8OqR6jtrM.dc1rdh2eCImDUjVAtRCyXemMl.0gMe8hf_GvXt0YiiQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] New Kernel Bugs
Date: Wed, 14 Nov 2007 03:56:31 +1100
User-Agent: KMail/1.9.5
Cc: Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org>
In-Reply-To: <20071113130411.26ccae12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140356.31483.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rant on :) ... These aren't directed specifically at Andrew, but
everyone who merges patches or is involved in the release process.

On Wednesday 14 November 2007 08:04, Andrew Morton wrote:
> On Tue, 13 Nov 2007 21:00:30 +0100 (CET) Christian Kujau 
<lists@nerdbynature.de> wrote:
> > On Tue, 13 Nov 2007, Andrew Morton wrote:
> > > I think that we're fairly good about working the regressions in
> > > Adrian/Michal/Rafael's lists but once Linus releases 2.6.x we tend to
> > > let the unsolved ones slide, and we don't pay as much attention to the
> > > regressions which 2.6.x testers report.
> >
> > Can't we wait until all regressions[0] are fixed before releasing a new
> > 2.6.x? I'd consider regressions a *literal* show stopper, and with this
> > policy they just have be fixed, nothing would "slide"...
>
> Problem is that everyone would then sit around pumping shiny new features
> into their trees waiting until someone else fixes the regressions.

Not if you said their regression causing patches will get reverted unless it
can be fixed for release. For everyone not involved, they'll be doing their
own productive things and we don't want to stop that.


> There are a number of process things we _could_ do.  Like
>
> - have bugfix-only kernel releases

I don't know why this would be better than the above. If you are worried
about perception of released kernels, then it would actually be worse,
because the non-bugfix-only releases will get out there, and the numbering
scheme gets yet another level of complexity.

Make 2.6.24-rc3 your bugfix only release. If you argue that would make
the cycle too long, the solution is to merge less stuff in 2.6.24-rc1.


> - Just refuse to merge any non-bugfix patches for a subsystem when it is
>   determined that the subsystem has "too many" regressions.

If you don't allow regressions to build up over releases in the first
place, then this naturally gets done for you.


> - Create an "if you added a regression, you should fix some other bug
>   too" rule.

That's pretty annoying. Everybody tries not to introduce regressions.
It's just a natural part of development. You just have to make the
system work well within that constraint.

It's easy: "if you add a regression, you fix it. If it doesn't get fixed,
we either don't release or we revert your patch."

That takes care of regressions. Now for actually improving quality. I
think to do that you have to encourage code review and bug fixing.

- Take reviewers seriously, and don't allow patches to be merged if they
  have outstanding unaddressed comments (unaddressed doesn't have to mean 
  changed completely to reviewers taste, but at least answered questions
  and provided rationale). Don't merge unreviewed patches.

- Prioritise bugfixes and regression fixes. I realise they can be
  very complex changes, but I am disappointed sometimes at how some
  of my bugfix attempts are received. Things like silent and
  un-reproduceable pagecache corruption, memory ordering bugs which
  will likewise cause silent and un-reproduceable data corruption
  are totally unacceptable IMO; worse than most simple (eg. fail-stop,
  performance) regressions. To see them struggle because the patch
  isn't perfect right off the bat, they're deemed too hard, or they
  clash with some pending "feature" is a pity to me. I don't expect
  thanks or even help, but at least having some priority would help
  me stay interested and the bug to get fixed quicker.

  For a concrete example: when I did the remap_vmalloc_range() patch,
  I converted over all in-tree drivers to use the range checking and
  much safer remap_vmalloc_range. During this conversion I found
  several places where drivers were potentially inserting mappings
  wrongly or not checking user inputs properly (eg. corruption and/or
  security issues). And tried to fix them. And yet the whole patchset
  was dropped, despite being simpler and cleaner code, and attempting
  to fix bugs. Because I wasn't able to test the hardware (and/or
  maintainers didn't respond). It didn't even get a chance in -mm
  (and if it had, it probably would have been immediately dropped if
  I had a typo somewhere). Those patches are still rotting on my hdd
  somewhere... So it is actually far easier for me to shut my eyes and
  not bother reviewing any in-tree code when introducing a new API or
  something like that.
  
  And yet something like CFS basically bypasses the review and test
  process entirely and gets upstream at least a release too soon. That
  isn't anything against the technical side of CFS development, which
  I'm a lot happier with than the old scheduler. It is a problem with
  the merging and release process.

- "if you added a regression, you should fix some other bug too" rule
  should be "if you want to add a new feature, you should review a
  number of other patches". Review points can be traded. If this could
  be done right, it would create a direct economic incentive to review.

OK, the last one is my pipedream that will never happen ;) But you
should understand what can be achieved, what can't, and what will be
the most productive way to change the system.


> - probably other stuff.
>
> But we can't/shouldn't do any of that until it is generally agreed that we
> have a problem and that the problem is of sufficient magnitude that process
> changes are needed to address it.  We aren't at that stage yet.


Well I don't think I need to agree that the kernel is getting worse in
order to think there are ways we can change the system to help it get
better. We can make changes for the better without making things more
difficult for anybody, IMO.

But is the kernel getting worse? I wonder if it has anything to do with
getting further away from large distros? (and thus will get better again
during the next distro release cycle). Because I know SLES9 took a huge
amount of work to get stable. Or do you think it is getting worse since
2.6.0?


> Here's an important point: developers have a fixed amount of development
> time.  They spend some of that time fixing bugs and the rest of that time
> on <otherstuff>.  And while one could cook up all sorts of wonderful
> process changes, they all would be aimed at a single thing: shifting some
> of the developers' time away from <otherstuff> and onto bugfixing.
>
> At this stage the only tool which is being deployed to attempt to bring
> about that reprioritisation is suasion.  aka "lkml flamewar".

To summarise, I think don't actually worry about how the developers
spend their time. All you have to do is control what patches you take
and release policy. Improve the system so it tolerates regressions and
poor quality code (which are inevitable).

Review bandwidth and regression fix rate should just naturally throttle
new features / code going in. And you encourage people to do good things
rather than hit them when inevitable bad things happen.
