Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0BSLDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 06:03:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45531 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0BSLDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 06:03:22 -0500
Date: Fri, 19 Feb 2010 11:03:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 01/12] Miscellaneous functions and defines needed by
 AppArmor, including the base path resolution routines.
Message-ID: <20100219110320.GL30031@ZenIV.linux.org.uk>
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
 <1266572188-26529-2-git-send-email-john.johansen@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266572188-26529-2-git-send-email-john.johansen@canonical.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 01:36:17AM -0800, john.johansen@canonical.com wrote:

> +static int d_namespace_path(struct path *path, char *buf, int buflen,
> +			    char **name, int flags)
> +{
> +	struct path root, tmp, ns_root = { };
> +	char *res;
> +	int deleted, connected;
> +	int error = 0;
> +
> +	read_lock(&current->fs->lock);
> +	root = current->fs->root;
> +	/* released below */
> +	path_get(&root);
> +	read_unlock(&current->fs->lock);
> +
> +	spin_lock(&vfsmount_lock);
> +	if (root.mnt && root.mnt->mnt_ns)
> +		/* released below */
> +		ns_root.mnt = mntget(root.mnt->mnt_ns->root);
> +	if (ns_root.mnt)
> +		/* released below */
> +		ns_root.dentry = dget(ns_root.mnt->mnt_root);
> +	spin_unlock(&vfsmount_lock);

Junk.  You might as well leave ns_root {NULL, NULL} instead of that crap.

> +	spin_lock(&dcache_lock);
> +	/* There is a race window between path lookup here and the
> +	 * need to strip the " (deleted) string that __d_path applies
> +	 * Detect the race and relookup the path
> +	 *
> +	 * The stripping of (deleted) is a hack that could be removed
> +	 * with an updated __d_path

Yes, it could.  Where's the patch doing just that?  Or discussion of
desired interface, at lease...

> +	if (flags & PATH_CHROOT_REL)
> +		connected = tmp.dentry == root.dentry && tmp.mnt == root.mnt;
> +	else
> +		connected = tmp.dentry == ns_root.dentry &&
> +			tmp.mnt == ns_root.mnt;
> +
> +	if (!connected && 
> +	    !(flags & PATH_CONNECT_PATH) &&
> +	    !((flags & PATH_CHROOT_REL) && (flags & PATH_CHROOT_NSCONNECT) &&
> +	      (tmp.dentry == ns_root.dentry && tmp.mnt == ns_root.mnt))) {
> +		/* disconnected path, don't return pathname starting with '/' */
> +		error = -ESTALE;
> +		if (*res == '/')
> +			*name = res + 1;

Explanations, please.
