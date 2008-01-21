Return-Path: <linux-kernel-owner+w=401wt.eu-S1761514AbYAUKKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761514AbYAUKKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759750AbYAUKCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759621AbYAUKC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:29 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabio Massimo Di Nitto <fabbione@ubuntu.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/58] [GFS2] Check for installation of mount helpers for DLM mounts
Date: Mon, 21 Jan 2008 09:21:41 +0000
Message-Id: <12009073803732-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907378664-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
Message-Id: <d9520a457c5ffccfc49dc541c32504a8229e0add.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Massimo Di Nitto <fabbione@ubuntu.com>

The patch is a fix to abort mount if the mount.gfs* and possible
umount.* are missing from /sbin.

While we do what we can to guarantee that they are installed properly in
userland (CVS HEAD), we want to make sure that mount still aborts properly.

The only sign of missing helpers is that lock_dlm will receive no mount options
at all. According to David the problem does not exist for lock_nolock as the
helpers are not required.

The patch has been tested for both gfs and gfs2 and it works as expected. The
lack of mount.gfs* will generate an error that is propagated to mount:

oot@node1:~# mount -t  gfs2 /dev/nbd2 /mnt/
mount: wrong fs type, bad option, bad superblock on /dev/nbd2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

[ 3513.303346] GFS2: fsid=: Trying to join cluster "lock_dlm", "gutsy:gfs2"
[ 3513.304546] DLM/GFS2/GFS ERROR: (u)mount helpers are not installed properly!
[ 3513.306290] GFS2: fsid=: can't mount proto=lock_dlm, table=gutsy:gfs2, hostdata=

You might want to notice that it will also avoid mount to hang or fail silently
or with strange errors that will require the cluster to reboot/restart before
you can actually mount the filesystem again.

Signed-off-by: Fabio M. Di Nitto <fabbione@ubuntu.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index 41c5b04..ab30102 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -67,6 +67,12 @@ static int make_args(struct gdlm_ls *ls, char *data_arg, int *nodir)
 	memset(data, 0, 256);
 	strncpy(data, data_arg, 255);
 
+	if (!strlen(data)) {
+		printk(KERN_ERR
+		       "DLM/GFS2/GFS ERROR: (u)mount helpers are not installed!\n");
+		return -EINVAL;
+	}
+
 	for (options = data; (x = strsep(&options, ":")); ) {
 		if (!*x)
 			continue;
-- 
1.5.1.2

