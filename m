Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYKKBMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYKKBMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYKKBMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:12:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58555 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbYKKBMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:12:08 -0500
Message-ID: <4918DB8E.2020004@redhat.com>
Date: Mon, 10 Nov 2008 20:10:38 -0500
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
References: <490F468B.4040602@redhat.com>	 <1225762877.27266.22.camel@yhuang-dev.sh.intel.com>	 <20081110163135.616E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1226365518.6081.90.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1226365518.6081.90.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Mon, 2008-11-10 at 15:35 +0800, KOSAKI Motohiro wrote:
>>>>> As far as I know, barriers don't cause changes to be visible on other
>>>>> CPUs faster too. It just guarantees corresponding operations after will
>>>>> not get executed until that before have finished. And, I don't think we
>>>>> need make changes to be visible on other CPUs faster.
>>>> You're correct that barrier() has no impact on other CPUs.  wmb() and rmb() do. 
>>>>   If we don't need to make changes visible any faster, what's the point in using 
>>>> atomic_set()?  It's not any less racy.  atomic_inc() and atomic_dec() would be 
>>>> less racy, but you're not using those.
>>> In default bust_spinlocks() implementation in lib/bust_spinlocks.c,
>>> atomic_inc() and atomic_dec_and_test() is used. Which is used by x86
>>> too. In some other architecture, atomic_set() is used to replace
>>> "oops_in_progress = <xxx>". So this patch fixes architectures which use
>>> default bust_spinlocks(), other architectures can be fixed by
>>> corresponding architecture developers.
>> I think Chris is right.
>> So, I reccomend to read Documentation/memory-barriers.txt
>>
>> Almost architecture gurantee atomic_inc cause barrier implicitly.
>> but not _all_ architecture.
> 
> Yes. atomic_inc() doesn't imply barrier on all architecture. But we
> should not add barriers before all atomic_inc(), just ones needed. Can
> you figure out which ones in the patch should has barrier added?

You need barriers *after* writes, and *before* reads.  Adding barriers to the 
oops path should be extremely cheap for performance, unless oopsing is a common 
occurrence, in which case we have bigger problems.

-- Chris
