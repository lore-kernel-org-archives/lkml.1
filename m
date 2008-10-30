Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbYJ3Shf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbYJ3Shf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYJ3Sh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:37:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53863 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531AbYJ3ShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:37:25 -0400
Date: Thu, 30 Oct 2008 19:37:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Message-ID: <20081030183714.GA17822@elte.hu>
References: <490A08E3.2040201@gmail.com> <20081030182056.GA14102@elte.hu> <c62985530810301130q41cc5c0ete2d7610d2172775@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810301130q41cc5c0ete2d7610d2172775@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/10/30 Ingo Molnar <mingo@elte.hu>:
> > hm, are you aware of the -finstrument-functions feature of GCC?
> >
> > that feature generates such entry points at build time:
> >
> >                   void __cyg_profile_func_enter (void *this_fn,
> >                                                  void *call_site);
> >                   void __cyg_profile_func_exit  (void *this_fn,
> >                                                  void *call_site);
> 
> Oh I didn't know it.
> But wouldn't it conflict with the -pg used for mcount in ftrace?

i dont think the two can be enabled at once. If then it would replace 
the mcount stuff. (but the principle is very similar)

I'm wondering whether it's worth it though.

> > this might be faster/cleaner than using a trampoline approach IMO.
> 
> Yes, oubviously!
> 
> > OTOH, entry+exit profiling has about double the cost of just entry
> > profiling - so maybe there should be some runtime flexibility there.
> > Plus the same recordmcount trick should be used to patch up these
> > entry points to NOP by default.
> 
> Yes that's right. Hm I don't know what to do since there is already 
> mcount....

just dont use -pg, only use -finstrument-functions.

when i wrote my first mcount tracer many eons ago i knew about 
-finstrument-functions and decided against it based on the fact that 
it doubles the cost of profiling.

OTOH, dyn-ftrace changes the picture dramatically, with its NOP 
insertion and opt-in tricks. Still, one more 5-byte NOP in every 
function is still something not to be done lightly.

In that sense your mcount enhancement is better, as it does not 
increase the default (single NOP) cost. It can also be 
enabled/disabled dynamically in addition to the 'half-way profiling' 
mcount solution we have today. So i like it at first sight - if it can 
be made stable ;-)

	Ingo
