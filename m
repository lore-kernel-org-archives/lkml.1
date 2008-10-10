Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYJJIuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYJJIuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYJJIuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:50:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbYJJIuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:50:01 -0400
Date: Fri, 10 Oct 2008 10:46:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
Message-ID: <20081010084614.GA319@elte.hu>
References: <20081009190405.13A253CB@kernel> <20081009190406.1B257119@kernel> <20081009194350.GA31214@us.ibm.com> <1223585671.11830.40.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223585671.11830.40.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Thu, 2008-10-09 at 14:43 -0500, Serge E. Hallyn wrote:
> > Hmm, I don't know too much about aio, but is it possible to succeed with
> > io_getevents if we didn't first do a submit?  It looks like the contexts
> > are looked up out of current->mm, so I don't think we need this call
> > here.
> > 
> > Otherwise, this is neat.
> 
> Good question.  I know nothing, either. :)
> 
> My thought was that any process *trying* to do aio stuff of any kind 
> is going to be really confused if it gets checkpointed.  Or, it might 
> try to submit an aio right after it checks the list of them.  I 
> thought it best to be cautious and say, if you screw with aio, no 
> checkpointing for you!

as long as there's total transparency and the transition from CR-capable 
to CR-disabled state is absolutely safe and race-free, that should be 
fine.

I expect users to quickly cause enough pressure to reduce the NOCR areas 
of the kernel significantly ;-)

In the long run, could we expect a (experimental) version of hibernation 
that would just use this checkpointing facility to hibernate? That would 
be way cool for users and for testing: we could do transparent kernel 
upgrades/downgrades via this form of hibernation, between CR-compatible 
kernels (!).

distros could mark certain kernels as 'safe fallback' kernels, and if 
say a WARN_ON() or app breakage hits that is suspected to be kernel 
related, the user could hit a 'switch back to safe kernel' button - 
which would switch back _without losing any app state_.

People could even try new versions of the kernel which would just fall 
back to the known-workin safe kernel if the bootup fails for example.

Pie in the sky for sure, but way cool: it could propel Linux kernel 
testing to completely new areas - new kernels could be tried 
non-intrusively. (as long as a new kernel does not corrupt the CR data 
structures - so some good consistency and redundancy checking would be 
nice in the format!)

	Ingo
