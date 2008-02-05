Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYBETV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYBETV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYBETVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:21:47 -0500
Received: from [212.12.190.177] ([212.12.190.177]:36421 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbYBETVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:21:46 -0500
From: Al Boldi <a1426z@gawab.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Tue, 5 Feb 2008 22:20:33 +0300
User-Agent: KMail/1.5
Cc: Chris Mason <chris.mason@oracle.com>, Andreas Dilger <adilger@sun.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <200802051007.44139.a1426z@gawab.com> <20080205150705.GC25464@duck.suse.cz>
In-Reply-To: <20080205150705.GC25464@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802052220.33135.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Tue 05-02-08 10:07:44, Al Boldi wrote:
> > Jan Kara wrote:
> > > On Sat 02-02-08 00:26:00, Al Boldi wrote:
> > > > Chris Mason wrote:
> > > > > Al, could you please compare the write throughput from vmstat for
> > > > > the data=ordered vs data=writeback runs?  I would guess the
> > > > > data=ordered one has a lower overall write throughput.
> > > >
> > > > That's what I would have guessed, but it's actually going up 4x fold
> > > > for mysql from 559mb to 2135mb, while the db-size ends up at 549mb.
> > >
> > >   So you say we write 4-times as much data in ordered mode as in
> > > writeback mode. Hmm, probably possible because we force all the dirty
> > > data to disk when committing a transation in ordered mode (and don't
> > > do this in writeback mode). So if the workload repeatedly dirties the
> > > whole DB, we are going to write the whole DB several times in ordered
> > > mode but in writeback mode we just keep the data in memory all the
> > > time. But this is what you ask for if you mount in ordered mode so I
> > > wouldn't consider it a bug.
> >
> > Ok, maybe not a bug, but a bit inefficient.  Check out this workload:
> >
> > sync;
> >
> > while :; do
> >   dd < /dev/full > /mnt/sda2/x.dmp bs=1M count=20
> >   rm -f /mnt/sda2/x.dmp
> >   usleep 10000
> > done
:
:
> > Do you think these 12mb redundant writeouts could be buffered?
>
>   No, I don't think so. At least when I run it, number of blocks written
> out varies which confirms that these 12mb are just data blocks which
> happen to be in the file when transaction commits (which is every 5
> seconds).

Just a thought, but maybe double-buffering can help?

> And to satisfy journaling gurantees in ordered mode you must
> write them so you really have no choice...

Making this RFC rather useful.

What we need now is an implementation, which should be easy.

Maybe something on these lines:

<< in ext3_ordered_write_end >>
  if (current->soft_sync & 1)
    return ext3_writeback_write_end;

<< in ext3_ordered_writepage >>
  if (current->soft_sync & 2)
    return ext3_writeback_writepage;

<< in ext3_sync_file >>
  if (current->soft_sync & 4)
    return ret;

<< in ext3_file_write >>
  if (current->soft_sync & 8)
    return ret;

As you can see soft_sync is masked and bits are ordered by importance.

It would be neat if somebody interested could cook-up a patch.


Thanks!

--
Al

