Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXCGGwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXCGGwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 01:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932739AbXCGGwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 01:52:45 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:59817 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbXCGGwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 01:52:44 -0500
Message-ID: <45EE6125.3010702@cosmosbay.com>
Date: Wed, 07 Mar 2007 07:52:21 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
References: <45ED1A3C.6030707@argo.co.il> <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 07 Mar 2007 07:52:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> I assume that the *only* reason for having multiple dentries is really 
> just the output in /proc/<pid>/fd/, right? Or is there any other reason to 
> have separate dentries for these pseudo-files?
> 
> It's a bit sad to waste that much memory (and time) on something like 
> that. I bet that the dentry setup is a noticeable part of the whole 
> sigfd()/timerfd() setup. It's likely also a big part of any memory 
> footprint if you have lots of them.
> 
> So how about just doing:
>  - do a single dentry
>  - make a "struct file_operations" member function that prints out the 
>    name of the thing in /proc/<pid>/fd/, and which *defaults* to just 
>    doing the d_path() on the dentry, but special filesystems like this 
>    could do something else (like print out a fake inode number from the 
>    "file->f_private_data" information)
> 
> There seems to really be no downsides to that approach. No existing 
> filesystem will even notice (they'll all have NULL in the new f_op 
> member), and it would allow pipes etc to be sped up and use less memory.
> 

I would definitly *love* saving dentries for pipes (and sockets too), but how 
are you going to get the inode ?

pipes()/sockets() can use read()/write()/rw_verify_area() and thus need 
file->f_path.dentry->d_inode (so each pipe needs a separate dentry)

Are you suggesting adding a new "struct file_operations" member to get the inode ?
Or re-intoducing an inode pointer in struct file ?

