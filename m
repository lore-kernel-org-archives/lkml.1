Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbZCRQrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbZCRQrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbZCRQrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:47:18 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60722 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958AbZCRQrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:47:16 -0400
Date: Wed, 18 Mar 2009 11:47:12 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Igor Zhbanov <izh1979@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       SELinux <selinux@tycho.nsa.gov>
Subject: Re: =?utf-8?B?0J7RgtCy0LXRgjogVkZTLCBORlMg?=
	=?utf-8?Q?security_bug=3F_Shoul?=
	=?utf-8?Q?d?= CAP_MKNOD and CAP_LINUX_IMMUTABLE be added to
	CAP_FS_MASK?
Message-ID: <20090318164712.GB27906@us.ibm.com>
References: <20090313190002.GA16025@us.ibm.com> <1237227705.1035.93.camel@localhost.localdomain> <20090316184926.GA6729@us.ibm.com> <1237237216.1035.195.camel@localhost.localdomain> <20090316231340.GC15522@us.ibm.com> <1237299633.6582.107.camel@localhost.localdomain> <20090317173903.GA31566@us.ibm.com> <1237312345.6582.140.camel@localhost.localdomain> <20090317182335.GB31633@us.ibm.com> <1237393287.12822.50.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237393287.12822.50.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Tue, 2009-03-17 at 13:23 -0500, Serge E. Hallyn wrote:
> > But in cap_inode_setxattr, any security.* xattrs are controlled by
> > CAP_SYS_ADMIN.  So do you think that this should be changed to a
> > CAP_XATTR_SECURITY capability which can be added to CAP_FS_MASK?
> 
> I think that would be preferable to CAP_SYS_ADMIN, yes.
> 
> > Or do you think it's ok that fsuid=0 does not allow you to set
> > security.selinux (or security.SMACK64, etc) xattrs when selinux is
> > not compiled in?
> 
> Just to be clear, at present fsuid is irrelevant to setting the
> security.* xattrs since it doesn't affect the CAP_SYS_ADMIN capability
> at all, so it all depends on the initial capability state prior to using
> setfsuid(), typically the full capability set.

Right.

> > (You may have already answered this with your EOPNOTSUPP comment, but
> > I want to make sure I understand right)
> > 
> > > > Does anyone know what the trusted xattrs are used for?
> > > 
> > > Not beyond what attr(5) says about them.
> > 
> > Well, if attr(5) says CAP_SYS_ADMIN being needed is the very
> > thing that defines these xattrs, then changing that seems a
> > bigger deal.  That really does seem akin to changing kernel-user
> > API.
> 
> Perhaps, although it isn't clear that this API is in use by anyone or in
> use in a way that would actually distinguish based on individual
> capability.
> 
> But if you were to add CAP_SYS_ADMIN to CAP_FS_MASK in order to ensure
> that setfsuid() does in fact affect all filesystem accesses, how much
> meaningful difference remains between fsuid==0 and euid==0?  It
> obviously takes you far afield of only affecting filesystem accesses.

Ok, thanks for time.  It's all pretty clear to me now:

CAP_MKNOD and CAP_LINUX_IMMUTABLE need to be added to the CAP_FS_MASK
because, in 2.0 timeframe, fsuid==0 gave you those privileges.

xattrs didn't exist back then, so the setting of security.* and
trusted.* xattrs doesn't need to be enabled by fsuid==0.  So really
CAP_SETFCAP also doesn't need to be added to CAP_FS_MASK either.

I'll send out a patch later today for 2.6, unless Igor wants to
do it (since he's the one who found this originally).

thanks,
-serge
