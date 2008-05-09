Return-Path: <linux-kernel-owner+w=401wt.eu-S934910AbYEIBoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934910AbYEIBoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 21:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbYEIBoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 21:44:00 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50912 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbYEIBn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 21:43:58 -0400
Date: Thu, 8 May 2008 21:43:19 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: Oi.  NFS people.  Read this.
Message-ID: <20080509014319.GL12690@fieldses.org>
References: <20080507174900.GB13591@elte.hu> <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org> <20080507181714.GA14980@elte.hu> <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org> <20080507184304.GA15554@elte.hu> <alpine.LFD.1.10.0805071150140.3024@woody.linux-foundation.org> <20080507192425.GC19219@parisc-linux.org> <alpine.LFD.1.10.0805071243330.3024@woody.linux-foundation.org> <20080507200050.GE19219@parisc-linux.org> <1210198227.7459.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210198227.7459.31.camel@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 03:10:27PM -0700, Trond Myklebust wrote:
> On Wed, 2008-05-07 at 14:00 -0600, Matthew Wilcox wrote:
> > On Wed, May 07, 2008 at 12:44:48PM -0700, Linus Torvalds wrote:
> > > On Wed, 7 May 2008, Matthew Wilcox wrote:
> > > > 
> > > > One patch I'd still like Yanmin to test is my one from yesterday which
> > > > removes the BKL from fs/locks.c.
> > > 
> > > And I'd personally rather have the network-fs people test and comment on 
> > > that one ;)
> > > 
> > > I think that patch is worth looking at regardless, but the problems with 
> > > that one aren't about performance, but about what the implications are for 
> > > the filesystems (if any)...
> > 
> > Oh, well, they don't seem interested.
> 
> Poor timing: we're all preparing for and travelling to the annual
> Connectathon interoperability testing conference which starts tomorrow.
> 
> > I can comment on some of the problems though.
> > 
> > fs/lockd/svcsubs.c, fs/nfs/delegation.c, fs/nfs/nfs4state.c,
> > fs/nfsd/nfs4state.c all walk the i_flock list under the BKL.  That won't
> > protect them against locks.c any more.  That's probably OK for fs/nfs/*
> > since they'll be protected by their own data structures (Someone please
> > check me on that?), but it's a bad idea for lockd/nfsd which are walking
> > the lists for filesystems.
> 
> Yes. fs/nfs is just reusing the code in fs/locks.c in order to track the
> locks it holds on the server. We could alternatively have coded a
> private lock implementation, but this seemed easier.

So, assuming nfs is taking care of its own locking (I don't know if
that's right), that leaves nlm_traverse_locks() and nlm_file_inuse()
(both in fs/lockd/svcsubs.c) as the problem spots.

> > Are we going to have to export the file_lock_lock?  I'd rather not.  But
> > we need to keep nfsd/lockd from tripping over locks.c.
> > 
> > Maybe we could come up with a decent API that lockd could use?  It all
> > seems a bit complex at the moment ... maybe lockd should be keeping
> > track of the locks it owns anyway (since surely the posix deadlock
> > detection code can't work properly if it's just passing all the locks
> > through).
> 
> I'm not sure what you mean when you talk about lockd keeping track of
> the locks it owns. It has to keep those locks on inode->i_flock in order
> to make them visible to the host filesystem...
> 
> All lockd really needs, is the ability to find a lock it owns, and then
> obtain a copy.

That sounds right.

--b.

> As for the nfs client, I suspect we can make do with
> something similar...


