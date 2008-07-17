Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbYGQURf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbYGQURf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbYGQURZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:17:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756246AbYGQURY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:17:24 -0400
Date: Thu, 17 Jul 2008 13:16:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ray Lee <ray-lk@madrabbit.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <alpine.LFD.1.10.0807171259010.2959@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807171304220.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org>  <200807170011.12184.rjw@sisk.pl>  <200807161633.01375.jbarnes@virtuousgeek.org>  <487EEAEB.4050009@firstfloor.org>  <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>  <487F71E8.9050705@firstfloor.org> <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com> <487FA24B.9060803@firstfloor.org>
 <alpine.LFD.1.10.0807171259010.2959@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Linus Torvalds wrote:
> 
> In particular, if something worked for somebody before, it also removes 
> the "known good state" from a bisection standpoint, so rebasing actually 
> makes things _harder_ to bisect - because now you cannot sanely bisect 
> between two versions of the tree (when you mark the old tree "good", it 
> has no relevance to the new tree that had all the old history rewritten).

Let me do a made-up example of this just to kind of illustrate the point.

Let's say that _I_ rebased history to always make it linear.

That would obviously make things much "easier" to bisect, since now it's 
just a linear list of commits, and bisection is just taking the midpoint 
of that list and trying it. Right? Also, I'd fix up the linear list so 
that any found bugs are squashed into th code that caused them, so all 
_known_ bugs are non-issues from the standpoint of bisection: because the 
code you are bisecting already has those removed entirely.

That's a clean nice linear history with no unnecessary breakages (no 
compile failures, no other unrelated and solved bugs) for bisection, so 
bisecting new bugs must be much simpler, right?

WRONG.

It means that a person who ran my tree as of yesterday, and had a working 
setup, but then updated to my tree as of today, and things break, can no 
longer bisect sanely AT ALL - because the state that he was at yesterday 
is basically completely *gone*, because it has been cleaned-up and 
sanitized, since I happened to rewrite history from a week ago due to 
finding a bug.

Also, related to the same thing, if that person had some patches of his 
own that he was working on on top of the state I had yesterday, since I 
rebased, it's now almost impossible for him to be able to judge what is 
really _new_ stuff, and what is just the old stuff he was working on, 
except it's been cleaned up and sanitized.

But at the same time, the new history is clearly _simpler_, isn't it? Yes, 
it is simpler, BUT ONLY IF YOU DON'T TAKE INTO ACCOUNT THAT SOMEBODY 
ALREADY SAW AND USED THE _OTHER_ HISTORY YESTERDAY!

I'm shouting, because this is really really important from a very 
fundamental standpoint. It's not just important from a git standpoint: 
this really is _not_ some odd git-specific implementation issue. No, it's 
much much more fundamental than git. It's a very basic fact that woudl be 
true with _any_ SCM.

So git just happens to encode that fundamental truth a bit more explicitly 
and make it very obvious. Git is very careful at _not_ losing that state 
as it existed somewhere yesterday.

So rebasing and cleanups may indeed result in a "simpler" history, but it 
only look that way if you then ignore all the _other_ "simpler" histories. 
So anybody who rebases basically creates not just one simple history, but 
a _many_ "simple" histories, and in doing so actually creates a 
potentially much bigger mess than he started out with!

As long as you never _ever_ expose your rewriting of history to anybody 
else, people won't notice or care, because you basically guarantee that 
nobody can ever see all those _other_ "simpler" histories, and they only 
see the one final result. That's why 'rebase' is useful for private 
histories.

But even then, any testing you did in your private tree is now suspect, 
because that testing was done with the old history that you threw away.  
So even if you delete all the old histories and never show them, they kind 
of do exist conceptually - they existed in the sense that you tested them, 
and you've just hidden the fact that what you release is different from 
what you tested.

		Linus
