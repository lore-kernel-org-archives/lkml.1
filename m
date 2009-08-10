Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZHJMnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZHJMnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZHJMnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:43:40 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:36343 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbZHJMnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:43:39 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, esandeen@redhat.com, eteo@redhat.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, linux-security-module@vger.kernel.org
Subject: Re: [Patch v3] vfs: allow file truncations when both suid and write permissions set
References: <20090807100743.5822.90612.sendpatchset@localhost.localdomain>
	<1249675025.2694.15.camel@dhcp231-106.rdu.redhat.com>
	<87prb7v0dr.fsf@devron.myhome.or.jp>
	<1249677481.2694.22.camel@dhcp231-106.rdu.redhat.com>
	<1249904964.2422.21.camel@moss-pluto.epoch.ncsc.mil>
Date: Mon, 10 Aug 2009 21:43:32 +0900
In-Reply-To: <1249904964.2422.21.camel@moss-pluto.epoch.ncsc.mil> (Stephen
	Smalley's message of "Mon, 10 Aug 2009 07:49:24 -0400")
Message-ID: <87r5vj2617.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> writes:

>> > > I was thinking about this and kept telling myself I was going to test v2
>> > > before I ack/nak.  Clearly we shouldn't for the dropping of SUID if the
>> > > process didn't have permission to change the ATTR_SIZE.
>> > >
>> > > Acked-by: Eric Paris <eparis@redhat.com>
>> > 
>> > BTW, Do you know why doesn't security modules fix the handling of
>> > do_truncate() (i.e. ATTR_MODE | ATTR_SIZE). And why doesn't it allow to
>> > pass ATTR_FORCE for it?
>> 
>> I'm not sure what you mean.  I understood ATTR_FORCE to mean 'I am magic
>> and get to override all security checks."  Which is why nothing should
>> ever be using ATTR_FORCE with things other than SUID.
>> 
>> I guess we could somehow force logic into the LSM to make it only apply
>> to SUID and friends but I'm not sure it buys us anything.
>
> SELinux shouldn't apply a permission check for the clearing of the suid
> bit on write or truncate.  It should only apply a permission check for
> the actual truncate or write operation, and then the clearing of the
> suid bit should always be forced if that check passed.

Ok. Yes. So, to do it efficiently without problem, I'm suggesting the
following or something (I don't know whether LSM should do this or not).

selinux_inode_setattr(),

	ia_valid = iattr->ia_valid;
	if (!(ia_valid & ATTR_FORCE) && (ia_valid & ATTR_FORCE_MASK)) {
		err = dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
		if (err)
                	return err;
		ia_valid &= ~ATTR_FORCE_MASK;
	}
	if (ia_valid & ATTR_NOT_FORCE_MASK)
	 	err = dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
	return err;

I guess ATTR_FORCE_MASK would be (ATTR_MODE | ATTR_UID | ATTR_GID |
			ATTR_ATIME_SET | ATTR_MTIME_SET) or something,
and ATTR_NOT_FORCE_MASK would be ATTR_SIZE or something.

I'm not sure this is the right code what selinux want to do though, but,
I hope it is clear what I want to say. (I'm assuming FILE__WRITE is for
check of ATTR_SIZE)

With this change, the caller can pass "(ATTR_SIZE | ATTR_MODE)" or
"(ATTR_SIZE | ATTR_MODE | ATTR_FORCE)" etc. for truncate().

[btw, "(ATTR_SIZE | ATTR_MODE)" is what do_truncate() does currently].

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
