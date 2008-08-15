Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbYHOMWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbYHOMWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYHOMWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:22:38 -0400
Received: from web82103.mail.mud.yahoo.com ([209.191.84.216]:26259 "HELO
	web82103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753399AbYHOMWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:22:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=y9KTKKjnM6/dOf8D4qVlpw/hpQIL3tkQ9xdc9CSE2qbi3JurnNpErWKTU14ZEW/eUXJpHKps2OUpmcOPssSn1YdDuAsTVrD66OZ9iOmstpUxJkk8iV28c5sGvrUcvsZACZ2qra+5YU1PVgOM1y95upS3IW2suwGn3BOh3BQOuQk=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Fri, 15 Aug 2008 05:22:36 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- retried 2.6.27-rc3 patch (and patch method)
To: Mike Galbraith <efault@gmx.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <879500.36987.qm@web82103.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> From: Mike Galbraith <efault@gmx.de>

> > Because of this, I would conclude that your patch for 2.6.27-rc3 was
> > doomed before you began, and we should look more carefully at the
> > commits from February instead of trying to revert at the 2.6.27 HEAD.

> I've only followed this thread casually, but I suspect that Yinghai is
> trying to determine whether or not 3def3d6d is in fact causing your
> regression directly, or whether it is interacting with other changes.

Yes, Yinghai's first response when I tried his 2.6.27-rc3 patch and the 
kernel still locked was "there is some other problem" (besides the changes
in 3def3d6d).

You may have misunderstood my meaning:  I was only saying that a further
experiment of mine showed that 3def3d6d... alone is not the problem, so
that trying to undo the changes from that commit all the way up near the
git HEAD was unlikely to work.  I did not mean that his patch was a bad
idea, or that it should not have been tried.  When Yinghai created that 
patch, I had not yet done that experiment.  I was just offering an 
explanation for why the patch did not succeed.


> What _could_ be happening is that 3def3d6d itself isn't directly causing
> your problem, rather interacting with earlier changes such that you see
> the problem as soon as 3def3d6d hit.

I am convinced this is the case, as a result of a bisection I performed
Wednesday night -- where I tried to revert the 3def3d6d changes alone in
kernel revisions much closer to that commit, only to discover that the
very next commit after 3def3d6d actually prevented the revert from working!


> Such cases can/do happen, and can cause much confusion.  To find such a
> problem without actually troubleshooting it (if such a thing is
> happening in your case), you'd have to work backward, ie apply 3def3d6d
> to earlier kernels and test.  If you find one earlier than 3def3d6d
> which works with 3def3d6d applied, you can be pretty sure that what
> you've got is a nasty interaction.  At that point, you'd start your
> bisection _with virgin source_ via git bisect good "the point that
> worked _with_ 3def3d6d applied", and git bisect bad any later point that
> failed.  During each and every bisection point, you'd have to apply
> 3def3d6d before testing (fixing any rejects), and _before_ saying git
> bisect good/bad after building/testing, you must revert it first so git
> bisect can proceed without encountering conflicts.

Thank you *very* much for this suggestion, Mike!  I am an "end user," not
a developer, so I never would have thought of this.

Your explanation of how to carry out this bisect process is very much like
the process I used on Wednesday night.  The only difference is that I 
manually edited the 3 files involved at each step, instead of trying to
patch using the 3def3d6d diff.  I can see that your way would have been
much easier, as long as I am careful to watch for rejected patches.

I have to go to work for a few hours, but should be able to put a lot of
time in on this method later today.  Much thanks!


> Before attempting any of that, you'd want to make damn sure that the
> simpler path (forward) is in fact good with the suspect commit fully
> reverted.  If the kernel with full revert does not work, and symptom
> does not change an any way (very important), it's not 3def3d6d directly.
> The patch forward then becomes git bisect start, git bisect good
> 3def3d6d, revert/restore 3def3d6d as above at each and every bisection
> interval until done.

Ahh, this is the experiment I performed Wednesday night.  The results:
3def3d6d is not the true cause.  Beginning with 3def3d6d..., it looks
like anything that touches insert_resource() causes kernels to lock up
on my two ECS AMD690GM-M2 mboards, but not on my other machine (or your
machine, or anyone else's machine....).


> Even if the kernel with full revert does work, it _can_ still be an
> interaction involving multiple changes.  Such interaction problems don't
> pop up often, and can be a real pain to dig out, so I hope it turns out
> to be something straight forward... and I just wasted all those words.

No such luck.  Can you say, "Preparation H"?  (I know I can....)


Thanks Mike,
Dave W.
