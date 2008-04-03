Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYDCA73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYDCA73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbYDCA7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:59:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58156 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154AbYDCA7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:59:17 -0400
Date: Thu, 3 Apr 2008 01:58:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080403005836.GT9785@ZenIV.linux.org.uk>
References: <20080402201321.062856131@szeredi.hu> <20080402205450.GO9785@ZenIV.linux.org.uk> <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu> <20080402214824.GP9785@ZenIV.linux.org.uk> <1207174890.722.12.camel@heimdal.trondhjem.org> <20080402223637.GQ9785@ZenIV.linux.org.uk> <1207178398.20254.19.camel@heimdal.trondhjem.org> <20080402234043.GR9785@ZenIV.linux.org.uk> <20080402234758.GS9785@ZenIV.linux.org.uk> <1207183329.20254.49.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207183329.20254.49.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 08:42:09PM -0400, Trond Myklebust wrote:

> > At the very least, you want "that thing is still busy" on normal umount -
> > we are still in the middle of write(2) and hell knows how long it's going
> > to last.  So you need to play with refcount of vfsmount in a very nasty
> > way, for all your pains. 
> 
> We already call fget_light()/fput_light() around the whole call to
> vfs_write(). Substituting a call to something which takes a reference to
> the new structure is trivial.

Huh?  So you want an extra layer of indirection?  descriptor table -> that
one -> struct file?  And refcounting these puppies?
 
> It allows you to get rid of the vfsmount 'argument' when opening a file,
> which again lowers the barrier for stacking filesystems.

I don't see how that would fix the fundamental breakage in those, but
anyway... (and yes, ecryptfs has interesting issues, but the look of it).

> As far as the filesystems themselves are concerned, the effect is to
> enforce your assertion that file operations should not depend on the
> namespace.

I really doubt that it's worth doing in this area...  "Don't use ->f_vfsmnt
in fs code" is easily enforced and struct file is really used outside of
filesystem code in fs-independent ways.

IOW, I don't believe that it's worth introducing a new layer between descriptor
table and files.  BTW, that'll complicate union-mount handling (real ones, not
unionfs under different name) and quite a few other things...
