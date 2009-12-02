Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZLBNh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZLBNh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZLBNh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:37:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:64836 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbZLBNh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:37:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217911323"
Date: Wed, 2 Dec 2009 21:37:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24/24] HWPOISON: show corrupted file info
Message-ID: <20091202133753.GF13277@localhost>
References: <20091202031231.735876003@intel.com> <20091202043046.791112765@intel.com> <20091202132048.GI18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202132048.GI18989@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:20:48PM +0800, Andi Kleen wrote:
> > +	dentry = d_find_alias(inode);
> > +
> > +	if (dentry) {
> > +		spin_lock(&dentry->d_lock);
> > +		name = dentry->d_name.name;
> > +	}
> 
> The standard way to do that is d_path()

Good idea.

> But the paths are somewhat meaningless without the root.

It would still be more helpful :)

> Better to not print path names for now.

OK.

> And pgoff should be just a byte offset with a range

Makes sense.


btw, I have a patch (maybe out of date) to allow calling d_path()
without a known root:


Subject: vfs: enable __d_path() to handle NULL vfsmnt

Enable __d_path() to handle vfsmnt==NULL case.

This can happen when the caller only have a struct inode/dentry instead of a
struct file, and still want to print the (partial) path within the filesystem.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
---

---
 fs/dcache.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1943,7 +1943,10 @@ char *__d_path(const struct path *path, 
 
 		if (dentry == root->dentry && vfsmnt == root->mnt)
 			break;
-		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
+		if (unlikely(!vfsmnt)) {
+			if (IS_ROOT(dentry))
+				break;
+		} else if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
 			/* Global root? */
 			if (vfsmnt->mnt_parent == vfsmnt) {
 				goto global_root;
