Return-Path: <linux-kernel-owner+w=401wt.eu-S967603AbXEHC12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967603AbXEHC12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 22:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966892AbXEHC1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 22:27:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56098 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966882AbXEHC1Y (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 22:27:24 -0400
Date: Tue, 8 May 2007 12:26:50 +1000
From: David Chinner <dgc@sgi.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: adilger@clusterfs.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070508022650.GA32602149@melbourne.sgi.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com> <20070430052559.GA13145@tuatara.stupidest.org> <20070502125312.GA5845@amitarora.in.ibm.com> <E1HjZOa-0003iJ-PX@n2o.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HjZOa-0003iJ-PX@n2o.xs4all.nl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 01:22:48PM +0200, Miquel van Smoorenburg wrote:
> In article <20070503103425.GE6220@schatzie.adilger.int> you write:
> >On May 02, 2007  18:23 +0530, Amit K. Arora wrote:
> >> On Sun, Apr 29, 2007 at 10:25:59PM -0700, Chris Wedgwood wrote:
> >> > On Mon, Apr 30, 2007 at 10:47:02AM +1000, David Chinner wrote:
> >> > 
> >> > > For FA_ALLOCATE, it's supposed to change the file size if we
> >> > > allocate past EOF, right?
> >> > 
> >> > I would argue no.  Use truncate for that.
> >> 
> >> The patch I posted for ext4 *does* change the filesize after
> >> preallocation, if required (i.e. when preallocation is after EOF).
> >> I may have to change that, if we decide on not doing this.
> >
> >I think I'd agree - it may be useful to allow preallocation beyond EOF
> >for some kinds of applications (e.g. PVR preallocating live TV in 10
> >minute segments or something, but not knowing in advance how long the
> >show will actually be recorded or the final encoded size).
> 
> I have an application (diablo dreader) where the header-info database
> basically consists of ~40.000 files, one for each group (it's more
> complicated that that, but never mind that now).
> 
> If you grow those files randomly by a few hundred bytes every update,
> the filesystem gets hopelessly fragmented.
> 
> I'm using XFS with preallocation turned on, and biosize=18 (which
> makes it preallocate in blocks of 256KB), and a homebrew patch that
> leaves the preallocated space on disk preallocated even if the
> file is closed .. and it helps enormously.

XFS always has speculative preallocation turned on - this is
different to explicit preallocation which we are talking about
here ;)

FWIW, the reason you need your homebrew patch is that specualtive
allocation does not set the PREALLOC bit on the inode, and so when
you close the file the speculative prealloc gets truncated away.
If you use a real preallocation (XFS_IOC_RESVSP64) or the upcoming
fallocate() syscall, XFS also sets the PREALLOC bit in the inode so
it doesn't get truncated away on file close.

If you don't want to use XFS_IOC_RESVSP64, you could just use
XFS_IOC_FSSETXATTR to set the prealloc bit on the files you care
about so you don't need a hack in XFS to prevent truncation of
speculative allocation on file close.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
