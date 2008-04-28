Return-Path: <linux-kernel-owner+w=401wt.eu-S935077AbYD1Ox0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935077AbYD1Ox0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932830AbYD1OxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:53:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33800 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbYD1OxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:53:13 -0400
To: mhalcrow@us.ibm.com
CC: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080428142048.GN18686@localhost.austin.ibm.com> (message from
	Michael Halcrow on Mon, 28 Apr 2008 09:20:48 -0500)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk> <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu> <20080424144815.GI15214@ZenIV.linux.org.uk> <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu> <20080424152129.GK15214@ZenIV.linux.org.uk> <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu> <20080424155954.GM15214@ZenIV.linux.org.uk> <E1Jp47x-0004MY-1W@pomaz-ex.szeredi.hu> <E1JqQOT-0004IY-7E@pomaz-ex.szeredi.hu> <20080428142048.GN18686@localhost.austin.ibm.com>
Message-Id: <E1JqUik-0004rV-GV@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Apr 2008 16:52:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Which begs the question: why is ecryptfs doing that with the xattr
> > methods?  Does it need to bypass the permission checks?  Seems very
> > fishy to me.
> 
> Yes, it was mainly to avoid the permission checks, since eCryptfs
> needs to be able to freely manipulate the cryptographic metadata
> stored in the xattr region of the lower file when the user mounts with
> the option to use the xattr region. I just used the same function to
> access the lower xattr (ecryptfs_setxattr(), for instance) for both
> xattr passthrough and metadata manipulation. This clearly can be
> changed at this point so that at least the xattr passthrough of xattr
> ops explicitly done by the user uses the vfs_* xattr calls instead.
> 
> However, in terms of permissions that eCryptfs needs, there are some
> semantics that I need to work out. For instance, if eCryptfs
> absolutely respects a rule that says that the lower file may only be
> opened append-only, even by root, then eCryptfs cannot do its job,
> which may include writing out the crypto metadata to the xattr of the
> lower file. In that case, an operation on the lower fs will succeed,
> but that exact same operation on the file under eCryptfs will fail,
> since xattr.c::xattr_permission() will return -EPERM if
> IS_APPEND(inode), and an open in eCryptfs will automatically entail an
> xattr write if the mount is done with instructions to write the
> metadata to the xattr regions of the lower files.

A more serious problem, is that permissions are not always checked at
the VFS level, but often at some place in the filesystem (as well)
like the NFS server for example.  Which means, that the current design
will fail miserably in those cases.

You don't have to care, of course, but I would rather have chosen a
design, where the stack doesn't have to care about implementation
details like that in the underlying filesystem.

Miklos
