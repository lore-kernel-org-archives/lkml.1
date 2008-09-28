Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYI1Uzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYI1Uzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYI1Uzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:55:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734AbYI1Uzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:55:35 -0400
Date: Sun, 28 Sep 2008 13:55:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
In-Reply-To: <Pine.LNX.4.64.0809282011020.1967@blonde.site>
Message-ID: <alpine.LFD.1.10.0809281350410.3265@nehalem.linux-foundation.org>
References: <20080926152031.GA30831@x200.localdomain> <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org> <20080928141856.GG28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0809282011020.1967@blonde.site>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Sep 2008, Hugh Dickins wrote:
> 
> I got a couple of earlier instances of this on powerpc
> http://lkml.org/lkml/2008/8/14/289
> but saw nothing more of it, so asked Al to forget about it.
> 
> But today I've got it again, this time on x86_64, with kdb in
> (but not serial console), similar kernel builds with swapping
> loads as before.  Though with Andrew's latest mmotm, so some
> details different from 2.6.27-rc, and could be an mmotm bug.

Ok, you were definitely under memory pressure, and yes, it looks like the 
exact same bug on ppc64 - access to a pointer that is two poointers offset 
down from NULL.

> The dentry in question (it's for /proc/sys/kernel/ngroups_max)
> looks as if the __d_drop and d_kill of prune_one_dentry() came
> in on one cpu just after __d_lookup() had found the entry on
> parent's hashlist, just before it acquired dentry->d_lock.

Yes. 

> That's plausible, isn't it, and would account for the rarity,
> and would say Linus's patch is good?
> 
> Do ask me for any details you'd like out of the dentry.

I actually like my second patch better - it looks simpler, and it means 
that the rules for filesystems using d_compare() are a bit clearer: at 
least we'll only pass them dentries to look at that haven't gone through 
d_drop (and we do hold dentry->d_lock that serializes all of that).

So here it is again (I sent it out just minutes ago, but you weren't on 
that cc, you must have picked this up off the kernel list)

NOTE! Totally untested patch! It looks sane and really obvious, but maybe 
it has some insane and non-obvious bug.

		Linus

---
 fs/dcache.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 80e9395..e7a1a99 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1395,6 +1395,10 @@ struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
 		if (dentry->d_parent != parent)
 			goto next;
 
+		/* non-existing due to RCU? */
+		if (d_unhashed(dentry))
+			goto next;
+
 		/*
 		 * It is safe to compare names since d_move() cannot
 		 * change the qstr (protected by d_lock).
@@ -1410,10 +1414,8 @@ struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
 				goto next;
 		}
 
-		if (!d_unhashed(dentry)) {
-			atomic_inc(&dentry->d_count);
-			found = dentry;
-		}
+		atomic_inc(&dentry->d_count);
+		found = dentry;
 		spin_unlock(&dentry->d_lock);
 		break;
 next:
