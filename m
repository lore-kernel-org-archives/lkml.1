Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZDWHi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZDWHi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbZDWHaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:30:07 -0400
Received: from sous-sol.org ([216.99.217.87]:50331 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756301AbZDWHaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:30:04 -0400
Message-Id: <20090423072421.260460544@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 032/100] mm: do_xip_mapping_read: fix length calculation
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=mm-do_xip_mapping_read-fix-length-calculation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

upstream commit: 58984ce21d315b70df1a43644df7416ea7c9bfd8

The calculation of the value nr in do_xip_mapping_read is incorrect.  If
the copy required more than one iteration in the do while loop the copies
variable will be non-zero.  The maximum length that may be passed to the
call to copy_to_user(buf+copied, xip_mem+offset, nr) is len-copied but the
check only compares against (nr > len).

This bug is the cause for the heap corruption Carsten has been chasing
for so long:

*** glibc detected *** /bin/bash: free(): invalid next size (normal): 0x00000000800e39f0 ***
======= Backtrace: =========
/lib64/libc.so.6[0x200000b9b44]
/lib64/libc.so.6(cfree+0x8e)[0x200000bdade]
/bin/bash(free_buffered_stream+0x32)[0x80050e4e]
/bin/bash(close_buffered_stream+0x1c)[0x80050ea4]
/bin/bash(unset_bash_input+0x2a)[0x8001c366]
/bin/bash(make_child+0x1d4)[0x8004115c]
/bin/bash[0x8002fc3c]
/bin/bash(execute_command_internal+0x656)[0x8003048e]
/bin/bash(execute_command+0x5e)[0x80031e1e]
/bin/bash(execute_command_internal+0x79a)[0x800305d2]
/bin/bash(execute_command+0x5e)[0x80031e1e]
/bin/bash(reader_loop+0x270)[0x8001efe0]
/bin/bash(main+0x1328)[0x8001e960]
/lib64/libc.so.6(__libc_start_main+0x100)[0x200000592a8]
/bin/bash(clearerr+0x5e)[0x8001c092]

With this bug fix the commit 0e4a9b59282914fe057ab17027f55123964bc2e2
"ext2/xip: refuse to change xip flag during remount with busy inodes" can
be removed again.

Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 mm/filemap_xip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -89,8 +89,8 @@ do_xip_mapping_read(struct address_space
 			}
 		}
 		nr = nr - offset;
-		if (nr > len)
-			nr = len;
+		if (nr > len - copied)
+			nr = len - copied;
 
 		error = mapping->a_ops->get_xip_mem(mapping, index, 0,
 							&xip_mem, &xip_pfn);

