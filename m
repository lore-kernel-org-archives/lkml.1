Return-Path: <linux-kernel-owner+w=401wt.eu-S1751670AbZCYSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbZCYSar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbZCYSa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:30:26 -0400
Received: from THUNK.ORG ([69.25.196.29]:52633 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZCYSaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:30:25 -0400
Date: Wed, 25 Mar 2009 14:30:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Rees <drees76@gmail.com>
Cc: Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325183011.GN32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 12:00:41PM -0700, David Rees wrote:
> >>> Consensus seems to be something with large memory machines, lots of dirty
> >>> pages and a long writeout time due to ext3.
> >>
> >> All filesystems seem to suffer from this issue to some degree.  I
> >> posted to the list earlier trying to see if there was anything that
> >> could be done to help my specific case.  I've got a system where if
> >> someone starts writing out a large file, it kills client NFS writes.
> >> Makes the system unusable:
> >> http://marc.info/?l=linux-kernel&m=123732127919368&w=2
> >
> > Yes, I've hit 120s+ penalties just by saving a file in vim.
> 
> Yeah, your disks aren't keeping up and/or data isn't being written out
> efficiently.

Agreed; we probably will need to get some blktrace outputs to see what
is going on.

> >> Only workaround I've found is to reduce dirty_background_ratio and
> >> dirty_ratio to tiny levels.  Or throw good SSDs and/or a fast RAID
> >> array at it so that large writes complete faster.  Have you tried the
> >> new vm_dirty_bytes in 2.6.29?
> >
> > No.. What would you suggest to be a reasonable setting for that?
> 
> Look at whatever is there by default and try cutting them in half to start.

I'm beginning to think that using a "ratio" may be the wrong way to
go.  We probably need to add an optional dirty_max_megabytes field
where we start pushing dirty blocks out when the number of dirty
blocks exceeds either the dirty_ratio or the dirty_max_megabytes,
which ever comes first.  The problem is that 5% might make sense for a
small machine with only 1G of memory, but it might not make so much
sense if you have 32G of memory.

But the other problem is whether we are issuing the writes in an
efficient way, and that means we need to see what is going on at the
blktrace level as a starting point, and maybe we'll need some
custom-designed trace outputs to see what is going on at the
inode/logical block level, not just at the physical block level.

	      	    	       	       - Ted
