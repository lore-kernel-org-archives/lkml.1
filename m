Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYCCSiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYCCSiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYCCSiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:38:00 -0500
Received: from mga06.intel.com ([134.134.136.21]:48406 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120AbYCCSh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:37:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,439,1199692800"; 
   d="scan'208";a="260621406"
Message-ID: <47CC451A.2060501@linux.intel.com>
Date: Mon, 03 Mar 2008 10:36:10 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: torvalds@linux-foundation.org, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu>
In-Reply-To: <20080303174009.GA19131@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>> ------------[ cut here ]------------
>> WARNING: at arch/x86/mm/pgtable_32.c:387 pmd_bad+0x44/0x53()
>> Modules linked in:
>> Pid: 1, comm: swapper Not tainted 2.6.25-rc3 #14
>>  [<c0424ba5>] warn_on_slowpath+0x41/0x67
>>  [<c0408c5c>] ? native_sched_clock+0x94/0xa6
>>  [<c043f432>] ? lock_release_holdtime+0x1a/0x115
>>  [<c04702d4>] ? handle_mm_fault+0x297/0x7e2
>>  [<c063eee6>] ? _spin_unlock+0x1d/0x20
>>  [<c04707f0>] ? handle_mm_fault+0x7b3/0x7e2
>>  [<c04851c1>] ? do_sync_read+0xab/0xe9
>>  [<c0417223>] pmd_bad+0x44/0x53
>>  [<c046f37f>] follow_page+0x8b/0x1f2
>>  [<c0470aa0>] get_user_pages+0x281/0x2ef
> 
> hm. I suspect some gcc related difference related to the handling of 
> this masking:
> 
>    pmd_val(x) & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)
> 
> versus:
> 
>    pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)
> 
> perhaps it will work if you change it to:
> 
>    pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER & ~_PAGE_PSE & ~_PAGE_NX)
> 
> ?
> 
> in any case, the commit has to be reverted as it clearly isnt a NOP on 
> your box as it was intended to be. (it should only have made a 
> difference in a rare hugetlbfs case)

interesting observation: if I turn the macros into inlines... the difference goes away.

I'm half tempted to just do it as inline period ... any objections ?
