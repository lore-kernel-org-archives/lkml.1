Return-Path: <linux-kernel-owner+w=401wt.eu-S934813AbYBGVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934813AbYBGVC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762365AbYBGUwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:45599 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933261AbYBGUwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:09 -0500
Date: Thu, 7 Feb 2008 12:47:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mszeredi@suse.cz, oleg@tv-sign.ru
Subject: [patch 25/45] sys_remap_file_pages: fix ->vm_file accounting
Message-ID: <20080207204737.GZ16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sys_remap_file_pages-fix-vm_file-accounting.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oleg Nesterov <oleg@tv-sign.ru>

patch 8a459e44ad837018ea5c34a9efe8eb4ad27ded26 in mainline.

Fix ->vm_file accounting, mmap_region() may do do_munmap().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 mm/fremap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -190,10 +190,13 @@ asmlinkage long sys_remap_file_pages(uns
 		 */
 		if (mapping_cap_account_dirty(mapping)) {
 			unsigned long addr;
+			struct file *file = vma->vm_file;
 
 			flags &= MAP_NONBLOCK;
-			addr = mmap_region(vma->vm_file, start, size,
+			get_file(file);
+			addr = mmap_region(file, start, size,
 					flags, vma->vm_flags, pgoff, 1);
+			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
 			} else {

-- 
