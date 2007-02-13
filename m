Return-Path: <linux-kernel-owner+w=401wt.eu-S1751095AbXBMViw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095AbXBMViw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 16:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbXBMViw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 16:38:52 -0500
Received: from ns1.suse.de ([195.135.220.2]:46931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbXBMViw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 16:38:52 -0500
Date: Tue, 13 Feb 2007 13:37:37 -0800
From: Greg KH <greg@kroah.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: torvalds@linux-foundation.org, neilb@suse.de, viro@zeniv.linux.org.uk,
       hch@lst.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
Message-ID: <20070213213737.GA14383@kroah.com>
References: <20070213195116.GA5181@kroah.com> <200702131158.02809.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702131158.02809.agruen@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:58:02AM -0800, Andreas Gruenbacher wrote:
> > I'm running pretty new GNOME and dbus here:
> > 	dbus 1.0.2
> > 	gnome 2.16.2
> > 	hal 0.5.7.1
> > 	nautilus 2.16.3
> >
> > Any ideas of things I can test?
> 
> Sorry for the breakage. Printk of the __d_path result may tell:
> 
> Index: b/fs/dcache.c
> ===================================================================
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1803,6 +1803,8 @@ char *__d_path(struct dentry *dentry, st
> 
>  out:
>         spin_unlock(&dcache_lock);
> +	printk(KERN_DEBUG "%s(%d): %s\n", current->comm, current->pid,
> +	       IS_ERR(buffer) ? "failed" : buffer);
> 	return buffer;
> 

This causes the following to just loop over and over, incrementing the
pid:

gnome-vfs-daemo(8914): 
gnome-vfs-daemo(8914): /
gnome-vfs-daemo(8914): /proc
gnome-vfs-daemo(8914): /sys
gnome-vfs-daemo(8914): /dev
gnome-vfs-daemo(8914): /dev/pts
gnome-vfs-daemo(8914): /dev/shm
gnome-vfs-daemo(8914): /proc/bus/usb
gnome-vfs-daemo(8914): /proc/sys/fs/binfmt_misc
gnome-vfs-daemo(8918): 
gnome-vfs-daemo(8918): /
gnome-vfs-daemo(8918): /proc
gnome-vfs-daemo(8918): /sys
gnome-vfs-daemo(8918): /dev
gnome-vfs-daemo(8918): /dev/pts
gnome-vfs-daemo(8918): /dev/shm
gnome-vfs-daemo(8918): /proc/bus/usb
gnome-vfs-daemo(8918): /proc/sys/fs/binfmt_misc

and so on...

I'm running gnome-vfs version 2.6.13 if that matters.

Anything else I can try?

thanks,

greg k-h
