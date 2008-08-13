Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbYHMOSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbYHMOSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbYHMORu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:17:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbYHMORt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:17:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <e7d8f83e0808130344x29fcb9aja00ce3f64a95ef7b@mail.gmail.com>
References: <e7d8f83e0808130344x29fcb9aja00ce3f64a95ef7b@mail.gmail.com> <20080808184349.999902616@linux.vnet.ibm.com> <1218221761.4444.13.camel@localhost.localdomain> <20080809185340.GC22905@infradead.org> <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com> <20080811170255.GA2662@us.ibm.com> <OFAC0E3107.C68382CD-ON852574A2.0068E1AD-852574A2.00692623@us.ibm.com> <20080811195645.GA16685@us.ibm.com> <e7d8f83e0808120141s4a0561fdw4919ce6f74d211af@mail.gmail.com> <20080812192925.GC18034@infradead.org> 
To: "Peter Dolding" <oiaohm@gmail.com>
Cc: dhowells@redhat.com, "Christoph Hellwig" <hch@infradead.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, "Mimi Zohar" <zohar@us.ibm.com>,
       serue@linux.vnet.ibm.com, "James Morris" <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Randy Dunlap" <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, "Stephen Smalley" <sds@tycho.nsa.gov>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mimi Zohar" <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Wed, 13 Aug 2008 15:11:53 +0100
Message-ID: <20485.1218636713@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Dolding <oiaohm@gmail.com> wrote:

> Credentials patch for Linux allows more than the BSD one does.  Linux one is
> a complete permission storage replacement.

No, it isn't.  It replaces the permission storage facility of a process but
does not change the way in which an inode caches its credentials in RAM.

> http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-08/msg02682.html
> 
> Note the file credentials one.

I said "Open file credentials".  I was referring to struct file which
designates an open file handle, not the file/inode itself.  What this means is
that the open file handle takes a reference to the subjective security context
of the process that opened it, at the time it opened it, so that accesses to
that file are (with exceptions) done with those credentials, no matter who is
actually using the handle.

For disk filesystems, for the most part, this makes no difference: an open file
is usable by anyone who has the handle.  However, for network filesystems,
where each request is marked with the details of who the request should be
accounted to and the server decides, it does matter.

> That is reused by FS Cache and it creates fake inodes.

FS-Cache+CacheFiles doesn't create fake inodes at all.  It creates real inodes
on disk in the cache.  The reason for these patches is that CacheFiles needs to
use its own subjective security context when creating or accessing these
inodes, rather than the subjective context of whoever invoked AFS or NFS, and
thus caused CacheFiles to touch the cache.

> "vfs_permission and file_permission are just small wrappers around
> inode_permission."  No longer both go to inote_permission after the
> credentials patch is in.   file_permission instead goes to credentials
> struct connected to the inode.  Most calls to inode_permission end up
> wrapped to the credentials struct.

I don't understand what you're talking about.  Looking in fs/namei.c, I see:

	int vfs_permission(struct nameidata *nd, int mask)
	{
		return inode_permission(nd->path.dentry->d_inode, mask);
	}

And:

	int file_permission(struct file *file, int mask)
	{
		return inode_permission(file->f_path.dentry->d_inode, mask);
	}

That looks like they still both go to inode_permission().

> Basically by the way Linux Credentials patch is being done.
> inode_permission could completely cease to exist.    Completely
> replaced by the credentials structure.

Erm...  Why?  inode_permission() is a function, the creds struct is a data
type.

> Each filesystem having its own cache is one reason why Linux Credentials
> Patch is being brought into live.

Not as far as I know.  The credentials belonging to the filesystem and the
inodes in the filesystem belong to the filesystem and are not held in cred
structs.  Using cred structs for inodes would waste memory as a task's
credentials have a lot of bits an inode's don't.

> So a single cache can store all the need information of the OS and for the
> file system.  Even better operate on filesystems lacking all the need
> permission structs using a userspace program to fill in some of the blanks.
>
> LSM's in Credentials can there own protected data sets since all
> alterations to Credentials by the user space deamon have to go past
> LSM for approval or rejection.  Linux Credentials only need a extra
> protected zone added to cover you LIM needs and AV needs to store
> data.

Are you suggesting the offloading of security data caching to userspace?

> In simple terms permissions stored in inodes is basically deprecated
> by Linux's Credentials patch.

In simple terms, no they aren't.

> Sorting out the Credentials patch is kinda key.   Nothing you AV or
> Integrity people is strange to the Linux Credentials patch.   Without
> embracing requires more processing when pulling data from a common
> cache that has already been AV or Integrity scanned and maintained in
> that state.  Now its really designing the struct that should exist in
> Credentials.

>From my quick glance over the integrity patches, I'd say that the cred struct
is entirely the wrong place to store this data.  It's nothing to do with a
task's subjective state, except, perhaps, in setting it up.  It appears to be
per-inode state.

David
