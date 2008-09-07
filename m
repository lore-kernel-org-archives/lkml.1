Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYIGASU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYIGASU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 20:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYIGASE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 20:18:04 -0400
Received: from r00tworld.com ([212.85.137.21]:49919 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbYIGASD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 20:18:03 -0400
From: pageexec@freemail.hu
To: Ingo Molnar <mingo@elte.hu>
Date: Sun, 07 Sep 2008 02:17:11 +0200
MIME-Version: 1.0
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Reply-to: pageexec@freemail.hu
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Message-ID: <48C31D87.22787.B09E1F6@pageexec.freemail.hu>
In-reply-to: <20080906154215.GA1774@elte.hu>
References: <20080905165239.GA12645@elte.hu>, <48C18A86.22801.4E3EE62@pageexec.freemail.hu>, <20080906154215.GA1774@elte.hu>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Sun, 07 Sep 2008 02:17:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Sep 2008 at 17:42, Ingo Molnar wrote:
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > On 5 Sep 2008 at 18:52, Ingo Molnar wrote:
> > 
> > provided the end user wants/needs to have the whole toolchain on his 
> > boxes at all. how many really do?
> 
> it's minimal and easy. It really works to operate on the source code - 
> this 'open source' thing ;-) We just still tend to think in terms of 
> binary software practices that have been established in the past few 
> decades.

the question wasn't whether it was minimal or easy but whether end users
want to have the toolchain on their production boxes, especially on these
supposedly secure ones. industry wisdom says that they'd rather not.

> > > Can be done in the background after install or so.
> > 
> > it's not only installation time (if you meant 'installing the box' 
> > itself), but every time the kernel is updated, so the toolchain will 
> > be there forever.
> 
> not a problem really, it is rather small compared to all the stuff that 
> is in a typical disto install. I like the fundamental message as well: 
> "If you want to be more secure, you've got to have the source code, and 
> you've got to be able to build it."

the point is not the size of the toolchain, i don't think anyone cares
about that in the days of TB disks. the more fundamental issue is that
the toolchain doesn't normally belong to production boxes and if the
sole reason to have it is this kernel image randomization feature, then
it may not be as easy a sell as you think as there're better alternatives
that work without having the toolchain there.

> > > > [...] and who would look at all the bugreports from such kernels?
> > > 
> > > yes, in this area debuggability is in straight conflict. Since we 
> > > can assume that both attacker and owner has about the same level of 
> > > access to the system, making the kernel less accessible to an 
> > > attacker makes it less accessible/debuggable to the owner as well.
> > 
> > in other words, it's a permanently unsolved problem ;). somehow i 
> > don't see Red Hat selling RHEL for production boxes with the tag 'we 
> > do not debug crashes here because we cannot' attached.
> 
> it's not an unsolvable problem. The debug info can be on a separate box, 
> encrypted, etc. etc - depending on your level of paranoia.

what does having the debug info available in whatever form help you in
the debugging process that doesn't at the same time help an attacker?

remember, the assumption is that the attacker is already on the box (and
as root at that), trying to get his kernel rootkit to work, so you'll
have to come up with a debugging procedure where he can't leverage that
local acccess to pry the debug info out of your hands as you're trying
to diagnose a problem. e.g., you can't just disconnect the box from the
network if you need remote access yourself or reproducing the problem
does.

> The need to 
> debug kernel crashes is a relatively rare event - especially on a box 
> that has such high security constraints, fortunately :-)

how are the security constraints of the box related to its kernel's
susceptibility to crashes/oopes/etc?

> > > well at least in the case of Linux we have a fairly good tally of 
> > > what kernel code is supposed to be executable at some given moment 
> > > after bootup, and can lock that list down permanently until the next 
> > > reboot,
> > 
> > so no module support? [...]
> 
> why no module support? Once the system has booted up all necessary 
> modules are loaded and the ability to load new ones is locked down as 
> well. This also makes it harder to inject rootkits btw. (combined with 
> signed modules - patches exist for that)

and this also makes it impossible to load newer versions of modules,
which will now require a full reboot. i'm sure management will like the
idea ;).

> > [...] what about kprobes and/or whatever else that generates code at 
> > runtime?
> 
> you dont need that in general on a perimeter box. If you need it, you 
> open that locked box with the debug info and make the system more 
> patchable/debuggable - at the risk of exposing same information to 
> attackers (were they gain the same level of access).

so all an attacker needs to do is induce some kernel problems (due to
the underlying assumption, he can easily do that), wait for you guys
come in and have a field day with the debug info? ;)

> > > and give the list to the checker to verify every now and then?
> > 
> > so good-bye to large page support for kernel code? else there's likely 
> > enough unused space left in the large pages for a rootkit to hide.
> > 
> > what if the rootkit finds unused pieces of actual code and replaces 
> > that (bound to happen with those generic distro configs, especially if 
> > you have to go with a non-modular kernel)?
> 
> are you now talking about the randomized kernel image? The whole point 
> why i proposed it was to hide the checking functionality in it, not to 
> make it harder for the attacker to place the rootkit.

i was reflecting to your saying that:

> well at least in the case of Linux we have a fairly good tally of 
> what kernel code is supposed to be executable at some given moment 
> after bootup, and can lock that list down permanently until the next 
> reboot,

and was pointing out that you don't actually have such a good tally unless
you're willing to give up large page support for kernel code, and even if
you go for 4k pages you'll be in trouble because a generic kernel like
those used in distros is bound to have unused regions of code. and i base
this on the assumption that your randomization cannot fundamentally change
function boundaries (i.e., randomizing code placement at the basic block
level) without killing the branch predictor for good. the short of it is
that your list of 'kernel code pages' is useless without ensuring that the
attacker cannot place his code into those same kernel code pages.

> Once the identity of the checking code is randomized reasonably, we can 
> assume it will run every now and then, and would expose any 
> modifications of 'unused' kernel functions. (which the attacker would 
> have to filter out of the randomized image to begin with)

as i indicated at the beginning, you're assuming that the attacker will
try to disable the checking mechanism, whereas he can equally neutralize
it by hiding his modifications to the kernel from the checker. recent years
saw a few academic papers on creating & defeating self-checksumming code,
and from what i recall now, it didn't look too well for the defender side.

> > last but not least, how would that 'lock that list down' work exactly? 
> > what would prevent a rootkit from locating and modifying it as well?
> 
> best would be hardware support for mark-read-only-permanently, but once 
> the checker functionality is reasonably randomized, its data structure 
> can be randomized as well.

what does marking it read-only help when the attacker can just remap the
virtual addresses to some other page under his control? i.e., you want to
lock some TLB entries hard, something not possible on contemporary i386
and amd64. you can sort of simulate it with a hypervisor though but then
you don't need any of this randomization stuff. or in other words, if you
have such a hw capability to mark-read-only-permanently, you might as well
use it for the kernel code itself and not bother with all this 'rootkit
patches kernel' problem.

> > what would you verify on the code? it's obfuscated so you can't really 
> > analyze it (else you've just solved the attacker's problem), all you 
> > can do is probably compute hashes but then you'll have to take care of 
> > kernel self-patching and also protecting the hashes somehow.
> 
> yes, hashes. The point would be to make the true characteristics of the 
> checker a random, per system property. True, it has many disadvantages 
> such as the inevitable slowdown from a randomized kernel image, the 
> restrictions on debuggability, etc. - but it can serve its purpose if 
> someone is willing to pay that price.

the question for the end user is what he gets for that price and whether
he could get it or better for less. as it stands, your idea is both too
expensive and doesn't quite deliver yet, not an easy sell ;).

> best (and most practical) tactics would still be to allow the kernel to 
> be locked down, in terms of not allowing new (non-authorized) kernel 
> code to be executed: signed modules and properly locked down debug APIs, 
> so that the only vector of code insertion is a not yet fixed kernel 
> space security hole.

i thought the whole discussion was about 0-day ;), is there any attacker
that doesn't use that vector to get into the kernel? it's the most generic
method, no need to bother with silly kernel 'protection' features when
exploitable kernels bugs abound (ok, let's not get into that discussion
again ;P).

