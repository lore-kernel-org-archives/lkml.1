Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbYBQDH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbYBQDH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 22:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYBQDHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 22:07:12 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37096 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYBQDHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 22:07:10 -0500
Date: Sat, 16 Feb 2008 22:06:59 -0500
Message-Id: <200802170306.m1H36xeT031583@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: unionfs_copy_attr_times oopses 
In-reply-to: Your message of "Fri, 01 Feb 2008 20:30:46 GMT."
             <Pine.LNX.4.64.0802011905230.32485@blonde.site> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0802011905230.32485@blonde.site>, Hugh Dickins writes:

> Hi Erez,
> 
> Aside from the occasional "unionfs: new lower inode mtime" messages
> on directories (which I've got into the habit of ignoring now), the
> only problem I'm still suffering with unionfs over tmpfs (not tested
> any other fs's below it recently) is oops in unionfs_copy_attr_times.
> 
> I believe I'm working with your latest: 2.6.24-rc8-mm1 plus the four
> patches you posted to lkml on 26 Jan.  But this problem has been around
> for a while before that: I'd been hoping to debug it myself, but taken
> too long to make too little progress, so now handing over to you.
> 
> The oops occurs while doing repeated "make -j20" kernel builds in a
> unionfs mount of a tmpfs (though I doubt tmpfs is relevant): most of
> my testing was while swapping, but today I find that's irrelevant,
> and it should happen much quicker without.  SMP kernels (4 cpus),
> I haven't tried UP; happens with or without PREEMPT, may just be
> coincidence that it happens quicker on the machines with PREEMPT.
> 
> Most commonly it's unionfs_copy_attr_times called from unionfs_create,
> but that's probably just the most common route in this workload:
> I've seen it also when called from unionfs_rename or unionfs_open or
> unionfs_unlink.  It looks like there's a locking or refcounting bug,
> hence a race: the unionfs_inode_info which unionfs_copy_attr_times
> is working on gets changed underneath it, so it oopses on NULL
> lower_inodes.
[...]

Hugh,

Check out my latest set of patches (which correspond to release 2.2.4 of
Unionfs).  Thanks to your info and the patch, I was able to trigger several
races more frequently, and fix them.  I've tested my code with make -j N
(for N=4 and N=20), on a 4 cpu machine a well as a 2 cpu machine (w/
different amounts of memory and CPU speeds, also 32-bit vs 64-bit); I ran a
kernel compile for ~10-12 hours.  With the patches I just posted, I wasn't
able to trigger any of the WARN_ON's in unionfs_copy_attr_times.  I also
tried it while flushing caches via /proc, and/or performing branch-mgmt
commands in unionfs.

Give it a good shake and let me know what you find.

Thanks,
Erez.
