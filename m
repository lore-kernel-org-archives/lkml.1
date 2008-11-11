Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYKKWJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYKKWJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYKKWIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:08:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYKKWIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:08:51 -0500
Date: Tue, 11 Nov 2008 17:08:43 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Christoph Hellwig <hch@infradead.org>
cc: Chandra Seetharaman <sekharan@us.ibm.com>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
 dm_any_congested() to properly sync up with suspend code path)
In-Reply-To: <20081111181854.GA25049@infradead.org>
Message-ID: <Pine.LNX.4.64.0811111657360.5129@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
 <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
 <20081110135401.GA11606@infradead.org> <Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
 <20081111181854.GA25049@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Christoph Hellwig wrote:

> On Mon, Nov 10, 2008 at 09:19:21AM -0500, Mikulas Patocka wrote:
> > For device mapper, congested_fn asks every device in the tree and make OR 
> > of their bits --- so if the user has 50 devices, it asks them all.
> > 
> > For md-linear, md-raid0, md-raid1, md-raid10 and md-multipath it does the 
> > same --- asking every device.
> > 
> > If you have a better idea how to implement congested_fn, say it.
> 
> Well, even asking 50 devices shouldn't take that long normally.

There are some atomic operations inside congested_fn.

I remember that there was some database benchmark on a setup with 48 
devices. Just dropping one spinlock from unplug function resulted in 
overall improvement (not microbenchmarks, the whole run) by 18%. The 
slowdown with unplug is similar as with congested_fn --- unplugs walks all 
the physical devices for a given logical device and unplugs them.

So simplifying congested_fn might help too. Do you have an idea, how often 
is it called? I thought about caching the return value for one jiffy.

> Do you take some sleeping lock that might block forever?  In that case I 
> would just return congested for that device as it would delay pdflush 
> otherwise.

Sometimes we do, and we shouldn't, because congested_fn is called with 
spinlock. That's what I'm working on now.

BTW. how "realtime" do you expect the Linux kernel to be? Is there some 
effort to make all spinlocks locked for finite time? (so that someone 
could one day calculate the times of all spinlocks, take the maximum time 
and give Linux a "realtime" label). If so, then bdi_congested call should 
be moved out of spinlocks. If there are already many cases when spinlock 
could be taken and list of indefinite length walked inside, it isn't worth 
optimizing for it.

Mikulas
