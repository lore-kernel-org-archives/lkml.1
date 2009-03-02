Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbZCBSoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbZCBSoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZCBSoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:44:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755679AbZCBSoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:44:23 -0500
Date: Mon, 2 Mar 2009 10:42:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC][PATCH] x86: make text_poke() atomic
In-Reply-To: <20090302102841.7e099670@infradead.org>
Message-ID: <alpine.LFD.2.00.0903021035560.3111@localhost.localdomain>
References: <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com> <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com>
 <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com> <49A82851.5080707@redhat.com> <20090227180724.GA17947@Krystal> <49A83237.40604@redhat.com> <20090227185316.GA19811@Krystal> <49A853CD.3020607@redhat.com>
 <49AC10E9.1090102@redhat.com> <20090302102841.7e099670@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Mar 2009, Arjan van de Ven wrote:
> 
> .... but text_poke() realistically needs to call stop_machine() since
> you can't poke live code.... so that makes me wonder how useful this
> is...

Well, not always. There's at least two cases where we don't need it:

 - in the UP -> SMP transition.

 - perhaps more interestingly, we're still kind of waiting for the 
   resolution of the whole "nop out the first byte to a single-byte 'irq3' 
   trap instruction, then rewrite the rest of the instruction, and then 
   reset the first byte of the final instruction" thing.

IOW, there are possible non-stop_machine() models where rewriting 
instructions in a live system does work, and quite frankly, I think we 
need them. Making the rule be the (obviously safe) "we can only do this in 
stop_machine" is quite possibly not going to be an acceptable rule and we 
may need alternatives.

			Linus
