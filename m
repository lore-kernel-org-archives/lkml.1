Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZKWCKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZKWCKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 21:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZKWCKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 21:10:32 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:59146 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZKWCKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 21:10:31 -0500
To: jmorris@namei.org, ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC][PATCH] security/selinux: Simplify proc inode to securitylabel mapping.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <m11vjtrpfk.fsf@fess.ebiederm.org>
	<alpine.LRH.2.00.0911230917020.19108@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0911230917020.19108@tundra.namei.org>
Message-Id: <200911231110.AGI23211.OOFHJFStQMLFVO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 23 Nov 2009 11:10:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> I need to investigate this further, but one immediate issue is that 
> Tomoyo seems to have similar code.

tomoyo_sysctl hook and related functions will be removed soon.

> On Fri, 20 Nov 2009, Eric W. Biederman wrote:
> > caveat: Because the dentry may not yet be hashed I think dentry_path will
> >         append (deleted) and thus is not the right function to call.

SELinux, TOMOYO, AppArmor want pathname calculation functions which don't
append " (deleted)" suffix.

Regarding TOMOYO, I want to use below function.
It is impossible to convert "pid" to "self" outside __d_path() because string
returned by __d_path() does not have hints for telling whether "pid" part is
procfs or not. As a result, I have to traverse dentry/vfsmount tree manually
in order to tell whether "pid" part is procfs or not, which makes __d_path()
useless for TOMOYO.

/**
 * tomoyo_get_absolute_path - Get the path of a dentry but ignores chroot'ed root.
 *
 * @path:   Pointer to "struct path".
 * @buffer: Pointer to buffer to return value in.
 * @buflen: Sizeof @buffer.
 *
 * Returns the buffer on success, an error code otherwise.
 *
 * Caller holds the dcache_lock and vfsmount_lock.
 * Based on __d_path() in fs/dcache.c
 *
 * If dentry is a directory, trailing '/' is appended.
 * /proc/pid is represented as /proc/self if pid is current.
 */
static char *tomoyo_get_absolute_path(struct path *path, char * const buffer,
				      const int buflen)
{
	char *pos = buffer + buflen - 1;
	struct dentry *dentry = path->dentry;
	struct vfsmount *vfsmnt = path->mnt;
	bool is_dir = (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode));
	const char *name;
	int len;

	if (buflen < 256)
		goto out;

	*pos = '\0';
	for (;;) {
		struct dentry *parent;
		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
			if (vfsmnt->mnt_parent == vfsmnt)
				break;
			dentry = vfsmnt->mnt_mountpoint;
			vfsmnt = vfsmnt->mnt_parent;
			continue;
		}
		if (is_dir) {
			is_dir = false;
			*--pos = '/';
		}
		parent = dentry->d_parent;
		name = dentry->d_name.name;
		len = dentry->d_name.len;
		if (IS_ROOT(parent) && *name > '0' && *name <= '9' &&
		    parent->d_sb &&
		    parent->d_sb->s_magic == PROC_SUPER_MAGIC) {
			char *ep;
			const pid_t pid = (pid_t) simple_strtoul(name, &ep,
								 10);
			const pid_t tgid = task_tgid_nr_ns(current,
							   dentry->d_sb->
							   s_fs_info);
			if (!*ep && pid == tgid && tgid) {
				name = "self";
				len = 4;
			}
		}
		pos -= len;
		if (pos <= buffer)
			goto out;
		memmove(pos, name, len);
		*--pos = '/';
		dentry = parent;
	}
	if (*pos == '/')
		pos++;
	len = dentry->d_name.len;
	pos -= len;
	if (pos < buffer)
		goto out;
	memmove(pos, dentry->d_name.name, len);
	return pos;
 out:
	return ERR_PTR(-ENOMEM);
}
