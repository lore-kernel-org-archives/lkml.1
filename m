Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbZAHMyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbZAHMyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZAHMyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:54:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40684 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbZAHMyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:54:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/10] Alter NOMMU mmap handling [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:53:46 +0000
Message-ID: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The primary change made by the attached patches alters the NOMMU mmap code so
that VMAs are per-MM rather than being a shared resource with separate per-MM
linkage blocks.

This solves two problems:

 (1) In SYSV SHM where nattch for a segment does not reflect the number of
     shmat's (and forks) done.

 (2) In mmap() where the VMA's vm_mm is set to point to the parent mm by an
     exec'ing process when VM_EXECUTABLE is specified, regardless of the fact
     that a VMA might be shared and already have its vm_mm assigned to another
     process or even a dead process.

And adds a number of features:

 (3) Allocations are now made with alloc_pages() rather than kmalloc().  This
     simplifies page accounting within a block of pages.

 (4) Excess pages can be trimmed from allocations.

 (5) VMAs are added for the parent MM's RB-tree and mmap lists, as for MMU-mode
     mmap.

 (6) Non-anonymous VMAs can now be linked to the inode as for MMU-mode.

 (7) mmaps can now be partially unmapped under some circumstances.

 (8) Simplified coredumping in ELF-FDPIC.

 (9) /proc/meminfo has a line "MmapCopy" that indicates the amount of private
     copying mmap() has done.


There are some patches with secondary changes that do not relate to the primary
change:

 (*) Ramfs needs to clean up correctly in the case where its get_unmapped_area
     call gets fewer pages from find_get_pages() than were asked for.

 (*) The askedalloc and realalloc variables are removed as nothing uses the
     values computed.

 (*) The ELF-FDPIC and FLAT binfmts no longer expand the stack segment to
     consume the space that is allocated to them beyond what is asked for.
     This removes some users of the contentious kobjsize().

     An alternative method would be to to replace the call to kobjsize() with
     something that uses the VMA list only.

 (*) Fix kobjsize() to check the VMA list.

 (*) Support XIP on initramfs under NOMMU conditions by pre-truncating the
     ramfs files to get contiguous memory allocated in advance in the page
     cache.


The patches can be obtained as a tarball from:

	http://people.redhat.com/~dhowells/nommu-permmvmas.tar.bz2

And are available by GIT from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-nommu.git

These patches have been tested on FRV, Blackfin and SH.

David
