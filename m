Return-Path: <linux-kernel-owner+w=401wt.eu-S1750839AbXISRHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839AbXISRHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXISRGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:06:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:8796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbXISRGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:06:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,274,1186383600"; 
   d="scan'208";a="313979935"
Date: Wed, 19 Sep 2007 10:06:44 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Mike Galbraith <efault@gmx.de>
cc: Tong Li <tong.n.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git] CFS-devel, group scheduler, fixes
In-Reply-To: <1190191368.8687.5.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
  <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com> 
 <1190183324.9737.7.camel@Homer.simpson.net>  <1190188261.9185.21.camel@Homer.simpson.net>
 <1190191368.8687.5.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Mike Galbraith wrote:

> On Wed, 2007-09-19 at 09:51 +0200, Mike Galbraith wrote:
>
>> The scenario which was previously cured was this:
>> taskset -c 1 nice -n 0 ./massive_intr 2 9999
>> taskset -c 1 nice -n 5 ./massive_intr 2 9999
>> click link
>> (http://pages.cs.wisc.edu/~shubu/talks/cachescrub-prdc2004.ppt) to bring
>> up browser and OpenOffice Impress.
>>
>> Xorg (at nice -5 + above scenario) latency samples:
>> se.wait_max              :            57985337
>> se.wait_max              :            25163510
>> se.wait_max              :            37005538
>> se.wait_max              :            66986511
>> se.wait_max              :            53990868
>> se.wait_max              :            80976761
>> se.wait_max              :            96967501
>> se.wait_max              :            80989254
>> se.wait_max              :            53990897
>> se.wait_max              :           181963905
>> se.wait_max              :            85985181
>
> To be doubly sure of the effect on the pinned tasks + migrating Xorg
> scenario, I just ran the above test 10 times with virgin devel source.
> Maximum Xorg latency was 20ms.
>
> 	-Mike
>

Yeah, the patch was a first attempt at getting better global fairness for 
unpinned tasks. I expected there'd be latency problems when unpinned and 
pinned tasks co-exist. The original code for vruntime adjustment in 
set_task_cpu() helped alleviate this problem, so removing it in my patch 
would definitely bring the problem back. On the other hand, leaving it 
there broke global fairness in my fairness benchmark. So we'd need a 
better compromise.

Were the experiments run on a 2-CPU system? When Xorg experiences large 
wait time, is it on the same CPU that has the two pinned tasks? If this is 
the case, then the problem could be X somehow advanced faster and got a 
larger vruntime then the two pinned tasks, so it had to wait for the 
pinned ones to catch up before it got a chance to be scheduled.

   tong
