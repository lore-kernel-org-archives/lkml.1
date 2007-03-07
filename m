Return-Path: <linux-kernel-owner+w=401wt.eu-S1161075AbXCGAwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161075AbXCGAwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161070AbXCGAwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:52:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40308 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161075AbXCGAwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:52:09 -0500
Date: Tue, 6 Mar 2007 16:51:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Al Viro added to Cc: as the arbiter of good taste in the VFS layer. He 
  has veto powers even over my proposals ;^]

On Tue, 6 Mar 2007, Davide Libenzi wrote:
> 
> I currently have the dentry to carry the name of the file* class it is 
> linked to. I'd prefer to keep it that way, unless there are huge factors 
> against.

I assume that the *only* reason for having multiple dentries is really 
just the output in /proc/<pid>/fd/, right? Or is there any other reason to 
have separate dentries for these pseudo-files?

It's a bit sad to waste that much memory (and time) on something like 
that. I bet that the dentry setup is a noticeable part of the whole 
sigfd()/timerfd() setup. It's likely also a big part of any memory 
footprint if you have lots of them.

So how about just doing:
 - do a single dentry
 - make a "struct file_operations" member function that prints out the 
   name of the thing in /proc/<pid>/fd/, and which *defaults* to just 
   doing the d_path() on the dentry, but special filesystems like this 
   could do something else (like print out a fake inode number from the 
   "file->f_private_data" information)

There seems to really be no downsides to that approach. No existing 
filesystem will even notice (they'll all have NULL in the new f_op 
member), and it would allow pipes etc to be sped up and use less memory.

			Linus
