Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYEWKVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYEWKVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYEWKVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:21:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYEWKVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:21:11 -0400
Subject: Re: [patch 04/14] gfs2: dont call permission()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
	 <20080521171546.697638614@szeredi.hu>
	 <20080523091805.GB27119@infradead.org>
	 <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 23 May 2008 11:18:50 +0100
Message-Id: <1211537930.3635.569.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2008-05-23 at 11:48 +0200, Miklos Szeredi wrote:
> > Bad idea.  You're duplicating bits out of permission for no good
> > reason.  I spent quite a bit of effort to make sure we don't have
> > this duplicated logic around.
> 
> In this case you are wrong.  Look at the ugly conditional locking
> gfs2_permission() does, which is probably due to the fact that it's
> doing a recursion via calling permission() from inside already locked
> parts in the filesystem.
> 
> That's _much_ worse than a duplicated IS_IMMUTABLE() call.  Which btw,
> is a filesystem implementation detail: it needs to re-check the
> immutability of the file after it has been locked.  I'm not even sure
> it's strictly needed.  Steven?
> 
Given the fact that (a) its only a very minor change and (b) as soon as
we have a solution to what we really want to do:

 - inode/file operation:
   - Do lookup via VFS
   - Get GFS2 glock
     - Do perm check via VFS
     - Do actual operation
   - Drop GFS2 glock

as opposed to the current situation of:

 - Do lookup via VFS:
   - Get GFS2 glock
   - Do perm check
   - Drop GFS2 glock
 - inode/file operation:
   - Get GFS2 glock
   - Recheck perms
   - Do the actual operation
   - Drop GFS2 glock

then the rechecking of perms will no longer be required anyway. I'm
inclined to agree with Miklos and say that its ok, but strictly on the
basis that its days are already numbered.

> Generally this sort of recursion through the VFS is ugly and
> unnecessary, it's much better to provide helper for what the VFS is
> doing if there's a lot of duplication.  But in this case there's
> really no point in that at all.
> 
> Miklos

Indeed I've spent a lot of time tracking down these cases and at least
now its possible to see them all by greping for
gfs2_glock_is_locked_by_me() in gfs2, whereas previously these cases
were hidden and less obvious,

Steve.


