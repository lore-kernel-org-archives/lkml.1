Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZLCPUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZLCPUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbZLCPUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:20:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbZLCPUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:20:50 -0500
Date: Thu, 3 Dec 2009 10:20:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jamie@shareable.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com, ebiederm@xmission.com,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH 2/2] vfs: force reval on dentry of bind mounted files on
 FS_REVAL_DOT filesystems
Message-ID: <20091203102021.0b04a6eb@barsoom.rdu.redhat.com>
In-Reply-To: <E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu>
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
	<1259783983-26884-3-git-send-email-jlayton@redhat.com>
	<E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009 11:58:43 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Wed,  2 Dec 2009, Jeff Layton wrote:
> > In the case of a bind mounted file, the path walking code will assume
> > that the cached dentry that was bind mounted is valid. This is a problem
> > problem for NFSv4 in a way that's similar to LAST_BIND symlinks.
> > 
> > Fix this by revalidating the dentry if FS_FOLLOW_DOT is set and
> > __follow_mount returns true.
> > 
> > Note that in the non-open codepath, we cannot return an error to the
> > lookup if the revalidation fails. Doing so will leave a bind mount in
> > a state such that we can't unmount it. In that case we'll just have to
> > settle for d_invalidating it (which should mostly turn out to be a
> > d_drop in this case) and returning success.
> 
> The only worry I have is that this adds an extra branch in a very hot
> codepath (do_lookup).  An error can't be returned, as you note, and
> for bind mounted directories d_invalidate() will not succeed: the
> directory is busy, it's referenced by the mount.  So basically the
> only thing this does is working around the NFSv4 issue.  But Trond has
> a proper solution to that, and a temporary solution could be added to
> do_filp_open() rather than burdening do_lookup() with it, no?
> 

(re-adding Trond. I forgot to cc him on this latest set)

Self-NAK on this patch...

That's my main worry too, and sadly it doesn't seem to be unfounded.
This patch adds a lot of extra d_revalidate calls here. I think it's
going to be too expensive to do this.

Unfortunately, adding the code to do_filp_open alone doesn't really
help. The path walking code in there is just for the O_CREAT case. If
we're not creating the file, we call into path_lookup_open which
eventually calls do_lookup.

What we probably need to do is only make it d_revalidate when it looks
like the final dentry is bind mounted. I'm not sure how to tell that
though and even if I could, I'm still leery of adding this to such a
hot codepath.

The only problem I've identified that this fixes is with file bind
mounts and I don't get the impression they're that common. Maybe the
best thing is to just fix the LAST_BIND symlink case for now and wait
for Trond or Al's overhaul of this code.

-- 
Jeff Layton <jlayton@redhat.com>
