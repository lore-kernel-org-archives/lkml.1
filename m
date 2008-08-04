Return-Path: <linux-kernel-owner+w=401wt.eu-S1761199AbYHDWaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199AbYHDWaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYHDW3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:29:49 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:54406 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751693AbYHDW3r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:29:47 -0400
X-BigFish: VPS-47(zz1432R98dR936eQ1419M1805M936fQzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4897837B.3070605@am.sony.com>
Date: Mon, 4 Aug 2008 15:32:27 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080802163848.GB30454@fieldses.org> <20080804155237.1f64892d@surf> <20080804181641.GE25940@fieldses.org> <48974973.6000408@am.sony.com> <20080804182532.GF25940@fieldses.org>
In-Reply-To: <20080804182532.GF25940@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 04 Aug 2008 22:29:32.0721 (UTC) FILETIME=[91317210:01C8F681]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields wrote:
> On Mon, Aug 04, 2008 at 11:24:51AM -0700, Tim Bird wrote:
>> J. Bruce Fields wrote:
>>> On Mon, Aug 04, 2008 at 03:52:37PM +0200, Thomas Petazzoni wrote:
>>>> Le Sat, 2 Aug 2008 12:38:48 -0400,
>>>> "J. Bruce Fields" <bfields@fieldses.org> a écrit :
>>>>
>>>>> Out of curiosity, why does the nfs client need disabling, but not
>>>>> nfsd, gfs2, fuse, etc.?
>>>> Then also need disabling.
>>> OK by me, but again, why exactly?  Since you're replacing the locking
>>> calls they used by stubs that just return errors, in theory nfs, nfsd,
>>> gfs2, and the rest should still compile and run, just without locking
>>> support, right?
>> I think so, but haven't tested this myself.
>>
>> However, I would still be inclined to NOT add the extra config
>> dependencies.  Just my 2 cents.
> 
> OK.  My fear was that there was some good reason that the nfs dependency
> was added in the first place, and that it's since been lost....

For general information,  I just ran a test with the NFS dependency
on file locking turned off, and with the NFS auto-enable of
CONFIG_LOCKD removed.

It got me about a 16K savings, and I was able to successfully boot
a target with an NFS-mounted root file system.  I haven't run extensive
tests, so I don't know what apps might break in this configuration,
but at least in this test, it ran well enough to boot the machine.

Below is the patch I used, which is only provided for information.
This should NOT be applied - it consists of quick hacks to test this
configuration only (that is, to test NFS with CONFIG_FILE_LOCKING=n).

BTW - this is on a 2.6.23 kernel, so even the regular FILE_LOCKING
bits may be different from the current no-file-locking patch.

---
 fs/Kconfig         |    3 +--
 fs/nfs/client.c    |    6 ++++++
 fs/nfs/nfs3proc.c  |    4 ++++
 fs/nfs/proc.c      |    4 ++++
 fs/read_write.c    |    2 ++
 include/linux/fs.h |   13 +++++++------
 6 files changed, 24 insertions(+), 8 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1701,8 +1701,7 @@ menu "Network File Systems"

 config NFS_FS
 	tristate "NFS file system support"
-	depends on INET && FILE_LOCKING
-	select LOCKD
+	depends on INET
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
 	help
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -414,6 +414,7 @@ static void nfs_destroy_server(struct nf
 		lockd_down();	/* release rpc.lockd */
 }

+#ifdef LOCKD
 /*
  * Version 2 or 3 lockd setup
  */
@@ -434,6 +435,7 @@ static int nfs_start_lockd(struct nfs_se
 out:
 	return error;
 }
+#endif

 /*
  * Initialise an NFSv3 ACL client connection
@@ -577,9 +579,11 @@ static int nfs_init_server(struct nfs_se
 	server->acdirmax = data->acdirmax * HZ;

 	/* Start lockd here, before we might error out */
+#ifdef LOCKD
 	error = nfs_start_lockd(server);
 	if (error < 0)
 		goto error;
+#endif

 	error = nfs_init_server_rpcclient(server, data->pseudoflavor);
 	if (error < 0)
@@ -1128,9 +1132,11 @@ struct nfs_server *nfs_clone_server(stru
 		(unsigned long long) server->fsid.major,
 		(unsigned long long) server->fsid.minor);

+#ifdef LOCKD
 	error = nfs_start_lockd(server);
 	if (error < 0)
 		goto out_free_server;
+#endif

 	spin_lock(&nfs_client_lock);
 	list_add_tail(&server->client_link, &server->nfs_client->cl_superblocks);
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -795,7 +795,11 @@ static void nfs3_proc_commit_setup(struc
 static int
 nfs3_proc_lock(struct file *filp, int cmd, struct file_lock *fl)
 {
+#ifdef LOCKD
 	return nlmclnt_proc(filp->f_path.dentry->d_inode, cmd, fl);
+#else
+	return -ENOLCK;
+#endif
 }

 const struct nfs_rpc_ops nfs_v3_clientops = {
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -605,7 +605,11 @@ nfs_proc_commit_setup(struct nfs_write_d
 static int
 nfs_proc_lock(struct file *filp, int cmd, struct file_lock *fl)
 {
+#ifdef LOCKD
 	return nlmclnt_proc(filp->f_path.dentry->d_inode, cmd, fl);
+#else
+	return -ENOLCK;
+#endif
 }


--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -211,6 +211,7 @@ int rw_verify_area(int read_write, struc
 	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
 		goto Einval;

+#ifdef FILE_LOCKING
 	if (unlikely(inode->i_flock && MANDATORY_LOCK(inode))) {
 		int retval = locks_mandatory_area(
 			read_write == READ ? FLOCK_VERIFY_READ : FLOCK_VERIFY_WRITE,
@@ -218,6 +219,7 @@ int rw_verify_area(int read_write, struc
 		if (retval < 0)
 			return retval;
 	}
+#endif
 	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;

 Einval:
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -863,10 +863,6 @@ extern int fcntl_setlk64(unsigned int, s
 extern int fcntl_setlease(unsigned int fd, struct file *filp, long arg);
 extern int fcntl_getlease(struct file *filp);

-/* fs/sync.c */
-extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
-			loff_t endbyte, unsigned int flags);
-
 /* fs/locks.c */
 extern void locks_init_lock(struct file_lock *);
 extern void locks_copy_lock(struct file_lock *, struct file_lock *);
@@ -918,6 +914,10 @@ extern int lock_may_write(struct inode *
 #define steal_locks(a)
 #endif /* !CONFIG_FILE_LOCKING */

+/* fs/sync.c */
+extern int do_sync_mapping_range(struct address_space *mapping, loff_t offset,
+			loff_t endbyte, unsigned int flags);
+
 struct fasync_struct {
 	int	magic;
 	int	fa_fd;
@@ -1424,8 +1424,6 @@ static inline int locks_verify_locked(st
 	return 0;
 }

-extern int rw_verify_area(int, struct file *, loff_t *, size_t);
-
 static inline int locks_verify_truncate(struct inode *inode,
 				    struct file *filp,
 				    loff_t size)
@@ -1459,6 +1457,9 @@ static inline int break_lease(struct ino

 #endif /* !CONFIG_FILE_LOCKING */

+extern int rw_verify_area(int, struct file *, loff_t *, size_t);
+
+
 /* fs/open.c */

 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,



=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

