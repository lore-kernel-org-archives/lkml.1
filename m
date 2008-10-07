Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYJGQOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYJGQOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 12:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYJGQON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 12:14:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:10871 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYJGQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 12:14:12 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Date: Tue,  7 Oct 2008 19:15:17 +0300
Message-Id: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.5.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If SHM_MAP_NOT_FIXED specified and shmaddr is not NULL, then the kernel takes
shmaddr as a hint about where to place the mapping. The address of the mapping
is returned as the result of the call.

It's similar to mmap() without MAP_FIXED.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/shm.h |    2 ++
 ipc/shm.c           |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/shm.h b/include/linux/shm.h
index eca6235..fd288eb 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -55,6 +55,8 @@ struct shmid_ds {
 #define	SHM_RND		020000	/* round attach address to SHMLBA boundary */
 #define	SHM_REMAP	040000	/* take-over region on attach */
 #define	SHM_EXEC	0100000	/* execution access */
+#define	SHM_MAP_NOT_FIXED 0200000 /* interpret attach address as a search
+				   * hint */
 
 /* super user shmctl commands */
 #define SHM_LOCK 	11
diff --git a/ipc/shm.c b/ipc/shm.c
index e77ec69..54f3c61 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -819,7 +819,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 	if (shmid < 0)
 		goto out;
 	else if ((addr = (ulong)shmaddr)) {
-		if (addr & (SHMLBA-1)) {
+		if (!(shmflg & SHM_MAP_NOT_FIXED) && (addr & (SHMLBA-1))) {
 			if (shmflg & SHM_RND)
 				addr &= ~(SHMLBA-1);	   /* round down */
 			else
@@ -828,7 +828,8 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 #endif
 					goto out;
 		}
-		flags = MAP_SHARED | MAP_FIXED;
+		flags = MAP_SHARED |
+				(shmflg & SHM_MAP_NOT_FIXED ? 0 : MAP_FIXED);
 	} else {
 		if ((shmflg & SHM_REMAP))
 			goto out;
@@ -892,7 +893,7 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 	sfd->vm_ops = NULL;
 
 	down_write(&current->mm->mmap_sem);
-	if (addr && !(shmflg & SHM_REMAP)) {
+	if (addr && !(shmflg & (SHM_REMAP|SHM_MAP_NOT_FIXED))) {
 		err = -EINVAL;
 		if (find_vma_intersection(current->mm, addr, addr + size))
 			goto invalid;
-- 
1.5.6.5.GIT

