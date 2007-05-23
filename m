Return-Path: <linux-kernel-owner+w=401wt.eu-S1760824AbXEWTGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760824AbXEWTGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXEWTG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:06:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:33768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXEWTG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:06:27 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Wed, 23 May 2007 21:06:28 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de> <20070412101236.GD4095@ftp.linux.org.uk>
In-Reply-To: <20070412101236.GD4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3563
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705232106.28260.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 12:12, Al Viro wrote:
> On Thu, Apr 12, 2007 at 02:08:10AM -0700, jjohansen@suse.de wrote:
> > This is needed for computing pathnames in the AppArmor LSM.
>
> Which is an argument against said LSM in current form.

The fundamental model of AppArmor is to perform access checks based on the 
location of a file in the filesystem namespace, i.e., the pathname, and this 
can only be done with both the dentry and vfsmount. My understanding was that 
there was agreement at the last kernel summit that pathname based approaches 
should be allowed.

> > -	error = security_inode_create(dir, dentry, mode);
> > +	error = security_inode_create(dir, dentry, nd ? nd->mnt : NULL, mode);
>
> is a clear sign that interface is wrong.

No. There are callers of vfs_create() that use a NULL nameidata, and that's 
what causes the problem here. Struct nameidata is pretty big, and so we don't 
want to allocate temporary nameidata objects all over the place. So to me the 
above NULL check seems the lesser evil.

One way to deal with the nameidata size problem is to split it up into one 
part for the real path lookups, and a much smaller part that only contains 
the dentry, vfsmount, and intent flags. This would allow to pass around the 
smaller nameidata much more consistently.

John has posted patches for that on May 14; subject [RFD Patch 0/4]. Feedback 
appreciated.

In several places, the NULL nameidata is wrong because we can't check the 
vfsmount flags or intent. Not having this information is causing problems for 
nfs too for example -- it's not an AppArmor specific problem.

> Leaving aside the general idiocy of "we prohibit to do something with file
> if mounted here, but if there's another mountpoint, well, we just miss", an
> API of that kind is just plain wrong.  Either you can live without seeing
> vfsmount in that method (in which case you shouldn't pass it at all), or you
> have a hole.

This is backwards from what AppArmor does. The policy defines which paths may 
be accessed; all paths not explicitly listed are denied. If files are mounted 
at multiple locations, then the policy may allow access to some locations but 
not to others. That's not a hole.

In fact this is not much different from traditional permissions on parent 
directories: even if the same files are mounted at several locations, parent 
directory permissions may allow accessing only some of those locations.

Thanks,
Andreas
