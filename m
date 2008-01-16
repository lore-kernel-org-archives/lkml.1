Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbYAPGr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbYAPGr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 01:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYAPGrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 01:47:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:4998 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYAPGrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 01:47:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nHo8VnhCRQnGhAAA6tN52BjF0860VkdO5C8ZcxKx9Y6ENo6Y82ZNC97tu+WKGAFZsBWzVczYp19bKhcrf3XCeVhzVNVKRMjZ/YZCWxWtWU4ryhjRHY7n94+MJAzpjLLvQRBv/NTVu3I0yWjJnBl3FREV/U9lM8JYsnFmOT8fdrk=
Message-ID: <478DA86F.10905@gmail.com>
Date: Wed, 16 Jan 2008 15:47:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       bluez-devel@lists.sourceforge.net, cornelia.huck@de.ibm.com
Subject: Re: [PATCH 2.6.24-rc7 2/2] sysfs: fix bugs in sysfs_rename/move_dir()
References: <478D74A6.7000206@gmail.com> <478D75BD.1010805@gmail.com> <alpine.LFD.1.00.0801151928380.2806@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801151928380.2806@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 16 Jan 2008, Tejun Heo wrote:
>> * sysfs_move_dir() has an extra dput() on success path.
> 
> Are you sure? How did this ever work?

I'm pretty sure.  I've seen dentry blowing up due to early release &&
compared it with older code.  It was my mistake during restructuring
error path.  The only user of sysfs_move_dir() was S390 Cornelia works
on (cc'd).  Cornelia is usually very good at spotting and debugging
sysfs bugs.  Dunno how it got slipped this time.

> Also, looking at this, I think the "how did this ever work" question is 
> answered by "it didn't",

Before dput() bug was introduced, it worked although error handling path
was broken.

> but I also think there are still serious problems 
> there. Look at
> 
> 	again:
> 	        mutex_lock(&old_parent->d_inode->i_mutex);
> 	        if (!mutex_trylock(&new_parent->d_inode->i_mutex)) {
> 	                mutex_unlock(&old_parent->d_inode->i_mutex);
> 	                goto again;
> 	        }
> 
> and wonder what happen sif old_parent == new_parent. Is that trying to 
> avoid an ABBA deadlock?

It will fall in infinite loop if old_parent == new_parent and for the
question, I suppose so.  Cornelia, right?

> Normally you'd do it by ordering the locks, or by 
> taking a third lock to guarantee serialization at a higher level (ie the 
> "s_vfs_rename_mutex" on the VFS layer)

sysfs currently doesn't depend on VFS locking.  VFS locking is done just
to keep VFS layer happy.  sysfs_dirent hierarchy is protected by
sysfs_mutex and renaming/moving are protected by sysfs_rename_mutex.  As
both ops are under rename_mutex, I think the above code just can grab
both mutexes in any order.  It's probably a remnant of the days when
sysfs used VFS locking to protect internal structures.

s390 was the only user of the move interface till now and through all
the recent sysfs change, it didn't receive enough attention other than
Cornelia's testing.  Eventually, I think sysfs_rename_dir() and
sysfs_move_dir() should be merged into sysfs_move() but for the current
two users, I don't see anything wrong with the locking.

Thanks.

-- 
tejun
