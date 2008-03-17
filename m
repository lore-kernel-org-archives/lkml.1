Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbYCQUDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbYCQUDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYCQUCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:02:33 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51457 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbYCQUCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:02:31 -0400
Message-Id: <20080317200053.447640802@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 17 Mar 2008 21:00:53 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/11] mount ownership and unprivileged mount syscall (v9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Al,

Please consider adding this series to your trees.

I've been using these patches for a while on my laptop to mount fuse
filesystems as user, without any suid-root helpers.  The setup is as
follows:

- link /proc/mounts to /etc/mtab
- patch util-linux-ng with http://lkml.org/lkml/2008/1/16/103
- remove suid from mount, umount and fusermount
- add a line to /etc/fstab to bind mount ~/mnt onto itself owned by the user
- add 'fs.types.fuse.usermount_safe = 1' to /etc/sysctl.conf

Apart from '/dev/sda2' being replaced with '/dev/root' in 'mount' and
'df' outputs, I haven't experienced any problems.

Thanks,
Miklos

v8 -> v9

 - new patch: copy mount ownership when cloning the mount namespace

v7 -> v8

 - extend documentation of allow_usermount sysctl tunable
 - describe new unprivileged mounting in fuse.txt

v6 -> v7:

 - add '/proc/sys/fs/types/<type>/usermount_safe' tunable (new patch)
 - do not make FUSE safe by default, describe possible problems
   associated with unprivileged FUSE mounts in patch header
 - return EMFILE instead of EPERM, if maximum user mount count is exceeded
 - rename option 'nomnt' -> 'nosubmnt'
 - clean up error propagation in dup_mnt_ns
 - update util-linux-ng patch

v5 -> v6:

 - update to latest -mm
 - preliminary util-linux-ng support (will post right after this series)

v4 -> v5:

 - fold back Andrew's changes
 - fold back my update patch:
    o use fsuid instead of ruid
    o allow forced unpriv. unmounts for "safe" filesystems
    o allow mounting over special files, but not over symlinks
    o set nosuid and nodev based on lack of specific capability
 - patch header updates
 - new patch: on propagation inherit owner from parent
 - new patch: add "no submounts" mount flag

v3 -> v4:

 - simplify interface as much as possible, now only a single option
   ("user=UID") is used to control everything
 - no longer allow/deny mounting based on file/directory permissions,
   that approach does not always make sense

v1 -> v3:

 - add mount flags to set/clear mnt_flags individually
 - add "usermnt" mount flag.  If it is set, then allow unprivileged
   submounts under this mount
 - make max number of user mounts default to 1024, since now the
   usermnt flag will prevent user mounts by default

--

