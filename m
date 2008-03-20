Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYCTM22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYCTM22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 08:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYCTM2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 08:28:18 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33362 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752570AbYCTM2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 08:28:17 -0400
Message-ID: <406016111.11683@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 20 Mar 2008 20:28:07 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] A deadlock free and best try version of drop_caches()
References: <20080318112843.GJ95344431@sgi.com> <E1JbwS9-0008Gq-7h@localhost> <20080319220318.GK155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319220318.GK155407@sgi.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1JcJsN-0005K0-RW@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 09:03:18AM +1100, David Chinner wrote:
> On Wed, Mar 19, 2008 at 07:27:29PM +0800, Fengguang Wu wrote:
> > On Tue, Mar 18, 2008 at 10:28:44PM +1100, David Chinner wrote:
> > > Looks like everything is backed up on the inode_lock.  Why? Looks
> > > like drop_pagecache_sb() is doing something ..... suboptimal.
> ......
> > > Anyone know the reason why drop_pagecache_sb() uses such a brute-force
> > > mechanism to free up clean page cache pages?
> > 
> > Because extensive use of it(out of testings) is discouraged? ;-)
> > 
> > I have been running a longer but safer version, let's merge it?
> 
> So you walk the inode hash to find inodes? Seems like a nice idea on
> the surface.... Won't it need to hold the iprune_mutex to prevent
> races with prune_icache() and invalidate_list()?

Oh, I didn't notice iprune_mutex :-/

> Hmmmm - what about unhashed inodes? We'll never see them with this
> method of traversal. I ask because I'm working on some prototype
> patches for XFS that avoid using the inode hash altogether and drive
> inode lookup from the multitude of radix trees we have per filesystem
> (for parallelised and lockless inode lookup).
> 
> The above scanning method would not work at all with that sort of
> filesystem structure. Perhaps combining the bulk get/put with Jan's
> get/put method for walking the sb inode list would be sufficient?

You mean to move __invalidate_mapping_pages() out of inode_lock in
drop_pagecache_sb()? Sounds reasonable.

BTW, I noticed the following comments on locking order are outdated:

filemap.c 
 *  ->inode_lock
 *    ->sb_lock                 (fs/fs-writeback.c)

rmap.c 
 *                 sb_lock (within inode_lock in fs/fs-writeback.c)

They are invalidated by this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commit;h=03da8814512f55441b9bd57c1ceddd28fbcf59ba
[PATCH] Rearrangement of inode_lock in writeback_inodes()

[...] It narrows down use of inode_lock and removes unneccassary
nesting of sb_lock and inode_lock. [...]

Thank you,
Fengguang

