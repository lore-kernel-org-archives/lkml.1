Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZBIL6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZBIL6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZBIL6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:58:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37544 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZBIL6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:58:24 -0500
Date: Mon, 9 Feb 2009 11:58:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       containers@lists.osdl.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [cgroup or VFS ?]  WARNING: at fs/namespace.c:636
	mntput_no_expire+0xac/0xf2()
Message-ID: <20090209115818.GX28946@ZenIV.linux.org.uk>
References: <49617D35.4040805@cn.fujitsu.com> <20090209004046.3ce1dde0.akpm@linux-foundation.org> <498FEE24.5030407@cn.fujitsu.com> <20090209110348.GV28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209110348.GV28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 11:03:48AM +0000, Al Viro wrote:
> 	BTW, a trivial note - kfree(root) in your ->kill_sb() is done
> earlier than it's nice to do.  Shouldn't affect the problem, though.

	Other probably irrelevant notes:

                memcpy(start, cgrp->dentry->d_name.name, len);
                cgrp = cgrp->parent;
                if (!cgrp)
                        break;
                dentry = rcu_dereference(cgrp->dentry);

in cgroup_path().  Why don't we need rcu_dereference on both?
Moreover, shouldn't that be
                memcpy(start, dentry->d_name.name, len);
anyway, seeing that we'd just looked at dentry->d_name.len?

In cgroup_rmdir():
        spin_lock(&cgrp->dentry->d_lock);
        d = dget(cgrp->dentry);
        spin_unlock(&d->d_lock);

        cgroup_d_remove_dir(d);
        dput(d);
Er?  Comments, please...  Unless something very unusual is going on,
either that d_lock is pointless or dget() is rather unsafe.

cgroups_clone()
        /* Now do the VFS work to create a cgroup */
        inode = parent->dentry->d_inode;

        /* Hold the parent directory mutex across this operation to
         * stop anyone else deleting the new cgroup */
        mutex_lock(&inode->i_mutex);
Can the parent be in process of getting deleted by somebody else?  If yes,
we are in trouble here.

BTW, that thing in cgroup_path()...  What guarantees that cgroup_rename()
won't hit between getting len and doing memcpy()?

That said, cgroup seems to be completely agnostic wrt anything happening
on vfsmount level, so I really don't see how it gets to that WARN_ON().
Hell knows; I really want to see the sequence of events - it might be
something like fscking up ->s_active handling with interesting results
(cgroup code is certainly hitting it in not quite usual ways), it may be
genuine VFS-only race.  Need more data...
