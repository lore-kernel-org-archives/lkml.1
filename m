Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbYDXQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbYDXQA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbYDXQAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:00:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39755 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYDXQAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:00:04 -0400
Date: Thu, 24 Apr 2008 16:59:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424155954.GM15214@ZenIV.linux.org.uk>
References: <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk> <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu> <20080424144815.GI15214@ZenIV.linux.org.uk> <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu> <20080424152129.GK15214@ZenIV.linux.org.uk> <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 05:37:39PM +0200, Miklos Szeredi wrote:
> > > What is left is the guarantee, that the race-free r/o remounts will
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > always work and some obscure caller didn't forget to surround it with
^^^^^^^^^^^^^^^^^

> Why are those so important?  Yes, if we have multiple vfs_() calls,
> surround them with an extra want/drop pair.

Which leaves you with the same need to audit all these suckers anyway.

I'm in principle fine with having such helper functions, *IF* they are
not sold as providing all protection one needs, *IF* you are not expecting
to be able to fold all areas down into them and *IF* original ones are
left intact.

Modulo the like path_rename(), BTW - that one is just plain ugly API.

> > We don't even have many callers of each, and with a few we do it's not
> > obvious that we want to go through vfsmounts (and vfsmount-based checks)
> > in all of them.  So no, I don't buy your argument.  Sorry.
> > 
> > I'm not even convinced that they are useful as helpers, at least until
> > we'd decided what to do with checks in nfsd.  Until then we do, as
> > far as I'm concerned, one place where they would definitely DTRT - fs/namei.c.
> > And I want more than one caller before merging those,
> 
> unix_bind() -> vfs_mknod()
> sys_mq_unlink() -> vfs_unlink()
> open.c (several) -> notify_change()
> *setxattr() -> vfs_setxattr()
> *removexattr() -> vfs_removexattr()

OK.

> > let alone removing the interface that doesn't require checks to be
> > vfsmount-based for all users.
> 
> What users?  There are paractically _no_ other users.  The ones that
> there are (like reiserfs) should not be using them, and there are
> already some patches cleaning that mess up.

OK, explain me, in small words, WTF should something that wants to do
operations on filesystem tree have a vfsmount.  Slowly.  And "r/o
bind loses value if it can be bypassed" is a hogwash - fs methods are
still there, so it *can* be bypassed just fine, thank you very much.
It's really up to caller.  "But they won't be able to do open()" also
doesn't fly - again, it's up to whoever writes particular piece of code.
