Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZH0OSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZH0OSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZH0OSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:18:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40876 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZH0OSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:18:31 -0400
Date: Thu, 27 Aug 2009 15:18:34 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, linux-man@vger.kernel.org,
       mtk.manpages@gmail.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/3] hugetlbfs: Allow the creation of files suitable
	for MAP_PRIVATE on the vfs internal mount
Message-ID: <20090827141834.GF21183@csn.ul.ie>
References: <cover.1251282769.git.ebmunson@us.ibm.com> <1c66a9e98a73d61c611e5cf09b276e954965046e.1251282769.git.ebmunson@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1c66a9e98a73d61c611e5cf09b276e954965046e.1251282769.git.ebmunson@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 11:44:51AM +0100, Eric B Munson wrote:
> There are two means of creating mappings backed by huge pages:
> 
>         1. mmap() a file created on hugetlbfs
>         2. Use shm which creates a file on an internal mount which essentially
>            maps it MAP_SHARED
> 
> The internal mount is only used for shared mappings but there is very
> little that stops it being used for private mappings. This patch extends
> hugetlbfs_file_setup() to deal with the creation of files that will be
> mapped MAP_PRIVATE on the internal hugetlbfs mount. This extended API is
> used in a subsequent patch to implement the MAP_HUGETLB mmap() flag.
> 

Hi Eric,

I ran these patches through a series of small tests and I have just one
concern with the changes made to can_do_hugetlb_shm(). If that returns false
because of MAP_HUGETLB, we then proceed to call user_shm_lock(). I think your
intention might have been something like the following patch on top of yours?

For what it's worth, once this was applied, I didn't spot any other
problems, run-time or otherwise.

=====
hugetlbfs: Do not call user_shm_lock() for MAP_HUGETLB

The patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
alters can_do_hugetlb_shm() to check if a file is being created for shared
memory or mmap(). If this returns false, we then unconditionally call
user_shm_lock() triggering a warning. This block should never be entered
for MAP_HUGETLB. This patch partially reverts the problem and fixes the check.

This patch should be considered a fix to
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 fs/hugetlbfs/inode.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 49d2bf9..c944cc1 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -910,15 +910,9 @@ static struct file_system_type hugetlbfs_fs_type = {
 
 static struct vfsmount *hugetlbfs_vfsmount;
 
-static int can_do_hugetlb_shm(int creat_flags)
+static int can_do_hugetlb_shm(void)
 {
-	if (creat_flags != HUGETLB_SHMFS_INODE)
-		return 0;
-	if (capable(CAP_IPC_LOCK))
-		return 1;
-	if (in_group_p(sysctl_hugetlb_shm_group))
-		return 1;
-	return 0;
+	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
 struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
@@ -934,7 +928,7 @@ struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag,
 	if (!hugetlbfs_vfsmount)
 		return ERR_PTR(-ENOENT);
 
-	if (!can_do_hugetlb_shm(creat_flags)) {
+	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
 		*user = current_user();
 		if (user_shm_lock(size, *user)) {
 			WARN_ONCE(1,


