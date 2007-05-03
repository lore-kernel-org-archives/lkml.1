Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXECKMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXECKMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXECKMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:12:00 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:18722 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXECKL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:11:58 -0400
Message-ID: <4639B68D.3000700@sw.ru>
Date: Thu, 03 May 2007 14:16:45 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Kirill Korotaev <dev@openvz.org>, Alexey Kuznetsov <alexey@openvz.org>,
       devel@openvz.org
Subject: [PATCH] Invalid return value of execve() resulting in oopses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kuznetsov <alexey@openvz.org>

When elf loader fails to map executable (due to memory shortage or
because binary is malformed), it can return 0. Normally, this is 
invisible because process is killed with SIGKILL and it never returns
to user space.

But if exec() is called from kernel thread (hotplug, whatever)
consequences are more interesting and vary depending on architecture.

i386.   Nothing especially interesting, execve() just returns 
        with "success"  :-)

x86_64. Fake zero frame is used on way to caller, RSP/RIP are loaded
        with zeros, ergo... double fault.

ia64.   Similar to i386, but r32...r95 are corrupted. Sometimes it 
        oopses due to return to zero PC, sometimes it sees NaT in 
        rXX and oopses due to NaT consumption.

Signed-off-by: Alexey Kuznetsov <alexey@openvz.org>
Signed-off-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Pavel Emelianov <xemul@openvz.org>

---

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 67d9b31..fa8ea33 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -871,6 +871,8 @@ static int load_elf_binary(struct linux_
 				elf_prot, elf_flags);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
+			retval = IS_ERR((void *)error) ?
+				PTR_ERR((void*)error) : -EINVAL;
 			goto out_free_dentry;
 		}
 
@@ -900,6 +902,7 @@ static int load_elf_binary(struct linux_
 		    TASK_SIZE - elf_ppnt->p_memsz < k) {
 			/* set_brk can never work. Avoid overflows. */
 			send_sig(SIGKILL, current, 0);
+			retval = -EINVAL;
 			goto out_free_dentry;
 		}
 
