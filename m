Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXDISTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXDISTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXDISTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:19:41 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38293 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbXDISTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:19:39 -0400
Date: Mon, 9 Apr 2007 14:14:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/4] UML - Remove unused x86_64 code
Message-ID: <20070409181440.GA7262@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that essentially none of the x86_64 bugs.c is needed.
So, we can delete most of it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/sys-x86_64/bugs.c |   69 ----------------------------------------------
 1 file changed, 69 deletions(-)

Index: linux-2.6.21-mm/arch/um/sys-x86_64/bugs.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/sys-x86_64/bugs.c	2007-04-03 11:31:25.000000000 -0400
+++ linux-2.6.21-mm/arch/um/sys-x86_64/bugs.c	2007-04-05 13:26:48.000000000 -0400
@@ -4,12 +4,7 @@
  * Licensed under the GPL
  */
 
-#include "linux/sched.h"
-#include "linux/errno.h"
-#include "asm/system.h"
-#include "asm/pda.h"
 #include "sysdep/ptrace.h"
-#include "os.h"
 
 void arch_init_thread(void)
 {
@@ -23,67 +18,3 @@ int arch_handle_signal(int sig, union um
 {
 	return 0;
 }
-
-#define MAXTOKEN 64
-
-/* Set during early boot */
-int host_has_cmov = 1;
-int host_has_xmm = 0;
-
-static char token(int fd, char *buf, int len, char stop)
-{
-	int n;
-	char *ptr, *end, c;
-
-	ptr = buf;
-	end = &buf[len];
-	do {
-		n = os_read_file(fd, ptr, sizeof(*ptr));
-		c = *ptr++;
-		if(n != sizeof(*ptr)){
-			if(n == 0)
-				return 0;
-			printk("Reading /proc/cpuinfo failed, err = %d\n", -n);
-			if(n < 0)
-				return n;
-			else return -EIO;
-		}
-	} while((c != '\n') && (c != stop) && (ptr < end));
-
-	if(ptr == end){
-		printk("Failed to find '%c' in /proc/cpuinfo\n", stop);
-		return -1;
-	}
-	*(ptr - 1) = '\0';
-	return c;
-}
-
-static int find_cpuinfo_line(int fd, char *key, char *scratch, int len)
-{
-	int n;
-	char c;
-
-	scratch[len - 1] = '\0';
-	while(1){
-		c = token(fd, scratch, len - 1, ':');
-		if(c <= 0)
-			return 0;
-		else if(c != ':'){
-			printk("Failed to find ':' in /proc/cpuinfo\n");
-			return 0;
-		}
-
-		if(!strncmp(scratch, key, strlen(key)))
-			return 1;
-
-		do {
-			n = os_read_file(fd, &c, sizeof(c));
-			if(n != sizeof(c)){
-				printk("Failed to find newline in "
-				       "/proc/cpuinfo, err = %d\n", -n);
-				return 0;
-			}
-		} while(c != '\n');
-	}
-	return 0;
-}
