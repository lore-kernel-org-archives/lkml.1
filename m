Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323Ab0AVE27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab0AVE27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995Ab0AVE26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:28:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab0AVE26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:28:58 -0500
Date: Thu, 21 Jan 2010 20:19:13 -0800
From: Greg KH <gregkh@suse.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: sysfs_chmod_file() broken in 2.6.33-rc4-git6
Message-ID: <20100122041913.GC4302@suse.de>
References: <20100120131602.12aa48f7@hyperion.delvare> <m1ocko6fkx.fsf@fess.ebiederm.org> <20100120160008.7d59688b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120160008.7d59688b@hyperion.delvare>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 04:00:08PM +0100, Jean Delvare wrote:
> On Wed, 20 Jan 2010 06:01:02 -0800, Eric W. Biederman wrote:
> > Jean Delvare <khali@linux-fr.org> writes:
> > 
> > > Hi Eric, Greg,
> > >
> > > While working on a driver using 2.6.33-rc4-git6 as my environment, I
> > > have found that sysfs_chmod_file() called from a kernel driver no
> > > longer works. It doesn't return any error nor print any message in the
> > > logs, it simply has no effect. The same code worked fine using kernel
> > > 2.6.32. I have bisected it down to the following commit:
> > >
> > > commit e61ab4ae48fbf477f5b9fcbec9e1b8dc789920d0
> > > Author: Eric W. Biederman <ebiederm@xmission.com>
> > > Date:   Fri Nov 20 16:08:53 2009 -0800
> > >
> > >     sysfs: Implement sysfs_getattr & sysfs_permission
> > >     
> > >     With the implementation of sysfs_getattr and sysfs_permission
> > >     sysfs becomes able to lazily propogate inode attribute changes
> > >     from the sysfs_dirents to the vfs inodes.   This paves the way
> > >     for deleting significant chunks of now unnecessary code.
> > >     
> > >     While doing this we did not reference sysfs_setattr from
> > >     sysfs_symlink_inode_operations so I added along with
> > >     sysfs_getattr and sysfs_permission.
> > >     
> > >     Acked-by: Tejun Heo <tj@kernel.org>
> > >     Acked-by: Serge Hallyn <serue@us.ibm.com>
> > >     Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> > >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > >
> > > Eric, can you please look at your code again and see if you can find
> > > any obvious issue?
> > 
> > Does this fix your issue?
> > 
> > Eric
> > 
> > 
> > diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> > index 220b758..6a06a1d 100644
> > --- a/fs/sysfs/inode.c
> > +++ b/fs/sysfs/inode.c
> > @@ -81,24 +81,23 @@ int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
> >  		if (!sd_attrs)
> >  			return -ENOMEM;
> >  		sd->s_iattr = sd_attrs;
> > -	} else {
> > -		/* attributes were changed at least once in past */
> > -		iattrs = &sd_attrs->ia_iattr;
> > -
> > -		if (ia_valid & ATTR_UID)
> > -			iattrs->ia_uid = iattr->ia_uid;
> > -		if (ia_valid & ATTR_GID)
> > -			iattrs->ia_gid = iattr->ia_gid;
> > -		if (ia_valid & ATTR_ATIME)
> > -			iattrs->ia_atime = iattr->ia_atime;
> > -		if (ia_valid & ATTR_MTIME)
> > -			iattrs->ia_mtime = iattr->ia_mtime;
> > -		if (ia_valid & ATTR_CTIME)
> > -			iattrs->ia_ctime = iattr->ia_ctime;
> > -		if (ia_valid & ATTR_MODE) {
> > -			umode_t mode = iattr->ia_mode;
> > -			iattrs->ia_mode = sd->s_mode = mode;
> > -		}
> > +	}
> > +	/* attributes were changed at least once in past */
> > +	iattrs = &sd_attrs->ia_iattr;
> > +
> > +	if (ia_valid & ATTR_UID)
> > +		iattrs->ia_uid = iattr->ia_uid;
> > +	if (ia_valid & ATTR_GID)
> > +		iattrs->ia_gid = iattr->ia_gid;
> > +	if (ia_valid & ATTR_ATIME)
> > +		iattrs->ia_atime = iattr->ia_atime;
> > +	if (ia_valid & ATTR_MTIME)
> > +		iattrs->ia_mtime = iattr->ia_mtime;
> > +	if (ia_valid & ATTR_CTIME)
> > +		iattrs->ia_ctime = iattr->ia_ctime;
> > +	if (ia_valid & ATTR_MODE) {
> > +		umode_t mode = iattr->ia_mode;
> > +		iattrs->ia_mode = sd->s_mode = mode;
> >  	}
> >  	return 0;
> >  }
> 
> Yes, this fixes my problem. Thanks for the fast fix!

Great, Eric, care to resend this so that I can submit it for inclusion?

thanks,

greg k-h
