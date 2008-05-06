Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbYEFOjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbYEFOjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762418AbYEFOjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:39:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762291AbYEFOje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:39:34 -0400
Date: Tue, 6 May 2008 16:39:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, zdenek.kabelac@gmail.com
Subject: Re: [PATCH REPOST^3] Run IST traps from user mode preemptive on
	process stack
Message-ID: <20080506143920.GA26281@elte.hu>
References: <20080502091948.GA26099@basil.nowhere.org> <alpine.LFD.1.10.0805061305460.3318@apollo.tec.linutronix.de> <87skwvbn4m.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skwvbn4m.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

[...]
> Well it was worked around, not properly fixed. This patch fixes it 
> properly. The problem of the original workaround is that it wouldn't 
> print the vma now in many cases because it couldn't take the 
> semaphore.

huh? While this issue is dwarfed by the security hole your patch 
introduces, you miss the whole point about debug printouts in case of 
traps.

In practice we dont need to print out _anything_ from int3 traps (even 
if they were unexpected) - user-space very much knows it has set a 
breakpoint.

What we are interested in are the segmentation faults for example. Those 
do get printed out correctly as segmentation faults do not go via IST 
traps, they go via the normal process stack.

Furthermore, we _do_ print out the fault location even for int3 if we 
are not preemptible. An example i just triggered on latest -git:

  int3[2789] trap int3 ip:4004cd sp:7fff27501c50 error:0

And we do print out the vma information too in other, much more 
interesting trap types such as unresolved page faults:

  segfault[2652]: segfault at 0 ip 400471 sp 7fff05d42480 error 6 in segfault[400000+1000]

So what we do worst-case is that we do not do a find_vma() and we dont 
print out the vma. Not a big deal at all for an int3 or a hw-breakpoint 
trap ...

	Ingo
