Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYCNDdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYCNDdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 23:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYCNDdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 23:33:43 -0400
Received: from mga05.intel.com ([192.55.52.89]:22139 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751631AbYCNDdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 23:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,498,1199692800"; 
   d="scan'208";a="533697129"
Subject: Re: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1205463842.3215.188.camel@ymzhang>
References: <1205394417.3215.85.camel@ymzhang>
	 <20080313014808.f8d25c2a.akpm@linux-foundation.org>
	 <1205400538.3215.148.camel@ymzhang>
	 <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
	 <1205463842.3215.188.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Mar 2008 11:30:47 +0800
Message-Id: <1205465447.3215.195.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 11:04 +0800, Zhang, Yanmin wrote:
> On Thu, 2008-03-13 at 17:16 -0700, Christoph Lameter wrote:
> > Could you recompile the kernel with slub performance statistics and post 
> > the output of
> > 
> > slabinfo -AD
> Before testing with kernel 2.6.25-rc5:
> Name                   Objects    Alloc     Free   %Fast
> vm_area_struct            2795   135185   132587  93  29
> :0004096                    25   119045   119043  99  98
> :0000064                 12257   119671   107742  98  50
> :0000192                  3312    78563    75370  92  21
> :0000128                  4648    48143    43738  97  53
> dentry                   15217    46675    31527  95  72
> :0000080                 12784    33674    21206  99  97
> :0000016                  4367    25871    23705  99  78
> :0000096                  3001    22591    20084  99  92
> buffer_head               5536    18147    12884  97  42
> anon_vma                  1729    14948    14130  99  73
> 
> 
> After testing:
> Name                   Objects    Alloc     Free   %Fast
> :0000192                  3428 80093958 80090708  92   8
> :0000512                   374 80016030 80015715  68   7
> vm_area_struct            2875   224524   221868  94  20
> :0000064                 12408   134273   122227  98  47
> :0004096                    24   127397   127395  99  98
> :0000128                  4596    57837    53432  97  48
> dentry                   15659    51402    35824  95  64
> :0000016                  4584    29327    27161  99  76
> :0000080                 12784    33674    21206  99  97
> :0000096                  2998    26264    23757  99  93
> 
> 
> So block 192 and 512's and very active and their fast free percentage is low.
On my 8-core stoakley, there is no such regression. Below data is after testing.

[root@lkp-st02-x8664 ~]# slabinfo -AD
Name                   Objects    Alloc     Free   %Fast
:0000192                  3170 80055388 80052280  92   1 
:0000512                   316 80012750 80012466  69   1 
vm_area_struct            2642   194700   192193  94  16 
:0000064                  3846    74468    70820  97  53 
:0004096                    15    69014    69012  98  97 
:0000128                  1447    32920    31541  91   8 
dentry                   13485    33060    19652  92  42 
:0000080                 10639    23377    12953  98  98 
:0000096                  1662    16496    15036  99  94 
:0000832                   232    14422    14203  85  10 
:0000016                  2733    15102    13372  99  14 

So the block 192 and 512's fast free percentage is even smaller than the ones on tigerton.

Oprofile data on stoakley:

CPU: Core 2, speed 2660 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 100000
samples  %        app name                 symbol name
2897265  25.7603  linux-2.6.25-rc5         __slab_alloc
2689900  23.9166  linux-2.6.25-rc5         add_partial
629355    5.5957  linux-2.6.25-rc5         copy_user_generic_string
552309    4.9107  linux-2.6.25-rc5         __slab_free
514792    4.5771  linux-2.6.25-rc5         sock_alloc_send_skb
500879    4.4534  linux-2.6.25-rc5         unix_stream_recvmsg
274798    2.4433  linux-2.6.25-rc5         __kmalloc_track_caller
230283    2.0475  linux-2.6.25-rc5         kfree
222286    1.9764  linux-2.6.25-rc5         unix_stream_sendmsg
217413    1.9331  linux-2.6.25-rc5         memset_c
211589    1.8813  linux-2.6.25-rc5         kmem_cache_alloc
151500    1.3470  linux-2.6.25-rc5         system_call
132262    1.1760  linux-2.6.25-rc5         sock_def_readable
123130    1.0948  linux-2.6.25-rc5         kmem_cache_free
109518    0.9738  linux-2.6.25-rc5         sock_wfree


yanmin


