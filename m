Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYBJOz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYBJOz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 09:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYBJOzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 09:55:12 -0500
Received: from [212.12.190.136] ([212.12.190.136]:36337 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbYBJOzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 09:55:10 -0500
From: Al Boldi <a1426z@gawab.com>
To: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Sun, 10 Feb 2008 17:54:24 +0300
User-Agent: KMail/1.5
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
References: <200801242336.00340.a1426z@gawab.com> <200801260827.59675.a1426z@gawab.com> <20080207000020.GB3149@webber.adilger.int>
In-Reply-To: <20080207000020.GB3149@webber.adilger.int>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802101754.25059.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger wrote:
> On Jan 26, 2008  08:27 +0300, Al Boldi wrote:
> > Jan Kara wrote:
> > > > data=ordered mode has proven reliable over the years, and it does
> > > > this by ordering filedata flushes before metadata flushes.  But this
> > > > sometimes causes contention in the order of a 10x slowdown for
> > > > certain apps, either due to the misuse of fsync or due to inherent
> > > > behaviour like db's, as well as inherent starvation issues exposed
> > > > by the data=ordered mode.
> > > >
> > > > data=writeback mode alleviates data=order mode slowdowns, but only
> > > > works per-mount and is too dangerous to run as a default mode.
> > > >
> > > > This RFC proposes to introduce a tunable which allows to disable
> > > > fsync and changes ordered into writeback writeout on a per-process
> > > > basis like this:
> > > >
> > > >       echo 1 > /proc/`pidof process`/softsync
> > >
> > >   I guess disabling fsync() was already commented on enough. Regarding
> > > switching to writeback mode on per-process basis - not easily possible
> > > because sometimes data is not written out by the process which stored
> > > them (think of mmaped file).
> >
> > Do you mean there is a locking problem?
> >
> > > And in case of DB, they use direct-io
> > > anyway most of the time so they don't care about journaling mode
> > > anyway.
> >
> > Testing with sqlite3 and mysql4 shows that performance drastically
> > improves with writeback writeout.
> >
> > >  But as Diego wrote, there is definitely some room for improvement in
> > > current data=ordered mode so the difference shouldn't be as big in the
> > > end.
> >
> > Yes, it would be nice to get to the bottom of this starvation problem,
> > but even then, the proposed tunable remains useful for misbehaving apps.
>
> Al, can you try a patch posted to linux-fsdevel and linux-ext4 from
> Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> to see if this improves
> your situation?  Dated Mon, 04 Feb 2008 19:15:25 +0900.
>
>     [PATCH] ext3,4:fdatasync should skip metadata writeout when
> overwriting
>
> It may be that we already have a solution in that patch for database
> workloads where the pages are already allocated by avoiding the need
> for ordered mode journal flushing in that case.

Well, it seems that it does have a positive effect for the 'konqueror hangs' 
case, but doesn't improve the db case.

This shouldn't be surprising, as the db redundant writeout problem is 
localized not in fsync but rather in ext3_ordered_write_end.

Maybe some form of a staged merged commit could help.


Thanks!

--
Al

