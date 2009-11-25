Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbZKYHNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbZKYHNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZKYHNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:13:53 -0500
Received: from smtp.nokia.com ([192.100.122.233]:54052 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZKYHNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:13:52 -0500
Message-ID: <4B0CD912.7090002@nokia.com>
Date: Wed, 25 Nov 2009 09:13:22 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 4/7] nandsim: Don't use PF_MEMALLOC
References: <20091124194532.AFC2.A69D9226@jp.fujitsu.com> <4B0BC9E3.6070504@nokia.com> <20091125084630.AFC5.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091125084630.AFC5.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Nov 2009 07:13:22.0700 (UTC) FILETIME=[C5F664C0:01CA6D9E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> KOSAKI Motohiro wrote:
>>> Hi
>>>
>>> Thank you for this useful comments.
>>>
>>>>> I vaguely remember Adrian (CCed) did this on purpose. This is for the
>>>>> case when nandsim emulates NAND flash on top of a file. So there are 2
>>>>> file-systems involved: one sits on top of nandsim (e.g. UBIFS) and the
>>>>> other owns the file which nandsim uses (e.g., ext3).
>>>>>
>>>>> And I really cannot remember off the top of my head why he needed
>>>>> PF_MEMALLOC, but I think Adrian wanted to prevent the direct reclaim
>>>>> path to re-enter, say UBIFS, and cause deadlock. But I'd thing that all
>>>>> the allocations in vfs_read()/vfs_write() should be GFP_NOFS, so that
>>>>> should not be a probelm?
>>>>>
>>>> Yes it needs PF_MEMALLOC to prevent deadlock because there can be a
>>>> file system on top of nandsim which, in this case, is on top of another
>>>> file system.
>>>>
>>>> I do not see how mempools will help here.
>>>>
>>>> Please offer an alternative solution.
>>> I have few questions.
>>>
>>> Can you please explain more detail? Another stackable filesystam
>>> (e.g. ecryptfs) don't have such problem. Why nandsim have its issue?
>>> What lock cause deadlock?
>> The file systems are not stacked.  One is over nandsim, which nandsim
>> does not know about because it is just a lowly NAND device, and, with
>> the file cache option, one file system below to provide the file cache.
>>
>> The deadlock is the kernel writing out dirty pages to the top file system
>> which writes to nandsim which writes to the bottom file system which
>> allocates memory which causes dirty pages to be written out to the top
>> file system, which tries to write to nandsim => deadlock.
> 
> You mean you want to prevent pageout() instead reclaim itself?

Yes

> Dropping filecache seems don't make recursive call, right?

Yes

