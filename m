Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZCYVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZCYVMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZCYVL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:11:59 -0400
Received: from waste.org ([66.93.16.53]:60586 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbZCYVL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:11:58 -0400
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Hua Zhong <hzhong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <49CA935F.8000908@goop.org>
References: <20090325051920.406564281@goodmis.org>
	 <20090325052023.071564146@goodmis.org>
	 <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
	 <009101c9ad20$1ae231c0$50a69540$@com>
	 <1237968394.30175.12.camel@penberg-laptop>
	 <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>
	 <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com>
	 <1237993145.30175.34.camel@penberg-laptop>
	 <alpine.DEB.2.00.0903251103070.5675@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.0903251105030.5675@gandalf.stny.rr.com>
	 <1237997658.2132.193.camel@calx>
	 <alpine.DEB.2.00.0903251227360.5675@gandalf.stny.rr.com>
	 <49CA935F.8000908@goop.org>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 16:09:32 -0500
Message-Id: <1238015372.2132.381.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 13:26 -0700, Jeremy Fitzhardinge wrote:
> Steven Rostedt wrote:
> > Thanks for this info!
> >
> > Although gcc plays a role too. That is, if we have
> >
> > 	if (x)
> > 		do something small;
> >
> > 	do something large;
> >
> >
> > this can be broken into:
> >
> > 	cmp x
> > 	beq 1f
> > 	do something small
> > 1:
> > 	do something large
> >
> > Which plays nice with the cache. But, by adding a unlikely(x), gcc will 
> > probably choose to do:
> >
> > 	cmp x
> > 	bne 2f
> >
> > 1:
> > 	do something large
> >
> > 	ret;
> >
> > 2:
> > 	do something small
> > 	b 1b
> >
> > which hurts in a number of ways.
> >   
> 
> I think that's probably the dominant effect on x86 systems, because 
> Intel doesn't recommend using the branch hint prefixes as far as I can 
> tell (their consumption of icache space outweighs any benefit of priming 
> the predictor).

Yeah, I was actually thinking 'hint' in the gcc sense of adding
unlikely() or not, which results in, say, choosing one code layout vs
the other based on the CPU's cold-cache bias. 

-- 
http://selenic.com : development and support for Mercurial and Linux


