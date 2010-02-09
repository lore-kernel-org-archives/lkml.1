Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0BICyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:54:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab0BICys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:54:48 -0500
Message-ID: <4B70CECC.2060205@redhat.com>
Date: Tue, 09 Feb 2010 10:56:12 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>, Miles Lane <miles.lane@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, akpm@linux-foundation.org
Subject: Re: [Patch 2/2] block: add sysfs lockdep class for iosched
References: <20100208095518.3612.73574.sendpatchset@localhost.localdomain> <20100208095530.3612.7843.sendpatchset@localhost.localdomain> <4B707904.4030102@lwfinger.net>
In-Reply-To: <4B707904.4030102@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> On 02/08/2010 03:52 AM, Amerigo Wang wrote:
>> Similar to the previous PM case, in iosched, we hold an s_active
>> lock to store "scheduler", meanwhile we want to remove "iosched/*"
>> files.
>>
>> This patch depends on the previous one. I tested it on my machine,
>> it fixes the problem.
>>
>> Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Jens Axboe <jens.axboe@oracle.com>
> 
> After applying the 2 patches to 2.6.33-rc7, I get the following:
> 
> ACPI: bus type pci registered
> PCI: MMCONFIG for domain 0000 [bus 00-09] at [mem 0xe0000000-0xe09fffff] (base
> 0xe0000000)
> PCI: MMCONFIG at [mem 0xe0000000-0xe09fffff] reserved in E820
> PCI: Using configuration type 1 for base access
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> Pid: 1, comm: swapper Not tainted 2.6.33-rc7-Linus-00010-g6339204-dirty #181
> Call Trace:
>  [<ffffffff8107c6e6>] __lock_acquire+0xf86/0x1d30
>  [<ffffffff81078e7f>] ? lockdep_init_map+0x5f/0x5d0
>  [<ffffffff8107d52b>] lock_acquire+0x9b/0x120
>  [<ffffffff81167a93>] ? sysfs_addrm_finish+0x43/0x70
>  [<ffffffff81167243>] sysfs_deactivate+0xc3/0x110
>  [<ffffffff81167a93>] ? sysfs_addrm_finish+0x43/0x70
>  [<ffffffff813124d3>] ? mutex_lock_nested+0x243/0x300
>  [<ffffffff81167a93>] sysfs_addrm_finish+0x43/0x70
>  [<ffffffff81167af6>] remove_dir+0x36/0x40
>  [<ffffffff81167b09>] sysfs_remove_subdir+0x9/0x10
>  [<ffffffff81168ff6>] sysfs_remove_group+0x66/0xf0
>  [<ffffffff81861555>] param_sysfs_init+0x102/0x277
>  [<ffffffff8124a5bd>] ? sysdev_create_file+0xd/0x10
>  [<ffffffff8130fe46>] ? register_cpu+0xa3/0xa5
>  [<ffffffff81861453>] ? param_sysfs_init+0x0/0x277
>  [<ffffffff810001d7>] do_one_initcall+0x37/0x190
>  [<ffffffff8184c6d0>] kernel_init+0x14f/0x1a5
>  [<ffffffff81003bd4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8131417c>] ? restore_args+0x0/0x30
>  [<ffffffff8184c581>] ? kernel_init+0x0/0x1a5
>  [<ffffffff81003bd0>] ? kernel_thread_helper+0x0/0x10
> 
> This dump does not occur with standard 2.6.33-rc7. As the above turns off the
> locking correctness validator, I cannot really test to see what happens when
> suspending.
> 

Ouch! I forgot to add the annotations to sysfs dirs...

Thanks much for the report, I will send an updated version soon!

