Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbYGPVcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbYGPVcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYGPVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:32:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:33954 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbYGPVcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=SwY2zPnjecGWq6nmiqu1bJmEkJ5omVTFpbee5pqFoQczdHZoBUgwemkqFTXAaIdGb+
         m6CPp1wVNC4QMKtpJ6vGAUPz7l3oW3P3tqqt1tymywB5HSrPiGwtvLMDhy2MSkBMZaHR
         UA/nyctrGuxtCtmWV0dqEMz64LK8FzRFjD9x4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: do not grow initial process stack so much
Date: Wed, 16 Jul 2008 23:32:37 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807162332.37741.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

fs/exec.c has this function

/*
 * Finalizes the stack vm_area_struct. The flags and permissions are updated,
 * the stack is optionally relocated, and some extra space is added.
 */
int setup_arg_pages(struct linux_binprm *bprm,
                    unsigned long stack_top,
                    int executable_stack)
{...

which is called for every newly exec'ed process. Apart from other things,
it grows stack by EXTRA_STACK_VM_PAGES, which is defined to "random",
as comment says, 20 pages:

#define EXTRA_STACK_VM_PAGES    20      /* random */

Just for gigs I replaced it with 1 and it works,
I can see stack size of processes in my top instead of uniformly
80k for each process:

  PID   VSZ VSZRW   RSS (SHR) DIRTY (SHR)*STACK COMMAND
...
 2389 25632  1476 15364 14536  6812  6140    44 ksmserver [kdeinit]
 2395 32632  3768 22516 17008  9532  6092    44 kicker [kdeinit]
 2402 30308  3048 20072 16608  9000  6084    44 konsole [kdeinit]
 2369 24952  1068 14472 14204  6432  6236    44 kdeinit Running...
 2390 28052  2096 17844 15760  7548  6116    44 kwin [kdeinit]
 2386 25596  1344 15196 14464  6820  6140    44 kaccess [kdeinit]
 2400 30976  1588 19436 14728  8996  6128    44 knotify [kdeinit]
  609  1420   232   572   412   132     0    40 rpc.portmap
 2374 25944  1208 14516 13900  6648  6088    36 klauncher [kdeinit]
 2372 24364   916 12048 11676  6388  6064    32 dcopserver [kdeinit] --nosid
  861  3176   532  1904  1320   560     0    24 -bash
 2436  3160   516  1808  1264   540     0    24 /bin/bash
 4291  3156   512  1780  1240   540     0    20 /bin/bash
  767  1380   220   664   468   116     0    20 automount -f -s -v --timeout 15 /.local/mnt/auto program /.local/var/service/automount/map
 2404  3152   508  1776  1240   536     0    20 /bin/bash
  812  2364   212  1280  1056   220     0    16 /bin/sh ./run
 2387  1220   184   324   248    68     0    16 kwrapper ksmserver
  880  3044   516  1424   464   328     0    16 /usr/bin/sshd -D -e -p22 -u0
 1775  1328   208   248   120   100     0    16 rpc.mountd
 2399  1592   360   852   544   252     0    12 ksysguardd
  799   776    24   176   152    24     0    12 tcpsvd -v -l 0 -c 40 ::1 21 setuidgid root vsftpd /.local/var/service/vsftp/vsftpd.conf
  591    80    40    72     4    40     0    12 udevd
...

Even though those 80k were on demand, cat /proc/meminfo >NN
fresh after boot actually shows that I have a few tens of kb more
of free memory. Results with 80, 40 and 2 kb:

# grep MemFree 80k 40k 1k
80k:MemFree:       1991412 kB
80k:MemFree:       1991420 kB
80k:MemFree:       1991412 kB
40k:MemFree:       1991452 kB
40k:MemFree:       1991444 kB
40k:MemFree:       1991444 kB
1k:MemFree:       1991832 kB
1k:MemFree:       1991824 kB
1k:MemFree:       1991824 kB

I assume that there are architectures that need those 20 pages
pre-prepared in stack vma.

I do not see, though, why this can be useful for x86. The pages
are not mapped anyway, so accessing them still causes page faults.
No speedup for, say, rapidly spawning processes which need ~60k
of stack right away. They will still fault in kernel, right?

Therefore I propose to not do it for x86.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--- linux-2.6.26.src/fs/exec.c	Sun Jul 13 23:51:29 2008
+++ linux-2.6.26.stk/fs/exec.c	Wed Jul 16 23:16:21 2008
@@ -563,7 +563,11 @@
 	return 0;
 }
 
+#if defined __i386__ || defined __x86_64__
+#define EXTRA_STACK_VM_PAGES	1
+#else
 #define EXTRA_STACK_VM_PAGES	20	/* random */
+#endif
 
 /*
  * Finalizes the stack vm_area_struct. The flags and permissions are updated,
