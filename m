Return-Path: <linux-kernel-owner+w=401wt.eu-S1765622AbXGaQhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765622AbXGaQhS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763981AbXGaQhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:37:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45190 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762682AbXGaQhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:37:00 -0400
Date: Tue, 31 Jul 2007 12:36:56 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730161324.261652101@weierstrass.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> Introduce white-out support to ext2.

I think storing whiteouts on the branches is wrong. It creates all sort of
nasty cases when people actually try to use unioning. Imagine a (no-so
unlikely) scenario where you have 2 unions, and they share a branch. If you
create a whiteout in one union on that shared branch, the whiteout magically
affects the other union as well! Whiteouts are a union-level construct, and
therefore storing them at the branch level is wrong.

If you store whiteouts on the branches, you'll probably want readdir to not
include them. That's relatively cheap if you have a whiteout bit in the
inode, but I don't think filesystems should be forced to use up rather
prescious inode bits for whiteouts/opaqueness [1].

Really the only sane way of keeping track of whiteouts seems some external
store. We did an experiment with Unionfs, and moving the whiteout handling
to effectively a "library" that did all the dirty work cleaned up the code
considerably [2,3].

> Known Bugs:
> - Needs a reserved inode number for white-outs
> - S_OPAQUE isn't persistently stored

Out of curiosity, how do you keep track of opaqueness while the fs is
mounted?

Josef 'Jeff' Sipek.

[1] http://www.mail-archive.com/linux-fsdevel@vger.kernel.org/msg02904.html
[2] http://www.filesystems.org/unionfs-odf.txt
[3] http://download.filesystems.org/unionfs/unionfs-2.0-odf/linux-2.6.20-rc6-odf1.diff.gz

-- 
UNIX is user-friendly ... it's just selective about who it's friends are
