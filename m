Return-Path: <linux-kernel-owner+w=401wt.eu-S1751393AbXA2Ngl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbXA2Ngl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXA2Ngl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:36:41 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:56529 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751393AbXA2Ngk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:36:40 -0500
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <20070128151122.GA21159@infradead.org>
References: <20070128115118.837777000@programming.kicks-ass.net>
	 <20070128144325.GB16552@infradead.org>
	 <20070128151122.GA21159@infradead.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 29 Jan 2007 08:32:53 -0500
Message-Id: <1170077573.8720.30.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-28 at 15:11 +0000, Christoph Hellwig wrote:
> On Sun, Jan 28, 2007 at 02:43:25PM +0000, Christoph Hellwig wrote:
> > On Sun, Jan 28, 2007 at 12:51:18PM +0100, Peter Zijlstra wrote:
> > > This patch-set breaks up the global file_list_lock which was found to be a
> > > severe contention point under basically any filesystem intensive workload.
> > 
> > Benchmarks, please.  Where exactly do you see contention for this?
> > 
> > 
> > filesystem intensive workload apparently means namespace operation heavy
> > workload, right?  The biggest bottleneck I've seen with those is dcache lock.
> > 
> > Even if this is becoming a real problem there must be simpler ways to fix
> > this than introducing various new locking primitives and all kinds of
> > complexity.
> 
> One good way to fix scalability without all this braindamage is
> to get rid of sb->s_files.  Current uses are:
> 
>  - fs/dquot.c:add_dquot_ref()
> 
> 	This performs it's actual operation on inodes.  We should
> 	be able to check inode->i_writecount to see which inodes
> 	need quota initialization.
> 
>  - fs/file_table.c:fs_may_remount_ro()
> 
> 	This one is gone in Dave Hansens per-mountpoint r/o patchkit
> 
>  - fs/proc/generic.c:proc_kill_inodes()
> 
> 	This can be done with a list inside procfs.
> 
>  - fs/super.c:mark_files_ro()
> 
> 	This one is only used for do_emergency_remount(), which is
> 	and utter hack.  It might be much better to just deny any
> 	kind of write access through a superblock flag here.
> 
>  - fs/selinuxfs.c:sel_remove_bools()
> 
> 	Utter madness.  I have no idea how this ever got merged.
> 	Maybe the selinux folks can explain what crack they were
> 	on when writing this.  The problem would go away with
> 	a generic rewoke infrastructure.

It was modeled after proc_kill_inodes(), as noted in the comments.  So
if you have a suitable replacement for proc_kill_inodes(), you can apply
the same approach to sel_remove_bools().

> 
> Once sb->s_files is gone we can also kill of fu_list entirely and
> replace it by a list head entirely in the tty code and make the lock
> for it per-tty.

-- 
Stephen Smalley
National Security Agency

