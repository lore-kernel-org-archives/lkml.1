Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYDCMkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYDCMkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 08:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYDCMjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 08:39:52 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:58794 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbYDCMjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:39:51 -0400
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>
In-Reply-To: <20080402205450.GO9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu>
	 <20080402201321.062856131@szeredi.hu>
	 <20080402205450.GO9785@ZenIV.linux.org.uk>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 03 Apr 2008 08:33:31 -0400
Message-Id: <1207226011.27710.142.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 21:54 +0100, Al Viro wrote:
> On Wed, Apr 02, 2008 at 10:12:48PM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > R/o bind mounts require operations which modify the filesystem to be
> > wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
> > this, so callers won't need to bother, and more importantly, cannot
> > forget!  Call these path_*, analogous to vfs_*.  Where there are no
> > callers of vfs_* left, make them static.
> >
> > This series is a cleanup, as well as fixing several places (mostly in
> > nfsd) where mnt_{want,drop}_write() were missing.
> > 
> > It will also help with merging You Know What(*) security module, which
> > needs to know the path within the namespace, and not just within the
> > filesystem.  These helpers will allow the security hooks to be in a
> > common place, and need not be repeated in all callers.
> 
> Rot.
> 
> Places in nfsd must be fixed, LSM hooks *moved* *to* *callers*.

Please don't move the existing security_inode hooks - they are at
exactly the right location for SELinux and likely other security modules
too - after the DAC checks (so no noise in the audit logs from accesses
that would be denied by DAC anyway), and right before the inode method
is invoked (so easy to see that the permission check is always invoked
before access).  Moving the existing hooks will break the first property
unless the DAC checks are also moved and will make it harder to check
and maintain the second property.

>   And
> really, by that point I absolutely do not give a damn for these clowns.
> "Help with merging" implies that they can't be arsed to do _anything_
> with their code.  Just as they could not be arsed to react to any
> comments (including civil ones) in any manner except "wait for a month
> and repost without changes".  Sod them.
> 
> And no, "make static where all (two of) current callers have vfsmount"
> is non-starter.  path_...() is (at most) a convenience helper, not a
> fundamental interface - simply because new callers should not be
> forced into inventing a fake vfsmount just to use that.
> 
> I'll look into missing mnt_..._write() in nfsd and fix that.  The rest...
> Sorry.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Stephen Smalley
National Security Agency

