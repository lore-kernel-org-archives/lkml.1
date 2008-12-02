Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYLBRCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYLBRCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 12:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYLBRCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 12:02:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334AbYLBRCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 12:02:20 -0500
Date: Tue, 2 Dec 2008 09:01:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: About git-bisect (was: Linux 2.6.28-rc7)
In-Reply-To: <49356274.6080400@diamondcut.com.br>
Message-ID: <alpine.LFD.2.00.0812020845500.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda> <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org> <20081202165637.09984819@varda> <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
 <49356274.6080400@diamondcut.com.br>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Renato S. Yamane wrote:
>
> Linus Torvalds wrote:
> > Just do
> > 
> > 	git bisect start
> > 	git bisect bad v2.6.27
> > 	git bisect good v2.6.28-rc6-00007-ged31348
> > 
> > and off you go. That would help enormously.
> 
> Hi Linus, is possible plan something to make faster and easier the way
> to loking for a specific bug?

Well, normally 'git bisect' is pretty optimal, if you don't have "extra" 
information. 

> E.g: <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/110784>
> 
> In this bug, I think that it appear after ~2.6.22, so is necessary do a 
> git-bisect more than 13 times!

Well, thirteen kernel compiles and bootups may feel really painful, and I 
agree that it's not exactly pleasant, but considering that there's almost 
ten _thousand_ commits there, isnt' it nice to only have to test 13 
kernels?

> I need more than 20min to compile each kernel, so is necessary ~260min.
> 
> My wife will kill me if I says: Hey baby, wait 260min to me compile a
> lot of kernel here.

heh. It will probably take a lot longer than 260 min, if only because you 
need to reboot and test. And yes, it's painful.

You _can_ speed it up if you already have a good clue about where the bug 
is, and if you know which files/directories are involved, you can give 
that pathname list to "git bisect start". IOW, you can do things like

	git bisect start drivers/acpi arch/x86/kernel/acpi

if you are _sure_ that it's really an ACPI issue, for example. But let me 
be honest: about 50% of the time people have ever tried this, their guess 
has actually turned out to be wrong, and they actually caused _more_ time 
to be wasted rather than less. Which is why I do not generally ever 
suggest using this mode, even if it's better "in theory".

There's another way you can speed up bisection if you have a guess about 
_when_ it happened (as opposed to where). What you can do, is that when 
"git bisect" runs and gives you a suggested commit to compile, you can 
decide that you actually have a better idea, and use "git reset <mycommit>" 
instead to say "I want to test at _this_ point instead, to narrow it down 
faster".

However, as with the path-based one, in order for this to actually speed 
up bisection, you really need to guess right - and you need to understand 
how bisection works. You don't want to guess at the bad commit - instead, 
you want to guess at a commit that _limits_ the set of commits to be 
tested to the bad one in an optimal way.

IOW rather than doing 13 tries, what you can do if you suspect a 
particular range of commits is to first try a commit just before that 
range (on the assumption that it will be good), and then if that worked 
out, try a commit just after the range (on the guess that it will be bad), 
and now you may have cut down the guesses from ten thousand to just a 
couple of hundred with just two tries.

Of course, again - if your guesses were bad, you effectively screwed up 
the 'log2(n)' behavior of "git bisect", and instead of 13 tries you 
probably now have 14 or 15 instead, because your two first tries were just 
not very helpful, and lessened the number of commits to try by much less 
than half each.

The good news, of course, is that if multiple people see the same bug, you 
can actually distribute the bisection load across machines. That works 
only if it is really guaranteed to be the same bug, of course. And it 
won't make it possible to do things in parallel (since each bisection is 
still dependent on the result from the previous one), but it means that 
even if you decide that "13 bisections is too much", if you just do four 
or five, and tell others about your results, now somebody else who thinks 
that they have the same issue can at least start from your range.

Again, that actually requires that people udnerstand how bisection works, 
although it can be done blindly by people just doing "git bisect replay" 
and just assuming that they really see exactly the same issue.

			Linus
