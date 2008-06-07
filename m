Return-Path: <linux-kernel-owner+w=401wt.eu-S1764498AbYFGBZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764498AbYFGBZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbYFGBJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:48 -0400
Received: from sous-sol.org ([216.99.217.87]:42566 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760157AbYFGBJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:32 -0400
Message-Id: <20080607010633.579099367@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 44/50] brk: make sys_brk() honor COMPAT_BRK when computing lower bound
Content-Disposition: inline; filename=brk-make-sys_brk-honor-compat_brk-when-computing-lower-bound.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jiri Kosina <jkosina@suse.cz>

upstream commit: a5b4592cf77b973c29e7c9695873a26052b58951

Fix a regression introduced by

commit 4cc6028d4040f95cdb590a87db478b42b8be0508
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Wed Feb 6 22:39:44 2008 +0100

    brk: check the lower bound properly

The check in sys_brk() on minimum value the brk might have must take
CONFIG_COMPAT_BRK setting into account.  When this option is turned on
(i.e.  we support ancient legacy binaries, e.g.  libc5-linked stuff), the
lower bound on brk value is mm->end_code, otherwise the brk start is
allowed to be arbitrarily shifted.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 mm/mmap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -242,10 +242,16 @@ asmlinkage unsigned long sys_brk(unsigne
 	unsigned long rlim, retval;
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
+	unsigned long min_brk;
 
 	down_write(&mm->mmap_sem);
 
-	if (brk < mm->start_brk)
+#ifdef CONFIG_COMPAT_BRK
+	min_brk = mm->end_code;
+#else
+	min_brk = mm->start_brk;
+#endif
+	if (brk < min_brk)
 		goto out;
 
 	/*

-- 
