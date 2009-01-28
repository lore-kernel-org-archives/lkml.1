Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbZA1SeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbZA1SeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZA1SeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:34:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57293 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZA1SeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:34:16 -0500
Date: Wed, 28 Jan 2009 13:34:13 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, jens.axboe@oracle.com
Subject: Re: Buggy IPI and MTRR code on low memory
In-Reply-To: <20090128102208.68a900cc@infradead.org>
Message-ID: <alpine.DEB.1.10.0901281331130.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <1233161182.10992.52.camel@laptop> <alpine.DEB.1.10.0901281221450.25359@gandalf.stny.rr.com> <20090128102208.68a900cc@infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 28 Jan 2009, Arjan van de Ven wrote:

> On Wed, 28 Jan 2009 12:24:48 -0500 (EST)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > ---
> > I'll have skip the NMI test and see if it locks up any place else.
> 
> if you get an NMI during MTRR changing you are more or less screwed.
> Really. (the cpu is uncachable etc)

Heh, the NMI is just another place that has the IPI problem. A different
issue to the MTRR. Well, same bug, different place.

> 
> the MTRR code should disable NMIs as much as possible.
> 
> and for sure in -RT, the MTRR change section should not be preemptable
> at all.

Yeah, that is why I found this. The current code calls kfree and such from 
the IPI if it is allocated (not to mention the kmalloc in 
smp_call_function. Both of which can sleep in RT. I was forcing the 
data=NULL case in RT to keep it from entering the allocation code paths. 
But this is where I found the deadlock with MTRR (and NMI).

-- Steve

