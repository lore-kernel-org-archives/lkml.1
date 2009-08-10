Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZHJMzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZHJMzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZHJMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:55:04 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:41034 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZHJMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:55:03 -0400
Subject: Re: [Patch v3] vfs: allow file truncations when both suid and
 write permissions set
From: Stephen Smalley <sds@tycho.nsa.gov>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Eric Paris <eparis@redhat.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, esandeen@redhat.com, eteo@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org
In-Reply-To: <87r5vj2617.fsf@devron.myhome.or.jp>
References: <20090807100743.5822.90612.sendpatchset@localhost.localdomain>
	 <1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com>
	 <87prb7v0dr.fsf@devron.myhome.or.jp>
	 <1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com>
	 <1249904964.2422.21.camel@moss-pluto.epoch.ncsc.mil>
	 <87r5vj2617.fsf@devron.myhome.or.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 10 Aug 2009 08:57:11 -0400
Message-Id: <1249909031.2422.37.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 21:43 +0900, OGAWA Hirofumi wrote:
> Stephen Smalley <sds@tycho.nsa.gov> writes:
> 
> >> > > I was thinking about this and kept telling myself I was going to test v2
> >> > > before I ack/nak.  Clearly we shouldn't for the dropping of SUID if the
> >> > > process didn't have permission to change the ATTR_SIZE.
> >> > >
> >> > > Acked-by: Eric Paris <eparis@redhat.com>
> >> > 
> >> > BTW, Do you know why doesn't security modules fix the handling of
> >> > do_truncate() (i.e. ATTR_MODE | ATTR_SIZE). And why doesn't it allow to
> >> > pass ATTR_FORCE for it?
> >> 
> >> I'm not sure what you mean.  I understood ATTR_FORCE to mean 'I am magic
> >> and get to override all security checks."  Which is why nothing should
> >> ever be using ATTR_FORCE with things other than SUID.
> >> 
> >> I guess we could somehow force logic into the LSM to make it only apply
> >> to SUID and friends but I'm not sure it buys us anything.
> >
> > SELinux shouldn't apply a permission check for the clearing of the suid
> > bit on write or truncate.  It should only apply a permission check for
> > the actual truncate or write operation, and then the clearing of the
> > suid bit should always be forced if that check passed.
> 
> Ok. Yes. So, to do it efficiently without problem, I'm suggesting the
> following or something (I don't know whether LSM should do this or not).
> 
> selinux_inode_setattr(),
> 
> 	ia_valid = iattr->ia_valid;
> 	if (!(ia_valid & ATTR_FORCE) && (ia_valid & ATTR_FORCE_MASK)) {
> 		err = dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
> 		if (err)
>                 	return err;
> 		ia_valid &= ~ATTR_FORCE_MASK;
> 	}
> 	if (ia_valid & ATTR_NOT_FORCE_MASK)
> 	 	err = dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
> 	return err;
> 
> I guess ATTR_FORCE_MASK would be (ATTR_MODE | ATTR_UID | ATTR_GID |
> 			ATTR_ATIME_SET | ATTR_MTIME_SET) or something,
> and ATTR_NOT_FORCE_MASK would be ATTR_SIZE or something.
> 
> I'm not sure this is the right code what selinux want to do though, but,
> I hope it is clear what I want to say. (I'm assuming FILE__WRITE is for
> check of ATTR_SIZE)

The logic is supposed to map certain attribute changes (mode, owner,
group, explicit setting of atime or mtime to a specific value rather
than the current time) to the SELinux setattr permission, while mapping
other attribute changes that occur naturally on a write (size, setting
of mtime to current time) to the SELinux write permission.  That doesn't
seem clear from using ATTR_FORCE_MASK vs ATTR_NOT_FORCE_MASK above - I'd
use different naming conventions for clarity.

> 
> With this change, the caller can pass "(ATTR_SIZE | ATTR_MODE)" or
> "(ATTR_SIZE | ATTR_MODE | ATTR_FORCE)" etc. for truncate().
> 
> [btw, "(ATTR_SIZE | ATTR_MODE)" is what do_truncate() does currently].

That was a change in do_truncate(), commit
7b82dc0e64e93f430182f36b46b79fcee87d3532.

It makes sense, but no one ever updated selinux_inode_setattr() to match
that change.

-- 
Stephen Smalley
National Security Agency

