Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbZDJL1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbZDJL1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZDJL1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:27:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbZDJL1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:27:08 -0400
Date: Fri, 10 Apr 2009 13:25:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090410112546.GD21506@elte.hu>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410104648.GA31516@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> On Fri 2009-04-10 12:39:34, Ingo Molnar wrote:
> > 
> > * Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > Hi!
> > > 
> > > > x86, setup: "glove box" BIOS calls -- infrastructure
> > > > 
> > > > Impact: new interfaces (not yet used)
> > > > 
> > > > For all the platforms out there, there is an infinite number of buggy
> > > > BIOSes.  This adds infrastructure to treat BIOS interrupts more like
> > > > toxic waste and "glove box" them -- we switch out the register set,
> > > > perform the BIOS interrupt, and then restore the previous state.
> > > > 
> > > > LKML-Reference: <49DE7F79.4030106@zytor.com>
> > > > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > > Cc: Pavel Machek <pavel@ucw.cz>
> > > 
> > > Sounds quite sane. Disadvantage is that we will no longer detect 
> > > those buggy BIOSen.
> > 
> > I'd call that an advantage: sandboxing BIOS calls as much as we can 
> > and trusting all data from it as if it were a random packet from the 
> > Internet is the only sane way forward IMHO.
> 
> Well, difference is that you can defend against arbitrary network 
> packet, but you can't defend against arbitrarily broken BIOS. If 
> it loops forever, or overwrites random memory place, we lost...

We could protect against random memory corruption too, if it ever 
became a widespread problem: by executing the BIOS call in a virtual 
machine. (We can probably use the KVM code to properly emulate big 
real mode, etc.)

That way we can monitor and warn about any undue access patterns.

The solution Peter did here sandboxes the CPU context: which was 
observed to be randomly corrupted by BIOSen and depending on 
register layout details of other OSs (Windows mostly) it might not 
have caused trouble there.

Memory corruption would be noticed under Windows too, so while it 
does show up every now and then, it rarely remains unfixed. Register 
corruptions will stay unfixed forever if they dont affect Windows 
(which they often dont) - so these are far more of a priority to 
sandbox.

> > If we really care we could put in checks for unexpected register 
> > state changes ... but is it worth the trouble?
> 
> So maybe we do need to cooperate with BIOS people, making them fix 
> their code. Checking for unexpected changes would certainly be 
> good idea for firmware testing kit... and it would probably make 
> sense to complain during regular boot, too.

"BIOS people" are operating in a completely different culture. Time 
to market, hardware workarounds, short-term differentiators, secret 
bootstrap sequences and code compactness are king in that space. 
Code quality is dead last in the list. I strongly doubt that given 
the radically conflicting priorities a reasonable dialogue can be 
established.

Reasonable dialogue could be established with efforts that turn 
Linux into a replacement of the firmware: CoreBoot a'ka LinuxBIOS. 
Having an end-to-end Linux solution for all things bootstrap is a 
very strong concept IMHO. For various reasons that relationship is 
not unstrained either, unfortunately.

	Ingo
