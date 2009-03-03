Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbZCCAAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbZCCAAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbZCCAAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:00:32 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:60679 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322AbZCCAAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:00:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwFABsBrElMQW1W/2dsb2JhbACBWdNYhAYG
Date: Mon, 2 Mar 2009 19:00:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
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
Message-ID: <20090303000027.GB3906@Krystal>
References: <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com> <49AC10E9.1090102@redhat.com> <20090302171914.GB21735@Krystal> <49AC5A87.7000604@redhat.com> <20090302222254.GA31962@elte.hu> <49AC63FA.70801@redhat.com> <20090302230915.GA11626@elte.hu> <49AC6DEA.2050304@redhat.com> <20090302234910.GA17956@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090302234910.GA17956@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:58:15 up 2 days, 20:24,  3 users,  load average: 0.71, 0.61,
	0.57
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Ingo Molnar wrote:
> > >>> So perhaps another approach to (re-)consider would be to go back 
> > >>> to atomic fixmaps here. It spends 3 slots but that's no big 
> > >>> deal.
> > >> Oh, it's a good idea! fixmaps must make it simpler.
> > >>
> > >>> In exchange it will be conceptually simpler, and will also scale 
> > >>> much better than a global spinlock. What do you think?
> > >> I think even if I use fixmaps, we have to use a spinlock to protect
> > >> the fixmap area from other threads...
> > > 
> > > that's why i suggested to use an atomic-kmap, not a fixmap.
> > 
> > Even if the mapping is atomic, text_poke() has to protect pte
> > from other text_poke()s while changing code.
> > AFAIK, atomic-kmap itself doesn't ensure that, does it?
> 
> Well, but text_poke() is not a serializing API to begin with. 
> It's normally used in code patching sequences when we 'know' 
> that there cannot be similar parallel activities. The kprobes 
> usage of text_poke() looks unsafe - and that needs to be fixed.
> 
> So indeed a new global lock is needed there.
> 
> It's fixable and we'll fixit, but text_poke() is really more 
> complex than i'd like it to be.
> 
> stop_machine_run() is essentially instantaneous in practice and 
> obviously serializing so it warrants a second look at least. 
> Have you tried to use it in kprobes?
> 
> 	Ingo

This is why I prepared 

text-edit-lock-architecture-independent-code.patch
text-edit-lock-kprobes-architecture-independent-support.patch

A while ago. I'll post them right away.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
