Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbYDXPiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbYDXPiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbYDXPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:37:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38755 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbYDXPhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:37:54 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424152129.GK15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 16:21:29 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk> <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu> <20080424144815.GI15214@ZenIV.linux.org.uk> <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu> <20080424152129.GK15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 17:37:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Since all the vfs_* functions will become static with path_* being the
> > only caller, the compiler will be happy to get rid of that stack frame
> > too.
> > 
> > What is left is the guarantee, that the race-free r/o remounts will
> > always work and some obscure caller didn't forget to surround it with
> > the r/o checks.
> > 
> > I think it's definitely worth it.
> 
> It would be, if we had only single vfs_...() as critical sections.  We
> do not - see previous mail or read the fucking tree, already.

Why are those so important?  Yes, if we have multiple vfs_() calls,
surround them with an extra want/drop pair.  We do already do multiple
overlapping want/drop pairs with O_TRUNC and O_CREAT (AFAIR).

> We don't even have many callers of each, and with a few we do it's not
> obvious that we want to go through vfsmounts (and vfsmount-based checks)
> in all of them.  So no, I don't buy your argument.  Sorry.
> 
> I'm not even convinced that they are useful as helpers, at least until
> we'd decided what to do with checks in nfsd.  Until then we do, as
> far as I'm concerned, one place where they would definitely DTRT - fs/namei.c.
> And I want more than one caller before merging those,

unix_bind() -> vfs_mknod()
sys_mq_unlink() -> vfs_unlink()
open.c (several) -> notify_change()
*setxattr() -> vfs_setxattr()
*removexattr() -> vfs_removexattr()

> let alone removing the interface that doesn't require checks to be
> vfsmount-based for all users.

What users?  There are paractically _no_ other users.  The ones that
there are (like reiserfs) should not be using them, and there are
already some patches cleaning that mess up.

Miklos

