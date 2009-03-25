Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbZCYANX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbZCYANX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZCYANM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:13:12 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:51155 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbZCYANL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:13:11 -0400
Date: Wed, 25 Mar 2009 01:13:03 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dann frazier <dannf@dannf.org>, linux-mips@linux-mips.org
Subject: [PATCH 1/2] fs: Fix sign extension problem in sys_llseek
Message-ID: <20090325001303.GB24026@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/read_write.c:

SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
                unsigned long, offset_low, loff_t __user *, result,
                unsigned int, origin)
...
   	offset = vfs_llseek(file, ((loff_t) offset_high << 32) | offset_low,
                        origin);

On a 64-bit system that define CONFIG_HAVE_SYSCALL_WRAPPERS SYSCALL_DEFINEx
will truncate long arguments to 32-bit and on some architectures such as
MIPS sign-extended to 64-bit again.  On such architectures passing a
value with bit 31 in offset_low set will result in a huge 64-bit offset
being passed to vfs_llseek() and it failiing with EINVAL.

The issue was discovered on Debian's MIPS infrastructure machines running
e2fsck:

[...]
                          This was noticed on one of the Debian
infrastructure machines where, after an upgrade, e2fsck began failing
with errors like:

  Error reading block 524290 (Invalid argument) while getting next inode
  from scan.  Ignore error<y>?
[...]

Fixed by changing the prototype to use 32-bit arguments for the higher
and lower half of offset of sys_llseek.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 fs/read_write.c          |    4 ++--
 include/linux/syscalls.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 400fe81..2fb171e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -171,8 +171,8 @@ bad:
 }
 
 #ifdef __ARCH_WANT_SYS_LLSEEK
-SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned long, offset_high,
-		unsigned long, offset_low, loff_t __user *, result,
+SYSCALL_DEFINE5(llseek, unsigned int, fd, unsigned int, offset_high,
+		unsigned int, offset_low, loff_t __user *, result,
 		unsigned int, origin)
 {
 	int retval;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f9f900c..5c593d4 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -444,8 +444,8 @@ asmlinkage long sys_utimes(char __user *filename,
 				struct timeval __user *utimes);
 asmlinkage long sys_lseek(unsigned int fd, off_t offset,
 			  unsigned int origin);
-asmlinkage long sys_llseek(unsigned int fd, unsigned long offset_high,
-			unsigned long offset_low, loff_t __user *result,
+asmlinkage long sys_llseek(unsigned int fd, unsigned int offset_high,
+			unsigned int offset_low, loff_t __user *result,
 			unsigned int origin);
 asmlinkage long sys_read(unsigned int fd, char __user *buf, size_t count);
 asmlinkage long sys_readahead(int fd, loff_t offset, size_t count);
