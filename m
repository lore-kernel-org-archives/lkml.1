Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbXJVMh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbXJVMh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbXJVMhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:37:13 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51641 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752364AbXJVMhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:37:12 -0400
Message-ID: <393056632.00561@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 22 Oct 2007 20:37:07 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 100% iowait on one of cpus in current -git
Message-ID: <20071022123707.GA4240@mail.ustc.edu.cn>
References: <200710220822.52370.maximlevitsky@gmail.com> <200710221258.11384.maximlevitsky@gmail.com> <393051953.24752@ustc.edu.cn> <200710221421.21439.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710221421.21439.maximlevitsky@gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 02:21:21PM +0200, Maxim Levitsky wrote:
> I Bisected this bug to exactly this commit:
> 
> 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b
> writeback: introduce writeback_control.more_io to indicate more io
> 
> Reverting it and compiling latest git shows no more signs of that bug.

Thank you very much.

I guess your system has some difficulty in writing back some inodes.
(i.e. a bug disclosed by this patch, the 100% iowait only makes it
more obvious)

I cannot reproduce it with your .config, so would you recompile and
run the kernel with the above commit _and_ the below debugging patch?

Thank you,
Fengguang
---

 fs/fs-writeback.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- linux-2.6.23-git17.orig/fs/fs-writeback.c
+++ linux-2.6.23-git17/fs/fs-writeback.c
@@ -164,12 +164,25 @@ static void redirty_tail(struct inode *i
 	list_move(&inode->i_list, &sb->s_dirty);
 }
 
+#define requeue_io(inode)						\
+	do {								\
+		__requeue_io(inode, __LINE__);				\
+	} while (0)
+
 /*
  * requeue inode for re-scanning after sb->s_io list is exhausted.
  */
-static void requeue_io(struct inode *inode)
+static void __requeue_io(struct inode *inode, int line)
 {
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+
+	printk(KERN_DEBUG "redirtied inode %lu size %llu at %02x:%02x(%s), line %d.\n",
+			inode->i_ino,
+			i_size_read(inode),
+			MAJOR(inode->i_sb->s_dev),
+			MINOR(inode->i_sb->s_dev),
+			inode->i_sb->s_id,
+			line);
 }
 
 static void inode_sync_complete(struct inode *inode)

