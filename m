Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbZKXL4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbZKXL4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbZKXL4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:56:53 -0500
Received: from smtp.nokia.com ([192.100.122.230]:25007 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbZKXL4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:56:52 -0500
Message-ID: <4B0BC9E3.6070504@nokia.com>
Date: Tue, 24 Nov 2009 13:56:19 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: ext KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 4/7] nandsim: Don't use PF_MEMALLOC
References: <1258988417.18407.44.camel@localhost> <4B0AEA33.3010306@nokia.com> <20091124194532.AFC2.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091124194532.AFC2.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2009 11:56:20.0505 (UTC) FILETIME=[231C1890:01CA6CFD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext KOSAKI Motohiro wrote:
> Hi
> 
> Thank you for this useful comments.
> 
>>> I vaguely remember Adrian (CCed) did this on purpose. This is for the
>>> case when nandsim emulates NAND flash on top of a file. So there are 2
>>> file-systems involved: one sits on top of nandsim (e.g. UBIFS) and the
>>> other owns the file which nandsim uses (e.g., ext3).
>>>
>>> And I really cannot remember off the top of my head why he needed
>>> PF_MEMALLOC, but I think Adrian wanted to prevent the direct reclaim
>>> path to re-enter, say UBIFS, and cause deadlock. But I'd thing that all
>>> the allocations in vfs_read()/vfs_write() should be GFP_NOFS, so that
>>> should not be a probelm?
>>>
>> Yes it needs PF_MEMALLOC to prevent deadlock because there can be a
>> file system on top of nandsim which, in this case, is on top of another
>> file system.
>>
>> I do not see how mempools will help here.
>>
>> Please offer an alternative solution.
> 
> I have few questions.
> 
> Can you please explain more detail? Another stackable filesystam
> (e.g. ecryptfs) don't have such problem. Why nandsim have its issue?
> What lock cause deadlock?
> 
> 
> 

The file systems are not stacked.  One is over nandsim, which nandsim
does not know about because it is just a lowly NAND device, and, with
the file cache option, one file system below to provide the file cache.

The deadlock is the kernel writing out dirty pages to the top file system
which writes to nandsim which writes to the bottom file system which
allocates memory which causes dirty pages to be written out to the top
file system, which tries to write to nandsim => deadlock.


