Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbXJLQ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbXJLQ66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXJLQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:58:50 -0400
Received: from gw.goop.org ([64.81.55.164]:53684 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbXJLQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:58:49 -0400
Message-ID: <470FA7C3.90404@goop.org>
Date: Fri, 12 Oct 2007 09:58:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?UTF-8?B?TW9ydGVuIELDuGc=?= =?UTF-8?B?ZXNrb3Y=?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Interaction between Xen and XFS: stray RW mappings
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave & other XFS folk,

I'm tracking down a bug which appears to be a bad interaction between
XFS and Xen.  It looks like XFS is holding RW mappings on free pages,
which Xen is trying to get an exclusive RO mapping on so it can turn
them into pagetables.

I'm assuming the pages are actually free, and this isn't a use after
free problem.  From a quick poke around, the most likely pieces of XFS
code is the stuff in xfs_map.c which creates a virtually contiguous
mapping of pages with vmap, and seems to delay unmapping them.

When pinning a pagetable, Xen tries to eliminate any RW aliases of the
pages its using.  This is generally trivial because pages returned by
get_free_page don't have any mappings aside from the normal kernel
mapping.  High pages, when using CONFIG_HIGHPTE, may have a residual
kmap mapping, so we clear out the kmap cache if we encounter a highpage
in the pagetable.

I guess we could create a special-case interface to do the same thing
with XFS mappings, but it would be nicer to have something more generic.

Is my analysis correct?  Or should XFS not be holding stray mappings? 
Or is there already some kind of generic mechanism I can use to get it
to release its mappings?

Thanks,
    J
