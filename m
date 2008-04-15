Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYDOHIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYDOHIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYDOHIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:08:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbYDOHIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:08:31 -0400
Date: Tue, 15 Apr 2008 09:08:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415070811.GA15499@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <84144f020804142341ic4621c9o6de06d68eee74871@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020804142341ic4621c9o6de06d68eee74871@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Tue, Apr 15, 2008 at 9:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >  so it's probably the first few page allocations (setup_cpu_cache())
> >  going wrong already - suggesting a some fundamental borkage in SLAB?
> 
> I think it's still pointing to the page allocator and/or setting up 
> the zonelists...

i did a .config bisection and it pinpointed CONFIG_SPARSEMEM=y as the 
culprit. Changing it to FLATMEM gives a correctly booting system.

if you look at the good versus bad bootup log:

  http://redhat.com/~mingo/misc/log-Tue_Apr_15_07_24_59_CEST_2008.good
  http://redhat.com/~mingo/misc/log-Tue_Apr_15_07_24_59_CEST_2008.bad

(both SLUB) you'll see that the zone layout provided by the architecture 
code is _exactly_ the same and looks sane as well. So this is not an 
architecture zone layout bug, this is probably sparsemem setup (and/or 
the page allocator) getting confused by something.

why are there no good debug logs possible in this area? To debug such 
bugs we'd need an early dump of the precise layout of all memory maps, 
what points where, how large it is, where it is allocated - and then 
compare it with how the rest of the system is layed out - looking at 
possible overlaps or other bugs. This 8-way box is a pain to debug on, 
it takes a long time to boot it up, etc. etc.

	Ingo
