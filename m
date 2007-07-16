Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbXGPSbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbXGPSbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXGPSbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:31:15 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:42798 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbXGPSbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:31:14 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Jul 2007 00:24:23 +0530
Message-Id: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] utime(s): Honour CAP_FOWNER when times==NULL

do_utimes() does not honour CAP_FOWNER when times==NULL.
Trivial and obvious one-line fix.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

BTW this bug was hidden by the fact that we call vfs_permission() from the
code below (for) this condition. vfs_permission() inevitably degenerates to
generic_permission() which returns 0 (success) for CAP_DAC_OVERRIDE.

However, a privileged process that has released CAP_DAC_OVERRIDE (but carries
CAP_FOWNER) would still get bit by this issue. There is a sample userspace
program (with instructions on how to reproduce) available at:

http://www.cse.iitk.ac.in/users/ssatyam/test.c

 fs/utimes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index b3c8895..83a7e69 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -106,7 +106,7 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
                 if (IS_IMMUTABLE(inode))
                         goto dput_and_out;
 
-		if (current->fsuid != inode->i_uid) {
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
 			if (f) {
 				if (!(f->f_mode & FMODE_WRITE))
 					goto dput_and_out;
