Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0CITLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:11:33 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:57429 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab0CITLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:11:31 -0500
Date: Tue, 9 Mar 2010 12:11:27 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Tejun Heo <tj@kernel.org>
Subject: [PATCH] sysfs: Fixup broken chown tracking
Message-ID: <20100309191127.GA30462@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch:

commit ddd29ec6597125c830f7badb608a86c98b936b64
Author: David P. Quigley <dpquigl@tycho.nsa.gov>
Date:   Wed Sep 9 14:25:37 2009 -0400

    sysfs: Add labeling support for sysfs

Introduced a bug into the way sysfs handles attribute changes from user
space. Booting a kernel straight to busy box:

Linux version 2.6.33-rc8-00033-g5e96a56-dirty (jgg@bertha1) (gcc version 3.4.4) #37 Tue Mar 9 11:
[..]
Freeing unused kernel memory: 1184k init
BusyBox v1.1.0 (2006.12.14-23:35+0000) Built-in shell (ash)
/empty # chown 0.301 /sys/devices/system/fpga/fpga0/led_0b
/empty # chmod 0664 /sys/devices/system/fpga/fpga0/led_0b
/empty # ls -l /sys/devices/system/fpga/fpga0/led_0b
-rw-rw-r--    1 0        0            4096 Mar  9 18:44 /sys/devices/system/fpga/fpga0/led_0b

The chown was lost.

The problem seems to stem from moving the check of iattr to be
conditional on the first allocation of the sd_iattr. The chown
call path looks like:

[c308be50] [c00b1db4] sysfs_sd_setattr+0x34/0xf0 (unreliable)
[c308be70] [c00b1ee8] sysfs_setattr+0x78/0xa0
[c308be90] [c0086338] notify_change+0x19c/0x2d4
[c308bec0] [c00707d4] chown_common+0x84/0xa8
[c308bf20] [c007084c] sys_chown+0x54/0x80
[c308bf40] [c000dcf0] ret_from_syscall+0x0/0x3c

And sysfs_sd_setattr goes through the sysfs_init_inode_attrs allocation
path and completely ignores the passed in iattr that contains the
alteration from the chown.

This patch makes the run through the iattr mandatory in all cases - this
seems to solve the problem for me.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 fs/sysfs/inode.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

I've no idea if this is correct for any cases other than this single
one, but there is definitely a nasty bug here.

Hopefully someone more knowledgeable can sort this out :)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 220b758..b36f81c 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -81,24 +81,24 @@ int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
 		if (!sd_attrs)
 			return -ENOMEM;
 		sd->s_iattr = sd_attrs;
-	} else {
-		/* attributes were changed at least once in past */
-		iattrs = &sd_attrs->ia_iattr;
-
-		if (ia_valid & ATTR_UID)
-			iattrs->ia_uid = iattr->ia_uid;
-		if (ia_valid & ATTR_GID)
-			iattrs->ia_gid = iattr->ia_gid;
-		if (ia_valid & ATTR_ATIME)
-			iattrs->ia_atime = iattr->ia_atime;
-		if (ia_valid & ATTR_MTIME)
-			iattrs->ia_mtime = iattr->ia_mtime;
-		if (ia_valid & ATTR_CTIME)
-			iattrs->ia_ctime = iattr->ia_ctime;
-		if (ia_valid & ATTR_MODE) {
-			umode_t mode = iattr->ia_mode;
-			iattrs->ia_mode = sd->s_mode = mode;
-		}
+	}
+
+	/* attributes were changed at least once in past */
+	iattrs = &sd_attrs->ia_iattr;
+
+	if (ia_valid & ATTR_UID)
+		iattrs->ia_uid = iattr->ia_uid;
+	if (ia_valid & ATTR_GID)
+		iattrs->ia_gid = iattr->ia_gid;
+	if (ia_valid & ATTR_ATIME)
+		iattrs->ia_atime = iattr->ia_atime;
+	if (ia_valid & ATTR_MTIME)
+		iattrs->ia_mtime = iattr->ia_mtime;
+	if (ia_valid & ATTR_CTIME)
+		iattrs->ia_ctime = iattr->ia_ctime;
+	if (ia_valid & ATTR_MODE) {
+		umode_t mode = iattr->ia_mode;
+		iattrs->ia_mode = sd->s_mode = mode;
 	}
 	return 0;
 }
-- 
1.5.4.2


