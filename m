Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbYF1KiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbYF1KiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 06:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYF1KiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 06:38:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37374 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbYF1KiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ROhEoY0JDuKTnB0AN/FMwD0N/woLG/PDMWEPqdDFnxhTBkUk8wIzOOVw1yxhvcoH8h
         py+JB7w2UKVtHMzjp+bhFyRdBwfTt5NMW/hRKFNCfmth1hHtaNDguBch4nNhl12O7i9I
         nG/RubE6YFwbGtD18fZS0UzmbiyBZLmHQWi2M=
Message-ID: <48661488.10304@gmail.com>
Date: Sat, 28 Jun 2008 13:38:00 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Ctrl+C doesn't interrupt process waiting for I/O
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have encountered the following situation several times, but I've been
unable to come up with a way to reproduce this until now:
 - some process is keeping the disk busy (some cron job for example:
updatedb, chkrootkit, ...)
 - other processes that want to do I/O have to wait (this is normal)
 - I have a (I/O bound) process running in my terminal, and I want to
interrupt it with Ctrl+C
 - I type Ctrl+C several times, and the process is not interrupted for
several seconds (10-30 secs)
 - if I type Ctrl+Z, and use kill %1 the process dies faster than
waiting for it to react to Ctrl+C

This issue occurs both on my x86-64 machine that uses reiserfs, and on
my x86 machine that uses XFS, so it doesn't seem related to the
underlying FS.
I use 2.6.25-2 and 2.6.26-rc8 now; I don't recall seeing this behaviour
with old kernels (IIRC I see this since 2.6.21 or 2.6.23).

Is this intended behaviour, or should I report a bug?

If it should be considered a bug, I will try several kernels to see if
there is a particular kernel version that introduced this behaviour.

To reproduce this issue here is a testcase:
Step 1: Run this shell script in a terminal in X (gnome-terminal,
konsole, ...):
#!/bin/sh
# choose a size that will keep the disks busy for about half a minute or
more
dd if=/dev/zero of=xt bs=100M count=4&
dd if=/dev/zero of=yt bs=100M count=4&
rm xt
rm yt
wait %1 %2

Step 2: Run latencytop
Step 3: In another terminal run an I/O bound process and try to
interrupt it with Ctrl+C, see how fast it responds, for example:
edwin@thunder:~/tst$ find / >/dev/null
find: `/boot/lost+found': Permission denied
^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C
edwin@thunder:~/tst$

Step 4: repeat step 3 until you get a behaviour like the above (repeat
20-30 times, it doesn't always happen, when it happens you have to press
Ctrl+C several times in order for the process to react)

Here is the output of /proc/latency_stats when this situation occured,
notice that even select has a high latency:

Latency Top version : v0.1
555 202326 4994 do_sys_poll sys_poll sysenter_past_esp
430 515897 4994 do_select core_sys_select sys_select sysenter_past_esp
12 1140 1013 tty_wait_until_sent set_termios tty_mode_ioctl n_tty_ioctl
tty_ioctl vfs_ioctl do_vfs_ioctl sys_ioctl sysenter_past_esp
434 60405 4522 do_select core_sys_select sys_select sysenter_past_esp
21 244388 54486 blk_execute_rq scsi_execute scsi_execute_req
sr_test_unit_ready sr_media_change media_changed cdrom_media_changed
sr_block_media_changed check_disk_change cdrom_open sr_block_open do_open
21 44988 7252 blk_execute_rq scsi_execute scsi_execute_req
sr_test_unit_ready sr_drive_status cdrom_ioctl sr_block_ioctl
blkdev_driver_ioctl blkdev_ioctl block_ioctl vfs_ioctl do_vfs_ioctl
7 7052 1185 blk_execute_rq scsi_execute sr_do_ioctl sr_packet
cdrom_get_media_event sr_drive_status cdrom_ioctl sr_block_ioctl
blkdev_driver_ioctl blkdev_ioctl block_ioctl vfs_ioctl
7 4399 735 blk_execute_rq scsi_execute scsi_execute_req
ioctl_internal_command scsi_set_medium_removal sr_lock_door
cdrom_release sr_block_release __blkdev_put blkdev_put blkdev_close __fput
32 5646 3269 sys_epoll_wait sysenter_past_esp
14 14108 3260 futex_wait do_futex sys_futex sysenter_past_esp
4 5257 4095 futex_wait do_futex sys_futex sysenter_past_esp
7 2712 1396 pipe_wait pipe_read do_sync_read vfs_read sys_read
sysenter_past_esp
2 0 0 pipe_wait pipe_read do_sync_read vfs_read sys_read sysenter_past_esp
208 1996603 953067 xfs_ilock xfs_iomap __xfs_get_blocks xfs_get_blocks
__block_prepare_write block_write_begin xfs_vm_write_begin
generic_file_buffered_write xfs_write xfs_file_aio_write do_sync_write
vfs_write
21 10264428 915514 get_request_wait __make_request generic_make_request
submit_bio xfs_submit_ioend_bio xfs_submit_ioend xfs_page_state_convert
xfs_vm_writepage __writepage write_cache_pages generic_writepages
xfs_vm_writepages
26 3369263 2260529 down xfs_buf_iowait xfs_buf_iostart
xfs_buf_read_flags xfs_trans_read_buf xfs_imap_to_bp xfs_itobp xfs_iread
xfs_iget_core xfs_iget xfs_lookup xfs_vn_lookup
1 17888 17888 down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags
xfs_trans_read_buf xfs_da_do_buf xfs_da_read_buf xfs_dir2_block_getdents
xfs_readdir xfs_file_readdir vfs_readdir sys_getdents64
2 8226 7641 down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags
xfs_trans_read_buf xfs_da_do_buf xfs_da_read_buf xfs_dir2_leaf_getdents
xfs_readdir xfs_file_readdir vfs_readdir sys_getdents64
2 16090 10971 down xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags
xfs_trans_read_buf xfs_da_do_buf xfs_da_read_buf
xfs_dir2_leaf_lookup_int xfs_dir2_leaf_lookup xfs_dir_lookup xfs_lookup
xfs_vn_lookup
1 2149 2149 down xfs_buf_lock _xfs_buf_find xfs_buf_get_flags
xfs_buf_read_flags xfs_trans_read_buf xfs_da_do_buf xfs_da_read_buf
xfs_dir2_leaf_getdents xfs_readdir xfs_file_readdir vfs_readdir
2 0 0 unix_stream_recvmsg sock_recvmsg sys_recvfrom sys_recv
sys_socketcall sysenter_past_esp
43 1340361 1336178 xfs_ilock xfs_iomap xfs_map_blocks
xfs_page_state_convert xfs_vm_writepage __writepage write_cache_pages
generic_writepages xfs_vm_writepages do_writepages
__writeback_single_inode sync_sb_inodes
1 6 6 xfs_ilock xfs_iomap_write_allocate xfs_iomap xfs_map_blocks
xfs_page_state_convert xfs_vm_writepage __writepage write_cache_pages
generic_writepages xfs_vm_writepages do_writepages __writeback_single_inode
64 1052948 21773 congestion_wait __alloc_pages_internal __alloc_pages
__grab_cache_page block_write_begin xfs_vm_write_begin
generic_file_buffered_write xfs_write xfs_file_aio_write do_sync_write
vfs_write sys_write
3 5264928 3610252 sync_page wait_on_page_bit
wait_on_page_writeback_range filemap_fdatawait xfs_fsync xfs_file_fsync
do_fsync __do_fsync sys_fsync sysenter_past_esp
1 284000 284000 get_request_wait __make_request generic_make_request
submit_bio _xfs_buf_ioapply xfs_buf_iorequest xlog_bdstrat_cb xlog_sync
xlog_state_release_iclog xlog_state_sync _xfs_log_force _xfs_trans_commit
3 1724786 1319135 xlog_state_sync _xfs_log_force _xfs_trans_commit
xfs_fsync xfs_file_fsync do_fsync __do_fsync sys_fsync sysenter_past_esp
3 2851878 1642865 down xfs_buf_lock _xfs_buf_find xfs_buf_get_flags
xfs_buf_read_flags xfs_trans_read_buf xfs_alloc_read_agf
xfs_alloc_fix_freelist xfs_alloc_vextent xfs_bmap_btalloc xfs_bmap_alloc
xfs_bmapi
17 43 23 xfs_ilock xfs_iomap_write_allocate xfs_iomap xfs_map_blocks
xfs_page_state_convert xfs_vm_writepage shrink_page_list
shrink_inactive_list shrink_zone try_to_free_pages
__alloc_pages_internal __alloc_pages
1 45 45 down xfs_buf_lock _xfs_buf_find xfs_buf_get_flags
xfs_buf_read_flags xfs_trans_read_buf xfs_btree_read_bufs
xfs_alloc_lookup xfs_alloc_lookup_eq xfs_alloc_fixup_trees
xfs_alloc_ag_vextent_size xfs_alloc_ag_vextent
1 539 539 congestion_wait __alloc_pages_internal __alloc_pages
handle_mm_fault do_page_fault error_code
2 26759 21339 congestion_wait __alloc_pages_internal __alloc_pages
__get_free_pages proc_file_read proc_reg_read vfs_read sys_read
sysenter_past_esp
6 96540 19159 congestion_wait __alloc_pages_internal __alloc_pages
__get_free_pages __pollwait unix_poll sock_poll do_select
core_sys_select sys_select sysenter_past_esp
2 53244 47209 mempool_alloc bio_alloc_bioset bio_alloc
xfs_alloc_ioend_bio xfs_submit_ioend xfs_page_state_convert
xfs_vm_writepage __writepage write_cache_pages generic_writepages
xfs_vm_writepages do_writepages
1 425375 425375 sync_page __lock_page find_lock_page filemap_fault
__do_fault handle_mm_fault do_page_fault error_code

Best regards,
--Edwin
