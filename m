Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbZCQSAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbZCQSAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZCQSAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:00:06 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:50124 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZCQSAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:00:05 -0400
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
In-Reply-To: <20090317173903.GA31566@us.ibm.com>
References: <20090312161047.GA15209@us.ibm.com>
	 <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
	 <20090313175848.GB27891@fieldses.org>
	 <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com>
	 <20090313190002.GA16025@us.ibm.com>
	 <1237227705.1035.93.camel@localhost.localdomain>
	 <20090316184926.GA6729@us.ibm.com>
	 <1237237216.1035.195.camel@localhost.localdomain>
	 <20090316231340.GC15522@us.ibm.com>
	 <1237299633.6582.107.camel@localhost.localdomain>
	 <20090317173903.GA31566@us.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 17 Mar 2009 13:52:25 -0400
Message-Id: <1237312345.6582.140.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 12:39 -0500, Serge E. Hallyn wrote:
> Quoting Stephen Smalley (sds@tycho.nsa.gov):
> > > So do you think it makes sense to have CAP_MAC_ADMIN and CAP_FOWNER
> > > in CAP_FS_MASK?  In other words are you objecting to CAP_SYS_ADMIN
> > > because of all of its other implications, or because you disagree
> > > that labels for security modules should be treated as mere fs data
> > > here?
> > 
> > For CAP_FOWNER, yes (and it is already there).  CAP_MAC_ADMIN is less
> 
> Sorry, I meant CAP_SETFCAP.  Should it be added?

Sure - it is only used for filesystem operations.

> > ideal as it isn't clearly tied to filesystem accesses, and likewise for
> > CAP_MAC_OVERRIDE (but that one is included in CAP_FS_MASK already).
> 
> So it is.  I didn't realize that.
> 
> > Ideally the capability space would be partitioned into capabilities that
> > affect filesystem accesses and the rest so that setfsuid() would yield
> > the expected behavior of only affecting filesystem access.
> > CAP_SYS_ADMIN is even less suitable due to its pervasive use outside of
> > the filesystem.  So that's the first concern.
> > 
> > The second one is that we don't want CAP_SYS_ADMIN (or CAP_MAC_ADMIN) to
> > be required when setting SELinux labels.  Only the SELinux permission
> > checks should govern setting those labels (aside from the usual DAC
> > ownership || CAP_FOWNER check).
> 
> So if a non-selinux kernel is booted, then you think only the usual
> DAC checks should be required to set selinux labels?

I'm talking about the dumb NFS server case (non-SELinux NFS server
providing label and data storage to SELinux clients, MAC enforcement
handled client-side).  But we aren't there yet, so I don't think we have
to worry about it right now.

> Or is this assuming EOPNOTSUPP were returned for setting
> security.selinux xattrs in such a kernel?
>
> > > > uses CAP_SYS_ADMIN to control setting of its own attributes:
> > > > - SELinux applies a DAC check and its own set of MAC file permission
> > > > checks,
> > > > - Smack applies CAP_MAC_ADMIN,
> > > > - Capabilities applies CAP_SETFCAP.
> > > > 
> > > > Checking CAP_SYS_ADMIN was really just a fallback to prevent unchecked
> > > > setting of attributes in the no-LSM case.  It might make more sense to
> > > > return EOPNOTSUPP for any attributes unknown to the enabled security
> > > 
> > > I suspect that would create a LOT of bug reports.  Would requiring
> > > CAP_MAC_ADMIN seem reasonable?
> > 
> > It would narrow the scope a bit more, but it still isn't ideal.
> > 
> > > > module and require you to enable the desired module before setting the
> > > > attributes these days.
> > > > http://marc.info/?t=107428809400002&r=1&w=2
> > > > 
> > > > I don't think this will make any difference for labeled NFS at present,
> > > > as the current labeled NFS patches only export the MAC label attribute
> > > > if the server has the MAC model enabled.  So CAP_SYS_ADMIN won't get
> > > > checked regardless.
> > > > 
> > > > Trusted namespace is another case where CAP_SYS_ADMIN check is applied
> > > > on file operations.
> > > 
> > > Which seems like all the more reason why CAP_SYS_ADMIN would need to
> > > be added to the CAP_FS_MASK.  Or do you mean that check should also be
> > > changed for something else?  (CAP_MAC_ADMIN, or some new CAP_FS_XATTR?)
> > 
> > I'd favor changing it to a new capability.  We have CAP_SETFCAP for
> > setting file capabilities; why not have CAP_SETTRUSTED for setting
> > attributes in the trusted namespace?  Then adding it to CAP_FS_MASK has
> > no further side effects beyond controlling filesystem accesses.
> 
> Does anyone know what the trusted xattrs are used for?

Not beyond what attr(5) says about them.

-- 
Stephen Smalley
National Security Agency

