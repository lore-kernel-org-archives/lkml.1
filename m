Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYCALT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYCALT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 06:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYCALTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 06:19:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:63153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYCALTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 06:19:45 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: latency problems with 2.6.24.3 and before (probably xfs related)
Date: Sat, 1 Mar 2008 12:19:29 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803011219.30194.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/vv5qpn00lK9aWuG0VKjTUnNXG+wzi8w2mhhE
 L+FA04EhBLQLR8/81DxZYK8z9RNqRt7RqL1KEFNLYTYsfz8Kq0
 O4Z14Ssnae5OfaStndtSg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm suffering from latency problems on a openSUSE 10.2 server with kernel
2.6.24.3. To get gripe on it, I finally got around installing latencytop
from git, and that output pretty much reflects the pathologic situation:

Process cupsd (4917)                                                                                                    
xlog_state_sync _xfs_log_force xfs_alloc_search_bu2480.0 msec         59.2 %s_alloc_vextent xfs_bmap_btalloc xfs_bmap_al
vn_iowait xfs_setattr xfs_vn_setattr notify_change1957.5 msec         26.8 %_namei do_filp_open do_sys_open sys_open sys
xfs_buf_lock xfs_getsb xfs_trans_getsb xfs_trans_a1269.6 msec          8.0 %commit xfs_itruncate_finish xfs_setattr xfs_
xfs_buf_lock xfs_getsb xfs_trans_getsb xfs_trans_a968.8 msec          6.1 %_commit xfs_iomap_write_allocate xfs_iomap xf
s_bmap xfs_map_blocks xfs_page_state_convert xfs_vm_writepage __writepage

Process svn (16210)                                                                                                     
sync_page __lock_page do_generic_mapping_read gene2289.2 msec         55.8 % xfs_file_aio_read do_sync_read vfs_read sys
xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags 1714.8 msec         27.2 %do_buf xfs_da_read_buf xfs_dir2_block_lookup
xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags 1175.6 msec         15.2 %bp xfs_iread xfs_iget_core xfs_iget xfs_dir_
xfs_buf_lock xfs_getsb xfs_trans_getsb xfs_trans_a191.4 msec          1.7 %_commit xfs_create xfs_vn_mknod xfs_vn_create
 vfs_create open_namei do_filp_open do_sys_open

Process find (15502)                                                                                                    
xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags 1468.8 msec         43.8 %bp xfs_iread xfs_iget_core xfs_iget xfs_dir_
xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags 1070.4 msec         56.2 %do_buf xfs_da_read_buf xfs_dir2_block_getden
ts xfs_readdir xfs_file_readdir vfs_readdir sys_getdents64 sysenter_past_esp

Okay, that doesn't look funny in any way. Up to 2,5 sec latency is way too 
much, given the equipment in play: Tyan S2882-D, 2 * AMD Opteron 265 DC, 4GB 
RAM, Areca ARC-1130 12-Port PCI-X to SATA RAID Controller, main system installed 
on 4 * Hitachi 500GB SATA drives in a RAID 5 setup. The kernel config is 
based on the default SUSE setup for i386 with pae extension, compiled with 
HZ 250, running with SCHED_MINTIMESLICE="10000", SCHED_MAXTIMESLICE="100000".

It looks like it's xfs related. I suspect, cupsd mostly operates on 
/var, which has it's own partition:

meta-data=/dev/sda6              isize=256    agcount=16, agsize=2457567 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=39321072, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=19199, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

Any ideas, what's wrong here?

Pete
