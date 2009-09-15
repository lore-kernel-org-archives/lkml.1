Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZIODLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZIODLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 23:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758042AbZIODLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 23:11:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49296 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbZIODLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 23:11:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Sep 2009 12:09:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] /proc/kmem cleanups and hwpoison bits
Message-Id: <20090915120939.bcc571e1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090915021851.168285585@intel.com>
References: <20090915021851.168285585@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 10:18:51 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Hi Kame,
> 
> Here are 3 more kmem patches in my queue. Comments are welcome.
> If you feel good about them, I can send all recent kmem cleanup
> patches for you.
> 

This is my quick hack. But I don't want to be an obstacle for you.
So, I'll wait for your updates.

==
Now, /dev/kmem's read/write vmalloc area doesn't do
range-check. Because vread/vwrite traverse vmalloc area list
under system-wide spinlock, it's better to avoid unnecessary
to do unnecessary calls to vread/vwrite.

And, vread/vwrite returns 0 if we accessed memory holes.
We can avoid copy-to-user in read side, we just ignore at write.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 drivers/char/mem.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

Index: linux-2.6.31/drivers/char/mem.c
===================================================================
--- linux-2.6.31.orig/drivers/char/mem.c
+++ linux-2.6.31/drivers/char/mem.c
@@ -437,17 +437,19 @@ static ssize_t read_kmem(struct file *fi
 	}
 
 	if (count > 0) {
-		kbuf = (char *)__get_free_page(GFP_KERNEL);
+		kbuf = (char *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
 			sz = size_inside_page(p, count);
-			sz = vread(kbuf, (char *)p, sz);
-			if (!sz)
-				break;
-			if (copy_to_user(buf, kbuf, sz)) {
-				free_page((unsigned long)kbuf);
-				return -EFAULT;
+			if (is_vmalloc_or_module_addr((void*)p)) {
+				/* returns Non-zero if a page is found */
+				if (vread(kbuf, (char *)p, sz))
+					if (copy_to_user(buf, kbuf, sz)) {
+						free_page((unsigned long)kbuf);
+						return -EFAULT;
+					}
+				}
 			}
 			count -= sz;
 			buf += sz;
@@ -541,6 +543,11 @@ static ssize_t write_kmem(struct file * 
 			unsigned long sz = size_inside_page(p, count);
 			unsigned long n;
 
+			if (is_vmalloc_or_module_addr((void*)p)) {
+				free_page((unsignedl long)kbuf);
+				retrun -EFAULT;
+			}
+
 			n = copy_from_user(kbuf, buf, sz);
 			if (n) {
 				if (wrote + virtr)
@@ -548,7 +555,11 @@ static ssize_t write_kmem(struct file * 
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			sz = vwrite(kbuf, (char *)p, sz);
+			/*
+			 * returns non-zero if copied successfully....
+			 * But we don't care it. just make a progress.
+			 */
+			vwrite(kbuf, (char *)p, sz);
 			count -= sz;
 			buf += sz;
 			virtr += sz;


