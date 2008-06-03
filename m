Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYFCQvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYFCQvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYFCQu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:50:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59426 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYFCQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:50:55 -0400
Date: Tue, 3 Jun 2008 17:50:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
Message-ID: <20080603165042.GC28946@ZenIV.linux.org.uk>
References: <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu> <20080603104035.GT28946@ZenIV.linux.org.uk> <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu> <20080603105258.GV28946@ZenIV.linux.org.uk> <1212499623.3025.46.camel@raven.themaw.net> <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org> <1212509263.3025.66.camel@raven.themaw.net> <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org> <20080603164102.GB28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603164102.GB28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 05:41:03PM +0100, Al Viro wrote:

> >From my reading of that code looks like it's been rmdir'ed.  And no, I
> don't understand what the hell is that code trying to do.
> 
> Ian, could you describe the race you are talking about?

BTW, this stuff is definitely broken regardless of mount - if something
had the directory in question opened before that rmdir and we'd hit
your lookup_unhashed while another CPU had been in the middle of
getdents(2) on that opened descriptor, we'll get

vfs_readdir() grabs i_mutex
vfs_readdir() checks that it's dead
autofs4_lookup_unhashed() calls iput()
inode is freed
vfs_readdir() releases i_mutex - in already freed struct inode.

Hell, just getdents() right *after* dentry->d_inode = NULL will oops,
plain and simple.
