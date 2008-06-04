Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYFDAK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYFDAK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYFDAKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:10:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:19984 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYFDAKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qGqiZSmwXWpTRcj9OOHecDmP4vn/8uhSm05d1A+0EbXQPdXapYQxTqm+HiQ7tis0ZwZhqyqHBeHMt91SqlDdciZ0wguUlF7qE+FBxphk9UkMQtXEjhP3ZytaJ7qH871VvxoLeBIJ7+z1RIkRHBK6IoVEZ8UoIbvhI7boen+7qTo=
Message-ID: <a01a16b50806031710u54b9297bkf1fad9c4f8fd581f@mail.gmail.com>
Date: Wed, 4 Jun 2008 02:10:13 +0200
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805312332270.2760@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu> <1211966834.12349.62.camel@twins>
	 <a01a16b50805310725x4f1c375ep2d091bb044ac0787@mail.gmail.com>
	 <Pine.LNX.4.64.0805311839540.2657@wrl-59.cs.helsinki.fi>
	 <484191BD.8000904@gmail.com>
	 <Pine.LNX.4.64.0805312119270.2672@wrl-59.cs.helsinki.fi>
	 <a01a16b50805311325w7f58ca69h93d02af9bc28d2ea@mail.gmail.com>
	 <Pine.LNX.4.64.0805312332270.2760@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m540AZHl018891

2008/5/31 Ilpo J√§rvinen <ilpo.jarvinen@helsinki.fi>:> I didn't really mean tcpdump, I was more thinking of syscall what is the> syscall where the process is waiting. Though tcpdump might reveal> something as well about the behavior when nearing the problem,
> Hmm, perhaps periodically checking /proc/net/tcp (e.g., once per 10s) if> the timeout is larger than TCP_RTO_MAX might allow some script to> immediately notice when things broke while reproducing it. Storing all> those once per 10s values shouldn't be a too big either, it could even be> done in both ends for a single flow (but I'll leave a script to do that on> Monday).
Hi. I have now tested and taken various logs before/under/after (ps, netstat,tcpdump, strace, /proc/net/tcp). The logs did not grow as big as I fearedhowever they are way too big attach here. Any tips on how to distribute?
I mentioned before that the ssh connection died on the new PC, but sometimesit just hangs as well, i.e. the ssh connection is alive but there isno data transferred.The last test I did hang after just 292MB transferred. In this case pvjust hangson the new PC, waiting for data that never arrives. On the sendingside tar whichis producing data have died and the corresponding ssh is locked in someuninterruptible sleep:
//netstat before the hang:Proto Recv-Q Send-Q Local Address               Foreign Address     State       PID/Program name    Timertcp        0    504 new_pc:22                   old_pc:39464     ESTABLISHED 17054/sshd: hlovdal on (0.20/0/0)
// after the hang:Proto Recv-Q Send-Q Local Address               Foreign Address     State       PID/Program name    Timertcp        0   2896 old_pc:22                   new_pc:39464     ESTABLISHED -                   on (21329441.19/0/0)
old_pc>.ps -elf | sed -n '1p; /17054.*ssh/pF S UID        PID  PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD4 D root     17054  4402  0  80   0 -     0 -      00:08 ?00:00:00 [sshd]5 Z hlovdal  17058 17054  0  80   0 -     0 -      00:08 ?00:00:33 [sshd] <defunct>old_pc>strace -p 17054attach: ptrace(PTRACE_ATTACH, ...): Operation not permittedold_pc>
Many things  in /proc/17054/ are in a non-normal state (exe is anempty symlink, fd is empty, etc)but the stat* files seem normal:
/proc/17054/stat17054 (sshd) D 4402 17054 17054 0 -1 4202756 1007 395 11 2 1 6 0 1 200 1 0 80373564 0 0 4294967295 0 0 0 0 0 0 0 4096 16387 0 0 0 17 0 0 037 0 0
/proc/17054/statm0 0 0 0 0 0 0
/proc/17054/statusName:   sshdState:  D (disk sleep)Tgid:   17054Pid:    17054PPid:   4402TracerPid:      0Uid:    0       0       500     0Gid:    0       0       500     0FDSize: 0Groups:Threads:        1SigQ:   0/32639SigPnd: 0000000000000000ShdPnd: 0000000000000000SigBlk: 0000000000000000SigIgn: 0000000000001000SigCgt: 0000000180004003CapInh: 0000000000000000CapPrm: 00000000ffffffffCapEff: 00000000ffffffffvoluntary_ctxt_switches:        86nonvoluntary_ctxt_switches:     43
I also took a sysrq-t dump and here is the the output related to 17054:
sshd          D 000110ab  1972 17054   4402       f0628aa0 00200046 a3fbe728 000110ab f3788640 a4088c34 000110ab effb1a80       effb1ab0 effb1ac4 e769a380 c05be260 00000001 f0628aa0 c042f321 effb1ad4       effb1ad4 effb1a80 e769a3b4 00000000 e769a380 c05bb9aa 00000000 c9e82c00Call Trace: [<c05be260>] lock_sock_nested+0x6c/0x9d [<c042f321>] autoremove_wake_function+0x0/0x35 [<c05bb9aa>] sock_fasync+0x5e/0x113 [<c05bcc68>] sock_close+0x22/0x2f [<c0468b07>] __fput+0xaf/0x180 [<c046623a>] filp_close+0x51/0x58 [<c0421318>] put_files_struct+0x5f/0xa7 [<c0422443>] do_exit+0x208/0x6b5 [<c045990b>] do_munmap+0x193/0x1ac [<c042295b>] sys_exit_group+0x0/0xd [<c0404daa>] sysenter_past_esp+0x5f/0x85 =======================sshd          ? c04dc1a6  1296 17058  17054       d240d740 00200046 c0626ea3 c04dc1a6 c7886380 d240d740 00000000 00000010       d240d740 f0628aa0 f783f440 c04228ec c06d0b50 d240d9fd 000042a2 00000002       d240d8c4 00000000 f394eb60 f394eb60 f394ebe8 f394ec20 c06c0068 00200006Call Trace: [<c0626ea3>] _spin_unlock+0xf/0x23 [<c04dc1a6>] _atomic_dec_and_lock+0x22/0x2c [<c04228ec>] do_exit+0x6b1/0x6b5 [<c04060d0>] die+0x1d8/0x1e0 [<c062838e>] do_page_fault+0x0/0x615 [<c06288b9>] do_page_fault+0x52b/0x615 [<c062838e>] do_page_fault+0x0/0x615 [<c062710a>] error_code+0x6a/0x70 [<f8c77b39>] nf_conntrack_find_get+0x36/0x3a [nf_conntrack] [<f8c78379>] nf_conntrack_in+0x135/0x3e8 [nf_conntrack] [<c0423c5d>] local_bh_disable+0xa/0xb [<c0626d54>] _read_lock_bh+0x12/0x1a [<c0423d2c>] local_bh_enable_ip+0x37/0x4b [<f8a4a3a3>] ipt_do_table+0x2af/0x2d8 [ip_tables] [<f8c88161>] ipv4_conntrack_local+0x0/0x51 [nf_conntrack_ipv4] [<c05dbde6>] nf_iterate+0x3a/0x6e [<c05e33b0>] dst_output+0x0/0x7 [<c05dc12f>] nf_hook_slow+0x57/0xde [<c05e33b0>] dst_output+0x0/0x7 [<c05e5678>] ip_queue_xmit+0x2ff/0x340 [<c05e33b0>] dst_output+0x0/0x7 [<c05f34d7>] tcp_transmit_skb+0x6cc/0x6ff [<c05f34d7>] tcp_transmit_skb+0x6cc/0x6ff [<c04057bb>] common_interrupt+0x23/0x28 [<c05f2acc>] tcp_snd_test+0x13/0xe1 [<c05f554c>] tcp_push_one+0xb3/0xd4 [<c05eb11e>] tcp_sendmsg+0x7f1/0xa3b [<c05ebae4>] tcp_recvmsg+0x60b/0x717 [<c04bcb75>] avc_has_perm_noaudit+0x389/0x431 [<c04c57e4>] selinux_netlbl_inode_permission+0x40/0xa3 [<c05bbd73>] sock_aio_write+0xe3/0xef [<c04678e1>] do_sync_write+0xc6/0x109 [<c0626f11>] _spin_unlock_irqrestore+0x14/0x2a [<c042f321>] autoremove_wake_function+0x0/0x35 [<c0468135>] vfs_write+0xb5/0x14b [<c046869f>] sys_write+0x41/0x67 [<c0404daa>] sysenter_past_esp+0x5f/0x85 =======================
All the other ssh zombies are also stuck in lock_sock_nested/_spin_unlock(except one pair of lock_sock_nested/do_exit).
Any other tests I should do/logs you want?
BR H√•kon L√∏vdalˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
