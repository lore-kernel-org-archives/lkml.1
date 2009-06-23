Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbZFWRCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbZFWRCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbZFWRB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:01:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZFWRB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:01:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu>
References: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@ZenIV.linux.org.uk, adilger@sun.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Date: Tue, 23 Jun 2009 17:59:16 +0100
Message-ID: <17246.1245776356@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Not sure if it's a good base for what AFS/pioctl is trying to do, but
> it's something that I personally would very much like to see.

It could be useful.  The problem is that I then need to do an ioctl() on it.

To emulate a pioctl with this, I'd need something like the following in a
library:

	long pioctl(char *path, int cmd, struct ViceIoctl *arg, int nofollow)
	{
		struct ioctl_pioctl {
			int cmd;
			struct ViceIoctl *arg;
		} ip;
		long ret;
		int fd;

		switch (cmd) {
		case VIOC_CMD1:
		case VIOC_CMD2:
		case VIOC_CMD3:
			fd = open(path, O_NOACC | (nofollow ? O_NOFOLLOW : 0));
			ip.cmd = cmd;
			ip.arg = arg;
			ret = ioctl(fd, DO_PIOCTL, &ip);
			close(fd);
			break;
		}

		return ret;
	}

Now, the DO_PIOCTL constant could be dispensed with, and each VIOC_CMDx be
mapped to a different ioctl command number.  Note that you may not assume that
the set of pioctl numbers shares with the set of ioctl numbers, so you can't
just hand the cmd number through as-is.

Not all pioctl commands need to be emulated this way.  Some could call getxattr
instead, for instance, and some could muck around with /proc and /sys files.

>   2) open with "3" calls driver's ->open() with any side effect that
>      may have.  Open with O_NOACC doesn't do that, and hence if we
>      want to allow ioctls they need a new interface which gets a
>      "struct path" instead of a "struct file".

You don't actually need that.  struct file contains a struct path.  You just
need a way to come up with an alternative set of file ops for an O_NOACC open
- perhaps through struct inode_operations.

Alternatively, you could install a special set of generic file ops that only
has an ioctl op.  This could then redirect through another ioctl op in the
inode_operations struct.

As I mentioned in another email, for emulation of pioctl(), I need O_NOACC to
_not_ call device_driver->open() on device files, and to not install the
device driver file ops table.  pioctl() operates on the underlying file in the
underlying fs.

David
