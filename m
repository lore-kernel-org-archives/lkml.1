Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZHQLuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZHQLuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbZHQLuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:50:10 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:34296 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbZHQLuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:50:09 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Greg Kroah-Hartman <greg@kroah.com>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
In-Reply-To: <4A860D0F.7020205@schaufler-ca.com>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <4A84EF1D.8060408@schaufler-ca.com>
	 <1250252411.2422.177.camel@moss-pluto.epoch.ncsc.mil>
	 <4A860D0F.7020205@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 17 Aug 2009 07:53:13 -0400
Message-Id: <1250509993.3629.93.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 18:19 -0700, Casey Schaufler wrote:
> Stephen Smalley wrote:
> > On Thu, 2009-08-13 at 21:59 -0700, Casey Schaufler wrote:
> >   
> >> From: Casey Schaufler <casey@schaufler-ca.com>
> >>
> >> This patch is in response to David P. Quigley's proposal from
> >> July of this year. That patch provided special case handling of
> >> LSM xattrs in the security name space.
> >>
> >> This patch provides an in memory representation of general
> >> xattrs. It currently only allows xattrs in the security namespace,
> >> but that is only because the support of ACLs is beyond the
> >> day's needs. The list of xattrs for a given file is created on
> >> demand and a system that does not use xattrs should be pretty
> >> well oblivious to the changes. On the down side, this requires
> >> an unpleasant locking scheme. Improvements would of course be
> >> welcome.
> >>
> >> This scheme should generalize to any memory based file system,
> >> although I have not attempted to create a generic implementation
> >> here.
> >>     
> >
> > I don't understand the benefits of this scheme compared to David's patch
> > - can you explain?
> 
> Sure, you bet. David's scheme requires as LSM and is only capable
> of supporting security namespace attributes. It is further not a
> reasonable model for other memory based filesystems. If all you
> ever want to support is SELinux, it would be fine, but an LSM
> that uses multiple xattrs (Smack only uses multiple xattrs on
> sockets, but it does use them) would be hard pressed to work off
> of a secid. This is a swag at real xattr support, which is the
> right thing to do for any filesystem. Special purpose interfaces
> to solve a single instance of a problem are for squares.

I don't see that one particularly wants full xattr support on sysfs
nodes (or other in-memory filesystems).  Why would one support e.g.
user.* attributes on such nodes?  Why would one support filesystem
capabilities on such nodes (careful - last thing we want is a repeat of
suid bit on proc nodes)?  And if you want ACL support, you'll need code
to actually enforce those ACLs within the filesystem, not just generic
xattr handler code - see the tmpfs code in mm/shmem.c for an example of
ACL support for in-memory filesystems.

> >   It seems worse in terms of locking,
> 
> I'll buy that, and happily incorporate improvements. The
> crude locking is an artifact of keeping memory usage down.

But you don't need any extra locking if you just directly use the
existing memory storage provided by the security module.

> >  memory use,
> 
> There are less than 12,000 entries in /sys on my machine.
> Is that really an issue?
> 
> >  and
> > is no more general than David's patch.
> 
> Except that one could (fix the locking and) port this code to
> other memory based file systems, such as smackfs or selinuxfs
> without much bother. You'd have to implement new LSM hooks for
> each file system you ported the other approach for. It
> can be used without an LSM, it could support multiple security
> xattrs and it can support other namespaces.

The hooks proposed by David would work with other in-memory filesystems
that likewise need to save the attribute in a backing data structure -
only the particular backing data structure and placement of the hooks
would be specific to the filesystem, and that is unavoidable.

For in-memory filesystems that pin the inodes, we already have all the
support we require by virtue of the existing vfs fallbacks.

-- 
Stephen Smalley
National Security Agency

