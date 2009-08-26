Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbZHZMha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbZHZMha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932912AbZHZMh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:37:29 -0400
Received: from THUNK.ORG ([69.25.196.29]:48488 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbZHZMh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:37:28 -0400
Date: Wed, 26 Aug 2009 08:37:09 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: david@lang.hm, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090826123709.GJ32712@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	david@lang.hm, Ric Wheeler <rwheeler@redhat.com>,
	Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
References: <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm> <20090825224004.GD4300@elf.ucw.cz> <alpine.DEB.2.00.0908251547520.28411@asgard.lang.hm> <20090825233701.GH4300@elf.ucw.cz> <alpine.DEB.2.00.0908251651140.28411@asgard.lang.hm> <20090826001206.GL4300@elf.ucw.cz> <4A94812C.5010803@redhat.com> <20090826004430.GR4300@elf.ucw.cz> <alpine.DEB.2.00.0908251817390.30426@asgard.lang.hm> <20090826112535.GF26595@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826112535.GF26595@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 01:25:36PM +0200, Pavel Machek wrote:
> > you just plain cannot count on writes that are in flight when a powerfail 
> > happens to do predictable things, let alone what you consider sane or  
> > proper.
> 
> From what I see, this kind of failure is rather harder to reproduce
> than the software problems. And at least SGI machines were designed to
> avoid this...
> 
> Anyway, I'd like to hear from ext3 people... what happens on read
> errors in journal? That's what you'd expect to see in situation above.

On a power failure, what normally happens is that the random garbage
gets written into the disk drive's last dying gasp, since the memory
starts going insane and sends garbage to the disk.  So the disk
successfully completes the write, but the sector contains garbage.
Since HDD's tend to be last thing to die, being less sensitive to
voltage drops than the memory or DMA controller, my experience is that
you don't get a read error after the system comes up, you just get
garbage written into the journal.

The ext3 journalling code waits until all of the journal code is
written, and only then writes the commit block.  On restart, we look
for the last valid commit block.  So if the power failure is before we
write the commit block, we replay the journal up until the previous
commit block.  If the power failure is while we are writing the commit
block, garbage will be written out instead of the commit block, and so
it falls back to the previous case.

We do not allow any updates to the filesystem metadata to take place
until the commit block has been written; therefore the filesystem
stays consistent.

If there the journal *does* develop read errors, then fsck will
require a manual fsck, and so the boot operation will get stopped so a
system administrator can provide manual intervention.  The best bet
for the sysadmin is to replay as much of the journal she can, and then
let fsck fix any resulting filesystem inconsistencies.  In practice,
though, I've not experienced or seen any reports of this happening
from a power failure; usually it happens if the laptop gets dropped or
the hard drive suffers or suffers some other kind of hardware failure.

    	       	       	  	       - Ted
