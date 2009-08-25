Return-Path: <linux-kernel-owner+w=401wt.eu-S932362AbZHYX2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbZHYX2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932312AbZHYX2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:28:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:35931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287AbZHYX2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:28:20 -0400
From: Neil Brown <neilb@suse.de>
To: Greg Freemyer <greg.freemyer@gmail.com>
Date: Wed, 26 Aug 2009 09:28:50 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19092.29618.98997.854784@notabene.brown>
Cc: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
       Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is 
	possible
In-Reply-To: message from Greg Freemyer on Monday August 24
References: <20090312092114.GC6949@elf.ucw.cz>
	<200903121413.04434.rob@landley.net>
	<20090316122847.GI2405@elf.ucw.cz>
	<200903161426.24904.rob@landley.net>
	<20090323104525.GA17969@elf.ucw.cz>
	<87ljqn82zc.fsf@frosties.localdomain>
	<20090824093143.GD25591@elf.ucw.cz>
	<87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday August 24, greg.freemyer@gmail.com wrote:
> > +Don't damage the old data on a failed write (ATOMIC-WRITES)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Either whole sector is correctly written or nothing is written during
> > +powerfail.
> > +
> > +       Because RAM tends to fail faster than rest of system during
> > +       powerfail, special hw killing DMA transfers may be necessary;
> > +       otherwise, disks may write garbage during powerfail.
> > +       This may be quite common on generic PC machines.
> > +
> > +       Note that atomic write is very hard to guarantee for RAID-4/5/6,
> > +       because it needs to write both changed data, and parity, to
> > +       different disks. (But it will only really show up in degraded mode).
> > +       UPS for RAID array should help.
> 
> Can someone clarify if this is true in raid-6 with just a single disk
> failure?  I don't see why it would be.

It does affect raid6 with a single drive missing.

After an unclean shutdown you cannot trust any Parity block as it
is possible that some of the blocks in the stripe have been updated,
but others have not.  So you must assume that all parity blocks are
wrong and update them.  If you have a missing disk you cannot do that.

To take a more concrete example, imagine a 5 device RAID6 with
3 data blocks D0 D1 D2 as well a P and Q on some stripe.
Suppose that we crashed while updating D0, which would have involved
writing out D0, P and Q.
On restart, suppose D2 is missing. It is possible that 0, 1, 2, or 3
of D0, P and Q have been updated and the others not.
We can try to recompute D2 from D0 D1 and P, from
D0 P and Q or from D1, P and Q.

We could conceivably try each of those and if they all produce the
same result we might be confident of it.
If two produced the same result and the other was different we could
use a voting process to choose the 'best'.  And in this particular
case I think that would work.  If 0 or 3 had been updates, all would
be the same.  If only 1 was updated, then the combinations that
exclude it will match.  If 2 were updated, then the combinations that
exclude the non-updated block will match.

But if both D0 and D1 were being updated I think there would be too
many combinations and it would be very possibly that all three
computed values for D2 would be different.

So yes: a singly degraded RAID6 cannot promise no data corruption
after an unclean shutdown.  That is why "mdadm" will not assemble such
an array unless you use "--force" to acknowledge that there has been a
problem. 

NeilBrown
