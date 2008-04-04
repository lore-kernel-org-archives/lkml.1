Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbYDDP21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbYDDP21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYDDP2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:28:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57592 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbYDDP2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:28:20 -0400
Date: Fri, 4 Apr 2008 08:34:02 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: debugfs_remove() vs. anything that is dynamic
Message-ID: <20080404153402.GB16923@kroah.com>
References: <1207266986.19189.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207266986.19189.14.camel@johannes.berg>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 01:56:26AM +0200, Johannes Berg wrote:
> Consider the following trivial module:
> 
> --- %< ---
> #include <linux/module.h>
> #include <linux/debugfs.h>
> 
> static struct dentry *f;
> static u32 tmp;
> 
> int __init mod_enter(void)
> {
> 	f = debugfs_create_u32("tmp-test", 0666, NULL, &tmp);
> 
> 	return 0;
> }
> 
> void __exit mod_leave(void)
> {
> 	debugfs_remove(f);
> }
> 
> module_init(mod_enter);
> module_exit(mod_leave);
> MODULE_LICENSE("GPL");
> --- >% ---
> 
> How do I make that safe?
> 
> 
> FWIW, the problem is:
> 
> thread 1			thread 2
>  fd = open("tmp-test")
> 
>  sleep(30);			rmmod test-module
> 
>  read(fd, buf, 100);
> 
> --> accesses now invalid memory because debugfs doesn't actually stop
> you from accessing "&tmp" after debugfs_remove(). [yes, I actually
> tested a variation of this where I dynamically allocated the 'tmp'
> variable, I got the slab poison in my test program]
> 
> 
> Personally, I tend to think this makes debugfs rather unusable in
> modules and with anything that is dynamically allocated [1]. AFAICT
> sysfs avoids this by having object lifetime imposed by sysfs, but
> debugfs doesn't work that way.
> 
> What am I missing?

If you worry about this type of interaction, use debugfs_create_file,
which takes a fileops, and set your module owner in there so that the
reference count will not allow your module from being removed.

Also remember, you have to be root to unload modules, so if you are
doing that, and you have debugfs files open, you should know better :)

thanks,

greg k-h
