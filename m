Return-Path: <linux-kernel-owner+w=401wt.eu-S1754354AbYKJOke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbYKJOke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 09:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYKJOk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 09:40:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbYKJOkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 09:40:25 -0500
Date: Mon, 10 Nov 2008 09:40:18 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alasdair G Kergon <agk@redhat.com>
cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
       dm-devel <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Queue upcall locking (was: [dm-devel] [RFC][PATCH] fix
 dm_any_congested() to properly sync up with suspend code path)
In-Reply-To: <20081110142715.GD16649@agk.fab.redhat.com>
Message-ID: <Pine.LNX.4.64.0811100933520.16965@hs20-bc2-1.build.redhat.com>
References: <1225944008.14830.1101.camel@chandra-ubuntu>
 <Pine.LNX.4.64.0811100746180.24696@hs20-bc2-1.build.redhat.com>
 <20081110135401.GA11606@infradead.org> <20081110142715.GD16649@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Nov 2008, Alasdair G Kergon wrote:

> On Mon, Nov 10, 2008 at 08:54:01AM -0500, Christoph Hellwig wrote:
> > On Mon, Nov 10, 2008 at 08:11:51AM -0500, Mikulas Patocka wrote:
> > > For upstream Linux developers: you are holding a spinlock and calling 
> > > bdi*_congested functions that can take indefinite amount of time (there 
> > > are even users reporting having 50 disks in one logical volume or so). I 
> > > think it would be good to move these calls out of spinlocks.
> > Umm, they shouldn't block that long, as that completely defeats their
> > purpose.  
> 
> Indeed - the blocking was a bug for which there's a patch, but that doesn't
> deal with how the function should be operating in the first place.

To me it looks like the bug is more severe --- holding a reference to 
table can happen in other upcalls too and in many other dm places.

I'm considering if we could call the table destructor just at one place 
(that would wait until all references are gone), instead of calling the 
destructor at each dm_table_put point (there are many of these points and 
it's hard to check all of them for correctness).

> - If one device is found to be congested, why bother checking the remaining
> devices?

Yes, that could be improved. But it doesn't solve the O(n) problem.

> - If the device is suspended, the response should be that it is 
> congested, I'd have thought.

Yes, but these congestion upcalls are used only for optimization and the 
device is suspended for so small time, that it doesn't matter if we 
optimize io acces in small moment or not.

Mikulas

> Alasdair
> -- 
> agk@redhat.com
> 
