Return-Path: <linux-kernel-owner+w=401wt.eu-S1765330AbZLQVPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765330AbZLQVPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765228AbZLQVPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:15:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765225AbZLQVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:15:02 -0500
Date: Thu, 17 Dec 2009 13:14:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alain Knaff <alain@knaff.lu>
cc: markh@compro.net, fdutils@fdutils.linux.lu, linux-kernel@vger.kernel.org
Subject: Re: DMA cache consistency bug introduced in 2.6.28 (Was: Re: [Fdutils]
 Cannot format floppies under kernel 2.6.*?)
In-Reply-To: <4B2A98BB.5080406@knaff.lu>
Message-ID: <alpine.LFD.2.00.0912171256560.15740@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B26B031.4060301@compro.net> <4B26BAE3.2090408@knaff.lu> <4B275975.8040509@cfl.rr.com> <4B275B18.80704@knaff.lu> <4B275D37.4090807@cfl.rr.com> <4B2761E9.2030301@knaff.lu> <4B276513.6030509@cfl.rr.com>
 <4B276753.80807@knaff.lu> <4B27983F.5090600@compro.net> <4B27EF18.7050101@knaff.lu> <4B28FDEB.3030800@compro.net> <4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net> <4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu>
 <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net> <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu>
 <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu> <alpine.LFD.2.00.0912170916420.15740@localhost.locald! omain> <4B2A98BB.5080406@knaff.lu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Alain Knaff wrote:
> 
> For the moment, I have a very small sample of hardware:
> 1. One machine which works (my own): Athlon XP 1800+ processor
> 2. One which doesn't work (Mark's)

Ok. I don't think I even have any machines with floppy drives any more 
(one external USB drive somewhere gathering dust just in case I ever 
encounter a floppy again).

> I might get access to a wider sample of boxen in a week or so, in order
> to do some stats.

Ok, I was more thinking "we have a bugzilla with ten different people 
reporting this". If it's just a single machine, that's not going to be 
relevant.

> What's the easiest way to find out the chipset?
> 
> Here's already the output of lspci from my machine (works):
> 
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host Bridge
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8235 PCI Bridge
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge

Yeah, lspci (and generally only the northbridge and southbridge matters, 
the "ISA bridge" might technically be relevant, but since it's universally 
on the same die as the southbridge, I left it in there just for kicks).

> (It happens during formatting the floppy drive: here the first byte
> happens to be the trackid of the first physical sector of the track, and
> it always ends up being the track of the *previously* formatted track).

I guess it could simply be a floppy controller bug too, triggered by some 
random timing difference or innocuous-looking change.

> > But I think we'd like to see a list of hardware where this can be 
> > triggered,
> 
> We'll get a list of 2 machines relatively quickly (unless other people
> would like to chime in: the test is easy, just fdformat a floppy disk),
> and more in a week or so.

Only the "it doesn't work on xyz" is likely interesting. The machines it 
works on are probably uninteresting statistically.

> > and quite frankly, a 'git bisect' would be absolutely wonderful 
> 
> How exactly would I use this (command line sample)?

You'd need a git tree that contains both the working and non-working 
versions, and then literally just do

	git bisect start
	git bisect good <known good version number here>
	git bisect bad <known bad version here>

and it will give you a commit to try. Compile, test, see if it's good or 
bad, and do

	git bisect [good|bad]

depending on the result. Rinse and repeat (depending on how tight the 
initial good/bad commits were, it will need 10-15 kernel tests).

So in this case, since apparently 2.6.27.41 is good, and 2.6.28 is not, it 
would be something like this:

	# clone hpa's tree that has all the stable releases in one place
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git

	cd linux-2.6-allstable
	git bisect start
	git bisect bad v2.6.28
	git bisect good v2.6.27.41

and off you go.

NOTE! Bisection depends very much on the bug being 100% reproducible. If 
you ever mark a good kernel bad (because you messed up) or a bad kernel 
good (because the bug wasn't 100% reproducible, so you _thought_ it was 
good even though the bug was present and just happened to hide), the end 
result of the bisect will be totally unreliable and seriously screwed up.

So after a successful bisect, it is usually a good idea to try to go back 
to the original known-bad kernel, and then revert the commit that was 
indicated as the bad one (assuming the revert works - it could be that the 
bad one ends up being fundamental to other commits after it), and test 
that yes, that really fixes the bug.

It gets more complicated if the bisect hits kernels that you can't test 
because they have _unrelated_ issues on that machine (compile failures or 
just other bugs that hide the actual floppy behavior), but generally 
bisection is pretty simple. "man git-bisect" does have some extra 
pointers.

So git bisect may be somewhat time-consuming and mindless, but for 
reliably triggering bugs where nobody really knows what caused the bug it 
is a _really_ convenient thing to do. The only thing you need is a 
reliably triggering test-case, and some time.

			Linus
