Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZFHXcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZFHXcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZFHXci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:32:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:43011 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbZFHXcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:32:36 -0400
From: Neil Brown <neilb@suse.de>
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Date: Tue, 9 Jun 2009 09:32:55 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18989.40871.865610.422540@notabene.brown>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [dm-devel] Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft
	RAID under Linux
In-Reply-To: message from Heinz Mauelshagen on Wednesday June 3
References: <18980.48553.328662.80987@notabene.brown>
	<4A25876A.1010901@garzik.org>
	<18981.62579.171350.910761@notabene.brown>
	<1244040123.6938.19.camel@o>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday June 3, heinzm@redhat.com wrote:
> > 
> > I haven't spoken to them, no (except for a couple of barely-related
> > chats with Alasdair).
> > By and large, they live in their little walled garden, and I/we live
> > in ours.
> 
> Maybe we are about to change that? ;-)

Maybe ... what should we talk about?

Two areas where I think we might be able to have productive
discussion:

 1/ Making md personalities available as dm targets.
    In one sense this is trivial as an block device can be a DM
    target, and any md personality can be a block device.
    However it might be more attractive if the md personality
    responded to dm ioctls.
    Considering specifically raid5, some aspects of plugging
    md/raid5 underneath dm would be trivial - e.g. assembling the
    array at the start.
    However others are not so straight forward.
    In particular, when a drive fails in a raid5, you need to update
    the metadata before allowing any writes which depend on that drive
    to complete.  Given that metadata is managed in user-space, this
    means signalling user-space and waiting for a response.
    md does this via a file in sysfs.  I cannot see any similar
    mechanism in dm, but I haven't looked very hard.

    Would it be useful to pursue this do you think?


 2/ It might be useful to have a common view how virtual devices in
    general should be managed in Linux.  Then we could independently
    migrated md and dm towards this goal.

    I imagine a block-layer level function which allows a blank
    virtual device to be created, with an arbitrary major/minor
    allocated.
    e.g.
         echo foo > /sys/block/.new
    causes
         /sys/devices/virtual/block/foo/
    to be created.
    Then a similar mechanism associates that with a particular driver.
    That causes more attributes to appear in  ../block/foo/ which
    can be used to flesh out the details of the device.

    There would be library code that a driver could use to:
      - accept subordinate devices
      - manage the state of those devices
      - maintain a write-intent bitmap
    etc.

    There would also need to be a block-layer function to 
    suspend/resume or similar so that a block device can be changed
    underneath a filesystem.

    We currently have three structures for a block device:
      struct block_device -> struct gendisk -> struct request_queue

    I imagine allow either the "struct gendisk" or  the "struct
    request_queue" to be swapped between two "struct block_device".
    I'm not sure which, and the rest of the details are even more
    fuzzy.

    That sort of infrastructure would allow interesting migrations
    without being limited to "just with dm" or "just within md".

    Thoughts?

NeilBrown
