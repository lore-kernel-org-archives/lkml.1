Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbYABUcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbYABUcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYABUbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:31:55 -0500
Received: from verein.lst.de ([213.95.11.210]:44400 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716AbYABUby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:31:54 -0500
Date: Wed, 2 Jan 2008 21:31:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: getting rid of filp search in fs_may_remount_ro()
Message-ID: <20080102203136.GA884@lst.de>
References: <20071126135220.GA17244@lst.de> <20071226141214.GA31455@lst.de> <1199130866.13731.27.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199130866.13731.27.camel@localhost>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.001 () BAYES_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 11:54:26AM -0800, Dave Hansen wrote:
> > Btw, I just noticed in current -mm fs_may_remount_ro() is still around
> > and not replaced by ther per-sb writers count.  That surely sounds like
> > some kind of mismerge..
> 
> I was actually leaving that for later.  Getting rid of the filp search
> is a great benefit of the r/o bind patches, but it isn't strictly
> necessary and it doesn't really hurt anything to keep it.

Well, it's one of the primary arguments for the expensive infrastructure
behind the per-mount r/o patches, as checkin the counter here means
we can now do exact tracking of the writable status of the superblock
and thus avoid the remount r/o races.

But there's another argument for it which is unrelated to the per-mount
r/o patches.  fs_may_remount_ro is the last non-trivial user of
sb->s_files and the file_list_lock.  Peter Zijlstra identified the
latter as scalabilty problem, and I'd really prefer to get rid of the
list and the lock instead of hacking around these issues.  Removing
sb->s_files will also allow removing a list_head from struct file
with some additional hackery to the tty core which should be a nice
memory safer on big systems.

> The reason that it was contentious was that we need some way to be able
> to do an sb-to-mount mapping.  When remounting the sb, we need to
> determine whether *any* of the mounts of that sb have any writers.
> 
> We don't currently have any mechanisms to do direct lookups from sb to
> mount.  The only alternative I can see right now is to walk over all
> tasks, then walk over all vfs namespaces, and walk each mount tree to
> see if any mounts are of the sb we're looking for.  This needs to be
> done while already holding the mnt_writers[] locks so that no new mnt
> writers can come in.
> 
> *THAT* is going to be a heavyweight operation.  I need to go look in
> detail at how the mount trees are kept, and we'll need some kind of
> mechanism to keep track of which vfs namespaces we've looked at during
> the search so we don't search them twice. 
> 
> Can you think of a simpler way to do it?

Well, the first revisions of the patches added a list of vfsmounts
to the superblock, and I wasn't quite happy with that because I though
we could get around that easily.  Given that we can't get around it
easily I'd be happy to take my comments back.
