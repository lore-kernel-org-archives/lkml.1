Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbZGIQHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbZGIQHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760379AbZGIQHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:07:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760347AbZGIQHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:07:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0907090822g1533e9dt97c3f29ccaf4945b@mail.gmail.com>
References: <8bd0f97a0907090822g1533e9dt97c3f29ccaf4945b@mail.gmail.com> <8bd0f97a0907090104h5d4984dfkbeb82616a01128c8@mail.gmail.com> <24005.1247134018@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: truncate on MAP_SHARED files in ramfs filesystems on no-mmu
Date: Thu, 09 Jul 2009 17:07:08 +0100
Message-ID: <24988.1247155628@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> you dont need a MMU (virtual memory) to protect against it.  you only
> need a MPU which some systems have.

You may not have that either.  FRV doesn't, for example.  Furthermore, if you
have an MPU only, you can still do a lot of the missing bits of NOMMU mmap() -
shared writable disk or NFS files for example, so it can be argued that
MPU-only systems shouldn't be using mm/nommu.c.

> > This doesn't only protect the process with a mapping on that file against
> > its own truncate, but also other processes that have made mappings against
> > that file.
> 
> and those too are broken

Not necessarily.  They may not be expecting the truncation.  Just because the
first process might be incorrect doesn't mean that the other affected processes
are.

> > Whilst you can argue it either way, you need a better reason to change this
> > than it causes some LTP failures.  You cannot expect all the MM-related LTP
> > tests to work against a NOMMU system.
> 
> crappy programming is likely to crash regardless of standard functions we
> attempt to disable in the kernel.  this isnt a virtual memory issue at all,
> it's memory protection.

Are you actually seeing this in a real world situation?  Or just in LTP?

> > Doing it this way also makes things simpler in the kernel and makes the
> > system more robust.
> 
> really?  looks like the kernel is a lot more complicated to me.  the fix here
> would be to delete a whole bunch of code.

Delete what?  The check for ramfs_nommu_check_mappings()?  That is not
sufficient.  That might allow truncate to give the pages back to the system,
but the pages are still pointed to by VMAs and regions.  NOMMU truncate, as it
stands, will not take care of that: unmap_mapping_range() is not implemented
for NOMMU as the aforementioned check renders it unnecessary.

It is simpler in that we simply reject a truncate that would cut down a mapping
rather than trying to shrink that mapping.

It is more robust in that if one process has a file mapped, and another process
truncates it, then that second process isn't prevented from accessing the
region that has been taken away from it.

> > If a process shared mmaps a file and then wants to truncate it, it can
> > always munmap the excess first.
> 
> sure, we could go around changing a whole bunch of things specific to no-mmu,
> but that's kind of the wrong way to go.  applications shouldnt need to know
> they're running with different MMU features available.

Can you point to a real world case where this is a problem?


Note that it would be very easy to add (if such does not already exist) an LTP
test that creates a file, expands it, maps it, shrinks it and then attempts to
alter the removed part of the mapping in the expectation of receiving a SIGBUS.

As it stands, such a test will work on MMU, but go wrong on NOMMU in a
different way in these two cases.  With the current behaviour, the shrink
request will be rejected, but the system will survive.  With your proposed
behaviour, the system will potentially be wrecked.

The NOMMU situation behaves differently to the MMU situation in either case.

David
