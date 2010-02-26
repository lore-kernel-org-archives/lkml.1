Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107Ab0BZDWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 22:22:46 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57742 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935082Ab0BZDWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 22:22:44 -0500
Message-Id: <201002260322.o1Q3Mc3r000644@www262.sakura.ne.jp>
Subject: Re: [AppArmor #4 0/12] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.johansen@canonical.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Feb 2010 12:22:38 +0900
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>  
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 25022010 #3418103, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding path.c

"struct task_struct" has "struct fs_struct *fs" and "struct nsproxy *nsproxy".
The former is used for holding current process's root directory and current
directory.
The latter is used for holding current process's namespace information.

I'm not sure, but I think we can directly fetch current process's namespace's
root by dereferencing current->nsproxy->mnt_ns , and therefore simplify
d_namespace_path() as follows.

 36 static int d_namespace_path(struct path *path, char *buf, int buflen,
 37                             char **name, int flags)
 38 {
 39         struct path root, tmp, ns_root = { };

	/* Remove "ns_root" as only "root" and "tmp" are used. */

 40         char *res;
 41         int deleted, connected;
 42         int error = 0;
 43 

	if (flags & PATH_CHROOT_REL) {

 44         read_lock(&current->fs->lock);
 45         root = current->fs->root;
 46         /* released below */
 47         path_get(&root);
 48         read_unlock(&current->fs->lock);
 49 

	} else {
		root.mnt = current->nsproxy->root;
		root.dentry = root.mnt->mnt_root;
		/* released below */
		path_get(&root);
	}

	/*

 50         spin_lock(&vfsmount_lock);
 51         if (root.mnt && root.mnt->mnt_ns)
 52                 /* released below */
 53                 ns_root.mnt = mntget(root.mnt->mnt_ns->root);
 54         if (ns_root.mnt)
 55                 /* released below */
 56                 ns_root.dentry = dget(ns_root.mnt->mnt_root);
 57         spin_unlock(&vfsmount_lock);
 58 

	*/

 59         spin_lock(&dcache_lock);
 60         /* There is a race window between path lookup here and the
 61          * need to strip the " (deleted) string that __d_path applies
 62          * Detect the race and relookup the path
 63          *
 64          * The stripping of (deleted) is a hack that could be removed
 65          * with an updated __d_path
 66          */
 67         do {

		/*

 68                 if (flags & PATH_CHROOT_REL)

		*/

 69                         tmp = root;

		/*

 70                 else
 71                         tmp = ns_root;

		*/

 72                 deleted = d_unlinked(path->dentry);
 73                 res = __d_path(path, &tmp, buf, buflen);
 74 
 75         } while (deleted != d_unlinked(path->dentry));
 76         spin_unlock(&dcache_lock);
 77 
 78         *name = res;
 79         /* handle error conditions - and still allow a partial path to
 80          * be returned.
 81          */
 82         if (IS_ERR(res)) {
 83                 error = PTR_ERR(res);
 84                 *name = buf;
 85                 goto out;
 86         }
 87         if (deleted) {
 88                 /* On some filesystems, newly allocated dentries appear to the
 89                  * security_path hooks as a deleted dentry except without an
 90                  * inode allocated.
 91                  *
 92                  * Remove the appended deleted text and return as string for
 93                  * normal mediation, or auditing.  The (deleted) string is
 94                  * guarenteed to be added in this case, so just strip it.
 95                  */
 96                 buf[buflen - 11] = 0;   /* - (len(" (deleted)") +\0) */
 97 
 98                 if (path->dentry->d_inode && !(flags & PATH_MEDIATE_DELETED)) {
 99                         error = -ENOENT;
100                         goto out;
101                 }
102         }
103 

	/*

104         if (flags & PATH_CHROOT_REL)

	*/

105                 connected = tmp.dentry == root.dentry && tmp.mnt == root.mnt;

	/*

106         else
107                 connected = tmp.dentry == ns_root.dentry &&
108                         tmp.mnt == ns_root.mnt;

	*/

109 
110         if (!connected && 
111             !(flags & PATH_CONNECT_PATH) &&
112             !((flags & PATH_CHROOT_REL) && (flags & PATH_CHROOT_NSCONNECT) &&
113               (tmp.dentry == ns_root.dentry && tmp.mnt == ns_root.mnt))) {

	/* Change from "ns_root" to "root". */

114                 /* disconnected path, don't return pathname starting with '/' */
115                 error = -ESTALE;
116                 if (*res == '/')
117                         *name = res + 1;
118         }
119 
120 out:
121         path_put(&root);

	/*

122         path_put(&ns_root);

	*/

123 
124         return error;
125 }
