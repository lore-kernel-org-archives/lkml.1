Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZECFxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZECFxp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 01:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZECFxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 01:53:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:37903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZECFxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 01:53:35 -0400
From: Neil Brown <neilb@suse.de>
To: Philipp Reisner <philipp.reisner@linbit.com>
Date: Sun, 3 May 2009 15:53:41 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18941.12645.590037.589600@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
In-Reply-To: message from Philipp Reisner on Thursday April 30
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 30, philipp.reisner@linbit.com wrote:
> Hi,
> 
> This is a repost of DRBD, to keep you updated about the ongoing
> cleanups and improvements.
> 
> Patch set attached. Git tree available:
> git pull git://git.drbd.org/linux-2.6-drbd.git drbd
> 
> We are looking for reviews!
> 
> Description
> 
>   DRBD is a shared-nothing, synchronously replicated block device. It
>   is designed to serve as a building block for high availability
>   clusters and in this context, is a "drop-in" replacement for shared
>   storage. Simplistically, you could see it as a network RAID 1.

I know this is minor, but it bugs me every time I see that phrase
"shared-nothing".   Surely the network is shared?? And the code...
Can you just say "DRBD is a synchronously replicated block device"?
or would we have to call it SRBD then?
Or maybe "shared-nothing" is an accepted technical term in the
clustering world??

> 
>   Although I use the "RAID1+NBD" metaphor myself, recent discussion
>   unveiled that one needs to understand the differences as well.
>   Here are just two examples of that:

All this should probably be in a patch against Documentation/drbd.txt 

> 
>    1) Think of a two node HA cluster. Node A is active ('primary' in DRBD
>     speak) has the filesystem mounted and the application running. Node B is
>     in standby mode ('secondary' in DRBD speak).

If there some strong technical reason to only allow 2 nodes?  Was it
Asimov who said the only sensible numbers were 0, 1, and infinity?
(People still get surprised that md/raid1 can do 2 or 3 or n drives,
and that md/raid5 can handle just 2 :-)

> 
>     We loose network connectivity, the primary node continues to run, the
         lose
>     secondary no longer gets updates.
> 
>     Then we have a complete power failure, both nodes are down. Then they
>     power up the data center again, but at first the get only the power
                                                   they
>     circuit of node B up and running again.
> 
>     Should node B offer the service right now ?
>       ( DRBD has configurable policies for that )
> 
>     Later on they manage to get node A up and running again, now lets assume
>     node B was chosen to be the new primary node. What needs to be done ?
> 
>     Modifications on B since it became primary needs to be resynced to A.
>     Modifications on A sind it lost contact to B needs to be taken out.
> 
>     DRBD does that.
> 
>     How do you fit that into a RAID1+NBD model ? NBD is just a block
>     transport, it does not offer the ability to exchange dirty bitmaps or
>     data generation identifiers, nor does the RAID1 code has a concept of
>     that.

Not 100% true, but I - at least partly -  get your point.
As md stores bitmaps and data generation identifiers on the block
device, these can be transferred over NBD just like any other data on
the block device.
However I think that part of your point is that DRBD can transfer them
more efficiently (e.g. it compresses the bitmap before transferring it
-  I assume the compression you use is much more effective than gzip??
else why both to code your own).
I suspect there is more to your point that I am missing.
You say "nor does the RAID1 code has a concept of that".  It isn't
clear what you are referring to.  RAID1 does have a concept of dirty
bitmaps as you know, and it does have a concept of data generation,
though it is quite possibly weaker than the concept that DRBD has.
I'd need to explore the DRBD code more to be sure.


> 
>    2) When using DRBD over small bandwidth links, one has to run a resync,
>     DRBD offers the option to do a "checksum based resync". Similar to rsync
>     it at first only exchanges a checksum, and transmits the whole data
>     block only if the checksums differ.
> 
>     That again is something that does not fit into the concepts of
>     NBD or RAID1.

Interesting idea....  RAID1 does have a mode where it reads both (all)
devices and compares them to see if they match or not.  Doing this
compare with checksums rather than memcmp would not be an enormous
change.

I'm beginning to imagine an enhanced NBD as a model for what DRBD
does.
This enhanced NBD not only supports read and write of blocks but also:

   - maintains the local bitmap and sets bits before allowing a write
   - can return a strong checksum rather than the data of a block
   - provides sequence numbers in a way that I don't fully understand
     yet, but which allows consistent write ordering.
   - allows reads to be compressed so that the bitmap can be
     transferred efficiently.

I can imagine that md/raid1 could be made to work well with an
enhanced NBD like this.

> 
>   DRBD can also be used in dual-Primary mode (device writable on both
>   nodes), which means it can exhibit shared disk semantics in a
>   shared-nothing cluster.  Needless to say, on top of dual-Primary
>   DRBD utilizing a cluster file system is necessary to maintain for
>   cache coherency.
> 
>   More background on this can be found in this paper:
>     http://www.drbd.org/fileadmin/drbd/publications/drbd8.pdf
> 
>   Beyond that, DRBD addresses various issues of cluster partitioning,
>   which the MD/NBD stack, to the best of our knowledge, does not
>   solve. The above-mentioned paper goes into some detail about that as
>   well.

Agreed - MD/NBD could probably be easily confused by cluster
partitioning, though I suspect that in many simple cases it would get
it right.  I haven't given it enough thought to be sure.  I doubt the
enhancements necessary would be very significant though.

> 
>   DRBD can operate in synchronous mode, or in asynchronous mode. I want
>   to point out that we guarantee not to violate a single possible write
>   after write dependency when writing on the standby node. More on that
>   can be found in this paper:
>     http://www.drbd.org/fileadmin/drbd/publications/drbd_lk9.pdf

I really must read and understand this paper..


So... what would you think of working towards incorporating all of the
DRBD functionality into md/raid1??
I suspect that it would be a mutually beneficial exercise, except for
the small fact that it would take a significant amount of time and
effort.  I'd be will to shuffle some priorities and put in some effort
if it was a direction that you would be open to exploring.

Whether the current DRBD code gets merged or not is possibly a
separate question, though I would hope that if we followed the path of
merging DRBD into md/raid1, then any duplicate code would eventually be
excised from the kernel.

What do you think?

NeilBrown
