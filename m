Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbYFIMIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbYFIMIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbYFIMIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:08:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:55718 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755634AbYFIMIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:08:42 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/dYZI7WLrdKY3KeD8oxnpUDCG5vf0S7apluxtLJP
	u0/lSSsCE3ggg1
Date: Mon, 9 Jun 2008 14:08:04 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: mhalcrow@us.ibm.com, phillip@hellewell.homeip.net
Subject: (forw) [snakebyte@gmx.de: Several issues with ecryptfs]
Message-ID: <20080609120804.GA13923@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26-rc4 (x86_64)
X-Uptime: 14:04:33 up  1:37,  1 user,  load average: 3.43, 1.93, 2.18
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i already posted this to ecryptfs-devel last week,
but it didnt get moderated yet, so i decided to post it
to lkml too. I also see these with todays -git which already
contains the "eCryptfs: remove unnecessary page decrypt call" fix.

after i saw some of the recent fixes for ecryptfs i decided
i add some basic ecryptfs testing to my testboxes.
This revealed two issues, the first one is a lockdep
warning, the second one is a memory corrupted, getting
reported with slub and slub_debug. I dont
get a corruption warning using slab. I did a make clean, mrproper
and co and rebuild the kernel to make sure this isnt something flaky.
The underlying filesystem is ext3.

Greetings, Eric

root@whiterabbit:~/testing/fs-tests# mount -t ecryptfs foo /media/samba -o key=passphrase:passwd=123456789012345672343,ecryptfs_key_bytes=16,ecryptfs_cipher=aes,ecryptfs_passthrough,ecryptfs_hmac
Attempting to mount with the following options:
  ecryptfs_hmac
  ecryptfs_passthrough
  ecryptfs_key_bytes=16
  ecryptfs_cipher=aes
  ecryptfs_sig=266af63a752e95d3
Mounted eCryptfs
root@whiterabbit:~/testing/fs-tests# touch /media/samba/blafasel


[  615.463946] =======================================================
[  615.464022] [ INFO: possible circular locking dependency detected ]
[  615.464022] 2.6.26-rc4-00168-gc3b25b3 #8
[  615.464022] -------------------------------------------------------
[  615.464022] touch/4428 is trying to acquire lock:
[  615.464022]  (&mount_crypt_stat->global_auth_tok_list_mutex){--..}, at: [<c026e654>] ecryptfs_find_global_auth_tok_for_sig+0x24/0xa0
[  615.464022] 
[  615.464022] but task is already holding lock:
[  615.464022]  (&crypt_stat->keysig_list_mutex){--..}, at: [<c026e721>] ecryptfs_generate_key_packet_set+0x51/0xe70
[  615.464022] 
[  615.464022] which lock already depends on the new lock.
[  615.464022] 
[  615.464022] 
[  615.464022] the existing dependency chain (in reverse order) is:
[  615.464022] 
[  615.464022] -> #1 (&crypt_stat->keysig_list_mutex){--..}:
[  615.464022]        [<c0149b88>] __lock_acquire+0xc58/0x1100
[  615.464022]        [<c014a0b0>] lock_acquire+0x80/0xa0
[  615.464022]        [<c07538fe>] mutex_lock_nested+0x8e/0x2a0
[  615.464022]        [<c026f952>] ecryptfs_add_keysig+0x42/0x80
[  615.464022]        [<c026d812>] ecryptfs_new_file_context+0xe2/0x1f0
[  615.464022]        [<c02689cd>] ecryptfs_create+0x13d/0x330
[  615.464022]        [<c01966fc>] vfs_create+0xac/0x140
[  615.464022]        [<c0199861>] do_filp_open+0x551/0x7a0
[  615.464022]        [<c018c5c9>] do_sys_open+0x49/0xd0
[  615.464022]        [<c018c6b9>] sys_open+0x29/0x40
[  615.464022]        [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[  615.464022]        [<ffffffff>] 0xffffffff
[  615.464022] 
[  615.464022] -> #0 (&mount_crypt_stat->global_auth_tok_list_mutex){--..}:
[  615.464022]        [<c0149990>] __lock_acquire+0xa60/0x1100
[  615.464022]        [<c014a0b0>] lock_acquire+0x80/0xa0
[  615.464022]        [<c07538fe>] mutex_lock_nested+0x8e/0x2a0
[  615.464022]        [<c026e654>] ecryptfs_find_global_auth_tok_for_sig+0x24/0xa0
[  615.464022]        [<c026e7b6>] ecryptfs_generate_key_packet_set+0xe6/0xe70
[  615.464022]        [<c026d5c2>] ecryptfs_write_metadata+0x102/0x270
[  615.464022]        [<c0268a2b>] ecryptfs_create+0x19b/0x330
[  615.464022]        [<c01966fc>] vfs_create+0xac/0x140
[  615.464022]        [<c0199861>] do_filp_open+0x551/0x7a0
[  615.464022]        [<c018c5c9>] do_sys_open+0x49/0xd0
[  615.464022]        [<c018c6b9>] sys_open+0x29/0x40
[  615.464022]        [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[  615.464022]        [<ffffffff>] 0xffffffff
[  615.464022] 
[  615.464022] other info that might help us debug this:
[  615.464022] 
[  615.464022] 2 locks held by touch/4428:
[  615.464022]  #0:  (&sb->s_type->i_mutex_key#11){--..}, at: [<c01994ca>] do_filp_open+0x1ba/0x7a0
[  615.464022]  #1:  (&crypt_stat->keysig_list_mutex){--..}, at: [<c026e721>] ecryptfs_generate_key_packet_set+0x51/0xe70
[  615.464022] 
[  615.464022] stack backtrace:
[  615.464022] Pid: 4428, comm: touch Not tainted 2.6.26-rc4-00168-gc3b25b3 #8
[  615.464022]  [<c01475cf>] print_circular_bug_tail+0x6f/0x80
[  615.464022]  [<c0149990>] __lock_acquire+0xa60/0x1100
[  615.464022]  [<c016d65b>] ? get_page_from_freelist+0x28b/0x530
[  615.464022]  [<c014a0b0>] lock_acquire+0x80/0xa0
[  615.464022]  [<c026e654>] ? ecryptfs_find_global_auth_tok_for_sig+0x24/0xa0
[  615.464022]  [<c07538fe>] mutex_lock_nested+0x8e/0x2a0
[  615.464022]  [<c026e654>] ? ecryptfs_find_global_auth_tok_for_sig+0x24/0xa0
[  615.464022]  [<c026e654>] ? ecryptfs_find_global_auth_tok_for_sig+0x24/0xa0
[  615.464022]  [<c026e654>] ecryptfs_find_global_auth_tok_for_sig+0x24/0xa0
[  615.464022]  [<c026e730>] ? ecryptfs_generate_key_packet_set+0x60/0xe70
[  615.464022]  [<c026e7b6>] ecryptfs_generate_key_packet_set+0xe6/0xe70
[  615.464022]  [<c04bbe0e>] ? extract_entropy+0x4e/0xa0
[  615.464022]  [<c026d5c2>] ecryptfs_write_metadata+0x102/0x270
[  615.464022]  [<c0268a2b>] ecryptfs_create+0x19b/0x330
[  615.464022]  [<c01491f4>] ? __lock_acquire+0x2c4/0x1100
[  615.464022]  [<c01a6ef0>] ? mnt_want_write+0x20/0x90
[  615.464022]  [<c0755577>] ? _spin_unlock+0x27/0x50
[  615.464022]  [<c01ff130>] ? ext3_permission+0x0/0x10
[  615.464022]  [<c01ff13d>] ? ext3_permission+0xd/0x10
[  615.464022]  [<c0195761>] ? permission+0x91/0x100
[  615.464022]  [<c026909a>] ? ecryptfs_permission+0x3a/0x60
[  615.464022]  [<c0269060>] ? ecryptfs_permission+0x0/0x60
[  615.464022]  [<c0195761>] ? permission+0x91/0x100
[  615.464022]  [<c01966fc>] vfs_create+0xac/0x140
[  615.464022]  [<c0755577>] ? _spin_unlock+0x27/0x50
[  615.464022]  [<c0199861>] do_filp_open+0x551/0x7a0
[  615.464022]  [<c0755577>] ? _spin_unlock+0x27/0x50
[  615.464022]  [<c018c5c9>] do_sys_open+0x49/0xd0
[  615.464022]  [<c018c6b9>] sys_open+0x29/0x40
[  615.464022]  [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[  615.464022]  =======================

Same mount options as above and i get this:

root@whiterabbit:~/testing/fs-tests# fsx -N 500 -S 0 /media/samba/stress/nfs
Seed set to 8832
Floating point exception

[  728.722691] =============================================================================
[  728.722864] BUG kmalloc-4096: Redzone overwritten
[  728.722959] -----------------------------------------------------------------------------
[  728.722964] 
[  728.723029] INFO: 0xc168e0f0-0xc168e0f3. First byte 0xee instead of 0xcc
[  728.723029] INFO: Allocated in 0xdbebd943 age=175239678 cpu=2471483887 pid=-1831017312
[  728.723029] INFO: Freed in 0x3ba71192 age=3948966532 cpu=3775324926 pid=-164087254
[  728.723029] INFO: Slab 0xc102f100 objects=7 used=6 fp=0xc168e120 flags=0x400020c3
[  728.723029] INFO: Object 0xc168d0f0 @offset=20720 fp=0x408702c1
[  728.723029] 
[  728.723029] Bytes b4 0xc168d0e0:  fa d6 78 41 d0 be 2e 59 24 3c d8 30 9b 24 c4 8a ��xAо.Y$<�0.$�.
[  728.723029]   Object 0xc168d0f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  728.723029]   Object 0xc168d100:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  728.723029]   Object 0xc168d110:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  728.723029]   Object 0xc168d120:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  728.723029]   Object 0xc168d130:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  728.723029]   Object 0xc168d140:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  728.723029]   Object 0xc168d150:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  728.723029]   Object 0xc168d160:  00 00 00 00 00 00 00 00 00 00 00 ................
[  728.723029]  Redzone 0xc168e0f0:  ee a2 7e                   ���~            
[  728.723029]  Padding 0xc168e118:  9b 44 e4 90 6d             .D䭰.m.        
[  728.723029] Pid: 4434, comm: fsx Not tainted 2.6.26-rc4-00168-gc3b25b3 #8
[  728.723029]  [<c018845f>] print_trailer+0xaf/0xf0
[  728.723029]  [<c018853c>] check_bytes_and_report+0x9c/0xc0
[  728.723029]  [<c0188813>] check_object+0x53/0x1f0
[  728.723029]  [<c0189a6a>] __slab_free+0x1ea/0x2e0
[  728.723029]  [<c0189cae>] kfree+0x8e/0x120
[  728.723029]  [<c0268d1c>] ? ecryptfs_truncate+0x14c/0x2b0
[  728.723029]  [<c0268d1c>] ? ecryptfs_truncate+0x14c/0x2b0
[  728.723029]  [<c0268d1c>] ecryptfs_truncate+0x14c/0x2b0
[  728.723029]  [<c02691ef>] ecryptfs_setattr+0x12f/0x1e0
[  728.723029]  [<c01a32a0>] ? notify_change+0x240/0x340
[  728.723029]  [<c01a313a>] notify_change+0xda/0x340
[  728.723029]  [<c018d139>] do_truncate+0x69/0x90
[  728.723029]  [<c07574b4>] ? do_page_fault+0x194/0x690
[  728.723029]  [<c018d29c>] do_sys_ftruncate+0x13c/0x160
[  728.723029]  [<c018d324>] sys_ftruncate+0x24/0x30
[  728.723029]  [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[  728.723029]  =======================
[  728.723029] FIX kmalloc-4096: Restoring 0xc168e0f0-0xc168e0f3=0xcc
[  728.723029] 
[  858.518733] =============================================================================
[  858.518910] BUG kmalloc-4096: Redzone overwritten
[  858.519006] -----------------------------------------------------------------------------
[  858.519011] 
[  858.519025] INFO: 0xc2fe9000-0xc2fe9003. First byte 0x11 instead of 0xcc
[  858.519025] INFO: Allocated in 0x2a97d247 age=663075257 cpu=3180298127 pid=757475889
[  858.519025] INFO: Freed in 0xf412a58c age=994671576 cpu=977006770 pid=-2082819191
[  858.519025] INFO: Slab 0xc1061d00 objects=7 used=1 fp=0xc2fe9030 flags=0x400020c3
[  858.519025] INFO: Object 0xc2fe8000 @offset=0 fp=0xe59f59d1
[  858.519025] 
[  858.519025]   Object 0xc2fe8000:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  858.519025]   Object 0xc2fe8010:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  858.519025]   Object 0xc2fe8020:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  858.519025]   Object 0xc2fe8030:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  858.519025]   Object 0xc2fe8040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  858.519025]   Object 0xc2fe8050:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  858.519025]   Object 0xc2fe8060:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  858.519025]   Object 0xc2fe8070:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[  858.519025]  Redzone 0xc2fe9000:  11 b6 10 7d                                     .�.}            
[  858.519025]  Padding 0xc2fe9028:  54 78 7e 90 e9 c6 e6 1a                         Tx~.���.        
[  858.519025] Pid: 4437, comm: fsx Not tainted 2.6.26-rc4-00168-gc3b25b3 #8
[  858.519025]  [<c018845f>] print_trailer+0xaf/0xf0
[  858.519025]  [<c018853c>] check_bytes_and_report+0x9c/0xc0
[  858.519025]  [<c0188813>] check_object+0x53/0x1f0
[  858.519025]  [<c0189a6a>] __slab_free+0x1ea/0x2e0
[  858.519025]  [<c0189cae>] kfree+0x8e/0x120
[  858.519025]  [<c0268d1c>] ? ecryptfs_truncate+0x14c/0x2b0
[  858.519025]  [<c0268d1c>] ? ecryptfs_truncate+0x14c/0x2b0
[  858.519025]  [<c0268d1c>] ecryptfs_truncate+0x14c/0x2b0
[  858.519025]  [<c02691ef>] ecryptfs_setattr+0x12f/0x1e0
[  858.519025]  [<c01a32a0>] ? notify_change+0x240/0x340
[  858.519025]  [<c01a313a>] notify_change+0xda/0x340
[  858.519025]  [<c018d139>] do_truncate+0x69/0x90
[  858.519025]  [<c07574b4>] ? do_page_fault+0x194/0x690
[  858.519025]  [<c018d29c>] do_sys_ftruncate+0x13c/0x160
[  858.519025]  [<c018d324>] sys_ftruncate+0x24/0x30
[  858.519025]  [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[  858.519025]  =======================
[  858.519025] FIX kmalloc-4096: Restoring 0xc2fe9000-0xc2fe9003=0xcc
[  858.519025] 


/usr/bin/fstest -n 20 -l 20 -f 20 -s 40000 -p /media/samba/stress/


[  909.845733] =============================================================================
[  909.845903] BUG kmalloc-4096: Redzone overwritten
[  909.845997] -----------------------------------------------------------------------------
[  909.846002] 
[  909.846009] INFO: 0xc2fec090-0xc2fec093. First byte 0xb4 instead of 0xcc
[  909.846009] INFO: Allocated in 0xc008c42e age=589178417 cpu=4101696668 pid=2008059572
[  909.846009] INFO: Freed in 0x1b74c899 age=2541795435 cpu=3721940232 pid=-297573540
[  909.846009] INFO: Slab 0xc1061d00 objects=7 used=5 fp=0xc2fed0f0 flags=0x400020c3
[  909.846009] INFO: Object 0xc2feb090 @offset=12432 fp=0xd5e9dc0a
[  909.846009] 
[  909.846009] Bytes b4 0xc2feb080:  a2 42 56 0d 97 5a cb 7a f2 28 d7 83 47 e8 20 eb �BV..Z�z�(�.G�.
[  909.846009]   Object 0xc2feb090:  02 df ae 2b af 07 0d 81 3b a4 08 c9 48 da 29 60 .߮+�...;�.�H�)`
[  909.846009]   Object 0xc2feb0a0:  8e bc 67 56 91 a7 db 43 0b 46 32 c5 b1 ec 6d 6a .�gV.��C.F2ű�mj
[  909.846009]   Object 0xc2feb0b0:  6f 53 36 a8 7b 82 d8 73 2d f0 b4 56 4f 4e 44 a4 oS6�{.�s-��VOND�
[  909.846009]   Object 0xc2feb0c0:  6f 31 d3 9c c6 65 8a a7 1a 36 e4 f7 b2 25 4b 27 o1�.�e.�.6���%K'
[  909.846009]   Object 0xc2feb0d0:  fe 68 f3 c2 c1 bb e1 84 f7 3f ac 8a 3a d8 0a cc �h�����.�?�.:�.
[  909.846009]   Object 0xc2feb0e0:  5f ac db a1 a7 fc b1 20 5f 39 1c 9c 0c d6 d5 ae _�ۡ���._9...�ծ
[  909.846009]   Object 0xc2feb0f0:  ff 8c 72 4c d0 8b 18 4c c2 1c 5c a8 e1 67 d4 cd �.rL�..L�.\��g�
[  909.846009]   Object 0xc2feb100:  3d 22 da 8e 49 4b 89 47 fa 3c 98 ef 44 e3 2f 8b ="�.IK.G�<.�D�/.
[  909.846009]  Redzone 0xc2fec090:  b4 7e ef b2                                     �~��            
[  909.846009]  Padding 0xc2fec0b8:  53 b3 54 6c 6e 47 e6 a1                         S�TlnG��        
[  909.846009] Pid: 4444, comm: fstest Not tainted 2.6.26-rc4-00168-gc3b25b3 #8
[  909.846009]  [<c018845f>] print_trailer+0xaf/0xf0
[  909.846009]  [<c018853c>] check_bytes_and_report+0x9c/0xc0
[  909.846009]  [<c0188813>] check_object+0x53/0x1f0
[  909.846009]  [<c0189a6a>] __slab_free+0x1ea/0x2e0
[  909.846009]  [<c0189cae>] kfree+0x8e/0x120
[  909.846009]  [<c026dc24>] ? ecryptfs_encrypt_page+0x304/0x560
[  909.846009]  [<c026dc24>] ? ecryptfs_encrypt_page+0x304/0x560
[  909.846009]  [<c026dc24>] ecryptfs_encrypt_page+0x304/0x560
[  909.846009]  [<c026e162>] ? ecryptfs_decrypt_page+0x2e2/0x4c0
[  909.846009]  [<c026b9c2>] ecryptfs_commit_write+0xe2/0x340
[  909.846009]  [<c026b8e0>] ? ecryptfs_commit_write+0x0/0x340
[  909.846009]  [<c016901c>] generic_file_buffered_write+0x33c/0x5e0
[  909.846009]  [<c0753868>] ? mutex_unlock+0x8/0x10
[  909.846009]  [<c01a582d>] ? mnt_drop_write+0x1d/0x120
[  909.846009]  [<c01a2c3e>] ? file_update_time+0x8e/0xd0
[  909.846009]  [<c0169525>] __generic_file_aio_write_nolock+0x265/0x520
[  909.846009]  [<c0169833>] ? generic_file_aio_write+0x53/0xe0
[  909.846009]  [<c0169833>] ? generic_file_aio_write+0x53/0xe0
[  909.846009]  [<c0169846>] generic_file_aio_write+0x66/0xe0
[  909.846009]  [<c018df9c>] do_sync_write+0xcc/0x110
[  909.846009]  [<c013a540>] ? autoremove_wake_function+0x0/0x40
[  909.846009]  [<c01c7b57>] ? dnotify_parent+0x37/0x80
[  909.846009]  [<c0755577>] ? _spin_unlock+0x27/0x50
[  909.846009]  [<c018e7e9>] vfs_write+0x99/0x130
[  909.846009]  [<c018ded0>] ? do_sync_write+0x0/0x110
[  909.846009]  [<c018eeb3>] sys_pwrite64+0x63/0x80
[  909.846009]  [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[  909.846009]  =======================
[  909.846009] FIX kmalloc-4096: Restoring 0xc2fec090-0xc2fec093=0xcc
[  909.846009] 
[  909.927520] =============================================================================
[  909.927664] BUG kmalloc-4096: Redzone overwritten
[  909.927758] -----------------------------------------------------------------------------
[  909.927763] 
[  909.927943] INFO: 0xc2fed0c0-0xc2fed0c3. First byte 0xbe instead of 0xcc
[  909.928008] INFO: Allocated in 0x5362fa0d age=2176032693 cpu=3541331536 pid=1456363
[  909.928008] INFO: Freed in 0x8cb15a82 age=3475273534 cpu=2285274145 pid=-493192386
[  909.928008] INFO: Slab 0xc1061d00 objects=7 used=6 fp=0xc2fee120 flags=0x400020c3
[  909.928008] INFO: Object 0xc2fec0c0 @offset=16576 fp=0x4c0f8b43
[  909.928008] 
[  909.928008] Bytes b4 0xc2fec0b0:  f8 86 44 0a ef e5 d3 87 11 5d 5c 48 c6 7f b7 4a �.D.���..]\H�.�J
[  909.928008]   Object 0xc2fec0c0:  fa ce 0c 1c 53 76 5e 3c d4 68 b5 c7 a6 0f b3 50 ��..Sv^<�h�Ǧ.�P
[  909.928008]   Object 0xc2fec0d0:  52 19 1b e0 89 68 7e 2b 3a 85 cf 6f bf bf c4 0f R..�.h~+:.�o���.
[  909.928008]   Object 0xc2fec0e0:  28[  909.961456] =============================================================================
[  909.961599] BUG kmalloc-4096: Redzone overwritten
[  909.961693] -----------------------------------------------------------------------------
[  909.961698] 
[  909.961878] INFO: 0xc2fee0f0-0xc2fee0f3. First byte 0x70 instead of 0xcc
[  909.962011] INFO: Allocated in 0xa2467a90 age=3578169626 cpu=3245504730 pid=-2071354349
[  909.962011] INFO: Freed in 0xfc52a610 age=503857749 cpu=3018491243 pid=-1872877663
[  909.962011] INFO: Slab 0xc1061d00 objects=7 used=7 fp=0x00000000 flags=0x400020c3
[  909.962011] INFO: Object 0xc2fed0f0 @offset=20720 fp=0x75ca69d5
[  909.962011] 
[  909.962011] Bytes b4 0xc2fed0e0:  e7 b5 78 6a ca 34 a5 f7 ca 57 4e 3d ae 8d 3b 34 ��xj�4���WN=�.;4
[  909.962011]   Object 0xc2fed0f0:  3f 3d 3a 84 5c 5c 4a 5a c6 e9 89 a2 21 21 7a c4 ?=:.\\JZ��.�!!z
[  909.962011]   Object 0xc2fed100:  18 cf 57 8b f8 e8 fa 50 ed 0a ba 72 ca 78 b0 66 .�W.���P�.�r�x�f
[  909.962011]   Object 0xc2fed110:  f4 ca 59 b2 12 p..�            
[  909.962011]  Padding 0xc2fee118:  fd 37 3a 7e 7a 7a 51                         @�7:~zzQ        
[  909.962011] Pid: 4443, comm: fstest Not tainted 2.6.26-rc4-00168-gc3b25b3 #8
[  909.962011]  [<c018845f>] print_trailer+0xaf/0xf0
[  909.962011]  [<c018853c>] check_bytes_and_report+0x9c/0xc0
[  909.962011]  [<c0188813>] check_object+0x53/0x1f0
[  909.962011]  [<c0189a6a>] __slab_free+0x1ea/0x2e0
[  909.962011]  [<c0189cae>] kfree+0x8e/0x120
[  909.962011]  [<c026dc24>] ? ecryptfs_encrypt_page+0x304/0x560
[  909.962011]  [<c026dc24>] ? ecryptfs_encrypt_page+0x304/0x560
[  909.962011]  [<c026dc24>] ecryptfs_encrypt_page+0x304/0x560
[  909.962011]  [<c026b9c2>] ecryptfs_commit_write+0xe2/0x340
[  909.962011]  [<c026b8e0>] ? ecryptfs_commit_write+0x0/0x340
[  909.962011]  [<c016901c>] generic_file_buffered_write+0x33c/0x5e0
[  909.962011]  [<c0753868>] ? mutex_unlock+0x8/0x10
[  909.962011]  [<c01a582d>] ? mnt_drop_write+0x1d/0x120
[  909.962011]  [<c01a2c3e>] ? file_update_time+0x8e/0xd0
[  909.962011]  [<c0169525>] __generic_file_aio_write_nolock+0x265/0x520
[  909.962011]  [<c0169833>] ? generic_file_aio_write+0x53/0xe0
[  909.962011]  [<c0169833>] ? generic_file_aio_write+0x53/0xe0
[  909.962011]  [<c0169846>] generic_file_aio_write+0x66/0xe0
[  909.962011]  [<c018df9c>] do_sync_write+0xcc/0x110
[  909.962011]  [<c0105dd5>] ? do_softirq+0x55/0xd0
[  909.962011]  [<c013a540>] ? autoremove_wake_function+0x0/0x40
[  909.962011]  [<c01c7b57>] ? dnotify_parent+0x37/0x80
[  909.962011]  [<c0755577>] ? _spin_unlock+0x27/0x50
[  909.962011]  [<c018e7e9>] vfs_write+0x99/0x130
[  909.962011]  [<c018ded0>] ? do_sync_write+0x0/0x110
[  909.962011]  [<c018eeb3>] sys_pwrite64+0x63/0x80
[  909.962011]  [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[  909.962011]  =======================
[  909.962011] FIX kmalloc-4096: Restoring 0xc2fee0f0-0xc2fee0f3=0xcc
[  909.962011] 
[  910.010435] =============================================================================
[  910.010590] BUG kmalloc-4096: Redzone overwritten
[  910.010684] -----------------------------------------------------------------------------
[  910.010689] 
[  910.010870] INFO: 0xc331a030-0xc331a033. First byte 0x87 instead of 0xcc
[  910.011012] INFO: Allocated in 0x2cd7890d age=1902030838 cpu=1559256163 pid=-206528884
[  910.011012] INFO: Freed in 0x7e7e171c age=1821308379 cpu=4164296002 pid=1203550846
[  910.011012] INFO: Slab 0xc1068300 objects=7 used=4 fp=0xc331c0c0 flags=0x400020c3
[  910.011012] INFO: Object 0xc3319030 @offset=4144 fp=0x90df867c
[  910.011012] 
[  910.011012] Bytes b4 0xc3319020:  3d 58 6d 76 3a 84 70 1c ef 60 76 3e 3e 68 2c 64 =Xmv:.p.�`v>>h,d
[  910.011012]   Object 0xc3319030:  89 8f be 5f fa 99 cf 65 58 0c d0 09 96 7f 84 81 ..�_�.�eX.�.....
[  910.011012]   Object 0xc3319040:  94 41 6e ac 1d e0 db 5f bb 42 db 7d 08 93 53 aa .An�.��_�B�}..S�
[  910.011012]   Object 0xc3319050:  31 36 50 b0 57 a3 e0 bd ab 34 bb cb 96 ce 44 10 16P�W�ཫ4��.�D.
[  910.011012]   Object 0xc3319060:  87 68 0e b7 30 26 5c 45 32 be 57 41 64 90 d5 45 .h.�0&\E2�WAd.�E
[  910.011012]   Object 0xc3319070:  bb 9d bc 3e 91 c2 c5 c9 13 bd 81 10 11 2a ad 29 �.�>.���.�...*�)
[  910.011012]   Object 0xc3319080:  fc 11 ed 34 3f 87 32 6f 83 0d aa cb 5f fb 04 29 �.�4?.2o..��_
[  910.011012]   Object 0xc3319090:  0a f3 b0 34 e9 8a ac bb c1 f4 5e ec bf 5b 21 32 .��4�.����^��[!2
[  910.011012]   Object 0xc33190a0:  5d f6 11 38 1c 6c 6f 09 11 a5 ed 5c cf 73 c4 98 ]�.8.lo..��\�s�.
[  910.011012]  Redzone 0xc331a030:  87 e9 68 e2                                     .�h�            
[  910.011012]  Padding 0xc331a058:  2a 7d 06 a7 17 eb 0d 39                         *}.�.�.9        
[  910.011012] Pid: 4442, comm: fstest Not tainted 2.6.26-rc4-00168-gc3b25b3 #8
[  910.011012]  [<c018845f>] print_trailer+0xaf/0xf0
[  910.011012]  [<c018853c>] check_bytes_and_report+0x9c/0xc0
[  910.011012]  [<c0188813>] check_object+0x53/0x1f0
[  910.011012]  [<c0189a6a>] __slab_free+0x1ea/0x2e0
[  910.011012]  [<c0189cae>] kfree+0x8e/0x120
[  910.011012]  [<c026dc24>] ? ecryptfs_encrypt_page+0x304/0x560
[  910.011012]  [<c026dc24>] ? ecryptfs_encrypt_page+0x304/0x560
[  910.011012]  [<c026dc24>] ecryptfs_encrypt_page+0x304/0x560
[  910.011012]  [<c026b9c2>] ecryptfs_commit_write+0xe2/0x340
[  910.011012]  [<c026b8e0>] ? ecryptfs_commit_write+0x0/0x340
[  910.011012]  [<c016901c>] generic_file_buffered_write+0x33c/0x5e0
[  910.011012]  [<c0753868>] ? mutex_unlock+0x8/0x10
[  910.011012]  [<c01a582d>] ? mnt_drop_write+0x1d/0x120
[  910.011012]  [<c01a2c3e>] ? file_update_time+0x8e/0xd0
[  910.011012]  [<c0169525>] __generic_file_aio_write_nolock+0x265/0x520
[  910.011012]  [<c0169833>] ? generic_file_aio_write+0x53/0xe0
[  910.011012]  [<c0169833>] ? generic_file_aio_write+0x53/0xe0
[  910.011012]  [<c0169846>] generic_file_aio_write+0x66/0xe0
[  910.011012]  [<c018df9c>] do_sync_write+0xcc/0x110
[  910.011012]  [<c013a540>] ? autoremove_wake_function+0x0/0x40
[  910.011012]  [<c01c7b57>] ? dnotify_parent+0x37/0x80
[  910.011012]  [<c0755577>] ? _spin_unlock+0x27/0x50
[  910.011012]  [<c018e7e9>] vfs_write+0x99/0x130
[  910.011012]  [<c018ded0>] ? do_sync_write+0x0/0x110
[  910.011012]  [<c018eeb3>] sys_pwrite64+0x63/0x80
sysenter_past_esp+0x6a/0xb1
[  910.011012]  =======================
[  910.011012] FIX kmalloc-4096: Restoring 0xc331a030-0xc331a033=0xcc
[  910.011012] 
[  910.036467] =============================================================================
[  910.036611] BUG kmalloc-4096: Redzone overwritten
[  910.036705] -----------------------------------------------------------------------------
[  910.036710] 
[  910.036891] INFO: 0xc331b060-0xc331b063. First byte 0x60 instead of 0xcc
[  910.037012] INFO: Allocated in 0x95aa2fc age=846244220 cpu=288210818 pid=-1937427097
[  910.037012] INFO: Freed in 0x7c1447d7 age=455496820 cpu=2025920559 pid=-934980749
[  910.037012] INFO: Slab 0xc1068300 objects=7 used=5 fp=0xc331d0f0 flags=0x400020c3
[  910.037012] INFO: Object 0xc331a060 @offset=8288 fp=0x275c46c7
[  910.037012] 
[  910.037012] Bytes b4 0xc331a050:  7e ba bc 47 ff 58 7a 93 2a 7d 06 a7 17 eb 0d 39 ~��G�Xz.*}.�.�.9
[  910.037012]   Object 0xc331a060:  4d cf bd c4 0a 27 bd 81 77 e1 32 2a d2 46 5c 97 MϽ�.'�.w�2*�F\.
[  910.037012]   Object 0xc331a070:  87 ad c3 3b 82 0d 68 f6 89 5c 35 24 4b 66 fe 62 .��;..h�.\5$Kf�b
[  910.037012]   Object 0xc331a080:  73 b7 65 20 69 44 16 63 89 e2 92 72 95 83 9f d3 s�e.iD.c.�.r...
[  910.037012]   Object 0xc331a090:  9e 35 4b e1 11 53 a3 5f 1f 68 b3 dc 11 a0 c3 d0 .5K�.S�_.h��..�
[  910.037012]   Object 0xc331a0a0:  7a 60 31 ae 77 97 24 01 b5 df a1 6e 8c d4 4e 00 z`1�w.$.�ߡn.�N.
[  910.037012]   Object 0xc331a0b0:  4f fc d1 30 fe 8b 33 fb e3 c5 d5 6b 1b 93 a4 4c O��0�.3����k..�L
[  910.037012]   Object 0xc331a0c0:  40 f6 5f f3 2e ed 3d 08 8a 09 04 b9 db b1 6d c1 @�_�.�=....�۱m
[  910.037012]   Object 0xc331a0d0:  02 1c 7b 48 08 6c 0e e9 df a0 c6 82 fc 70 91 df ..{H.l.��.�.
[  910.037012]  Redzone 0xc331b060:  60 09 09 43                                     `..C            
[  910.037012]  Padding 0xc331b088:  65 d8 ac c6 da 40 a6 09                         eج��@�.        
[  910.037012] Pid: 4444, comm: fstest Not tainted 2.6.26-rc4-00168-gc3b25b3 #8
[  910.037012]  [<c018845f>] print_trailer+0xaf/0xf0
[  910.037012]  [<c018853c>] check_bytes_and_report+0x9c/0xc0
[  910.037012]  [<c0188813>] check_object+0x53/0x1f0
[  910.037012]  [<c0189a6a>] __slab_free+0x1ea/0x2e0
[  910.037012]  [<c0189cae>] kfree+0x8e/0x120
[  910.037012]  [<c026dc24>] ? ecryptfs_encrypt_page+0x304/0x560
[  910.037012]  [<c026dc24>] ? ecryptfs_encrypt_page+0x304/0x560
[  910.037012]  [<c026dc24>] ecryptfs_encrypt_page+0x304/0x560
[  910.037012]  [<c026b9c2>] ecryptfs_commit_write+0xe2/0x340
[  910.037012]  [<c026b8e0>] ? ecryptfs_commit_write+0x0/0x340
[  910.037012]  [<c016901c>] generic_file_buffered_write+0x33c/0x5e0
[  910.037012]  [<c0753868>] ? mutex_unlock+0x8/0x10
[  910.037012]  [<c01a582d>] ? mnt_drop_write+0x1d/0x120
[  910.037012]  [<c01a2c3e>] ? file_update_time+0x8e/0xd0
[  910.037012]  [<c0169525>] __generic_file_aio_write_nolock+0x265/0x520
[  910.037012]  [<c0169833>] ? generic_file_aio_write+0x53/0xe0
[  910.037012]  [<c0169833>] ? generic_file_aio_write+0x53/0xe0
[  910.037012]  [<c0169846>] generic_file_aio_write+0x66/0xe0
[  910.037012]  [<c018df9c>] do_sync_write+0xcc/0x110
[  910.037012]  [<c013a540>] ? autoremove_wake_function+0x0/0x40
[  910.037012]  [<c01c7b57>] ? dnotify_parent+0x37/0x80
[  910.037012]  [<c0755577>] ? _spin_unlock+0x27/0x50
[  910.037012]  [<c018e7e9>] vfs_write+0x99/0x130
[  910.037012]  [<c018ded0>] ? do_sync_write+0x0/0x110
[  910.037012]  [<c018eeb3>] sys_pwrite64+0x63/0x80
[  910.037012]  [<c0103d6d>] sysenter_past_esp+0x6a/0xb1
[  910.037012]  =======================
[  910.037012] FIX kmalloc-4096: Restoring 0xc331b060-0xc331b063=0xcc
[  910.037012] 



