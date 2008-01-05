Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYAETpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYAETpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbYAETpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:45:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37571 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497AbYAETpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:45:15 -0500
Date: Sat, 5 Jan 2008 19:45:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       Greg KH <greg@kroah.com>
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080105194510.GK27894@ZenIV.linux.org.uk>
References: <20071228173203.GA20690@boogie.lpds.sztaki.hu> <a8e1da0712290007o168a730cw923055ad2c265d84@mail.gmail.com> <20080102151642.GA7273@boogie.lpds.sztaki.hu> <20080105075039.GF27894@ZenIV.linux.org.uk> <477F9481.2040505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477F9481.2040505@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 11:30:25PM +0900, Tejun Heo wrote:
> > Assuming that this is what we get, everything looks explainable - we
> > have sysfs_rename_dir() calling sysfs_get_dentry() while the parent
> > gets evicted.  We don't have any exclusion, so while we are playing
> > silly buggers with lookups in sysfs_get_dentry() we have parent become
> > negative; the rest is obvious...
> 
> That part of code is walking down the sysfs tree from the s_root of
> sysfs hierarchy and on each step parent is held using dget() while being
> referenced, so I don't think they can turn negative there.

Turn?  Just what stops you from getting a negative (and unhashed) from
lookup_one_noperm() and on the next iteration being buggered on mutex_lock()?
 
> > AFAICS, the locking here is quite broken and frankly, sysfs_get_dentry()
> > and the way it plays with fs/namei.c are ucking fugly.
> 
> Can you elaborate a bit?  The locking in sysfs is unconventional but
> that's mostly from necessity.  It has dual interface - vfs and driver
> model && vfs data structures (dentry and inode) are too big to always
> keep around, so it basically becomes a small distributed file system
> where the backing data can change asynchronously.

... with all fun that creates.  As it is, you have those async changers
of backing data using VFS locking _under_ sysfs locks via lookup_one_noperm()
and yet it needs sysfs_mutex inside sysfs_lookup().  So you can't have
sysfs_get_dentry() under it.  So you don't have exclusion with arseloads
of sysfs tree changes in there.  Joy...

Frankly, with the current state of sysfs the last vestiges of arguments
used to push it into the tree back then are dead and buried.  I'm not
blaming you, BTW - the shitpile *did* grow past the point where its
memory footprint became far too large and something needed to be done.
Unfortunately, it happened too late for that something being "get rid
of the entire mess" and now we are saddled with it for good.
