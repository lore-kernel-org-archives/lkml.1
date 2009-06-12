Return-Path: <linux-kernel-owner+w=401wt.eu-S933802AbZFLKIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbZFLKIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbZFLKID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:08:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55829 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbZFLKIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:08:01 -0400
Date: Fri, 12 Jun 2009 12:07:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
	suspending
Message-ID: <20090612100756.GA25185@elte.hu>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI> <20090612091002.GA32052@elte.hu> <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, Jun 12, 2009 at 12:10 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >> @@ -1548,6 +1548,20 @@ new_slab:
> >>               goto load_freelist;
> >>       }
> >>
> >> +     /*
> >> +      * Lets not wait if we're booting up or suspending even if the user
> >> +      * asks for it.
> >> +      */
> >> +     if (system_state != SYSTEM_RUNNING)
> >> +             gfpflags &= ~__GFP_WAIT;
> >
> > Hiding that bug like that is not particularly clean IMO. We should
> > not let system_state hacks spread like that.
> >
> > We emit a debug warning but dont crash, so all should be fine and
> > the culprits can then be fixed, right?
> 
> OK, lets not use system_state then and go with Ben's approach 
> then. Again, neither of the patches are about "hiding buggy 
> callers" but changing allocation policy wrt. gfp flags during boot 
> (and later on during suspend).

IMHO such invisible side-channels modifying the semantics of GFP 
flags is a bit dubious.

We could do GFP_INIT or GFP_BOOT. These can imply other useful 
modifiers as well: panic-on-failure for example. (this would clean 
up a fair amount of init code that currently checks for an panics on 
allocation failure.)

	Ingo
