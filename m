Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZFLPfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZFLPfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZFLPfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:35:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZFLPfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:35:24 -0400
Date: Fri, 12 Jun 2009 17:35:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when
	feature is disabled
Message-ID: <20090612153501.GA5737@elte.hu>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612112258.GA14123@elte.hu> <20090612125741.GA6140@localhost> <20090612131754.GA32105@elte.hu> <alpine.LFD.2.01.0906120827020.3237@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906120827020.3237@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 12 Jun 2009, Ingo Molnar wrote:
> > 
> > This seems like trying to handle a failure mode that cannot be 
> > and shouldnt be 'handled' really. If there's an 'already 
> > corrupted' page then the box should go down hard and fast, and 
> > we should not risk _even more user data corruption_ by trying to 
> > 'continue' in the hope of having hit some 'harmless' user 
> > process that can be killed ...
> 
> No, the box should _not_ go down hard-and-fast. That's the last 
> thing we should *ever* do.
> 
> We need to log it. Often at a user level (ie we want to make sure 
> it actually hits syslog, possibly goes out the network, maybe pops 
> up a window, whatever).
> 
> Shutting down the machine is the last thing we ever want to do.
> 
> The whole "let's panic" mentality is a disease.

No doubt about that - and i'm removing BUG_ON()s and panic()s 
wherever i can and havent added a single new one myself in the past 
5 years or so, its a disease.

If a fault hits a harmless piece of the system, then the log message 
will make it out and people know what happened. hwpoison does not 
affect that at all. If the fault hits the critical path towards 
gettig the log message out - then we wont get a log message, 
hwpoison or not.

My point is that hwpoison allows the _ignoring_ of hardware problems 
and thus pushes more buggy hardware up the pipeline.

Clusters will be running with this under the (false IMO) assumption 
that the kernel will tell the admin when something bad happened and 
the machine can limp along otherwise.

So i think hwpoison simply does not affect our ability to get log 
messages out - but it sure allows crappier hardware to be used.
Am i wrong about that for some reason?

	Ingo
