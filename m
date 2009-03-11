Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZCKXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZCKXYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 19:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZCKXYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 19:24:04 -0400
Received: from mail.fieldses.org ([141.211.133.115]:57380 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZCKXYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 19:24:03 -0400
Date: Wed, 11 Mar 2009 19:23:56 -0400
To: Igor Zhbanov <izh1979@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, neilb@suse.de,
       Trond.Myklebust@netapp.com, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and
	CAP_LINUX_IMMUTABLE be added to CAP_FS_MASK?
Message-ID: <20090311232356.GP13540@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 03:53:34PM +0300, Igor Zhbanov wrote:
> Hello!
> 
> It seems that CAP_MKNOD and CAP_LINUX_IMMUTABLE were forgotten to be
> added to CAP_FS_MASK_B0 in linux-2.6.x and to CAP_FS_MASK in
> linux-2.4.x. Both capabilities affects file system and can be
> considered file system capabilities.

Sounds right to me--I'd expect rootsquash to guarantee that new device
nodes can't be created from the network.  Cc'ing random people from the
git log for include/linux/capability.h in hopes they can help.

--b.

(Also: my copy of mknod(2) claims "Linux... does not have the CAP_MKNOD
capability".  I assume the manpage is out of date?)

> 
> Let's look at linux-2.6.x.
> 
> In include/linux/capability.h CAP_FS_SET is defined to contain
> following capabilities:
> CAP_CHOWN, CAP_DAC_OVERRIDE, CAP_DAC_READ_SEARCH, CAP_FOWNER,
> CAP_FSETID and CAP_MAC_OVERRIDE.
> 
> And CAP_NFSD_SET is defined to be the same plus CAP_SYS_RESOURCE.
> 
> So, both CAP_FS_SET and CAP_NFSD_SET doesn't include CAP_MKNOD and
> CAP_LINUX_IMMUTABLE.
> 
> Also include/linux/capability.h there are cap_drop_fs_set(...),
> cap_raise_fs_set(...),
> cap_drop_nfsd_set(...) and cap_raise_nfsd_set(...) inline functions that return
> corresponding capabilities sets.
> 
> Let's look how these functions are used.
> 
> In file fs/nfsd/auth.c function nfsd_setuser(...) calls
> cap_raise_nfsd_set(...) and
> cap_drop_nfsd_set(...) to add/exclude corresponding capabilities to/from
> effective set of current nfsd process.
> 
> And in file security/commoncap.c function cap_task_post_setuid(...) calls
> cap_drop_fs_set(...) and cap_raise_fs_set(...) to change effective set
> of current task
> when (current->fsuid != old_ruid).
> 
> In linux-2.4.x the story is the same.
> 
> In file include/linux/capability.h CAP_FS_MASK is defined to contain
> CAP_CHOWN, CAP_DAC_OVERRIDE, CAP_DAC_READ_SEARCH, CAP_FOWNER, CAP_FSETID
> capabilities.
> 
> And in file fs/nfsd/auth.c CAP_NFSD_MASK is defined to be same as CAP_FS_MASK
> plus CAP_SYS_RESOURCE.
> 
> In file fs/nfsd/auth.c function nfsd_setuser(...) uses CAP_NFSD_MASK
> to add/exclude corresponding capabilities to/from effective set of current
> nfsd process.
> 
> And CAP_FS_MASK used in file kernel/sys.c in function sys_setfsuid(...)
> to add/exclude corresponding capabilities to/from effective set of current task.
> 
> This can be exploited (and I have succesfully tried it).
> 
> Suppose you have NFS-share exported even with root_squash option.
> If one client was compromised, local root can set CAP_MKNOD to some
> local user's process. Then that user can execute mknod to create a device
> that will be owned by that user, e.g. block device file for /dev/hda hard drive.
> 
> And he can create that device file on NFS-share (even exported with root_squash
> option). After that he can someway (ssh, cgi) execute code on another nfs client
> or the server to modify it's filesystem. It will be possible because
> he owns that
> device file on nfs share.
> 
> The problem is because CAP_MKNOD allows that user to successfully execute
> vfs_mknod(...) function on local host, and that function will call corresponding
> function in nfs module which sends request to NFS server. And nfsd will not
> drop CAP_MKNOD in nfsd_setuser(...) function when impersonating to that user.
> 
> Of course, NFS-shares can be mounted with nodev option, but they should be
> placed on separate partition on NFS-server, so even on server that partition
> is mounted with nodev option too.
> 
> So I suggest to add CAP_MKNOD and CAP_LINUX_IMMUTABLE to CAP_FS_MASK
> in linux-2.4.x and to CAP_FS_MASK_B0 in linux-2.6.x.
