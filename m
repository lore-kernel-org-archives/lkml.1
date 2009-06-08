Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZFHNvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZFHNvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZFHNvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:51:14 -0400
Received: from verein.lst.de ([213.95.11.210]:38192 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbZFHNvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:51:12 -0400
Date: Mon, 8 Jun 2009 15:51:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: types for storing instruction pointers
Message-ID: <20090608135106.GA2276@lst.de>
References: <20090604131400.GA31596@lst.de> <20090607132516.GB12088@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090607132516.GB12088@elte.hu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 03:25:16PM +0200, Ingo Molnar wrote:
> 
> * Christoph Hellwig <hch@lst.de> wrote:
> 
> > Currently the _THIS_IP_ and _RET_IP_ macros aded for lockdep but 
> > now available from kernel.org case the instruction pointer to an 
> > unsigned long.  But the %pf/%pF format for printing them want a 
> > pointer of some sort.  That's a pretty nasty situation for tracers 
> > - can we standardize on one type for it?
> 
> Yes but what's the practical problem exactly? Could you cite an 
> example?

The simplest tracer in xfs showing this is the following:

/*
 * ilock/iolock tracer
 *
 * Reports the inode, operation, flags and caller for each operation
 * on the inode locks.
 */
TRACE_EVENT(xfs_ilock,
	TP_PROTO(struct xfs_inode *ip, const char *op, unsigned lockflags,
		 unsigned long caller_ip),
	TP_ARGS(ip, op, lockflags, caller_ip),

	TP_STRUCT__entry(
		__field(dev_t, dev)
		__field(xfs_ino_t, ino)
		__field(const char *, op)
		__field(int, lockflags)
		__field(unsigned long, caller_ip)
	),

	TP_fast_assign(
		__entry->dev = VFS_I(ip)->i_sb->s_dev;
		__entry->ino = ip->i_ino;
		__entry->op = op;
		__entry->lockflags = lockflags;
		__entry->caller_ip = caller_ip;
	),

	TP_printk("dev %d:%d ino 0x%lld %s %s by %pF",
		  MAJOR(__entry->dev), MINOR(__entry->dev),
		  __entry->ino,
		  __entry->op,
		  __print_flags(__entry->lockflags, "|", XFS_LOCK_FLAGS),
		  (void *)__entry->caller_ip)
);

It has the following callers:

	trace_xfs_ilock(ip, "lock", lock_flags, _RET_IP_);
	trace_xfs_ilock(ip, "lock_nowait", lock_flags, _RET_IP_);
	trace_xfs_ilock(ip, "unlock", lock_flags, _RET_IP_);
	trace_xfs_ilock(ip, "demote", lock_flags, _RET_IP_);

Basically everything obtained via _RET_IP_/_THIS_IP_ needs to be
casted.  Given that both need to case the their return value to a
pointer that's rather unfortunately.  Life would be much easier
if _RET_IP_/_THIS_IP_ just returned a pointer (probably just a void
pointer, maybe with a fancy typedef to make it clear we're dealing
with an instruction pointer here).
