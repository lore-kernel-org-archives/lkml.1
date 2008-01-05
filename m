Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbYAEHu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbYAEHu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 02:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYAEHut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 02:50:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51904 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYAEHut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 02:50:49 -0500
Date: Sat, 5 Jan 2008 07:50:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, htejun@gmail.com
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080105075039.GF27894@ZenIV.linux.org.uk>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102151642.GA7273@boogie.lpds.sztaki.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 04:16:42PM +0100, Gabor Gombas wrote:
> Heh, it seems talking about a bug makes it trigger:
> 
> Jan  2 16:05:45 twister kernel: Unable to handle kernel NULL pointer dereference at 00000000000000b8 RIP: 
> Jan  2 16:05:45 twister kernel:  [<ffffffff804720a5>] mutex_lock+0x10/0x1d
 
> So the patch referenced above does not help. But I've found a very easy
> way to trigger the bug:
> 
> - do a "cat /dev/zero > /dev/rfcomm0"
> - switch the phone off
> - switch the phone on, and the kernel oopses

sysfs_get_dentry(),
                mutex_lock(&parent->d_inode->i_mutex);
hitting parent->d_inode either NULL or very close to it, depending on your
.config; most likely NULL, if offset of i_mutex is 0xb8 in your build.
That's plausible - 0xb8 is what you'd get on UP build without spinlock
debugging, lockdep, etc.

Assuming that this is what we get, everything looks explainable - we
have sysfs_rename_dir() calling sysfs_get_dentry() while the parent
gets evicted.  We don't have any exclusion, so while we are playing
silly buggers with lookups in sysfs_get_dentry() we have parent become
negative; the rest is obvious...

AFAICS, the locking here is quite broken and frankly, sysfs_get_dentry()
and the way it plays with fs/namei.c are ucking fugly.

Could you stick
	if (!parent->d_inode)
		printk(KERN_WARNING "sysfs locking blows: %s",
			parent->d_name.name);
right before
                mutex_lock(&parent->d_inode->i_mutex);
                dentry = lookup_one_noperm(cur->s_name, parent);
                mutex_unlock(&parent->d_inode->i_mutex);
in sysfs_get_dentry() (fs/sysfs/dir.c) and verify that it does, indeed,
trigger?
