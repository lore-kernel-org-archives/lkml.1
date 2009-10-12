Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZJLFxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZJLFxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZJLFxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:53:44 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:50395 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZJLFxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:53:43 -0400
Message-ID: <4AD2C43D.1080804@linux.vnet.ibm.com>
Date: Mon, 12 Oct 2009 07:53:01 +0200
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: make VM_MAX_READAHEAD configurable
References: <1255087175-21200-1-git-send-email-ehrhardt@linux.vnet.ibm.com> <1255090830.8802.60.camel@laptop> <20091009122952.GI9228@kernel.dk> <20091009154950.43f01784@mschwide.boeblingen.de.ibm.com> <20091011011006.GA20205@localhost>
In-Reply-To: <20091011011006.GA20205@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Hi Martin,
>
> On Fri, Oct 09, 2009 at 09:49:50PM +0800, Martin Schwidefsky wrote:
>   
>> On Fri, 9 Oct 2009 14:29:52 +0200
>> Jens Axboe <jens.axboe@oracle.com> wrote:
>>
>>     
>>> On Fri, Oct 09 2009, Peter Zijlstra wrote:
>>>       
>>>> On Fri, 2009-10-09 at 13:19 +0200, Ehrhardt Christian wrote:
>>>>         
>>>>> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
>>>>>
>>>>> On one hand the define VM_MAX_READAHEAD in include/linux/mm.h is just a default
>>>>> and can be configured per block device queue.
>>>>> On the other hand a lot of admins do not use it, therefore it is reasonable to
>>>>> set a wise default.
>>>>>
>>>>> This path allows to configure the value via Kconfig mechanisms and therefore
>>>>> allow the assignment of different defaults dependent on other Kconfig symbols.
>>>>>
>>>>> Using this, the patch increases the default max readahead for s390 improving
>>>>> sequential throughput in a lot of scenarios with almost no drawbacks (only
>>>>> theoretical workloads with a lot concurrent sequential read patterns on a very
>>>>> low memory system suffer due to page cache trashing as expected).
>>>>>           
> [snip]
>   
>> The patch from Christian fixes a performance regression in the latest
>> distributions for s390. So we would opt for a larger value, 512KB seems
>> to be a good one. I have no idea what that will do to the embedded
>> space which is why Christian choose to make it configurable. Clearly
>> the better solution would be some sort of system control that can be
>> modified at runtime. 
>>     
>
> May I ask for more details about your performance regression and why
> it is related to readahead size? (we didn't change VM_MAX_READAHEAD..)
>   
Sure, the performance regression appeared when comparing Novell SLES10 
vs. SLES11.
While you are right Wu that the upstream default never changed so far, 
SLES10 had a
patch applied that set 512.

As mentioned before I didn't expect to get a generic 128->512 patch 
accepted,therefore
the configurable solution. But after Peter and Jens replied so quickly 
stating that
changing the default in kernel would be the wrong way to go I already 
looked out for
userspace alternatives. At least for my issues I could fix it with 
device specific udev rules
too.

And as Andrew mentioned the diversity of devices cause any default to be 
wrong for one
or another installation. To solve that the udev approach can also differ 
between different
device types (might be easier on s390 than on other architectures 
because I need to take
care of two disk types atm - and both shold get 512).

The testcase for anyone who wants to experiment with it is almost too 
easy, the biggest
impact can be seen with single thread iozone - I get ~40% better 
throughput when
increasing the readahead size to 512 (even bigger RA sizes don't help 
much in my
environment, probably due to fast devices).

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, Open Virtualization 

