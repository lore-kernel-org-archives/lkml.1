Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbZENWzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbZENWzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbZENWms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:48 -0400
Received: from kroah.org ([198.145.64.141]:52559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbZENWm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:26 2009
Message-Id: <20090514223526.055032602@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:10 -0700
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
       alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 35/51] NFS: Close page_mkwrite() races
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=nfs-close-page_mkwrite-races.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 7fdf523067666b0eaff330f362401ee50ce187c4 upstream.

Follow up to Nick Piggin's patches to ensure that nfs_vm_page_mkwrite
returns with the page lock held, and sets the VM_FAULT_LOCKED flag.

See http://bugzilla.kernel.org/show_bug.cgi?id=12913

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -481,10 +481,10 @@ static int nfs_vm_page_mkwrite(struct vm
 
 	ret = nfs_updatepage(filp, page, 0, pagelen);
 out_unlock:
+	if (!ret)
+		return VM_FAULT_LOCKED;
 	unlock_page(page);
-	if (ret)
-		ret = VM_FAULT_SIGBUS;
-	return ret;
+	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct nfs_file_vm_ops = {


