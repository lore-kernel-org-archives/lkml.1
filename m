Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYKIJkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYKIJkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 04:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYKIJkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 04:40:32 -0500
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:57882 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbYKIJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 04:40:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LDmzgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,568,1220193000"; 
   d="scan'208";a="227699276"
Date: Sun, 9 Nov 2008 20:40:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081109094024.GE2373@disturbed>
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
	Hirokazu Takahashi <taka@valinux.co.jp>,
	Ryo Tsuruta <ryov@valinux.co.jp>,
	Andrea Righi <righi.andrea@gmail.com>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
	balbir@linux.vnet.ibm.com,
	Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
	ngupta@google.com, Jeff Moyer <jmoyer@redhat.com>
References: <20081106153022.215696930@redhat.com> <1225986593.7803.4688.camel@twins> <20081106160154.GA7461@redhat.com> <1225988173.7803.4723.camel@twins> <20081106163957.GB7461@redhat.com> <1225990327.7803.4776.camel@twins> <491321ED.5010103@redhat.com> <1225991487.7803.4801.camel@twins> <20081107004131.GD2373@disturbed> <1226053904.7803.5856.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226053904.7803.5856.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 11:31:44AM +0100, Peter Zijlstra wrote:
> On Fri, 2008-11-07 at 11:41 +1100, Dave Chinner wrote:
> > On Thu, Nov 06, 2008 at 06:11:27PM +0100, Peter Zijlstra wrote:
> > > On Thu, 2008-11-06 at 11:57 -0500, Rik van Riel wrote:
> > > > Peter Zijlstra wrote:
> > > > 
> > > > > The only real issue I can see is with linear volumes, but
> > > > > those are stupid anyway - non of the gains but all the
> > > > > risks.
> > > > 
> > > > Linear volumes may well be the most common ones.
> > > > 
> > > > People start out with the filesystems at a certain size,
> > > > increasing onto a second (new) disk later, when more space
> > > > is required.
> > > 
> > > Are they aware of how risky linear volumes are? I would
> > > discourage anyone from using them.
> > 
> > In what way are they risky?
> 
> You loose all your data when one disk dies, so your mtbf decreases
> with the number of disks in your linear span.  And you get non of
> the benefits from having multiple disks, like extra speed from
> striping, or redundancy from raid.

Fmeh. Step back and think for a moment. How does every major
distro build redundant root drives?

Yeah, they build a mirror and then put LVM on top of the mirror
to partition it. Each partition is a *linear volume*, but
no single disk failure is going to lose data because it's
been put on top of a mirror.

IOWs, reliability of linear volumes is only an issue if you don't
build redundancy into your storage stack.  Just like RAID0, a single
disk failure will lose data.  So, most people use linear volumes on
top of RAID1 or RAID5 to avoid such a single disk failure problem.
People do the same thing with RAID0 - it's what RAID10 and RAID50
do....

Also, linear volume performance scalability is on a different axis
to striping. Striping improves bandwidth, but each disk in a stripe
tends to make the same head movements. Hence striping improves
sequential throughput but only provides limited iops scalability.
Effectively, striping only improves throughput while the disks are
not seeking a lot. Add a few parallel I/O streams, and a stripe will
start to slow down as each disk seeks between streams.  i.e. disks
in stripes cannot be considered to be able to operate independently.

Linear voulmes create independent regions within the address space -
the regions can seek independently when under concurrent I/O and
hence iops scalability is much greater. Aggregate bandwidth is the
same a striping, it's just that a single stream is limited in
throughput. If you want to improve single stream throughput,
you stripe before you concatenate.

That's why people create layered storage systems like this:

	linear volume
	  |->stripe
	      |-> md RAID5
		   |-> disk
		   |-> disk
		   |-> disk
		   |-> disk
		   |-> disk
	      |-> md RAID5
		   |-> disk
		   |-> disk
		   |-> disk
		   |-> disk
		   |-> disk
	  |->stripe
	      |-> md RAID5
	      ......
	  |->stripe
	  ......

What you then need is a filesystem that can spread the load over
such a layout. Lets use, for argument's sake, XFS and tell it the
geometry of the RAID5 luns that make up the volume so that it's
allocation is all nicely aligned.  Then we match the allocation
group size to the size of each independent part of the linear
volume.  Now when XFS spreads it's inodes and data over multiple
AGs, it's spreading the load across disks that can operate
concurrently....

Effectively, linear volumes are about as dangerous as striping.
If you don't build in redundancy at a level below the linear
volume or stripe, then you lose when something fails.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
