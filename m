Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZBLDJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZBLDJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZBLDJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:09:44 -0500
Received: from ns2.suse.de ([195.135.220.15]:53260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbZBLDJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:09:43 -0500
Date: Wed, 11 Feb 2009 19:02:27 -0800
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: sysfs_add_one tells you _where_ the duplicate
	file is
Message-ID: <20090212030227.GA4859@suse.de>
References: <20090211202601.GC3402@ldl.fc.hp.com> <20090211223903.GA21100@suse.de> <20090212025655.GA6916@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212025655.GA6916@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 07:56:55PM -0700, Alex Chiang wrote:
> * Greg KH <gregkh@suse.de>:
> > On Wed, Feb 11, 2009 at 01:26:01PM -0700, Alex Chiang wrote:
> > > Give a better clue about where we might be creating duplicate
> > > files by displaying the parent's name as well.
> > > 
> > > Signed-off-by: Alex Chiang <achiang@hp.com>
> > > ---
> > > It would be nice to get a full path, but simply printing out the
> > > parent is cheap and more useful than what we have now.
> > 
> > What happens if you don't have a parent?  will this oops if you are
> > creating a duplicate device in the root of the sysfs tree?
> 
> We won't oops because if you attempt to create a device in the
> root of the sysfs tree with a NULL parent, then we say that your
> parent is sysfs_root:
> 
> int sysfs_create_dir(struct kobject * kobj)
> {
> 	...
>         if (kobj->parent)
> 		parent_sd = kobj->parent->sd;
> 	else
> 		parent_sd = &sysfs_root;
> 	...
> 
> But I do notice that we're not giving sysfs_root a name, so if
> you do hit the WARN for a duplicate entry in sysfs_root, you get
> a blank string for the location of the duplicate.
> 
> How about this instead?
> 
> From: Alex Chiang <achiang@hp.com>
> 
> sysfs: give sysfs_root a proper name; display parent in duplicate entry WARN
> 
> Name sysfs_root "/".
> 
> Make sysfs_add_one tell you _where_ you're attempting to create a
> duplicate file to help debug.
> 
> Giving sysfs_root a proper name covers the case when trying to
> create multiple entries with the same name in the root of the
> sysfs tree.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> Still would be nicer to get a full path.

It would, and you _almost_ might be able to get it, but it might take
some work.  We do store the last sysfs file accessed, and can compute
the path of that as we have a struct file * to play with.  You could
walk the tree of devices backwards to reconstruct the full path to
emulate this if you want to.

> I think that in the context of a sysfs WARN, claiming that you're
> trying to create a duplicate file in "/" really means "/sys" and
> shouldn't be confusing. Sample output:

While you and I mount sysfs at /sys/ and it is the "expected" place for
it to be, we shouldn't just assume that is where it is in the
filesystem, especially as I don't where the container people are placing
sysfs.

> sysfs: duplicate filename 'alex' can not be created in /
> 
> This maybe wants to be 2 patches, and I can split it up that way
> if you prefer.

Sure, that would probably be best.

thanks,

greg k-h
