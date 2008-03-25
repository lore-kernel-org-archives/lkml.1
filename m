Return-Path: <linux-kernel-owner+w=401wt.eu-S1760055AbYCYU5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055AbYCYU5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYCYU5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:57:16 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34610 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbYCYU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:57:14 -0400
Date: Tue, 25 Mar 2008 16:51:17 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Ric Wheeler <ric@emc.com>, Matthew Wilcox <matthew@wil.cx>,
       Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH l <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Message-ID: <20080325205117.GP16358@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <ric@emc.com>,
	Matthew Wilcox <matthew@wil.cx>, Mark Lord <lkml@rtr.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
	Tejun Heo <htejun@gmail.com>, Greg KH l <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	linux-scsi <linux-scsi@vger.kernel.org>
References: <47E875AD.1000901@rtr.ca> <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org> <47E8FF58.8050209@rtr.ca> <47E90CDA.600@emc.com> <20080325153423.GD16721@parisc-linux.org> <47E91EE2.9080801@emc.com> <20080325164750.GG16358@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080325164750.GG16358@mit.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 12:47:50PM -0400, Theodore Tso wrote:
> 
> Well 2TB, assuming a 4k blocksize, means a block bitmap is 512 megs.
> So at least for ext3, 4GB should be just enough, unless you hit
> certainly really nasty complicated corruptions (i.e. large number of
> blocks claimed by more than one inode, which can happen if an inode
> table is written to the wrong location on disk --- on top of some
> other portion of the inode table), or if the filesystem has a large
> number of files with hard links (such as the case with certain backup
> programs).

Whoops, screwed up my math.  The block bitmap for a 2TB filesystem is
64 megs, not 512 megs.  2*41 / 2**12 / 2**3 == 2**26, or 64mb.  E2fsck
in the worst case will allocate 5 inode bitmaps and 3 block bitmaps,
plus various arrays for directory blocks and keeping track of
refcounts (which are optimized for counnts of 0 and 1, so lots of hard
links will blow up your memory usage, although we do have a tdb option
which helps in that particular case).  So I'd say that most of the
time 3GB of address space should really be enough for a 2TB raid
array, unless you get really pathalogical corruption cases.

							- Ted
