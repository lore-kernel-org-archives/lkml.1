Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZKWWFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZKWWFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbZKWWFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:05:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47528 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbZKWWF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:05:28 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, pavel@ucw.cz,
       miklos@szeredi.hu, viro@ZenIV.linux.org.uk
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Nov 2009 14:05:24 -0800
In-Reply-To: <1258998084-26797-1-git-send-email-jlayton@redhat.com> (Jeff Layton's message of "Mon\, 23 Nov 2009 12\:41\:21 -0500")
Message-ID: <m1my2cdhi3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and file bind mounts (try #5)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> There are a few situations where a lookup can end up returning a dentry
> without revalidating it, and without checking whether the calling
> process has permissions to access it. Two situations identified so far
> are:
>
> 1) LAST_BIND symlinks (such as those under /proc/<pid>)
>
> 2) file bind mounts
>
> This patchset is intended to fix this by forcing revalidation of the
> returned dentries at appropriate locations.
>
> In the case of LAST_BIND symlinks it also adds a check to verify that
> the target of the symlink is accessible by the current process by
> walking mounts and dentries back up to the root and checking permission
> on each inode.
>
> This set fixes the reproducers I have (including the reproducer that
> Pavel provided for the permissions bypass). It's still pretty rough
> though and I expect that it'll need revision. At this point, I'm mainly
> looking to get these questions answered:
>
> 1) what should we do if these dentries are found to be invalid? Is it ok
> to d_invalidate them? Or is that likely to break something (particularly
> in the case of file bind mounts)?

The normal sequence in do_revalidate should be safe.  In practice what we
should see is d_drop().  If we access the dentries via another path today
we already go through d_revalidate.  It is only the reference count on
the dentry that keeps them alive and working.  The cases I have looked
at for distributed filesystems have to call d_drop themselves so I don't
know if it would add anything if the vfs called d_revalidate.  Especially
since FS_REVAL_DOT doesn't have that logic.

> 2) I'm using FS_REVAL_DOT as an indicator of whether to force a
> d_revalidate. I think that it's appropriate to key off of that flag, but
> we may want to rename it (maybe FS_FORCE_D_REVAL ?).

Perhaps FS_ALWAYS_REVAL.    I don't think it makes much of
a difference either way.  I expect a rename should come after we fix
nfsv4 so there is a chance at pushing the fixes back to stable.

> 3) is check_path_accessible racy? It seems to work, but something
> doesn't seem quite right with this approach. Is this defeatable somehow?
> Could a rename of one of the intermediate path components cause
> problems?

check_path_accessible seems pretty horrible.   If a process is running
inside of a subdirectory it doesn't have permissions to access, say
a chroot, /proc/self/fd/XXX becomes completely unusable.

Eric
