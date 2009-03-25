Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbZCYPP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbZCYPP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762178AbZCYPPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:15:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762186AbZCYPPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:15:22 -0400
Date: Wed, 25 Mar 2009 11:15:14 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
In-Reply-To: <20090324150517.GX27476@kernel.dk>
Message-ID: <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
References: <49C7DD3C.2020401@redhat.com> <Pine.LNX.4.64.0903241000010.29968@hs20-bc2-1.build.redhat.com>
 <20090324140524.GV27476@kernel.dk> <Pine.LNX.4.64.0903241010490.29968@hs20-bc2-1.build.redhat.com>
 <20090324143034.GW27476@kernel.dk> <Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
 <20090324150517.GX27476@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Over time we should have support everywhere, but it needs to be checked, 
> > > audited, and trusted.
> > 
> > BTW. What is the rule for barriers if the device can't prevent the 
> > requests from being delayed or reordered? (for example ATA<=3 disks with 
> > cache that lack cache-flush command ... or flash cards that do 
> > write-caching anyway and it can't be turned off). Should they support 
> > barriers and try to make best effort? Or should they reject barriers to 
> > inform the caller code that they have no data consistency?
> 
> If they can't flush cache, then they must reject barriers unless they
> have write through caching.

... and you suppose that journaled filesystems will use this error and 
mark filesystem for fsck if they are running over a device that doesn't 
support consistency?

In theory it would be nice, in practice it doesn't work this way because 
many devices *DO* support data consistency don't support barriers (the 
most common are DM and MD when run over disk without write cache).


So I think there should be flag (this device does/doesn't support data 
consistency) that the journaled filesystems can use to mark the disk dirty 
for fsck. And if you implement this flag, you can accept barriers always 
to all kind of devices regardless of whether they support consistency. You 
can then get rid of that -EOPNOTSUPP and simplify filesystem code because 
they'd no longer need two commit paths and a clumsy way to restart 
-EOPNOTSUPPed requests.

Mikulas

> -- 
> Jens Axboe
> 
