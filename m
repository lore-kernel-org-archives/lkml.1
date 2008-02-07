Return-Path: <linux-kernel-owner+w=401wt.eu-S1764692AbYBGAdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764692AbYBGAdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764468AbYBGAAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:00:44 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62157 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764299AbYBGAAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:00:38 -0500
Date: Wed, 06 Feb 2008 19:00:20 -0500
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
In-reply-to: <200801260827.59675.a1426z@gawab.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Message-id: <20080207000020.GB3149@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <200801242336.00340.a1426z@gawab.com>
 <20080125153634.GG28856@atrey.karlin.mff.cuni.cz>
 <200801260827.59675.a1426z@gawab.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 26, 2008  08:27 +0300, Al Boldi wrote:
> Jan Kara wrote:
> > > data=ordered mode has proven reliable over the years, and it does this
> > > by ordering filedata flushes before metadata flushes.  But this
> > > sometimes causes contention in the order of a 10x slowdown for certain
> > > apps, either due to the misuse of fsync or due to inherent behaviour
> > > like db's, as well as inherent starvation issues exposed by the
> > > data=ordered mode.
> > >
> > > data=writeback mode alleviates data=order mode slowdowns, but only works
> > > per-mount and is too dangerous to run as a default mode.
> > >
> > > This RFC proposes to introduce a tunable which allows to disable fsync
> > > and changes ordered into writeback writeout on a per-process basis like
> > > this:
> > >
> > >       echo 1 > /proc/`pidof process`/softsync
> >
> >   I guess disabling fsync() was already commented on enough. Regarding
> > switching to writeback mode on per-process basis - not easily possible
> > because sometimes data is not written out by the process which stored
> > them (think of mmaped file).
> 
> Do you mean there is a locking problem?
> 
> > And in case of DB, they use direct-io
> > anyway most of the time so they don't care about journaling mode anyway.
> 
> Testing with sqlite3 and mysql4 shows that performance drastically improves 
> with writeback writeout.
> 
> >  But as Diego wrote, there is definitely some room for improvement in
> > current data=ordered mode so the difference shouldn't be as big in the
> > end.
> 
> Yes, it would be nice to get to the bottom of this starvation problem, but 
> even then, the proposed tunable remains useful for misbehaving apps.

Al, can you try a patch posted to linux-fsdevel and linux-ext4 from
Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> to see if this improves
your situation?  Dated Mon, 04 Feb 2008 19:15:25 +0900.

    [PATCH] ext3,4:fdatasync should skip metadata writeout when overwriting

It may be that we already have a solution in that patch for database
workloads where the pages are already allocated by avoiding the need
for ordered mode journal flushing in that case.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

