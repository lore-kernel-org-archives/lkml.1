Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbYKVFQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbYKVFQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 00:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYKVFQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 00:16:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbYKVFQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 00:16:38 -0500
Date: Fri, 21 Nov 2008 21:16:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, greg@kroah.com
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in
 Userspace
Message-Id: <20081121211607.49e0ec84.akpm@linux-foundation.org>
In-Reply-To: <1227190983-5820-6-git-send-email-tj@kernel.org>
References: <1227190983-5820-1-git-send-email-tj@kernel.org>
	<1227190983-5820-6-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008 23:23:03 +0900 Tejun Heo <tj@kernel.org> wrote:

> CUSE enables implementing character devices in userspace.  With recent
> additions of nonblock, lseek, ioctl and poll support, FUSE already has
> most of what's necessary to implement character devices.  All CUSE has
> to do is bonding all those components - FUSE, chardev and the driver
> model - nicely.
> 
> Due to the number of different objects involved and many ways an
> instance can fail, object lifetime rules are a tad bit complex.
> Please take a look at the comment on top of fs/fuse/cuse.c for
> details.
> 
> Other than that, it's mostly straight forward.  Client opens
> /dev/cuse, kernel starts conversation with CUSE_INIT.  The client
> tells CUSE which device it wants to create.  CUSE creates the device
> for the client and the rest works the same way as in a direct IO FUSE
> session.
> 
> Each CUSE device has a corresponding directory /sys/class/cuse/DEVNAME
> (which is symlink to /sys/devices/virtual/class/DEVNAME if
> SYSFS_DEPRECATED is turned off) which hosts "waiting" and "abort"
> among other things.  Those two files have the same meaning as the FUSE
> control files.
> 
> The only notable lacking feature compared to in-kernel implementation
> is mmap support.
> 
> ...
>
> +struct cuse_conn {
> +	struct fuse_conn	fc;
> +	struct cdev		cdev;
> +	struct vfsmount		*mnt;
> +	struct device		*dev;
> +
> +	/* init parameters */
> +	bool			unrestricted_ioctl:1;

I'd suggest removal of the :1 here.  If someone later comes along and
adds another bitfield next to it, locking will be needed to prevent
racess accessing the bitfields, and I seeno appropriate lock here, nor
any comment explaining the locking..

> +static int cuse_init_worker(void *data)
> +{
> +	struct cuse_init_in iin = { };
> +	struct cuse_init_out iout = { };
> +	struct cuse_devinfo devinfo = { };

You might want to check the generated code here.  gcc has a habit of
assembling a temp structure on the stack then memcpying it over, which
is just junk.  This will be gcc version dependent.  Fixable by using an
old-fashioned memset instead.

