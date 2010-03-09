Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0CIMWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:22:42 -0500
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:42268 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751Ab0CIMWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 07:22:38 -0500
Date: Tue, 9 Mar 2010 23:20:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Karel Zak <kzak@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>,
       Neil Brown <neilb@suse.de>
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100309122029.GO28189@discord.disaster>
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com> <4B95F071.3070400@msgid.tls.msk.ru> <20100309100153.GD18077@nb.net.home> <4B961FE1.5040105@msgid.tls.msk.ru> <20100309111523.GL28189@discord.disaster> <4B963351.50707@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B963351.50707@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 02:38:57PM +0300, Michael Tokarev wrote:
> Dave Chinner wrote:
> > On Tue, Mar 09, 2010 at 01:16:01PM +0300, Michael Tokarev wrote:
> >> Karel Zak wrote:
> >>> I did almost all my tests with scsi_debug or MD RAID0 on scsi_debug.
> >>> It works as expected.
> >> Actually, for raid0, the alignment is questionable.  Should it be a
> >> multiple of chunk size or whole stripe size?  I'm not sure, both ways
> >> has bad and good sides..  But if it is the latter, the same issues
> >> pops up again: do a 3-disk raid0 and you'll have to align to 3*2^N.
> > 
> > Yes, alignment is still needed, especially for filesystems that can
> > do stripe unit aligned allocation like XFS. If you don't align the
> > filesystem properly, all the data IO will be mis-aligned to the
> > underlying disks and stripe unit sized IO will hit multiple disks
> > rather than just one....
> 
> I understand alignment is needed, the question is if the alignment
> should be to chunk size or full-stripe size.  In neither case it
> will be bad for underlying disks.

Depends on the RAID implementation. High end RAID arrays often have
cache bypass features that are triggered by stripe width aligned and
sized IOs. cwWhen receiving well formed IO they can more than double
write performance because they are not limited by internal cache
mirroring bandwidth (e.g. the controller magically switches to
write-through for those well formed IOs instead of writeback).

So from that perspective, alignment needs to be to stripe width,
not stripe unit. Similarly for RAID5/6 alignment needs to be to
stripe width, so that a well formed IO issued by the filesystem
only hits one RAID5/6 stripe.

FWIW, XFS takes great care to ensure that it doesn't place all it's
allocation group headers on the same stripe unit.  Failing to
distribute the AG headers across all the ѕtripe units evenly loads
the disks/luns in the stripe unevenly. As soon as you have uneven
load on a stripe the performance tanks as stripe is only as fast as
it's slowest member.

Also, while XFS prefers to align to stripe unit, there are mount
options to change the default allocation alignment to be stripe
width based. Hence if you have large files and applications that are
doing well formed IO, stripe width alignment of the filesystem to
the underlying block device is critical to acheiving deterministic
throughput close to the maximum the hardware can support.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
