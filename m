Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYIIWa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYIIWa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYIIWaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:30:18 -0400
Received: from phunq.net ([64.81.85.152]:37440 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753808AbYIIWaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:30:16 -0400
X-Greylist: delayed 3143 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2008 18:30:16 EDT
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 Report: One less feature
Date: Tue, 9 Sep 2008 14:37:52 -0700
User-Agent: KMail/1.9.5
Cc: tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091437.52226.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Last week, the subvolumes feature was dropped from Tux3.  I thought it
would be worth explaining why, because it says something about the Tux3
design philosophy and the direction I think we ought to be headed.

A subvolume is a separately mountable filesystem that coexists with
other subvolumes in a single, physical volume.  For a tree-structured
filesystem, which is to say, nearly every modern filesystem, having
subvolumes just requires adding more tree roots.  Nothing could be
simpler, right?

Well, almost.  All subvolumes allocate from the same free space pool,
and indeed the idea of unifying allocation is the main argument for
having subvolumes.  Otherwise why not just have separate volumes?

Since subvolumes cost very little to implement and apparently are
useful, adding a volume table to Tux3 was an easy call:

   http://lwn.net/Articles/293645/

Code was duly written to manage the volume table, about 150 lines.  So
far, so good.  Then a fly flew into the ointment.  What about fsync?

Each fsync requires the disk image of the allocation map to be up to
date and consistent with the synced filesystem image.  But the
allocation map is shared by all subvolumes, so what do we do, sync
all of them?  Or design the allocation subsystem so that it can be
separately synced per subvolume?

Worried about performance artifacts from the first approach, I
investigated the second:

   http://article.gmane.org/gmane.comp.file-systems.tux3/81

Solution number four in that post is maybe the most efficient and least
invasive.  There is just one thing wrong with it: it describes exactly
what logical volume managers already do.  And why are we incorporating
a volume manager into Tux3 to implement this feature when the only
argument for having the feature is to share the allocation space?  And
if the most efficient way to share the allocation space is to act like
a volume manager, then why not just use a volume manager?

It is not that it would be hard to implement the subvolume feature by
any of the methods I described.  It is just that it feels wrong from a
philosophical standpoint.  So after fretting about this for a few days
I decided to drop this questionable feature.  If that means Tux3 has to
suffer feelings of inadequacy compared to ZFS, then so be it.  Tux3 is
going to rely on a separate volume manager and that is that, unless
somebody comes up with a compelling reason why an efficient layering
cannot be achieved.  (Note: this conviction relies partly on the
expectation that the existing LVM will be improved to be more capable,
see the nascent LVM3 design work.)

This is not in any way a swipe at Btrfs, which has subvolumes and does
integrate a number of volume manager features, as ZFS does.  I think
that is the correct decision for that project.  If the goal is to match
ZFS feature for feature, then be sure to cover them all, there are very
good logistical reasons for doing that.  But I do not see the blurring
of the traditional layering between filesystem and block device as a
good or necessary thing.  One could say that ZFS already suffers
negative effects from that design approach in that the majority of open
bugs they have seem to be related to volume management rather than the
filesystem proper.

I just think it is important for a filesystem to be as simple as
possible, if it aims to be reliable.

Regards,

Daniel
