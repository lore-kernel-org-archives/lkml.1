Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbYEGUBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbYEGUBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbYEGUAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:00:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36205 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbYEGUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:00:52 -0400
Date: Wed, 7 May 2008 14:00:50 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Oi.  NFS people.  Read this.
Message-ID: <20080507200050.GE19219@parisc-linux.org>
References: <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org> <20080507174900.GB13591@elte.hu> <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org> <20080507181714.GA14980@elte.hu> <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org> <20080507184304.GA15554@elte.hu> <alpine.LFD.1.10.0805071150140.3024@woody.linux-foundation.org> <20080507192425.GC19219@parisc-linux.org> <alpine.LFD.1.10.0805071243330.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071243330.3024@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 12:44:48PM -0700, Linus Torvalds wrote:
> On Wed, 7 May 2008, Matthew Wilcox wrote:
> > 
> > One patch I'd still like Yanmin to test is my one from yesterday which
> > removes the BKL from fs/locks.c.
> 
> And I'd personally rather have the network-fs people test and comment on 
> that one ;)
> 
> I think that patch is worth looking at regardless, but the problems with 
> that one aren't about performance, but about what the implications are for 
> the filesystems (if any)...

Oh, well, they don't seem interested.

I can comment on some of the problems though.

fs/lockd/svcsubs.c, fs/nfs/delegation.c, fs/nfs/nfs4state.c,
fs/nfsd/nfs4state.c all walk the i_flock list under the BKL.  That won't
protect them against locks.c any more.  That's probably OK for fs/nfs/*
since they'll be protected by their own data structures (Someone please
check me on that?), but it's a bad idea for lockd/nfsd which are walking
the lists for filesystems.

Are we going to have to export the file_lock_lock?  I'd rather not.  But
we need to keep nfsd/lockd from tripping over locks.c.

Maybe we could come up with a decent API that lockd could use?  It all
seems a bit complex at the moment ... maybe lockd should be keeping
track of the locks it owns anyway (since surely the posix deadlock
detection code can't work properly if it's just passing all the locks
through).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
