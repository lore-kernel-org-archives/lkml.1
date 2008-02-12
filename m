Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbYBLRK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbYBLRK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760089AbYBLRKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:10:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43524 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897AbYBLRKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:10:10 -0500
Date: Tue, 12 Feb 2008 09:09:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: David Miller <davem@davemloft.net>, arjan@infradead.org, greg@kroah.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <47B1CB08.4020101@garzik.org>
Message-ID: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Jeff Garzik wrote:

> David Miller wrote:
> > This is why, with the networking, we've just tossed all of the network
> > driver stuff in there too.  I can rebase freely, remove changesets,
> > rework them, etc. and this causes a very low amount of pain for Jeff
> > Garzik and John Linville.
> 
> Rebasing is always a pain, and John and I both agreed the other day that you
> do it too often.

I do think that some people rebase too often (and that David is in that 
number), often with no real discernible reason. I think rebasing is great 
when you are doing active development (ie you're really acting in "quilt 
mode") and I actually think git could and should integrate more of the 
queues modes, but I don't think it should be a default action for an 
up-stream developer.

I also don't think rebasing helps the particular problem under discussion 
(ie conflicts due to having to sort out dependencies between different 
trees), and in some ways hurts it.

One thing that I personally react to is that

 - I think sysfs and the device model layer has had too much churn, and 
   I'm unhappy that people seem to expect that to continue.

   [ NOTE!! I'm picking on the device model/sysfs stuff here not because 
     it's the only one, but because it's the obvious and good example. I 
     do think we have other cases of the same thing. ]

   Really. I do agree that we need to fix up bad designs, but I disagree 
   violently with the notion that this should be seen as some ongoing 
   thing. The API churn should absolutely *not* be seen as a constant 
   pain, and if it is (and it clearly is) then I think the people involved 
   should start off not by asking "how can we synchronize", but looking a 
   bit deeper and saying "what are we doing wrong?"

   It may well be that part of the problem is that the people causing the 
   churn don't realize the downsides of the pain they are causing, because 
   THEY aren't the generally ones that see it!

   For example, it's easy for Greg to change his driver core, and he can 
   obviously synchronize with himself in the other trees (because his left 
   hand is hopefully somewhat aware of what his right hand is doing), so I 
   suspect Greg simply doesn't see the pain that much. So Greg thinks that 
   the solution is to just have me merge his changes early, and the pain 
   is all gone as far as he is concerned.

 - That said, I'm also a bit unhappy about the fact you think all merging 
   has to go through my tree and has to be visible during the two-week 
   merge period. Quite frankly, I think that you guys could - and should - 
   just try to sort API changes out more actively against each other, and 
   if you can't, then that's a problem too.

   In other words, please do use the distributed nature of git to your 
   advantage, when there are things you guys know you need to sort out.

So there are two separate and totally independent issues here.

One is that I suspect some people are a bit too willing to do cleanup for 
its own sake, and do not realize that backwards compatibility does 
actually help too, and that "better solutions" are sometimes worse than 
"keep things stable". We should always *allow* major breakage when 
necessary, but I think the threshold for them should be higher than I 
think it currently is.

The other is that once somebody says "ok, I *really* need to cause this 
breakage, because there's a major bug or we need it for fundamental reason 
XYZ", then that person should

 (a) create a base tree with _just_ that fundamental infrastructure change,
     and make sure that base branch is so obviously good that there is no 
     question about merging it.

 (b) tell other people about the reason for the infrastructure change, and 
     simply allow others to merge it. You don't have to wait for *me* to 
     open the merge window, you need to make sure that the people that get 
     impacted most can continue development!

This is where "rebases really are bad" comes in. When the above sequence 
happens, the fundamental infrastructure change obviously does need to be 
solid and not shifting under from other people who end up merging it. I do 
not want to see five different copies of the fundamental change either 
because the original source fixed it up and rebased it, or because the 
people who merged it rebased _their_ trees and rebased the fundamental 
change in the process.

Can that (b) be my tree? Sure. That's been the common case, and I'll 
happily continue it, of course, so I'm not arguing for that to go away. 
Merging is my job, I'll do it. But when the merge window is a problem, my 
merge window should *not* hold up people from using the distributed nature 
of git for their advantage.

But yes, obviously when doing cross-merges, you'd better be really 
*really* sure that the base is solid and will get merged. But let's face 
it, all the really core maintainers should damn well know that by now: 
you've all worked with me for years, so you should be able to trivially be 
able to tell whether you *might* need to worry about something, and when 
it's a slam dunk.

And it's the "it's a slam dunk" cases that I think are (a) the common ones 
and (b) the ones where you can just do cross-merges to satisfy each others 
needs.

Hmm? Does that sound palatable to people?

			Linus
