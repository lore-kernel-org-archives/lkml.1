Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbYAPDmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbYAPDmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbYAPDm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:42:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030AbYAPDm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:42:26 -0500
Date: Tue, 15 Jan 2008 19:41:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.24-rc7 2/2] sysfs: fix bugs in
 sysfs_rename/move_dir()
In-Reply-To: <478D75BD.1010805@gmail.com>
Message-ID: <alpine.LFD.1.00.0801151928380.2806@woody.linux-foundation.org>
References: <478D74A6.7000206@gmail.com> <478D75BD.1010805@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Tejun Heo wrote:
>
> * sysfs_move_dir() has an extra dput() on success path.

Are you sure? How did this ever work?

Also, looking at this, I think the "how did this ever work" question is 
answered by "it didn't", but I also think there are still serious problems 
there. Look at

	again:
	        mutex_lock(&old_parent->d_inode->i_mutex);
	        if (!mutex_trylock(&new_parent->d_inode->i_mutex)) {
	                mutex_unlock(&old_parent->d_inode->i_mutex);
	                goto again;
	        }

and wonder what happen sif old_parent == new_parent. Is that trying to 
avoid an ABBA deadlock? Normally you'd do it by ordering the locks, or by 
taking a third lock to guarantee serialization at a higher level (ie the 
"s_vfs_rename_mutex" on the VFS layer)

I'd like to apply these two patches, but I really want to get more of an 
ack for them from somebody like Al, or at least more of an explanation for 
why it's all the right thing.

			Linus
