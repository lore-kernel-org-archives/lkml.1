Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZKYGxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZKYGxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 01:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZKYGwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 01:52:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZKYGws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 01:52:48 -0500
Date: Wed, 25 Nov 2009 07:52:53 +0100
From: Nick Piggin <npiggin@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091125065253.GC17484@wotan.suse.de>
References: <20091123145409.GA29627@wotan.suse.de> <20091124.121959.35689494.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124.121959.35689494.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 12:19:59PM -0800, David Miller wrote:
> From: Nick Piggin <npiggin@suse.de>
> Date: Mon, 23 Nov 2009 15:54:09 +0100
> 
> > This was basically reproduced by several cores executing wait
> > with WNOHANG.
> > 
> > Of course it would always be nice to improve locking so
> > contention isn't an issue, but so long as we have rwlocks, we
> > could possibly get into a situation where starvation is
> > triggered *somehow*. So I'd really like to fix this.
> > 
> > This particular starvation on tasklist lock I guess is a local
> > DoS vulnerability even if the workload is not particularly
> > realistic.
> > 
> > Anyway, I don't have a patch yet. I'm sure it can be done
> > without extra atomics in fastpaths. Comments?
> 
> I think nobody would notice if you changed tasklist_lock into
> a spinlock_t, and this would solve the DoS because at least on
> x86 you'd end up with the ticket spinlocks.
> 
> And this is a repeating theme every time the topic of rwlocks come up.
> All uses should just simply be converted gradually to some other
> locking mechanism over time, the cases causing problems taking
> priority.

For tasklist_lock, I'm not so sure. It gets taken fairly often
for read, and has some quite long critical sections. I think
we might start running into contention on lock hold times.

For other locks, I agree. In fact there are a couple of them in
the vfs which I think should be just spinlocks. I'll send some
patches for those.

