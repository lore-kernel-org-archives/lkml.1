Return-Path: <linux-kernel-owner+w=401wt.eu-S936155AbZAOWds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936155AbZAOWds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933934AbZAOWDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:03:33 -0500
Received: from kroah.org ([198.145.64.141]:38807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932455AbZAOWDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:03:30 -0500
Date: Thu, 15 Jan 2009 14:01:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 56/85] [PATCH 36/44] [CVE-2009-0029] System call wrappers
	part 26
Message-ID: <20090115220103.GE17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0036--CVE-2009-0029-System-call-wrappers-part-26.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit c4ea37c26a691ad0b7e86aa5884aab27830e95c9 upstream.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/syscall.c |   12 ++++--------
 ipc/mqueue.c          |   22 +++++++++++-----------
 kernel/sys.c          |    4 ++--
 mm/swapfile.c         |    4 ++--
 4 files changed, 19 insertions(+), 23 deletions(-)

--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -14,10 +14,8 @@
 #include <asm/uaccess.h>
 #include "pci.h"
 
-asmlinkage long
-sys_pciconfig_read(unsigned long bus, unsigned long dfn,
-		   unsigned long off, unsigned long len,
-		   void __user *buf)
+SYSCALL_DEFINE5(pciconfig_read, unsigned long, bus, unsigned long, dfn,
+		unsigned long, off, unsigned long, len, void __user *, buf)
 {
 	struct pci_dev *dev;
 	u8 byte;
@@ -86,10 +84,8 @@ error:
 	return err;
 }
 
-asmlinkage long
-sys_pciconfig_write(unsigned long bus, unsigned long dfn,
-		    unsigned long off, unsigned long len,
-		    void __user *buf)
+SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
+		unsigned long, off, unsigned long, len, void __user *, buf)
 {
 	struct pci_dev *dev;
 	u8 byte;
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -808,9 +808,9 @@ static inline void pipelined_receive(str
 	sender->state = STATE_READY;
 }
 
-asmlinkage long sys_mq_timedsend(mqd_t mqdes, const char __user *u_msg_ptr,
-	size_t msg_len, unsigned int msg_prio,
-	const struct timespec __user *u_abs_timeout)
+SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
+		size_t, msg_len, unsigned int, msg_prio,
+		const struct timespec __user *, u_abs_timeout)
 {
 	struct file *filp;
 	struct inode *inode;
@@ -896,9 +896,9 @@ out:
 	return ret;
 }
 
-asmlinkage long sys_mq_timedreceive(mqd_t mqdes, char __user *u_msg_ptr,
-	size_t msg_len, unsigned int __user *u_msg_prio,
-	const struct timespec __user *u_abs_timeout)
+SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
+		size_t, msg_len, unsigned int __user *, u_msg_prio,
+		const struct timespec __user *, u_abs_timeout)
 {
 	long timeout;
 	ssize_t ret;
@@ -981,8 +981,8 @@ out:
  * and he isn't currently owner of notification, will be silently discarded.
  * It isn't explicitly defined in the POSIX.
  */
-asmlinkage long sys_mq_notify(mqd_t mqdes,
-				const struct sigevent __user *u_notification)
+SYSCALL_DEFINE2(mq_notify, mqd_t, mqdes,
+		const struct sigevent __user *, u_notification)
 {
 	int ret;
 	struct file *filp;
@@ -1107,9 +1107,9 @@ out:
 	return ret;
 }
 
-asmlinkage long sys_mq_getsetattr(mqd_t mqdes,
-			const struct mq_attr __user *u_mqstat,
-			struct mq_attr __user *u_omqstat)
+SYSCALL_DEFINE3(mq_getsetattr, mqd_t, mqdes,
+		const struct mq_attr __user *, u_mqstat,
+		struct mq_attr __user *, u_omqstat)
 {
 	int ret;
 	struct mq_attr mqstat, omqstat;
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1634,8 +1634,8 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
-asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
-			  unsigned long arg4, unsigned long arg5)
+SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
+		unsigned long, arg4, unsigned long, arg5)
 {
 	long error = 0;
 
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1204,7 +1204,7 @@ int page_queue_congested(struct page *pa
 }
 #endif
 
-asmlinkage long sys_swapoff(const char __user * specialfile)
+SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct * p = NULL;
 	unsigned short *swap_map;
@@ -1448,7 +1448,7 @@ __initcall(procswaps_init);
  *
  * The swapon system call
  */
-asmlinkage long sys_swapon(const char __user * specialfile, int swap_flags)
+SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct * p;
 	char *name = NULL;

