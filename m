Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYIFPmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYIFPmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYIFPmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:42:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55475 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYIFPmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:42:35 -0400
Date: Sat, 6 Sep 2008 17:42:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080906154215.GA1774@elte.hu>
References: <20080905165239.GA12645@elte.hu> <48C18A86.22801.4E3EE62@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C18A86.22801.4E3EE62@pageexec.freemail.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> On 5 Sep 2008 at 18:52, Ingo Molnar wrote:
> 
> > * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> > 
> > > > i think Linux is fundamentally different here as we have the source 
> > > > code, and could apply the randomization technique i mentioned:
> > > 
> > > how's that supposed to work for the binary distros, i.e., the majority 
> > > of end users? [...]
> > 
> > it takes less than 10 minutes to build a full kernel on recent hardware. 
> 
> provided the end user wants/needs to have the whole toolchain on his 
> boxes at all. how many really do?

it's minimal and easy. It really works to operate on the source code - 
this 'open source' thing ;-) We just still tend to think in terms of 
binary software practices that have been established in the past few 
decades.

> > Can be done in the background after install or so.
> 
> it's not only installation time (if you meant 'installing the box' 
> itself), but every time the kernel is updated, so the toolchain will 
> be there forever.

not a problem really, it is rather small compared to all the stuff that 
is in a typical disto install. I like the fundamental message as well: 
"If you want to be more secure, you've got to have the source code, and 
you've got to be able to build it."

> > > [...] and who would look at all the bugreports from such kernels?
> > 
> > yes, in this area debuggability is in straight conflict. Since we 
> > can assume that both attacker and owner has about the same level of 
> > access to the system, making the kernel less accessible to an 
> > attacker makes it less accessible/debuggable to the owner as well.
> 
> in other words, it's a permanently unsolved problem ;). somehow i 
> don't see Red Hat selling RHEL for production boxes with the tag 'we 
> do not debug crashes here because we cannot' attached.

it's not an unsolvable problem. The debug info can be on a separate box, 
encrypted, etc. etc - depending on your level of paranoia. The need to 
debug kernel crashes is a relatively rare event - especially on a box 
that has such high security constraints, fortunately :-)

> > well at least in the case of Linux we have a fairly good tally of 
> > what kernel code is supposed to be executable at some given moment 
> > after bootup, and can lock that list down permanently until the next 
> > reboot,
> 
> so no module support? [...]

why no module support? Once the system has booted up all necessary 
modules are loaded and the ability to load new ones is locked down as 
well. This also makes it harder to inject rootkits btw. (combined with 
signed modules - patches exist for that)

> [...] what about kprobes and/or whatever else that generates code at 
> runtime?

you dont need that in general on a perimeter box. If you need it, you 
open that locked box with the debug info and make the system more 
patchable/debuggable - at the risk of exposing same information to 
attackers (were they gain the same level of access).

> > and give the list to the checker to verify every now and then?
> 
> so good-bye to large page support for kernel code? else there's likely 
> enough unused space left in the large pages for a rootkit to hide.
> 
> what if the rootkit finds unused pieces of actual code and replaces 
> that (bound to happen with those generic distro configs, especially if 
> you have to go with a non-modular kernel)?

are you now talking about the randomized kernel image? The whole point 
why i proposed it was to hide the checking functionality in it, not to 
make it harder for the attacker to place the rootkit.

Once the identity of the checking code is randomized reasonably, we can 
assume it will run every now and then, and would expose any 
modifications of 'unused' kernel functions. (which the attacker would 
have to filter out of the randomized image to begin with)

> last but not least, how would that 'lock that list down' work exactly? 
> what would prevent a rootkit from locating and modifying it as well?

best would be hardware support for mark-read-only-permanently, but once 
the checker functionality is reasonably randomized, its data structure 
can be randomized as well.

> > Such a verification pass certainly wouldnt be cheap though: all 
> > kernel pagetables have to be scanned and verified, plus all known 
> > code (a few megabytes typically), and the key CPU data structures.
> 
> what would you verify on the code? it's obfuscated so you can't really 
> analyze it (else you've just solved the attacker's problem), all you 
> can do is probably compute hashes but then you'll have to take care of 
> kernel self-patching and also protecting the hashes somehow.

yes, hashes. The point would be to make the true characteristics of the 
checker a random, per system property. True, it has many disadvantages 
such as the inevitable slowdown from a randomized kernel image, the 
restrictions on debuggability, etc. - but it can serve its purpose if 
someone is willing to pay that price.

best (and most practical) tactics would still be to allow the kernel to 
be locked down, in terms of not allowing new (non-authorized) kernel 
code to be executed: signed modules and properly locked down debug APIs, 
so that the only vector of code insertion is a not yet fixed kernel 
space security hole.

	Ingo
