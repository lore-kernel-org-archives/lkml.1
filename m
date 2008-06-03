Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbYFCRbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbYFCRbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbYFCRbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:31:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56177 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbYFCRbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:31:40 -0400
X-Sasl-enc: lqO4h4q/wX5DIr0SY/NWT169MU+Ei592Pv7d59gyoci6 1212514298
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080603165042.GC28946@ZenIV.linux.org.uk>
References: <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212509263.3025.66.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
	 <20080603164102.GB28946@ZenIV.linux.org.uk>
	 <20080603165042.GC28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 01:28:23 +0800
Message-Id: <1212514104.3025.110.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 17:50 +0100, Al Viro wrote:
> On Tue, Jun 03, 2008 at 05:41:03PM +0100, Al Viro wrote:
> 
> > >From my reading of that code looks like it's been rmdir'ed.  And no, I
> > don't understand what the hell is that code trying to do.
> > 
> > Ian, could you describe the race you are talking about?
> 
> BTW, this stuff is definitely broken regardless of mount - if something
> had the directory in question opened before that rmdir and we'd hit
> your lookup_unhashed while another CPU had been in the middle of
> getdents(2) on that opened descriptor, we'll get
> 
> vfs_readdir() grabs i_mutex
> vfs_readdir() checks that it's dead
> autofs4_lookup_unhashed() calls iput()

Can this really happen, since autofs4_lookup_unhashed() is only called
with the i_mutex held.

> inode is freed
> vfs_readdir() releases i_mutex - in already freed struct inode.

But it could happen later. So it's academic I guess.

> 
> Hell, just getdents() right *after* dentry->d_inode = NULL will oops,
> plain and simple.

Yeah, I'll look into why I believed I needed to turn the dentry
negative. I'll need to keep the dentry positive through out this
process.

Ian


