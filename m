Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbYDPAhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbYDPAhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbYDPAhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:37:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34983 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580AbYDPAhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:37:00 -0400
Date: Wed, 16 Apr 2008 02:36:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Message-ID: <20080416003624.GA26459@elte.hu>
References: <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080416000356.GA24737@elte.hu> <Pine.LNX.4.64.0804151718140.5705@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151718140.5705@schroedinger.engr.sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 16 Apr 2008, Ingo Molnar wrote:
> 
> > if a !PAE x86 kernel is booted on a 32-bit system with more than 4GB 
> > of RAM, then we call memory_present() with a start/end that goes 
> > outside the scope of MAX_PHYSMEM_BITS.
> 
> Well okay this fixes it but is this the right fix? The arch should not 
> call memory_present() with an invalid pfn.

it is the right fix. The architecture memory setup code doesnt even 
_know_ the limits at this place in an open-coded way (and shouldnt know 
them) - and even later on we use pfn_valid() to determine whether to 
attempt to get to a struct page and free it into the buddy.

[ Of course the architecture code in general 'knows' about the limits - 
  but still it's cleaner to have a dumb enumeration interface here 
  combined with a resilient core code - that's always going to be less 
  fragile. ]

btw., i just did some bug history analysis, the calls were originally 
added when sparsemem support was added:

| commit 215c3409eed16c89b6d11ea1126bd9d4f36b9afd
| Author: Andy Whitcroft <apw@shadowen.org>
| Date:   Fri Jan 6 00:12:06 2006 -0800
|
|    [PATCH] i386 sparsemem for single node systems

in v2.6.15-1003-g215c340. (so this is appears to be an unfixed bug in 
v2.6.16 as well)

	Ingo
