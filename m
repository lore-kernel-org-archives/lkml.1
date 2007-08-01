Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbXHATKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbXHATKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbXHATKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:10:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33282 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbXHATKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:10:34 -0400
Subject: Re: [RFC 12/26] ext2 white-out support
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
In-Reply-To: <20070801184405.GA18405@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de>
	 <20070730161324.261652101@weierstrass.suse.de>
	 <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
	 <20070731170012.GN5101@hasse.suse.de>
	 <20070731171159.GA27234@filer.fsl.cs.sunysb.edu>
	 <1185981810.18007.14.camel@kleikamp.austin.ibm.com>
	 <20070801184405.GA18405@filer.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 14:10:31 -0500
Message-Id: <1185995431.18007.24.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 14:44 -0400, Josef Sipek wrote:
> Alright not the greatest of examples, there is something to be said about
> symmetry, so...let me try again :)
> 
> /a/
> /b/bar		(whiteout for bar)
> /c/foo/qwerty
> 
> Now, let's mount a union of {a,b,c}, and we'll see:
> 
> $ find /u
> /u
> /u/foo
> /u/foo/qwerty
> $ mv /u/foo /u/bar
> 
> Now what? How do you rename? Do you rename in the same branch (assuming it
> is rw)?

Er, no.  According to Documentation/filesystems/union-mounts.txt, "only
the topmost layer of the mount stack can be altered".

> If you do, you'll get:
> 
> $ find /u
> /u
> 
> Oops! There's a whiteout in /b that hides the directory in /c -- rename(2)
> shouldn't make directory subtrees disappear.
> 
> There are two ways to solve this:
> 
> 1) "cp -r" the entire subtree being renamed to highest-priority branch, and
> rename there (you might have to recreate a series of directories to have a
> place to "cp" to...so you got "cp -r" _AND_ "mkdir -p"-like code in the VFS!
> 1/2 a :) )

I think this is the only alternative, given the design.

> 2) Don't store whiteouts within branches. This makes it really easy to
> rename and remove the whiteout.
> 
> Sure, you could try to rename in-place and remove the whiteout, but what if
> you have:
> 
> /a/
> /b/bar		(whiteout)
> /c/bar/blah
> /d/foo/qwerty
> 
> $ mv /u/foo /u/bar
> 
> You can't just remove the whiteout, because that'd uncover the whited-out
> directory bar in /c.
> 
> Josef 'Jeff' Sipek.
> 
-- 
David Kleikamp
IBM Linux Technology Center

