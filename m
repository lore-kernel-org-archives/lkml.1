Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbXISM7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbXISM7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 08:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXISM7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 08:59:31 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:44518 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbXISM7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 08:59:30 -0400
Date: Wed, 19 Sep 2007 16:59:18 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten (sysfs?)
Message-ID: <20070919125918.GA6760@localhost.sw.ru>
References: <20070919123907.GA15591@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070919123907.GA15591@localhost.sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 04:39:07PM +0400, Alexey Dobriyan wrote:
> Occured right after "sudo reboot" invocation (I think)
> with some crash proggies running (which -mm survives)
> 
> BUG kmalloc-16: Object padding overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xffff8101000d7998-0xffff8101000d7998. First byte 0x63 instead of 0x5a
> INFO: Allocated in sysfs_new_dirent+0x100/0x120 age=16985537 cpu=1 pid=3426
> INFO: Freed in kobject_uevent_env+0x123/0x430 age=16985537 cpu=1 pid=3426
> INFO: Slab 0xffff810004802f08 used=21 fp=0xffff8101000d78f0 flags=0x80000000000000c3
> INFO: Object 0xffff8101000d7948 @offset=2376 fp=0xffff8101000d79a0
> 
> Bytes b4 0xffff8101000d7938:  ef 23 ff 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ï#ÿ.....ZZZZZZZZ
>   Object 0xffff8101000d7948:  73 75 62 73 79 73 74 65 6d 00 6b 6b 6b 6b 6b a5 subsystem.kkkkk¥
>  Redzone 0xffff8101000d7958:  cc cc cc cc cc cc cc cc                         ÌÌÌÌÌÌÌÌ        
>  Padding 0xffff8101000d7998:  63 5a 5a 5a 5a 5a 5a 5a                         cZZZZZZZ        

Steps to reproduce:

	find /sys/slab | xargs cat

now it's

=============================================================================
BUG bio: Padding overwritten. 0x000000000000003a-0x00000000fffffffe
-----------------------------------------------------------------------------

INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002

Call Trace:
 [<ffffffff80282169>] slab_err+0x99/0xc0
 [<ffffffff8025070f>] mark_held_locks+0x3f/0x80
 [<ffffffff80266565>] get_page_from_freelist+0x325/0x540
 [<ffffffff8025172c>] __lock_acquire+0x8ac/0x10f0
 [<ffffffff80219d9e>] flat_send_IPI_allbutself+0x4e/0x80
 [<ffffffff80216fec>] __smp_call_function_mask+0x9c/0xf0
 [<ffffffff802822d3>] slab_pad_check+0xe3/0x120
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80282f8e>] __free_slab+0x9e/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
5a5a
<4>
<3>Bytes b4 0xffff810102148230:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148240:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148250:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148260:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148270:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148280:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148290:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021482a0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff8101021482a8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff8101021482e8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
----------------------------------------------------------------------------
<4>
<3>INFO: 0xffff810102148d28-0xffff810102148d2f. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148cc0 @offset=3264 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148cb0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148cc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148cd0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148ce0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148cf0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d20:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148d28:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148d68:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148d78:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148d28-0xffff810102148d2f=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148de8-0xffff810102148def. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148d80 @offset=3456 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148d70:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d80:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d90:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148da0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148db0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148dc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148dd0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148de0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        ZZZZZ        
 Padding 0xffff8101021485e8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff8101021485f8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff8101021485a8-0xffff8101021485af=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148668-0xffff81010214866f. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148600 @offset=1536 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff8101021485f0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148600:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148610:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148620:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148630:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148640:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148650:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148660:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148668:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff8101021486a8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff8101021486b8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148668-0xffff81010214866f=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148728-0xffff81010214872f. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff8101021486c0 @offset=1728 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff8101021486b0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021486c0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021486d0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021486e0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021486f0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148700:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148710:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148720:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148728:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148768:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148778:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148728-0xffff81010214872f=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff8101021487e8-0xffff8101021487ef. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148780 @offset=1920 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148770:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148780:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148790:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021487a0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021487b0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021487c0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021487d0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021487e0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff8101021487e8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148828:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148838:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff8101021487e8-0xffff8101021487ef=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff8101021488a8-0xffff8101021488af. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148840 @offset=2112 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148830:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148840:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148850:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148860:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148870:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148880:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148890:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021488a0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff8101021488a8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff8101021488e8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff8101021488f8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff8101021488a8-0xffff8101021488af=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148968-0xffff81010214896f. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148900 @offset=2304 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff8101021488f0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148900:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148910:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148920:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148930:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148940:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148950:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148960:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148968:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff8101021489a8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff8101021489b8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148968-0xffff81010214896f=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148a28-0xffff810102148a2f. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff8101021489c0 @offset=2496 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff8101021489b0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021489c0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021489d0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021489e0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8101021489f0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148a00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148a10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148a20:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148a28:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148a68:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148a78:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148a28-0xffff810102148a2f=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148ae8-0xffff810102148aef. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148a80 @offset=2688 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148a70:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148a80:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148a90:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148aa0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148ab0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148ac0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148ad0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148ae0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148ae8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148b28:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148b38:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148ae8-0xffff810102148aef=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148ba8-0xffff810102148baf. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148b40 @offset=2880 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148b30:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148b40:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148b50:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148b60:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148b70:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148b80:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148b90:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148ba0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148ba8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148be8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148bf8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148ba8-0xffff810102148baf=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148c68-0xffff810102148c6f. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148c00 @offset=3072 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148bf0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148c00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148c10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148c20:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148c30:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148c40:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148c50:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148c60:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148c68:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148ca8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148cb8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148c68-0xffff810102148c6f=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148d28-0xffff810102148d2f. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148cc0 @offset=3264 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148cb0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148cc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148cd0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148ce0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148cf0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d20:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148d28:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148d68:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148d78:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148d28-0xffff810102148d2f=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148de8-0xffff810102148def. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148d80 @offset=3456 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148d70:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d80:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148d90:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148da0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148db0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148dc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148dd0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148de0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148de8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148e28:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148e38:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148de8-0xffff810102148def=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148ea8-0xffff810102148eaf. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148e40 @offset=3648 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148e30:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148e40:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148e50:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148e60:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148e70:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148e80:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148e90:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148ea0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148ea8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148ee8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148ef8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148ea8-0xffff810102148eaf=0xbb

=============================================================================
BUG bio: Redzone overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810102148f68-0xffff810102148f6f. First byte 0x5a instead of 0xbb
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
INFO: Object 0xffff810102148f00 @offset=3840 fp=0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff810102148ef0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148f00:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148f10:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148f20:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148f30:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148f40:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148f50:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff810102148f60:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Redzone 0xffff810102148f68:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
 Padding 0xffff810102148fa8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xffff810102148fb8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282a66>] check_object+0x66/0x270
 [<ffffffff80282fe5>] __free_slab+0xf5/0x140
 [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
 [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
 [<ffffffff80284a52>] list_locations+0xb2/0x380
 [<ffffffff80266818>] __alloc_pages+0x58/0x360
 [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
 [<ffffffff802819b0>] slab_attr_show+0x20/0x30
 [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
 [<ffffffff80288e0a>] vfs_read+0xaa/0xe0
 [<ffffffff80289283>] sys_read+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX bio: Restoring 0xffff810102148f68-0xffff810102148f6f=0xbb


