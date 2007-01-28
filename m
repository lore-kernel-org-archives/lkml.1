Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXA1PL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXA1PL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbXA1PL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:11:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36060 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbXA1PL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:11:28 -0500
Date: Sun, 28 Jan 2007 15:11:22 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
Message-ID: <20070128151122.GA21159@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070128144325.GB16552@infradead.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 28, 2007 at 02:43:25PM +0000, Christoph Hellwig wrote:
> On Sun, Jan 28, 2007 at 12:51:18PM +0100, Peter Zijlstra wrote:
> > This patch-set breaks up the global file_list_lock which was found to be a
> > severe contention point under basically any filesystem intensive workload.
> 
> Benchmarks, please.  Where exactly do you see contention for this?
> 
> 
> filesystem intensive workload apparently means namespace operation heavy
> workload, right?  The biggest bottleneck I've seen with those is dcache lock.
> 
> Even if this is becoming a real problem there must be simpler ways to fix
> this than introducing various new locking primitives and all kinds of
> complexity.

One good way to fix scalability without all this braindamage is
to get rid of sb->s_files.  Current uses are:

 - fs/dquot.c:add_dquot_ref()

	This performs it's actual operation on inodes.  We should
	be able to check inode->i_writecount to see which inodes
	need quota initialization.

 - fs/file_table.c:fs_may_remount_ro()

	This one is gone in Dave Hansens per-mountpoint r/o patchkit

 - fs/proc/generic.c:proc_kill_inodes()

	This can be done with a list inside procfs.

 - fs/super.c:mark_files_ro()

	This one is only used for do_emergency_remount(), which is
	and utter hack.  It might be much better to just deny any
	kind of write access through a superblock flag here.

 - fs/selinuxfs.c:sel_remove_bools()

	Utter madness.  I have no idea how this ever got merged.
	Maybe the selinux folks can explain what crack they were
	on when writing this.  The problem would go away with
	a generic rewoke infrastructure.

Once sb->s_files is gone we can also kill of fu_list entirely and
replace it by a list head entirely in the tty code and make the lock
for it per-tty.
