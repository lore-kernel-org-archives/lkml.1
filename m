Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbXHPXfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbXHPXfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbXHPXeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:34:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41429 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbXHPXes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:34:48 -0400
Date: Fri, 17 Aug 2007 00:34:12 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: Adding a security parameter to VFS functions
Message-ID: <20070816233412.GO21089@ftp.linux.org.uk>
References: <29015.1187178055@redhat.com> <alpine.LFD.0.999.0708161550140.30176@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708161550140.30176@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 03:57:24PM -0700, Linus Torvalds wrote:
> I personally consider this an affront to everythign that is decent.
> 
> Why the *hell* would mkdir() be so magical as to need something like that?
> 
> Make it something sane, like a "struct nameidata" instead, and make it at 
> least try to look like the path creation that is done by "open()".  Or 
> create a "struct file *" or something.

No.  I agree that mkdir/mknod/etc. should all take the same thing.
*However*, it should not be nameidata or file.  Why?  Because it
should not contain vfsmount.  Object creation should not *care*
where fs is mounted.  At all.  The same goes for open(), BTW - letting
it see the reference to vfsmount via nameidata is bloody wrong and
I really couldn't care less what kinds of perversions apparmour crowd
might like - pathnames simply do not belong there.

Said that, I agree that we need uniform prototypes for all these guys
and I can see arguments both for and against having creds passed by
reference stored in whatever struct we are passing (for: copy-on-write
refcounted cred objects would almost never have to be modified or
copied and normally we would just pick the current creds reference
from task_struct and assing it to a single field in whatever we pass
instead of nameidata; against: might be conceptually simpler to have
all that data directly in that struct and a helper filling it in).

Which way we do that and which struct we end up passing is a very good
question, but I want to make it very clear: having object creation/removal/
renaming methods[1] depend on which vfsmount we are dealing with is *wrong*.
IOW, I strongly object against the use of nameidata here.
