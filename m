Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0BTMSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 07:18:00 -0500
Received: from adelie.canonical.com ([91.189.90.139]:46588 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab0BTMR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 07:17:57 -0500
Message-ID: <4B7FD2F0.6090602@canonical.com>
Date: Sat, 20 Feb 2010 04:17:52 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 01/12] Miscellaneous functions and defines needed by AppArmor,
 including the base path resolution routines.
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com> <1266572188-26529-2-git-send-email-john.johansen@canonical.com> <20100219110320.GL30031@ZenIV.linux.org.uk>
In-Reply-To: <20100219110320.GL30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Fri, Feb 19, 2010 at 01:36:17AM -0800, john.johansen@canonical.com wrote:
> 
>> +static int d_namespace_path(struct path *path, char *buf, int buflen,
>> +			    char **name, int flags)
>> +{
>> +	struct path root, tmp, ns_root = { };
>> +	char *res;
>> +	int deleted, connected;
>> +	int error = 0;
>> +
>> +	read_lock(&current->fs->lock);
>> +	root = current->fs->root;
>> +	/* released below */
>> +	path_get(&root);
>> +	read_unlock(&current->fs->lock);
>> +
>> +	spin_lock(&vfsmount_lock);
>> +	if (root.mnt && root.mnt->mnt_ns)
>> +		/* released below */
>> +		ns_root.mnt = mntget(root.mnt->mnt_ns->root);
>> +	if (ns_root.mnt)
>> +		/* released below */
>> +		ns_root.dentry = dget(ns_root.mnt->mnt_root);
>> +	spin_unlock(&vfsmount_lock);
> 
> Junk.  You might as well leave ns_root {NULL, NULL} instead of that crap.
> 
Right, though the ns_root.mnt and ns_root.dentry are needed below to detect
disconnected paths.

<< snip >>

> 
>> +	if (flags & PATH_CHROOT_REL)
>> +		connected = tmp.dentry == root.dentry && tmp.mnt == root.mnt;
>> +	else
>> +		connected = tmp.dentry == ns_root.dentry &&
>> +			tmp.mnt == ns_root.mnt;
>> +
>> +	if (!connected && 
>> +	    !(flags & PATH_CONNECT_PATH) &&
>> +	    !((flags & PATH_CHROOT_REL) && (flags & PATH_CHROOT_NSCONNECT) &&
>> +	      (tmp.dentry == ns_root.dentry && tmp.mnt == ns_root.mnt))) {
>> +		/* disconnected path, don't return pathname starting with '/' */
>> +		error = -ESTALE;
>> +		if (*res == '/')
>> +			*name = res + 1;
> 
> Explanations, please.

Right this needs to have a very good comment attached.

Basically AppArmor wants to know if the path is connected to the expected root
(either the chroot, or the namespace depending on how the profile is created).

When the file object isn't actually connected, and the profile is setup to use
file delegation instead of artificially connecting it to /, we stip the leading /
returned by __d_path disconnecting the path.

Objects disconnected from the root in this way can not be matched via regular path
matching rules but need to be delegated.

Previously we were doing this by patching __d_path to return disconnected paths
and then reattaching them in d_path, and getcwd.  In many ways that was cleaner
as then we wouldn't need to grab to the ns_root to find if the path was connected
or not.

But for this submission I split any proposed changes to __d_path from AppArmor
so that they can be discussed separately.

