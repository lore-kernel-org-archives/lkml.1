Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZGGIQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZGGIQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZGGIQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:16:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40323 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbZGGIQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:16:09 -0400
Date: Tue, 7 Jul 2009 10:16:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Ma, Chinang" <chinang.ma@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Eric.Moore@lsi.com" <Eric.Moore@lsi.com>,
       "DL-MPTFusionLinux@lsi.com" <DL-MPTFusionLinux@lsi.com>
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090707081608.GA10187@basil.fritz.box>
References: <20090703025607.GK5480@parisc-linux.org> <87skhdaaub.fsf@basil.nowhere.org> <BC02C49EEB98354DBA7F5DD76F2A9E800357E120E6@azsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BC02C49EEB98354DBA7F5DD76F2A9E800357E120E6@azsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 02:16:38PM -0700, Ma, Chinang wrote:
> >
> >> 0.8246 kmem_cache_free             0.8801 kmem_cache_free
> >> 0.7108 schedule                    0.7774 __blockdev_direct_IO
> >> 0.6733 scsi_request_fn             0.7031 scsi_request_fn
> >> 0.6114 kmem_cache_alloc            0.5317 __schedule
> >> 0.4207 follow_hugetlb_page         0.3922 task_rq_lock
> >> 0.4062 list_del                    0.3629 sd_prep_fn
> >> 0.3400 __switch_to                 0.3504 list_del
> >
> >A callgraph for the list_del/list_dels would be interesting.
> >Presumably that's cache misses, maybe we can do something
> >here with some strategic prefetches or more batching.
> >
> >> 0.3339 generic_make_request        0.3382 __sigsetjmp
> >
> >__sigsetjmp is in glibc, isn't it?
> 
> Yes, __sigsetjmp from glibc

Strange that it takes that much CPU time.

> 
> >
> >> 0.3204 memmove                     0.3270 __switch_to
> >> 0.3088 __sigsetjmp                 0.3257 generic_make_request
> >> 0.2848 get_request                 0.3116 kfree
> >> 0.2804 lock_timer_base             0.2895 memmove
> >
> >memmove? Is that glibc or the kernel? (it would be good if that
> >was marked in the listing)
> 
> Memmove is from glibc. I will filter out all user space libraries in the future report 

it would be good to find out why __errno_location is that costly.
in theory it should be only
	
	mov %fs:xxxx,%rax
	ret

> >A callgraph for it would be useful if it's kernel.
> >
> >> 0.2572 __end_that_request_first    0.2402 aio_complete
> >> 0.2567 fget_light                  0.2382 mptscsih_qcmd
> >> 0.2531 submit_page_section         0.2342 fget
> >> 0.2428 mempool_alloc               0.2277 gup_huge_pmd
> >> 0.2428 __generic_file_aio_read     0.2264 submit_page_section
> >> 0.2368 touch_atime                 0.2204 touch_atime
> >
> >Did you not run with noatime? If it runs with noatime and touch_atime
> >still takes that many cycles something must be wrong.
> >
> 
> Did not try noatime option yet. Will try it next time.

noatime would only help with the patch from the previous message.
Otherwise it'll still take the lock all the time.

Also 2.6.30 defaults to "relatime" which should be often
equivalent to noatime. But still the patch might help.
> 
> Will try collect this data.

It's probably not needed for now; if you can get callgraphs.
The memmove part would have been only interesting if the hot memmove
was in kernel. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
