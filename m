Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXL0Kog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXL0Kog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 05:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXL0Ko2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 05:44:28 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2854 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751423AbXL0Ko2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 05:44:28 -0500
Date: Thu, 27 Dec 2007 10:44:14 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Andrew Lutomirski <luto@myrealbox.com>,
       David Newall <david@davidnewall.com>,
       John Reiser <jreiser@bitwagon.com>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
Message-ID: <20071227104414.GB5353@ucw.cz>
References: <47632010.6030709@BitWagon.com> <20071215043208.GF17344@thunk.org> <4766A40D.4080804@BitWagon.com> <20071217173623.GC7070@thunk.org> <476719E5.1010505@myrealbox.com> <20071218030533.GN7070@thunk.org> <47673AD8.9010702@davidnewall.com> <20071218034656.GR7070@thunk.org> <cb0375e10712192018l66671b34r1680077765e89fb0@mail.gmail.com> <20071220203601.GI27081@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220203601.GI27081@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-12-20 15:36:01, Theodore Tso wrote:
> On Wed, Dec 19, 2007 at 11:18:54PM -0500, Andrew Lutomirski wrote:
> > I understand that there's no way that /dev/random can provide good
> > output if there's insufficient entropy.  But it still shouldn't leak
> > arbitrary bits of user data that were never meant to be put into the
> > pool at all.
> 
> Let's be clear here.  It's not arbitrary bits of user data.  It's at
> most three bytes of kernel stack garbage from the process which is
> adding entropy to /dev/random from userspace.  And the attacker
> doesn't get to pick which 3 bytes they are, either!  That means they
> are not "arbitrary bits".
> 
> > (My hypothetical attack is a lot hypothetical than I thought at first.
> >  An attacker does not need to break into the kernel and steal the
> > state of the pool.  It may be as easy as this to trigger:
> > 
> > Step 1: Boot a system without a usable entropy source.
> > Step 2: add some (predictable) "entropy" from userspace which isn't a
> > multiple of 4, so up to three extra bytes get added.
> > Step 3: Read a few bytes of /dev/random and send them over the network.
> 
> So Step 1 assumes a system without a random seed file, or any usable
> entropy source.  As I've mentioned, this means that any cryptographic
> users of /dev/random --- like, say, openssh daemon --- are in deep,
> DEEP, trouble.  This is a very serious problem, and in my opinion, far
> more serious and far more REAL that your hypothetical attack.  So we
> need to address Step 1 anyway, and more urgently.
> 
> In step 2, what program are you expecting will be writing to
> /dev/random?  Very few programs do so today, and none that are
> commonly installed on most Linux distributions, other than the dd
> program run out of /etc/init.d/random to initialize /dev/random from
> the random seed file.  But, oh wait --- you're assuming that doesn't
> exist, even though all major distributions have it.
> 
> Why would a legitimate program read a few bytes of /dev/random and
> send them on the network in step 3?  Or are you assuming your
> hypothetical attacker has a shell account on the system?  In which
> case there is probably far more concerns about information leakage
> than 3 bytes of kernel stack garbage, which might or might not contain
> user data.
> 
> And note that this attack can only be done for 3 bytes.  After that,
> the work factors involved become intractable.
> 
> So yes, there is a theoretical hole given your assumptions, but the
> problem started the "system without any intial entropy", and there are
> far worse problems that result in that case.  So that is the problem
> we should be addressing.
> 
> That being said, write_pool() is hardly a fastpath, and the memset
> isn't going to make any difference.  So if it makes people feel
> better, I don't object to adding it.  I'm just pointing out that the
> assumption is either pretty silly (since all of the distributions do
> use the random seed file, and in practice *someone* has logged into
> the console to add some amount of entropy at some point in the
> machine's lifetime, even it if was when the machine was initially
> installed) and/or points out a more critical issue, which is we need
> to make sure that we do have a reasonable entropy source on all
> machines.

Lets memset. It is not a fastpath, and code will be more obvious that
way.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
