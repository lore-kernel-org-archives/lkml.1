Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZAFQ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZAFQ4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZAFQ4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:56:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52684 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZAFQ4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:56:38 -0500
Date: Tue, 6 Jan 2009 17:56:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Message-ID: <20090106165615.GA5168@elte.hu>
References: <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain> <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain> <20090106165409.GA32608@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106165409.GA32608@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> One thought:
> 
> BUG_ON()'s do_exit() shows a slightly misleading failure pattern to 
> users: instead of a 'hanging' task, we'd get a misbehaving app due to 
> one of its tasks exiting spuriously. It can even go completely unnoticed 
> [users dont look at kernel logs normally] - while a hanging task 
> generally does get noticed. (because there's no progress in processing)
> 
> So instead of the BUG_ON() we could emit a WARN_ONCE() perhaps, plus not 
> do any spinning and just block - resulting in an uninterruptible task 
> (that the user will probably notice) and a scary message in the syslog? 
> [all in the slowpath]

And we'd strictly do an uninterruptible sleep here, unconditionally: even 
if this is within mutex_lock_interruptible() - we dont want a Ctrl-C or a 
SIGKILL to allow to 'break out' the app from the deadlock.

	Ingo
