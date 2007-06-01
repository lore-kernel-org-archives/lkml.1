Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbXFAMBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbXFAMBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbXFAMBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:01:25 -0400
Received: from lazybastard.de ([212.112.238.170]:38626 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXFAMBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:01:24 -0400
Date: Fri, 1 Jun 2007 13:56:44 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH resend] introduce I_SYNC
Message-ID: <20070601115644.GA30328@lazybastard.org>
References: <20070516170110.GC8113@lazybastard.org> <B2D11B52-B25C-4063-BC4F-4066F78E286C@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B2D11B52-B25C-4063-BC4F-4066F78E286C@cam.ac.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 June 2007 09:59:17 +0100, Anton Altaparmakov wrote:
> 
> I agree that your patch is a good idea.  I reviewed the latest  
> incarnation and it makes sense to me.  And your comment concerning  

Thanks.

> the flags is a very welcome addition.  Probably ought to find its way  
> into Documentation/filesystems/Locking or vfs.txt or somewhere like  
> that also.

Might make sense.  Right now I would be more interested in getting the
questions at the bottom answered.  Possibly the right answer might be
"here is a patch to fix it".

> Note that once your patch is applied I think it would make sense to  
> follow up with a second patch to remove the I_LOCK flag completely.   
> The only remaining uses are either together with I_NEW in which case  
> I_LOCK can be removed altogether or can be substituted with I_NEW  
> when only I_LOCK is used.  This is because no places remain where we  
> set I_LOCK by itself any more with your patch.  The only place where  
> we set it is the place where a new inode gets created in memory and  
> in that place we also set I_NEW at the same time as I_LOCK.   
> wait_on_inode() can then be changed to wait on I_NEW instead of on  
> I_LOCKED.  That way we have one less confusing flag to worry about  
> and things are much easier to understand.

True.  Waiting on I_NEW would be equivalent to waiting on I_LOCK.  To
some degree I still prefer the current method.  I_NEW is a state, while
I_LOCK is a lock or completion method.  Having a confusing mix of
state/lock/completion bits is bad enough.  Having such a mix of uses for
a single bit could be even worse.

> >I still suspect that NTFS has hit the same deadlock and its current  
> >"fix" will cause data corruption instead.
> 
> The NTFS "fix" will not cause data corruption at all.  The usage in  
> NTFS is very different...  I am afraid your patch does not address  
> the deadlock with NTFS or rather it only addresses the inode write  
> deadlock and does not address the get_new_inode() deadlock that  
> exists with ilookup5() and is avoided by ilookup5_nowait().  This  
> deadlock is inherent to what NTFS does so you don't need to worry  
> about it.  (If you want I am happy to explain it but I would rather  
> not waste my time explaining if no-one except me cares about it...)

Two seperate deadlocks exist, we agree on this.  I_SYNC only solves one
of the two.  LogFS solved the second deadlock by implementing its own
destroy_inode() and drop_inode() methods.  Any inodes that would cause
the get_new_inode() deadlock get cached and logfs implements its own
iget() method to return a cached inode from any deadlock-prone codepath.

It is not a pretty solution, but ilookup_nowait() would definitely cause
data corruption for logfs, so that was not an option.  Better ideas are
very welcome.

Jörn

-- 
The strong give up and move away, while the weak give up and stay.
-- unknown
