Return-Path: <linux-kernel-owner+w=401wt.eu-S1752309AbZFYVzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbZFYVzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZFYVzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:55:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:36727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZFYVzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:55:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,292,1243839600"; 
   d="scan'208";a="158616638"
Date: Thu, 25 Jun 2009 14:55:41 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rjw@sisk.pl" <rjw@sisk.pl>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: possible recursive locking detected at kmem_cache_free
Message-ID: <20090625215541.GB29401@linux-os.sc.intel.com>
References: <20090625185942.GA29401@linux-os.sc.intel.com> <20090625123750.734b7f50.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625123750.734b7f50.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 12:37:50PM -0700, Andrew Morton wrote:
> On Thu, 25 Jun 2009 11:59:42 -0700
> "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
> 
> > 
> > Not sure if this has been reported elsewhere. I started seeing this with git
> > kernel from this morning on a system with RedHat EL5 base installation with
> > ext3 root file system. Attached is the config I am using.
> > 
> > Let me know if you need any more details. This seems to be at every boot. I
> > am trying the bisect right now.
> > 
> 
> Thanks.  Let's cc Pekka.
> 

git bisect result.

Thanks,
Venki

8429db5c6336083594036c30f49401405d536911 is first bad commit
commit 8429db5c6336083594036c30f49401405d536911
Author: Pekka Enberg <penberg@cs.helsinki.fi>
Date:   Fri Jun 12 15:58:59 2009 +0300

    slab: setup cpu caches later on when interrupts are enabled
    
    Fixes the following boot-time warning:
    
      [    0.000000] ------------[ cut here ]------------
      [    0.000000] WARNING: at kernel/smp.c:369 smp_call_function_many+0x56/0x1bc()
      [    0.000000] Hardware name:
      [    0.000000] Modules linked in:
      [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30 #492
      [    0.000000] Call Trace:
      [    0.000000]  [<ffffffff8149e021>] ? _spin_unlock+0x4f/0x5c
      [    0.000000]  [<ffffffff8108f11b>] ? smp_call_function_many+0x56/0x1bc
      [    0.000000]  [<ffffffff81061764>] warn_slowpath_common+0x7c/0xa9
      [    0.000000]  [<ffffffff810617a5>] warn_slowpath_null+0x14/0x16
      [    0.000000]  [<ffffffff8108f11b>] smp_call_function_many+0x56/0x1bc
      [    0.000000]  [<ffffffff810f3e00>] ? do_ccupdate_local+0x0/0x54
      [    0.000000]  [<ffffffff810f3e00>] ? do_ccupdate_local+0x0/0x54
      [    0.000000]  [<ffffffff8108f2be>] smp_call_function+0x3d/0x68
      [    0.000000]  [<ffffffff810f3e00>] ? do_ccupdate_local+0x0/0x54
      [    0.000000]  [<ffffffff81066fd8>] on_each_cpu+0x31/0x7c
      [    0.000000]  [<ffffffff810f64f5>] do_tune_cpucache+0x119/0x454
      [    0.000000]  [<ffffffff81087080>] ? lockdep_init_map+0x94/0x10b
      [    0.000000]  [<ffffffff818133b0>] ? kmem_cache_init+0x421/0x593
      [    0.000000]  [<ffffffff810f69cf>] enable_cpucache+0x68/0xad
      [    0.000000]  [<ffffffff818133c3>] kmem_cache_init+0x434/0x593
      [    0.000000]  [<ffffffff8180987c>] ? mem_init+0x156/0x161
      [    0.000000]  [<ffffffff817f8aae>] start_kernel+0x1cc/0x3b9
      [    0.000000]  [<ffffffff817f829a>] x86_64_start_reservations+0xaa/0xae
      [    0.000000]  [<ffffffff817f837f>] x86_64_start_kernel+0xe1/0xe8
      [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
    
    Cc: Christoph Lameter <cl@linux-foundation.org>
    Cc: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

:040000 040000 4575f193f5b94a4c1110cdef769a47fd41ae1f69 54d87f956098163232fce87a59bdc90a42de14bf M      mm


$ git bisect log
git bisect start
# good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
git bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
# bad: [28d0325ce6e0a52f53d8af687e6427fee59004d3] Linux 2.6.31-rc1
git bisect bad 28d0325ce6e0a52f53d8af687e6427fee59004d3
# bad: [e7c5a4f292e0d1f4ba9a3a94b2c8e8b71e35b25a] powerpc/5121: make clock debug output more readable
git bisect bad e7c5a4f292e0d1f4ba9a3a94b2c8e8b71e35b25a
# good: [8a1ca8cedd108c8e76a6ab34079d0bbb4f244799] Merge branch 'perfcounters-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 8a1ca8cedd108c8e76a6ab34079d0bbb4f244799
# bad: [6b702462cbe5b6f372966a53f4465d745d86b65c] Merge branch 'drm-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git bisect bad 6b702462cbe5b6f372966a53f4465d745d86b65c
# bad: [6d21491838a2a9f22843c7530b118596ee9f4d77] Merge branch 'topic/slab/earlyboot-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6
git bisect bad 6d21491838a2a9f22843c7530b118596ee9f4d77
# good: [c34752bc8b3196aee3115d1aa41972604ab0aea8] Merge branch 'cuse' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse
git bisect good c34752bc8b3196aee3115d1aa41972604ab0aea8
# good: [ca9e9c3eb118d0cb9dc2e5232f6f2dcaa4b7a5e0] [SCSI] qla2xxx: Check status of qla2x00_get_fw_version() call.
git bisect good ca9e9c3eb118d0cb9dc2e5232f6f2dcaa4b7a5e0
# good: [c59a264c9e932c828d533497e286b89e43c8d1be] Merge git://git.infradead.org/~dwmw2/firmware-2.6
git bisect good c59a264c9e932c828d533497e286b89e43c8d1be
# good: [e7deff3374cc5951f914dcb3c66bc1b8de8a084e] [SCSI] mpt fusion: Adding DeviceResetCtx for internal Device reset frame
git bisect good e7deff3374cc5951f914dcb3c66bc1b8de8a084e
# good: [0e35afbc8b054e04a35faa796c72abb3b82bd33b] [SCSI] libosd: osd_req_{read,write}_kern new API
git bisect good 0e35afbc8b054e04a35faa796c72abb3b82bd33b
# good: [82681a318f9f028ea64e61f24bbd9ac535531921] [SCSI] Merge branch 'linus'
git bisect good 82681a318f9f028ea64e61f24bbd9ac535531921
# good: [eb91f1d0a531289e18f5587dc197d12a251c66a3] slab: fix gfp flag in setup_cpu_cache()
git bisect good eb91f1d0a531289e18f5587dc197d12a251c66a3
# bad: [8429db5c6336083594036c30f49401405d536911] slab: setup cpu caches later on when interrupts are enabled
git bisect bad 8429db5c6336083594036c30f49401405d536911
# good: [7e85ee0c1d15ca5f8bff0f514f158eba1742dd87] slab,slub: don't enable interrupts during early boot
git bisect good 7e85ee0c1d15ca5f8bff0f514f158eba1742dd87

