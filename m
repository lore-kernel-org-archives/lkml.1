Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbYFLIRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbYFLIRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbYFLIRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:17:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbYFLIRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:17:33 -0400
Date: Thu, 12 Jun 2008 01:16:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: repeatable slab corruption with LTP msgctl08
Message-Id: <20080612011651.374e60fe.akpm@linux-foundation.org>
In-Reply-To: <20080612011537.6146c41d.akpm@linux-foundation.org>
References: <20080611221324.42270ef2.akpm@linux-foundation.org>
	<20080611233449.08e6eaa0.akpm@linux-foundation.org>
	<20080612010200.106df621.akpm@linux-foundation.org>
	<20080612011537.6146c41d.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 01:15:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 12 Jun 2008 01:02:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 11 Jun 2008 23:34:49 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 11 Jun 2008 22:13:24 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > Running current mainline on my old 2-way PIII.  Distro is RH FC1.  LTP
> > > > version is ltp-full-20070228 (lots of retro-computing there).
> > > > 
> > > > Config is at http://userweb.kernel.org/~akpm/config-vmm.txt
> > > > 
> > > > 
> > > > ./testcases/bin/msgctl08 crashes after ten minutes or so:
> > > 
> > > ah, it runs to completion in about ten seconds on 2.6.25, so it'll be
> > > easy for someone to bisect it.
> > > 
> > > What's that?  Sigh.  OK.  I wasn't doing anything much anyway.
> > 
> > Oh drat.  git-bisect tells me that this one-year-old msgctl08's
> > execution time vastly increased when we added
> > 
> > commit f7bf3df8be72d98afa84f5ff183e14c1ba1e560d
> > Author: Nadia Derbey <Nadia.Derbey@bull.net>
> > Date:   Tue Apr 29 01:00:39 2008 -0700
> > 
> >     ipc: scale msgmni to the amount of lowmem
> >     
> > 
> > But we already knew that, and LTP got changed to fix it.
> > 
> > So I was wrong in assuming that the long-execution-time correlates with
> > the slab-corruption bug.
> > 
> > And the slab corruption bug takes half an hour to reproduce and an
> > unknown amount of time to not-reproduce.  I don't think I'll be able to
> > complete this before I disappear for over a week.
> > 
> 
> Doing
> 
> 	echo 16 > /proc/sys/kernel/msgmni
> 
> on the tree at the above bisection point
> (f7bf3df8be72d98afa84f5ff183e14c1ba1e560d is most-recently-applied
> patch), msgctl08 runs to completion in 15.7 seconds.
> 
> Doing the same thing on 2.6.26-rc5-mm3, msgctl08 also runs to
> completion, in 20.9 seconds.  So
> 
> - it got slower
> 
> - the crash requires the huge value of /proc/sys/kernel/msgmni (1746)

                                                                  actually, it's 1741.

>   to reproduce.
> 
