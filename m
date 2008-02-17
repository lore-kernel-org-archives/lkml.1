Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYBQTok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYBQTok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYBQToc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:44:32 -0500
Received: from qult.net ([82.238.217.46]:55786 "EHLO slartibartfast.qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYBQTob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:44:31 -0500
Date: Sun, 17 Feb 2008 20:44:27 +0100
From: Ignacy Gawedzki <lkml@qult.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel BUG at mm/rmap.c:631!
Message-ID: <20080217194427.GA1080@zenon.in.qult.net>
Mail-Followup-To: Ignacy Gawedzki <lkml@qult.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was printing on the parallel port and suddenly the "parallel" CUPS backend
went 50% CPU (obviously endless-looping), while the other 50% were eaten by
ghostscript (strace didn't show anything, so this might be an "internal"
loop).  When I eventually killed the latter, I got this:

Eeek! page_mapcount(page) went negative! (-1)
  page pfn = 3
  page->flags = 80014
  page->count = 0
  page->mapping = 00000000
  vma->vm_ops = _stext+0x3feff000/0x14
------------[ cut here ]------------
kernel BUG at mm/rmap.c:631!
invalid opcode: 0000 [#1] 
Modules linked in: cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state
ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4
xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables aes_i586
geode_aes aes_generic ieee80211_crypt_ccmp lirc_dev nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack ipv6 evdev hostap_pci hostap ieee80211_crypt
i2c_viapro via686a ide_cd

Pid: 5098, comm: gs Tainted: GF       (2.6.24.1 #9)
EIP: 0060:[<c01443f1>] EFLAGS: 00010246 CPU: 0
EIP is at page_remove_rmap+0xe4/0x111
EAX: 00000000 EBX: c1000060 ECX: 00000046 EDX: 00005a52
ESI: e90d3f44 EDI: ea61b720 EBP: b7000000 ESP: eefc7e00
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process gs (pid: 5098, ti=eefc6000 task=ea6fd570 task.ti=eefc6000)
Stack: c0398eb6 00000000 c1000060 b6dc8000 c013f6c8 0000326b 00000000 e90d3f44 
       eefc7e74 00000000 00000001 ef371b6c ef1073a0 c0454f98 ffffffa0 ffffffff 
       ef371b6c 000eaeb1 b70bc000 00000000 eefc7e74 e90d3860 ef1073a0 eefc7f10 
Call Trace:
 [<c013f6c8>] unmap_vmas+0x23e/0x403
 [<c0141c3e>] exit_mmap+0x5f/0xc9
 [<c0116a82>] mmput+0x1b/0x5e
 [<c011a8f8>] do_exit+0x1ad/0x5ae
 [<c011ad4a>] sys_exit_group+0x0/0xd
 [<c0120962>] get_signal_to_deliver+0x370/0x380
 [<c02cf89e>] net_rx_action+0x70/0x144
 [<c026d8bb>] intr_handler+0x9c/0xcf
 [<c0111f67>] do_page_fault+0x0/0x52d
 [<c0103326>] do_notify_resume+0x81/0x5c0
 [<c013ff5d>] handle_mm_fault+0x70/0x49d
 [<c010455b>] common_interrupt+0x23/0x28
 [<c01120f3>] do_page_fault+0x18c/0x52d
 [<c0336dc2>] schedule+0x1f3/0x20d
 [<c0111f67>] do_page_fault+0x0/0x52d
 [<c0103c4e>] work_notifysig+0x13/0x19
 [<c0330000>] rpc_info_open+0x17/0x6a
 =======================
Code: 8b 46 40 8b 50 08 b8 05 8f 39 c0 e8 08 df fe ff 8b 46 48 85 c0 74 14 8b
40 10 85 c0 74 0d 8b 50 2c b8 23 8f 39 c0 e8 ed de fe ff <0f> 0b eb fe 8b 53
10 8b 03 83 e2 01 f7 da c1 e8 1e 83 c2 04 69 
EIP: [<c01443f1>] page_remove_rmap+0xe4/0x111 SS:ESP 0068:eefc7e00
---[ end trace 42d12388f65d0f6f ]---
Fixing recursive fault but reboot is needed!

Apparently this happened to me in the near past, but I didn't have any
netconsole facility enabled at that time to capture the message.

Anybody has any idea where this might have come from?

-- 
Sex on TV doesn't hurt....unless you fall off.
