Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZADSjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZADSjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZADSiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:38:46 -0500
Received: from thunk.org ([69.25.196.29]:43068 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZADSin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:38:43 -0500
Date: Sun, 4 Jan 2009 13:38:34 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: document ext3 requirements
Message-ID: <20090104183834.GB17558@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090103123813.GA1512@ucw.cz> <4960BB2D.3060000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4960BB2D.3060000@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 06:35:41PM +0500, Alexander E. Patrakov wrote:
>
> Ext3 means either hardware that supports barriers (not sure how to  
> check

Pretty much all modern disk drives supports barriers.  And note that
w/o barriers ext3 has worked pretty well.  *If* you have a workload
pushes your system into a mode which where it is very low on memory,
so it is constantly paging/thrashing and you have a workload which is
metadata intensive, and you crash the machine while it is thrashing,
it is possible to end up in a situation where your filesystem is
corrupted and you have to use e2fsck to correct the filesystem.  In
practice this is often not the case, which is why the default for ext3
has been with barriers disabled, and most people have not noted major
problems.  This is why Andrew Morton has refused accept the patch for
ext3 which disables barriers by default; he's not convinced the
performance hit is worth the improvement in reliability.

Ext4 does enable barriers by defaults, mainly because filesystem
developers tend to be believe the reliability is more important than
performance.  (On the other hand, Google runs with ext2 w/o
journalling, because everything is replicated three times and it's
easier to just blow away the filesystem and resync from one of the
duplicate copies; so in the right circumstances, maybe worrying only
about performance and ignoring reliability makes perfect sense.)

> and anyway I have to use encryption on the work laptop due to the  
> corporate policy

If dm supported barriers, this wouldn't be an issue.  Personally, I
find the convenience of LVM is so useful that I use ext4 with LVM,
even though the barrier requests get dropped on the ground.  And I'm a
kernel developer, and I use a laptop with suspend/resume, which means
I often crash uncleanly --- and I've not lost data yet, despite the
lack of barriers.  (On the other hand, my laptop has 4 gigs of memory,
so I'm rarely thrashing due memory pressure.)

> or disabling write cache (but, as Alan Cox said, this  
> shortens the lifespan of the disk).

Huh?  I've never heard an assertion that disabling the write cache (I
assume you mean using write-through caching as opposed to write-back
caching), shortens the lifespan of disk drives.  Aggressive battery
saving mode is far more likely to shorten disk drive life, due to
spinning the platters up and down a lot.   

> Does this requirement apply to other  
> journaling filesystems? Do I need journaling at all, given that I have  
> an UPS on my desktop and a battery in the laptop?

Which requirement?  Barriers?  Most journaling filesystems simply
enable barriers by default.  

And journalling is useful so that if your system crashes, say due to
suspend and resume not working out, or the battery runs dry without
your noticing it, you can avoid running fsck at boot time.  It's
really more about shorting the boot time after a crash more than
anything else.

					- Ted
