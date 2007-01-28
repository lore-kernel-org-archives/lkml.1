Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbXA1P3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbXA1P3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932692AbXA1P3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:29:23 -0500
Received: from amsfep20-int.chello.nl ([62.179.120.15]:34964 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbXA1P3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:29:09 -0500
Subject: Re: [PATCH 0/7] breaking the global file_list_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070128151122.GA21159@infradead.org>
References: <20070128115118.837777000@programming.kicks-ass.net>
	 <20070128144325.GB16552@infradead.org>
	 <20070128151122.GA21159@infradead.org>
Content-Type: text/plain
Date: Sun, 28 Jan 2007 16:29:04 +0100
Message-Id: <1169998144.10987.28.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-28 at 15:11 +0000, Christoph Hellwig wrote:

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
> 
> Once sb->s_files is gone we can also kill of fu_list entirely and
> replace it by a list head entirely in the tty code and make the lock
> for it per-tty.

I shall pursue this direction. Thanks for the information.

