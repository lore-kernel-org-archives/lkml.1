Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbXI1Im3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbXI1Im3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbXI1ImV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:42:21 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:41686 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbXI1ImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:42:15 -0400
Date: Fri, 28 Sep 2007 10:42:08 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Strange system hangs
Message-ID: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-523460431-1190968928=:17152"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-523460431-1190968928=:17152
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

I am experiencing weird system hangs. Once about 2-5 weeks system freezes=
=20
and stops accepting remote connections, so it is no longer possible to=20
connect to most important services: smtp (postfix), www (squid) or even=20
ssh. Such connection is accepted but then it hangs.

What is strange, that previously established ssh session is usable. It is=
=20
possible to work on such system until you do something stupid like "less=20
/var/log/all.log". Using strace I found that process blocks on:

--- strace: being ---
execve("/usr/bin/tail", ["tail", "-f", "/var/log/all.log"], [/* 33 vars */]=
) =3D 0
brk(0)                                  =3D 0x8052000
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x6ff00000
access("/etc/ld.so.preload", R_OK)      =3D -1 ENOENT (No such file or dire=
ctory)
open("/etc/ld.so.cache", O_RDONLY)      =3D 3
fstat64(3, {st_mode=3DS_IFREG|0644, st_size=3D20944, ...}) =3D 0
mmap2(NULL, 20944, PROT_READ, MAP_PRIVATE, 3, 0) =3D 0x6fefa000
close(3)                                =3D 0
open("/lib/libc.so.6", O_RDONLY)        =3D 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0RY\1\0004\0\0\0"...=
, 512) =3D 512
fstat64(3, {st_mode=3DS_IFREG|0755, st_size=3D1175920, ...}) =3D 0
mmap2(NULL, 1185212, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
=3D 0x6fdd8000
mmap2(0x6fef4000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DE=
NYWRITE, 3, 0x11b) =3D 0x6fef4000
mmap2(0x6fef7000, 9660, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANO=
NYMOUS, -1, 0) =3D 0x6fef7000
close(3)                                =3D 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
=3D 0x6fdd7000
set_thread_area({entry_number:-1 -> 6, base_addr:0x6fdd76b0, limit:1048575,=
 seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_prese=
nt:0, useable:1}) =3D 0
mprotect(0x6fef4000, 4096, PROT_READ)   =3D 0
mprotect(0x6ff1c000, 4096, PROT_READ)   =3D 0
munmap(0x6fefa000, 20944)               =3D 0
brk(0)                                  =3D 0x8052000
brk(0x8073000)                          =3D 0x8073000
open("/var/log/all.log", O_RDONLY|O_LARGEFILE) =3D 3
fstat64(3, {st_mode=3DS_IFREG|0640, st_size=3D3171841, ...})
llseek(3, 0,  <unfinished ...>
--- strace: end ---

This file is not very big:

# ls -l /var/log/all.log
-rw-r----- 1 root root 3171841 Sep 27 04:36 /var/log/all.log

Also running "dmesg > file" hangs, creating a file with only 4096 bytes.

--- Show Blocked State: begin ---
SysRq : Show Blocked State

                          free                        sibling
   task             PC    stack   pid father child younger older
syslogd       D F5C83C60     0  2162      1 (NOTLB)
        f5c83c74 00000082 00000002 f5c83c60 f5c83c5c 00000000 00000000 7853=
8d20
        00000009 00000001 f7f6a070 f7cb8030 82c47e5f 0001cfed 00000a43 f7f6=
a17c
        7a016980 f705dc80 78404217 7812c708 00000000 00000213 f5c83c84 1e7a=
64bb
Call Trace:
  [<78404217>] _spin_unlock_irqrestore+0xf/0x23
  [<7812c708>] __mod_timer+0x92/0x9c
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
  [<783c55a1>] unix_dgram_recvmsg+0x1b4/0x1c8
  [<78128c8e>] current_fs_time+0x41/0x46
  [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7814621b>] generic_file_aio_write+0x55/0xb3
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f34f>] do_sync_readv_writev+0xc1/0xfe
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<784041ae>] _spin_unlock+0xd/0x21
  [<781a8c38>] log_wait_commit+0xc3/0xe3
  [<7814448b>] find_get_pages_tag+0x76/0x80
  [<7815f204>] rw_copy_check_uvector+0x50/0xaa
  [<7815f9d4>] do_readv_writev+0x99/0x164
  [<78194b04>] ext3_file_write+0x0/0x8f
  [<7815fadc>] vfs_writev+0x3d/0x48
  [<7815feb5>] sys_writev+0x41/0x67
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
freshclam     D 00000282     0  2866      1 (NOTLB)
        f36e3cc4 00000082 00000009 00000282 7a0173c0 00000002 00000000 0000=
007b
        00000009 00000001 f7cb8030 f7c72030 82c4884d 0001cfed 000009ee f7cb=
813c
        7a016980 f66c0b80 78404217 7812c708 00000000 00000213 f36e3cd4 1e7a=
64bb
Call Trace:
  [<78404217>] _spin_unlock_irqrestore+0xf/0x23
  [<7812c708>] __mod_timer+0x92/0x9c
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
  [<7819cdb4>] __ext3_journal_stop+0x19/0x34
  [<7840408f>] _spin_lock+0xd/0x5a
  [<78176f3d>] __mark_inode_dirty+0xdd/0x16f
  [<78128c8e>] current_fs_time+0x41/0x46
  [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7814621b>] generic_file_aio_write+0x55/0xb3
  [<78103159>] setup_sigcontext+0x105/0x189
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f453>] do_sync_write+0xc7/0x10a
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781085d2>] convert_fxsr_from_user+0x15/0xd5
  [<7815f38c>] do_sync_write+0x0/0x10a
  [<7815fbb6>] vfs_write+0x8a/0x10c
  [<78160123>] sys_write+0x41/0x67
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
crond         D 00000140     0  3029      1 (NOTLB)
        f1577cc4 00000082 00000008 00000140 7a00f3c0 00000002 00000000 0002=
6b9a
        00000009 00000001 7a1d8030 e89f0070 82c469af 0001cfed 00000ad9 7a1d=
813c
        7a016980 f73afb40 78404217 7812c708 00000000 00000213 f1577cd4 1e7a=
64bb
Call Trace:
  [<78404217>] _spin_unlock_irqrestore+0xf/0x23
  [<7812c708>] __mod_timer+0x92/0x9c
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
  [<7819cdb4>] __ext3_journal_stop+0x19/0x34
  [<7840408f>] _spin_lock+0xd/0x5a
  [<78176f3d>] __mark_inode_dirty+0xdd/0x16f
  [<78128c8e>] current_fs_time+0x41/0x46
  [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7814621b>] generic_file_aio_write+0x55/0xb3
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f453>] do_sync_write+0xc7/0x10a
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<78162281>] sys_stat64+0x1e/0x23
  [<7815f38c>] do_sync_write+0x0/0x10a
  [<7815fbb6>] vfs_write+0x8a/0x10c
  [<78160123>] sys_write+0x41/0x67
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  [<78400000>] svcauth_gss_accept+0x8a3/0xb2b
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ntpd          D 00000140     0  3237      1 (NOTLB)
        ed027cc4 00200082 00000006 00000140 7a00f3c0 00000002 00000000 8889=
25f9
        00000009 00000001 7a1c8070 ea1d2a50 82c49c08 0001cfed 00000a11 7a1c=
817c
        7a016980 f66c0580 78404217 7812c708 00000000 00200213 ed027cd4 1e7a=
64bb
Call Trace:
  [<78404217>] _spin_unlock_irqrestore+0xf/0x23
  [<7812c708>] __mod_timer+0x92/0x9c
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7810477b>] common_interrupt+0x23/0x28
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
  [<78128c8e>] current_fs_time+0x41/0x46
  [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7814621b>] generic_file_aio_write+0x55/0xb3
  [<781484b8>] get_page_from_freelist+0x278/0x325
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f453>] do_sync_write+0xc7/0x10a
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<7815f38c>] do_sync_write+0x0/0x10a
  [<7815fbb6>] vfs_write+0x8a/0x10c
  [<78160123>] sys_write+0x41/0x67
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
snmpd         D EB4EDCB0     0  3506      1 (NOTLB)
        eb4edcc4 00200086 00000002 eb4edcb0 eb4edcac 00000000 ebdbe100 000f=
4240
        00000007 00000001 eb94e030 ed65a030 82c4e0b2 0001cfed 00000a63 eb94=
e13c
        7a016980 ebdbe100 78404217 7812c708 00000000 00200213 eb4edcd4 1e7a=
64bb
Call Trace:
  [<78404217>] _spin_unlock_irqrestore+0xf/0x23
  [<7812c708>] __mod_timer+0x92/0x9c
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
  [<78128c8e>] current_fs_time+0x41/0x46
  [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7814621b>] generic_file_aio_write+0x55/0xb3
  [<7819cdb4>] __ext3_journal_stop+0x19/0x34
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f453>] do_sync_write+0xc7/0x10a
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<7815f38c>] do_sync_write+0x0/0x10a
  [<7815fbb6>] vfs_write+0x8a/0x10c
  [<78160123>] sys_write+0x41/0x67
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  [<78400000>] svcauth_gss_accept+0x8a3/0xb2b
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squid         D 00000140     0  3565   3563 (NOTLB)
        eb2f7cc4 00000086 00000004 00000140 7a00f3c0 00000002 00000000 f7fa=
c000
        00000009 00000001 f7c72030 7a1c8070 82c491f7 0001cfed 000009aa f7c7=
213c
        7a016980 ebdbeb00 78404217 7812c708 00000000 00000213 eb2f7cd4 1e7a=
64bb
Call Trace:
  [<78404217>] _spin_unlock_irqrestore+0xf/0x23
  [<7812c708>] __mod_timer+0x92/0x9c
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
  [<7819cdb4>] __ext3_journal_stop+0x19/0x34
  [<7840408f>] _spin_lock+0xd/0x5a
  [<78176f3d>] __mark_inode_dirty+0xdd/0x16f
  [<78128c8e>] current_fs_time+0x41/0x46
  [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7814621b>] generic_file_aio_write+0x55/0xb3
  [<782bc211>] e1000_alloc_rx_buffers+0x1bb/0x280
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f453>] do_sync_write+0xc7/0x10a
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<78102d86>] __switch_to+0x108/0x127
  [<784023bb>] __sched_text_start+0x78b/0x7b2
  [<78374bb5>] net_rx_action+0x13a/0x17b
  [<7815f38c>] do_sync_write+0x0/0x10a
  [<7815fbb6>] vfs_write+0x8a/0x10c
  [<78160123>] sys_write+0x41/0x67
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  [<78400000>] svcauth_gss_accept+0x8a3/0xb2b
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
zabbix_agentd D E9C41E34     0  3687      1 (NOTLB)
        e9c41e48 00200082 00000002 e9c41e34 e9c41e30 00000000 00000310 ea20=
cb84
        00000008 00000001 eb94e540 f7f92030 ad13acaf 0001ce8d 00012a82 eb94=
e64c
        7a016980 eab33b40 1e634329 00000003 00000000 00000000 e9c41e60 9d73=
9158
Call Trace:
  [<7840324c>] __mutex_lock_slowpath+0x10f/0x20e
  [<78146206>] generic_file_aio_write+0x40/0xb3
  [<781484b8>] get_page_from_freelist+0x278/0x325
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f453>] do_sync_write+0xc7/0x10a
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<7815f38c>] do_sync_write+0x0/0x10a
  [<7815fbb6>] vfs_write+0x8a/0x10c
  [<78160123>] sys_write+0x41/0x67
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
zabbix_agentd D EB6C5CB0     0  3754   3687 (NOTLB)
        eb6c5cc4 00200082 00000002 eb6c5cb0 eb6c5cac 00000000 f7c81574 0000=
0001
        00000008 00000001 ed65a030 f7f92030 82c4ea91 0001cfed 000009df ed65=
a13c
        7a016980 f5cc5c40 1e7a6458 00000003 00000000 00000000 eb6c5cd4 1e7a=
64bb
Call Trace:
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
  [<7819cdb4>] __ext3_journal_stop+0x19/0x34
  [<7840408f>] _spin_lock+0xd/0x5a
  [<78176f3d>] __mark_inode_dirty+0xdd/0x16f
  [<78128c8e>] current_fs_time+0x41/0x46
  [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
  [<781710e9>] mntput_no_expire+0x11/0x63
  [<7814621b>] generic_file_aio_write+0x55/0xb3
  [<781484b8>] get_page_from_freelist+0x278/0x325
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f453>] do_sync_write+0xc7/0x10a
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<7815f38c>] do_sync_write+0x0/0x10a
  [<7815fbb6>] vfs_write+0x8a/0x10c
  [<78160123>] sys_write+0x41/0x67
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       D 00000270     0 19280      1 (NOTLB)
        c2563e2c 00000082 00000005 00000270 7a0173c0 00000002 00000000 0000=
0000
        00000008 00000001 f7e86a90 944bc070 82c4b069 0001cfed 000009e0 f7e8=
6b9c
        7a016980 c13f6680 1e7a6458 00000003 00000000 00000270 c2563e3c 1e7a=
64bb
Call Trace:
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814e32c>] do_wp_page+0x3bb/0x3fd
  [<7814f6da>] __handle_mm_fault+0x7b4/0x82c
  [<7812f815>] __atomic_notifier_call_chain+0x3f/0x5a
  [<78119744>] do_page_fault+0x20d/0x52d
  [<78138135>] do_gettimeofday+0x31/0xd4
  [<78119537>] do_page_fault+0x0/0x52d
  [<784043ea>] error_code+0x72/0x78
  [<78400000>] svcauth_gss_accept+0x8a3/0xb2b
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       D 00000001     0 19570      1 (NOTLB)
        97f79ccc 00000006 f7c81574 00000001 0000000a 7822768f 97f79c80 97f7=
9c80
        00000009 00000001 e89f0070 f7f6a070 82c4741c 0001cfed 00000a6d e89f=
017c
        7a016980 78622bc0 78404217 7812c708 00000000 00000213 97f79cdc 1e7a=
64bb
Call Trace:
  [<7822768f>] blk_done_softirq+0x44/0x4f
  [<78404217>] _spin_unlock_irqrestore+0xf/0x23
  [<7812c708>] __mod_timer+0x92/0x9c
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7810477b>] common_interrupt+0x23/0x28
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
  [<7819cdb4>] __ext3_journal_stop+0x19/0x34
  [<7840408f>] _spin_lock+0xd/0x5a
  [<78128c8e>] current_fs_time+0x41/0x46
  [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7814621b>] generic_file_aio_write+0x55/0xb3
  [<78176f3d>] __mark_inode_dirty+0xdd/0x16f
  [<78194b28>] ext3_file_write+0x24/0x8f
  [<7815f453>] do_sync_write+0xc7/0x10a
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<7815f38c>] do_sync_write+0x0/0x10a
  [<7815fbb6>] vfs_write+0x8a/0x10c
  [<781601f0>] sys_pwrite64+0x48/0x5f
  [<78103d6a>] sysenter_past_esp+0x5f/0x85
  [<78400000>] svcauth_gss_accept+0x8a3/0xb2b
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sadc          D 00000140     0 21692      1 (NOTLB)
        a830bcc4 00000082 00000002 00000140 7a00f3c0 00000002 00000000 0000=
0002
        00000007 00000001 ebff0a90 eb94e030 82c4d64f 0001cfed 00000a11 ebff=
0b9c
        7a016980 f5cc5040 78404217 7812c708 00000000 00000213 a830bcd4 1e7a=
64bb
Call Trace:
  [<78404217>] _spin_unlock_irqrestore+0xf/0x23
  [<7812c708>] __mod_timer+0x92/0x9c
  [<78402b34>] schedule_timeout+0x70/0x8d
  [<7812c521>] process_timeout+0x0/0x5
  [<78402548>] io_schedule_timeout+0x1e/0x28
  [<7814d41e>] congestion_wait+0x50/0x64
  [<78134abc>] autoremove_wake_function+0x0/0x35
  [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
--- Show Blocked State: end ---

--- cat /proc/interrupts: begin ---
            CPU0       CPU1
   0:        541          0   IO-APIC-edge      timer
   1:         56          0   IO-APIC-edge      i8042
   6:          3          0   IO-APIC-edge      floppy
   8:         43          0   IO-APIC-edge      rtc
   9:          0          0   IO-APIC-fasteoi   acpi
  12:       1418          0   IO-APIC-edge      i8042
  14:         26          0   IO-APIC-edge      libata
  15:          0          0   IO-APIC-edge      libata
  17:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
  20:  106711998          0   IO-APIC-fasteoi   eth0
  21:      42948          0   IO-APIC-fasteoi   eth1
  22:   10816027          0   IO-APIC-fasteoi   libata, ehci_hcd:usb1, uhci=
_hcd:usb2
NMI:          0          0
LOC:   86943769   86934941
ERR:          0
--- cat /proc/interrupts: end ---

--- dmesg: begin ---
Linux version 2.6.22.6 (root@cougar) (gcc version 4.1.2 (Gentoo 4.1.2)) #1 =
SMP PREEMPT Fri Sep 21 11:41:24 CEST 2007
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
  BIOS-e820: 0000000000100000 - 000000007ffc0000 (usable)
  BIOS-e820: 000000007ffc0000 - 000000007ffcfc00 (ACPI data)
  BIOS-e820: 000000007ffcfc00 - 000000007ffff000 (reserved)
  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
  BIOS-e820: 00000000fed13000 - 00000000feda0000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
2047MB LOWMEM available.
found SMP MP-table at 000fe710
Entering add_active_range(0, 0, 524224) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   524224
early_node_map[1] active PFN ranges
     0:        0 ->   524224
On node 0 totalpages: 524224
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 4063 pages used for memmap
   Normal zone: 516065 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000FD160, 0014 (r0 DELL  )
ACPI: RSDT 000FD174, 0038 (r1 DELL   PE830           1 MSFT  100000A)
ACPI: FACP 000FD1B8, 0074 (r1 DELL   PE830           1 MSFT  100000A)
ACPI: DSDT 7FFC0000, 1C19 (r1 DELL   PE830           1 MSFT  100000E)
ACPI: FACS 7FFCFC00, 0040
ACPI: APIC 000FD22C, 0074 (r1 DELL   PE830           1 MSFT  100000A)
ACPI: SPCR 000FD2A0, 0050 (r1 DELL   PE830           1 MSFT  100000A)
ACPI: HPET 000FD2F0, 0038 (r1 DELL   PE830           1 MSFT  100000A)
ACPI: MCFG 000FD328, 003C (r1 DELL   PE830           1 MSFT  100000A)
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec10000] gsi_base[32])
IOAPIC[1]: apic_id 3, version 32, address 0xfec10000, GSI 32-55
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
ACPI: HPET id: 0xffffffff base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7ffff000:70001000)
Built 1 zonelists.  Total pages: 520129
Kernel command line: auto BOOT_IMAGE=3DLinux-2.6.22.6 ro root=3D900 rootfla=
gs=3Ddata=3Djournal nf_conntrack.hashsize=3D32768
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec10000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3200.405 MHz processor.
Console: colour VGA+ 80x30
Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
Memory: 2073468k/2096896k available (3092k kernel code, 23040k reserved, 12=
69k data, 220k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
     vmalloc : 0xf8800000 - 0xfffb5000   ( 119 MB)
     lowmem  : 0x78000000 - 0xf7fc0000   (2047 MB)
       .init : 0x7854b000 - 0x78582000   ( 220 kB)
       .data : 0x784051cb - 0x7854280c   (1269 kB)
       .text : 0x78100000 - 0x784051cb   (3092 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok=
=2E
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 6404.65 BogoMIPS (lpj=3D32=
02326)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000=
649d 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 0000b180 0000649d 00=
000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) D CPU 3.20GHz stepping 07
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6400.33 BogoMIPS (lpj=3D32=
00168)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000=
649d 00000000 00000001
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 0000b180 0000649d 00=
000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) D CPU 3.20GHz stepping 07
Total of 2 processors activated (12804.98 BogoMIPS).
ENABLING IO-APIC IRQs
=2E.TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=3D291
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0880-08bf claimed by ICH6 GPIO
PCI: PXH quirk detected, disabling MSI for SHPC device
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PES1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEP0.PXHA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIS._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 2.21 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post a r=
eport
pnp: 00:09: ioport range 0x800-0x87f has been reserved
pnp: 00:09: ioport range 0x880-0x8bf has been reserved
pnp: 00:09: ioport range 0x8c0-0x8df has been reserved
Time: tsc clocksource has been installed.
pnp: 00:09: ioport range 0x8e0-0x8e3 has been reserved
pnp: 00:09: ioport range 0xc00-0xc0f has been reserved
pnp: 00:09: ioport range 0xc10-0xc1f has been reserved
pnp: 00:09: ioport range 0xca0-0xca7 has been reserved
pnp: 00:09: ioport range 0xca9-0xcab has been reserved
pnp: 00:0b: iomem range 0xf0000000-0xf3ffffff could not be reserved
PCI: Bridge: 0000:00:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:02:00.0
   IO window: e000-efff
   MEM window: fe900000-feafffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
   IO window: e000-efff
   MEM window: fe800000-feafffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
   IO window: d000-dfff
   MEM window: fe600000-fe7fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.5
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
   IO window: c000-cfff
   MEM window: fe400000-fe5fffff
   PREFETCH window: fd000000-fdffffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:02:00.0 to 64
ACPI: PCI Interrupt 0000:00:1c.4[B] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.4 to 64
ACPI: PCI Interrupt 0000:00:1c.5[C] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
Boot video device is 0000:06:05.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie03]
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
Allocate Port Service[0000:00:1c.5:pcie03]
sisfb: Video ROM found
sisfb: Video RAM at 0xfd000000, mapped to 0xf8880000, size 16384k
sisfb: MMIO at 0xfe4c0000, mapped to 0xf9900000, size 256k
sisfb: Memory heap starting at 16160K, size 32K
sisfb: CRT1 DDC supported
sisfb: CRT1 DDC level: 2=20
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
sisfb: Monitor range H 24-61KHz, V 56-75Hz, Max. dotclock 80MHz
sisfb: Default mode is 800x600x8 (60Hz)
sisfb: Initial vbflags 0x0
Console: switching to colour frame buffer device 100x37
sisfb: 2D acceleration is enabled, y-panning enabled (auto-max)
fb0: XGI Z7 frame buffer device version 1.8.9
sisfb: Copyright (C) 2001-2005 Thomas Winischhofer
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
intel_rng: FWH not detected
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 6=
0 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 35 (level, low) -> IRQ 20
e1000: 0000:03:02.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:04:23:c7:a4:de
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:03:02.1[B] -> GSI 34 (level, low) -> IRQ 21
e1000: 0000:03:02.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:04:23:c7:a4:df
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
Ethernet Channel Bonding Driver: v3.1.3 (June 13, 2007)
bonding: Warning: either miimon or arp_interval and arp_ip_target module pa=
rameters must be specified, otherwise bonding will not detect link failures=
! see bonding.txt for details.
tg3.c:v3.77 (May 31, 2007)
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
eth2: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 10/100/100=
0Base-T Ethernet 00:13:72:3c:fd:fe
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[1]
eth2: dma_rwctrl[76180000] dma_mask[64-bit]
netconsole: not configured, aborting
st: Version 20070203, fixed bufsize 32768, s/g segs 256
ata_piix 0000:00:1f.1: version 2.11
ACPI: Unable to derive IRQ for device 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A]: no GSI
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001fc00 irq =
14
ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001fc08 irq =
15
ata1.00: ATAPI: TSSTcorpDVD-ROM TS-H352C, DE02, max UDMA/33
ata1.01: ATAPI: Seagate STT3401A, 310B, max PIO3
ata1.00: configured for UDMA/33
ata1.01: configured for PIO3
ata2: port disabled. ignoring.
scsi 0:0:0:0: CD-ROM            TSSTcorp DVD-ROM TS-H352C DE02 PQ: 0 ANSI: =
5
sr0: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
sr 0:0:0:0: Attached scsi generic sg0 type 5
scsi 0:0:1:0: Sequential-Access Seagate  STT3401A         310B PQ: 0 ANSI: =
2
st 0:0:1:0: Attached scsi tape st0
st 0:0:1:0: st0: try direct i/o: yes (alignment 512 B)
st 0:0:1:0: Attached scsi generic sg1 type 1
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[C] -> GSI 20 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x0001bc98 ctl 0x0001bc92 bmdma 0x0001bc60 irq =
22
ata4: SATA max UDMA/133 cmd 0x0001bc80 ctl 0x0001bc7a bmdma 0x0001bc68 irq =
22
ata3.00: ATA-7: WDC WD2500JS-75NCB1, 10.02E01, max UDMA/133
ata3.00: 488281250 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata3.01: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
ata3.01: 488281250 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata3.01: configured for UDMA/133
ata4.00: ATA-7: Maxtor 7L250S0, BACE1G10, max UDMA/133
ata4.00: 488281250 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500JS-75N 10.0 PQ: 0 ANSI: =
5
sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 2:0:0:0: [sda] 488281250 512-byte hardware sectors (250000 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
  sda: sda1 sda2 sda3 sda4
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 2:0:1:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: =
5
sd 2:0:1:0: [sdb] 488281250 512-byte hardware sectors (250000 MB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 2:0:1:0: [sdb] 488281250 512-byte hardware sectors (250000 MB)
sd 2:0:1:0: [sdb] Write Protect is off
sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
  sdb: sdb1 sdb2 sdb3 sdb4
sd 2:0:1:0: [sdb] Attached SCSI disk
sd 2:0:1:0: Attached scsi generic sg3 type 0
scsi 3:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: =
5
sd 3:0:0:0: [sdc] 488281250 512-byte hardware sectors (250000 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 3:0:0:0: [sdc] 488281250 512-byte hardware sectors (250000 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
  sdc: sdc1 sdc2 sdc3 sdc4
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg4 type 0
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 22, io mem 0xfeb00400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 22, io base 0x0000bce0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000bcc0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000bca0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
raid6: int32x1    730 MB/s
raid6: int32x2    742 MB/s
raid6: int32x4    667 MB/s
raid6: int32x8    507 MB/s
raid6: mmxx1     1660 MB/s
raid6: mmxx2     1781 MB/s
raid6: sse1x1    1019 MB/s
raid6: sse1x2    1113 MB/s
raid6: sse2x1    2039 MB/s
raid6: sse2x2    1851 MB/s
raid6: using algorithm sse2x1 (2039 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  4008.000 MB/sec
raid5: using function: pIII_sse (4008.000 MB/sec)
md: faulty personality registered for level -5
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redha=
t.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
EDAC MC: Ver: 2.0.1 Sep 21 2007
input: ImExPS/2 Generic Explorer Mouse as /class/input/input2
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (32768 buckets, 262144 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
IP_TPROXY: Transparent proxy support initialized, version 4.0.0
IP_TPROXY: Copyright (c) 2002-2007 BalaBit IT Ltd.
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
ip6_tables: (C) 2000-2006 Netfilter Core Team
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Using IPI No-Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdc4 ...
md:  adding sdc4 ...
md: sdc3 has different UUID to sdc4
md: sdc2 has different UUID to sdc4
md:  adding sdb4 ...
md: sdb3 has different UUID to sdc4
md: sdb2 has different UUID to sdc4
md:  adding sda4 ...
md: sda3 has different UUID to sdc4
md: sda2 has different UUID to sdc4
md: created md4
md: bind<sda4>
md: bind<sdb4>
md: bind<sdc4>
md: running: <sdc4><sdb4><sda4>
raid5: device sdc4 operational as raid disk 2
raid5: device sdb4 operational as raid disk 1
raid5: device sda4 operational as raid disk 0
raid5: allocated 3164kB for md4
raid5: raid level 5 set md4 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
  --- rd:3 wd:3
  disk 0, o:1, dev:sda4
  disk 1, o:1, dev:sdb4
  disk 2, o:1, dev:sdc4
md: considering sdc3 ...
md:  adding sdc3 ...
md: sdc2 has different UUID to sdc3
md:  adding sdb3 ...
md: sdb2 has different UUID to sdc3
md:  adding sda3 ...
md: sda2 has different UUID to sdc3
md: created md15
md: bind<sda3>
md: bind<sdb3>
md: bind<sdc3>
md: running: <sdc3><sdb3><sda3>
raid10: raid set md15 active with 3 out of 3 devices
md15: bitmap initialized from disk: read 12/12 pages, set 0 bits, status: 0
created bitmap (179 pages) for device md15
md: considering sdc2 ...
md:  adding sdc2 ...
md:  adding sdb2 ...
md:  adding sda2 ...
md: created md0
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2><sda2>
raid1: raid set md0 active with 3 out of 3 mirrors
md0: bitmap initialized from disk: read 15/15 pages, set 0 bits, status: 0
created bitmap (239 pages) for device md0
md: ... autorun DONE.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: md0: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 130332
EXT3-fs: md0: 1 orphan inode deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with journal data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 220k freed
EXT3 FS on md0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with journal data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with journal data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2927608k swap on /dev/md15.  Priority:8192 extents:1 across:2927608k
bonding: bond0: setting mode to active-backup (1).
bonding: bond0: Setting MII monitoring interval to 100.
ADDRCONF(NETDEV_UP): bond0: link is not ready
bonding: bond0: Adding slave eth0.
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Con=
trol: RX/TX
bonding: bond0: making interface eth0 the new active one.
bonding: bond0: first active interface up!
bonding: bond0: enslaving eth0 as an active interface with an up link.
bonding: bond0: Adding slave eth1.
ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
ADDRCONF(NETDEV_UP): eth1: link is not ready
bonding: bond0: enslaving eth1 as a backup interface with a down link.
bonding: bond0: Setting eth0 as primary slave.
eth0: no IPv6 routers present
bond0: no IPv6 routers present
device eth0 entered promiscuous mode
device bond0 entered promiscuous mode
device eth0 left promiscuous mode
device bond0 left promiscuous mode
device eth0 entered promiscuous mode
device bond0 entered promiscuous mode
device eth0 left promiscuous mode
device bond0 left promiscuous mode
--- dmesg: end ---

Both dmesg and interrupts are from working system.

This is a quite busy "Intel(R) Pentium(R) D CPU 3.20GHz" running mainly=20
squid and postfix. There are three disks (ata_piix) and LVM on top of a=20
software (md) raid5, with root fs on raid1 and swap on raid10.

I have tested 2.6.20, 2.6.21 and 2.6.22 kernels so far and this problem=20
exists with each release.

Any ideas?

Best regards,


 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-523460431-1190968928=:17152--
