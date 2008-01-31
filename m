Return-Path: <linux-kernel-owner+w=401wt.eu-S933773AbYAaRQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbYAaRQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbYAaRQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:16:38 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:35708 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534AbYAaRQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:16:36 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Thu, 31 Jan 2008 12:14:54 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Al Boldi <a1426z@gawab.com>, Andreas Dilger <adilger@sun.com>,
       Chris Snook <csnook@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <200801311156.01768.chris.mason@oracle.com> <20080131171040.GL1461@duck.suse.cz>
In-Reply-To: <20080131171040.GL1461@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311214.55287.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008, Jan Kara wrote:
> On Thu 31-01-08 11:56:01, Chris Mason wrote:
> > On Thursday 31 January 2008, Al Boldi wrote:
> > > Andreas Dilger wrote:
> > > > On Wednesday 30 January 2008, Al Boldi wrote:
> > > > > And, a quick test of successive 1sec delayed syncs shows no hangs
> > > > > until about 1 minute (~180mb) of db-writeout activity, when the
> > > > > sync abruptly hangs for minutes on end, and io-wait shows almost
> > > > > 100%.
> > > >
> > > > How large is the journal in this filesystem?  You can check via
> > > > "debugfs -R 'stat <8>' /dev/XXX".
> > >
> > > 32mb.
> > >
> > > > Is this affected by increasing
> > > > the journal size?  You can set the journal size via "mke2fs -J
> > > > size=400" at format time, or on an unmounted filesystem by running
> > > > "tune2fs -O ^has_journal /dev/XXX" then "tune2fs -J size=400
> > > > /dev/XXX".
> > >
> > > Setting size=400 doesn't help, nor does size=4.
> > >
> > > > I suspect that the stall is caused by the journal filling up, and
> > > > then waiting while the entire journal is checkpointed back to the
> > > > filesystem before the next transaction can start.
> > > >
> > > > It is possible to improve this behaviour in JBD by reducing the
> > > > amount of space that is cleared if the journal becomes "full", and
> > > > also doing journal checkpointing before it becomes full.  While that
> > > > may reduce performance a small amount, it would help avoid such huge
> > > > latency problems. I believe we have such a patch in one of the Lustre
> > > > branches already, and while I'm not sure what kernel it is for the
> > > > JBD code rarely changes much....
> > >
> > > The big difference between ordered and writeback is that once the
> > > slowdown starts, ordered goes into ~100% iowait, whereas writeback
> > > continues 100% user.
> >
> > Does data=ordered write buffers in the order they were dirtied?  This
> > might explain the extreme problems in transactional workloads.
>
>   Well, it does but we submit them to block layer all at once so elevator
> should sort the requests for us...

nr_requests is fairly small, so a long stream of random requests should still 
end up being random IO.

Al, could you please compare the write throughput from vmstat for the 
data=ordered vs data=writeback runs?  I would guess the data=ordered one has 
a lower overall write throughput.

-chris
