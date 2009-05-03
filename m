Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZECIay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZECIay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 04:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbZECIae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 04:30:34 -0400
Received: from [212.69.161.110] ([212.69.161.110]:43039 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZECIa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 04:30:29 -0400
Date: Sun, 3 May 2009 10:29:31 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Neil Brown <neilb@suse.de>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Message-ID: <20090503082931.GD31340@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <18941.12645.590037.589600@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18941.12645.590037.589600@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 03:53:41PM +1000, Neil Brown wrote:
> I know this is minor, but it bugs me every time I see that phrase
> "shared-nothing". 

> Or maybe "shared-nothing" is an accepted technical term in the
> clustering world??

yes.

> All this should probably be in a patch against Documentation/drbd.txt 

Ok.

> >    1) Think of a two node HA cluster. Node A is active ('primary' in DRBD
> >     speak) has the filesystem mounted and the application running. Node B is
> >     in standby mode ('secondary' in DRBD speak).
> 
> If there some strong technical reason to only allow 2 nodes?

It "just" has not yet been implemented.
I'm working on that, though.

> >     How do you fit that into a RAID1+NBD model ? NBD is just a block
> >     transport, it does not offer the ability to exchange dirty bitmaps or
> >     data generation identifiers, nor does the RAID1 code has a concept of
> >     that.
> 
> Not 100% true, but I - at least partly -  get your point.
> As md stores bitmaps and data generation identifiers on the block
> device, these can be transferred over NBD just like any other data on
> the block device.

Do you have one dirty bitmap per mirror (yet) ?
Do you _merge_ them?

the "NBD" mirrors are remote, and once you lose communication,
they may be (and in general, you have to assume they are) modified
by which ever node they are directly attached to.

> However I think that part of your point is that DRBD can transfer them
> more efficiently (e.g. it compresses the bitmap before transferring it
> -  I assume the compression you use is much more effective than gzip??
> else why both to code your own).

No, the point was that we have one bitmap per mirror (though currently
number of mirrors == 2, only), and that we do merge them.

but to answer the question:
why bother to implement our own encoding?
because we know a lot about the data to be encoded.

the compression of the bitmap transfer we just added very recently.
for a bitmap, with large chunks of bits set or unset, it is efficient
to just code the runlength.
to use gzip in kernel would add yet an other huge overhead for code
tables and so on.
during testing of this encoding, applying it to an already gzip'ed file
was able to compress it even further, btw.
though on english plain text, gzip compression is _much_ more effective.

> You say "nor does the RAID1 code has a concept of that".  It isn't
> clear what you are referring to.

The concept that one of the mirrors (the "nbd" one in that picture)
may have been accessed independently, without MD knowning,
because the node this MD (and its "local" mirror) was living on
suffered from power outage.

The concept of both mirrors being modified _simultaneously_,
(e.g. living below a cluster file system).

> >    2) When using DRBD over small bandwidth links, one has to run a resync,
> >     DRBD offers the option to do a "checksum based resync". Similar to rsync
> >     it at first only exchanges a checksum, and transmits the whole data
> >     block only if the checksums differ.
> > 
> >     That again is something that does not fit into the concepts of
> >     NBD or RAID1.
> 
> Interesting idea....  RAID1 does have a mode where it reads both (all)
> devices and compares them to see if they match or not.  Doing this
> compare with checksums rather than memcmp would not be an enormous
> change.
> 
> I'm beginning to imagine an enhanced NBD as a model for what DRBD
> does.  This enhanced NBD not only supports read and write of blocks
> but also:
> 
>    - maintains the local bitmap and sets bits before allowing a write

right.

>    - can return a strong checksum rather than the data of a block

ok.

>    - provides sequence numbers in a way that I don't fully understand
>      yet, but which allows consistent write ordering.

yes, please.

>    - allows reads to be compressed so that the bitmap can be
>      transferred efficiently.

yep.

add to that
     - can exchange data generations on handshake,
     - can refuse the handshake (consistent data,
       but evolved differently than the other copy;
       diverging data sets detected!)
     - is bi-directional, can _push_ writes!

and whatever else I forgot just now.

> I can imagine that md/raid1 could be made to work well with an
> enhanced NBD like this.

of course.

> >   DRBD can also be used in dual-Primary mode (device writable on both
> >   nodes), which means it can exhibit shared disk semantics in a
> >   shared-nothing cluster.  Needless to say, on top of dual-Primary
> >   DRBD utilizing a cluster file system is necessary to maintain for
> >   cache coherency.
> > 
> >   More background on this can be found in this paper:
> >     http://www.drbd.org/fileadmin/drbd/publications/drbd8.pdf
> > 
> >   Beyond that, DRBD addresses various issues of cluster partitioning,
> >   which the MD/NBD stack, to the best of our knowledge, does not
> >   solve. The above-mentioned paper goes into some detail about that as
> >   well.
> 
> Agreed - MD/NBD could probably be easily confused by cluster
> partitioning, though I suspect that in many simple cases it would get
> it right.  I haven't given it enough thought to be sure.  I doubt the
> enhancements necessary would be very significant though.

The most significant part is probably the bidirectional nature
and the "refuse it" part of the handshake.

> >   DRBD can operate in synchronous mode, or in asynchronous mode. I want
> >   to point out that we guarantee not to violate a single possible write
> >   after write dependency when writing on the standby node. More on that
> >   can be found in this paper:
> >     http://www.drbd.org/fileadmin/drbd/publications/drbd_lk9.pdf
> 
> I really must read and understand this paper..
> 
> 
> So... what would you think of working towards incorporating all of the
> DRBD functionality into md/raid1??
> I suspect that it would be a mutually beneficial exercise, except for
> the small fact that it would take a significant amount of time and
> effort.  I'd be will to shuffle some priorities and put in some effort
> if it was a direction that you would be open to exploring.

Sure. But yes, full ack on the time and effort part ;)

> Whether the current DRBD code gets merged or not is possibly a
> separate question, though I would hope that if we followed the path of
> merging DRBD into md/raid1, then any duplicate code would eventually be
> excised from the kernel.

Rumor [http://lwn.net/Articles/326818/] has it, that the various in
kernel raid implementations are being unified right now, anyways?

If you want to stick to "replication is almost identical to RAID1",
best not to forget "this may be a remote mirror", there may be more than
one entity accessing it, this may be part of a bi-directional
(active-active) replication setup.

For further ideas on what could be done with replication (enhancing the
strict "raid1" notion), see also
http://www.drbd.org/fileadmin/drbd/publications/drbd9.linux-kongress.2008.pdf

 - time shift replication
 - generic point in time recovery of block device data
 - (remote) backup by periodically, round-robin re-sync of
   "raid" members, then "dropping" them again.
 ...

No useable code on those ideas, yet,
but a lot of thought. It is not all handwaving.

	Lars
