Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbXITHyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbXITHyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXITHyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:54:23 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:3282 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbXITHyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:54:23 -0400
Date: Thu, 20 Sep 2007 11:53:54 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten (sysfs?)
Message-ID: <20070920075353.GA6781@localhost.sw.ru>
References: <20070919123907.GA15591@localhost.sw.ru> <20070919125918.GA6760@localhost.sw.ru> <20070919123954.fb552e80.akpm@linux-foundation.org> <Pine.LNX.4.64.0709191355340.3136@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0709191432200.3111@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0709191432200.3111@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 02:36:04PM -0700, Christoph Lameter wrote:
> catting
> 
> 	alloc_calls
> 
> and
> 	free_calls
> 
> will perform a global scan over all objects to determine the callers. 
> Before we do that we have to flush the per cpu slabs. The trace shows that 
> one of the errors was detected in there and the other one probably later.
> 
> So I would think that this is an actual memory corruption issue on your 
> system and the /sys/slab stuff works fine. slabinfo -v will perform a more 
> details scan to help you located the problem.

OK, I do clean boot, ssh to box, then sudo slabinfo -v.


=============================================================================
BUG kmalloc-16: Object padding overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810100fd8998-0xffff810100fd8999. First byte 0xa7 instead of 0x5a
INFO: Allocated in sysfs_new_dirent+0x100/0x120 age=11055 cpu=0 pid=3474
INFO: Freed in kobject_uevent_env+0x123/0x430 age=11055 cpu=0 pid=3474
INFO: Slab 0xffff810004837740 used=28 fp=0xffff810100fd89a0 flags=0x8000000000000083
INFO: Object 0xffff810100fd8948 @offset=2376 fp=0xffff810100fd89a0

Bytes b4 0xffff810100fd8938:  f1 f9 fb ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ñùûÿ....ZZZZZZZZ
  Object 0xffff810100fd8948:  73 75 62 73 79 73 74 65 6d 00 6b 6b 6b 6b 6b a5 subsystem.kkkkk¥
 Redzone 0xffff810100fd8958:  cc cc cc cc cc cc cc cc                         ÌÌÌÌÌÌÌÌ        
 Padding 0xffff810100fd8998:  a7 5e 5a 5a 5a 5a 5a 5a                         §^ZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282c34>] check_object+0x234/0x270
 [<ffffffff80282e51>] validate_slab_slab+0x1e1/0x280
 [<ffffffff8028591e>] validate_store+0xde/0x1c0
 [<ffffffff802819e7>] slab_attr_store+0x27/0x30
 [<ffffffff802cc9da>] sysfs_write_file+0xca/0x140
 [<ffffffff80288d2d>] vfs_write+0xad/0xe0
 [<ffffffff80289313>] sys_write+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX kmalloc-16: Restoring 0xffff810100fd8998-0xffff810100fd8999=0x5a

=============================================================================
BUG kmalloc-16: Object padding overwritten
-----------------------------------------------------------------------------

INFO: 0xffff810101b45310-0xffff810101b45311. First byte 0xd3 instead of 0x5a
INFO: Allocated in kobject_get_path+0x57/0xc0 age=18405 cpu=1 pid=2006
INFO: Freed in kobject_uevent_env+0x123/0x430 age=18405 cpu=1 pid=2006
INFO: Slab 0xffff81000485f718 used=8 fp=0xffff810101b45318 flags=0x8000000000000083
INFO: Object 0xffff810101b452c0 @offset=704 fp=0xffff810101b45370

Bytes b4 0xffff810101b452b0:  db f9 fb ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a Ûùûÿ....ZZZZZZZZ
  Object 0xffff810101b452c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
 Redzone 0xffff810101b452d0:  bb bb bb bb bb bb bb bb                         »»»»»»»»        
 Padding 0xffff810101b45310:  d3 5e 5a 5a 5a 5a 5a 5a                         Ó^ZZZZZZ        

Call Trace:
 [<ffffffff802827c8>] check_bytes_and_report+0xb8/0x100
 [<ffffffff80282c34>] check_object+0x234/0x270
 [<ffffffff80282dcf>] validate_slab_slab+0x15f/0x280
 [<ffffffff8028591e>] validate_store+0xde/0x1c0
 [<ffffffff802819e7>] slab_attr_store+0x27/0x30
 [<ffffffff802cc9da>] sysfs_write_file+0xca/0x140
 [<ffffffff80288d2d>] vfs_write+0xad/0xe0
 [<ffffffff80289313>] sys_write+0x53/0x90
 [<ffffffff8020bcae>] system_call+0x7e/0x83

FIX kmalloc-16: Restoring 0xffff810101b45310-0xffff810101b45311=0x5a


