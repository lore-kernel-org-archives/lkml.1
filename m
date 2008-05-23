Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYEWJPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYEWJPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYEWJPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:15:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYEWJPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:15:04 -0400
Subject: Re: [patch 04/14] gfs2: dont call permission()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080521171546.697638614@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
	 <20080521171546.697638614@szeredi.hu>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 23 May 2008 10:12:06 +0100
Message-Id: <1211533926.3635.552.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2008-05-21 at 19:15 +0200, Miklos Szeredi wrote:
> plain text document attachment (gfs2_permission_fix.patch)
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> GFS2 calls permission() to verify permissions after locks on the files
> have been taken.
> 
> For this it's sufficient to call gfs2_permission() instead.  This
> results in the following changes:
> 
>   - IS_RDONLY() check is not performed
>   - IS_IMMUTABLE() check is not performed
>   - devcgroup_inode_permission() is not called
>   - security_inode_permission() is not called
> 
> IS_RDONLY() should be unnecessary anyway, as the per-mount read-only
> flag should provide protection against read-only remounts during
> operations.  do_gfs2_set_flags() has been fixed to perform
> mnt_want_write()/mnt_drop_write() to protect against remounting
> read-only.
> 
> IS_IMMUTABLE has beed added to gfs2_do_permission()
> 
That looks ok, but I wonder do we really need gfs2_do_permission() and
gfs2_permission when the only difference seems to be one argument?

> Repeating the security checks seems to be pointless, as they don't
> normally change, and if they do, it's independent of the filesystem
> state.
> 
I hope eventually we can fix this by allowing GFS2 to do its own
lookups, via a suitable VFS library function. I understand that is the
preferred option to replace "open intents" (which we don't currently use
anyway) in the longer term.

> I also suspect the conditional locking in gfs2_do_permission() could
> be cleaned up, due to the removal of the implicit recursion.
> 
In order to be sure we'd have to check that there are no NFS code paths
left which can reach this code. That has usually been the reason for
conditional locking.

In general the patch looks ok to me, and since it doesn't appear to
depend on anything else, I can drop it in my GFS2 git tree if that would
be helpful at this stage,

Steve.


