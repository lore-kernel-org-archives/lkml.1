Return-Path: <linux-kernel-owner+w=401wt.eu-S933963AbXCFGXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963AbXCFGXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 01:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933964AbXCFGXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 01:23:13 -0500
Received: from waste.org ([66.93.16.53]:45950 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933962AbXCFGXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 01:23:10 -0500
Date: Tue, 6 Mar 2007 00:10:09 -0600
From: Matt Mackall <mpm@selenic.com>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@stusta.de>, Theodore Tso <tytso@mit.edu>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: Re: [2.6.21 patch] unconditionally enable SYSFS_DEPRECATED
Message-ID: <20070306061009.GR23311@waste.org>
References: <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com> <20070305125950.GC26781@thunk.org> <20070305185813.GA31465@kroah.com> <20070305234052.GR3441@stusta.de> <20070306000722.GA11436@kroah.com> <20070306013020.GN23311@waste.org> <20070306024850.GA24477@kroah.com> <20070306033947.GQ23311@waste.org> <20070306040350.GA25783@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306040350.GA25783@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 08:03:50PM -0800, Greg KH wrote:
> On Mon, Mar 05, 2007 at 09:39:47PM -0600, Matt Mackall wrote:
> > On Mon, Mar 05, 2007 at 06:48:50PM -0800, Greg KH wrote:
> > > If so, can you disable the option and strace it to see what program is
> > > trying to access what?  That will put the
> > > HAL/NetworkManager/libsysfs/distro script finger pointing to rest pretty
> > > quickly :)
> > 
> > Ok, I've got straces of both good and bad (>5M each). Filtered out
> > random pointer values and the like, diffed, and filtered for /sys/,
> > and the result's still 1.5M. What should I be looking for?
> 
> Failures when trying to read from /sys/class/net/
> 
> Or opening the directory and iterating over the subdirs in there.  Or
> something like that.
> 
> But the /sys/class/net/ stuff should hopefully help narrow it down.

Works:

6857  open("/sys/class/net",
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 13
6857  fstat64(13, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
6857  fcntl64(13, F_SETFD, FD_CLOEXEC)  = 0
6857  getdents64(13, /* 5 entries */, 4096) = 120
6857  readlink("/sys/class/net/eth1", 0x80a2450, 256) = -1 EINVAL
(Invalid argument)
6857  readlink("/sys/class/net/eth1/device",
"../../../devices/pci0000:00/0000:00:1e.0/0000:02:02.0", 256) = 53
6857  readlink("/sys/class/net/lo", 0x80a2450, 256) = -1 EINVAL
(Invalid argument)
6857  readlink("/sys/class/net/lo/device", 0x80a2450, 256) = -1 ENOENT
(No such
file or directory)
6857  readlink("/sys/class/net/eth0", 0x80a2450, 256) = -1 EINVAL
(Invalid argument)
6857  readlink("/sys/class/net/eth0/device",
"../../../devices/pci0000:00/0000:00:1e.0/0000:02:01.0", 256) = 53
6857  getdents64(13, /* 0 entries */, 4096) = 0
6857  close(13)                         = 0

Breaks:

3620  open("/sys/class/net",
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 13
3620  fstat64(13, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
3620  fcntl64(13, F_SETFD, FD_CLOEXEC)  = 0
3620  getdents64(13, /* 5 entries */, 4096) = 120
3620  readlink("/sys/class/net/eth1",
"../../devices/pci0000:00/0000:00:1e.0/00\00:02:02.0/eth1", 256) = 55
3620
readlink("/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0/eth1/device",
0x809e910, 256) = -1 ENOENT (No such file or directory)
3620  readlink("/sys/class/net/lo", "../../devices/virtual/net/lo",
256) = 28
3620  readlink("/sys/devices/virtual/net/lo/device", 0x809e960, 256) =
-1 ENOEN\T (No such file or directory)
3620  readlink("/sys/class/net/eth0",
"../../devices/pci0000:00/0000:00:1e.0/00\00:02:01.0/eth0", 256) = 55
3620
readlink("/sys/devices/pci0000:00/0000:00:1e.0/0000:02:01.0/eth0/device",
0x809e960, 256) = -1 ENOENT (No such file or directory)
3620  getdents64(13, /* 0 entries */, 4096) = 0
3620  close(13)                         = 0

-- 
Mathematics is the supreme nostalgia of our time.
