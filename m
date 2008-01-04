Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYADOgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYADOgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYADOge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:36:34 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:34025 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbYADOgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:36:33 -0500
Date: Fri, 4 Jan 2008 15:35:57 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: return -EPERM when preventing read of
 /proc/*/maps
Message-ID: <20080104153557.13e24970@inria.fr>
In-Reply-To: <20080104141443.GB27894@ZenIV.linux.org.uk>
References: <20080104135731.2908.90012.stgit@localhost.localdomain>
	<20080104141443.GB27894@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> vma_stop() doesn't need changes either...

Hmmm, not sure ;-)

$ cat /proc/1/maps
Pid: 2282, comm: cat Not tainted (2.6.24-rc6-gc2 #185)
EIP: 0060:[<c01a4080>] EFLAGS: 00010286 CPU: 0
EIP is at vma_stop+0xd/0x21
EAX: f7c90360 EBX: f7c90360 ECX: c042b5f0 EDX: ffffffff
ESI: f62aa240 EDI: ffffffff EBP: f62daf24 ESP: f62daf20
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process cat (pid: 2282, ti=f62da000 task=f6264d20 task.ti=f62da000)
Stack: f7c90360 f62daf30 c01a40dc f62d0080 f62daf70 c018bdf1 00000400 0804f000 
       f62d0080 f62aa260 00000000 ffffffff 00000400 f62cc000 f62dafb0 00000000 
       00000000 f62d0080 c018bc9e 0804f000 f62daf90 c01751c5 f62daf9c 00000000 
Call Trace:
 [<c0104e4a>] show_trace_log_lvl+0x1a/0x2f
 [<c0104efc>] show_stack_log_lvl+0x9d/0xa5
 [<c0104fa6>] show_registers+0xa2/0x1b8
 [<c01051d9>] die+0x11d/0x202
 [<c03319f9>] do_general_protection+0x1f7/0x1ff
 [<c0331172>] error_code+0x6a/0x70
 [<c01a40dc>] m_stop+0xe/0x29
 [<c018bdf1>] seq_read+0x153/0x25a
 [<c01751c5>] vfs_read+0xa6/0x158
 [<c0175583>] sys_read+0x3d/0x61
 [<c0103ea2>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: 89 50 18 31 d2 89 48 1c 83 c4 5c 89 d0 5b 5e 5f 5d c3 55 31 c9 89 e5 e8 80 fd ff ff 5d c3 55 85 d2 89 e5 53 74 16 3b 50 08 74 11 <8b> 1a 8d 43 34 e8 80 ea f8 ff 89 d8 e8 16 89 f7 ff 5b 5d c3 55 
EIP: [<c01a4080>] vma_stop+0xd/0x21 SS:ESP 0068:f62daf20
---[ end trace 297d07fbbfc82b7b ]---

This is an inconsistency in the handling of errors in m_start() between
fs/proc/task_mmu.c and fs/proc/task_nommu.c.

task_mmu.c:
        if (IS_ERR(mm) || !mm)
                return mm;

task_nommu.c:
        if (IS_ERR(mm) || !mm) {
                put_task_struct(priv->task);
                priv->task = NULL;
                return mm;
        }

task_nommu.c does the cleanup while task_mmu.c defers it to m_stop.

-- 
Guillaume
