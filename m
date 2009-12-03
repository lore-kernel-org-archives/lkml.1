Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZLCSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZLCSf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbZLCSf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:35:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49097 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611AbZLCSf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:35:28 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jamie@shareable.org, pavel@ucw.cz,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com,
       Trond Myklebust <trond.myklebust@fys.uio.no>
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
	<1259783983-26884-3-git-send-email-jlayton@redhat.com>
	<E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu>
	<20091203102021.0b04a6eb@barsoom.rdu.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 03 Dec 2009 10:35:21 -0800
In-Reply-To: <20091203102021.0b04a6eb@barsoom.rdu.redhat.com> (Jeff Layton's message of "Thu\, 3 Dec 2009 10\:20\:21 -0500")
Message-ID: <m1ws13j47q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 2/2] vfs: force reval on dentry of bind mounted files on FS_REVAL_DOT filesystems
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> On Thu, 03 Dec 2009 11:58:43 +0100
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> On Wed,  2 Dec 2009, Jeff Layton wrote:
>> > In the case of a bind mounted file, the path walking code will assume
>> > that the cached dentry that was bind mounted is valid. This is a problem
>> > problem for NFSv4 in a way that's similar to LAST_BIND symlinks.
>> > 
>> > Fix this by revalidating the dentry if FS_FOLLOW_DOT is set and
>> > __follow_mount returns true.
>> > 
>> > Note that in the non-open codepath, we cannot return an error to the
>> > lookup if the revalidation fails. Doing so will leave a bind mount in
>> > a state such that we can't unmount it. In that case we'll just have to
>> > settle for d_invalidating it (which should mostly turn out to be a
>> > d_drop in this case) and returning success.
>> 
>> The only worry I have is that this adds an extra branch in a very hot
>> codepath (do_lookup).  An error can't be returned, as you note, and
>> for bind mounted directories d_invalidate() will not succeed: the
>> directory is busy, it's referenced by the mount.  So basically the
>> only thing this does is working around the NFSv4 issue.  But Trond has
>> a proper solution to that, and a temporary solution could be added to
>> do_filp_open() rather than burdening do_lookup() with it, no?
>> 
>
> (re-adding Trond. I forgot to cc him on this latest set)
>
> Self-NAK on this patch...
>
> That's my main worry too, and sadly it doesn't seem to be unfounded.
> This patch adds a lot of extra d_revalidate calls here. I think it's
> going to be too expensive to do this.

How so?  We should only see extra calls if we follow a mount point.
Currently we call d_revalidate on every path component.

> The only problem I've identified that this fixes is with file bind
> mounts and I don't get the impression they're that common. Maybe the
> best thing is to just fix the LAST_BIND symlink case for now and wait
> for Trond or Al's overhaul of this code.

Well right now following mount points breaks the VFS contract that we
will revalidate all dentries before we use them.  That breaking of the
contract breaks NFS.

I don't know what else d_revalidate is good for.  On the sysfs side
I only use it to unhash the dentry.  Something we don't care about
from the do_lookup side of things if we have a bind mount.

I'm not clear what kind of changes revalidating a deleted but open
file will give you on NFS.

Eric
