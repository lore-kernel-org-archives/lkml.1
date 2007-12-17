Return-Path: <linux-kernel-owner+w=401wt.eu-S935942AbXLQLJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935942AbXLQLJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934343AbXLQLJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:09:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932863AbXLQLJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:09:46 -0500
Date: Mon, 17 Dec 2007 03:07:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: remove __read_mostly
Message-Id: <20071217030743.da80e6a8.akpm@linux-foundation.org>
In-Reply-To: <20071217115336.d06427d3.dada1@cosmosbay.com>
References: <20071213222044.GH21616@stusta.de>
	<20071213235432.GA26669@fattire.cabal.ca>
	<p73tzmmf72u.fsf@bingen.suse.de>
	<20071217023339.ce3da56c.akpm@linux-foundation.org>
	<20071217115336.d06427d3.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 11:53:36 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> n Mon, 17 Dec 2007 02:33:39 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 14 Dec 2007 01:33:45 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > Kyle McMartin <kyle@mcmartin.ca> writes:
> > > 
> > > > I'd bet, in the __read_mostly case at least, that there's no
> > > > improvement in almost all cases.
> > > 
> > > I bet you're wrong. Cache line behaviour is critical, much more
> > > than pipeline behaviour (which unlikely affects). That is because
> > > if you eat a cache miss it gets really expensive, which e.g.
> > > a mispredicted jump is relatively cheap in comparison. We're talking
> > > one or more orders of magnitude.
> > 
> > So...  once we've moved all read-mostly variables into __read_mostly, what
> > is left behind in bss?
> > 
> > All the write-often variables.  All optimally packed together to nicely
> > maximise cacheline sharing.
> 
> This is why it's important to group related variables together, so that they share
> same cacheline.

Not feasible.  The linker is (I believe) free to place them anywhere it
likes unless we go and aggregate them in a struct.

Take (just for one example) inode_lock.  How do we prevent that from
sharing a cacheline with (to pick another example) rtnl_mutex?

The insidious thing about this is that is is highly dependent upon
compiler/linker version and upon kernel config.  So performance differences
will appears and disappear with us having very little understanding why.


I guess we could hunt down the write-very-often variables and put them in
private cachelines.  But there will be a *lot* of them when one considers
all possible workloads and all possible drivers.


Now, if we had named it __read_often rather than __read_mostly then we might
end up with a better result: all those read-mostly, read-rarely variables (and
there are a lot of those) could be very usefully deployed by packing them
in between the write-often variables.

It's crying out for a performance-guided solution.
