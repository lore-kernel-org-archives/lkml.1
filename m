Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYAFPqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYAFPqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbYAFPqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:46:31 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58211 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbYAFPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:46:30 -0500
Date: Sun, 6 Jan 2008 17:45:58 +0200
From: Adrian Bunk <bunk@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
Message-ID: <20080106154557.GK2082@does.not.exist>
References: <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <1199304735.3258.53.camel@localhost.localdomain> <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain> <20080106144706.GA25419@elte.hu> <1199632845.5205.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1199632845.5205.31.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 09:20:45AM -0600, James Bottomley wrote:
> 
> On Sun, 2008-01-06 at 15:47 +0100, Ingo Molnar wrote:
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > > I can repeat this bug, both with and without the scsi patch that is 
> > > > claimed to make a difference, both with an external USB drive and an 
> > > > internal IDE drive.
> > > > 
> > > > To repeat:
> > > > 
> > > >   1. Start with an empty drive.
> > > >   2. pktsetup 0 /dev/scd0 
> > > >   3. Insert a CD containing an isofs filesystem.
> > > >   4. mount /dev/pktcdvd/0 /mnt/tmp
> > > >   5. umount /mnt/tmp
> > > >   6. Press the eject button.
> > > >   7. Insert a DVD containing a non-writable filesystem.
> > > >   8. mount /dev/scd0 /mnt/tmp
> > > >   9. find /mnt/tmp -type f -print0 | xargs -0 sha1sum >/dev/null
> > > >   10. If the DVD contains data beyond the physical size of a CD, you
> > > >       get I/O errors in the terminal, and dmesg reports lots of
> > > >       "attempt to access beyond end of device" errors.
> > > 
> > > Brilliant!  I can confirm the reproduction of the bug too (that's with 
> > > the originally fingered commit reverted).
> > 
> > may i point out the obvious at this stage? The thing that finally got 
> > movement into this bug was ... :
> > 
> >    exposure on lkml
> 
> I won't disagree with that.  That's why my philosophy is to try to force
> all bug reports out of bugzilla and on to the relevant mailing list
> because of the many eyes approach this engenders.

The problem is that mailing lists are far too often equivalent to 
/dev/null for many bug reports.

Tracking e.g. helps with not missing regressions and getting more of 
them fixed.

And another of the advantages of using Bugzilla is that it gives us 
numbers how bad we are in terms of introducing regressions and having 
unfixed bugs, so developers are no longer able to tell we didn't have a 
problem in this area...

> > The reproducer came to you via Peter Osterlund who has never authored a 
> > single drivers/scsi/ commit before (according to git-log) and who (and 
> > here i'm out on a limb guessing it) does not even follow 
> > linux-scsi@vger.kernel.org.
> > 
> > this bug was obscure and hidden on linux-scsi@vger.kernel.org for 
> > _months_, (it is a rarely visited and rarely read mailing list) and 
> > there was just not enough "critical mass" to get this issue fixed.
> 
> If I were you, I'd actually make a cursory effort to get my facts
> straight before spouting off.
> 
> This bug was actually hidden in bugzilla for ages, where Matthew Wilcox
> was trying to deal with it on his own.  The first I heard of it (apart
> from a linux-scsi question on 13 November, when regrettably, I was busy
> with other things) was on 18 Dec when Natalie added me to the bugzilla
> cc list.  The first thing I did on that date was finger pktcdvd and add
> Jens to the cc list ... however, since there was no mailing list thread
> to follow he ended up asking for context which no-one provided.
> 
> The whole problem with this bug was generated precisely because it was
> kept in bugzilla where too few people actually looked at it.  You're the
> one who annotated the bugzilla entries with trite little homilies asking
> why there was no action *without* ever notifying any mailing list, I
> might add.
> 
> The fault lies in our bug processing methodology.  Bugzilla is a fine
> tracking tool, but it's a bloody useless workflow one for actually
> solving problems because, as you say, and I agree, the mailing lists are
> where we produce the solutions.
>...

Bugzilla for tracking and mailing lists for discussing are not mutually 
exclusive.

What about asking the Bugzilla admins to set the default owner of new 
SCSI bugs to linux-scsi@vger.kernel.org?

This way all SCSI bugs submitted in Bugzilla will automatically be 
forwarded to the linux-scsi mailing list.

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

