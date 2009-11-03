Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZKCGGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZKCGGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 01:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZKCGGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 01:06:34 -0500
Received: from cobra.newdream.net ([66.33.216.30]:48873 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZKCGGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 01:06:33 -0500
Date: Mon, 2 Nov 2009 22:06:36 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: ext3/jbd oops in journal_start
In-Reply-To: <87bpjorn6g.fsf@openvz.org>
Message-ID: <Pine.LNX.4.64.0911022157360.26157@cobra.newdream.net>
References: <Pine.LNX.4.64.0910302253100.1867@cobra.newdream.net>
 <87bpjorn6g.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009, Dmitry Monakhov wrote:

> Sage Weil <sage@newdream.net> writes:
> 
> > Hi,
> >
> > I'm consistently seeing ext3 oops on a fresh ~60 GB fs on 2.6.32-rc3 (and 
> > 2.6.31).  data=writeback or data=ordered.  It's not the hardware or 
> > drive... I have 8 boxes (each with slightly different hardware) that crash 
> > identically.
> Strange, 2.6.31 with ext3 is quite popular configuration...
> Can you please post exact test-case.
> >
> > The oops is at fs/jbd/transaction.c, journal_start():
> >
> > 		J_ASSERT(handle->h_transaction->t_journal == journal);
> *handle = journal_current_handle()
> 
> IMHO it's looks like you have entered here with current->journal_info != NULL
> 
> , but journal_info contains unexpected data
> This may happens in two cases:
> 1) calling jbd code from other filesystem.
> 2) Some fs forget to zero current->journal_info on exit from vfs
> According to call trace we have got second case. Do you use some 
> unusual/experimental fs?

Yep, it was #2.  It turns out btrfs s setting current->journal_info 
(for no reason that I can see?), and with the transaction ioctl a 
transaction can span multiple calls.

Chris, is it ok to just remove the journal_info bits?  Nothing in fs/btrfs 
even looks at it.  I'm not sure what the point of only conditionally 
setting/clearly journal_info would be either, unless it's for debugging or 
something?

Thanks-
sage

---
From: Sage Weil <sage@newdream.net>
Date: Mon, 2 Nov 2009 14:21:29 -0800
Subject: [PATCH] Btrfs: don't set current->journal_info

Btrfs doesn't use current->journal_info for anything, so don't set it.  
We currently cause a NULL dereference in jbd if a process starts a btrfs 
user transaction and then touches another mounted fs that uses jbd, since 
current->journal_info is only supposed to be set for the duration of a 
single call into the fs.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/transaction.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bca82a4..c6dbbb8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -186,9 +186,6 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	h->alloc_exclude_start = 0;
 	h->delayed_ref_updates = 0;
 
-	if (!current->journal_info)
-		current->journal_info = h;
-
 	root->fs_info->running_transaction->use_count++;
 	record_root_in_trans(h, root);
 	mutex_unlock(&root->fs_info->trans_mutex);
@@ -321,8 +318,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	put_transaction(cur_trans);
 	mutex_unlock(&info->trans_mutex);
 
-	if (current->journal_info == trans)
-		current->journal_info = NULL;
 	memset(trans, 0, sizeof(*trans));
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 
@@ -1105,9 +1100,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	mutex_unlock(&root->fs_info->trans_mutex);
 
-	if (current->journal_info == trans)
-		current->journal_info = NULL;
-
 	kmem_cache_free(btrfs_trans_handle_cachep, trans);
 	return ret;
 }
-- 
1.5.6.5

