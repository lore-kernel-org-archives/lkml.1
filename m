Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYLSXfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYLSXfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYLSXfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:35:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47813 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYLSXe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:34:59 -0500
Date: Sat, 20 Dec 2008 00:34:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
	tracing_reset_online_cpus() helper)
Message-ID: <20081219233443.GC17984@elte.hu>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi> <20081219225717.GK13409@elte.hu> <alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > hm, that ftrace behavior is silly. Steve, i think i mentioned this a 
> > long time ago and i thought it got fixed? Changing the ring buffer 
> > size is a slow op, it should include an implicit reset and should be 
> > plug-and-play with no dependencies of having to stop the trace or 
> > something.
> 
> I think you are referencing a different issue, where we passed in a NULL 
> buffer pointer and expected it to be resized. I still think that should 
> not return a success, but that's a different issue altogether.
> 
> Before the ring buffer, the only safe way to resize the buffer was to 
> switch the tracer to none (aka nop).  Now, the only thing you need to do 
> is disable tracing. This is probably a good thing since it forces the 
> user to stop tracing, otherwise the tracing will stop during the resize 
> anyway, and the user will wonder why they lost data.

uhm, the user just resized the buffer - he will not be wondering about any 
impact.

And that's why we should do a full reset: that makes it abundantly clear 
what happened. We shouldnt pretend to be able to do something (seemless, 
lightweight buffer size change with no visible impact) which we obviously 
cannot reliably offer.

Buffer resize is a slow op, and everyone realizes that. Most people will 
in fact say: "hey, I didnt even need to reboot to change the trace buffer 
size, cool!".

The current "only allow resizing while tracing is disabled" is an 
unintuitive and counterproductive restriction - a borderline bug in fact.

	Ingo
