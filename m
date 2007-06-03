Return-Path: <linux-kernel-owner+w=401wt.eu-S1764158AbXFCHYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764158AbXFCHYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 03:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbXFCHX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 03:23:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:60915 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbXFCHX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 03:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=uNtHVOGnIAq7LAoO9OZISyszAmrBlf2ojsw/ae60HRcyhv/pIasXfhAN8sSxhA467L4JWMyQMTTjsj23/kwo77mwixmPWY+GN5Ij+y28BsK5z8aNfFmlMy8igtY4ghqQWPJ4m/OoT8aBm1pwWI7CAedCTv5aik7/cuHrwGtD5Jk=
Date: Sun, 3 Jun 2007 11:22:44 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070603072244.GB8396@cvg>
References: <20070601235422.fdc1f750.akpm@linux-foundation.org> <20070602065923.GB8387@cvg> <20070602000645.508ddf93.akpm@linux-foundation.org> <20070602140619.GA10303@cvg> <20070602103203.e39d25ed.akpm@linux-foundation.org> <20070602185707.GA8518@cvg> <20070602121616.37ffce9e.akpm@linux-foundation.org> <20070602200146.GC8518@cvg> <20070602154942.cc4f9818.akpm@linux-foundation.org> <20070603062840.GA8396@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070603062840.GA8396@cvg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Jun 03, 2007 at 10:28:40AM +0400]
| [Andrew Morton - Sat, Jun 02, 2007 at 03:49:42PM -0700]
| | On Sun, 3 Jun 2007 00:01:46 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| | 
| | > [Andrew Morton - Sat, Jun 02, 2007 at 12:16:16PM -0700]
| | > [...snip...]
| | > | 
| | > | No, the problem is that the patch caused the kernel to take inode_lock
| | > | within the newly-added drop_inode(), btu drop_inode() is already called
| | > | under inode_lock.
| | > | 
| | > | It has nothing to do with lock_kernel() and it has nothing to do with
| | > | sleeping.
| | > | 
| | > 
| | > Andrew, the only call that could leading to subseq. inode_lock lock
| | > is mark_inode_dirty() I guess (and that is snown by Eric's dump)
| | > but as I shown you in my dbg print without SMP it's OK. So
| | > is it SMP who lead to lock? How it depends on it? (I understand
| | > that is a stupid question for you but if you have time explain
| | > me this please ;)
| | > 
| | 
| | When CONFIG_SMP=n, spin_lock() is a no-op.  (Except with CONFIG_PREEMPT=y,
| | in which case spin_lock() will disable kernel preemption on SMP and non-SMP
| | kernels)
| | 
| | When CONFIG_SMP=y, spin_lock() really does take a lock.  But if this thread
| | already holds this lock, we'll deadlock.
| | 
| 
| Thanks, Andrew. So the reason that raises lock problem is the calling of
| mark_inode_dirty() inside drop_inode() (by indirection). And I see two way
| of solution:
| 
| - or check for inode->i_count at each mark_inode_dirty that being called
|   after drop_inode
| 
| 		if (inode->i_count > 0)
| 				mark_inode_dirty()
| 
| - or wrap mark_inode_dirty as
| 
| 	udf_mark_inode_dirty()
| 	{
- 		if (inode->i_count > 0)
+		if (atomic_read(&inode->i_count) > 0)
| 			mark_inode_dirty();
| 	}
| 
| 	and replace all mark_inode_dirty -> udf_mark_inode_dirty
| 
| Your thoughts?
| 
| 		Cyrill
| 


		Cyrill

