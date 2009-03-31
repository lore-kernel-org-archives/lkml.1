Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbZCaNcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbZCaNcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759979AbZCaNcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:32:39 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62048 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759648AbZCaNch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:32:37 -0400
Date: Tue, 31 Mar 2009 15:32:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Jared Hulbert <jaredeh@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] do_xip_mapping_read: fix length calculation
Message-ID: <20090331153223.74b177bd@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The calculation of the value nr in do_xip_mapping_read is incorrect. If
the copy required more than one iteration in the do while loop the
copies variable will be non-zero. The maximum length that may be passed
to the call to copy_to_user(buf+copied, xip_mem+offset, nr) is len-copied
but the check only compares against (nr > len).

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
"ext2/xip: refuse to change xip flag during remount with busy inodes"
can be removed again.

Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Jared Hulbert <jaredeh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 mm/filemap_xip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/mm/filemap_xip.c linux-2.6-patched/mm/filemap_xip.c
--- linux-2.6/mm/filemap_xip.c	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6-patched/mm/filemap_xip.c	2009-03-31 15:25:53.000000000 +0200
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
