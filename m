Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZAEUT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZAEUT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbZAEUTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:19:51 -0500
Received: from thunk.org ([69.25.196.29]:52209 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbZAEUTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:19:49 -0500
Date: Mon, 5 Jan 2009 15:19:28 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Pavel Machek <pavel@suse.cz>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090105201928.GD8939@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Pavel Machek <pavel@suse.cz>, Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net> <20090104225545.GF1913@elf.ucw.cz> <yq1r63i30bv.fsf@sermon.lab.mkp.net> <20090105094504.GB27199@atrey.karlin.mff.cuni.cz> <yq1sknx1s4f.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1sknx1s4f.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 02:15:44PM -0500, Martin K. Petersen wrote:
> 
> It works some of the time.  But in reality if you yank power halfway
> during a write operation the end result is undefined.
> 
> The saving grace for normal users is that the potential corruption is
> limited to a couple of sectors.

A few years ago it was asserted to me that the internal block size for
spinning magnetic media was around 32k.  So if the hard drive doesn't
have enough of a capacitor or other energy reserve to complete its
internal read-modify-write cycle, attempts to read the 32k chunk of
disk could result in hard ECC failures that would cause the blocks in
question to all return uncorrectiable read errors when they are
accessed.

Of course, if the memory goes south first, and you're in the middle of
streaming a 128k update to the inode the filesystem, and the power
fails, and the memory start returning garbage during the DMA
operation, you may have much bigger problems.  :-)

So it's probably more than "a couple of sectors"....

> The current suck of flash SSDs is that the erase block size amplifies
> this problem by at least one order of magnitude, often two.  I have a
> couple of SSDs here that will leave my filesystem in shambles every time
> the machine crashes.  I quickly got tired of reinstalling Fedora several
> times per week so now my main machine is back to spinning media.

The erase block size is typically 1 to 4 megabytes, from my
understanding.  So yeah, that's easily 1-2 orders of magnitude.  Worse
yet, flash's sequential streaming write speeds are much slower than
hard drive's (anywhere from a factor of 3 to 12 depending on
cheap/trashy the flash drive happens to be), so that opens the time
window even further, by possibly as much as another order of magnitude.

I also suspect that HDD manufactures have learned various tricks (due
to enterprise storage/database vendors leaning on them) to make the
drives appear more atomic in the face of hard drive errors, and also,
in Pavel's case, as I recall he was using the card in a laptop where
the SD card protruded slightly from the laptop case, and it was very
easy for it to get dislodged, meaning that power failures during
writes were even more likely than you would expect with a fixed HDD or
SDD which is secured into place using screws or other more reliable
mounting hardware.

Put all of this together, given that Pavel's Really Trashy 32GB SD was
probably the full 3 orders of magnitude worse than traditional HDD,
and he was having many more failures due to physical mounting issues,
it's not surprising that most people haven't see problems with
traditional HDD's, even none of this is guaranteed by the hard drive
vendors.

> The people that truly and deeply care about this type of write atomicity
> (i.e. enterprises) deploy disk arrays that will do the right thing in
> face of an error.  This involves NVRAM, mirrored caches, uninterruptible
> power supplies, etc.  Brute force if you will.

Don't forget non-cheasy mounting options so an accidental brush
against the side of the unit doesn't cause the hard drive to become
disconnected from system and suffer a power drop.  I guess that gets
filed under "Brute force" as well.  :-)

							- Ted

P.S.  I feel obliged to point out that in my Lenovo X61s, the SD card
is flush with the laptop case when inserted, and I've never had a
problem with the SD card prematurely ejected during operaiton.   :-)

