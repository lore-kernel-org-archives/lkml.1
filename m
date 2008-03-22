Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYCVCUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYCVCUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYCVCUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:20:11 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62604 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbYCVCUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:20:09 -0400
To: miklos@szeredi.hu, viro@ZenIV.linux.org.uk
Cc: haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
Subject: Re: r-o bind in nfsd
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu>
	<20080321181105.GW10722@ZenIV.linux.org.uk>
	<E1JcmLz-0001n1-RC@pomaz-ex.szeredi.hu>
	<20080321194931.GX10722@ZenIV.linux.org.uk>
	<E1Jcnm7-00020F-7o@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Jcnm7-00020F-7o@pomaz-ex.szeredi.hu>
Message-Id: <200803221120.ADB21850.SLtOJMFFOVOFQH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 22 Mar 2008 11:20:03 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> As for the apparmor and friends...  I'm far past the point of trying to
> give them feedback, seeing how any such feedback is ignored, if not worse
> (the ugliness of some of the suggested kludges is bloody astonishing - e.g.
> some guy proposed to stuff a reference to vfsmount into task_struct, etc.)
TOMOYO is one of AppArmor's friends, and I am the guy who proposed to pass
a reference to vfsmount via task_struct as if that reference is passed via stack memory.

> > Because filesystem shouldn't _care_ where it is mounted.  Anything
> > vfsmount-dependent belongs to upper layers.  The same goes for passing
> > nameidata to fs methods, BTW - again, ->follow_link() is an obvious
> > legitimate exception.
> 
> Nobody wants to send vfsmounts to the filesystem.  But vfs_...() are
> still part of the "upper layer", not the filesystem, so I'm not
> convinced yet.  For example:
I'm not asking to pass the vfsmount parameter to individual filesystem's "vfs functions".
I'm asking to pass the vfsmount parameter to the "vfs *helper* functions".
So, filesytem will not care where it is mounted
even if the vfsmount is passed to "vfs *helper* functions".
The vfs helper functions are designed to aggregate common checks (permission checks,
inode_operations->foo existence checks etc.) to avoid scattering same code everywhere
in the kernel, didn't they?

> Assuming of course, that all valid users _do_ have the vfsmount
> available, which I think is true.  If you have a counterexample,
> please let us know.
At least, calls to vfs helper functions from userland code
_do_ have the vfsmount available because they are called immediately after the name resolution.

Calls to vfs helper functions from kernel code does not always have the vfsmount available,
but that's beyond what the LSM can do.
We must trust kernel code, because kernel code can bypass the LSM check
if the kernel code is malicious enough to directly call "vfs functions" instead of
calling "vfs helper functions".
(Or, more simply, kernel code can rewrite the call to the LSM check to no-op
like funny workaround for vmsplice's vulnerability).

I think attempt to receive the vfsmount from kernel code won't help guaranteeing that
LSM's security checks are always performed.
Routes to access "vfs functions" from kernel code is undeterminable.
In other words, LSM can't guarantee that LSM's security checks are always performed
against the kernel code regardless of the security model.

But, at least, LSM can guarantee that LSM's security checks are always performed
against the userland code regardless of the security model.
Routes to access "vfs functions" from userland code is determinable.

So, making the vfsmount available to LSM make sense.
I don't care if the vfsmount is unavailable when the vfs helper function call was
issued from kernel code.
