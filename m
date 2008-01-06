Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbYAFPVC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbYAFPVC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:21:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbYAFPUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:20:53 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42849 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922AbYAFPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:20:51 -0500
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
In-Reply-To: <20080106144706.GA25419@elte.hu>
References: <20080102162534.GA4041@elte.hu>
	 <1199292381.3258.32.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org>
	 <20080102194030.GC11638@parisc-linux.org>
	 <1199304735.3258.53.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org>
	 <1199316785.3258.85.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>
	 <m3ir27oe7f.fsf@telia.com> <1199627875.5205.1.camel@localhost.localdomain>
	 <20080106144706.GA25419@elte.hu>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 09:20:45 -0600
Message-Id: <1199632845.5205.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 15:47 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > I can repeat this bug, both with and without the scsi patch that is 
> > > claimed to make a difference, both with an external USB drive and an 
> > > internal IDE drive.
> > > 
> > > To repeat:
> > > 
> > >   1. Start with an empty drive.
> > >   2. pktsetup 0 /dev/scd0 
> > >   3. Insert a CD containing an isofs filesystem.
> > >   4. mount /dev/pktcdvd/0 /mnt/tmp
> > >   5. umount /mnt/tmp
> > >   6. Press the eject button.
> > >   7. Insert a DVD containing a non-writable filesystem.
> > >   8. mount /dev/scd0 /mnt/tmp
> > >   9. find /mnt/tmp -type f -print0 | xargs -0 sha1sum >/dev/null
> > >   10. If the DVD contains data beyond the physical size of a CD, you
> > >       get I/O errors in the terminal, and dmesg reports lots of
> > >       "attempt to access beyond end of device" errors.
> > 
> > Brilliant!  I can confirm the reproduction of the bug too (that's with 
> > the originally fingered commit reverted).
> 
> may i point out the obvious at this stage? The thing that finally got 
> movement into this bug was ... :
> 
>    exposure on lkml

I won't disagree with that.  That's why my philosophy is to try to force
all bug reports out of bugzilla and on to the relevant mailing list
because of the many eyes approach this engenders.

> The reproducer came to you via Peter Osterlund who has never authored a 
> single drivers/scsi/ commit before (according to git-log) and who (and 
> here i'm out on a limb guessing it) does not even follow 
> linux-scsi@vger.kernel.org.
> 
> this bug was obscure and hidden on linux-scsi@vger.kernel.org for 
> _months_, (it is a rarely visited and rarely read mailing list) and 
> there was just not enough "critical mass" to get this issue fixed.

If I were you, I'd actually make a cursory effort to get my facts
straight before spouting off.

This bug was actually hidden in bugzilla for ages, where Matthew Wilcox
was trying to deal with it on his own.  The first I heard of it (apart
from a linux-scsi question on 13 November, when regrettably, I was busy
with other things) was on 18 Dec when Natalie added me to the bugzilla
cc list.  The first thing I did on that date was finger pktcdvd and add
Jens to the cc list ... however, since there was no mailing list thread
to follow he ended up asking for context which no-one provided.

The whole problem with this bug was generated precisely because it was
kept in bugzilla where too few people actually looked at it.  You're the
one who annotated the bugzilla entries with trite little homilies asking
why there was no action *without* ever notifying any mailing list, I
might add.

The fault lies in our bug processing methodology.  Bugzilla is a fine
tracking tool, but it's a bloody useless workflow one for actually
solving problems because, as you say, and I agree, the mailing lists are
where we produce the solutions.

> _THAT_ is the power of lkml. People who are not generally interested in 
> your subsystem come and help. There is extra noise, but it's manageable.
> 
> so may i at this point suggest that you as the SCSI maintainer start 
> reading SCSI bugreports on lkml and start participating in SCSI topics 
> there, without extra prompting? It _is_ an important aggregation mailing 
> list for development, just like -mm or the upstream kernel is an 
> aggregation point of all things Linux.
> 
> I believe the "I only read linux-scsi, please post bugs there" approach 
> is harmful. If lkml traffic is too big then i'd suggest to set up email 
> filters to separate out mails that have 'SCSI' in their subject line or 
> body. Fortunately it's a really easy key to filter on. [ Scheduler mails 
> are much harder to filter out :-/ ] In fact i'd suggest to do all SCSI 
> development on lkml. We've got one upstream kernel codebase, one git 
> stream of commits and hence we should use one lkml feed to discuss 
> things on.

Oh good grief ... we do add other mailing lists to the cc list (most
often lkml) when it becomes evident that it's not a SCSI problem.  Most
bug reports actually start off going to a set of lists (including lkml)
anyway, so there's usually full context.  You may love drinking from the
firehose ... I find it makes me want to pee a lot.  Forcing your work
habits on everyone else isn't really a very community way of solving
anything.

James


