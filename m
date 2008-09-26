Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYIZPsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYIZPsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYIZPr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:47:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbYIZPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:47:57 -0400
Date: Fri, 26 Sep 2008 08:47:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: viro@zeniv.linux.org.uk, ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc7-sha1: EIP at proc_sys_compare+0x36/0x50
In-Reply-To: <20080926152031.GA30831@x200.localdomain>
Message-ID: <alpine.LFD.1.10.0809260838120.3265@nehalem.linux-foundation.org>
References: <20080926152031.GA30831@x200.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Sep 2008, Alexey Dobriyan wrote:
>
> Gentlemen, this happened while script was slowly rebuilding 300+ configs
> sequentially. Very little recompling activity itself, much seeking.
> 
> This is first time I see this. No debugging was on, no preemption.
> 
> Version: 2.6.27-rc7-c0f4d6d4b14a75a341d972ff73fb9740e1ceb634 +
> 	atl1 fixlet + "notes" kobject fixlet, but they don't matter.
> 
> ffffffff802bc690 <proc_sys_compare>:
....
> ffffffff802bc6c0:	75 dd                	jne    ffffffff802bc69f <proc_sys_compare+0xf>
> ffffffff802bc6c2:	49 8b 40 e0          	mov    -0x20(%r8),%rax
> ffffffff802bc6c6: ===>	48 8b 78 f0          	mov    -0x10(%rax),%rdi		<===
> ffffffff802bc6ca:	e8 71 96 f7 ff       	callq  ffffffff80235d40 <sysctl_is_seen>

That would be the

	sysctl_is_seen(PROC_I(dentry->d_inode)->sysctl)

call, and it really looks like 'dentry->d_inode' is NULL:

> [16526.029537] BUG: unable to handle kernel paging request at fffffffffffffff0

The whole PROC_I() thing just offsets from the inode:

	container_of(inode, struct proc_inode, vfs_inode);

and 'sysctl' is indeed 16 bytes below the vfs inode on x86-64:

	struct proc_inode {
		...
	        struct ctl_table_header *sysctl;
	        struct ctl_table *sysctl_entry;
	        struct inode vfs_inode;
	};

and as far as I can tell, there is nothing to say that a /proc inode 
cannot be a negative dentry. Sure, we try to get rid of them, but during a 
parallel lookup, we will have added the dentry with a NULL inode in the 
other lookup.

So assuming that you have an inode at that point seems to be utter crap.

Now, the whole _function_ is utter crap and should probably be dropped, 
but whatever. That's just another sysctl insanity. In the meantime, 
something like this does look appropriate, no?

Al, did I miss something?

		Linus
---
 fs/proc/proc_sysctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index f9a8b89..9435fd0 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -386,6 +386,8 @@ static int proc_sys_compare(struct dentry *dir, struct qstr *qstr,
 		return 1;
 	if (memcmp(qstr->name, name->name, name->len))
 		return 1;
+	if (!dentry->d_inode)
+		return 1;
 	return !sysctl_is_seen(PROC_I(dentry->d_inode)->sysctl);
 }
 
