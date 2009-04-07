Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZDGP4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZDGP4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZDGP41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:56:27 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48252 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbZDGP40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:56:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Nikanth K <nikanth@gmail.com>
Subject: Re: [PATCH 00/12] DRBD: a block device for HA clusters
Date: Tue, 7 Apr 2009 17:56:22 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, jens.axboe@oracle.com,
       nab@risingtidestorage.com, andi@firstfloor.org,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1238431643-19433-1-git-send-email-philipp.reisner@linbit.com> <807b3a220904070523t746ad2abx6a46d30e816eb1d6@mail.gmail.com>
In-Reply-To: <807b3a220904070523t746ad2abx6a46d30e816eb1d6@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904071756.23914.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009 14:23:14 Nikanth K wrote:
> Hi Philipp,
>
> On Mon, Mar 30, 2009 at 10:17 PM, Philipp Reisner
>
> <philipp.reisner@linbit.com> wrote:
> > Hi,
> >
> >  This is a repost of DRBD, to keep you updated about the ongoing
> >  cleanups.
> >
> > Description
> >
> >  DRBD is a shared-nothing, synchronously replicated block device. It
> >  is designed to serve as a building block for high availability
> >  clusters and in this context, is a "drop-in" replacement for shared
> >  storage. Simplistically, you could see it as a network RAID 1.
> >
> >  Each minor device has a role, which can be 'primary' or 'secondary'.
> >  On the node with the primary device the application is supposed to
> >  run and to access the device (/dev/drbdX). Every write is sent to
> >  the local 'lower level block device' and, across the network, to the
> >  node with the device in 'secondary' state.  The secondary device
> >  simply writes the data to its lower level block device.
> >
> >  DRBD can also be used in dual-Primary mode (device writable on both
> >  nodes), which means it can exhibit shared disk semantics in a
> >  shared-nothing cluster.  Needless to say, on top of dual-Primary
> >  DRBD utilizing a cluster file system is necessary to maintain for
> >  cache coherency.
> >
> >  This is one of the areas where DRBD differs notably from RAID1 (say
> >  md) stacked on top of NBD or iSCSI. DRBD solves the issue of
> >  concurrent writes to the same on disk location. That is an error of
> >  the layer above us -- it usually indicates a broken lock manager in
> >  a cluster file system --, but DRBD has to ensure that both sides
> >  agree on which write came last, and therefore overwrites the other
> >  write.
>
> So this difference to RAID1+NBD is required only if the DLM of the
> clustered fs is buggy?
>

No, DRBD is much more than RAID1+NBD, I had the impression that by writing 
"RAID1+NBD" I can quickly communicate the big picture what DRBD is.

> >  More background on this can be found in this paper:
> >    http://www.drbd.org/fileadmin/drbd/publications/drbd8.pdf
> >
> >  Beyond that, DRBD addresses various issues of cluster partitioning,
> >  which the MD/NBD stack, to the best of our knowledge, does not
> >  solve. The above-mentioned paper goes into some detail about that as
> >  well.
>
> It would be nice, if you can list those limitations of NBD/RAID here.
>

Ok. I will give you two simple examples:

1)
Think of a two node HA cluster. Node A is active ('primary' in DRBD speak)
has the filesystem mounted and the application running. Node B is
in standby mode ('secondary' in DRBD speak).

We loose network connectivity, the primary node continues to run, the 
secondary no longer gets updates.

Then we have a complete power failure, both nodes are down. Then they
power up the data center again, but at first the get only the power circuit
of node B up and running again. 

  Should node B offer the service right now ? 
     ( DRBD has configurable policies for that )

Later on they manage to get node A up and running again, now lets assume
node B was chosen to be the new primary node. What needs to be done ?

 Modifications on B since it became primary needs to be resynced to A.
 Modifications on A sind it lost contact to B needs to be taken out.

DRBD does that. 

How do you fit that into a RAID1+NBD model ? NBD is just a block transport,
it does not offer the ability to exchange dirty bitmaps or data generation
identifiers, nor does the RAID1 code has a concept of that.

2)
When using DRBD over small bandwidth links, one has to run a resync, DRBD
offers the option to do a "checksum based resync". Similar to rsync it 
at first only exchanges a checksum, and transmits the whole data block only
if the checksums differ.

That again is something that does not fit into the concepts of NBD or RAID1.

I will write down more examples if you think, that you need more justification
for yet another implementation of RAID in the kernel. DRBD does more, but DRBD
is not suitable for RAID1 on a local box. 

PS: Lars Marowsky-Bree requested a GIT tree of the DRBD-for-mainline kernel
    patch. I will set that up until Friday, and maintain the code there for
    for the merging process.

Best,
 Philipp
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.

