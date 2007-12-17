Return-Path: <linux-kernel-owner+w=401wt.eu-S935652AbXLQKyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935652AbXLQKyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935556AbXLQKxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:53:41 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:35765 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935544AbXLQKxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:53:40 -0500
Date: Mon, 17 Dec 2007 11:53:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-Id: <20071217115336.d06427d3.dada1@cosmosbay.com>
In-Reply-To: <20071217023339.ce3da56c.akpm@linux-foundation.org>
References: <20071213222044.GH21616@stusta.de>
	<20071213235432.GA26669@fattire.cabal.ca>
	<p73tzmmf72u.fsf@bingen.suse.de>
	<20071217023339.ce3da56c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 02:33:39 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 14 Dec 2007 01:33:45 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Kyle McMartin <kyle@mcmartin.ca> writes:
> > 
> > > I'd bet, in the __read_mostly case at least, that there's no
> > > improvement in almost all cases.
> > 
> > I bet you're wrong. Cache line behaviour is critical, much more
> > than pipeline behaviour (which unlikely affects). That is because
> > if you eat a cache miss it gets really expensive, which e.g.
> > a mispredicted jump is relatively cheap in comparison. We're talking
> > one or more orders of magnitude.
> 
> So...  once we've moved all read-mostly variables into __read_mostly, what
> is left behind in bss?
> 
> All the write-often variables.  All optimally packed together to nicely
> maximise cacheline sharing.

This is why it's important to group related variables together, so that they share
same cacheline.

Random example : vmlist_lock & vmlist

Currently in two separate cache lines (not that important since vmlist is
 so big that one extra cache line access is not measurable)

Other possibilities are :

1) to make sure that really critical hot spots are alone 
(they eventually waste a full cacheline, even if only 4 bytes are in use)

2) Or they are mixed with seldom used data. (One cache line contains one
critical object + other mostly_unused data). This kind of mixing
is really hard to do without a special linker.

