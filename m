Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbXEaNyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbXEaNyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXEaNyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:54:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55813 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbXEaNyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:54:32 -0400
To: linux-kernel@vger.kernel.org
Subject: Oops on disk write (kernel 2.6.16.y)
From: Holger Eitzenberger <holger@my-eitzenberger.de>
Date: Thu, 31 May 2007 15:54:09 +0200
Message-ID: <874pltayke.fsf@kruemel.my-eitzenberger.de>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1/zJFw4wHKv3Zk+OuxvhYD0yOIOBOpL1YnLnZL
 sM8jaLqTfhR0xZ+jmMDSHzVfNhfBu5Ae1hLqCNu/jfcW5Xke6g
 0ygCt+PCOyx7HBky5Uabw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am currently experiencing the same Kernel crash on several machines and
Kernel version 2.6.16.43.  Attached are some dumps of one particular
machine which crashed several times because of this.  Up until now I was
unable to reproduce this behaviour in the testlab, also putting some I/O
on the box helped not.

All of them happened on UP kernels, but this may be just a coincidence.
>From the logs I see that at least in one case the machine didn't stop
immediately but worked for few our from that point on until it hit the
wall.

Looking at the traces I can say that all of them follow a codepath from
the block I/O layer downward to ext3, e.g. here in page writeback path,
see:

kernel: Unable to handle kernel NULL pointer dereference at virtual address 00000004
kernel: printing eip:
kernel: c018e36a
kernel: *pde = 00000000
kernel: Oops: 0000 [#1]
kernel: Modules linked in: nfnetlink_queue ip_nat_ftp ip_conntrack_ftp
edd sg sd_mod sr_mod scsi_mod ide_cd cdrom ipt_MASQUERADE ipt_hashlimit
xt_condition ipt_REDIRECT xt_limit xt_conntrack ipt_esp xt_tcpudp
ipt_psd ipt_addrtype ip_nat_mms ip_nat_pptp ip_nat_irc iptable_nat
ebtable_nat ebtables iptable_ips ip_conntrack_mms ip_conntrack_pptp
ip_conntrack_irc ppp_deflate zlib_deflate bsd_comp sha1
arc4 ppp_mppe ppp_async crc_ccitt ppp_generic slhc crypto_null blowfish
cast5 serpent twofish ipsec af_packet ipt_logmark ipt_confirmed
ipt_owner ipt_REJECT ipt_CONFIRMED evdev ehci_hcd uhci_hcd ohci_hcd
parport_pc ppdev parport xt_state xt_NOTRACK iptable_raw iptable_filter
ip_conntrack_netlink ip_nat ipt_LOG ip_conntrack ip_tables x_tables
nfnetlink_log nfnetlink eepro100 mii e100 capability commoncap loop
kernel: CPU:    0
kernel: EIP:    0060:[<c018e36a>]    Not tainted VLI
kernel: EFLAGS: 00010286   (2.6.16.43-46-default #1)
kernel: EIP is at walk_page_buffers+0x1a/0x70
kernel: eax: 00000000   ebx: 00000000   ecx: 00000000   edx: 00000000
kernel: esi: 00000000   edi: d5f3cb74   ebp: 00000000   esp: c34a5d6c
kernel: ds: 007b   es: 007b   ss: 0068
kernel: Process pdflush (pid: 22753, threadinfo=c34a4000 task=cd7cb070)
kernel: Stack: <0>d573c574 dbb7c720 00000000 dbb7c720 c1114540 dbb7c720
d5f3cb74 dbb7c720
kernel: c01919c3 00001000 00000000 c018e3c0 cb6e1710 00000246 c1114540
0000000a
kernel: c01918c0 c34a5f48 c0176979 c1114540 c34a5f48 c34a5e28 00000000
0000000e
kernel: Call Trace:
kernel: [<c01919c3>] ext3_ordered_writepage+0x103/0x1f0
kernel: [<c018e3c0>] bget_one+0x0/0x10
kernel: [<c01918c0>] ext3_ordered_writepage+0x0/0x1f0
kernel: [<c0176979>] mpage_writepages+0x1c9/0x3e0
kernel: [<c01918c0>] ext3_ordered_writepage+0x0/0x1f0
kernel: [<c013aa79>] do_writepages+0x49/0x50
kernel: [<c017504c>] __writeback_single_inode+0x8c/0x3c0
kernel: [<c02fbafc>] schedule_timeout+0x4c/0xc0
kernel: [<c01755a8>] sync_sb_inodes+0x178/0x230
kernel: [<c0175b1f>] writeback_inodes+0x6f/0x89
kernel: [<c013ac59>] wb_kupdate+0xf9/0x170
kernel: [<c013b5ee>] pdflush+0x8e/0x180
...

The disassembly of write_page_buffers() is at [1].  At least some of the
other crashes happen in the sys_write() path, I have attached some of
them ([2], [3] and [4]).

Looking at the LKML archive I can say that

 http://lkml.org/lkml/2007/3/4/11

looks similar.

Any help appreciated.

Thanks.

  /holger


[1]
http://ftp.astaromail.com/people/heitzenberger/v7/kernel/6313/walk_page_buffers.s
[2]
http://ftp.astaromail.com/people/heitzenberger/v7/kernel/6313/kernel-2007-05-03.log.gz
[3] http://ftp.astaromail.com/people/heitzenberger/v7/kernel/6313/kernel-2007-05-10.log.gz
[4] http://ftp.astaromail.com/people/heitzenberger/v7/kernel/6313/kernel-2007-05-15.log.gz
