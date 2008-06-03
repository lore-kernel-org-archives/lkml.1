Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYFCRAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYFCRAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYFCRAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:00:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbYFCRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:00:09 -0400
Date: Tue, 3 Jun 2008 09:59:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
In-Reply-To: <20080603164102.GB28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0806030951180.3473@woody.linux-foundation.org>
References: <20080603095713.GR28946@ZenIV.linux.org.uk> <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu> <20080603104035.GT28946@ZenIV.linux.org.uk> <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
 <20080603105258.GV28946@ZenIV.linux.org.uk> <1212499623.3025.46.camel@raven.themaw.net> <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org> <1212509263.3025.66.camel@raven.themaw.net> <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
 <20080603164102.GB28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jun 2008, Al Viro wrote:
> > 
> > If the dentry is unhashed, it means that it _either_
> > 
> >  - has already been deleted (rmdir'ed) or d_invalidate()'d. Right?
> > 
> >    I don't see why you should ever return the dentry in this case..
> 
> From my reading of that code looks like it's been rmdir'ed.  And no, I
> don't understand what the hell is that code trying to do.

Hmm. Looking closer, I think that code is meant to handle the 
d_invalidate() that it did in autofs4_tree_busy().

However, that should never trigger for a directory entry that can be 
reached some other way, because that code has done a "dget()" on the 
dentry, and d_invalidate() does

	if (atomic_read(&dentry->d_count) > 1) {
		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
			..unlock..
			return -EBUSY;
		}
	}

so I dunno. I still think the expire code shouldn't even use 
d_invalidate() at all, and just revalidate() at lookup. 

		Linus
