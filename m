Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbXISTlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbXISTlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXISTlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:41:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278AbXISTlL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:41:11 -0400
Date: Wed, 19 Sep 2007 12:39:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten
 (sysfs?)
Message-Id: <20070919123954.fb552e80.akpm@linux-foundation.org>
In-Reply-To: <20070919125918.GA6760@localhost.sw.ru>
References: <20070919123907.GA15591@localhost.sw.ru>
	<20070919125918.GA6760@localhost.sw.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 16:59:18 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:

> On Wed, Sep 19, 2007 at 04:39:07PM +0400, Alexey Dobriyan wrote:
> > Occured right after "sudo reboot" invocation (I think)
> > with some crash proggies running (which -mm survives)
> > 
> > BUG kmalloc-16: Object padding overwritten
> > -----------------------------------------------------------------------------
> > 
> > INFO: 0xffff8101000d7998-0xffff8101000d7998. First byte 0x63 instead of 0x5a
> > INFO: Allocated in sysfs_new_dirent+0x100/0x120 age=16985537 cpu=1 pid=3426
> > INFO: Freed in kobject_uevent_env+0x123/0x430 age=16985537 cpu=1 pid=3426
> > INFO: Slab 0xffff810004802f08 used=21 fp=0xffff8101000d78f0 flags=0x80000000000000c3
> > INFO: Object 0xffff8101000d7948 @offset=2376 fp=0xffff8101000d79a0
> > 
> > Bytes b4 0xffff8101000d7938:  ef 23 ff 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ï#ÿ.....ZZZZZZZZ
> >   Object 0xffff8101000d7948:  73 75 62 73 79 73 74 65 6d 00 6b 6b 6b 6b 6b a5 subsystem.kkkkk¥
> >  Redzone 0xffff8101000d7958:  cc cc cc cc cc cc cc cc                         ÌÌÌÌÌÌÌÌ        
> >  Padding 0xffff8101000d7998:  63 5a 5a 5a 5a 5a 5a 5a                         cZZZZZZZ        
> 
> Steps to reproduce:
> 
> 	find /sys/slab | xargs cat
> 
> now it's
> 
> =============================================================================
> BUG bio: Padding overwritten. 0x000000000000003a-0x00000000fffffffe
> -----------------------------------------------------------------------------
> 
> INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
> 
> Call Trace:
>  [<ffffffff80282169>] slab_err+0x99/0xc0
>  [<ffffffff8025070f>] mark_held_locks+0x3f/0x80
>  [<ffffffff80266565>] get_page_from_freelist+0x325/0x540
>  [<ffffffff8025172c>] __lock_acquire+0x8ac/0x10f0
>  [<ffffffff80219d9e>] flat_send_IPI_allbutself+0x4e/0x80
>  [<ffffffff80216fec>] __smp_call_function_mask+0x9c/0xf0
>  [<ffffffff802822d3>] slab_pad_check+0xe3/0x120
>  [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
>  [<ffffffff80282f8e>] __free_slab+0x9e/0x140
>  [<ffffffff80284d70>] flush_cpu_slab+0x0/0xc0
>  [<ffffffff80233d1b>] on_each_cpu+0x4b/0x90
>  [<ffffffff80284a52>] list_locations+0xb2/0x380
>  [<ffffffff80266818>] __alloc_pages+0x58/0x360
>  [<ffffffff80284d68>] alloc_calls_show+0x18/0x20
>  [<ffffffff802819b0>] slab_attr_show+0x20/0x30
>  [<ffffffff802ccaee>] sysfs_read_file+0x9e/0x150
> 5a5a
> <4>
> <3>Bytes b4 0xffff810102148230:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff810102148240:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff810102148250:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff810102148260:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff810102148270:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff810102148280:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff810102148290:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
>   Object 0xffff8101021482a0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
>  Redzone 0xffff8101021482a8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
>  Padding 0xffff8101021482e8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> ----------------------------------------------------------------------------
> <4>
> <3>INFO: 0xffff810102148d28-0xffff810102148d2f. First byte 0x5a instead of 0xbb
> INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
> INFO: Freed in 0x5a5a5a5a5a5a5a5a age=11936128522577653999 cpu=1515870810 pid=1515870810
> INFO: Slab 0xffff8100048747c0 used=4294967295 fp=0xffff8101021489c0 flags=0x8000000000000002
> INFO: Object 0xffff810102148cc0 @offset=3264 fp=0x5a5a5a5a5a5a5a5a


So do you beleive the bug lies in the /sys/slab implementation?
