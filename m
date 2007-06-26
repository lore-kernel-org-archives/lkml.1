Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbXFZJ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbXFZJ1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFZJ1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:27:12 -0400
Received: from mx12.go2.pl ([193.17.41.142]:46889 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751096AbXFZJ1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:27:12 -0400
Date: Tue, 26 Jun 2007 11:35:20 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Chinner <dgc@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Satyam Sharma <satyam.sharma@gmail.com>,
       Johannes Weiner <hannes-kernel@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com
Subject: Re: [BUG] Lockdep warning with XFS on 2.6.22-rc6
Message-ID: <20070626093520.GB2691@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626021617.GK989688@sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-06-2007 04:16, David Chinner wrote:
> On Mon, Jun 25, 2007 at 11:01:11PM +0200, Ingo Molnar wrote:
>> * Satyam Sharma <satyam.sharma@gmail.com> wrote:
>>
>>> [ Ok, so we know that XFS wants to lock inodes in ascending inode 
>>> number order and not strictly the parent-first-child-second order that 
>>> rest of the fs/ code does, so that makes it difficult to teach lockdep 
>>> about this kind of lock ordering ... ]
> 
> It does both - parent-first/child-second and ascending inode # order,
> which is where the problem is. standing alone, these seem fine, but
> they don't appear to work when the child has a lower inode number
> than the parent.
...

>From xfs_inode.h:

/*
 * Flags for lockdep annotations.
 *
 * XFS_I[O]LOCK_PARENT - for operations that require locking two inodes
 * (ie directory operations that require locking a directory inode and
 * an entry inode).  The first inode gets locked with this flag so it
 * gets a lockdep subclass of 1 and the second lock will have a lockdep
 * subclass of 0.
 *
 * XFS_I[O]LOCK_INUMORDER - for locking several inodes at the some time
 * with xfs_lock_inodes().  This flag is used as the starting subclass
 * and each subsequent lock acquired will increment the subclass by one.
 * So the first lock acquired will have a lockdep subclass of 2, the
 * second lock will have a lockdep subclass of 3, and so on.
 */

I don't know xfs code, and probably miss something, but it seems
there could be some inconsistency: lockdep warning shows mr_lock/1
taken both before and after mr_lock (i.e. /0). According to the
above comment there should be always 1 before 0...

Cheers,
Jarek P.  
