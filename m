Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZKWWtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZKWWtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZKWWtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:49:50 -0500
Received: from mail2.shareable.org ([80.68.89.115]:44832 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbZKWWtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:49:50 -0500
Date: Mon, 23 Nov 2009 22:49:48 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and file bind mounts (try #5)
Message-ID: <20091123224948.GB5598@shareable.org>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com> <m1my2cdhi3.fsf@fess.ebiederm.org> <20091123173616.75c3f600@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123173616.75c3f600@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:
> > check_path_accessible seems pretty horrible.   If a process is running
> > inside of a subdirectory it doesn't have permissions to access, say
> > a chroot, /proc/self/fd/XXX becomes completely unusable.
> > 
> 
> Hmm...I have this in there:
> 
> +		/* are we at global root or root of namespace? */
> +		if ((tdentry == root.dentry && vfsmnt == root.mnt) ||
> +		    vfsmnt->mnt_parent == vfsmnt)
> +			break;
> 
> ...In the case of a chroot, wouldn't "current->fs->root" point to the
> root of the process' namespace? Or am I misunderstanding what
> current->fs actually represents?

A process can run inside a subdirectory it doesn't have permissions to
access without that being a chroot.

It can also run inside a subdirectory that isn't accessible from it's
root, if that's how it was started - as well as having other
descriptors pointing to things outside its root.

It can also be passed file descriptors from outside it's root while
it's running.

Really, I think the /proc/PID/fd/N check should restrict the open to
the O_* limitations that were used to open fd N before, and not have
any connection to actual paths at the time of this check.

-- Jamie
