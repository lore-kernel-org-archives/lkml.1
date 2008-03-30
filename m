Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbYC3LHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbYC3LHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 07:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYC3LHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 07:07:30 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:54810 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYC3LH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 07:07:29 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Mar 2008 07:07:29 EDT
Date: Sun, 30 Mar 2008 04:00:07 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: David Flynn <davidf@rd.bbc.co.uk>
cc: linux-kernel@vger.kernel.org, daivdf@rd.bbc.co.uk
Subject: Re: xfs+md(raid5) xfssyncd & kswapd & pdflush hung in d-state
In-Reply-To: <20080319150508.GA3087@localhost.localdomain>
Message-ID: <alpine.DEB.1.00.0803300359170.11059@twinlark.arctic.org>
References: <20080319150508.GA3087@localhost.localdomain>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there's a workaround -- increase /sys/block/md1/md/stripe_cache_size to 
4096 ...

and there's a patch... search for "Fix an occasional deadlock in raid5".

-dean

On Wed, 19 Mar 2008, David Flynn wrote:

> We are currently experiencing a problem with writing to xfs on a 20disk
> raid5 array.  It seems very similar to a post in 2007nov09:
> 
>   Re: 2.6.23.1: mdadm/raid5 hung/d-state
> 
> Using kernel 2.6.24.  Unlike the previous post the array was in a clean
> state so no resync was occuring.  We are able to read from the array,
> but any process that writes joins the list of blocked tasks
> 
> The machine is:
>   2 of dual core opteron 280
>   16GiB RAM
>   4 lots of 5 sata disks connected to sil3124 sata hba.
>   Running 2.6.24
> 
> There was a single rsync process accessing the array at the time
> (~40MB/sec).
> 
> Random other bits[1]:
> # cat /sys/block/md1/md/stripe_cache_active
> 256
> # cat /sys/block/md1/md/stripe_cache_size  
> 256
> 
> Example of sysrq-w:
> 
> pdflush       D ffffffff804297c0     0   245      2
>  ffff810274dd1920 0000000000000046 0000000000000000 ffffffff80305ba3
>  ffff810476524680 ffff81047748e000 ffff810276456800 ffff81047748e250
>  00000000ffffffff ffff8102758a0d30 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff80305ba3>] __generic_unplug_device+0x13/0x24
>  [<ffffffff882fcfcf>] :raid456:get_active_stripe+0x233/0x4c7
>  [<ffffffff8022ee03>] default_wake_function+0x0/0xe
>  [<ffffffff88302e6c>] :raid456:make_request+0x3f0/0x568
>  [<ffffffff80293fc7>] new_slab+0x1e5/0x20c
>  [<ffffffff80247fea>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff802941b6>] __slab_alloc+0x1c8/0x3a9
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff803042be>] generic_make_request+0x30e/0x349
>  [<ffffffff802737a4>] mempool_alloc+0x24/0xda
>  [<ffffffff883826ed>] :xfs:xfs_cluster_write+0xcd/0xf2
>  [<ffffffff803043d4>] submit_bio+0xdb/0xe2
>  [<ffffffff802babc1>] __bio_add_page+0x109/0x1ce
>  [<ffffffff88381ea0>] :xfs:xfs_submit_ioend_bio+0x1e/0x27
>  [<ffffffff88381f46>] :xfs:xfs_submit_ioend+0x88/0xc6
>  [<ffffffff88382d9e>] :xfs:xfs_page_state_convert+0x508/0x557
>  [<ffffffff88382f39>] :xfs:xfs_vm_writepage+0xa7/0xde
>  [<ffffffff802771e3>] __writepage+0xa/0x23
>  [<ffffffff8027767c>] write_cache_pages+0x176/0x2a5
>  [<ffffffff802771d9>] __writepage+0x0/0x23
>  [<ffffffff802777e7>] do_writepages+0x20/0x2d
>  [<ffffffff802b3ce1>] __writeback_single_inode+0x18d/0x2e0
>  [<ffffffff8026fb13>] delayacct_end+0x7d/0x88
>  [<ffffffff802b4175>] sync_sb_inodes+0x1b6/0x273
>  [<ffffffff802b4595>] writeback_inodes+0x69/0xbb
>  [<ffffffff8027801a>] wb_kupdate+0x9e/0x10d
>  [<ffffffff8027839e>] pdflush+0x0/0x204
>  [<ffffffff802784f8>] pdflush+0x15a/0x204
>  [<ffffffff80277f7c>] wb_kupdate+0x0/0x10d
>  [<ffffffff80247ecb>] kthread+0x47/0x74
>  [<ffffffff8020cc48>] child_rip+0xa/0x12
>  [<ffffffff80247e84>] kthread+0x0/0x74
>  [<ffffffff8020cc3e>] child_rip+0x0/0x12
> 
> I've attatched the rest of the output.
> Other than the blocked processes, the machine is idle.
> 
> After rebooting the machine, we increased stripe_cache_size to 512 and
> are currently seeing the same processes (now with md1_resync) periodically
> hang in the Dstate, best described as the almost the entire machine
> freezing for upto a minute then recovering.
> 
> I say almost as some processes seem unaffected, eg my existing ssh login
> to echo w > /proc/sysrq-trigger and a vmware virtual
> machine (root filesystem for host and guest is an nfsroot mounted from
> elsewhere).  Trying to login during these periods of tenseness fails
> though.
> 
> During these tense periods everything is idle with anything touching md1
> in the D state.
> 
> Any thoughts?
> 
> ..david
> 
