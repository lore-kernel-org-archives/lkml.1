Return-Path: <linux-kernel-owner+w=401wt.eu-S1161202AbXCGCAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202AbXCGCAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161206AbXCGCAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:00:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42948 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161202AbXCGCA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:00:29 -0500
Date: Tue, 6 Mar 2007 17:56:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Oliver Neukum <oliver@neukum.name>, Maneesh Soni <maneesh@in.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
In-Reply-To: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0703061735350.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Hugh Dickins wrote:
> 
> This comes from Oliver's commit 94bebf4d1b8e7719f0f3944c037a21cfd99a4af7
> Driver core: fix race in sysfs between sysfs_remove_file() and read()/write()
> in 2.6.21-rc1.  It looks to me like sysfs_write_file downs buffer->sem
> while calling flush_write_buffer, and flushing that particular write
> buffer entails downing buffer->sem in orphan_all_buffers.

Gaah. What a crock.

I really don't see any alternative to just reverting the whole change. 
Hugh's patch is simple, but rather pointless.

The fact is, the whole change is *bogus*.

We don't "lock" datastructures. We *reference count* them!

This is so fundamental that it's even mentioned in the file 
Documentation/CodingStyle in "Chapter 11: Data structures".

The whole "orphaned" kind of locking is broken. It's stupid. The way we do 
races between removal and use is that initial setup sets a reference count 
of 1, and something really simple like:

	static inline struct sysfs_buffer *get_sysfs_buffer(struct inode *inode)
	{
		struct sysfs_buffer *buffer = inode->i_private;

		BUG_ON(!mutex_locked(&inode->i_mutex));
		if (buffer)
			atomic_inc(&buffer->count);
		return buffer;
	}

	static inline void put_sysfs_buffer(struct sysfs_buffer *buffer)
	{
		if (atomic_dec_and_test(&buffer->count))
			kfree(buffer);
	}

and then the rule is:

 - everybody uses "get_sysfs_buffer()" to follow the reference (and yes, 
   you obviously have to hold "inode->i_mutex" for this to be safe! I 
   added the BUG_ON() as an example)

 - everybody uses "put_buffer()" to release it (and we simply don't *care* 
   whether somebody else released it too, since everybody has a reference 
   count)

 - removing the buffer is now just

	mutex_lock(&inode->i_mutex);
	buffer = inode->i_private;
	inode->i_private = NULL;
	mutex_unlock(&inode->i_mutex);

	put_sysfs_buffer(buffer);

 - everybody is happy!

Anyway, I'm unable to revert the broken commit, since there are now other 
changes that depend on it, but can somebody *please* do that? I'll apply 
Hugh's silly patch in the meantime, just to avoid the lockup.

			Linus
