Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbYBNTBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbYBNTBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbYBNTBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:01:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971AbYBNTBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:01:15 -0500
Date: Thu, 14 Feb 2008 20:00:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: pageexec@freemail.hu
Cc: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Message-ID: <20080214190050.GA32258@elte.hu>
References: <20080214170058.GA2043@elte.hu> <47B49384.23437.F8FB16A@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B49384.23437.F8FB16A@pageexec.freemail.hu>
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


* pageexec@freemail.hu <pageexec@freemail.hu> wrote:

> the commit comment says:
> 
> > This hack was true up to the point the stackprotector added another 
> > word to the stack frame. Shifting all the addresses by 8 bytes, 
> > crashing and burning any exec attempt.
> 
> actually, that's not the problem here because the canary is in the 
> local variable area, it doesn't affect the passed arguments. what 
> happens here is that gcc treats the argument area as owned by the 
> callee, not the caller and is allowed to do certain tricks. for ssp it 
> will make a copy of the struct passed by value into the local variable 
> area and pass *its* address down, and it won't copy it back into the 
> original instance stored in the argument area.
> 
> so once sys_execve returns, the pt_regs passed by value hasn't at all 
> changed and its default content will cause a nice double fault (FWIW, 
> this part took me the longest to debug, being down with cold didn't 
> help it either ;).

heh, indeed :-) I saw the double fault and was happy that you showed how 
to fix it (it did not seem obvious to me _at all_, and i've seen my fair 
share of fixes) and i quickly lured myself into having understood it :-/ 

I've now updated the commit message with your (correct) description.

> > Note: this means that we call __switch_to() [and its sub-functions] 
> > still with the old canary, but that is not a problem, both the 
> > previous and the next task has a high-quality canary. The only 
> > (mostly academic) disadvantage is that the canary of one task may 
> > leak onto the stack of another task, increasing the risk of 
> > information leaks, were an attacker able to read the stack of 
> > specific tasks (but not that of others).
> 
> the best practical defense against leaking the canary is to change its 
> value on every syscall but it has some performance impact in 
> microbenchmarks.

yeah, that's not really practical (especially as it would deplete our 
entropy pool pretty fast would could in some circumstances introduce a 
higher risk to the system than the risk of a canary leaking).

I think we can avoid the leakage across tasks by being careful during 
context-switch time: never calling with the old canary still in the PDA. 
I think this should be fairly easy as we'd just have to load the new 
pdaptr in the switch_to() assembly code.

[ the only (even more academic) possibility here would be an NMI to hit
  during those two instructions that update RSP and load the new pdpptr,
  and leaving the old canary on the stack. But NMIs go to separate stack
  frames anyway on 64-bit so this isnt really a practical worry IMO. ]

Hm?

> >   x86: stackprotector: mix TSC to the boot canary
> 
> this should probably be implemented in a general get_random_long() 
> function...

yeah ... this is the second time i could have used it recently.

> >   x86: test the presence of the stackprotector
> >   x86: streamline stackprotector
> 
> the config comment says -fstack-protector whereas you're really 
> enabling the stonger -fstack-protector-all feature (without the latter 
> the ssp test function sample_stackprotector_fn wouldn't even be 
> instrumented ;-).

yeah, indeed. I fixed the comments and flipped the commits around :-)

TODO: perhaps all vsyscall functions need to move into separate .o 
files. (probably academic as the functions affected by that tend to be 
very simple and do not deal with anything overflowable.)

	Ingo
