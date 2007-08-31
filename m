Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXHaRCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXHaRCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760013AbXHaRCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:02:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55395 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759569AbXHaRCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:02:41 -0400
Date: Fri, 31 Aug 2007 10:01:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: Frank van Maarseveen <frankvm@frankvm.com>, Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <1188577275.6649.133.camel@heimdal.trondhjem.org>
Message-ID: <alpine.LFD.0.999.0708310946270.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>  <1188513433.6626.24.camel@heimdal.trondhjem.org>
  <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
 <1188577275.6649.133.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Trond Myklebust wrote:
>
> The best I can do given the constraints appears to be to have the kernel
> first look for a superblock that matches both the fsid and the
> user-specified mount options, and then spawn off a new superblock if
> that search fails.

I think this is probably acceptable to get roughly the old behaviour, but 
I still think it's a bit stupid.

What happens at "mount -o remount,..." time?

The fact is, the whole "match the fsid and user mount options, and re-use 
the mount" sounds like it's trying to solve a problem that doesn't need 
solving. If the user really wants to duplicate the mount, he really should 
be using a a bind-mount instead.

In other words, let's assume that the user has /some/nfs/mount mounted 
over NFS, and wants to re-mount it (or even just a subset of it) somewhere 
else, the sane thing to do is not to mount it again, but to just do

	mount --bind /some/nfs/mount/subdir /new/mount/place

instead. That *guarantees* that the low-level filesystem uses the same 
flags, and it also means that things like re-mounting have sane and 
well-defined semantics, and will fail or succeed predictably.

In contrast, if a user wants to create a new NFS mount, it really should 
be independent of the old one, because that's (a) what other systems do, 
and (b) also makes the semantics of re-mounting it with other flags be 
clear and unambiguous (ie the remount has nothing what-so-ever to do with 
the independent NFS mount).

See? 

This is why I think "nosharecache" should just be the default, because 
that's the behaviour that simply does not have any subtle issues. The 
*special* case should be the "sharecache" case, and 99% of the time that 
one should likely be done with a "--bind" mount.

(I don't really see the point of _ever_ doing anything but a bind mount, 
but maybe there are reasons to try to share at a NFS layer that I don't 
really see)

> The attached patch does just that.

Hua, does this fix things for you? If it gets rid of the regression, I can 
certainly live with it, but as per above, I don't really think this makes 
much sense in the "bigger picture" kind of thing.

> Finally, for the record: I still feel very uncomfortable about not being
> able to report the state of the client setup back to the sysadmin.
> AFAIK, the only way to do so is to stat the mountpoints, and compare the
> device ids.

Well, not only don't I see that as being horribly wrong, I actually think 
that the sysadmin should know what his mount setup is, even without having 
to ask. But since he *can* ask, using easy and standard interfaces, I 
don't really see what the problem really is.

			Linus
