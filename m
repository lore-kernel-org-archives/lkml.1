Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbYDDUUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbYDDUUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbYDDUUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:20:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55017 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbYDDUUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:20:31 -0400
Date: Fri, 4 Apr 2008 13:20:06 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: debugfs_remove() vs. anything that is dynamic
Message-ID: <20080404202006.GB14016@kroah.com>
References: <1207266986.19189.14.camel@johannes.berg> <20080404153402.GB16923@kroah.com> <1207323684.19189.54.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207323684.19189.54.camel@johannes.berg>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 05:41:24PM +0200, Johannes Berg wrote:
> 
> > If you worry about this type of interaction, use debugfs_create_file,
> > which takes a fileops, and set your module owner in there so that the
> > reference count will not allow your module from being removed.
> >
> > Also remember, you have to be root to unload modules, so if you are
> > doing that, and you have debugfs files open, you should know better :)
> 
> That really was just an example, we have per-wireless-device debugfs
> code users can easily trigger a debugfs_remove() by unplugging a usb
> netdevice for example. Also, that means that anything that is dynamic
> would have the lifetime rules imposed by debugfs which is rather
> awkward.

Then use the debugfs_create_file() function instead of the individual
variable ones if this is the issue.  You can easily wrap them up much
like the debugfs core does with the common wrappers to allow for the
proper module lifetime rules to be followed.

> The current code for simple_attr_open copies the in i_private pointer:
> 
> attr->data = inode->i_private;
> 
> if, instead, it would keep a reference to that, like
> 
> attr->dataptr = &???inode->i_private;
> 
> we could NULL out that pointer on debugfs_remove() and have
> simple_attr_read() just return -ENOENT.

Patches are always gladly accepted :)

> However, if nobody else is concerned about this, I'll just remove all
> the wireless debugfs code instead, I just don't want to allow crashing
> it that way.

I think you should be able to handle this in your debugfs calls, or if
needed, we can easily add a new parameter to them to handle the module
ownership if you are concerned about them.

thanks,

greg k-h
