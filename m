Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbYAEOam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbYAEOam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 09:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYAEOad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 09:30:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:62659 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYAEOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:30:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=w9NKhihU2Fw1ysyy5e7LDrXJ14ckLvOQQqglsinDQCnyTtPB4vuTTWytRRhC9hccJG7n9k3GzviMTkH5FIKEBMzjde2cN3poBCEv8UR2W4gveYEx78n5J5Zen9gqO7BJtJYXe6m6jkxzR7SqHW7k702JbBFYVCUkArOzoGhVP7Q=
Message-ID: <477F9481.2040505@gmail.com>
Date: Sat, 05 Jan 2008 23:30:25 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Gabor Gombas <gombasg@sztaki.hu>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk>
In-Reply-To: <20080105075039.GF27894@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Al Viro wrote:
> sysfs_get_dentry(),
>                 mutex_lock(&parent->d_inode->i_mutex);
> hitting parent->d_inode either NULL or very close to it, depending on your
> .config; most likely NULL, if offset of i_mutex is 0xb8 in your build.
> That's plausible - 0xb8 is what you'd get on UP build without spinlock
> debugging, lockdep, etc.
> 
> Assuming that this is what we get, everything looks explainable - we
> have sysfs_rename_dir() calling sysfs_get_dentry() while the parent
> gets evicted.  We don't have any exclusion, so while we are playing
> silly buggers with lookups in sysfs_get_dentry() we have parent become
> negative; the rest is obvious...

That part of code is walking down the sysfs tree from the s_root of
sysfs hierarchy and on each step parent is held using dget() while being
referenced, so I don't think they can turn negative there.

> AFAICS, the locking here is quite broken and frankly, sysfs_get_dentry()
> and the way it plays with fs/namei.c are ucking fugly.

Can you elaborate a bit?  The locking in sysfs is unconventional but
that's mostly from necessity.  It has dual interface - vfs and driver
model && vfs data structures (dentry and inode) are too big to always
keep around, so it basically becomes a small distributed file system
where the backing data can change asynchronously.

> Could you stick
> 	if (!parent->d_inode)
> 		printk(KERN_WARNING "sysfs locking blows: %s",
> 			parent->d_name.name);
> right before
>                 mutex_lock(&parent->d_inode->i_mutex);
>                 dentry = lookup_one_noperm(cur->s_name, parent);
>                 mutex_unlock(&parent->d_inode->i_mutex);
> in sysfs_get_dentry() (fs/sysfs/dir.c) and verify that it does, indeed,
> trigger?

Yes, please.

Thanks.

-- 
tejun
