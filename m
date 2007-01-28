Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbXA1PbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbXA1PbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXA1PbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:31:17 -0500
Received: from main.gmane.org ([80.91.229.2]:41624 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbXA1PbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:31:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: O_DIRECT question
Date: Sun, 28 Jan 2007 10:30:02 -0500
Message-ID: <45BCC17A.9090302@tmr.com>
References: <7BYkO-5OV-17@gated-at.bofh.it> <7HIPV-8kp-35@gated-at.bofh.it> <E1HAo72-0000kF-Vz@be1.lrz> <200701271514.31203.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: 7eggert@gmx.de, Michael Tokarev <mjt@tls.msk.ru>,
       Phillip Susi <psusi@cfl.rr.com>, Linus Torvalds <torvalds@osdl.org>,
       Viktor <vvp01@inbox.ru>, Aubrey <aubreylee@gmail.com>,
       Hua Zhong <hzhong@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org, hch@infradead.org, kenneth.w.chen@in
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <200701271514.31203.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko wrote:
> On Saturday 27 January 2007 15:01, Bodo Eggert wrote:
>> Denis Vlasenko <vda.linux@googlemail.com> wrote:
>>> On Friday 26 January 2007 19:23, Bill Davidsen wrote:
>>>> Denis Vlasenko wrote:
>>>>> On Thursday 25 January 2007 21:45, Michael Tokarev wrote:
>>>>>> But even single-threaded I/O but in large quantities benefits from
>>>>>> O_DIRECT significantly, and I pointed this out before.
>>>>> Which shouldn't be true. There is no fundamental reason why
>>>>> ordinary writes should be slower than O_DIRECT.
>>>>>
>>>> Other than the copy to buffer taking CPU and memory resources.
>>> It is not required by any standard that I know. Kernel can be smarter
>>> and avoid that if it can.
>> The kernel can also solve the halting problem if it can.
>>
>> Do you really think an entropy estamination code on all access patterns in the
>> system will be free as in beer,
> 
> Actually I think we need this heuristic:
> 
> if (opened_with_O_STREAM && buffer_is_aligned
> 		&& io_size_is_a_multiple_of_sectorsize)
> 	do_IO_directly_to_user_buffer_without_memcpy
> 
> is not *that* compilcated.
> 
> I think that we can get rid of O_DIRECT peculiar requirements
> "you *must* not cache me" + "you *must* write me directly to bare metal"
> by replacing it with O_STREAM ("*advice* to not cache me") + O_SYNC
> ("write() should return only when data is written to storage, not sooner").
> 
> Why?
> 
> Because these O_DIRECT "musts" are rather unusual and overkill. Apps
> should not have that much control over what kernel does internally;
> and also O_DIRECT was mixing shampoo and conditioner on one bottle
> (no-cache and sync writes) - bad API.

What a shame that other operating systems can manage to really support 
O_DIRECT, and that major application software can use this api to write 
portable code that works even on Windows.

You overlooked the problem that applications using this api assume that 
reads are on bare metal as well, how do you address the case where 
thread A does a write, thread B does a read? If you give thread B data 
from a buffer and it then does a write to another file (which completes 
before the write from thread A), and then the system crashes, you have 
just put the files out of sync. So you may have to block all i/o for all 
threads of the application to be sure that doesn't happen. Or introduce 
some complex way to assure that all writes are physically done in 
order... that sounds like a lock infested mess to me, assuming that you 
could ever do it right.

Oracle has their own version of Linux now, do you think that they would 
fork the application or the kernel?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

