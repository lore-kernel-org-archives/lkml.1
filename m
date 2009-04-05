Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZDEELg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZDEELg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 00:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbZDEEJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 00:09:42 -0400
Received: from thunk.org ([69.25.196.29]:54149 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758805AbZDEEJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 00:09:40 -0400
Date: Sat, 4 Apr 2009 21:28:39 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Message-ID: <20090405012839.GF7553@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ric Wheeler <rwheeler@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
References: <20090324150517.GX27476@kernel.dk> <Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com> <20090325152751.GV27476@kernel.dk> <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com> <20090326084205.GG27476@kernel.dk> <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com> <20090331104933.GJ5178@kernel.dk> <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com> <20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D77AC3.3020207@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 04, 2009 at 11:20:35AM -0400, Ric Wheeler wrote:
> Barriers do work as we have them, but as others have mentioned, it is  
> not a "free" win - fsync will actually move your data safely out to  
> persistent storage for a huge percentage of real users (including every  
> ATA/S-ATA and SAS drive I was able to test).  The file systems I  
> monitored in production use without barriers were much less reliable.

The problem is that, as long as you're not under memory pressure, and
not pushing the filesystem heavily, ext3 didn't corrupt *that* often
without barriers.  So people got away with it "most of the time" ---
just as applications replacing files by rewriting them in place using
truncate and w/o fsync would "usually" not lose data after a crash if
they were using ext3 with data=ordered mode.  This caused people to
get lazy/sloppy.

So yes, barriers were something that were largely ignored for a long
time.  After all, in a server environment with UPS's, without crappy
proprietary video drivers, Linux systems didn't crash that often
anyway.  So you really needed a large base of systems and with the
ability to root cause failures such as what Ric had at EMC to see the
problem.

Even now, the reason why ext3 doesn't have barriers enabled by default
(although we did make them the default for ext4) is because Andrew
doesn't believe Chris's replication case is likely to be true for most
users in practice, and he's concerned about the performance
degradation of barriers.  He's basically depending on the fact that
"usually" you can get away without using barriers.  Sigh....

						- Ted

P.S.  Of course, distributions should feel free to consider changing
the default on their kernels.  SLES has already if memory serves
correctly.  I don't know if RHEL has yet.

