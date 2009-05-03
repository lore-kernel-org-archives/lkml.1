Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZECVdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZECVdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 17:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZECVdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:33:31 -0400
Received: from [212.69.161.110] ([212.69.161.110]:46422 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZECVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:33:30 -0400
Date: Sun, 3 May 2009 23:32:31 +0200
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
Message-ID: <20090503213231.GA6243@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <18941.12645.590037.589600@notabene.brown> <20090503082931.GD31340@racke> <18941.31069.695554.862567@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18941.31069.695554.862567@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 09:00:45PM +1000, Neil Brown wrote:
> On Sunday May 3, lars.ellenberg@linbit.com wrote:
> > > If there some strong technical reason to only allow 2 nodes?
> > 
> > It "just" has not yet been implemented.
> > I'm working on that, though.
> 
> :-)
> 
> > 
> > > >     How do you fit that into a RAID1+NBD model ? NBD is just a block
> > > >     transport, it does not offer the ability to exchange dirty bitmaps or
> > > >     data generation identifiers, nor does the RAID1 code has a concept of
> > > >     that.
> > > 
> > > Not 100% true, but I - at least partly -  get your point.
> > > As md stores bitmaps and data generation identifiers on the block
> > > device, these can be transferred over NBD just like any other data on
> > > the block device.
> > 
> > Do you have one dirty bitmap per mirror (yet) ?
> > Do you _merge_ them?
> 
> md doesn't merge bitmaps yet.  However if I found a need to, I would
> simple read a bitmap in userspace and feed it into the kernel via 
> 	/sys/block/mdX/md/md/bitmap_set_bits

ah, ok.  right.  that would do it.

> We sort-of have one bitmap per mirror, but only because the one bitmap
> is mirrored...

Which it could not be while replication link is down,
so once replication link is back (or remote node is back,
which is not easily distinguishable just there, blablabla),
you'd need to fetch the remote bitmap, and merge it with the local
bitmap (feeding it into bitmap_set_bits),
then re-attach the "failed" mirror.

The reasoning in the commit 9b1d1dac181d8c1b9492e05cee660a985d035a06,
which adds that feature, exactly describes this use case.

There, again, our simple run-length encoding scheme does make very much
sense, as the numbers dropping out of it during decoding are exactly
the runlengths, and could be fed into this almost directly.

> > the "NBD" mirrors are remote, and once you lose communication,
> > they may be (and in general, you have to assume they are) modified
> > by which ever node they are directly attached to.
> > 
> > > However I think that part of your point is that DRBD can transfer them
> > > more efficiently (e.g. it compresses the bitmap before transferring it
> > > -  I assume the compression you use is much more effective than gzip??
> > > else why both to code your own).
> > 
> > No, the point was that we have one bitmap per mirror (though currently
> > number of mirrors == 2, only), and that we do merge them.
> 
> Right.  I imagine much of the complexity of that could be handled in
> user-space while setting an a DRBD instance (??).

possibly.
you'd need to involve these steps on each and every communication loss
and network handshake.  I think that would make the system slower to
react on e.g. "flaky" replication links.

you are thinking in the "MD" paradigma: at any point in time, there is
only one MD instance involved, the mirror transports (currently dumb
block devices) simply do what they are told.

in DRBD, we have multiple (ok, two) instances talking to each other,
and I think that is the better approach for (remote) replication.

> > but to answer the question:
> > why bother to implement our own encoding?
> > because we know a lot about the data to be encoded.
> > 
> > the compression of the bitmap transfer we just added very recently.
> > for a bitmap, with large chunks of bits set or unset, it is efficient
> > to just code the runlength.
> > to use gzip in kernel would add yet an other huge overhead for code
> > tables and so on.
> > during testing of this encoding, applying it to an already gzip'ed file
> > was able to compress it even further, btw.
> > though on english plain text, gzip compression is _much_ more effective.
> 
> I just tried a little experiment.
> I created a 128meg file and randomly set 1000 bits in it.
> I compressed it with "gzip --best" and the result was 4Meg.  Not
> particularly impressive.
> I then tried to compress it wit bzip2 and got 3452 bytes.
> Now *that* is impressive.  I suspect your encoding might do a little
> better, but I wonder if it is worth the effort.

The effort is minimal.
The cpu overhead is negligible (compared with bzip2, or any other
generic compression scheme), and the memory overhead is next to none
(just a small scratch buffer, to assemble the network packet).
No tables or anything involved.
Especially the _decoding_ part has this nice property:
  chunk = 0;
  while (!eof) {
	vli_decode_bits(&rl, input); /* number of unset bits */
	chunk += rl;
	vli_decode_bits(&rl, input); /* number of set bits */
	bitmap_dirty_bits(bitmap, chunk, chunk + rl);
	chunk += rl;
 }

The source code is there.

For your example, on average you'd have (128 << 23) / 1000 "clear" bits,
then one set bit. The encoding transfers
"first bit unset -- ca. (1<<20), 1, ca. (1<<20), 1, ca. (1<<20), 1, ...",
using 2 bits for the "1", and up to 29 bit for the "ca. 1<<20".
should be in the very same ballpark as your bzip2 result.

> I'm not certain that my test file is entirely realistic, but it is
> still an interesting experiment.

It is not ;) but still...
If you are interessted, I can dig up my throw away user land code,
that has been used to evaluate various such schemes.
But it is so ugly that I won't post it to lkml.

> Why do you do this compression in the kernel?  It seems to me that it
> would be quite practical to do it all in user-space, thus making it
> really easy to use pre-existing libraries.

Because the bitmap exchange happens in kernel.

If considering to rewrite a replication solution,
one can start to reconsider design choices.

But DRBD as of now does the connection handshake and bitmap exchange in
kernel.  We wanted to have a fast compression scheme suitable for
bitmaps, without cpu or memory overhead.  This does it quite nicely.

I can dig up my userland throwaway code used during evaluation
of various encoding schemes again, if you are interessted.

> BTW, the kernel already contains various compression code as part of
> the crypto API.

Of course I know.  But you are not really suggesting that I should do
bzip2 in kernel to exchange the bitmap. And on decoding, I want those
runlengths, not the actual plain bitmap.

> > > You say "nor does the RAID1 code has a concept of that".  It isn't
> > > clear what you are referring to.
> > 
> > The concept that one of the mirrors (the "nbd" one in that picture)
> > may have been accessed independently, without MD knowning,
> > because the node this MD (and its "local" mirror) was living on
> > suffered from power outage.

or the link has been down,
and the remote side decided to go active with it.

or the link has been taken down,
to activate the other side, knowingly creating a data set divergence,
to do some off-site processing.

> > The concept of both mirrors being modified _simultaneously_,
> > (e.g. living below a cluster file system).
> 
> Yes, that is an important concept.  Certainly one of the bits that
> would need to be added to md.
> 
> > > Whether the current DRBD code gets merged or not is possibly a
> > > separate question, though I would hope that if we followed the path of
> > > merging DRBD into md/raid1, then any duplicate code would eventually be
> > > excised from the kernel.
> > 
> > Rumor [http://lwn.net/Articles/326818/] has it, that the various in
> > kernel raid implementations are being unified right now, anyways?
> 
> I'm not holding my breath on that one...  
> I think that merging DRBD with md/raid1 would be significantly easier
> that any sort of merge between md and dm.  But (in either case) I'll
> do what I can to assist any effort that is technically sound.

D'accord.

> > If you want to stick to "replication is almost identical to RAID1",
> > best not to forget "this may be a remote mirror", there may be more than
> > one entity accessing it, this may be part of a bi-directional
> > (active-active) replication setup.
> > 
> > For further ideas on what could be done with replication (enhancing the
> > strict "raid1" notion), see also
> > http://www.drbd.org/fileadmin/drbd/publications/drbd9.linux-kongress.2008.pdf
> > 
> >  - time shift replication
> >  - generic point in time recovery of block device data
> >  - (remote) backup by periodically, round-robin re-sync of
> >    "raid" members, then "dropping" them again.
> >  ...
> > 
> > No useable code on those ideas, yet,
> > but a lot of thought. It is not all handwaving.
> 
> :-)
> 
> I'll have to do a bit of reading I see.  I'll then try to rough out a
> design and plan for merging DRBD functionality with md/raid1.  At the
> very least that would give me enough background understanding to be
> able to sensibly review your code submission.

Thanks.  Please give particular attention to the "taxonomy paper"
referenced therein, so we are going to use the same terms.

	Lars
