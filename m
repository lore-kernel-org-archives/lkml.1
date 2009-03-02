Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZCBXul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZCBXul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 18:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbZCBXuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 18:50:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35546 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531AbZCBXuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 18:50:05 -0500
Date: Tue, 3 Mar 2009 00:49:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
Message-ID: <20090302234910.GA17956@elte.hu>
References: <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AC6DEA.2050304@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ingo Molnar wrote:
> >>> So perhaps another approach to (re-)consider would be to go back 
> >>> to atomic fixmaps here. It spends 3 slots but that's no big 
> >>> deal.
> >> Oh, it's a good idea! fixmaps must make it simpler.
> >>
> >>> In exchange it will be conceptually simpler, and will also scale 
> >>> much better than a global spinlock. What do you think?
> >> I think even if I use fixmaps, we have to use a spinlock to protect
> >> the fixmap area from other threads...
> > 
> > that's why i suggested to use an atomic-kmap, not a fixmap.
> 
> Even if the mapping is atomic, text_poke() has to protect pte
> from other text_poke()s while changing code.
> AFAIK, atomic-kmap itself doesn't ensure that, does it?

Well, but text_poke() is not a serializing API to begin with. 
It's normally used in code patching sequences when we 'know' 
that there cannot be similar parallel activities. The kprobes 
usage of text_poke() looks unsafe - and that needs to be fixed.

So indeed a new global lock is needed there.

It's fixable and we'll fixit, but text_poke() is really more 
complex than i'd like it to be.

stop_machine_run() is essentially instantaneous in practice and 
obviously serializing so it warrants a second look at least. 
Have you tried to use it in kprobes?

	Ingo
