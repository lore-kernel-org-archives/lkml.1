Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYI1UrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYI1UrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYI1UrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:47:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbYI1UrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:47:06 -0400
Date: Sun, 28 Sep 2008 13:46:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
In-Reply-To: <20080928141856.GG28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0809281338350.3265@nehalem.linux-foundation.org>
References: <20080926152031.GA30831@x200.localdomain> <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org> <20080928141856.GG28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Sep 2008, Al Viro wrote:
>
> > Al, did I miss something?
> 
> The real underlying bug, whatever it is.  If this sucker ever becomes
> negative, we have a big problem.  Where _could_ that happen?  Remember,
> we do not allow ->rmdir() and ->unlink() to succeed there.

What about pure memory pressure? We're holding only the RCU read-side lock 
when looking up dentries, and if there is any memory pressure, the 
dentries may be unhashed and the inodes removed in parallel. Yes, yes, we 
end up not actually _releasing_ the dentry, since it's all RCU, but it 
will set D_UNHASHED and be scheduled for releasing later under RCU.

And d_compare() is called before we have done any validation that the name 
is still active, including checking whether it even got released already! 

I dunno. Do we want to move the D_UNHASHED check up earlier? Or am I still 
missing something?

		Linus

----
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
