Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZLaTFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZLaTFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 14:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZLaTFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 14:05:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbZLaTFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 14:05:01 -0500
Date: Thu, 31 Dec 2009 11:04:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
 (was: Re: Linux 2.6.33-rc2 - Merry Christmas ...)
In-Reply-To: <m1fx6rtu31.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain> <20091226094504.GA6214@liondog.tnic> <20091228092712.AA8C.A69D9226@jp.fujitsu.com> <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain> <m11victac1.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain> <m1fx6rtu31.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Dec 2009, Eric W. Biederman wrote:
> >
> >  - hibernate ends up with the sequence: _cpu_down (cpu_hotplug.lock) ->  ..
> >    kref_put .. -> sysfs_addrm_start (sysfs_mutex)
> >
> >    Again, nothing suspicious or "bad", and this part of the dependency 
> >    chain has nothing to do with the DRM code itself.
> 
> kobject_del with a lock held scares me.

I would not object at _all_ if sysfs fixed the locking here instead of in 
filldir.

The problem is that releasing objects (with kref_put() and friends) is 
something that is _commonly_ done with various locks held.

Btw, that "cpu_down()" is by no means the only case. I would suggest you 
just google for

	sysfs_mutex lockdep

and you'll find a _lot_ of cases, most of them not involving drm at all, 
but ext4 and btrfs.

(Side note: almost all of them tend to _also_ have mmap_sem in the chain: 
that's usually the thing that "closes the deal").

> There is a possible deadlock (that lockdep is ignorant of) if you hold
> a lock over sysfs_deactivate() and if any sysfs file takes that lock.
> 
> I won't argue with a claim of inconvenient locking semantics here, and
> this is different to the problem you are seeing (except that fixing this
> problem would happen to fix the filldir issue).

I suspect that filldir is almost always implicated because mmap_sem is so 
hard to do just one way: both page faulting and mmap have it held, and so 
a lot of locks need to be gotten _after_ it, while filldir very often has 
the exact reverse requirement. 

So that's why filldir is kind of special (and the fundamental _reason_ it 
is special is exactly because pretty much all other VFS operations work 
with generic caches, and the actual filesystem only fills in the caches, 
it doesn't copy to user space directly while holding any locks - although 
ioctl's sometimes have the same issue as filldir for all the same 
reasons).

Anyway, I'm in _no_ way saying that you need to break it at filldir: the 
reason I pick on filldir is because I hate it, and think that it's a 
really annoying special case at the VFS level. But from a sysfs 
standpoint, I could well see that there are worse problems than that kind 
of annoying VFS problem.

So if you can break it at that kref_put layer (which leads to releasing a 
sysfs object etc), then that would be great. In fact, it would be better, 
since kref_put and friends are in many ways "more fundamental" than some 
filldir special case that we _could_ fix in other ways.

> The cheap fix here is mostly a matter of grabbing a reference to the
> sysfs_dirent and then revalidating that the reference is still useful
> after we reacquire the sysfs_mutex.  If not we already have the code for
> restarting from just an offset.  We just don't want to use it too much as
> that will give us O(n^2) times for sysfs readdir.

Well, the _trivial_ fix is to just move the mutex_lock/unlock _inside_ the 
loop instead of of outside. Something like the appended might just work, 
and is the really stupid approach.

Totally untested. And it will do a _lot_ more sysfs mutex accesses, since 
now it will lock/unlock around each entry we return.

A smarter thing to do would probably be to rewrite the 's_sibling' search 
to instead insert a fake entry in the list, so that we don't have to 
traverse the s_sibling list every time for each entry (which is O(n**2) in 
size of the directory, and just generally horribly evil and crap code).

		Linus

---
 fs/sysfs/dir.c |   34 +++++++++++++++++++---------------
 1 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f05f230..2d0fd42 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -847,29 +847,33 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
 	}
-	if ((filp->f_pos > 1) && (filp->f_pos < INT_MAX)) {
-		mutex_lock(&sysfs_mutex);
+	while ((filp->f_pos > 1) && (filp->f_pos < INT_MAX)) {
+		const char * name;
+		int len, err;
 
+		mutex_lock(&sysfs_mutex);
 		/* Skip the dentries we have already reported */
 		pos = parent_sd->s_dir.children;
 		while (pos && (filp->f_pos > pos->s_ino))
 			pos = pos->s_sibling;
 
-		for ( ; pos; pos = pos->s_sibling) {
-			const char * name;
-			int len;
+		/* This is ok even with 'pos == NULL' */
+		sysfs_get_active(pos);
+		mutex_unlock(&sysfs_mutex);
+		if (!pos) {
+			filp->f_pos = INT_MAX;
+			break;
+		}
 
-			name = pos->s_name;
-			len = strlen(name);
-			filp->f_pos = ino = pos->s_ino;
+		name = pos->s_name;
+		len = strlen(name);
+		filp->f_pos = ino = pos->s_ino;
 
-			if (filldir(dirent, name, len, filp->f_pos, ino,
-					 dt_type(pos)) < 0)
-				break;
-		}
-		if (!pos)
-			filp->f_pos = INT_MAX;
-		mutex_unlock(&sysfs_mutex);
+		err = filldir(dirent, name, len, filp->f_pos, ino, dt_type(pos));
+		sysfs_put_active(pos);
+
+		if (err < 0)
+			break;
 	}
 	return 0;
 }
