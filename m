Return-Path: <linux-kernel-owner+w=401wt.eu-S1161111AbXCGHQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161111AbXCGHQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161106AbXCGHQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:16:40 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:39141 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161111AbXCGHQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:16:39 -0500
Message-ID: <45EE66BE.8020003@cosmosbay.com>
Date: Wed, 07 Mar 2007 08:16:14 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
References: <45ED1A3C.6030707@argo.co.il> <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org> <45EE6125.3010702@cosmosbay.com>
In-Reply-To: <45EE6125.3010702@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 07 Mar 2007 08:16:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> 
> I would definitly *love* saving dentries for pipes (and sockets too), 
> but how are you going to get the inode ?
> 
> pipes()/sockets() can use read()/write()/rw_verify_area() and thus need 
> file->f_path.dentry->d_inode (so each pipe needs a separate dentry)
> 
> Are you suggesting adding a new "struct file_operations" member to get 
> the inode ?
> Or re-intoducing an inode pointer in struct file ?

Crazy ideas : (some readers are going to kill me)

1) Use the low order bit of f_path.dentry to say : this pointer is not a 
pointer to a dentry but the inode pointer (with the low order bit set to 1)

OR

2) file->f_path.dentry set to NULL for this special files (so that we dont 
need to dput() and cache line ping pong the common dentry each time we 
__fput() a pipe/socket.

Same trick could be used for file->f_path.mnt, because there is a big SMP 
cache line ping/pong to maintain a mnt_count on pipe/sockets mountpoint while 
these file systems cannot be un-mounted)

If dentry is NULL, we get the inode pointer from an overlay of struct 
file_ra_state    f_ra; (because for this special files readahead is unused)

This adds some conditional branches of course, but being able to save ram and 
better use cpu caches might be worth them.


