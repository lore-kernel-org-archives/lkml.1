Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbZGAQyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbZGAQyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZGAQyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:54:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38905 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZGAQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:54:40 -0400
Date: Wed, 1 Jul 2009 12:54:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] gcov causes vread_tsc to increment kernel memory
Message-ID: <alpine.DEB.2.00.0907011245230.22887@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On bootup of the latest kernel my init segfaults. Debugging it, I found 
that vread_tsc (a vsyscall) increments some strange kernel memory:

0000000000000000 <vread_tsc>:
   0:   55                      push   %rbp
   1:   48 ff 05 00 00 00 00    incq   0(%rip)        # 8 <vread_tsc+0x8>
                        4: R_X86_64_PC32        .bss+0x3c
   8:   48 89 e5                mov    %rsp,%rbp
   b:   66 66 90                xchg   %ax,%ax
   e:   48 ff 05 00 00 00 00    incq   0(%rip)        # 15 <vread_tsc+0x15>
                        11: R_X86_64_PC32       .bss+0x44
  15:   66 66 90                xchg   %ax,%ax
  18:   48 ff 05 00 00 00 00    incq   0(%rip)        # 1f <vread_tsc+0x1f>
                        1b: R_X86_64_PC32       .bss+0x4c
  1f:   0f 31                   rdtsc  
	

Those "incq" is very bad to happen in vsyscall memory, since userspace can 
not modify it. You need to make something prevent profiling of vsyscall 
memory (like I do with ftrace).

-- Steve

