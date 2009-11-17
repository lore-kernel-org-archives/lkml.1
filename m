Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbZKQOP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbZKQOP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZKQOP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:15:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZKQOPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:15:55 -0500
Date: Tue, 17 Nov 2009 09:14:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091117141411.GA22462@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258461527.2862.2.camel@cail>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 07:38:47AM -0500, Alan D. Brunelle wrote:
> On Mon, 2009-11-16 at 17:18 -0500, Vivek Goyal wrote:
> > On Mon, Nov 16, 2009 at 03:51:00PM -0500, Alan D. Brunelle wrote:
> > 
> > [..]
> > > ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> > > 
> > > The next thing to look at is to see what the "penalty" is for the
> > > additional code: see how much bandwidth we lose for the capability
> > > added. Here we see the sum of the system's throughput for the various
> > > tests:
> > > 
> > > ---- ---- - ----------- ----------- ----------- ----------- 
> > > Mode RdWr N    base       ioc off   ioc no idle  ioc idle   
> > > ---- ---- - ----------- ----------- ----------- ----------- 
> > >  rnd   rd 2        17.3        17.1         9.4         9.1 
> > >  rnd   rd 4        27.1        27.1         8.1         8.2 
> > >  rnd   rd 8        37.1        37.1         6.8         7.1 
> > > 
> > 
> > Hi Alan,
> > 
> > This seems to be the most notable result in terms of performance degradation.
> > 
> > I ran two random readers on a locally attached SATA disk. There in fact
> > I gain in terms of performance because we perform less number of seeks
> > now as we allocate a continous slice to one group and then move onto
> > next group.
> > 
> > But in your setup it looks like there is a striped set of disks and seek
> > cost is less and waiting per group for sync-noidle workload is hurting
> > instead.
> 
> 
> That is correct - there are 4 back-end buses on an MSA1000, and each LUN
> that is exported is constructed from 1 drive from each bus (hardware
> striped RAID). [There is _no_ SW RAID involved.]
> 
> 
> > 
> > One simple way to test that would be to set slice_idle=0 so that CFQ does
> > not try to do any idling at all. Can you please re-run above test. This
> > will help in figuring out whether above performance regression is coming
> > from idling on sync-noidle workload group per cgroup or not.
> 
> I'll put that in the queue - first I'm going to re-run w/ synchronous
> direct I/O for the writes. I'm also going to pair this down to just
> doing 2-processes per disk runs (to simplify results & speed up tests).
> Once we get that working better, I can expand things back out.

Ok, the only thing to watch out for is number of request descriptors. I
think at some point of time with writes, you will consume all the request
descriptors and things will become serialized after that. We will need 
support of per group requests descriptros to solve this. But that patch
will come later is in TODO list. Boosting the number of request
descriptors per queue should help though.


Regarding the reduced throughput for random IO case, ideally we should not
idle on sync-noidle group on this hardware as this seems to be a fast NCQ
supporting hardware. But I guess we might not be detecting the queue depth
properly which leads to idling on per group sync-noidle workload and
forces the queue depth to be 1. 

I am also trying to setup a higher end system here and will do some
experiments.

Thanks
Vivek
