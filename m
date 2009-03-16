Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZCPQqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZCPQqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757839AbZCPQqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:46:16 -0400
Received: from mail.fieldses.org ([141.211.133.115]:53031 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbZCPQqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:46:15 -0400
Date: Mon, 16 Mar 2009 12:46:12 -0400
To: Igor Zhbanov <izh1979@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and
	CAP_LINUX_IMMUTABLE be added to CAP_FS_MASK?
Message-ID: <20090316164612.GC10959@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com> <f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com> <20090316163611.GB10959@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316163611.GB10959@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:36:11PM -0400, bfields wrote:
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

Also, thinking of the nfsd case: it violates the principal of least
surprise if dropping CAP_FS_MASK still leaves it possible to make a
change to the filesystem that would normally require special
privileges....

--b.

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
> special privilege, so don't consult filesystem permissions (do I have
> that right?  What happened to the attempt to allow ordinary users to
> mount?).
> 
> If filesystem permissions similarly never affected the ability to create
> device nodes, that might also be an argument against including
> CAP_MKNOD, but it would be interesting to know the pre-capabilities
> behavior of a uid 0 process with fsuid non-0.
> 
> --b.
> 
> > 
> > I'm sure about CAP_MKNOD and CAP_LINUX_IMMUTABLE, and not so sure
> > of CAP_SYS_ADMIN, CAP_SETFCAP and CAP_MAC_ADMIN.
> > (NFS doesn't support SElinux, as I know. And dropping filesystem capabilities
> > before manipulating SElinux labels seems to be useless. And if someone exploits
> > vulnerability in process with dropped filesystem capabilities, it's
> > easy to bring them back.)
> > 
> > Please tell what you think.
> > 
> > And there are patches:
> > 
> > For linux-2.6:
> > ------------------------------------------------------------------------------
> > diff -purN linux-2.6.28.7/include/linux/capability.h
> > linux/include/linux/capability.h
> > --- linux-2.6.28.7/include/linux/capability.h	2009-02-21
> > 01:41:27.000000000 +0300
> > +++ linux/include/linux/capability.h	2009-03-16 17:09:23.588420300 +0300
> > @@ -370,9 +370,14 @@ typedef struct kernel_cap_struct {
> >  			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
> >  			    | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
> >  			    | CAP_TO_MASK(CAP_FOWNER)		\
> > +			    | CAP_TO_MASK(CAP_MKNOD)		\
> > +			    | CAP_TO_MASK(CAP_LINUX_IMMUTABLE)	\
> > +			    | CAP_TO_MASK(CAP_SYS_ADMIN)	\
> > +			    | CAP_TO_MASK(CAP_SETFCAP)		\
> >  			    | CAP_TO_MASK(CAP_FSETID))
> > 
> > -# define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE))
> > +# define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE)	\
> > +			    | CAP_TO_MASK(CAP_MAC_ADMIN))
> > 
> >  #if _KERNEL_CAPABILITY_U32S != 2
> >  # error Fix up hand-coded capability macro initializers
> > ------------------------------------------------------------------------------
> > 
> > And for linux-2.4:
> > ------------------------------------------------------------------------------
> > diff -purN linux-2.4.37/include/linux/capability.h
> > linux/include/linux/capability.h
> > --- linux-2.4.37/include/linux/capability.h	2008-12-02 11:01:34.000000000 +0300
> > +++ linux/include/linux/capability.h	2009-03-16 17:14:16.308635400 +0300
> > @@ -101,7 +101,7 @@ typedef __u32 kernel_cap_t;
> > 
> >  /* Used to decide between falling back on the old suser() or fsuser(). */
> > 
> > -#define CAP_FS_MASK          0x1f
> > +#define CAP_FS_MASK          0x0820021f
> > 
> >  /* Overrides the restriction that the real or effective user ID of a
> >     process sending a signal must match the real or effective user ID
> > ------------------------------------------------------------------------------
> > 
> > Anyway, I haven't write access to git repository, so if you agree,
> > please commit.
> > 
> > P.S. CAP_SYS_ADMIN is bad - too many actions are bounded to this capability.
> > Perhaps it should be broken down to a set of independent capabilities.
> > Especially, SElinux related could be separated.
