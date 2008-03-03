Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYCCP0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYCCP0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYCCP0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:26:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:51842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbYCCP0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:26:37 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: latency problems with 2.6.24.3 and before (probably xfs related)
Date: Mon, 3 Mar 2008 16:26:28 +0100
User-Agent: KMail/1.9.9
References: <200803011219.30194.hpj@urpla.net>
In-Reply-To: <200803011219.30194.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803031626.28307.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX180RvNqPu7HX0PVAbjytLfKrUIPxQkx0loY2SO
 c5aof54Wabn7YiLlAkFctRDA4ByDZhTRmfOdeOGqwUfybc7uUE
 tMtCca/dO0weZl8DIBURw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 1. März 2008 schrieb Hans-Peter Jansen:
> Hi,
>
> I'm suffering from latency problems on a openSUSE 10.2 server with kernel
> 2.6.24.3. To get gripe on it, I finally got around installing latencytop
> from git, and that output pretty much reflects the pathologic situation:

Here's a typical situation with medium load :

Cause                                                Maximum     Percentage
sync_page wait_on_page_bit write_cache_pages gener1269.7 msec          7.2 %
sync_page __lock_page block_page_mkwrite xfs_vm_pa997.9 msec          2.5 %
sync_page __lock_page block_page_mkwrite xfs_vm_pa684.4 msec          1.7 %
sync_page __lock_page block_page_mkwrite xfs_vm_pa415.7 msec          4.8 %
lock_super sync_supers do_sync sys_sync sysenter_p221.6 msec          0.6 %
xlog_state_sync _xfs_log_force _xfs_trans_commit x134.3 msec          0.5 %
xfs_iflock xfs_finish_reclaim xfs_sync_inodes xfs_ 35.3 msec          0.1 %
sync_page wait_on_page_bit wait_on_page_writeback_ 29.4 msec          0.1 %
sync_page __lock_page do_generic_mapping_read gene 11.1 msec          0.0 %
_pread64 sysenter_past_esp 0xffffe410

Process muser (5319)                                                                                                    
sync_page wait_on_page_bit write_cache_pages gener1269.7 msec         89.4 %pages do_writepages __writeback_single_inode
lock_super sync_supers do_sync sys_sync sysenter_p221.6 msec          9.2 %odes
xfs_iflock xfs_finish_reclaim xfs_sync_inodes xfs_ 35.3 msec          1.3 %ync_super sync_filesystems do_sync sys_sync s
md_write_start make_request generic_make_request s  3.2 msec          0.1 %d_bio xfs_submit_ioend xfs_page_state_convert
 xfs_vm_writepage __writepage write_cache_pages generic_writepages xfs_vm_writepages

muser is a database application for a terminal based order mgmt system, where
this leads to a very annoying user interface starvation for about 5-10 seconds.

Obviously, this process (already running with nice -20) syncs often (probably
due to its age: we started using it at year 2 B.L.; 1989 on Bull DPX systems, 
oh well..).

I experimented with schedtool and ionice today, by boosting the suffering 
processes and degrading others. But the problem persists.

Could it be, that the write queue is simply too large?

Here's the the block stat of the offended device:

~# cat /sys/block/sda/stat 
 1912195    54104 161804644  9629427  1407367   111132 27530479 572302123        0 12852042 581945330

The "write ticks" value 572302123 looks suspicious, isn't it?

The raid system is a 3ware 9500 controller with 5 WD Raptor WD740GD-00FLA0 
drives in raid 5 mode. 

Any ideas are highly appreciated.

Pete
