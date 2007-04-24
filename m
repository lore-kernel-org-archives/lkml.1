Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbXDXEJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbXDXEJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbXDXEJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:09:20 -0400
Received: from [70.254.190.220] ([70.254.190.220]:33314 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753528AbXDXEJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:09:19 -0400
Date: Tue, 24 Apr 2007 04:09:18 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>
Subject: Re: BUG: Null pointer dereference in fs/open.c
In-Reply-To: <Pine.LNX.4.64.0704231633210.25153@server.thyself>
Message-ID: <Pine.LNX.4.64.0704240347470.25153@server.thyself>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
 <20070423010032.c89e8d32.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231356480.25153@server.thyself>
 <Pine.LNX.4.64.0704231633210.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This bug occurs in linux-2.6.20 and 2.6.21-rc7-git5, and does not occur in 
linux-2.6.19-git22.

After running "pktsetup 0 /dev/hdd", I get (timestamps removed):

pktcdvd: pkt_get_last_written failed
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000e
printing eip:
c0173f69
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: snd_ca0106 snd_ac97_codec ac97_bus 8139cp 8139too iTCO_wdt
CPU:    0
EIP:    0060:[<c0173f69>]    Not tainted VLI
EFLAGS: 00010203   (2.6.21-rc7-git5 #22)
EIP is at do_sys_open+0x59/0xd0
eax: 00000002   ebx: 40000020   ecx: 00000001   edx: 00000002
esi: df1e3000   edi: 00000003   ebp: de17bfa4   esp: de17bf84
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process vol_id (pid: 4273, ti=de17b000 task=df4143f0 task.ti=de17b000)
Stack: 00000000 c013d2a5 ffffff9c 00000002 c059cea3 bfb6bf64 00008000 b7f60ff4
        de17bfb0 c017401c 00000000 de17b000 c01041c6 bfb6bf64 00008000 00000000
        00008000 b7f60ff4 bfb6a798 00000005 0000007b 0000007b 00000000 00000005
Call Trace:
  [<c010521a>] show_trace_log_lvl+0x1a/0x30
  [<c01052d9>] show_stack_log_lvl+0xa9/0xd0
  [<c010551c>] show_registers+0x21c/0x3a0
  [<c01057a4>] die+0x104/0x260
  [<c04c5947>] do_page_fault+0x277/0x610
  [<c04c408c>] error_code+0x74/0x7c
  [<c017401c>] sys_open+0x1c/0x20
  [<c01041c6>] sysenter_past_esp+0x5f/0x99
  =======================
Code: ff 85 c0 89 c7 78 77 8b 45 08 89 d9 89 f2 89 04 24 8b 45 e8 e8 69 ff 
ff ff 3d 00 f0 ff ff 89 45 ec 77 71 8b 55 ec bb 20 00 00 40 <8b> 42 0c 8b 
48 30 89 4d f0 0f b7 51 66 81 e2 00 f0 00 00 81 fa
EIP: [<c0173f69>] do_sys_open+0x59/0xd0 SS:ESP 0068:de17bf84


from fs/open.c, comments added:
// do_sys_open is consistently called with dfd=0xffffff9c,
// filename="/dev/.tmp-254-0", flags=0x8000, mode=0)
long do_sys_open(int dfd, const char __user *filename, int flags, int mode)
{
         char *tmp = getname(filename);
         int fd = PTR_ERR(tmp);

         if (!IS_ERR(tmp)) {
                 fd = get_unused_fd();
                 if (fd >= 0) {
// do_filp_open consistently returns 2, in this case
                         struct file *f = do_filp_open(dfd, tmp, flags, mode);
// IS_ERR always returns 0 for this command
                         if (IS_ERR(f)) {
                                 put_unused_fd(fd);
                                 fd = PTR_ERR(f);
                         } else {
// null pointer dereference occurs here
                                 fsnotify_open(f->f_path.dentry);
                                 fd_install(fd, f);
                         }
                 }
                 putname(tmp);
         }
         return fd;
}

I was able to workaround this, by testing if do_filp_open was returning 
2 or not, but obviously this is a very temporal solution to a very 
specific circumstance.

If there is any more information I can provide, let me know.
William Heimbigner
icxcnika@mar.tar.cc
