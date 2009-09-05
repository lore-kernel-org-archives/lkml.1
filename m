Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZIERHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZIERHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 13:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZIERHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 13:07:13 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47953 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZIERHM (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 13:07:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Miklos Szeredi <mszeredi@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Andreas Gruenbacher <agruen@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org
Subject: vfs-fix-d_path-for-unreachable-paths.patch
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1252160549_2442P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 05 Sep 2009 10:22:29 -0400
Message-ID: <2818.1252160549@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1252160549_2442P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <2802.1252160530.1@turing-police.cc.vt.edu>

This patch apparently does something resembling what it's supposed to - the
first few lines of /proc/mounts now looks like:

% head -5 /proc/mounts
rootfs (unreachable)/ rootfs rw 0 0
/dev/root / ext3 rw,seclabel,noatime,nodiratime,user_xattr,acl,data=writeback,us
rquota,grpquota 0 0
/dev /dev tmpfs rw,seclabel,relatime,mode=755 0 0
/proc /proc proc rw,relatime 0 0
/sys /sys sysfs rw,relatime 0 0

The now-unreachable rootfs is the letftover initrd rootfs.

The patch commentary notes:

> This patch addresses all these issues, by prefixing such unreachable paths
> with "(unreachable)".  This isn't perfect since the returned path may
> still be a valid _relative_ path, and applications may not check the
> result of getcwd() for starting with a '/' before using it.

It turns out that some things don't check the contents of /proc/mounts for
starting with a / before using it either:

# /sbin/restorecon -v /etc/passwd
Full path required for exclude: (unreachable)/.

And strace shows it's a read of /proc/mounts, not a getcwd() call:

....
open("/proc/self/task/11479/attr/current", O_RDONLY) = 3
read(3, "staff_u:sysadm_r:setfiles_t:s0\0"..., 4095) = 31
close(3)                                = 0
uname({sys="Linux", node="turing-police.cc.vt.edu", ...}) = 0
open("/proc/mounts", O_RDONLY)          = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fe
9ce36a000
read(3, "rootfs (unreachable)/ rootfs rw 0"..., 1024) = 1024
write(2, "Full path required for exclude: ("..., 48) = 48

The added "(unreachable) text also gives /etc/rc0.d/S01halt indigestion,
because it thinks it can do stuff like:

awk '$2 !~ /\/(|dev|proc|selinux|sys)$/ && $1 !~ /^\/dev\/ram/ { print $2 }' \
    /proc/mounts | sort -r | \
  while read line; do
    $UMOUNT -f $line
done

Somebody is buggy here, but I'm not sure who. The initrd for leaving a dangling
reference, the patch for breaking /proc/mounts, or /sbin/restorecon and the
shutdown script for being far too trusting of what the kernel tells it?


--==_Exmh_1252160549_2442P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKonQlcC3lWbTT17ARAo6GAKCLayByTEBHIw1CB0mU+OnMkSpXVACgi/wR
a+sKX3a9YFnKLFVUxRi2FxQ=
=IWEf
-----END PGP SIGNATURE-----

--==_Exmh_1252160549_2442P--
