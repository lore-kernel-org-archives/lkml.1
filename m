Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbZAPHgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbZAPHgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbZAPHgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:36:15 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:40600 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041AbZAPHgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:36:14 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [Ecryptfs-devel] [PATCH] ecryptfs: some inode attrs, and a question 
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
In-Reply-To: <496FAFE2.8020102@linux.vnet.ibm.com>
References: <7471.1231827621@jrobl> <1231852628.6954.4.camel@norville.austin.ibm.com> <496FAFE2.8020102@linux.vnet.ibm.com>
Date: Fri, 16 Jan 2009 16:36:06 +0900
Message-ID: <9829.1232091366@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tyler Hicks:
> >> - The ecryptfs inode holds a reference to the lower inode, but doesn't=
> 
> >>   increment the reference counter. When a user sets inotify to the
> >>   ecryptfs inode, it may live without the corresponding dentry. In thi=
> s
> >>   case the referecen to the lower inode may be broken.
> >>   This patch maintains the reference of the lower inode.
> 
> Is this a problem that you've experienced or something you found during
> a code review?  How can it be reproduced?  We get a reference to the
> lower inode with the igrab() in ecryptfs_interpose() and put it back in
> ecryptfs_clear_inode().  This part of the patch seems to just increment
> the ref counts again.

I could confirm the igrab() in ecryptfs_interpose(), so touching i_count
in my patch are unnecessary.
Although I don't remember the detail, I have experienced a trouble (and
I wrote the patch). If I can recall the problem and find the
reproducible way, I will write again.
One thing I remember is, vfs_unlink() in ecryptfs_unlink() made
lower_dentry->d_inode NULL unexpectedly.

I guess the problem was related to the i_count including my fixes for
ecryptfs_unlink() and ecryptfs_link(). Current ecryptfs_link() calls
ecryptfs_interpose(), but obviously the inode is not I_NEW and the
incremented i_count is decremented again (finally unchanged).
The current unnecessary d_drop()s may help hiding the problem, but I am
not sure.


> I see that do_unlinkat does this, but since eCryptfs already holds these
> references, I don't think that we need to do it here.

Whether the counter is one or more is more important than to hold or not
to hold simply.


> This part of the patch is valid, nice catch!

I am happy that my patch was not totally useless. :-)


And one more suggestion. It is better to set f_type in
ecryptfs_statfs(), and move ECRYPTFS_SUPER_MAGIC under include/linux/,
in order to be usable from userspace (or other modules).


J. R. Okajima
