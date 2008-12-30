Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYL3IAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYL3IAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYL3IAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:00:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYL3IAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:00:43 -0500
Date: Tue, 30 Dec 2008 09:00:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] tracing/kmemtrace: normalize the raw tracer event to
	the unified tracing API
Message-ID: <20081230080031.GB2455@elte.hu>
References: <4959443f.09a1660a.44f3.2686@mx.google.com> <20081229220937.GC5829@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229220937.GC5829@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Pekka, note that I would be pleased to add statistical tracing on this 
> tracer, but I would need a hashtable, or an array, or a list, or 
> whatever iterable to insert the data into the stat tracing api.

there would be a couple of natural objects to group events by:

	1) callsite [IP] of kmalloc()/kfree()/etc.

	2) slab cache

	3) slab object

for 1) callsite based histograms, i think ftrace should have a built-in 
mechanism for that. kmemtrace tracepoints already pass in a call_site 
argument that can be used to drive it.

for 2) slab cache based histograms (counts) - we need some knowledge about 
the affected slab caches, and we need some space as well. The tracepoints 
could be extended with a kmem_cache argument perhaps. A callback is needed 
at cache creation time (which could be in the form of a tracepoint) that 
gives kernel/tracing/kmemtrace.c the right place to allocate the per slab 
histogram. (so that the other tracepoints dont have to do it implicitly - 
which would be fragile as we are in the SLAB code, often with spinlocks 
taken, so we cannot allocate)

i think 3) is the hardest so lets skip it for now ;-)

	Ingo
