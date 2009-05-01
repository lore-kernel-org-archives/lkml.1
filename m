Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbZEAMka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbZEAMka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZEAMkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:40:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35503 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561AbZEAMkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:40:20 -0400
Date: Fri, 1 May 2009 14:39:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v2] amd64_edac: EDAC module for AMD64
Message-ID: <20090501123956.GA4225@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <87iqknp8a0.fsf@basil.nowhere.org> <20090430115741.GA23634@aftab> <20090430124716.GW23223@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430124716.GW23223@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > Kconfig, mce code delivers needed error info to edac which, in 
> > turn, goes and decodes the error/does the mapping to DIMM 
> > blocks/supplies DRAM error injection facility for testing 
> > purposes and similar things. That way you have both and they 
> > don't overlap in functionality.
> 
> You can do that, but it's redundant because mcelog can do this 
> this already. [...]

The thing is, when we took up x86 maintenance i had a good look at 
the MCE situation, i checked both the kernel and the user-space 
side.

The kernel side MCE code was in pretty bad shape to begin with, but 
mcelog (the user-space tool) is a big stinking pile of poo on every 
level.

It's one of the worst piece of kernel related code i ever saw. I 
think you wrote all of it, and you should be ashamed of that code, 
and you should be ashamed of the design and you should be ashamed of 
the concept.

It even came with its own 'database' code: mcelog*/db.[ch] is 600+ 
lines of needless code instead of obvious library use. It's NIH and 
self-serving complexity all over.

And the thing is, mcelog/mcedecode never really _did_ anything real 
an useful, other than to:

 1) Confuse kernel users who see a fatal MCE panic, with cryptic, 
    quirky codes, who write that down on paper, then run it through 
    the user-space tool - just to see a piece of information the 
    kernel could have provided already. (if they didnt make any 
    mistakes while writing down the codes)

 2) Decode a quirky, binary MCE record and combine it with DMI data.
    (which the kernel can and should do just fine.)

Yes, i know about tolerant=3 and certain people/companies opting to 
ignore MCE fatality levels and live dangerously (and i also know 
about non-fatal reporting and correction extensions in hw) - but for 
99.999% of the Linux users the whole thing is just needless 
complexity today, that does not offer anything valuable.

And that is really what happens when code is misdesigned and the 
wrong pieces of code are pushed to user-space: a crappy, limited ABI 
and an under-maintained, big pile of junk user-space kit.

The obvious truth is that hardware faults have to be caught, decoded 
and optionally handled by the kernel.

The EDAC code at least has a sane design: it realizes that hardware 
faults _must_ be fully known, decoded and potentially handled in the 
kernel.

Piggyback-ing to user-space is plain idiotic and not defensible. So 
if a piece of hardware capability is handled by the EDAC code, the 
x86 MCE code will step aside and will stay the heck out of that 
business. At least until the two concepts are merged into some sane 
kernel hardware fault logging and handling framework.

And Andi, until you dont grasp such _basic_ design concepts, you 
have no business writing such code really. You should stay the heck 
away from it and you should stop 'advising' people who made the 
right calls while you messed up. It is mcelog that is crap, not the 
EDAC code.

	Ingo
