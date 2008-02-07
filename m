Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbYBGXD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbYBGXD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYBGXDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:03:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYBGXDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:03:19 -0500
Date: Thu, 7 Feb 2008 21:03:04 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Reducing debuginfo size by removing unneeded includes
Message-ID: <20080207230304.GA4352@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	I'm starting with you because the first file I used to
experiment with this idea was arch/x86/ia32/sys_ia32.c.

	I found it strange that the struct sk_buff definition was found
inside the DWARF debugging sections in the generated object, so I verified
and found that there is no need for the files that bring struct sk_buff
definition into this file and verified also that sk_buff is not brought
in indirectly too, thru other headers.

	I went on and removed many other unneeded includes and the end
result is:

[acme@doppio net-2.6]$ l /tmp/sys_ia32.o.before /tmp/sys_ia32.o.after
-rw-rw-r-- 1 acme acme 185240 2008-02-06 19:19 /tmp/sys_ia32.o.after
-rw-rw-r-- 1 acme acme 248328 2008-02-06 19:00 /tmp/sys_ia32.o.before

	Almost 64KB only on this object file!

	There were no other side effects from this change:

[acme@doppio net-2.6]$ objcopy -j "text" /tmp/sys_ia32.o.before /tmp/text.before
[acme@doppio net-2.6]$ objcopy -j "text" /tmp/sys_ia32.o.after /tmp/text.after
[acme@doppio net-2.6]$ md5sum /tmp/text.before /tmp/text.after
b7ac9b17942add68494e698e4f965d36  /tmp/text.before
b7ac9b17942add68494e698e4f965d36  /tmp/text.after

	One of the complaints about using tools such as systemtap is
that one has to install the huge kernel-debuginfo package:

[acme@doppio net-2.6]$ rpm -q --qf "%{size}\n" kernel-rt-debuginfo
471737710
543867594
[acme@doppio net-2.6]$

	So I'll try to improve automation to find more of these cases.

	Here goes the first patch, regards.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index abf71d2..38d4ae3 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -26,50 +26,25 @@
 #include <linux/file.h>
 #include <linux/signal.h>
 #include <linux/syscalls.h>
-#include <linux/resource.h>
 #include <linux/times.h>
 #include <linux/utsname.h>
-#include <linux/smp.h>
 #include <linux/smp_lock.h>
-#include <linux/sem.h>
-#include <linux/msg.h>
 #include <linux/mm.h>
-#include <linux/shm.h>
-#include <linux/slab.h>
 #include <linux/uio.h>
-#include <linux/nfs_fs.h>
-#include <linux/quota.h>
-#include <linux/module.h>
-#include <linux/sunrpc/svc.h>
-#include <linux/nfsd/nfsd.h>
-#include <linux/nfsd/cache.h>
-#include <linux/nfsd/xdr.h>
-#include <linux/nfsd/syscall.h>
 #include <linux/poll.h>
 #include <linux/personality.h>
 #include <linux/stat.h>
-#include <linux/ipc.h>
 #include <linux/rwsem.h>
-#include <linux/binfmts.h>
-#include <linux/init.h>
-#include <linux/aio_abi.h>
-#include <linux/aio.h>
 #include <linux/compat.h>
 #include <linux/vfs.h>
 #include <linux/ptrace.h>
 #include <linux/highuid.h>
-#include <linux/vmalloc.h>
-#include <linux/fsnotify.h>
 #include <linux/sysctl.h>
 #include <asm/mman.h>
 #include <asm/types.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <asm/atomic.h>
-#include <asm/ldt.h>
-
-#include <net/scm.h>
-#include <net/sock.h>
 #include <asm/ia32.h>
 
 #define AA(__x)		((unsigned long)(__x))

----- End forwarded message -----
