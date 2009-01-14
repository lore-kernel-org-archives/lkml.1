Return-Path: <linux-kernel-owner+w=401wt.eu-S1760961AbZANI7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961AbZANI7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZANI6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:58:40 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60289 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbZANI6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:58:38 -0500
Message-Id: <200901140858.n0E8wE9v099032@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #14 (mmotm 2008-12-30-16-05) 03/10] Introduce d_realpath().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Jan 2009 17:58:14 +0900
References: <20090101050741.372438529@I-love.SAKURA.ne.jp> <20090101050940.282118078@I-love.SAKURA.ne.jp> <alpine.LRH.1.10.0901052007350.16049@tundra.namei.org>
In-Reply-To: <alpine.LRH.1.10.0901052007350.16049@tundra.namei.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 14012009 #1451940, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> > (3) /proc/PID/ is represented as /proc/self/ if PID equals current->tgid.
> 
> This needs an ack from Al and/or Christoph.
> 
It is a sad thing that I cannot use /proc/self/ (which is the only part where
a pathname based access control can prevent current process from accessing
other process's information), but I purged d_realpath() for now.

Next posting (#15) will embed AppArmor's d_namespace_path()-like function
into TOMOYO's code.

/* d_namespace_path() in OpenSUSE 11.1's 2.6.27.7-9.1 kernel. */
char *d_namespace_path(struct dentry *dentry, struct vfsmount *vfsmnt,
		       char *buf, int buflen)
{
	struct path root, tmp, ns_root = { };
	struct path path = { .mnt = vfsmnt, .dentry = dentry };
	char *res;

	read_lock(&current->fs->lock);
	root = current->fs->root;
	path_get(&current->fs->root);
	read_unlock(&current->fs->lock);
	spin_lock(&vfsmount_lock);
	if (root.mnt && root.mnt->mnt_ns)
		ns_root.mnt = mntget(root.mnt->mnt_ns->root);
	if (ns_root.mnt)
		ns_root.dentry = dget(ns_root.mnt->mnt_root);
	spin_unlock(&vfsmount_lock);
	tmp = ns_root;
	res = __d_path(&path, &tmp, buf, buflen,
		       D_PATH_FAIL_DELETED | D_PATH_DISCONNECT);
	path_put(&root);
	path_put(&ns_root);

	/* Prevent empty path for lazily unmounted filesystems. */
	if (!IS_ERR(res) && *res == '\0')
		*--res = '.';
	return res;
}

Thanks.
