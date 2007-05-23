Return-Path: <linux-kernel-owner+w=401wt.eu-S1765881AbXEWMQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765881AbXEWMQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXEWMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:16:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53601 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760207AbXEWMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:16:21 -0400
Date: Wed, 23 May 2007 13:16:20 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523121620.GU4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk> <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu> <20070523102437.GS4095@ftp.linux.org.uk> <E1HqoGh-0001kd-00@dorka.pomaz.szeredi.hu> <20070523113925.GT4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523113925.GT4095@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:39:25PM +0100, Al Viro wrote:
> Then I do not understand what this mechanism could be used for, other
> than an odd way to twist POSIX behaviour and see how much of the userland
> would survive that.  Certainly not useful for your "look into tarball
> as a tree", unless you seriously want to scan the entire damn fs for
> tarballs at mount time and set up a superblock for each.  And for per-file
> extended attributes/forks/whatever-you-call-that-abomination it also
> obviously doesn't help, since you lose them for directories.
> 
> IOW, what uses do you have in mind?  Complete scenario, please...

Ah... After rereading the thread you've mentioned in the very beginning,
I think I understand what you are driving at.  However, in that case
	* I really don't see why bother with returning vfsmount at all.
dentry alone is enough to create a new vfsmount, all in fs/namei.c.
	* the lifetime rules look fscking scary.  You call that ->enter()
on nearly every damn lookup.  OK, so you'll recreate equivalent vfsmount,
but...  That's a lot of allocations/freeing.  Can we do some caching and
deal with it on memory pressure?
	* invalidation on unlink is still an open problem.
	* locking in final mntput() doesn't look nice; we probably need
a new refcounting scheme for vfsmounts to make that work.  I have a variant
that might work here (and make life much easier for expiry logics in
automount/shared trees, which is what it had been initially proposed for),
but it still doesn't kill the need to deal with invalidation.  And yes,
NFS still needs it (and so do all network filesystems, really).  The question
of caching is related to that.
