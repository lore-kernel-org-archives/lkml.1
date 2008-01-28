Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbYA1TCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbYA1TCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbYA1TCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:02:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbYA1TCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:02:24 -0500
Date: Mon, 28 Jan 2008 20:01:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Jacob Shin <jacob.shin@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH 2/5] x86: fix runtime error in
	arch/x86/kernel/cpu/mcheck/mce_amd_64.c
Message-ID: <20080128190149.GA24424@elte.hu>
References: <20080127233751.GA4524@kroah.com> <1201477122-4541-2-git-send-email-gregkh@suse.de> <20080128122434.GA24757@elte.hu> <20080128173706.GA17495@suse.de> <20080128175736.GC22487@elte.hu> <20080128183237.GA19829@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128183237.GA19829@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> > Are kobjects protected against accidental copying? If not add &kobj 
> > to the 'magic value' too, and check that - it becomes 
> > copying-resistent that way and has the same cost to check. (which is 
> > negligible anyway)
> 
> Oh, that's a very cool idea, I like it :)

hey, you are welcome :-)

[ I guess i should not mention that i've implemented list debugging for 
  Linux that checksums the struct list contents and stores the checksum 
  in it (offset by a magic value plus to address of the list head), and 
  thus protects it against accidental corruption? It was capable of 
  reliably detecting mixed up list_add() arguments for example, it 
  detected list corruption of _every_ sort, it detected double
  list_del() and list_add() of an already active list member as well. It
  was even capable of detecting SMP races: two parallel unserialized
  list_del()'s on the same list head were detected and warned about as 
  well. I guess i should release it one of these days? =B-) ]

> So I guess the complaint is that CONFIG_KOBJECT is too verbose?  I can 
> understand that, I'll look to clean things up as we have a lot of 
> "tracing" type functions in the debug output.  Hm, I wonder if the new 
> marker code could help with that...

that would certainly be helpful and nice as a second line of defense. 
(as a second line of defense the DEBUG_KOBJECT stuff was pretty 
effective as well, as you have shown it with this bug.)

but the "first line of defense" must be an as automatically and as 
transparently fault-resilient data structure as humanly possible.

"please enable DEBUG_KOBJECT and send me the logs" reduces the active 
tester base to somewhere around 0.1% of the full tester base - and if 
the bug is in any way spurious, the tester base goes down to 0.001% or 
down to outright zero.

i really think that in terms of central kernel data structures, no 
amount of debugging infrastructure is "too much" (within taste limits) - 
as long as it's cleanly structured. Even 10,000 lines of debugging code 
dwarves the 9,000,000 lines of code that it ultimately covers.

> > For example locks currently have 4000 lines of code of debugging 
> > infrastructure and 1500 lines of code of self-tests. The total 
> > amount of core locking code is less 1000 lines of code. So for every 
> > line of locking code there's more than 5 lines of debugging 
> > infrastructure (!).
> 
> Heh, good point, I'll look into fixing this up to be more useful to 
> the "normal" developer, and not just the two of us doing kobject core 
> development :)

you are right, that is another important argument: meaningful debugging 
checks that catch difficult to debug problems speed up development and 
allows one to iterate the codebase faster. As long as the debugging 
checks are transparent (i.e. they have no outrageous false positive rate 
and they do not spam the logs), distros and testers will happily enable 
it and you'll get much more feedback than you ever imagined would be 
possible.

Time is precious, even if you know what you are doing, so the more of 
the debugging you are capable of pushing to the computer, the better. 
Even if some debugging levels are as outrageously expensive as "iterate 
the linear list of all kobjects in the system, for every kobject op", 
people will still be happy to turn it on, if it catches bugs. Attach a 
nice WARN_ON_ONCE() to it and kerneloops.org will pick it up and 
categorize it for you to check. And i think that's an important effort 
for core subsystem maintainers: for example i spent far more time 
writing debugging code for mutexes and other locks than i spent time 
writing the facilities themselves. Preventing a certain category of bugs 
is far more important to users than shaving off 1 cycle from a fastpath.

	Ingo
