Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbYDCBqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbYDCBqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYDCBqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:46:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57194 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977AbYDCBqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:46:30 -0400
Date: Thu, 3 Apr 2008 02:46:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080403014622.GW9785@ZenIV.linux.org.uk>
References: <20080403010016.GU9785@ZenIV.linux.org.uk> <200804030137.m331b1O8004886@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804030137.m331b1O8004886@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 09:37:01PM -0400, Erez Zadok wrote:
> Since you've hinted of major vfs changes post-25, here's my take.
> 
> Right now I (and to a similar extent ecryptfs too) needs to keep track of
> vfsmounts for various reasons:
> 
> - to grab a reference so the lower filesystems/mounts won't disappear on me

Umm...  Strictly speaking that's not true; you can grab an active reference
to superblock and then superblock will stay.  vfsmount is usually more
convenient, but that's it.

> - to pass it to dentry_open (opening the lower file)
> - some fs ops pass a vfsmount (umount_begin, show_options)

Thank Trond for the former, BTW ;-)  Both methods will be back to sanity;
for umount_begin() the only obstacle is cifs mess, where we do unconditional
(and bogus) work at each umount(2).  With that fixed, we'll be back to
calling it only for forced umount and passing it only superblock.
->show_options() can and should revert immediately after 2.6.25; thanks
for pointing that one out.

> - some fs ops or vfs helpers require a nameidata or struct path which embed
>   a vfsmount inside

*ONLY* ->follow_link().  Which has to, by definition...  The rest will be
gone by .26.

> - sometimes it's ok to pass NULL for those things, sometimes it's not ok

See above.  This crap will be gone.  For ->follow_link() nobody is allowed
to pass NULL as nameidata, period.

> In the longer run, is there a way that a stackable f/s could traverse the
> namespace below it w/o knowing or caring how they are composed (assorted r-w
> and r-o bind mounts and such)?

Eh?  Explain, please...
