Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZCQO2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZCQO2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 10:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZCQO2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 10:28:13 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:57501 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZCQO2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:28:12 -0400
Subject: Re: =?UTF-8?Q?=D0=9E=D1=82=D0=B2=D0=B5=D1=82=3A?= VFS, NFS
 security bug? Should CAP_MKNOD and CAP_LINUX_IMMUTABLE be added to
 CAP_FS_MASK?
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Igor Zhbanov <izh1979@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       SELinux <selinux@tycho.nsa.gov>
In-Reply-To: <20090316231340.GC15522@us.ibm.com>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	 <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com>
	 <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
	 <20090313175848.GB27891@fieldses.org>
	 <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com>
	 <20090313190002.GA16025@us.ibm.com>
	 <1237227705.1035.93.camel@localhost.localdomain>
	 <20090316184926.GA6729@us.ibm.com>
	 <1237237216.1035.195.camel@localhost.localdomain>
	 <20090316231340.GC15522@us.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 17 Mar 2009 10:20:33 -0400
Message-Id: <1237299633.6582.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 18:13 -0500, Serge E. Hallyn wrote:
> Quoting Stephen Smalley (sds@tycho.nsa.gov):
> > On Mon, 2009-03-16 at 13:49 -0500, Serge E. Hallyn wrote:
> > > Quoting Stephen Smalley (sds@tycho.nsa.gov):
> > > > On Fri, 2009-03-13 at 14:00 -0500, Serge E. Hallyn wrote:
> > > > > Quoting Igor Zhbanov (izh1979@gmail.com):
> > > > > > But ordinary users can't create devices. It seems to me that in time
> > > > > > of implementation of capabilities in kernel 2.4, capabilities related
> > > > > > to filesystem was added first. And mark for them contains all above in
> > > > > > header file. And when CAP_MKNOD was added later, author just forget to
> > > > > > update mask.
> > > > > > 
> > > > > > If mask was designed to drop all filesystem related capabilities, then
> > > > > > it must be expanded, because ordinary users cannot create devices etc.
> > > > > 
> > > > > I think you thought Bruce was saying we shouldn't change the set of
> > > > > capabilities, but he was just asking exactly what changes Michael was
> > > > > interested in.
> > > > > 
> > > > > Igor, thanks for finding this.  I never got your original message.  Do
> > > > > you have a patdch to add the two capabilities?  Do you think the
> > > > > other two I mentioned (CAP_SYS_ADMIN and CAP_SETFCAP) need to be
> > > > > added too?
> > > > > 
> > > > > I've added Andrew Morgan, LSM and SELinux mailing lists to get another
> > > > > opinion about adding those two.  In particular, we'd be adding them
> > > > > to the fs_masks becuase CAP_SYS_ADMIN lets you change the selinux
> > > > > label, and CAP_SETFCAP lets you change the file capabilities.
> > > > 
> > > > I'd be inclined against adding CAP_SYS_ADMIN to the mask; note that it
> > > > is only checked for setting SELinux security contexts (or more broadly
> > > > any attributes in the security namespace) when SELinux is disabled.  In
> > > > the SELinux-enabled case, we are checking SELinux-specific permissions
> > > > when setting the SELinux attributes, whether on the client or the
> > > > server.
> > > 
> > > But that's exactly why it seemed like it ought to be in there.  If
> > > SELinux is enabled, then SELinux will continue to perform it's own
> > > checks based on security context and ignoring privileged root.  But
> > > outside of that, since we are in a root-is-privileged mode, should it
> > > not be the case that having fsuid=0 means that you can set extended
> > > attributes in the security namespace?
> > > 
> > > Conversely, if setting fsuid to non-zero, shouldn't all of the
> > > privileged ways of setting file attributes be lost?  Or, will we run
> > > into a problem where software wanted to set its fsuid to non-0 but
> > > still be able to call sethostname(2), for instance?  In which case
> > > we simply cannot put CAP_SYS_ADMIN in CAP_FS_MASK.
> > > 
> > > I guess it comes back down to whether those xattrs are considered a
> > > security attribute or a simple file property.
> > 
> > Well, they are a security attribute, but CAP_SYS_ADMIN was never
> > supposed to cover them.  In fact, none of the upstream security modules
> 
> So do you think it makes sense to have CAP_MAC_ADMIN and CAP_FOWNER
> in CAP_FS_MASK?  In other words are you objecting to CAP_SYS_ADMIN
> because of all of its other implications, or because you disagree
> that labels for security modules should be treated as mere fs data
> here?

For CAP_FOWNER, yes (and it is already there).  CAP_MAC_ADMIN is less
ideal as it isn't clearly tied to filesystem accesses, and likewise for
CAP_MAC_OVERRIDE (but that one is included in CAP_FS_MASK already).
Ideally the capability space would be partitioned into capabilities that
affect filesystem accesses and the rest so that setfsuid() would yield
the expected behavior of only affecting filesystem access.
CAP_SYS_ADMIN is even less suitable due to its pervasive use outside of
the filesystem.  So that's the first concern.

The second one is that we don't want CAP_SYS_ADMIN (or CAP_MAC_ADMIN) to
be required when setting SELinux labels.  Only the SELinux permission
checks should govern setting those labels (aside from the usual DAC
ownership || CAP_FOWNER check).

> > uses CAP_SYS_ADMIN to control setting of its own attributes:
> > - SELinux applies a DAC check and its own set of MAC file permission
> > checks,
> > - Smack applies CAP_MAC_ADMIN,
> > - Capabilities applies CAP_SETFCAP.
> > 
> > Checking CAP_SYS_ADMIN was really just a fallback to prevent unchecked
> > setting of attributes in the no-LSM case.  It might make more sense to
> > return EOPNOTSUPP for any attributes unknown to the enabled security
> 
> I suspect that would create a LOT of bug reports.  Would requiring
> CAP_MAC_ADMIN seem reasonable?

It would narrow the scope a bit more, but it still isn't ideal.

> > module and require you to enable the desired module before setting the
> > attributes these days.
> > http://marc.info/?t=107428809400002&r=1&w=2
> > 
> > I don't think this will make any difference for labeled NFS at present,
> > as the current labeled NFS patches only export the MAC label attribute
> > if the server has the MAC model enabled.  So CAP_SYS_ADMIN won't get
> > checked regardless.
> > 
> > Trusted namespace is another case where CAP_SYS_ADMIN check is applied
> > on file operations.
> 
> Which seems like all the more reason why CAP_SYS_ADMIN would need to
> be added to the CAP_FS_MASK.  Or do you mean that check should also be
> changed for something else?  (CAP_MAC_ADMIN, or some new CAP_FS_XATTR?)

I'd favor changing it to a new capability.  We have CAP_SETFCAP for
setting file capabilities; why not have CAP_SETTRUSTED for setting
attributes in the trusted namespace?  Then adding it to CAP_FS_MASK has
no further side effects beyond controlling filesystem accesses.

-- 
Stephen Smalley
National Security Agency

