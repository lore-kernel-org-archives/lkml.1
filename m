Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbZFXQlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbZFXQlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZFXQli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:41:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761147AbZFXQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:41:37 -0400
Date: Wed, 24 Jun 2009 09:40:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
       alan@lxorguk.ukuu.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       adilger@sun.com, akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
In-Reply-To: <20090624105336.GO8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.01.0906240933540.3240@localhost.localdomain>
References: <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk> <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org>
 <16370.1245772337@redhat.com> <16755.1245773452@redhat.com> <17310.1245776720@redhat.com> <alpine.LFD.2.01.0906231019250.3240@localhost.localdomain> <20090624105336.GO8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Al Viro wrote:
> 
> i_filesystem_fop is certainly bogus, but why do we want to bother with
> file_operations at all?
> 
> Unless you really insist on unlimited use of ioctl(2) on such beasts (and
> any users will be non-portable for obvious reasons anyway), there's no need
> to go anywhere near ->open() *or* ->f_op in general.

A lot of filesystems (especially network filesystems) want to do something 
special when you open a node on them.

NFS, for example, does that whole alloc_nfs_open_context() thing to keep 
track of RPC credentials etc. It's where things like "filp->f_private" 
get set etc.

So if you don't call open(), you'll not initialize the filp sufficiently 
to do lots of operations.

But yes:

> Just add new methods to ->i_op (and we already have that coming from
> fs code) and teach do_filp_open() to
> 	* call permission() with new flag (MAY_TALK_TO_FS_NODE) for such
> open()
> 	* do not die with -ELOOP on symlinks if we have O_NOFOLLOW + your flag
> 	* do not call ->f_op->open() at all for such open()
> and we are all set.  Hell, we can even teach sys_ioctl() that given set
> of ioctls maps to calls of our new methods.  Taken from ->i_op...

Sure. That will work, but I do think that it's going to be more hacky than 
just trying to make the file descriptor look as real as possible, and just 
calling "open" on it.

But I don't really have any strong opinions.

		Linus
