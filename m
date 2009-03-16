Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZCPRFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZCPRFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZCPREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:04:53 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36416 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZCPREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:04:52 -0400
Date: Mon, 16 Mar 2009 12:04:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Igor Zhbanov <izh1979@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       Trond.Myklebust@netapp.com, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and
	CAP_LINUX_IMMUTABLE be added to CAP_FS_MASK?
Message-ID: <20090316170433.GA2996@us.ibm.com>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com> <f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com> <20090316163611.GB10959@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316163611.GB10959@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting J. Bruce Fields (bfields@fieldses.org):
> On Mon, Mar 16, 2009 at 05:16:34PM +0300, Igor Zhbanov wrote:
> > I look again at kernel sources and will tell you what I think of.
> > 
> > CAP_FS_MASK is used currently in two places: in setfsuid(...) system call
> > and as a base for CAP_NFSD_MASK which used in nfsd_setuser(...) function.
> > 
> > First, setfsuid(...). As I understand, this system call is a subset
> > of seteuid(...). And it is used when some privileged process want to do
> > some filesystem operations as some ordinary user could do. That privileged
> > process don't want to completely drop all privileges and become that ordinary
> > user. But it wants temporarily lower it's privileges and set fsuid, so process
> > don't bother itself with checking permissions on files and can rely on kernel.
> > Here is typical usage from linux-PAM package, file modules/pam_xauth.c:
> > 
> > 	euid = geteuid();
> > 	setfsuid(pwd->pw_uid);
> > 	fp = fopen(path, "r");
> > 	setfsuid(euid);
> > 	if (fp != NULL) {...}
> > 
> > So, privileged PAM authentication process sets fsuid and tries to read file
> > from user's home, and after attempt to open file, it sets fsuid back.
> > So, if user cannot read that file, PAM module cannot read it too.
> > 
> > And I think that CAP_MKNOD and CAP_LINUX_IMMUTABLE privileges should
> > be included in CAP_FS_MASK. As for CAP_SYS_ADMIN and CAP_SETFCAP,
> > they could be also included in CAP_FS_MASK. Perhaps with CAP_MAC_ADMIN,
> > so mandatory access control labels couldn't be changed too.
> > 
> > Although it is strange to me if someone write a code that drops filesystem
> > capabilities and later tries e.g. to set SElinux label. Tries just to fail? ;-)
> > IMHO setfsuid(...) in ordinary privileged processes should be used only
> > for short times just around filesystem operations, that should be checked
> > against another user's permission.
> > 
> > As for NFSD, the story is quite different. Before attempting to access
> > file system NFSD calls nfsd_setuser(...) function. But NFSD is unaware
> > of capabilities of client's process. It knows just fsuid, fsgid and additional
> > groups of calling process (as it is done in AUTH_UNIX authorisation method).
> > So decision of NFSD is simple: if uid is zero, then raises filesystem
> > capabilities, else drop them.
> > 
> > And the problem is that not all filesystem operations that client can ask NFSD
> > to perform are covered by CAP_NFSD_SET. So if some ordinary user (because
> > of broken client or by given capability) will ask NFSD to create a device,
> > NFSD will do it because nfsd_setuser(...) doesn't drop that capability.
> > 
> > As for SElinux and extended attributes, it seems that extended attributes
> > other that ACL are not supported by NFS by bow. So, NFSD is unaffected
> > with CAP_SYS_ADMIN and CAP_SETFCAP not included in CAP_NFSD_SET - you just
> > can't ask NFSD to set SElinux label. It's not implemented. ;-)
> 
> That's true, though the labelled nfs people may change this some day.
> 
> > And my conclusion is that CAP_MKNOD, CAP_LINUX_IMMUTABLE, CAP_SYS_ADMIN,
> > CAP_SETFCAP and CAP_MAC_ADMIN should be included
> > in CAP_FS_MASK.
> 
> That may be reasonable, but I'd like to see clearer criteria for
> choosing those.  Some considerations:
> 
> 	1. As capabilities(7) says, we must "preserve the traditional
> 	   semantics for transitions between 0 and non-zero user IDs".
> 	   The setfsuid() interface predates capabilities, so the
> 	   introduction of capabilities shouldn't have changed the
> 	   behavior of a program written in ignorance of capabilities.
> 	2. Users of the interface (like nfsd!) would be less likely to
> 	   make mistakes if we had a simpler, more conceptual
> 	   description of CAP_FS_MASK than just "the following list of
> 	   capabilities".
> 	3. If there's a possibility new capabilities will be added again
> 	   in the future, then we should document CAP_FS_MASK in a way
> 	   that makes it clear how those new bits will be treated.
> 	4. We must fix nfsd in any case, either by changing the nfsd
> 	   code or CAP_FS_MASK, but we should err on the side of not
> 	   changing CAP_FS_MASK, for obvious backwards-compatibility
> 	   reasons.
> 
> So ideally we'd have a clear, simple description of CAP_FS_MASK that
> matches historical behavior of setfsuid(), without changing CAP_FS_MASK
> if not required.
> 
> setfsuid(2) says "The  system call setfsuid() sets the user ID that the
> Linux kernel uses to check for all accesses to the file system."  So,
> "the set of capabilities that allow bypassing filesystem permission
> checks" might be one candidate description of CAP_FS_MASK.
> 
> Based on that, I think I'd not include CAP_SYS_ADMIN: it covers a bunch
> of operations, most of which have nothing to do with filesystems--I
> think mount and umount is the only exception, and they always require

Yes, but actually the thing to keep in mind is that this is all
operating in the (supposedly temporary) whacky-land where we have
capabilities, yet we have a privileged root.  Note that when
issecure(NOSETUIDFIXUP) then these things aren't done.  So we are
enabling these capabilities precisely because we are emulating the
concept of root being privileged (and non-root being unprivileged).

Now with *that* in mind, I think it suddenly becomes clear that the
right thing to do is add every capability which could be related
to the uid wrt fs to the cap_fs_mask.

Note that even if euid=0 code does
	setresuid(500,500,0)
	...
	setfsuid(0);

then only the capabilities which are both in fsmask *and* in the
process' original permitted set (before the setresuid call) will
be replaced into the new effective set.  So if the task had taken
CAP_SYS_ADMIN out of its permitted set before the setresuid, then
it won't have that after the setfsuid(0).

> special privilege, so don't consult filesystem permissions (do I have
> that right?  What happened to the attempt to allow ordinary users to
> mount?).

Well, they keep getting stalled because we don't have a good answer for
what to do about the fact that an unprivileged user can make trees
undeletable by pinning them with mounts.  (Miklos and Eric cc'd in case
I didn't explain that well enough).

> If filesystem permissions similarly never affected the ability to create
> device nodes, that might also be an argument against including
> CAP_MKNOD, but it would be interesting to know the pre-capabilities
> behavior of a uid 0 process with fsuid non-0.

The sentiment rings true, but again since before capabilities, privilege
was fully tied to the userid, the question doesn't make sense.  Either
you had uid 0 and could mknod, or you didn't and couldn't.  And that is
the behavior which we unfortunately have to emulate when
!issecure(SECURE_NOROOT|SECURE_NOSUIDFIXUP).

-serge
