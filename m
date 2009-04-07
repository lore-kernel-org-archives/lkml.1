Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbZDGFbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbZDGFbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZDGFbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:31:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:1864 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbZDGFbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,335,1235980800"; 
   d="scan'208";a="128632520"
Date: Tue, 7 Apr 2009 13:30:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Avan Anishchuk <matimatik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [GIT PULL] SLAB include file dependency fixes + kmemtrace
	updates
Message-ID: <20090407053039.GA22854@localhost>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain> <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain> <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain> <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 12:45:37PM +0800, Linus Torvalds wrote:
> 
> 
> On Mon, 6 Apr 2009, Linus Torvalds wrote:
> > 
> > It bisected past them. I'm getting worried that it's timing-related, 
> > because nothing that remains looks even remotely interesting for that Mac 
> > mini, but right now:
> > 
> >  - bad: 56fcef75117a153f298b3fe54af31053f53997dd
> >  - good: bb233fdfc7b7cefe45bfa2e8d1b24e79c60a48e5
> > 
> > and there's not a whole lot of commits in between.
> 
> It's c3b1b1cbf002e65a3cabd479e68b5f35886a26db: 'ramfs: add support for 
> "mode=" mount option'.
> 
> And I checked. Reverting it at the tip fixes it. So no random timing 
> fluctuations.
> 
> So that commit causes some random SLAB corruption, that then (depending 
> apparently on luck) may or may not crash in some odd random places later.
> 
> Wu?

Maybe this bug?

Thanks,
Fengguang
---
ramfs: fix double freeing s_fs_info

On a failed ramfs mount, s_fs_info will be freed twice in ramfs_fill_super()
and ramfs_kill_sb(). Fix it by saving s_fs_info only on success.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a404fb8..7dbb433 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -225,7 +225,6 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 		err = -ENOMEM;
 		goto fail;
 	}
-	sb->s_fs_info = fsi;
 
 	err = ramfs_parse_options(data, &fsi->mount_opts);
 	if (err)
@@ -249,6 +248,7 @@ static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
 		goto fail;
 	}
 	sb->s_root = root;
+	sb->s_fs_info = fsi;
 	return 0;
 fail:
 	kfree(fsi);
