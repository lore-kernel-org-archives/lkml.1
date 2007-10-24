Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbXJXRZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbXJXRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXJXRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:25:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51117 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbXJXRZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:25:06 -0400
Date: Wed, 24 Oct 2007 10:21:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@redhat.com,
       torvalds@linux-foundation.org, viro@ftp.linux.org.uk
Subject: Re: [2.6 patch] unexport sys_{open,read}
Message-ID: <20071024102151.54bb1749@laptopd505.fenrus.org>
In-Reply-To: <20071024162434.GL30533@stusta.de>
References: <20071024162434.GL30533@stusta.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 18:24:34 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> sys_{open,read} can finally be unexported.

how about giving it a proper changelog like this:


From: Adrian Bunk <bunk@kernel.org>
Subject: unexport sys_open and sys_read

sys_open / sys_read were used in the early 1.2 days to load firmware from
disk inside drivers. Since 2.0 or so this was deprecated behavior, but
several drivers still were using this. Since a few years we have a
request_firmware() API that implements this in a nice, consistent way. Only
some old ISA sound drivers (pre-ALSA) still straggled along for some
time.... however with commit c2b1239a9f22f19c53543b460b24507d0e21ea0c the
last user is now gone.

This is a good thing, since using sys_open / sys_read etc for firmware is a
very buggy to dangerous thing to do; these operations put an fd in the
process file descriptor table.... which then can be tampered with from other
threads for example. For those who don't want the firmware loader,
open_filp()/vfs_read are the better APIs to use, without this security
issue.

The patch below finally exports sys_open and sys_read now that they're
really not used anymore.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Alan Cox <alan@redhat.com>

---

 fs/open.c       |    1 -
 fs/read_write.c |    1 -
 2 files changed, 2 deletions(-)

Index: linux-2.6.23-git8/fs/open.c
===================================================================
--- linux-2.6.23-git8.orig/fs/open.c
+++ linux-2.6.23-git8/fs/open.c
@@ -1056,7 +1056,6 @@ asmlinkage long sys_open(const char __us
 	prevent_tail_call(ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_open);
 
 asmlinkage long sys_openat(int dfd, const char __user *filename, int flags,
 			   int mode)
Index: linux-2.6.23-git8/fs/read_write.c
===================================================================
--- linux-2.6.23-git8.orig/fs/read_write.c
+++ linux-2.6.23-git8/fs/read_write.c
@@ -370,7 +370,6 @@ asmlinkage ssize_t sys_read(unsigned int
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sys_read);
 
 asmlinkage ssize_t sys_write(unsigned int fd, const char __user * buf, size_t count)
 {
