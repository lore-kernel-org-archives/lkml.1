Return-Path: <linux-kernel-owner+w=401wt.eu-S965674AbXCGVrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965674AbXCGVrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992640AbXCGVrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:47:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60437 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992641AbXCGVrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:47:11 -0500
Date: Wed, 7 Mar 2007 13:47:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ash Milsted <thatistosayiseenem@gawab.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       dmitry.torokhov@gmail.com
Subject: Re: 2.6.21-rc2 regression vs. 2.6.20: AT keyboard only works with
 pci=noacpi
In-Reply-To: <20070307212534.325f2f32.thatistosayiseenem@gawab.com>
Message-ID: <Pine.LNX.4.64.0703071335550.5963@woody.linux-foundation.org>
References: <20070303151424.3b08c33e.thatistosayiseenem@gawab.com>
 <20070304142350.7c3c79af.thatistosayiseenem@gawab.com>
 <20070307120004.0bab0f76.thatistosayiseenem@gawab.com>
 <20070307212534.325f2f32.thatistosayiseenem@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Ash Milsted wrote:
> 
> So, I tracked this down to 2.6.21-git7, the first snapshot that gives me
> this problem.

Hmm. There is no "2.6.21-git7" (that would be the seventh nightly snapshot 
after 2.6.21 is released, which hasn't happened yet!).

Do you mean that it happens between 2.6.20-git6 and 2.6.20-git7? That 
would be git commits (the way to get them is to look at the "*.id" file 
that is associated with a snapshot):

	66efc5a7e3061c3597ac43a8bb1026488d57e66b -git6
	509cb37e173d4e39cec47238397e91b718730794 -git7

and yes, doing a

	gitk 66efc5a7..509cb37e

does show an input merge. 

> Tellingly it does contain an input tree merge. I would git bisect
> but I don't have a local copy of the tree - I tried to get one, but it stopped
> halfway through the clone, probably because I had to use http... So, I hope that
> helps.

Can you try "rsync"? It's not a great protocol in general, but it's 
perfectly fine for an initial clone..

After that, since you have already narrowed it down to a particular 
nightly snapshot, you could do the bisection startign from the known 
commits already:

	git bisect start
	git bisect good 66efc5a7	# 2.6.20-git6 was good
	git bisect bad 509cb37e		# 2.6.20-git7 was bad

and you'll have less than 500 commits to test (which is quite fast to 
bisect).

If you want to do some manual checking first (ie guessing that the 
bad behaviour came from that particular input merge), you could first try 
out commit 2a598df5, which is the head commit before of the merged input 
tree (this is all trivial to see with the above "gitk" - the SHA1's may 
sound scary and esoteric, but they're really easy to look up).

That manual check (*if* it turns out that 2a598df5 is indeed the bad one) 
would cut down the range from good to bad to just 18 commits (the range 
would be 66efc5a7..2a598df5), and then you should be able to pinpoint the 
exact bad one from just a few reboots..

(If you have to bisect all 500 commits, it would be ~10 reboots rather 
than four or five).

		Linus
