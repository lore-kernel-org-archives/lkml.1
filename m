Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbZAIV7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbZAIV7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZAIV65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:58:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48592 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbZAIV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:58:55 -0500
Date: Fri, 9 Jan 2009 22:58:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Message-ID: <20090109215822.GA21613@elte.hu>
References: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 9 Jan 2009, Ingo Molnar wrote:
> > 
> > So, should we not remove CONFIG_OPTIMIZE_INLINING, then the correct one 
> > would be to mark it __always_inline [__asm_inline is senseless there], or 
> > the second patch below that changes the bit parameter to unsigned int.
> 
> Well, I certainly don't want to _remove_ the "inline" like your patch did. 

hm, that was a bug that i noticed and fixed in the second, fuller version 
of the patch i sent - which converts all the 'int nr' instances in 
bitops.h to 'unsigned int nr'.

This is the only instance where the integer type of 'nr' matters in 
practice though, due to the modulo arithmetics. But for cleanliness 
reasons we want to do the full patch, to have a standard type signature 
for these bitop methods.

> Other gcc versions will care. But I committed the pure "change to 
> unsigned" part.

thanks! I'll clean up the rest - the second patch will now conflict 
(trivially). I also wanted to check the whole file more fully, there might 
be other details. [ So many files, so few nights ;-) ]

We also might need more __always_inline's here and in other places, to 
solve the nonsensical inlining problems that Chris's case showed for 
example, with earlier GCCs.

Another option would be to not trust earlier GCCs at all with this feature 
- to only define inline to not-__always_inline only on latest 4.3.x GCC - 
the only one that seems to at least not mess up royally.

Thus CONFIG_OPTIMIZE_INLINING=y would have no effect on older GCCs. That 
would quarantine the problem (and the impact) sufficiently i think. And if 
future GCCs start messing up in this area we could zap the whole feature 
in a heartbeat.

( Although now that we have this feature this gives an incentive to
  compiler folks to tune their inliner on to the Linux kernel - for a 
  decade we never allowed them to do that. The kernel clearly has one of
  the trickiest (and ugliest) inlining smarts in headers - and we never 
  really exposed compilers to those things, so i'm not surprised at all 
  that they mess up in cases.

  Unfortunately the version lifecycle of most compiler projects is
  measured in years, not in months like that of the kernel. There's many
  reasons for that - and not all of those reasons are strictly their
  fault. )

	Ingo
