Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYKJOrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYKJOrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYKJOrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:47:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:53866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYKJOrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:47:06 -0500
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
 dm_any_congested() to properly sync up with suspend code path)
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Chandra Seetharaman <sekharan@us.ibm.com>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, axboe@kernel.dk
In-Reply-To: <Pine.LNX.4.64.0811100929380.16965@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
	 <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
	 <20081110135401.GA11606@infradead.org>
	 <Pine.LNX.4.64.0811100914500.14825@hs20-bc2-1.build.redhat.com>
	 <1226327210.7685.173.camel@twins>
	 <Pine.LNX.4.64.0811100929380.16965@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Nov 2008 15:46:57 +0100
Message-Id: <1226328417.7685.198.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 09:32 -0500, Mikulas Patocka wrote:
> 
> On Mon, 10 Nov 2008, Peter Zijlstra wrote:
> 
> > On Mon, 2008-11-10 at 09:19 -0500, Mikulas Patocka wrote:
> > > On Mon, 10 Nov 2008, Christoph Hellwig wrote:
> > > 
> > > > On Mon, Nov 10, 2008 at 08:11:51AM -0500, Mikulas Patocka wrote:
> > > > > For upstream Linux developers: you are holding a spinlock and calling 
> > > > > bdi*_congested functions that can take indefinite amount of time (there 
> > > > > are even users reporting having 50 disks in one logical volume or so). I 
> > > > > think it would be good to move these calls out of spinlocks.
> > > > 
> > > > Umm, they shouldn't block that long, as that completely defeats their
> > > > purpose.  These functions are mostly used to avoid throwing more I/O at
> > > > a congested device if pdflush could do more useful things instead.  But
> > > > if it blocks in those functions anyway we wouldn't have to bother using
> > > > them.  Do you have more details about the uses cases when this happens
> > > > and where the routines spend so much time?
> > > 
> > > For device mapper, congested_fn asks every device in the tree and make OR 
> > > of their bits --- so if the user has 50 devices, it asks them all.
> > > 
> > > For md-linear, md-raid0, md-raid1, md-raid10 and md-multipath it does the 
> > > same --- asking every device.
> > > 
> > > If you have a better idea how to implement congested_fn, say it.
> > 
> > Fix the infrastructure by adding a function call so that you can have
> > the individual devices report their congestion state to the aggregate.
> > 
> > Then congestion_fn can return a valid state in O(1) because the state is
> > keps up-to-date by the individual state changes.
> > 
> > IOW, add a set_congested_fn() and clear_congested_fn().
> 
> If you have a physical disk that has many LVM volumes on it, you end up in 
> a situation when disk congestion state change is reported to all the 
> volumes. So it will create O(n) problem at the other side.

*sigh* I can almost understand why people want to use lvm to combine
multiple disks, but why make the partition thing even worse...
