Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZBPDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZBPDu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 22:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbZBPDuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 22:50:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65185 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbZBPDuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 22:50:18 -0500
Message-ID: <4998E276.9010009@cn.fujitsu.com>
Date: Mon, 16 Feb 2009 11:50:14 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>
Subject: Re: [Bug #12419] possible circular locking dependency on i915 dma
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.avG.Xt0lJB@chimera>
In-Reply-To: <rjPbZ5GRJPO.A.avG.Xt0lJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki said the following on 2009-2-15 4:38:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12419
> Subject		: possible circular locking dependency on i915 dma
> Submitter	: Wang Chen <wangchen@cn.fujitsu.com>
> Date		: 2009-01-08 14:11 (38 days old)
> References	: http://marc.info/?l=linux-kernel&m=123142399720125&w=4
> 
> 

Yes. It's still there in mainline.
I think the commit 546b0974c39657017407c86fe79811100b60700d
"i915: Use struct_mutex to protect ring in GEM mode." brought this regression.

The lockdep problem is as following:
thread-1
i915_cmdbuffer()
      |
      ---> lock(drm_device->struct_mutex)
                   |
		   V
	i915_dispatch_cmdbuffer()
		   |
		   ---->i915_emit_box()
                             |
                             ----->copy_from_user()
					|
					-----might_fault()
						|
						--->lock(mm->mmap_sem)

thread-2
dup_mm()
   |
   --->lock(mm->mmap_sem)
           |
	   V
	drm_vm_open()
	   |
	   -------> lock(drm_device->struct_mutex)

The different order to lock "mmap_sem" and "drm_dev->struct_mutex" introduces the problem.
But it seems no way to reverse the lock order in i915.
So how about refine the lock granularity of drm_dev->struct_mutex and exclude the mmap_sem
lock/unlock out of the drm_dev->struct_mutex lock/unlock range?

