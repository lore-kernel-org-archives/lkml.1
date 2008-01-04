Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYADHlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYADHlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 02:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYADHk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 02:40:57 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:42001 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYADHk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 02:40:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=FryY1aEKs+PDxnACoeF9fPR6LVxGF+6QltmoUAYf4oojfgQhi2Rn4Th0+aQv2t68uYmGBgbkV0NXEnIm6QfHZQt33xLwWD2G5kwTzE67osn7LPbs/khgmus83Zl/ucY2;
Message-ID: <477DE2F9.2050208@simon.arlott.org.uk>
Date: Fri, 04 Jan 2008 07:40:41 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, folkert@vanheusden.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.22] circular lock detected
References: <20070824210033.GB13237@vanheusden.com> <20070902045529.c66eddc9.akpm@linux-foundation.org> <20070903122702.GC29908@atrey.karlin.mff.cuni.cz> <20070903054959.3ecd9576.akpm@linux-foundation.org> <20070903140135.GE7524@duck.suse.cz> <20070925100243.2ceebd9e@twins> <20070925084630.GA412@duck.suse.cz>
In-Reply-To: <20070925084630.GA412@duck.suse.cz>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/07 09:46, Jan Kara wrote:
> On Tue 25-09-07 10:02:43, Peter Zijlstra wrote:
>> On Mon, 3 Sep 2007 16:01:35 +0200 Jan Kara <jack@suse.cz> wrote:
>> 
>> > On Mon 03-09-07 05:49:59, Andrew Morton wrote:
>> > > > On Mon, 3 Sep 2007 14:27:02 +0200 Jan Kara <jack@suse.cz> wrote:
>> > > > > > On Fri, 24 Aug 2007 23:00:33 +0200 Folkert van Heusden <folkert@vanheusden.com> wrote:
>> 
>> > > > > Has been reported before, but I don't recall whether we fixed it.  Jan,
>> > > > > do you know>?
>> > > >   I think we at least found a solution: Teach lockdep that I_MUTEX for
>> > > > different filesystems is different. Peter Zilstra wrote a patch for that
>> > > > and Folkert even confirmed that it fixes the problem for him. I'm not
>> > > > sure what happened with the patch afterwards though. Adding Peter to CC
>> > > > :).
>> > > 
>> > > But this is a tty_lock-versus-dqptr_sem ranking error.  Unrelated to i_mutex?
>> >   The final report is for this ranking but the locking chain (if I understand it
>> > right) is:
>> > tty_mutex (con_close) -> i_mutex (sysfs: remove_subdir)
>> > i_mutex (do_truncate) -> i_alloc_sem (notify_change) -> truncate_mutex (ext3_truncate)
>> > truncate_mutex (ext3_get_blocks_handle) -> dqptr_sem (dquot_alloc_space)
>> > 
>> > So it complains about tty_mutex vs dqptr_sem (I don't know why it does not
>> > complain about tty_mutex vs i_mutex) but the wrong link in the chain is
>> > that i_mutex from remove_subdir() [sysfs] and i_mutex from do_truncate()
>> > [ext3] are different and should never depend on each other...
>> > 
>> 
>> Found it again.
>   Cool, thanks Peter. Andrew, would you put it into -mm? This should take care of
> the false lockdep warnings from the quota code. If I recall correctly, one
> of the reporters even confirmed it fixes the problem for him.
>   The patch looks fine. You can add:
> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> 									Honza
> 
>> Give each filesystem its own inode lock class. The various filesystems have
>> different locking order wrt the inode locks; esp. the pseudo filesystems
>> differ from the rest.
>> 
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

This patch still doesn't exist in 2.6.23.9 and the warning isn't fixed...

03 00:31:34 [1905219.899008] =======================================================
03 00:31:34 [1905219.907136] [ INFO: possible circular locking dependency detected ]
03 00:31:34 [1905219.913569] 2.6.23.9-git #43
03 00:31:34 [1905219.916624] -------------------------------------------------------
03 00:31:34 [1905219.923059] bacula-sd/32639 is trying to acquire lock:
03 00:31:34 [1905219.928364]  (tty_mutex){--..}, at: [<80389fd7>] mutex_lock+0x1c/0x1f
03 00:31:34 [1905219.935047]
03 00:31:34 [1905219.935049] but task is already holding lock:
03 00:31:34 [1905219.941238]  (&s->s_dquot.dqptr_sem){----}, at: [<801839bf>] dquot_alloc_space+0x42/0x15b
03 00:31:34 [1905219.949646]
03 00:31:34 [1905219.949649] which lock already depends on the new lock.
03 00:31:34 [1905219.949652]
03 00:31:34 [1905219.958367]
03 00:31:34 [1905219.958369] the existing dependency chain (in reverse order) is:
03 00:31:34 [1905219.966204]
03 00:31:34 [1905219.966206] -> #4 (&s->s_dquot.dqptr_sem){----}:
03 00:31:34 [1905219.972714]        [<80131c5b>] __lock_acquire+0x9ba/0xb96
03 00:31:34 [1905219.978511]        [<80132200>] lock_acquire+0x5d/0x75
03 00:31:34 [1905219.983957]        [<8012ac3c>] down_read+0x3a/0x4b
03 00:31:34 [1905219.989252]        [<801839bf>] dquot_alloc_space+0x42/0x15b
03 00:31:34 [1905219.995217]        [<801920e1>] ext3_new_blocks+0x83/0x5ba
03 00:31:34 [1905220.001009]        [<80195111>] ext3_get_blocks_handle+0x386/0x822
03 00:31:34 [1905220.007495]        [<80195889>] ext3_get_block+0xac/0xc5
03 00:31:34 [1905220.013113]        [<80174e54>] __block_prepare_write+0x151/0x3c6
03 00:31:34 [1905220.019603]        [<801750ed>] block_prepare_write+0x24/0x32
03 00:31:34 [1905220.025654]        [<80196a43>] ext3_prepare_write+0x98/0x153
03 00:31:34 [1905220.031705]        [<8013cbbe>] generic_file_buffered_write+0x219/0x57c
03 00:31:34 [1905220.038630]        [<8013d384>] __generic_file_aio_write_nolock+0x463/0x4b3
03 00:31:34 [1905220.045894]        [<8013d42a>] generic_file_aio_write+0x56/0xb4
03 00:31:34 [1905220.052292]        [<8019311b>] ext3_file_write+0x27/0x99
03 00:31:34 [1905220.057996]        [<80157742>] do_sync_write+0xc4/0x101
03 00:31:34 [1905220.063615]        [<80157f03>] vfs_write+0xaf/0x138
03 00:31:34 [1905220.068885]        [<8015840f>] sys_write+0x3d/0x61
03 00:31:34 [1905220.074071]        [<80102702>] sysenter_past_esp+0x5f/0x99
03 00:31:34 [1905220.080046]        [<ffffffff>] 0xffffffff
03 00:31:34 [1905220.084456]
03 00:31:34 [1905220.084458] -> #3 (&ei->truncate_mutex){--..}:
03 00:31:34 [1905220.090781]        [<80131c5b>] __lock_acquire+0x9ba/0xb96
03 00:31:34 [1905220.096573]        [<80132200>] lock_acquire+0x5d/0x75
03 00:31:34 [1905220.102020]        [<80389e25>] __mutex_lock_slowpath+0xdb/0x271
03 00:31:34 [1905220.108418]        [<80389fd7>] mutex_lock+0x1c/0x1f
03 00:31:34 [1905220.113690]        [<80196110>] ext3_truncate+0x49e/0x7ec
03 00:31:34 [1905220.119397]        [<80148496>] vmtruncate+0x161/0x187
03 00:31:34 [1905220.124847]        [<80169794>] inode_setattr+0x73/0x149
03 00:31:34 [1905220.130470]        [<8019720c>] ext3_setattr+0x185/0x1e1
03 00:31:34 [1905220.136088]        [<8016999a>] notify_change+0x130/0x2d2
03 00:31:34 [1905220.141883]        [<80156c7b>] do_truncate+0x60/0x79
03 00:31:34 [1905220.147245]        [<8015f377>] may_open+0x1b9/0x201
03 00:31:34 [1905220.152522]        [<801612e3>] open_namei+0x240/0x539
03 00:31:34 [1905220.157965]        [<8015651b>] do_filp_open+0x26/0x3b
03 00:31:34 [1905220.163411]        [<80156575>] do_sys_open+0x45/0xc9
03 00:31:34 [1905220.168857]        [<80156631>] sys_open+0x1c/0x1e
03 00:31:34 [1905220.173955]        [<80102702>] sysenter_past_esp+0x5f/0x99
03 00:31:34 [1905220.179830]        [<ffffffff>] 0xffffffff
03 00:31:34 [1905220.184233]
03 00:31:34 [1905220.184235] -> #2 (&inode->i_alloc_sem){--..}:
03 00:31:34 [1905220.190559]        [<80131c5b>] __lock_acquire+0x9ba/0xb96
03 00:31:34 [1905220.196436]        [<80132200>] lock_acquire+0x5d/0x75
03 00:31:34 [1905220.201884]        [<8012acd6>] down_write+0x3a/0x53
03 00:31:34 [1905220.207152]        [<80169952>] notify_change+0xe8/0x2d2
03 00:31:34 [1905220.212772]        [<80156c7b>] do_truncate+0x60/0x79
03 00:31:34 [1905220.218130]        [<8015f377>] may_open+0x1b9/0x201
03 00:31:34 [1905220.223485]        [<801612e3>] open_namei+0x240/0x539
03 00:31:34 [1905220.228926]        [<8015651b>] do_filp_open+0x26/0x3b
03 00:31:34 [1905220.234372]        [<80156575>] do_sys_open+0x45/0xc9
03 00:31:34 [1905220.239727]        [<80156631>] sys_open+0x1c/0x1e
03 00:31:34 [1905220.244819]        [<80102702>] sysenter_past_esp+0x5f/0x99
03 00:31:34 [1905220.250760]        [<ffffffff>] 0xffffffff
03 00:31:34 [1905220.255156]
03 00:31:34 [1905220.255158] -> #1 (&inode->i_mutex){--..}:
03 00:31:34 [1905220.261135]        [<80131c5b>] __lock_acquire+0x9ba/0xb96
03 00:31:34 [1905220.268005]        [<80132200>] lock_acquire+0x5d/0x75
03 00:31:34 [1905220.273448]        [<80389e25>] __mutex_lock_slowpath+0xdb/0x271
03 00:31:34 [1905220.279752]        [<80389fd7>] mutex_lock+0x1c/0x1f
03 00:31:34 [1905220.285024]        [<80190cf6>] get_node+0x1d/0x46
03 00:31:34 [1905220.290119]        [<80190e84>] devpts_get_tty+0xb/0x3b
03 00:31:34 [1905220.295646]        [<80214fb5>] init_dev+0x21/0x4a2
03 00:31:34 [1905220.300837]        [<80217c95>] ptmx_open+0xfd/0x1bc
03 00:31:34 [1905220.306102]        [<80159f91>] chrdev_open+0x14a/0x180
03 00:31:34 [1905220.311618]        [<801563b2>] __dentry_open+0xfd/0x1af
03 00:31:34 [1905220.317232]        [<801564e5>] nameidata_to_filp+0x27/0x37
03 00:31:34 [1905220.323097]        [<80156528>] do_filp_open+0x33/0x3b
03 00:31:34 [1905220.328535]        [<80156575>] do_sys_open+0x45/0xc9
03 00:31:34 [1905220.333874]        [<80156631>] sys_open+0x1c/0x1e
03 00:31:34 [1905220.338981]        [<80102702>] sysenter_past_esp+0x5f/0x99
03 00:31:34 [1905220.344855]        [<ffffffff>] 0xffffffff
03 00:31:34 [1905220.349256]
03 00:31:34 [1905220.349258] -> #0 (tty_mutex){--..}:
03 00:31:34 [1905220.354717]        [<80131b4b>] __lock_acquire+0x8aa/0xb96
03 00:31:34 [1905220.360505]        [<80132200>] lock_acquire+0x5d/0x75
03 00:31:34 [1905220.365956]        [<80389e25>] __mutex_lock_slowpath+0xdb/0x271
03 00:31:34 [1905220.372258]        [<80389fd7>] mutex_lock+0x1c/0x1f
03 00:31:34 [1905220.377517]        [<80182ea9>] print_warning+0x92/0x137
03 00:31:34 [1905220.383139]        [<80183ab8>] dquot_alloc_space+0x13b/0x15b
03 00:31:34 [1905220.389176]        [<801920e1>] ext3_new_blocks+0x83/0x5ba
03 00:31:34 [1905220.394961]        [<80195111>] ext3_get_blocks_handle+0x386/0x822
03 00:31:34 [1905220.401429]        [<80195889>] ext3_get_block+0xac/0xc5
03 00:31:34 [1905220.407047]        [<80174e54>] __block_prepare_write+0x151/0x3c6
03 00:31:34 [1905220.413455]        [<801750ed>] block_prepare_write+0x24/0x32
03 00:31:34 [1905220.419506]        [<80196a43>] ext3_prepare_write+0x98/0x153
03 00:31:34 [1905220.425553]        [<8013cbbe>] generic_file_buffered_write+0x219/0x57c
03 00:31:34 [1905220.432465]        [<8013d384>] __generic_file_aio_write_nolock+0x463/0x4b3
03 00:31:34 [1905220.439724]        [<8013d42a>] generic_file_aio_write+0x56/0xb4
03 00:31:34 [1905220.446027]        [<8019311b>] ext3_file_write+0x27/0x99
03 00:31:34 [1905220.451728]        [<80157742>] do_sync_write+0xc4/0x101
03 00:31:34 [1905220.457338]        [<80157f03>] vfs_write+0xaf/0x138
03 00:31:34 [1905220.462600]        [<8015840f>] sys_write+0x3d/0x61
03 00:31:34 [1905220.467771]        [<80102702>] sysenter_past_esp+0x5f/0x99
03 00:31:34 [1905220.473639]        [<ffffffff>] 0xffffffff
03 00:31:34 [1905220.478040]
03 00:31:34 [1905220.478043] other info that might help us debug this:
03 00:31:34 [1905220.478046]
03 00:31:34 [1905220.486588] 3 locks held by bacula-sd/32639:
03 00:31:34 [1905220.491025]  #0:  (&inode->i_mutex){--..}, at: [<80389fd7>] mutex_lock+0x1c/0x1f
03 00:31:34 [1905220.498668]  #1:  (&ei->truncate_mutex){--..}, at: [<80389fd7>] mutex_lock+0x1c/0x1f
03 00:31:34 [1905220.506659]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<801839bf>] dquot_alloc_space+0x42/0x15b
03 00:31:34 [1905220.515511]
03 00:31:34 [1905220.515513] stack backtrace:
03 00:31:34 [1905220.520230]  [<80103694>] show_trace_log_lvl+0x1a/0x2f
03 00:31:34 [1905220.525555]  [<8010421b>] show_trace+0x12/0x14
03 00:31:34 [1905220.530185]  [<80104232>] dump_stack+0x15/0x17
03 00:31:34 [1905220.534817]  [<801303c4>] print_circular_bug_tail+0x5e/0x67
03 00:31:34 [1905220.540580]  [<80131b4b>] __lock_acquire+0x8aa/0xb96
03 00:31:34 [1905220.545731]  [<80132200>] lock_acquire+0x5d/0x75
03 00:31:34 [1905220.550536]  [<80389e25>] __mutex_lock_slowpath+0xdb/0x271
03 00:31:34 [1905220.556203]  [<80389fd7>] mutex_lock+0x1c/0x1f
03 00:31:34 [1905220.560838]  [<80182ea9>] print_warning+0x92/0x137
03 00:31:34 [1905220.565819]  [<80183ab8>] dquot_alloc_space+0x13b/0x15b
03 00:31:34 [1905220.571230]  [<801920e1>] ext3_new_blocks+0x83/0x5ba
03 00:31:34 [1905220.576381]  [<80195111>] ext3_get_blocks_handle+0x386/0x822
03 00:31:34 [1905220.582226]  [<80195889>] ext3_get_block+0xac/0xc5
03 00:31:34 [1905220.587205]  [<80174e54>] __block_prepare_write+0x151/0x3c6
03 00:31:34 [1905220.592963]  [<801750ed>] block_prepare_write+0x24/0x32
03 00:31:34 [1905220.598372]  [<80196a43>] ext3_prepare_write+0x98/0x153
03 00:31:34 [1905220.603785]  [<8013cbbe>] generic_file_buffered_write+0x219/0x57c
03 00:31:34 [1905220.610063]  [<8013d384>] __generic_file_aio_write_nolock+0x463/0x4b3
03 00:31:34 [1905220.616687]  [<8013d42a>] generic_file_aio_write+0x56/0xb4
03 00:31:34 [1905220.622362]  [<8019311b>] ext3_file_write+0x27/0x99
03 00:31:34 [1905220.627426]  [<80157742>] do_sync_write+0xc4/0x101
03 00:31:34 [1905220.632401]  [<80157f03>] vfs_write+0xaf/0x138
03 00:31:34 [1905220.637033]  [<8015840f>] sys_write+0x3d/0x61
03 00:31:34 [1905220.641574]  [<80102702>] sysenter_past_esp+0x5f/0x99
03 00:31:34 [1905220.646811]  =======================

>> ---
>>  fs/inode.c         |   12 +++++++++---
>>  include/linux/fs.h |    5 +++++
>>  2 files changed, 14 insertions(+), 3 deletions(-)
>> 
>> Index: linux-2.6/fs/inode.c
>> ===================================================================
>> --- linux-2.6.orig/fs/inode.c
>> +++ linux-2.6/fs/inode.c
>> @@ -142,6 +142,15 @@ static struct inode *alloc_inode(struct 
>>  			return NULL;
>>  		}
>>  
>> +		spin_lock_init(&inode->i_lock);
>> +		lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
>> +
>> +		mutex_init(&inode->i_mutex);
>> +		lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
>> +
>> +		init_rwsem(&inode->i_alloc_sem);
>> +		lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
>> +
>>  		mapping->a_ops = &empty_aops;
>>   		mapping->host = inode;
>>  		mapping->flags = 0;
>> @@ -190,8 +199,6 @@ void inode_init_once(struct inode *inode
>>  	INIT_HLIST_NODE(&inode->i_hash);
>>  	INIT_LIST_HEAD(&inode->i_dentry);
>>  	INIT_LIST_HEAD(&inode->i_devices);
>> -	mutex_init(&inode->i_mutex);
>> -	init_rwsem(&inode->i_alloc_sem);
>>  	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
>>  	rwlock_init(&inode->i_data.tree_lock);
>>  	spin_lock_init(&inode->i_data.i_mmap_lock);
>> @@ -199,7 +206,6 @@ void inode_init_once(struct inode *inode
>>  	spin_lock_init(&inode->i_data.private_lock);
>>  	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
>>  	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
>> -	spin_lock_init(&inode->i_lock);
>>  	i_size_ordered_init(inode);
>>  #ifdef CONFIG_INOTIFY
>>  	INIT_LIST_HEAD(&inode->inotify_watches);
>> Index: linux-2.6/include/linux/fs.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/fs.h
>> +++ linux-2.6/include/linux/fs.h
>> @@ -1302,8 +1302,13 @@ struct file_system_type {
>>  	struct module *owner;
>>  	struct file_system_type * next;
>>  	struct list_head fs_supers;
>> +
>>  	struct lock_class_key s_lock_key;
>>  	struct lock_class_key s_umount_key;
>> +
>> +	struct lock_class_key i_lock_key;
>> +	struct lock_class_key i_mutex_key;
>> +	struct lock_class_key i_alloc_sem_key;
>>  };
>>  
>>  extern int get_sb_bdev(struct file_system_type *fs_type,
>> 


-- 
Simon Arlott
