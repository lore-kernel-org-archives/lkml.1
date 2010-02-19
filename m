Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab0BSRBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:08 -0500
Received: from kroah.org ([198.145.64.141]:57689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab0BSRAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:53 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:47 2010
Message-Id: <20100219163246.986567189@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wu Fengguang <fengguang.wu@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [59/93] devmem: check vmalloc address on kmem read/write
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 325fda71d0badc1073dc59f12a948f24ff05796a

[ cebbert@redhat.com : backport to 2.6.32 ]

devmem: check vmalloc address on kmem read/write

Otherwise vmalloc_to_page() will BUG().

This also makes the kmem read/write implementation aligned with mem(4):
"References to nonexistent locations cause errors to be returned." Here we
return -ENXIO (inspired by Hugh) if no bytes have been transfered to/from
user space, otherwise return partial read/write results.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/mem.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -421,6 +421,7 @@ static ssize_t read_kmem(struct file *fi
 	unsigned long p = *ppos;
 	ssize_t low_count, read, sz;
 	char * kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
+	int err = 0;
 
 	read = 0;
 	if (p < (unsigned long) high_memory) {
@@ -469,12 +470,16 @@ static ssize_t read_kmem(struct file *fi
 		while (count > 0) {
 			int len = size_inside_page(p, count);
 
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			len = vread(kbuf, (char *)p, len);
 			if (!len)
 				break;
 			if (copy_to_user(buf, kbuf, len)) {
-				free_page((unsigned long)kbuf);
-				return -EFAULT;
+				err = -EFAULT;
+				break;
 			}
 			count -= len;
 			buf += len;
@@ -483,8 +488,8 @@ static ssize_t read_kmem(struct file *fi
 		}
 		free_page((unsigned long)kbuf);
 	}
- 	*ppos = p;
- 	return read;
+	*ppos = p;
+	return read ? read : err;
 }
 
 
@@ -553,6 +558,7 @@ static ssize_t write_kmem(struct file *
 	ssize_t virtr = 0;
 	ssize_t written;
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
+	int err = 0;
 
 	if (p < (unsigned long) high_memory) {
 
@@ -576,13 +582,15 @@ static ssize_t write_kmem(struct file *
 		while (count > 0) {
 			int len = size_inside_page(p, count);
 
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			if (len) {
 				written = copy_from_user(kbuf, buf, len);
 				if (written) {
-					if (wrote + virtr)
-						break;
-					free_page((unsigned long)kbuf);
-					return -EFAULT;
+					err = -EFAULT;
+					break;
 				}
 			}
 			len = vwrite(kbuf, (char *)p, len);
@@ -594,8 +602,8 @@ static ssize_t write_kmem(struct file *
 		free_page((unsigned long)kbuf);
 	}
 
- 	*ppos = p;
- 	return virtr + wrote;
+	*ppos = p;
+	return virtr + wrote ? : err;
 }
 #endif
 


