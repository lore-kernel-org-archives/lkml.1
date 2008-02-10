Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYBJIF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYBJIF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 03:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYBJIFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 03:05:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51795 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbYBJIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 03:05:50 -0500
Date: Sun, 10 Feb 2008 00:03:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates
In-Reply-To: <20080209172538.87994c61.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.00.0802092344070.2896@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802092246390.3145@apollo.tec.linutronix.de> <20080209172538.87994c61.randy.dunlap@oracle.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Feb 2008, Randy Dunlap wrote:

> On Sun, 10 Feb 2008 00:24:50 +0100 (CET) Thomas Gleixner wrote:
> 
> > Linus,
> > 
> > please pull the pending x86 updates from:
> > 
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git master
> 
> Hi Thomas,
> can we please get diffstats with git pull requests?

Well, not only that, but I actually pulled it once, then ended up undoing 
my pull, and had to think twice about whether I want to pull it at all.

I do *not* like it when subsystem maintainers start mixing in stuff into 
their subsystem pull that has absolutely _zero_ to do with that subsystem. 
In this case, we have commit 9b706aee7d92d6ac3002547aea12e3eaa0a750ae, 
which calls itself "x86: trivial printk optimizations", but it really has 
nothing AT ALL to do with x86 except that it also did the same things to 
the bogus x86 version of those routines.

The thing is, trying to mix up things like that into a subsystem pull 
means that now I cannot trust the subsystem maintainer as much! And what 
should be a simple "git pull" becomes not just the pull, but also me 
having to then scrounge around in the result to see if I really want to do 
the pull in the first place.

That's the point where the subsystem maintainer just makes me do 
unnecessary extra and stupid work!

In other words: DO NOT DO THINGS LIKE THAT!

That vsnprintf() optimization looks ok, but it really doesn't have 
anything what-so-ever to do with x86, and some of it is rather dubious and 
too clever by half for its own good, for rather little gain. For example, 
we have:

	+/* Works only for digits and letters, but small and fast */
	+#define TOLOWER(x) ((x) | 0x20)

but then later on we have:

	-               if (cp[0] == '0' && toupper(cp[1]) == 'X')
	+               if (cp[0] == '0' && TOLOWER(cp[1]) == 'x')

where we now use that new TOLOWER() macro on a character that is *not* 
guaranteed to be a digit or a letter at all!

Does it work? Yes, it does happen to work. If it's a non-character or a 
non-letter, it will do essentially random things, but it will never turn 
that non-character/letter into 'x' unless it was 'X' or 'x' before. So 
yes, it works, but let's face it, that clever trick saved something like 
two instructions and a branch from a code-path that wasn't really even 
critical!

In general, I don't disagree with being clever. People enjoy tricks like 
that, and I don't really disagree with the patch. That's not the problem I 
have. The problem I have is that I shouldn't be taken by surprise by these 
things, and start having to worry whether I can trust the person who sends 
me mis-labeled patches without even warning me.

So I had this thing in my tree, went out to dinner, came back and decided 
I don't want to pull it after all. Did some other work, and decided I have 
the time to look through it, and then re-pulled it.

But I was *this* close to just deciding that "ok, I'm ready to release the 
-rc1 kernel, I don't need this kind of aggravation" and just decided to 
not bother pulling something dubious.

So Thomas, don't do this. I don't like it. The same way I didn't like 
seeing Ingo trying to mix in a kgdb pull into his x86 pull. Keep these 
things separate - git is *really* good at having multiple branches with 
different lines of development, use it that way (or send odd-ball misc 
patches just as emails).

But it's merged now.

			Linus

PS. And no, maybe I don't always notice. I bet maintainers can slip things 
by me all the time without me waking up to it. The fact that it sometimes 
works doesn't mean that it's a good idea, though - it just means that if I 
catch it, my level of trust goes down. 
