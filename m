Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZECLAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZECLAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZECLAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:00:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbZECLAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:00:39 -0400
From: Neil Brown <neilb@suse.de>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Date: Sun, 3 May 2009 21:00:45 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18941.31069.695554.862567@notabene.brown>
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
In-Reply-To: message from Lars Ellenberg on Sunday May 3
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	<18941.12645.590037.589600@notabene.brown>
	<20090503082931.GD31340@racke>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday May 3, lars.ellenberg@linbit.com wrote:
> > If there some strong technical reason to only allow 2 nodes?
> 
> It "just" has not yet been implemented.
> I'm working on that, though.

:-)

> 
> > >     How do you fit that into a RAID1+NBD model ? NBD is just a block
> > >     transport, it does not offer the ability to exchange dirty bitmaps or
> > >     data generation identifiers, nor does the RAID1 code has a concept of
> > >     that.
> > 
> > Not 100% true, but I - at least partly -  get your point.
> > As md stores bitmaps and data generation identifiers on the block
> > device, these can be transferred over NBD just like any other data on
> > the block device.
> 
> Do you have one dirty bitmap per mirror (yet) ?
> Do you _merge_ them?

md doesn't merge bitmaps yet.  However if I found a need to, I would
simple read a bitmap in userspace and feed it into the kernel via 
	/sys/block/mdX/md/md/bitmap_set_bits

We sort-of have one bitmap per mirror, but only because the one bitmap
is mirrored...

> 
> the "NBD" mirrors are remote, and once you lose communication,
> they may be (and in general, you have to assume they are) modified
> by which ever node they are directly attached to.
> 
> > However I think that part of your point is that DRBD can transfer them
> > more efficiently (e.g. it compresses the bitmap before transferring it
> > -  I assume the compression you use is much more effective than gzip??
> > else why both to code your own).
> 
> No, the point was that we have one bitmap per mirror (though currently
> number of mirrors == 2, only), and that we do merge them.

Right.  I imagine much of the complexity of that could be handled in
user-space while setting an a DRBD instance (??).

> 
> but to answer the question:
> why bother to implement our own encoding?
> because we know a lot about the data to be encoded.
> 
> the compression of the bitmap transfer we just added very recently.
> for a bitmap, with large chunks of bits set or unset, it is efficient
> to just code the runlength.
> to use gzip in kernel would add yet an other huge overhead for code
> tables and so on.
> during testing of this encoding, applying it to an already gzip'ed file
> was able to compress it even further, btw.
> though on english plain text, gzip compression is _much_ more effective.

I just tried a little experiment.
I created a 128meg file and randomly set 1000 bits in it.
I compressed it with "gzip --best" and the result was 4Meg.  Not
particularly impressive.
I then tried to compress it wit bzip2 and got 3452 bytes.
Now *that* is impressive.  I suspect your encoding might do a little
better, but I wonder if it is worth the effort.
I'm not certain that my test file is entirely realistic, but it is
still an interesting experiment.

Why do you do this compression in the kernel?  It seems to me that it
would be quite practical to do it all in user-space, thus making it
really easy to use pre-existing libraries.

BTW, the kernel already contains various compression code as part of
the crypto API.

> 
> > You say "nor does the RAID1 code has a concept of that".  It isn't
> > clear what you are referring to.
> 
> The concept that one of the mirrors (the "nbd" one in that picture)
> may have been accessed independently, without MD knowning,
> because the node this MD (and its "local" mirror) was living on
> suffered from power outage.
> 
> The concept of both mirrors being modified _simultaneously_,
> (e.g. living below a cluster file system).

Yes, that is an important concept.  Certainly one of the bits that
would need to be added to md.

> > Whether the current DRBD code gets merged or not is possibly a
> > separate question, though I would hope that if we followed the path of
> > merging DRBD into md/raid1, then any duplicate code would eventually be
> > excised from the kernel.
> 
> Rumor [http://lwn.net/Articles/326818/] has it, that the various in
> kernel raid implementations are being unified right now, anyways?

I'm not holding my breath on that one...  
I think that merging DRBD with md/raid1 would be significantly easier
that any sort of merge between md and dm.  But (in either case) I'll
do what I can to assist any effort that is technically sound.


> 
> If you want to stick to "replication is almost identical to RAID1",
> best not to forget "this may be a remote mirror", there may be more than
> one entity accessing it, this may be part of a bi-directional
> (active-active) replication setup.
> 
> For further ideas on what could be done with replication (enhancing the
> strict "raid1" notion), see also
> http://www.drbd.org/fileadmin/drbd/publications/drbd9.linux-kongress.2008.pdf
> 
>  - time shift replication
>  - generic point in time recovery of block device data
>  - (remote) backup by periodically, round-robin re-sync of
>    "raid" members, then "dropping" them again.
>  ...
> 
> No useable code on those ideas, yet,
> but a lot of thought. It is not all handwaving.

:-)

I'll have to do a bit of reading I see.  I'll then try to rough out a
design and plan for merging DRBD functionality with md/raid1.  At the
very least that would give me enough background understanding to be
able to sensibly review your code submission.

NeilBrown
